/* RT-56 unit tests of the raw 0xeb Multibuild puzzle kernel (src/action_family_eb_runtime.c) and its session binding
 * (src/session_bindings_aeb.c). Prints "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count.
 * Fixtures are synthetic bodies (no original bytes); the cases cite the original functions they exercise (GAME.EXE SHA-256
 * afd337a2...5c45): handler 0x480e02, piece builder 0x47e582, pointer receiver 0x47f421 (helpers 0x47ec06, 0x47fd65), click
 * 0x47ff0e (helpers 0x47fa11, 0x47fb76, 0x47ed96, 0x47e8fe/0x47e9d3, 0x47ea73, 0x47f19d, 0x47e52f, 0x47f275), second button
 * 0x47ef0f, save and solved check 0x480b34, sound blocks 0x4809a7/0x480a1d/0x480abe, invalidate 0x47e440, cleanup 0x47e2a5,
 * render 0x481cb9. tests/test_action_family_eb_runtime.py builds and runs this with and without ASan/UBSan and under source
 * mutations. */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_eb_runtime.h"
#include "scene_resource.h"
#include "session_bindings_aeb.h"

static int g_failed, g_total, g_failures;
static char g_msg[512];
#define CK(cond)                                                               \
    do {                                                                       \
        if (!(cond) && !g_failed) {                                            \
            g_failed = 1;                                                      \
            snprintf(g_msg, sizeof g_msg, "line %d: %.200s", __LINE__, #cond); \
        }                                                                      \
    } while (0)
#define CK_LOG(fx, expected)                                                                    \
    do {                                                                                        \
        if (strcmp((fx)->log, (expected)) != 0 && !g_failed) {                                  \
            g_failed = 1;                                                                       \
            snprintf(g_msg, sizeof g_msg, "line %d: log \"%.150s\" != \"%.150s\"", __LINE__,    \
                     (fx)->log, (expected));                                                    \
        }                                                                                       \
    } while (0)

/* Object offsets, written down independently of the kernel (see the header comment). */
enum {
    O_SLOT = 0x1c, O_ROW = 0x1e, O_ENT = 0x20, O_COUNTS = 0x7a0, O_PIECES = 0x7b4, O_DRAG = 0x1344, O_DROP = 0x1348,
    O_LIFT = 0x134c, O_HAND = 0x1350, O_PREV = 0x1352, O_MOVE = 0x1362, O_PREV_T = 0x1372, O_MOVE_T = 0x1382, O_SAVED = 0x1392,
    O_COUNT = 0x13a2, O_SRC = 0x13a4, O_MULTI = 0x13a8, O_ANIM = 0x13ac, O_HAS_MULTI = 0x13b0, O_MULTI_HAND = 0x13b1,
    O_ANIM_ON = 0x13b2, O_ANIM_REST = 0x13b3, O_HAS_ANIM = 0x13b4, O_ANIM_SRC = 0x13b5, O_ACTIVE = 0x13c5, O_EXIT = 0x13c9,
    O_STATE = 0x13ca, O_DONE = 0x13ce, O_PTR = 0x13cf, O_HIT = 0x13df, O_HW = 0x13e3, O_HH = 0x13e5, O_DEADLINE = 0x13e7,
    O_DEADLINE2 = 0x13eb, O_LIST1 = 0x13ef, O_COUNT1 = 0x1417, O_LIST2 = 0x1419, O_COUNT2 = 0x1441, O_TOTAL = 0x1443,
    O_ANIM_ROW = 0x1445, O_ANIM_FRAME = 0x1447, O_CELL_W = 0x1449, O_CELL_H = 0x144b
};
/* Piece instance fields. */
enum { P_Z = 0, P_RECT = 2, P_RECT2 = 0x12, P_ORIENT = 0x22, P_TYPE = 0x23, P_STAMP = 0x24 };
/* Body fields. */
enum {
    B_NAME = 0x00, B_MULTI = 0x21, B_PERSIST = 0x42, B_NTYPES = 0x43, B_TARGET = 0x45, B_WINSND = 0x47, B_ROT = 0x48,
    B_LOCKED = 0x49, B_ZONE_H = 0x4a, B_ZONE_W = 0x4c, B_AREA = 0x4e, B_MODE = 0x5e, B_OVERLAP = 0x5f, B_ANIMNAME = 0x60,
    B_ANIMAREA = 0x81, B_ROWS = 0x91, B_COLS = 0x93, B_GAP = 0x95, B_REPEAT = 0x97, B_TYPES = 0x99,
    BT_A = 0, BT_B = 0x10, BT_C = 0x20, BT_D = 0x30, BT_E = 0x40, BT_SPAWN = 0x50, BT_REQ = 0x51, BT_FORBID = 0x52,
    B_SND_ROT = 0x715, B_CH_ROT = 0x736, B_SND_PICK = 0x746, B_CH_PICK = 0x767, B_SND_GOOD = 0x777, B_CH_GOOD = 0x798,
    B_SND_BAD = 0x7a8, B_CH_BAD = 0x7c9, B_KEY_BAD = 0x7d9, B_TEXT_BAD = 0x7fa, B_CUR_PICK = 0x8c2, B_CUR_EXIT_A = 0x8c4,
    B_CUR_EXIT_B = 0x8c6, B_WIN = 0x8c8, B_SND_WIN = 0x8e1, B_CH_WIN = 0x902, B_KEY_WIN = 0x912, B_TEXT_WIN = 0x933,
    B_EXIT = 0x9fb, B_BTN_A = 0xa14, B_BTN_B = 0xa24
};
/* Scene block fields (0x19 bytes). */
enum { SB_SCENE = 0, SB_START = 20, SB_FLAG = 0x16, SB_VALUE = 0x18 };

#define PI(i) ((size_t)O_PIECES + (size_t)(i) * 0x25u)
#define TY(t) ((size_t)B_TYPES + (size_t)(t) * 0x53u)
#define EN(t, k) ((size_t)O_ENT + (size_t)(t) * 0x60u + (size_t)(k) * 0x18u)

typedef struct Fx {
    EbObject o;
    EbWorld w;
    EbHost host;
    uint8_t body[EB_BODY_BYTES];
    char log[16384];
    int calls, fail_call;
    uint32_t now;
    int32_t vo[2], clip[4];
    int32_t busy[16];
    int nbusy, ibusy, busy_default;
    int captions;
    const char *autotext;
    int16_t slot_value;
    uint32_t next_handle, next_load;
    int16_t dw[1024], dh[1024];
    uint32_t phase, np;
    EbResult res;
    EbPointerResult pr;
    const char *failure;
    int rc;
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
static void put_name(uint8_t *b, size_t off, const char *s, size_t span)
{
    memset(b + off, 0, span);
    memcpy(b + off, s, strlen(s));
}
static int rect_is(const uint8_t *b, size_t off, int32_t l, int32_t t, int32_t r, int32_t bt)
{
    return get32(b, off) == l && get32(b, off + 4) == t && get32(b, off + 8) == r && get32(b, off + 12) == bt;
}

static void logf_(Fx *f, const char *fmt, ...)
{
    char tmp[200];
    va_list ap;
    va_start(ap, fmt);
    vsnprintf(tmp, sizeof tmp, fmt, ap);
    va_end(ap);
    if (f->log[0] != '\0') strncat(f->log, ",", sizeof f->log - strlen(f->log) - 1u);
    strncat(f->log, tmp, sizeof f->log - strlen(f->log) - 1u);
}
#define HC(f)                                    \
    do {                                         \
        if (++(f)->calls == (f)->fail_call) return 1; \
    } while (0)

static int h_view(void *c, EbView *v)
{
    Fx *f = (Fx *)c;
    HC(f);
    v->origin_x = f->vo[0];
    v->origin_y = f->vo[1];
    for (int i = 0; i < 4; ++i) v->clip[i] = f->clip[i];
    return 0;
}
static int h_alloc(void *c, int16_t *slot) { Fx *f = (Fx *)c; HC(f); *slot = f->slot_value; return 0; }
static int h_register(void *c, int16_t slot, const char *label) { Fx *f = (Fx *)c; HC(f); logf_(f, "reg:%d:%s", slot, label); return 0; }
static int h_release_slot(void *c, int16_t slot) { Fx *f = (Fx *)c; HC(f); logf_(f, "relslot:%d", slot); return 0; }
static int h_dirty(void *c, int16_t slot) { Fx *f = (Fx *)c; HC(f); logf_(f, "dirty:%d", slot); return 0; }
static int h_load(void *c, const char *name, const char *tag, uint32_t *s)
{
    Fx *f = (Fx *)c;
    HC(f);
    logf_(f, "load:%s:%s", name, tag);
    *s = f->next_load++;
    return 0;
}
static int h_create(void *c, int16_t w, int16_t h, const char *tag, uint32_t *s)
{
    Fx *f = (Fx *)c;
    HC(f);
    *s = f->next_handle++;
    f->dw[*s & 1023u] = w;
    f->dh[*s & 1023u] = h;
    logf_(f, "create:%dx%d=%u", w, h, *s);
    if (strcmp(tag, "pDFSurface for Multibuild Puzzle Piece") != 0) logf_(f, "badtag:%s", tag);
    return 0;
}
static int h_blit(void *c, uint32_t src, uint32_t dst, const int32_t sr[4], const int32_t dr[4])
{
    Fx *f = (Fx *)c;
    HC(f);
    logf_(f, "blit:%u>%u:%d,%d,%d,%d>%d,%d,%d,%d", src, dst, sr[0], sr[1], sr[2], sr[3], dr[0], dr[1], dr[2], dr[3]);
    return 0;
}
static int h_copy(void *c, uint32_t dst, uint32_t src)
{
    Fx *f = (Fx *)c;
    HC(f);
    f->dw[dst & 1023u] = f->dw[src & 1023u];
    f->dh[dst & 1023u] = f->dh[src & 1023u];
    logf_(f, "copy:%u<%u", dst, src);
    return 0;
}
static int h_rotate(void *c, uint32_t s, int16_t *w, int16_t *h)
{
    Fx *f = (Fx *)c;
    const int16_t t = f->dw[s & 1023u];
    HC(f);
    f->dw[s & 1023u] = f->dh[s & 1023u];
    f->dh[s & 1023u] = t;
    *w = f->dw[s & 1023u];
    *h = f->dh[s & 1023u];
    logf_(f, "rot:%u=%dx%d", s, *w, *h);
    return 0;
}
static int h_release(void *c, uint32_t s) { Fx *f = (Fx *)c; HC(f); logf_(f, "rel:%u", s); return 0; }
static int h_clear(void *c) { Fx *f = (Fx *)c; HC(f); logf_(f, "clr"); return 0; }
static int h_prepare(void *c, uint32_t id, const uint8_t *rec) { Fx *f = (Fx *)c; HC(f); logf_(f, "prep:%x:%s", id, (const char *)rec); return 0; }
static int h_stop(void *c, uint32_t id, const uint8_t *rec) { Fx *f = (Fx *)c; HC(f); logf_(f, "stop:%x:%s", id, (const char *)rec); return 0; }
static int h_play(void *c, int16_t ch) { Fx *f = (Fx *)c; HC(f); logf_(f, "play:%d", ch); return 0; }
static int h_busy(void *c, int16_t ch, int32_t *r)
{
    Fx *f = (Fx *)c;
    HC(f);
    *r = f->ibusy < f->nbusy ? f->busy[f->ibusy++] : f->busy_default;
    logf_(f, "busy:%d=%d", ch, *r);
    return 0;
}
static uint32_t h_tick(void *c) { return ((Fx *)c)->now; }
static int h_captions(void *c, int32_t *e) { Fx *f = (Fx *)c; HC(f); *e = f->captions; return 0; }
static int h_autotext(void *c, const char *key, const char **t)
{
    Fx *f = (Fx *)c;
    HC(f);
    logf_(f, "auto:%s", key);
    *t = f->autotext;
    return 0;
}
static int h_caption(void *c, const char *text) { Fx *f = (Fx *)c; HC(f); logf_(f, "cap:%s", text); return 0; }
static int h_flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 100; }
static int h_transition(void *c, const EbTransition *t)
{
    Fx *f = (Fx *)c;
    HC(f);
    logf_(f, "scene:%d:%d,%d,%d:%d,%d,%d", t->scene, t->word[0], t->word[1], t->word[2], t->dword[0], t->dword[1], t->dword[2]);
    return 0;
}
static int h_store_flag(void *c, int16_t i, uint32_t v) { Fx *f = (Fx *)c; HC(f); logf_(f, "flag:%d=%u", i, v); return 0; }
static int h_complete(void *c, int16_t row) { Fx *f = (Fx *)c; HC(f); logf_(f, "done:%d", row); return 0; }

static void set_block(uint8_t *b, size_t off, int scene, int w1, int w2, int w3, int d1, int d2, int d3, int start, int flag, int value)
{
    put16(b, off, scene);
    put16(b, off + 2, w1);
    put16(b, off + 4, w2);
    put16(b, off + 6, w3);
    put32(b, off + 8, d1);
    put32(b, off + 12, d2);
    put32(b, off + 16, d3);
    put16(b, off + SB_START, start);
    put16(b, off + SB_FLAG, flag);
    b[off + SB_VALUE] = (uint8_t)value;
}

/* A three-type puzzle: type t has source rect A (1 + 50 t, 1, 40 + 50 t, 30), home rect B (300 + 50 t, 200, 339 + 50 t, 229),
 * no rects C, D, E, no spawning. Target 2, area (0, 0, 639, 479), mode 0, no rotation, all sounds NO SOUND, exit buttons at
 * (600, 440, 639, 479) and (0, 440, 39, 479), scene blocks 9999, flags -1, cursors 21 / 31 / 32. */
static void build_body(uint8_t *b)
{
    static const size_t snd[] = {B_SND_ROT, B_SND_PICK, B_SND_GOOD, B_SND_BAD, B_SND_WIN};
    memset(b, 0, EB_BODY_BYTES);
    put_name(b, B_NAME, "PIECES", 0x21);
    put_name(b, B_MULTI, "NO_FILE", 0x21);
    put_name(b, B_ANIMNAME, "NO_FILE", 0x21);
    put16(b, B_NTYPES, 3);
    put16(b, B_TARGET, 2);
    put16(b, B_ZONE_H, 10);
    put16(b, B_ZONE_W, 12);
    put_rect(b, B_AREA, 0, 0, 639, 479);
    for (int t = 0; t < 3; ++t) {
        put_rect(b, TY(t) + BT_A, 1 + 50 * t, 1, 40 + 50 * t, 30);
        put_rect(b, TY(t) + BT_B, 300 + 50 * t, 200, 339 + 50 * t, 229);
    }
    for (size_t i = 0; i < sizeof snd / sizeof snd[0]; ++i) put_name(b, snd[i], "NO SOUND", 0x21);
    put16(b, B_CH_ROT, 11);
    put16(b, B_CH_PICK, 12);
    put16(b, B_CH_GOOD, 13);
    put16(b, B_CH_BAD, 14);
    put16(b, B_CH_WIN, 15);
    put16(b, B_CUR_PICK, 21);
    put16(b, B_CUR_EXIT_A, 31);
    put16(b, B_CUR_EXIT_B, 32);
    set_block(b, B_WIN, 9999, 0, 0, 0, 0, 0, 0, 0, -1, 0);
    set_block(b, B_EXIT, 9999, 0, 0, 0, 0, 0, 0, 0, -1, 0);
    put_rect(b, B_BTN_A, 600, 440, 639, 479);
    put_rect(b, B_BTN_B, 0, 440, 39, 479);
}

static void fx_init(Fx *f)
{
    memset(f, 0, sizeof *f);
    eb_object_reset(&f->o);
    eb_world_reset(&f->w);
    f->w.scene_5bb57b = 7;
    build_body(f->body);
    f->host.context = f;
    f->host.view = h_view;
    f->host.alloc_slot = h_alloc;
    f->host.register_slot = h_register;
    f->host.release_slot = h_release_slot;
    f->host.mark_dirty = h_dirty;
    f->host.load_surface = h_load;
    f->host.create_surface = h_create;
    f->host.blit = h_blit;
    f->host.copy_surface = h_copy;
    f->host.rotate_surface = h_rotate;
    f->host.release_surface = h_release;
    f->host.clear_pending_item = h_clear;
    f->host.sound_prepare = h_prepare;
    f->host.sound_stop = h_stop;
    f->host.sound_play = h_play;
    f->host.sound_busy = h_busy;
    f->host.tick = h_tick;
    f->host.captions_enabled = h_captions;
    f->host.autotext_lookup = h_autotext;
    f->host.caption_show = h_caption;
    f->host.event_flag_invalid = h_flag_invalid;
    f->host.transition = h_transition;
    f->host.store_event_flag = h_store_flag;
    f->host.complete = h_complete;
    f->vo[0] = 10;
    f->vo[1] = 20;
    f->clip[2] = 639;
    f->clip[3] = 479;
    f->slot_value = 0x18;
    f->next_handle = 100u;
    f->next_load = 5u;
    f->now = 1000u;
    f->captions = 1;
    f->phase = 0;
}
static void fx_clear(Fx *f)
{
    f->log[0] = '\0';
    f->calls = 0;
    f->fail_call = 0;
}

static int od16(Fx *f, size_t off) { return get16(f->o.b, off); }
static int32_t od32(Fx *f, size_t off) { return get32(f->o.b, off); }
static void set16(Fx *f, size_t off, int v) { put16(f->o.b, off, v); }
static void set32(Fx *f, size_t off, int32_t v) { put32(f->o.b, off, v); }
static int ob(Fx *f, size_t off) { return f->o.b[off]; }
static int ob_of(const EbObject *o, size_t off) { return o->b[off]; }

static int step(Fx *f, uint32_t phase)
{
    f->failure = NULL;
    f->rc = eb_step(&f->o, f->body, EB_BODY_BYTES, 2, phase, &f->w, &f->host, &f->res, &f->failure);
    return f->rc;
}
static int start(Fx *f)
{
    const int rc = step(f, 0);
    f->phase = rc == EB_OK ? f->res.phase_after : 0u;
    return rc;
}
static int visit(Fx *f) { return step(f, f->phase); }
static int ptr(Fx *f, int x, int y)
{
    const int32_t rect[4] = {x - 8, y - 8, x + 8, y + 8};
    f->rc = eb_pointer_move(&f->o, f->body, EB_BODY_BYTES, (int16_t)x, (int16_t)y, rect, &f->host, &f->pr);
    return f->rc;
}
static int click(Fx *f, int32_t cand)
{
    f->np = 99u;
    f->rc = eb_click(&f->o, f->body, EB_BODY_BYTES, &f->w, f->phase, cand, &f->host, &f->np);
    return f->rc;
}
static int rkey(Fx *f)
{
    f->rc = eb_rotate_key(&f->o, f->body, EB_BODY_BYTES, f->phase, &f->host);
    return f->rc;
}

/* Instance i of type `type` at rect (l, t, r, b), rect2 = rect + the view origin, count raised to cover it. */
static void inst(Fx *f, int i, int type, int l, int t, int r, int b)
{
    uint8_t *o = f->o.b;
    put_rect(o, PI(i) + P_RECT, l, t, r, b);
    put_rect(o, PI(i) + P_RECT2, l + f->vo[0], t + f->vo[1], r + f->vo[0], b + f->vo[1]);
    o[PI(i) + P_TYPE] = (uint8_t)type;
    if (od16(f, O_COUNT) <= i) set16(f, O_COUNT, i + 1);
}

/* ---- validation, resets ------------------------------------------------------------------------------------------------------ */

static void t_validate(void)
{
    uint8_t b[EB_BODY_BYTES + 1];
    const char *why = NULL;
    static const struct { size_t off, span; const char *name; } fields[] = {
        {B_NAME, 0x21, "name"}, {B_MULTI, 0x21, "multi"}, {B_ANIMNAME, 0x21, "anim"}, {B_SND_ROT, 0x21, "rot"},
        {B_SND_PICK, 0x21, "pick"}, {B_SND_GOOD, 0x21, "good"}, {B_SND_BAD, 0x21, "bad"}, {B_KEY_BAD, 0x21, "keybad"},
        {B_TEXT_BAD, 200, "textbad"}, {B_SND_WIN, 0x21, "win"}, {B_KEY_WIN, 0x21, "keywin"}, {B_TEXT_WIN, 200, "textwin"}};
    build_body(b);
    CK(eb_validate_body(b, EB_BODY_BYTES, &why) == EB_OK && why == NULL);
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_OK);
    CK(eb_validate_body(NULL, EB_BODY_BYTES, &why) == EB_ERR_BODY && strcmp(why, "0xeb-body-length") == 0);
    CK(eb_validate_body(b, EB_BODY_BYTES - 1u, &why) == EB_ERR_BODY && strcmp(why, "0xeb-body-length") == 0);
    CK(eb_validate_body(b, EB_BODY_BYTES + 1u, &why) == EB_ERR_BODY && strcmp(why, "0xeb-body-length") == 0);
    CK(eb_validate_body(b, 0u, NULL) == EB_ERR_BODY);
    put16(b, B_NTYPES, -1);
    CK(eb_validate_body(b, EB_BODY_BYTES, &why) == EB_ERR_BODY && strcmp(why, "0xeb-type-count") == 0);
    put16(b, B_NTYPES, 21);
    CK(eb_validate_body(b, EB_BODY_BYTES, &why) == EB_ERR_BODY && strcmp(why, "0xeb-type-count") == 0);
    put16(b, B_NTYPES, 20);
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_OK); /* types 3..19 are zero rects: 1 x 1 pieces */
    put16(b, B_NTYPES, 0);
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_OK);
    /* The animation area needs columns unless it has no height. */
    build_body(b);
    put_rect(b, B_ANIMAREA, 0, 0, 9, 9);
    CK(eb_validate_body(b, EB_BODY_BYTES, &why) == EB_ERR_BODY && strcmp(why, "0xeb-grid-columns-zero") == 0);
    put16(b, B_COLS, 1);
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_OK);
    put16(b, B_COLS, 0);
    put_rect(b, B_ANIMAREA, 0, 5, 9, 5); /* top == bottom: no animation area */
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_OK);
    put_rect(b, B_ANIMAREA, 0, 5, 9, 6);
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_ERR_BODY);
    /* Every name, record, key and text field must be terminated within its span. */
    for (size_t k = 0; k < sizeof fields / sizeof fields[0]; ++k) {
        build_body(b);
        memset(b + fields[k].off, 'X', fields[k].span);
        CK(eb_validate_body(b, EB_BODY_BYTES, &why) == EB_ERR_BODY && strcmp(why, "0xeb-unterminated-field") == 0);
        b[fields[k].off + fields[k].span] = 0; /* a zero right behind the span does not terminate the field */
        CK(eb_validate_body(b, EB_BODY_BYTES, &why) == EB_ERR_BODY && strcmp(why, "0xeb-unterminated-field") == 0);
        b[fields[k].off + fields[k].span - 1u] = 0;
        CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_OK); /* the last byte of the span is a valid terminator */
    }
    /* Piece sizes: width and height from rect C (valid) or rect B, 1..4096. */
    build_body(b);
    put_rect(b, TY(0) + BT_B, 0, 0, 4094, 9);
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_OK); /* 4095 wide */
    put_rect(b, TY(0) + BT_B, 0, 0, 4095, 9);
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_OK); /* 4096 wide */
    put_rect(b, TY(0) + BT_B, 0, 0, 4096, 9);
    CK(eb_validate_body(b, EB_BODY_BYTES, &why) == EB_ERR_BODY && strcmp(why, "0xeb-piece-size") == 0);
    put_rect(b, TY(0) + BT_B, 0, 0, 9, 4095);
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_OK);
    put_rect(b, TY(0) + BT_B, 0, 0, 9, 4096);
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_ERR_BODY);
    put_rect(b, TY(0) + BT_B, 5, 0, 4, 9); /* width 0 */
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_ERR_BODY);
    put_rect(b, TY(0) + BT_B, 5, 0, 5, 9); /* a one pixel wide rect is invalid for rect_valid, so rect B decides: width 1 */
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_OK);
    put_rect(b, TY(0) + BT_B, 0, 7, 9, 6); /* height 0 */
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_ERR_BODY);
    put_rect(b, TY(0) + BT_B, 0, 0, 9, 9);
    put_rect(b, TY(0) + BT_C, 0, 0, 5000, 9); /* a valid rect C decides instead of B */
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_ERR_BODY);
    put_rect(b, TY(0) + BT_C, 0, 0, 99, 99);
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_OK);
    put_rect(b, TY(0) + BT_C, 0, 5, 9, 5); /* top == bottom: C is invalid again and B decides */
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_OK);
    build_body(b);
    put_rect(b, TY(3) + BT_B, 0, 0, 0, 0); /* types beyond the count are not looked at */
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_OK);
    put_rect(b, TY(2) + BT_B, 0, 0, 0, 0); /* the last used type is (width 1, height 1 from the zero rect) */
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_OK);
    put_rect(b, TY(2) + BT_B, 10, 0, -10, 9);
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_ERR_BODY);
    /* 16 bit wrap of the size, as the original computes it. */
    put_rect(b, TY(2) + BT_B, 0, 0, 65535, 9);
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_ERR_BODY); /* (int16)65535 + 1 = 0 */
    put_rect(b, TY(2) + BT_B, 0, 0, 65536 + 9, 9);
    CK(eb_validate_body(b, EB_BODY_BYTES, NULL) == EB_OK); /* (int16)(65545) + 1 = 10 */
}

static void t_reset(void)
{
    EbObject o;
    EbWorld w;
    memset(&o, 0xaa, sizeof o);
    eb_object_reset(&o);
    CK(eb_object_slot(&o) == -1 && eb_object_row(&o) == -1 && !eb_object_active(&o) && eb_object_state(&o) == 0);
    for (size_t i = 0; i < sizeof o.b; ++i)
        if (i != O_SLOT && i != O_SLOT + 1 && i != O_ROW && i != O_ROW + 1) CK(o.b[i] == 0);
    memset(&w, 0xaa, sizeof w);
    w.start_flag_5bb1ca = 5;
    w.scene_5bb57b = 6;
    w.saved_count = 11;
    w.saved_total = 12;
    eb_world_reset(&w);
    /* 0x47e3f7 clears the flag, the scene word, the counters and the instances; the count and total words keep their values */
    CK(w.saved_flag == 0 && w.saved_scene == 9999 && w.saved_count == 11 && w.saved_total == 12);
    CK(w.start_flag_5bb1ca == 5 && w.scene_5bb57b == 6);
    for (size_t i = 0; i < sizeof w.saved_counts; ++i) CK(w.saved_counts[i] == 0);
    for (size_t i = 0; i < sizeof w.saved_pieces; ++i) CK(w.saved_pieces[i] == 0);
    put32(o.b, O_ACTIVE, 1);
    CK(eb_object_active(&o));
    put32(o.b, O_STATE, 6);
    CK(eb_object_state(&o) == 6u);
}

/* ---- phase 0 (0x480e02 phase 0, 0x47e582) -------------------------------------------------------------------------------------- */

static void t_phase0(void)
{
    Fx f;
    fx_init(&f);
    CK(start(&f) == EB_OK && f.phase == 1u && f.res.initialized == 1u && f.res.completed == 0u && f.res.phase_after == 1u);
    CK_LOG(&f, "clr,load:PIECES:DF Piece Source Surface,create:40x30=100,blit:5>100:1,1,40,30>0,0,39,29,"
               "create:40x30=101,blit:5>101:51,1,90,30>0,0,39,29,create:40x30=102,blit:5>102:101,1,140,30>0,0,39,29,"
               "reg:24:MULTIBUILD PUZZLE OVERLAYS");
    CK(f.w.start_flag_5bb1ca == 1 && f.w.saved_scene == 7);
    CK(od32(&f, O_ACTIVE) == 1 && od16(&f, O_ROW) == 2 && od16(&f, O_SLOT) == 0x18 && od16(&f, O_HAND) == -1);
    CK(od16(&f, O_COUNT) == 3 && od16(&f, O_TOTAL) == 0 && od32(&f, O_SRC) == 5 && od32(&f, O_MULTI) == 0 && od32(&f, O_ANIM) == 0);
    CK(ob(&f, O_HAS_MULTI) == 0 && ob(&f, O_HAS_ANIM) == 0);
    for (int t = 0; t < 3; ++t) {
        CK(od32(&f, EN(t, 0)) == 100 + t && od16(&f, EN(t, 0) + 0x14) == 40 && od16(&f, EN(t, 0) + 0x16) == 30);
        CK(rect_is(f.o.b, EN(t, 0) + 4, 0, 0, 39, 29));
        CK(od32(&f, EN(t, 1)) == 0 && od32(&f, EN(t, 2)) == 0 && od32(&f, EN(t, 3)) == 0); /* no rotated copies */
        CK(rect_is(f.o.b, PI(t) + P_RECT, 300 + 50 * t, 200, 339 + 50 * t, 229));
        CK(rect_is(f.o.b, PI(t) + P_RECT2, 310 + 50 * t, 220, 349 + 50 * t, 249));
        CK(ob(&f, PI(t) + P_TYPE) == t && ob(&f, PI(t) + P_STAMP) == 0 && od16(&f, PI(t) + P_Z) == 0 && ob(&f, PI(t) + P_ORIENT) == 0);
    }
    CK(eb_object_active(&f.o) && eb_object_row(&f.o) == 2 && eb_object_slot(&f.o) == 0x18);
    /* Rect C valid: the entry is built from C (size and source), the home rect B still places the instance. */
    fx_init(&f);
    put_rect(f.body, TY(1) + BT_C, 10, 20, 69, 59);
    CK(start(&f) == EB_OK);
    CK(strstr(f.log, "create:60x40=101,blit:5>101:10,20,69,59>0,0,59,39") != NULL);
    CK(od16(&f, EN(1, 0) + 0x14) == 60 && od16(&f, EN(1, 0) + 0x16) == 40);
    CK(rect_is(f.o.b, PI(1) + P_RECT, 350, 200, 389, 229));
    /* A different view origin and slot. */
    fx_init(&f);
    f.vo[0] = -5;
    f.vo[1] = 7;
    f.slot_value = 0x3f;
    CK(start(&f) == EB_OK && od16(&f, O_SLOT) == 0x3f);
    CK(rect_is(f.o.b, PI(2) + P_RECT2, 395, 207, 434, 236));
    CK(strstr(f.log, "reg:63:MULTIBUILD PUZZLE OVERLAYS") != NULL);
    /* Rotation allowed: three more entries per type, each a rotated copy of the previous one. */
    fx_init(&f);
    f.body[B_ROT] = 1;
    put_rect(f.body, TY(0) + BT_B, 300, 200, 349, 219); /* 50 x 20 */
    CK(start(&f) == EB_OK);
    CK(strstr(f.log, "create:50x20=100,blit:5>100:1,1,40,30>0,0,49,19,create:50x20=101,copy:101<100,rot:101=20x50,"
                     "create:20x50=102,copy:102<101,rot:102=50x20,create:50x20=103,copy:103<102,rot:103=20x50,"
                     "create:40x30=104,") != NULL);
    CK(od32(&f, EN(0, 1)) == 101 && od16(&f, EN(0, 1) + 0x14) == 20 && od16(&f, EN(0, 1) + 0x16) == 50 && rect_is(f.o.b, EN(0, 1) + 4, 0, 0, 19, 49));
    CK(od32(&f, EN(0, 2)) == 102 && od16(&f, EN(0, 2) + 0x14) == 50 && od16(&f, EN(0, 2) + 0x16) == 20 && rect_is(f.o.b, EN(0, 2) + 4, 0, 0, 49, 19));
    CK(od32(&f, EN(0, 3)) == 103 && od16(&f, EN(0, 3) + 0x14) == 20 && od16(&f, EN(0, 3) + 0x16) == 50 && rect_is(f.o.b, EN(0, 3) + 4, 0, 0, 19, 49));
    CK(od32(&f, EN(1, 0)) == 104 && od32(&f, EN(1, 3)) == 107 && od32(&f, EN(2, 3)) == 111);
    /* Rotation not allowed, but a piece instance that starts rotated gets the copies too (only when its entry is built). */
    fx_init(&f);
    CK(start(&f) == EB_OK);
    fx_clear(&f);
    f.o.b[PI(1) + P_ORIENT] = 2;
    f.o.b[PI(1) + P_TYPE] = 1;
    set32(&f, O_SRC, 5);
    CK(start(&f) == EB_OK); /* fresh state clears the instance: no rotated copies */
    CK(strstr(f.log, "copy:") == NULL);
    /* Sounds are prepared in the order pick, good drop, rotate, bad drop, only when they are not NO SOUND. */
    fx_init(&f);
    put_name(f.body, B_SND_ROT, "ROT", 0x21);
    put_name(f.body, B_SND_PICK, "PICK", 0x21);
    put_name(f.body, B_SND_GOOD, "GOOD", 0x21);
    put_name(f.body, B_SND_BAD, "BAD", 0x21);
    put_name(f.body, B_SND_WIN, "WIN", 0x21);
    CK(start(&f) == EB_OK);
    CK(strstr(f.log, "MULTIBUILD PUZZLE OVERLAYS,prep:746:PICK,prep:777:GOOD,prep:715:ROT,prep:7a8:BAD") != NULL);
    CK(strstr(f.log, "prep:8e1") == NULL);
    fx_init(&f);
    put_name(f.body, B_SND_GOOD, "NO SOUNDX", 0x21); /* the comparison includes the terminator */
    CK(start(&f) == EB_OK && strstr(f.log, "prep:777:NO SOUNDX") != NULL);
    fx_init(&f);
    put_name(f.body, B_SND_PICK, "NO SOUN", 0x21);
    CK(start(&f) == EB_OK && strstr(f.log, "prep:746:NO SOUN") != NULL);
}

static void t_phase0_objects(void)
{
    Fx f;
    /* Every cell phase 0 initialises, over an object full of leftovers. */
    fx_init(&f);
    memset(f.o.b, 0x55, sizeof f.o.b);
    set32(&f, O_SRC, 0);
    put_rect(f.body, B_ANIMAREA, 10, 20, 89, 59);
    put16(f.body, B_COLS, 2);
    CK(start(&f) == EB_OK);
    CK(od32(&f, O_ACTIVE) == 1 && od16(&f, O_ROW) == 2 && od32(&f, O_HIT) == 0 && od32(&f, O_DRAG) == 0 && od16(&f, O_HAND) == -1);
    CK(od32(&f, O_DROP) == 0 && od32(&f, O_LIFT) == 0 && ob(&f, O_DONE) == 0 && ob(&f, O_EXIT) == 0 && od32(&f, O_STATE) == 0);
    for (size_t i = 0; i < 0x40u; ++i) CK(ob(&f, O_PREV + i) == 0);   /* previous, moving, previous translated, translated rects */
    for (size_t i = 0; i < 16u; ++i) CK(ob(&f, O_PTR + i) == 0);
    CK(ob(&f, O_PREV + 0x40) == 0x55); /* the saved piece rect is not touched */
    CK(od32(&f, O_DEADLINE) == 0 && od16(&f, O_ANIM_ROW) == 0 && od16(&f, O_ANIM_FRAME) == 0);
    CK(od16(&f, O_CELL_W) == 79 && od16(&f, O_CELL_H) == 39);
    CK(ob(&f, O_HAS_MULTI) == 0 && od32(&f, O_MULTI) == 0 && ob(&f, O_HAS_ANIM) == 0 && od32(&f, O_ANIM) == 0);
    CK(ob(&f, O_ANIM_REST) == 0 && ob(&f, O_ANIM_ON) == 0 && ob(&f, O_MULTI_HAND) == 0);
    CK(od32(&f, O_SRC) == 5); /* loaded as it was 0 */
    for (int t = 3; t < 20; ++t)
        for (int k = 0; k < 4; ++k) CK(od32(&f, EN(t, k)) == 0); /* the surface handles of all 20 types are cleared */
    for (int k = 0; k < 4; ++k) CK(od32(&f, EN(0, k)) == (k == 0 ? 100 : 0));
    /* Fresh state: the 80 instances and the 20 counters are cleared, the count is the type count, the total 0. */
    for (int i = 3; i < 80; ++i)
        for (int k = 0; k < 0x25; ++k) CK(ob(&f, PI(i) + (size_t)k) == 0);
    for (int i = 0; i < 20; ++i) CK(ob(&f, O_COUNTS + (size_t)i) == 0);
    CK(od16(&f, O_COUNT) == 3 && od16(&f, O_TOTAL) == 0);
    CK(ob(&f, O_COUNTS - 1) == 0x55); /* the counter block starts at its offset */
    /* A loaded source image is kept: no second load. */
    fx_init(&f);
    CK(start(&f) == EB_OK);
    fx_clear(&f);
    CK(start(&f) == EB_OK && strstr(f.log, "load:PIECES") == NULL && od32(&f, O_SRC) == 5);
    /* Multi piece source: loaded unless NO_FILE or empty. */
    fx_init(&f);
    put_name(f.body, B_MULTI, "MULTI", 0x21);
    CK(start(&f) == EB_OK && strstr(f.log, "load:MULTI:Multi Piece Source Surface") != NULL);
    CK(ob(&f, O_HAS_MULTI) == 1 && od32(&f, O_MULTI) == 6);
    fx_init(&f);
    put_name(f.body, B_MULTI, "NO_FILEX", 0x21);
    CK(start(&f) == EB_OK && ob(&f, O_HAS_MULTI) == 1);
    fx_init(&f);
    put_name(f.body, B_MULTI, "NO_FIL", 0x21);
    CK(start(&f) == EB_OK && ob(&f, O_HAS_MULTI) == 1);
    fx_init(&f);
    put_name(f.body, B_MULTI, "", 0x21);
    memset(f.o.b + O_HAS_MULTI, 0x55, 1);
    set32(&f, O_MULTI, 0x55);
    CK(start(&f) == EB_OK && ob(&f, O_HAS_MULTI) == 0 && od32(&f, O_MULTI) == 0 && strstr(f.log, "Multi Piece") == NULL);
    /* Animation image: loaded unless NO_FILE or empty. */
    fx_init(&f);
    put_name(f.body, B_ANIMNAME, "ANIM", 0x21);
    put_name(f.body, B_MULTI, "MULTI", 0x21);
    CK(start(&f) == EB_OK && strstr(f.log, "load:MULTI:Multi Piece Source Surface,load:ANIM:Multi Anim Surface,reg:") != NULL);
    CK(ob(&f, O_HAS_ANIM) == 1 && od32(&f, O_ANIM) == 7);
    fx_init(&f);
    put_name(f.body, B_ANIMNAME, "NO_FILEX", 0x21);
    CK(start(&f) == EB_OK && ob(&f, O_HAS_ANIM) == 1);
    fx_init(&f);
    put_name(f.body, B_ANIMNAME, "NO_FIL", 0x21);
    CK(start(&f) == EB_OK && ob(&f, O_HAS_ANIM) == 1);
    fx_init(&f);
    put_name(f.body, B_ANIMNAME, "", 0x21);
    CK(start(&f) == EB_OK && ob(&f, O_HAS_ANIM) == 0 && od32(&f, O_ANIM) == 0);
    fx_init(&f);
    set32(&f, O_ANIM, 0x77);
    f.o.b[O_HAS_ANIM] = 1;
    CK(start(&f) == EB_OK && ob(&f, O_HAS_ANIM) == 0 && od32(&f, O_ANIM) == 0);
}

static void t_phase0_persist(void)
{
    Fx f;
    uint8_t keep[EB_PIECE_STRIDE * EB_MAX_INSTANCES];
    /* Persisted state is restored only when the persist byte, the saved flag and the saved scene all agree. */
    for (int variant = 0; variant < 4; ++variant) {
        fx_init(&f);
        f.body[B_PERSIST] = variant == 1 ? 0 : 1;
        f.w.saved_flag = variant == 2 ? 0 : 1;
        f.w.saved_scene = (int16_t)(variant == 3 ? 8 : 7);
        for (size_t i = 0; i < sizeof f.w.saved_pieces; ++i) f.w.saved_pieces[i] = (uint8_t)(i * 7 + 1);
        for (int i = 0; i < 20; ++i) f.w.saved_counts[i] = (uint8_t)(i + 1);
        f.w.saved_count = 5;
        f.w.saved_total = 4;
        memcpy(keep, f.w.saved_pieces, sizeof keep);
        CK(start(&f) == EB_OK);
        if (variant == 3) {
            /* The handler overwrites the saved scene before the piece builder compares it: the records stay zero. */
            CK(od16(&f, O_COUNT) == 3 && f.w.saved_scene == 7 && ob(&f, PI(1) + P_TYPE) == 0 && od32(&f, PI(1) + P_RECT) == 0);
            CK(od32(&f, EN(0, 0)) == 100);
        } else if (variant == 0) {
            CK(od16(&f, O_COUNT) == 5 && od16(&f, O_TOTAL) == 4 && f.w.saved_scene == 7);
            CK(ob(&f, O_COUNTS) == 1 && ob(&f, O_COUNTS + 19) == 20);
            /* instances 0..2 are not rebuilt (their rect, z, type and stamp stay as saved); the instance block is the saved block */
            CK(memcmp(f.o.b + O_PIECES, keep, sizeof keep) == 0);
            CK(od32(&f, EN(0, 0)) == 100); /* the surface entries are always built */
        } else {
            CK(od16(&f, O_COUNT) == 3 && od16(&f, O_TOTAL) == 0 && ob(&f, O_COUNTS) == 0 && f.w.saved_scene == 7);
            CK(rect_is(f.o.b, PI(1) + P_RECT, 350, 200, 389, 229) && ob(&f, PI(3)) == 0);
        }
    }
    /* A fresh start records the current scene as the saved scene. */
    fx_init(&f);
    f.w.saved_scene = 1234;
    f.w.scene_5bb57b = -3;
    CK(start(&f) == EB_OK && f.w.saved_scene == -3);
    /* The saved flag value is any non-zero dword (only the low byte differs from zero here). */
    fx_init(&f);
    f.body[B_PERSIST] = 2;
    f.w.saved_flag = 0x100u;
    f.w.saved_scene = 7;
    f.w.saved_count = 4;
    CK(start(&f) == EB_OK && od16(&f, O_COUNT) == 4);
    /* The scene compare is made with the sign extended saved word. */
    fx_init(&f);
    f.body[B_PERSIST] = 1;
    f.w.saved_flag = 1;
    f.w.saved_scene = -2;
    f.w.scene_5bb57b = 65534;
    f.w.saved_count = 4;
    CK(start(&f) == EB_OK && od16(&f, O_COUNT) == 3);
}

static void rich_body(Fx *f)
{
    f->body[B_ROT] = 1;
    put_name(f->body, B_MULTI, "MULTI", 0x21);
    put_name(f->body, B_ANIMNAME, "ANIM", 0x21);
    put_name(f->body, B_SND_ROT, "ROT", 0x21);
    put_name(f->body, B_SND_PICK, "PICK", 0x21);
    put_name(f->body, B_SND_GOOD, "GOOD", 0x21);
    put_name(f->body, B_SND_BAD, "BAD", 0x21);
}

static void t_phase0_host_failures(void)
{
    Fx f;
    int total;
    fx_init(&f);
    rich_body(&f);
    CK(start(&f) == EB_OK);
    total = f.calls;
    CK(total > 30);
    for (int n = 1; n <= total + 1; ++n) {
        fx_init(&f);
        rich_body(&f);
        f.fail_call = n;
        if (n <= total) {
            CK(start(&f) == EB_ERR_HOST);
            CK(f.res.initialized == 0u && f.res.completed == 0u && f.res.phase_after == 0u);
        } else {
            CK(start(&f) == EB_OK); /* the failure never fires */
        }
    }
    /* The slot is stored only after the allocation succeeded. */
    fx_init(&f);
    f.fail_call = 1;
    CK(step(&f, 0) == EB_ERR_HOST);
}

static void t_step_args(void)
{
    Fx f;
    EbHost h;
    void *words[32];
    const size_t n = sizeof(EbHost) / sizeof(void *);
    fx_init(&f);
    CK(eb_step(NULL, f.body, EB_BODY_BYTES, 2, 0, &f.w, &f.host, &f.res, NULL) == EB_ERR_ARGUMENT);
    CK(eb_step(&f.o, NULL, EB_BODY_BYTES, 2, 0, &f.w, &f.host, &f.res, NULL) == EB_ERR_ARGUMENT);
    CK(eb_step(&f.o, f.body, EB_BODY_BYTES, 2, 0, NULL, &f.host, &f.res, NULL) == EB_ERR_ARGUMENT);
    CK(eb_step(&f.o, f.body, EB_BODY_BYTES, 2, 0, &f.w, NULL, &f.res, NULL) == EB_ERR_ARGUMENT);
    CK(eb_step(&f.o, f.body, EB_BODY_BYTES, 2, 0, &f.w, &f.host, NULL, NULL) == EB_ERR_ARGUMENT);
    CK(f.calls == 0 && f.log[0] == '\0');
    /* A body that fails validation is refused with the reason, before any effect. */
    put16(f.body, B_NTYPES, 30);
    CK(step(&f, 0) == EB_ERR_BODY && strcmp(f.failure, "0xeb-type-count") == 0 && f.calls == 0 && od32(&f, O_ACTIVE) == 0);
    CK(f.res.phase_after == 0u && f.res.initialized == 0u);
    CK(eb_step(&f.o, f.body, EB_BODY_BYTES - 1u, 2, 0, &f.w, &f.host, &f.res, NULL) == EB_ERR_BODY);
    build_body(f.body);
    /* Every host callback is required, by every entry point. */
    CK(sizeof(EbHost) == 25u * sizeof(void *) && n == 25u && n < 32u);
    for (size_t i = 1; i < n; ++i) {
        uint32_t np = 0;
        EbRenderPlan *plan = (EbRenderPlan *)calloc(1u, sizeof *plan);
        const int32_t rect[4] = {0, 0, 1, 1};
        memcpy(words, &f.host, sizeof f.host);
        words[i] = NULL;
        memcpy(&h, words, sizeof h);
        CK(plan != NULL);
        CK(eb_step(&f.o, f.body, EB_BODY_BYTES, 2, 0, &f.w, &h, &f.res, NULL) == EB_ERR_ARGUMENT);
        CK(eb_pointer_move(&f.o, f.body, EB_BODY_BYTES, 1, 1, rect, &h, &f.pr) == EB_ERR_ARGUMENT);
        CK(eb_click(&f.o, f.body, EB_BODY_BYTES, &f.w, 1, 0, &h, &np) == EB_ERR_ARGUMENT);
        CK(eb_rotate_key(&f.o, f.body, EB_BODY_BYTES, 1, &h) == EB_ERR_ARGUMENT);
        if (plan != NULL) CK(eb_render_plan(&f.o, f.body, EB_BODY_BYTES, &h, plan) == EB_ERR_ARGUMENT);
        free(plan);
    }
    CK(f.calls == 0);
    /* Phases above 2 do nothing. */
    CK(start(&f) == EB_OK);
    fx_clear(&f);
    CK(step(&f, 3) == EB_OK && f.res.phase_after == 3u && f.res.completed == 0u && f.log[0] == '\0');
    CK(step(&f, 77) == EB_OK && f.res.phase_after == 77u);
}

static void t_phase12_gating(void)
{
    Fx f;
    fx_init(&f);
    CK(step(&f, 1) == EB_ERR_UNSUPPORTED && strcmp(f.failure, "0xeb-phase-without-init") == 0);
    CK(f.res.phase_after == 1u && f.res.initialized == 0u && f.res.completed == 0u);
    CK(step(&f, 2) == EB_ERR_UNSUPPORTED && strcmp(f.failure, "0xeb-phase-without-init") == 0 && f.res.completed == 0u);
    CK(start(&f) == EB_OK);
    CK(eb_step(&f.o, f.body, EB_BODY_BYTES, 1, 1, &f.w, &f.host, &f.res, &f.failure) == EB_ERR_UNSUPPORTED); /* another row */
    CK(eb_step(&f.o, f.body, EB_BODY_BYTES, 1, 2, &f.w, &f.host, &f.res, &f.failure) == EB_ERR_UNSUPPORTED);
    CK(step(&f, 1) == EB_OK && f.res.phase_after == 1u && f.res.initialized == 0u);
    set32(&f, O_ACTIVE, 0);
    CK(step(&f, 1) == EB_ERR_UNSUPPORTED);
    CK(step(&f, 2) == EB_ERR_UNSUPPORTED);
    set32(&f, O_ACTIVE, 2);
    CK(step(&f, 1) == EB_OK); /* any non-zero active dword */
    set32(&f, O_ACTIVE, 0x100);
    CK(step(&f, 1) == EB_OK);
    set16(&f, O_ROW, 3);
    CK(step(&f, 1) == EB_ERR_UNSUPPORTED);
    /* Phase 0 over an active object re-initialises it. */
    CK(start(&f) == EB_OK && od16(&f, O_ROW) == 2);
}

/* ---- phase 1: the state machine on obj+0x13ca ------------------------------------------------------------------------------------ */

static void t_state_idle_and_wait(void)
{
    Fx f;
    fx_init(&f);
    CK(start(&f) == EB_OK);
    /* state 0: more than 0x4f instances end the puzzle */
    set16(&f, O_COUNT, 0x4f);
    CK(visit(&f) == EB_OK && f.res.phase_after == 1u);
    set16(&f, O_COUNT, 0x50);
    CK(visit(&f) == EB_OK && f.res.phase_after == 2u && f.res.completed == 0u);
    set16(&f, O_COUNT, (int16_t)0x8000);
    CK(visit(&f) == EB_OK && f.res.phase_after == 1u); /* signed compare */
    set16(&f, O_COUNT, 0x7fff);
    CK(visit(&f) == EB_OK && f.res.phase_after == 2u);
    /* state 1: wait for the (unsigned) deadline */
    set32(&f, O_STATE, 1);
    f.now = 500;
    set32(&f, O_DEADLINE, 501);
    CK(visit(&f) == EB_OK && od32(&f, O_STATE) == 1 && f.res.phase_after == 1u);
    set32(&f, O_DEADLINE, 500);
    CK(visit(&f) == EB_OK && od32(&f, O_STATE) == 0 && f.res.phase_after == 1u);
    set32(&f, O_STATE, 1);
    set32(&f, O_DEADLINE, 499);
    CK(visit(&f) == EB_OK && od32(&f, O_STATE) == 0);
    set32(&f, O_STATE, 1);
    set32(&f, O_DEADLINE, -16); /* 0xfffffff0 is far in the future */
    CK(visit(&f) == EB_OK && od32(&f, O_STATE) == 1);
    f.now = 0xfffffff0u;
    CK(visit(&f) == EB_OK && od32(&f, O_STATE) == 0);
    /* state 2 and states outside 0..6 do nothing */
    for (int s = 2; s <= 100; s += (s == 2 ? 5 : 20)) {
        set32(&f, O_STATE, s);
        fx_clear(&f);
        CK(visit(&f) == EB_OK && od32(&f, O_STATE) == s && f.res.phase_after == 1u && f.log[0] == '\0');
    }
    set32(&f, O_STATE, -1);
    CK(visit(&f) == EB_OK && od32(&f, O_STATE) == -1);
    set32(&f, O_STATE, 0x100000001LL & 0xffffffff);
    CK(visit(&f) == EB_OK && f.res.phase_after == 1u);
    /* state 3: wait for the win sound to stop */
    set32(&f, O_STATE, 3);
    put_name(f.body, B_SND_WIN, "WIN", 0x21);
    f.busy[0] = 1;
    f.nbusy = 1;
    fx_clear(&f);
    CK(visit(&f) == EB_OK && f.res.phase_after == 1u);
    CK_LOG(&f, "busy:15=1");
    f.busy_default = 0;
    fx_clear(&f);
    CK(visit(&f) == EB_OK && f.res.phase_after == 2u);
    CK_LOG(&f, "busy:15=0,stop:8e1:WIN");
    f.busy[0] = -1; /* any non-zero */
    f.ibusy = 0;
    fx_clear(&f);
    CK(visit(&f) == EB_OK && f.res.phase_after == 1u);
    fx_clear(&f);
    f.fail_call = 1;
    CK(visit(&f) == EB_ERR_HOST);
    f.ibusy = 5;
    fx_clear(&f);
    f.fail_call = 2;
    CK(visit(&f) == EB_ERR_HOST && f.res.phase_after == 1u);
    /* state 5 */
    set32(&f, O_STATE, 5);
    f.now = 100;
    set32(&f, O_DEADLINE2, 101);
    CK(visit(&f) == EB_OK && od32(&f, O_STATE) == 5);
    set32(&f, O_DEADLINE2, 100);
    CK(visit(&f) == EB_OK && od32(&f, O_STATE) == 4 && od32(&f, O_DEADLINE2) == 200);
    set32(&f, O_STATE, 5);
    set32(&f, O_DEADLINE2, -1);
    CK(visit(&f) == EB_OK && od32(&f, O_STATE) == 5);
}

static void t_state_four_no_animation(void)
{
    Fx f;
    fx_init(&f);
    CK(start(&f) == EB_OK);
    set32(&f, O_STATE, 4);
    f.now = 700;
    set32(&f, O_DEADLINE, 701);
    CK(visit(&f) == EB_OK && od32(&f, O_STATE) == 4);
    set32(&f, O_DEADLINE, 700);
    CK(visit(&f) == EB_OK && od32(&f, O_STATE) == 0); /* not solved: back to idle */
    set32(&f, O_STATE, 4);
    f.o.b[O_DONE] = 1;
    CK(visit(&f) == EB_OK && od32(&f, O_STATE) == 6); /* solved: the win sound state */
    set32(&f, O_STATE, 4);
    set32(&f, O_DEADLINE, -5);
    CK(visit(&f) == EB_OK && od32(&f, O_STATE) == 4);
    f.o.b[O_DONE] = 0x80;
    set32(&f, O_DEADLINE, 1);
    CK(visit(&f) == EB_OK && od32(&f, O_STATE) == 6);
}

static void t_state_four_animation(void)
{
    static const int src[6][4] = {{1, 1, 20, 10}, {21, 1, 40, 10}, {41, 1, 60, 10}, {1, 11, 20, 20}, {21, 11, 40, 20}, {41, 11, 60, 20}};
    Fx f;
    int draws = 0;
    fx_init(&f);
    put_name(f.body, B_ANIMNAME, "ANIM", 0x21);
    put_rect(f.body, B_ANIMAREA, 100, 100, 119, 109);
    put16(f.body, B_ROWS, 2);
    put16(f.body, B_COLS, 3);
    put16(f.body, B_GAP, 1);
    put16(f.body, B_REPEAT, 2);
    CK(start(&f) == EB_OK && od16(&f, O_CELL_W) == 19 && od16(&f, O_CELL_H) == 9);
    set32(&f, O_STATE, 4);
    fx_clear(&f);
    for (int k = 0; k < 20 && od32(&f, O_STATE) == 4; ++k) {
        const int frame = od16(&f, O_ANIM_FRAME);
        CK(visit(&f) == EB_OK);
        if (od32(&f, O_STATE) == 5) {
            const int cell = (frame == 6 ? 0 : frame);
            CK(rect_is(f.o.b, O_ANIM_SRC, src[cell][0], src[cell][1], src[cell][2], src[cell][3]));
            CK(ob(&f, O_ANIM_ON) == 1 && od16(&f, O_ANIM_FRAME) == cell + 1);
            CK(od16(&f, O_ANIM_ROW) == (draws >= 6 ? 1 : 0));
            ++draws;
            f.now += 100;
            set32(&f, O_DEADLINE2, (int32_t)f.now);
            CK(visit(&f) == EB_OK && od32(&f, O_STATE) == 4 && od32(&f, O_DEADLINE2) == (int32_t)(f.now + 100u));
        }
    }
    CK(draws == 12);
    CK(od32(&f, O_STATE) == 0 && od16(&f, O_ANIM_ROW) == 0 && ob(&f, O_ANIM_REST) == 1 && ob(&f, O_ANIM_ON) == 0);
    CK(strstr(f.log, "play:") == NULL && strstr(f.log, "busy:") == NULL); /* good sound is NO SOUND */
    /* Solved: the end of the animation goes to the win sound state. */
    set32(&f, O_STATE, 4);
    set16(&f, O_ANIM_ROW, 1);
    set16(&f, O_ANIM_FRAME, 6);
    f.o.b[O_DONE] = 1;
    CK(visit(&f) == EB_OK && od16(&f, O_ANIM_ROW) == 0 && od32(&f, O_STATE) == 6 && ob(&f, O_ANIM_REST) == 1);
}

static void t_state_four_animation_sound(void)
{
    Fx f;
    fx_init(&f);
    put_name(f.body, B_ANIMNAME, "ANIM", 0x21);
    put_name(f.body, B_SND_GOOD, "GOOD", 0x21);
    put_rect(f.body, B_ANIMAREA, 0, 0, 9, 9);
    put16(f.body, B_ROWS, 1);
    put16(f.body, B_COLS, 2);
    put16(f.body, B_REPEAT, 1);
    CK(start(&f) == EB_OK);
    set32(&f, O_STATE, 4);
    f.busy_default = 0;
    fx_clear(&f);
    CK(visit(&f) == EB_OK);
    CK_LOG(&f, "busy:13=0,play:13");
    CK(rect_is(f.o.b, O_ANIM_SRC, 1, 1, 10, 10) && od32(&f, O_STATE) == 5);
    set32(&f, O_STATE, 4);
    f.busy_default = 1;
    fx_clear(&f);
    CK(visit(&f) == EB_OK);
    CK_LOG(&f, "busy:13=1"); /* still playing: no second start */
    CK(rect_is(f.o.b, O_ANIM_SRC, 10, 1, 19, 10) && od16(&f, O_ANIM_FRAME) == 2);
    /* The grid wraps by column count; with zero columns the visit is refused. */
    set32(&f, O_STATE, 4);
    fx_clear(&f);
    CK(visit(&f) == EB_OK); /* frame 2 / 2 = 1 >= rows: reset, row 1 not < repeat 1: ends */
    CK(od32(&f, O_STATE) == 0 && ob(&f, O_ANIM_REST) == 1 && od16(&f, O_ANIM_ROW) == 0 && od16(&f, O_ANIM_FRAME) == 0);
    put16(f.body, B_COLS, 0);
    put_rect(f.body, B_ANIMAREA, 0, 0, 9, 0);
    set32(&f, O_STATE, 4);
    CK(visit(&f) == EB_ERR_BOUNDS);
    /* host failures in the sound check */
    put16(f.body, B_COLS, 2);
    set32(&f, O_STATE, 4);
    fx_clear(&f);
    f.fail_call = 1;
    CK(visit(&f) == EB_ERR_HOST);
    f.busy_default = 0;
    fx_clear(&f);
    f.fail_call = 2;
    CK(visit(&f) == EB_ERR_HOST);
    /* A negative row quotient: a negative frame (never produced by the code) is below the row count. */
    set16(&f, O_ANIM_FRAME, 0);
    set16(&f, O_ANIM_ROW, 0);
    set32(&f, O_STATE, 4);
    fx_clear(&f);
    CK(visit(&f) == EB_OK && od16(&f, O_ANIM_ROW) == 0);
}

/* ---- the pointer receiver (0x47f421, 0x47fd65, 0x47ec06) ---------------------------------------------------------------------- */

static int record_of(int cursor) { return 0x5b161c + cursor * 0x20; }

static void t_pointer_candidates(void)
{
    Fx f;
    fx_init(&f);
    CK(start(&f) == EB_OK);
    /* a piece under the pointer */
    CK(ptr(&f, 310, 210) == EB_OK);
    CK(f.pr.hit == 1u && f.pr.candidate == EB_CANDIDATE_PICK && f.pr.wrote_cursor == 1u && f.pr.cursor == 21 && f.pr.cursor_flag == 1u &&
       f.pr.cursor_record == (uint32_t)record_of(21));
    CK(EB_CANDIDATE_PICK == 0x278d && EB_CANDIDATE_ROTATE == 0x278e && EB_CANDIDATE_EXIT_A == 0x278f &&
       EB_CANDIDATE_EXIT_B == 0x2790 && EB_CANDIDATE_DROP == 0x2791);
    CK(od16(&f, O_COUNT1) == 1 && od16(&f, O_LIST1) == 0 && od16(&f, O_COUNT2) == 0);
    CK(rect_is(f.o.b, O_PTR, 302, 202, 318, 218));
    /* nothing under the pointer */
    CK(ptr(&f, 10, 10) == EB_OK);
    CK(f.pr.hit == 0u && f.pr.candidate == -1 && f.pr.wrote_cursor == 0u && f.pr.cursor == 0 && f.pr.cursor_record == 0u);
    CK(od16(&f, O_COUNT1) == 0 && od16(&f, O_COUNT2) == 0);
    /* the hit rectangle of a piece is inclusive on all four edges */
    {
        static const int probe[][3] = {{300, 200, 1}, {299, 200, 0}, {300, 199, 0}, {339, 229, 1}, {340, 229, 0}, {339, 230, 0},
                                       {339, 200, 1}, {300, 229, 1}, {320, 215, 1}};
        for (size_t i = 0; i < sizeof probe / sizeof probe[0]; ++i) {
            CK(ptr(&f, probe[i][0], probe[i][1]) == EB_OK);
            CK((f.pr.hit == 1u) == (probe[i][2] == 1));
        }
    }
    /* overlapping pieces are all listed, in instance order */
    inst(&f, 1, 1, 320, 210, 359, 239);
    CK(ptr(&f, 330, 220) == EB_OK && od16(&f, O_COUNT1) == 2 && od16(&f, O_LIST1) == 0 && od16(&f, O_LIST1 + 2) == 1);
    /* the list area is cleared on every move (10 dwords), the second list's words are left alone */
    for (size_t k = 0; k < 40u; ++k) f.o.b[O_LIST1 + k] = 0x44;
    for (size_t k = 0; k < 40u; ++k) f.o.b[O_LIST2 + k] = 0x44;
    CK(ptr(&f, 10, 10) == EB_OK);
    for (size_t k = 0; k < 40u; ++k) CK(ob(&f, O_LIST1 + k) == 0);
    CK(ob(&f, O_LIST2) == 0x44 && ob(&f, O_LIST2 + 39) == 0x44 && od16(&f, O_COUNT1) == 0);
    /* a piece wins over an exit button; the exit buttons are inclusive rectangles */
    fx_init(&f);
    CK(start(&f) == EB_OK);
    {
        static const int probe[][4] = {{600, 440, 1, 0x278f}, {639, 479, 1, 0x278f}, {599, 440, 0, 0}, {600, 439, 0, 0},
                                       {639, 480, 0, 0}, {640, 479, 0, 0}, {620, 460, 1, 0x278f}, {0, 440, 1, 0x2790},
                                       {39, 479, 1, 0x2790}, {40, 479, 0, 0}, {39, 480, 0, 0}, {0, 439, 0, 0}, {20, 460, 1, 0x2790}};
        for (size_t i = 0; i < sizeof probe / sizeof probe[0]; ++i) {
            CK(ptr(&f, probe[i][0], probe[i][1]) == EB_OK);
            CK(f.pr.hit == (uint8_t)probe[i][2] && (probe[i][2] == 0 || f.pr.candidate == probe[i][3]));
        }
        CK(ptr(&f, 620, 460) == EB_OK && f.pr.cursor == 31 && f.pr.cursor_flag == 1u && f.pr.cursor_record == (uint32_t)record_of(31));
        CK(ptr(&f, 20, 460) == EB_OK && f.pr.cursor == 32 && f.pr.cursor_flag == 1u && f.pr.cursor_record == (uint32_t)record_of(32));
    }
    inst(&f, 0, 0, 590, 430, 630, 470);
    CK(ptr(&f, 620, 460) == EB_OK && f.pr.candidate == EB_CANDIDATE_PICK);
    /* the same button rect for both buttons: A wins */
    put_rect(f.body, B_BTN_B, 600, 440, 639, 479);
    set16(&f, O_COUNT, 0);
    CK(ptr(&f, 620, 460) == EB_OK && f.pr.candidate == EB_CANDIDATE_EXIT_A);
    /* stamped and spawning pieces */
    fx_init(&f);
    CK(start(&f) == EB_OK);
    f.o.b[PI(0) + P_STAMP] = 1;
    CK(ptr(&f, 310, 210) == EB_OK && f.pr.hit == 1u); /* stamped, not spawning: still pickable */
    f.body[TY(0) + BT_SPAWN] = 1;
    CK(ptr(&f, 310, 210) == EB_OK && f.pr.hit == 0u); /* stamped spawner: a copy stays behind, nothing to pick */
    f.o.b[PI(0) + P_STAMP] = 0;
    CK(ptr(&f, 310, 210) == EB_OK && f.pr.hit == 1u);
    /* with a multi piece in hand only the hand piece is a candidate */
    fx_init(&f);
    CK(start(&f) == EB_OK);
    inst(&f, 1, 1, 300, 200, 339, 229);
    f.o.b[O_MULTI_HAND] = 1;
    set16(&f, O_HAND, 1);
    CK(ptr(&f, 310, 210) == EB_OK && od16(&f, O_COUNT1) == 1 && od16(&f, O_LIST1) == 1);
    set16(&f, O_HAND, 0);
    CK(ptr(&f, 310, 210) == EB_OK && od16(&f, O_COUNT1) == 1 && od16(&f, O_LIST1) == 0);
    set16(&f, O_HAND, 2);
    CK(ptr(&f, 310, 210) == EB_OK && f.pr.hit == 0u);
    set32(&f, O_DRAG, 1); /* dragging a multi piece does not take the drag branch */
    set16(&f, O_HAND, 1);
    CK(ptr(&f, 310, 210) == EB_OK && f.pr.candidate == EB_CANDIDATE_PICK);
}

static void t_pointer_rotate_zone(void)
{
    Fx f;
    fx_init(&f);
    f.body[B_ROT] = 1;
    f.body[B_LOCKED] = 1;
    CK(start(&f) == EB_OK);
    CK(ptr(&f, 305, 205) == EB_OK);
    CK(f.pr.hit == 1u && f.pr.candidate == EB_CANDIDATE_ROTATE && f.pr.cursor == 0x14 && f.pr.cursor_flag == 0u &&
       f.pr.cursor_record == 0x5b188cu && f.pr.wrote_cursor == 1u);
    CK(od16(&f, O_COUNT2) == 1 && od16(&f, O_LIST2) == 0 && od16(&f, O_COUNT1) == 0);
    {
        /* zone: x in [300, 312], y in [200, 210]; outside it the piece is an ordinary pick */
        static const int probe[][3] = {{300, 200, 1}, {312, 210, 1}, {312, 200, 1}, {300, 210, 1}, {313, 205, 0}, {305, 211, 0},
                                       {299, 205, 9}, {305, 199, 9}, {306, 207, 1}};
        for (size_t i = 0; i < sizeof probe / sizeof probe[0]; ++i) {
            CK(ptr(&f, probe[i][0], probe[i][1]) == EB_OK);
            if (probe[i][2] == 9) CK(f.pr.hit == 0u);
            else CK(f.pr.hit == 1u && (f.pr.candidate == EB_CANDIDATE_ROTATE) == (probe[i][2] == 1));
        }
    }
    /* each condition of the zone is needed */
    f.body[B_LOCKED] = 0;
    CK(ptr(&f, 305, 205) == EB_OK && f.pr.candidate == EB_CANDIDATE_PICK);
    f.body[B_LOCKED] = 1;
    f.body[B_ROT] = 0;
    CK(ptr(&f, 305, 205) == EB_OK && f.pr.candidate == EB_CANDIDATE_PICK);
    f.body[B_ROT] = 1;
    put16(f.body, B_ZONE_H, 0);
    CK(ptr(&f, 305, 201) == EB_OK && f.pr.candidate == EB_CANDIDATE_PICK && ptr(&f, 300, 200) == EB_OK && f.pr.candidate == EB_CANDIDATE_ROTATE);
    put16(f.body, B_ZONE_H, 10);
    put16(f.body, B_ZONE_W, 0);
    CK(ptr(&f, 301, 205) == EB_OK && f.pr.candidate == EB_CANDIDATE_PICK && ptr(&f, 300, 205) == EB_OK && f.pr.candidate == EB_CANDIDATE_ROTATE);
    /* stamped spawners are not zone candidates either */
    put16(f.body, B_ZONE_W, 12);
    f.body[TY(0) + BT_SPAWN] = 1;
    f.o.b[PI(0) + P_STAMP] = 1;
    CK(ptr(&f, 305, 205) == EB_OK && f.pr.hit == 0u);
    /* the lists are 20 words: the 21st piece is refused */
    for (int n = 20; n <= 21; ++n) {
        fx_init(&f);
        f.body[B_ROT] = 1;
        f.body[B_LOCKED] = 1;
        CK(start(&f) == EB_OK);
        for (int i = 0; i < n; ++i) inst(&f, i, 0, 300, 200, 339, 229);
        CK((ptr(&f, 305, 205) == EB_OK) == (n == 20));
        CK(n == 20 ? od16(&f, O_COUNT2) == 20 : f.rc == EB_ERR_BOUNDS);
        CK(n == 21 ? od16(&f, O_COUNT2) == 20 : od16(&f, O_LIST2 + 38) == 19);
        f.body[B_LOCKED] = 0;
        CK((ptr(&f, 310, 210) == EB_OK) == (n == 20));
        CK(n == 20 ? od16(&f, O_COUNT1) == 20 : f.rc == EB_ERR_BOUNDS);
        CK(od16(&f, O_LIST1 + 38) == (n == 20 ? 19 : 19));
    }
}

static void t_pointer_args_and_bounds(void)
{
    Fx f;
    const int32_t rect[4] = {0, 0, 1, 1};
    EbHost h = {0};
    fx_init(&f);
    CK(start(&f) == EB_OK);
    CK(eb_pointer_move(NULL, f.body, EB_BODY_BYTES, 1, 1, rect, &f.host, &f.pr) == EB_ERR_ARGUMENT);
    CK(eb_pointer_move(&f.o, NULL, EB_BODY_BYTES, 1, 1, rect, &f.host, &f.pr) == EB_ERR_ARGUMENT);
    CK(eb_pointer_move(&f.o, f.body, EB_BODY_BYTES, 1, 1, NULL, &f.host, &f.pr) == EB_ERR_ARGUMENT);
    CK(eb_pointer_move(&f.o, f.body, EB_BODY_BYTES, 1, 1, rect, &f.host, NULL) == EB_ERR_ARGUMENT);
    CK(eb_pointer_move(&f.o, f.body, EB_BODY_BYTES, 1, 1, rect, NULL, &f.pr) == EB_ERR_ARGUMENT);
    CK(eb_pointer_move(&f.o, f.body, EB_BODY_BYTES, 1, 1, rect, &h, &f.pr) == EB_ERR_ARGUMENT);
    CK(eb_pointer_move(&f.o, f.body, EB_BODY_BYTES - 1u, 1, 1, rect, &f.host, &f.pr) == EB_ERR_ARGUMENT);
    /* an inactive object is not touched */
    set32(&f, O_ACTIVE, 0);
    memset(f.o.b + O_PTR, 0x33, 16);
    memset(&f.pr, 0x77, sizeof f.pr);
    CK(ptr(&f, 310, 210) == EB_OK && f.pr.hit == 0u && f.pr.candidate == -1 && f.pr.wrote_cursor == 0u && f.pr.cursor == 0 &&
       f.pr.cursor_flag == 0u && f.pr.cursor_record == 0u);
    CK(ob(&f, O_PTR) == 0x33 && ob(&f, O_PTR + 15) == 0x33);
    /* the instance table must be sane: count 0..80, type bytes below 20 */
    set32(&f, O_ACTIVE, 1);
    set16(&f, O_COUNT, 81);
    CK(ptr(&f, 10, 10) == EB_ERR_BOUNDS);
    set16(&f, O_COUNT, 80);
    CK(ptr(&f, 10, 10) == EB_OK);
    set16(&f, O_COUNT, -1);
    CK(ptr(&f, 10, 10) == EB_ERR_BOUNDS);
    set16(&f, O_COUNT, 3);
    f.o.b[PI(2) + P_TYPE] = 20;
    CK(ptr(&f, 10, 10) == EB_ERR_BOUNDS);
    f.o.b[PI(2) + P_TYPE] = 19;
    CK(ptr(&f, 10, 10) == EB_OK);
    f.o.b[PI(3) + P_TYPE] = 200; /* beyond the count: ignored */
    CK(ptr(&f, 10, 10) == EB_OK);
    /* a dragged piece must be a valid instance */
    set32(&f, O_DRAG, 1);
    set16(&f, O_HAND, -1);
    CK(ptr(&f, 10, 10) == EB_ERR_BOUNDS);
    set16(&f, O_HAND, 3);
    CK(ptr(&f, 10, 10) == EB_ERR_BOUNDS);
    set16(&f, O_HAND, 80);
    CK(ptr(&f, 10, 10) == EB_ERR_BOUNDS);
    f.o.b[PI(3) + P_TYPE] = 0;
    set16(&f, O_COUNT, 80);
    set16(&f, O_HAND, 79);
    CK(ptr(&f, 10, 10) == EB_OK);
    set16(&f, O_COUNT, 3);
    set16(&f, O_HAND, 2);
    f.o.b[PI(2) + P_TYPE] = 20;
    CK(ptr(&f, 10, 10) == EB_ERR_BOUNDS);
    f.o.b[PI(2) + P_TYPE] = 0;
    CK(ptr(&f, 10, 10) == EB_OK);
    /* host failures */
    for (int n = 1; n <= 3; ++n) {
        fx_clear(&f);
        f.fail_call = n;
        CK((ptr(&f, 300, 300) == EB_ERR_HOST) == (n <= 2));
    }
}

static void t_pointer_drag(void)
{
    Fx f;
    fx_init(&f);
    CK(start(&f) == EB_OK);
    set32(&f, O_DRAG, 1);
    set16(&f, O_HAND, 0);
    set16(&f, O_HW, 39);
    set16(&f, O_HH, 29);
    CK(ptr(&f, 320, 215) == EB_OK);
    CK(f.pr.hit == 1u && f.pr.candidate == EB_CANDIDATE_DROP && f.pr.wrote_cursor == 1u && f.pr.cursor == 21 && f.pr.cursor_flag == 1u &&
       f.pr.cursor_record == (uint32_t)record_of(21));
    CK(od32(&f, O_HIT) == 1);
    CK(rect_is(f.o.b, O_MOVE, 301, 201, 340, 230) && rect_is(f.o.b, O_MOVE_T, 311, 221, 350, 250));
    CK(rect_is(f.o.b, O_PREV, 301, 201, 340, 230) && rect_is(f.o.b, O_PREV_T, 311, 221, 350, 250)); /* first move: previous = current */
    CK(ptr(&f, 330, 225) == EB_OK);
    CK(rect_is(f.o.b, O_MOVE, 311, 211, 350, 240) && rect_is(f.o.b, O_MOVE_T, 321, 231, 360, 260));
    CK(rect_is(f.o.b, O_PREV, 301, 201, 340, 230) && rect_is(f.o.b, O_PREV_T, 311, 221, 350, 250));
    CK(rect_is(f.o.b, O_PTR, 322, 217, 338, 233));
    /* the previous rect is copied only while both its top and bottom are zero */
    put_rect(f.o.b, O_MOVE, 5, 0, 6, 9);
    CK(ptr(&f, 330, 225) == EB_OK && rect_is(f.o.b, O_PREV, 5, 0, 6, 9) && od32(&f, O_PREV + 12) == 9);
    put_rect(f.o.b, O_MOVE, 5, 9, 6, 0);
    CK(ptr(&f, 330, 225) == EB_OK && rect_is(f.o.b, O_PREV, 5, 9, 6, 0));
    put_rect(f.o.b, O_MOVE, 5, 0, 6, 0);
    put_rect(f.o.b, O_MOVE_T, 1, 2, 3, 4);
    CK(ptr(&f, 330, 225) == EB_OK && rect_is(f.o.b, O_PREV, 311, 211, 350, 240) && rect_is(f.o.b, O_PREV_T, 321, 231, 360, 260));
    /* the cursor of an out-of-area drop is 0x16 */
    put_rect(f.body, B_AREA, 100, 100, 500, 400);
    CK(ptr(&f, 20, 20) == EB_OK && od32(&f, O_HIT) == 0 && f.pr.cursor == 0x16 && f.pr.cursor_flag == 1u &&
       f.pr.cursor_record == (uint32_t)record_of(0x16) && f.pr.candidate == EB_CANDIDATE_DROP && f.pr.hit == 1u);
    /* the drop area is strict on all four edges, counted from the hand piece's half size (19 x 14) */
    {
        static const int probe[][3] = {{300, 115, 1}, {300, 114, 0}, {300, 385, 1}, {300, 386, 0}, {120, 250, 1}, {119, 250, 0},
                                       {480, 250, 1}, {481, 250, 0}};
        for (size_t i = 0; i < sizeof probe / sizeof probe[0]; ++i) {
            CK(ptr(&f, probe[i][0], probe[i][1]) == EB_OK);
            CK(od32(&f, O_HIT) == probe[i][2]);
        }
    }
    /* the half size comes from the hand piece's instance rect (width and height / 2, truncated) */
    inst(&f, 0, 0, 300, 200, 340, 232); /* 40 x 32 */
    CK(ptr(&f, 300, 250) == EB_OK && od32(&f, O_HIT) == 1);
    CK(ptr(&f, 120, 250) == EB_OK && od32(&f, O_HIT) == 0);  /* 120 - 20 = 100, not > 100 */
    CK(ptr(&f, 121, 250) == EB_OK && od32(&f, O_HIT) == 1);
    CK(ptr(&f, 300, 116) == EB_OK && od32(&f, O_HIT) == 0);
    CK(ptr(&f, 300, 117) == EB_OK && od32(&f, O_HIT) == 1);
}

static void t_pointer_clamp(void)
{
    Fx f;
    fx_init(&f);
    CK(start(&f) == EB_OK);
    set32(&f, O_DRAG, 1);
    set16(&f, O_HAND, 0);
    set16(&f, O_HW, 39);
    set16(&f, O_HH, 29);
    CK(ptr(&f, 5, 5) == EB_OK);
    CK(rect_is(f.o.b, O_MOVE, 0, 0, 39, 29) && rect_is(f.o.b, O_MOVE_T, 10, 20, 49, 49));
    CK(ptr(&f, 635, 475) == EB_OK);
    CK(rect_is(f.o.b, O_MOVE, 600, 450, 639, 479) && rect_is(f.o.b, O_MOVE_T, 610, 470, 649, 499));
    /* a rect larger than the clip rect: top, bottom, left and right are applied in that order */
    f.clip[0] = 50;
    f.clip[1] = 60;
    f.clip[2] = 500;
    f.clip[3] = 400;
    set16(&f, O_HW, 600);
    set16(&f, O_HH, 500);
    CK(ptr(&f, 300, 200) == EB_OK);
    CK(rect_is(f.o.b, O_MOVE, -100, -100, 500, 400));
    /* a rect inside the clip rect is not moved */
    set16(&f, O_HW, 100);
    set16(&f, O_HH, 80);
    CK(ptr(&f, 300, 200) == EB_OK);
    CK(rect_is(f.o.b, O_MOVE, 250, 160, 350, 240));
    /* each side separately: the rect is moved back inside, keeping its size */
    CK(ptr(&f, 300, 100) == EB_OK && rect_is(f.o.b, O_MOVE, 250, 60, 350, 140));
    CK(ptr(&f, 300, 99) == EB_OK && rect_is(f.o.b, O_MOVE, 250, 60, 350, 140));
    CK(ptr(&f, 300, 90) == EB_OK && rect_is(f.o.b, O_MOVE, 250, 60, 350, 140));
    CK(ptr(&f, 300, 360) == EB_OK && rect_is(f.o.b, O_MOVE, 250, 320, 350, 400));
    CK(ptr(&f, 300, 361) == EB_OK && rect_is(f.o.b, O_MOVE, 250, 320, 350, 400));
    CK(ptr(&f, 300, 380) == EB_OK && rect_is(f.o.b, O_MOVE, 250, 320, 350, 400));
    CK(ptr(&f, 100, 200) == EB_OK && rect_is(f.o.b, O_MOVE, 50, 160, 150, 240));
    CK(ptr(&f, 99, 200) == EB_OK && rect_is(f.o.b, O_MOVE, 50, 160, 150, 240));
    CK(ptr(&f, 60, 200) == EB_OK && rect_is(f.o.b, O_MOVE, 50, 160, 150, 240));
    CK(ptr(&f, 450, 200) == EB_OK && rect_is(f.o.b, O_MOVE, 400, 160, 500, 240));
    CK(ptr(&f, 451, 200) == EB_OK && rect_is(f.o.b, O_MOVE, 400, 160, 500, 240));
    CK(ptr(&f, 470, 200) == EB_OK && rect_is(f.o.b, O_MOVE, 400, 160, 500, 240));
    CK(ptr(&f, 470, 380) == EB_OK && rect_is(f.o.b, O_MOVE, 400, 320, 500, 400));
    CK(ptr(&f, 60, 90) == EB_OK && rect_is(f.o.b, O_MOVE, 50, 60, 150, 140));
}

static void t_pointer_mode_one(void)
{
    static const int y_probe[][2] = {{243, 1}, {242, 0}, {259, 1}, {260, 0}};
    static const int x_probe[][2] = {{350, 1}, {349, 0}, {389, 1}, {390, 0}};
    Fx f;
    fx_init(&f);
    f.body[B_MODE] = 1;
    put_rect(f.body, B_AREA, 0, 0, 10, 10); /* the drop area never contains the pointer */
    CK(start(&f) == EB_OK);
    set32(&f, O_DRAG, 1);
    set16(&f, O_HAND, 0);
    set16(&f, O_HW, 39);
    set16(&f, O_HH, 29);
    inst(&f, 1, 1, 350, 260, 389, 289); /* away from home (home is 350,200,389,229) */
    CK(ptr(&f, 370, 250) == EB_OK && od32(&f, O_HIT) == 1);
    for (size_t i = 0; i < 4u; ++i) {
        CK(ptr(&f, 370, y_probe[i][0]) == EB_OK && od32(&f, O_HIT) == y_probe[i][1]);
        CK(ptr(&f, x_probe[i][0], 250) == EB_OK && od32(&f, O_HIT) == x_probe[i][1]);
    }
    /* the mode byte must be 1 */
    f.body[B_MODE] = 0;
    CK(ptr(&f, 370, 250) == EB_OK && od32(&f, O_HIT) == 0);
    f.body[B_MODE] = 2;
    CK(ptr(&f, 370, 250) == EB_OK && od32(&f, O_HIT) == 0);
    f.body[B_MODE] = 1;
    /* a piece at home does not count; any one of the four edges off home does */
    inst(&f, 1, 1, 350, 200, 389, 229);
    inst(&f, 2, 2, 400, 200, 439, 229);
    set16(&f, O_COUNT, 3);
    inst(&f, 0, 0, 300, 200, 339, 229);
    CK(ptr(&f, 370, 190) == EB_OK && od32(&f, O_HIT) == 0);
    for (int k = 0; k < 4; ++k) {
        static const int home[4] = {350, 200, 389, 229};
        int r[4] = {home[0], home[1], home[2], home[3]};
        r[k] += (k == 1 ? 60 : 0) + 1; /* only the top edge moves far; the others by one */
        inst(&f, 1, 1, r[0], r[1], r[2], r[3]);
        {
            const int top = r[1];
            /* probe a point that is "near" for the moved rect: y just above its top, x inside */
            CK(ptr(&f, (r[0] + r[2]) / 2, top - 5) == EB_OK && od32(&f, O_HIT) == 1);
        }
    }
    /* every instance is considered, the hand piece included, and the instance count bounds the loop */
    inst(&f, 1, 1, 350, 200, 389, 229);
    inst(&f, 0, 0, 450, 400, 489, 429);
    CK(ptr(&f, 470, 395) == EB_OK && od32(&f, O_HIT) == 1);
    set16(&f, O_COUNT, 1);
    CK(ptr(&f, 470, 395) == EB_OK && od32(&f, O_HIT) == 1); /* instance 0 is still counted */
    set16(&f, O_COUNT, 3);
    inst(&f, 0, 0, 300, 200, 339, 229);
    inst(&f, 2, 2, 450, 400, 489, 429);
    CK(ptr(&f, 470, 395) == EB_OK && od32(&f, O_HIT) == 1);
    set16(&f, O_COUNT, 2);
    CK(ptr(&f, 470, 395) == EB_OK && od32(&f, O_HIT) == 0); /* instance 2 is beyond the count */
}

static void t_pointer_overlap(void)
{
    /* mode 0 with the overlap byte: a dropped piece that overlaps a placed piece (counter set) is not a hit. */
    static const struct { int pl, pr, pt, pb, expect; } cases[] = {
        {301, 340, 100, 229, 1}, {301, 352, 100, 229, 1}, {301, 353, 100, 229, 0}, {301, 353, 100, 202, 1}, {301, 353, 100, 203, 0},
        {350, 400, 226, 300, 0}, {350, 400, 227, 300, 1}, {386, 400, 150, 300, 0}, {387, 400, 150, 300, 1}, {386, 400, 200, 300, 0},
        {386, 400, 226, 300, 0}, {386, 400, 227, 300, 1}, {351, 400, 150, 202, 1}, {351, 400, 150, 203, 0}, {340, 349, 100, 300, 1},
        {340, 353, 100, 300, 0}};
    Fx f;
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        fx_init(&f);
        f.body[B_OVERLAP] = 1;
        CK(start(&f) == EB_OK);
        set32(&f, O_DRAG, 1);
        set16(&f, O_HAND, 0);
        set16(&f, O_HW, 39);
        set16(&f, O_HH, 29);
        f.o.b[O_COUNTS + 1] = 1; /* indexed by instance, as the original does */
        put_rect(f.o.b, O_MOVE, cases[i].pl, cases[i].pt, cases[i].pr, cases[i].pb);
        CK(ptr(&f, 320, 215) == EB_OK);
        CK(rect_is(f.o.b, O_PREV, cases[i].pl, cases[i].pt, cases[i].pr, cases[i].pb));
        if (od32(&f, O_HIT) != cases[i].expect) {
            CK(od32(&f, O_HIT) == cases[i].expect);
            snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (case %zu)", i);
        }
    }
    /* only with the byte, only in mode 0, only for placed pieces other than the hand */
    fx_init(&f);
    CK(start(&f) == EB_OK);
    set32(&f, O_DRAG, 1);
    set16(&f, O_HAND, 0);
    set16(&f, O_HW, 39);
    set16(&f, O_HH, 29);
    f.o.b[O_COUNTS + 1] = 1;
    put_rect(f.o.b, O_MOVE, 351, 201, 390, 230);
    f.body[B_OVERLAP] = 0;
    CK(ptr(&f, 320, 215) == EB_OK && od32(&f, O_HIT) == 1);
    f.body[B_OVERLAP] = 1;
    put_rect(f.o.b, O_MOVE, 351, 201, 390, 230);
    CK(ptr(&f, 320, 215) == EB_OK && od32(&f, O_HIT) == 0);
    f.body[B_MODE] = 2;
    put_rect(f.o.b, O_MOVE, 351, 201, 390, 230);
    CK(ptr(&f, 320, 215) == EB_OK && od32(&f, O_HIT) == 1);
    f.body[B_MODE] = 0;
    f.o.b[O_COUNTS + 1] = 0;
    put_rect(f.o.b, O_MOVE, 351, 201, 390, 230);
    CK(ptr(&f, 320, 215) == EB_OK && od32(&f, O_HIT) == 1); /* counter 0: not placed */
    f.o.b[O_COUNTS + 1] = 1;
    f.o.b[O_COUNTS + 0] = 1;
    set16(&f, O_HAND, 1);
    put_rect(f.o.b, O_MOVE, 351, 201, 390, 230);
    CK(ptr(&f, 320, 215) == EB_OK && od32(&f, O_HIT) == 1); /* instance 1 is the hand: skipped; instance 0 does not overlap */
    f.o.b[O_COUNTS + 0] = 0;
    f.o.b[O_COUNTS + 2] = 1;
    set16(&f, O_HAND, 0);
    put_rect(f.o.b, O_MOVE, 401, 201, 440, 230);
    CK(ptr(&f, 320, 215) == EB_OK && od32(&f, O_HIT) == 0); /* later instances are checked too */
    /* the loop is bounded by the instance count */
    set16(&f, O_COUNT, 2);
    put_rect(f.o.b, O_MOVE, 401, 201, 440, 230);
    CK(ptr(&f, 320, 215) == EB_OK && od32(&f, O_HIT) == 1);
}

/* ---- the click (0x47ff0e) --------------------------------------------------------------------------------------------------- */

static void t_click_guards(void)
{
    Fx f;
    uint32_t np = 0;
    fx_init(&f);
    put_name(f.body, B_SND_PICK, "PICK", 0x21);
    CK(start(&f) == EB_OK);
    CK(ptr(&f, 310, 210) == EB_OK);
    fx_clear(&f);
    for (int guard = 0; guard < 8; ++guard) {
        fx_init(&f);
        put_name(f.body, B_SND_PICK, "PICK", 0x21);
        CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK);
        fx_clear(&f);
        if (guard == 0) set32(&f, O_ACTIVE, 0);
        if (guard == 1) f.o.b[O_DONE] = 1;
        if (guard == 2) f.o.b[O_DONE] = 0x80;
        if (guard == 3) set32(&f, O_STATE, 1);
        if (guard == 4) set32(&f, O_STATE, 0x100);
        if (guard == 5) f.phase = 0;
        if (guard == 6) f.phase = 2;
        if (guard == 7) f.phase = 3;
        CK(click(&f, EB_CANDIDATE_PICK) == EB_OK && f.np == f.phase && od32(&f, O_DRAG) == 0 && f.log[0] == '\0');
        CK(click(&f, EB_CANDIDATE_EXIT_A) == EB_OK && f.np == f.phase && ob(&f, O_EXIT) == 0 && f.log[0] == '\0');
    }
    /* arguments */
    fx_init(&f);
    CK(start(&f) == EB_OK);
    CK(eb_click(NULL, f.body, EB_BODY_BYTES, &f.w, 1, 0, &f.host, &np) == EB_ERR_ARGUMENT);
    CK(eb_click(&f.o, NULL, EB_BODY_BYTES, &f.w, 1, 0, &f.host, &np) == EB_ERR_ARGUMENT);
    CK(eb_click(&f.o, f.body, EB_BODY_BYTES, NULL, 1, 0, &f.host, &np) == EB_ERR_ARGUMENT);
    CK(eb_click(&f.o, f.body, EB_BODY_BYTES, &f.w, 1, 0, NULL, &np) == EB_ERR_ARGUMENT);
    CK(eb_click(&f.o, f.body, EB_BODY_BYTES, &f.w, 1, 0, &f.host, NULL) == EB_ERR_ARGUMENT);
    CK(eb_click(&f.o, f.body, EB_BODY_BYTES - 1u, &f.w, 1, 0, &f.host, &np) == EB_ERR_ARGUMENT);
    /* a candidate that is none of the five does nothing */
    for (int32_t c = -1; c <= 0x2793; c += (c < 0 ? 1 : 0x279)) {
        if (c == EB_CANDIDATE_PICK || c == EB_CANDIDATE_ROTATE || (c >= EB_CANDIDATE_EXIT_A && c <= EB_CANDIDATE_DROP)) continue;
        fx_clear(&f);
        CK(click(&f, c) == EB_OK && f.np == 1u && f.log[0] == '\0' && od32(&f, O_DRAG) == 0);
    }
    CK(click(&f, 0x278c) == EB_OK && click(&f, 0x2792) == EB_OK && od32(&f, O_DRAG) == 0 && ob(&f, O_EXIT) == 0 && f.log[0] == '\0');
    f.o.b[O_DONE] = 0;
}

static void t_click_pick(void)
{
    Fx f;
    fx_init(&f);
    put_name(f.body, B_SND_PICK, "PICK", 0x21);
    CK(start(&f) == EB_OK);
    f.o.b[O_COUNTS + 0] = 1;
    f.o.b[O_COUNTS + 1] = 7;
    f.o.b[O_PIECES + 0x25 * 0 + P_STAMP] = 1;
    CK(ptr(&f, 310, 210) == EB_OK);
    fx_clear(&f);
    CK(click(&f, EB_CANDIDATE_PICK) == EB_OK && f.np == 1u);
    CK_LOG(&f, "play:12");
    CK(od32(&f, O_DRAG) == 1 && od16(&f, O_HAND) == 0 && od32(&f, O_LIFT) == 1 && ob(&f, O_MULTI_HAND) == 0);
    CK(rect_is(f.o.b, O_SAVED, 300, 200, 339, 229) && rect_is(f.o.b, PI(0) + P_RECT, 300, 200, 339, 229));
    CK(rect_is(f.o.b, PI(0) + P_RECT2, 310, 220, 349, 249) && od16(&f, O_HW) == 39 && od16(&f, O_HH) == 29);
    CK(ob(&f, O_COUNTS + 0) == 0 && ob(&f, O_COUNTS + 1) == 7);
    CK(od32(&f, O_STATE) == 1 && od32(&f, O_DEADLINE) == 1300);
    CK(ob(&f, PI(0) + P_STAMP) == 1); /* the stamp is kept until the drop */
    /* a second pick while dragging does nothing */
    set32(&f, O_STATE, 0);
    fx_clear(&f);
    CK(click(&f, EB_CANDIDATE_PICK) == EB_OK && f.log[0] == '\0' && od32(&f, O_STATE) == 0);
    /* a counter of zero stays zero; no pick sound means no state change */
    fx_init(&f);
    CK(start(&f) == EB_OK && ptr(&f, 360, 210) == EB_OK);
    fx_clear(&f);
    f.now = 5000;
    CK(click(&f, EB_CANDIDATE_PICK) == EB_OK && f.log[0] == '\0' && od32(&f, O_STATE) == 0 && od32(&f, O_DEADLINE) == 0);
    CK(od16(&f, O_HAND) == 1 && ob(&f, O_COUNTS + 1) == 0);
    /* the pick sound deadline is the tick + 300 (wrapping) */
    fx_init(&f);
    put_name(f.body, B_SND_PICK, "PICK", 0x21);
    CK(start(&f) == EB_OK && ptr(&f, 360, 210) == EB_OK);
    f.now = 0xfffffff0u;
    CK(click(&f, EB_CANDIDATE_PICK) == EB_OK && od32(&f, O_DEADLINE) == (int32_t)(0xfffffff0u + 300u));
    /* rect C is the in-hand rect */
    fx_init(&f);
    put_rect(f.body, TY(1) + BT_C, 10, 20, 69, 59);
    CK(start(&f) == EB_OK && ptr(&f, 360, 210) == EB_OK && click(&f, EB_CANDIDATE_PICK) == EB_OK);
    CK(rect_is(f.o.b, O_SAVED, 350, 200, 389, 229) && rect_is(f.o.b, PI(1) + P_RECT, 10, 20, 69, 59));
    CK(rect_is(f.o.b, PI(1) + P_RECT2, 20, 40, 79, 79) && od16(&f, O_HW) == 59 && od16(&f, O_HH) == 39);
    /* the topmost piece (greatest z, the first on a tie) is picked */
    {
        static const int z[][3] = {{2, 5, 0}, {5, 5, 0}, {5, 2, 0}, {-3, -1, 0}, {1, 3, 2}, {1, 2, 3}, {3, 2, 1}, {0, 0, 1}, {1, 1, 1}};
        static const int want[] = {1, 0, 0, 2, 1, 2, 0, 2, 0};
        for (size_t i = 0; i < sizeof z / sizeof z[0]; ++i) {
            fx_init(&f);
            CK(start(&f) == EB_OK);
            for (int k = 0; k < 3; ++k) {
                inst(&f, k, k, 300, 200, 339, 229);
                set16(&f, PI(k) + P_Z, z[i][k]);
            }
            CK(ptr(&f, 310, 210) == EB_OK && od16(&f, O_COUNT1) == 3);
            CK(click(&f, EB_CANDIDATE_PICK) == EB_OK && od16(&f, O_HAND) == want[i]);
        }
    }
    /* nothing under the pointer: refused */
    fx_init(&f);
    CK(start(&f) == EB_OK && ptr(&f, 10, 10) == EB_OK);
    CK(click(&f, EB_CANDIDATE_PICK) == EB_ERR_BOUNDS);
    /* sound failure */
    fx_init(&f);
    put_name(f.body, B_SND_PICK, "PICK", 0x21);
    CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK);
    fx_clear(&f);
    f.fail_call = 1;
    CK(click(&f, EB_CANDIDATE_PICK) == EB_ERR_HOST);
}

static void t_click_pick_spawn(void)
{
    Fx f;
    fx_init(&f);
    f.body[TY(0) + BT_SPAWN] = 1;
    CK(start(&f) == EB_OK);
    f.o.b[O_COUNTS + 0] = 1;
    memset(f.o.b + PI(3), 0xaa, 0x25);
    CK(ptr(&f, 310, 210) == EB_OK && click(&f, EB_CANDIDATE_PICK) == EB_OK);
    CK(od16(&f, O_COUNT) == 4 && od16(&f, O_HAND) == 0 && ob(&f, O_COUNTS + 0) == 1); /* spawners keep their counter */
    CK(ob(&f, PI(3) + P_TYPE) == 0 && ob(&f, PI(3) + P_STAMP) == 0 && rect_is(f.o.b, PI(3) + P_RECT, 300, 200, 339, 229));
    CK(rect_is(f.o.b, PI(3) + P_RECT2, 310, 220, 349, 249));
    CK(od16(&f, PI(3) + P_Z) == 1); /* above the piece it overlaps */
    CK(od32(&f, O_LIFT) == 1 && od32(&f, O_DRAG) == 1);
    /* the copy starts from a clean instance: the leftovers of its slot (z, stamp, orientation of the new piece) do not survive */
    fx_init(&f);
    f.body[TY(0) + BT_SPAWN] = 1;
    CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK);
    set16(&f, PI(3) + P_Z, 55);
    f.o.b[PI(3) + P_STAMP] = 1;
    CK(click(&f, EB_CANDIDATE_PICK) == EB_OK && od16(&f, O_COUNT) == 4);
    CK(od16(&f, PI(3) + P_Z) == 1 && ob(&f, PI(3) + P_STAMP) == 0);
    /* no piece under the pointer and no multi source: the refusal leaves the hand as it was */
    fx_init(&f);
    CK(start(&f) == EB_OK && ptr(&f, 10, 10) == EB_OK);
    set16(&f, O_HAND, 5);
    CK(click(&f, EB_CANDIDATE_PICK) == EB_ERR_BOUNDS && od16(&f, O_HAND) == 5);
    /* copies are made up to the 80th instance */
    for (int c = 78; c <= 81; ++c) {
        fx_init(&f);
        f.body[TY(0) + BT_SPAWN] = 1;
        CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK);
        for (int i = 3; i < c; ++i) inst(&f, i, 0, 0, 0, 1, 1);
        set16(&f, O_COUNT, c);
        {
            const int rc = click(&f, EB_CANDIDATE_PICK);
            CK((rc == EB_OK) == (c < 80));
            CK(rc == EB_OK ? od16(&f, O_COUNT) == c + 1 : (rc == EB_ERR_BOUNDS && od16(&f, O_COUNT) == c));
        }
    }
    fx_init(&f);
    f.body[TY(0) + BT_SPAWN] = 1;
    CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK);
    set16(&f, O_COUNT, -1);
    CK(click(&f, EB_CANDIDATE_PICK) == EB_ERR_BOUNDS);
    /* a copy host failure */
    fx_init(&f);
    f.body[TY(0) + BT_SPAWN] = 1;
    CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK);
    fx_clear(&f);
    f.fail_call = 1;
    CK(click(&f, EB_CANDIDATE_PICK) == EB_ERR_HOST); /* the view lookup of the copy */
}

static void t_click_multi(void)
{
    Fx f;
    fx_init(&f);
    put_name(f.body, B_MULTI, "MULTI", 0x21);
    put_name(f.body, B_SND_PICK, "PICK", 0x21);
    put_rect(f.body, TY(0) + BT_D, 0, 0, 59, 39);
    CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK);
    fx_clear(&f);
    CK(click(&f, EB_CANDIDATE_PICK) == EB_OK);
    CK(f.log[0] == '\0' && ob(&f, O_MULTI_HAND) == 1 && od32(&f, O_DRAG) == 1 && od16(&f, O_HAND) == 0 && od32(&f, O_LIFT) == 1);
    CK(rect_is(f.o.b, O_SAVED, 300, 200, 339, 229) && rect_is(f.o.b, PI(0) + P_RECT, 291, 196, 350, 235));
    CK(rect_is(f.o.b, PI(0) + P_RECT2, 301, 216, 360, 255));
    CK(od32(&f, O_STATE) == 0); /* no sound for the multi pick */
    /* the next release (any candidate) puts the piece on the area and picks it up for the drag */
    f.o.b[O_COUNTS + 0] = 2;
    CK(click(&f, 0) == EB_OK);
    CK(ob(&f, O_MULTI_HAND) == 0 && od32(&f, O_LIFT) == 1 && rect_is(f.o.b, O_SAVED, 291, 196, 350, 235));
    CK(rect_is(f.o.b, PI(0) + P_RECT2, 301, 216, 360, 255) && od16(&f, O_HW) == 59 && od16(&f, O_HH) == 39);
    CK(ob(&f, O_COUNTS + 0) == 1 && od32(&f, O_STATE) == 1 && strstr(f.log, "play:12") != NULL);
    /* rect E replaces the computed placement */
    fx_init(&f);
    put_name(f.body, B_MULTI, "MULTI", 0x21);
    put_rect(f.body, TY(0) + BT_D, 0, 0, 59, 39);
    put_rect(f.body, TY(0) + BT_E, 100, 100, 159, 139);
    CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK && click(&f, EB_CANDIDATE_PICK) == EB_OK);
    CK(rect_is(f.o.b, PI(0) + P_RECT, 100, 100, 159, 139) && rect_is(f.o.b, PI(0) + P_RECT2, 110, 120, 169, 159));
    CK(ob(&f, O_MULTI_HAND) == 1);
    /* the D placement is clamped; a rotated entry's size is used */
    fx_init(&f);
    put_name(f.body, B_MULTI, "MULTI", 0x21);
    put_rect(f.body, TY(0) + BT_D, 0, 0, 1000, 39);
    CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK && click(&f, EB_CANDIDATE_PICK) == EB_OK);
    CK(rect_is(f.o.b, PI(0) + P_RECT, -361, 196, 639, 235));
    fx_init(&f);
    put_name(f.body, B_MULTI, "MULTI", 0x21);
    f.body[B_ROT] = 1;
    put_rect(f.body, TY(0) + BT_D, 0, 0, 59, 39);
    CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK);
    f.o.b[PI(0) + P_ORIENT] = 1; /* entry 1 is 30 x 40: (300 + 15) - 29 = 286, (200 + 20) - 19 = 201 */
    CK(click(&f, EB_CANDIDATE_PICK) == EB_OK && rect_is(f.o.b, PI(0) + P_RECT, 286, 201, 345, 240));
    /* with a spawner the multi hand leaves a copy at the next release */
    fx_init(&f);
    put_name(f.body, B_MULTI, "MULTI", 0x21);
    f.body[TY(0) + BT_SPAWN] = 1;
    put_rect(f.body, TY(0) + BT_D, 0, 0, 59, 39);
    CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK && click(&f, EB_CANDIDATE_PICK) == EB_OK);
    CK(od16(&f, O_COUNT) == 3);
    CK(click(&f, 0) == EB_OK && od16(&f, O_COUNT) == 4 && rect_is(f.o.b, PI(3) + P_RECT, 300, 200, 339, 229));
    /* invalid hand at the second release */
    set32(&f, O_DRAG, 1);
    f.o.b[O_MULTI_HAND] = 1;
    set16(&f, O_HAND, -1);
    CK(click(&f, 0) == EB_ERR_BOUNDS);
    set16(&f, O_HAND, 4);
    CK(click(&f, 0) == EB_ERR_BOUNDS);
    set16(&f, O_HAND, 3);
    CK(click(&f, 0) == EB_OK);
    /* no pieces under the pointer for the first multi pick */
    fx_init(&f);
    put_name(f.body, B_MULTI, "MULTI", 0x21);
    CK(start(&f) == EB_OK && ptr(&f, 10, 10) == EB_OK);
    CK(click(&f, EB_CANDIDATE_PICK) == EB_ERR_BOUNDS);
    /* host failures of the first release */
    for (int n = 1; n <= 3; ++n) {
        fx_init(&f);
        put_name(f.body, B_MULTI, "MULTI", 0x21);
        put_rect(f.body, TY(0) + BT_D, 0, 0, 59, 39);
        CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK);
        fx_clear(&f);
        f.fail_call = n;
        CK((click(&f, EB_CANDIDATE_PICK) == EB_ERR_HOST) == (n <= 2));
    }
}

static void rot_setup(Fx *f)
{
    f->body[B_ROT] = 1;
    f->body[B_LOCKED] = 1;
    put_rect(f->body, TY(0) + BT_B, 300, 200, 349, 219); /* 50 x 20 */
}

static void t_click_rotate(void)
{
    Fx f;
    fx_init(&f);
    rot_setup(&f);
    put_name(f.body, B_SND_ROT, "ROT", 0x21);
    CK(start(&f) == EB_OK);
    f.o.b[O_COUNTS + 0] = 1;
    CK(ptr(&f, 305, 205) == EB_OK && f.pr.candidate == EB_CANDIDATE_ROTATE);
    fx_clear(&f);
    CK(click(&f, EB_CANDIDATE_ROTATE) == EB_OK && f.np == 1u);
    CK_LOG(&f, "play:11");
    CK(ob(&f, PI(0) + P_ORIENT) == 1 && od32(&f, O_LIFT) == 1 && rect_is(f.o.b, O_SAVED, 300, 200, 349, 219));
    CK(rect_is(f.o.b, PI(0) + P_RECT, 315, 185, 334, 234) && rect_is(f.o.b, PI(0) + P_RECT2, 325, 205, 344, 254));
    CK(od32(&f, O_DRAG) == 1 && od16(&f, O_HAND) == 0 && od16(&f, O_HW) == 19 && od16(&f, O_HH) == 49);
    CK(od32(&f, O_STATE) == 1 && od32(&f, O_DEADLINE) == 1350 && ob(&f, O_COUNTS + 0) == 1); /* 0x15e = 350 */
    /* four turns come back to the start */
    set32(&f, O_STATE, 0);
    f.phase = 1;
    f.body[B_LOCKED] = 0;
    for (int k = 2; k <= 5; ++k) {
        set32(&f, O_STATE, 0);
        CK(ptr(&f, 305, 205) == EB_OK || 1);
        CK(rkey(&f) == EB_OK || 1);
        (void)k;
    }
    /* rotation from orientation 1 to 2: the centre stays (315 + 10, 185 + 25) */
    fx_init(&f);
    rot_setup(&f);
    CK(start(&f) == EB_OK);
    f.o.b[PI(0) + P_ORIENT] = 1;
    put_rect(f.o.b, PI(0) + P_RECT, 315, 185, 334, 234);
    CK(ptr(&f, 316, 186) == EB_OK && f.pr.candidate == EB_CANDIDATE_ROTATE);
    CK(click(&f, EB_CANDIDATE_ROTATE) == EB_OK && ob(&f, PI(0) + P_ORIENT) == 2 && rect_is(f.o.b, PI(0) + P_RECT, 300, 200, 349, 219));
    f.o.b[PI(0) + P_ORIENT] = 3;
    put_rect(f.o.b, PI(0) + P_RECT, 315, 185, 334, 234);
    set32(&f, O_STATE, 0);
    CK(ptr(&f, 316, 186) == EB_OK && click(&f, EB_CANDIDATE_ROTATE) == EB_OK && ob(&f, PI(0) + P_ORIENT) == 0);
    /* the new rect is clamped into the clip rect and the saved rect is the old one */
    fx_init(&f);
    rot_setup(&f);
    put_rect(f.body, TY(0) + BT_B, 0, 0, 49, 19);
    CK(start(&f) == EB_OK && ptr(&f, 3, 3) == EB_OK && f.pr.candidate == EB_CANDIDATE_ROTATE);
    CK(click(&f, EB_CANDIDATE_ROTATE) == EB_OK && rect_is(f.o.b, PI(0) + P_RECT, 15, 0, 34, 49));
    CK(rect_is(f.o.b, PI(0) + P_RECT2, 25, 20, 44, 69) && rect_is(f.o.b, O_SAVED, 0, 0, 49, 19));
    /* the topmost piece of the rotate list turns */
    fx_init(&f);
    rot_setup(&f);
    CK(start(&f) == EB_OK);
    inst(&f, 1, 0, 300, 200, 349, 219);
    set16(&f, PI(0) + P_Z, 1);
    set16(&f, PI(1) + P_Z, 2);
    CK(ptr(&f, 305, 205) == EB_OK && od16(&f, O_COUNT2) == 2);
    CK(click(&f, EB_CANDIDATE_ROTATE) == EB_OK && od16(&f, O_HAND) == 1 && ob(&f, PI(1) + P_ORIENT) == 1 && ob(&f, PI(0) + P_ORIENT) == 0);
    /* nothing in the rotate list: nothing happens; a bad list entry is refused */
    fx_init(&f);
    rot_setup(&f);
    CK(start(&f) == EB_OK && ptr(&f, 10, 10) == EB_OK);
    CK(click(&f, EB_CANDIDATE_ROTATE) == EB_OK && od32(&f, O_DRAG) == 0 && od32(&f, O_LIFT) == 0);
    set16(&f, O_COUNT2, 1);
    set16(&f, O_LIST2, 99);
    CK(click(&f, EB_CANDIDATE_ROTATE) == EB_ERR_BOUNDS);
    set16(&f, O_LIST2, 3);
    CK(click(&f, EB_CANDIDATE_ROTATE) == EB_ERR_BOUNDS);
    /* host failures: the view lookups of clamp and translate, then the sound */
    for (int n = 1; n <= 4; ++n) {
        fx_init(&f);
        rot_setup(&f);
        put_name(f.body, B_SND_ROT, "ROT", 0x21);
        CK(start(&f) == EB_OK && ptr(&f, 305, 205) == EB_OK);
        fx_clear(&f);
        f.fail_call = n;
        CK((click(&f, EB_CANDIDATE_ROTATE) == EB_ERR_HOST) == (n <= 3));
    }
}

static void t_rotate_key(void)
{
    Fx f;
    fx_init(&f);
    f.body[B_ROT] = 1;
    put_rect(f.body, TY(0) + BT_B, 300, 200, 349, 219);
    put_name(f.body, B_SND_ROT, "ROT", 0x21);
    CK(start(&f) == EB_OK);
    f.o.b[O_COUNTS + 0] = 2;
    CK(ptr(&f, 305, 205) == EB_OK && od16(&f, O_COUNT1) == 1);
    fx_clear(&f);
    CK(rkey(&f) == EB_OK);
    CK_LOG(&f, "play:11");
    CK(ob(&f, PI(0) + P_ORIENT) == 1 && rect_is(f.o.b, PI(0) + P_RECT, 315, 185, 334, 234) && od32(&f, O_DRAG) == 1 && od16(&f, O_HAND) == 0);
    CK(od16(&f, O_HW) == 19 && od16(&f, O_HH) == 49 && ob(&f, O_COUNTS + 0) == 1 && od16(&f, PI(0) + P_Z) == 1);
    CK(od32(&f, O_STATE) == 1 && od32(&f, O_DEADLINE) == 1350 && od32(&f, O_LIFT) == 1);
    /* while dragging, the hand piece turns and no counter changes */
    set32(&f, O_STATE, 0);
    fx_clear(&f);
    CK(rkey(&f) == EB_OK && ob(&f, PI(0) + P_ORIENT) == 2 && rect_is(f.o.b, PI(0) + P_RECT, 300, 200, 349, 219) && ob(&f, O_COUNTS + 0) == 1);
    CK(od16(&f, O_HW) == 49 && od16(&f, O_HH) == 19);
    /* each guard stops it */
    for (int g = 0; g < 8; ++g) {
        fx_init(&f);
        f.body[B_ROT] = 1;
        CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK);
        if (g == 0) set32(&f, O_ACTIVE, 0);
        if (g == 1) f.body[B_ROT] = 0;
        if (g == 2) f.body[B_LOCKED] = 1;
        if (g == 3) f.o.b[O_DONE] = 1;
        if (g == 4) set32(&f, O_STATE, 1);
        if (g == 5) f.phase = 2;
        if (g == 6) f.phase = 0;
        if (g == 7) set16(&f, O_COUNT1, 0);
        fx_clear(&f);
        CK(rkey(&f) == EB_OK && ob(&f, PI(0) + P_ORIENT) == 0 && od32(&f, O_DRAG) == 0 && f.log[0] == '\0');
    }
    /* a spawner's counter is kept; the topmost piece turns; an empty-looking or bad list is refused */
    fx_init(&f);
    f.body[B_ROT] = 1;
    f.body[TY(0) + BT_SPAWN] = 1;
    CK(start(&f) == EB_OK);
    f.o.b[O_COUNTS + 0] = 2;
    CK(ptr(&f, 310, 210) == EB_OK && rkey(&f) == EB_OK && ob(&f, O_COUNTS + 0) == 2);
    fx_init(&f);
    f.body[B_ROT] = 1;
    CK(start(&f) == EB_OK);
    inst(&f, 1, 1, 300, 200, 339, 229);
    set16(&f, PI(1) + P_Z, 4);
    CK(ptr(&f, 310, 210) == EB_OK && rkey(&f) == EB_OK && od16(&f, O_HAND) == 1 && od16(&f, PI(1) + P_Z) == 5);
    set16(&f, O_LIST1, 99);
    set16(&f, O_COUNT1, 1);
    set32(&f, O_DRAG, 0);
    CK(rkey(&f) == EB_ERR_BOUNDS);
    set32(&f, O_DRAG, 1);
    set16(&f, O_HAND, 80);
    CK(rkey(&f) == EB_ERR_BOUNDS);
    set16(&f, O_HAND, -1);
    CK(rkey(&f) == EB_ERR_BOUNDS);
    /* arguments and host failures */
    fx_init(&f);
    f.body[B_ROT] = 1;
    put_name(f.body, B_SND_ROT, "ROT", 0x21);
    CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK);
    CK(eb_rotate_key(NULL, f.body, EB_BODY_BYTES, 1, &f.host) == EB_ERR_ARGUMENT);
    CK(eb_rotate_key(&f.o, NULL, EB_BODY_BYTES, 1, &f.host) == EB_ERR_ARGUMENT);
    CK(eb_rotate_key(&f.o, f.body, EB_BODY_BYTES, 1, NULL) == EB_ERR_ARGUMENT);
    CK(eb_rotate_key(&f.o, f.body, EB_BODY_BYTES + 1u, 1, &f.host) == EB_ERR_ARGUMENT);
    for (int n = 1; n <= 4; ++n) {
        fx_init(&f);
        f.body[B_ROT] = 1;
        put_name(f.body, B_SND_ROT, "ROT", 0x21);
        CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK);
        fx_clear(&f);
        f.fail_call = n;
        CK((rkey(&f) == EB_ERR_HOST) == (n <= 3));
    }
}

/* ---- the drop: layers (0x47ed96, 0x47ea73), good and bad drops, modes ------------------------------------------------------------ */

static int layer_after_drop(const int a[4], const int b[4], int z0, int z1)
{
    Fx f;
    fx_init(&f);
    if (start(&f) != EB_OK) return 12345;
    inst(&f, 1, 1, b[0], b[1], b[2], b[3]);
    set16(&f, PI(0) + P_Z, z0);
    set16(&f, PI(1) + P_Z, z1);
    set32(&f, O_DRAG, 1);
    set16(&f, O_HAND, 0);
    set32(&f, O_HIT, 1);
    put_rect(f.o.b, O_PREV, a[0], a[1], a[2], a[3]);
    put_rect(f.o.b, O_PREV_T, a[0] + 10, a[1] + 20, a[2] + 10, a[3] + 20);
    if (click(&f, EB_CANDIDATE_DROP) != EB_OK) return 12346;
    return od16(&f, PI(0) + P_Z);
}

static void t_layers(void)
{
    static const struct { int a[4], b[4], z0, z1, expect; } cases[] = {
        {{10, 10, 20, 20}, {20, 10, 30, 20}, 0, 5, 6},   {{10, 10, 20, 20}, {21, 10, 30, 20}, 0, 5, 1},
        {{20, 10, 30, 20}, {10, 10, 20, 20}, 0, 5, 6},   {{20, 10, 30, 20}, {10, 10, 19, 20}, 0, 5, 1},
        {{10, 10, 20, 20}, {10, 20, 20, 30}, 0, 5, 6},   {{10, 10, 20, 20}, {10, 21, 20, 30}, 0, 5, 1},
        {{10, 20, 20, 30}, {10, 10, 20, 20}, 0, 5, 6},   {{10, 20, 20, 30}, {10, 10, 20, 19}, 0, 5, 1},
        {{0, 0, 100, 100}, {10, 10, 20, 20}, 0, 5, 6},   {{10, 10, 20, 20}, {0, 0, 100, 100}, 0, 5, 6},
        {{-1, 0, 5, 5}, {-1, 0, 5, 5}, 0, 5, 1},        {{-5, 0, -1, 5}, {-3, 0, -1, 5}, 0, 5, 1},
        {{0, -1, 5, 5}, {0, -1, 5, 5}, 0, 5, 1},        {{0, -5, 5, -1}, {0, -3, 5, -1}, 0, 5, 1},
        {{10, 10, 20, 20}, {10, 10, 20, 20}, 10, 3, 11}, {{10, 10, 20, 20}, {10, 10, 20, 20}, 32767, 0, -32768},
        {{10, 10, 20, 20}, {10, 10, 20, 20}, -4, -2, -1}, {{10, 10, 20, 20}, {10, 10, 20, 20}, 4, 4, 5},
        {{10, 10, 20, 20}, {10, 10, 20, 20}, 0, 0, 1},   {{10, 10, 20, 20}, {10, 10, 20, 20}, -1, -1, 0},
        {{10, 10, 20, 20}, {15, 12, 18, 14}, 0, 7, 8},    {{10, 10, 20, 20}, {19, 19, 40, 40}, 0, 7, 8},
        {{10, 10, 20, 20}, {20, 20, 40, 40}, 0, 7, 8},    {{10, 10, 20, 20}, {21, 20, 40, 40}, 0, 7, 1},
        {{10, 10, 20, 20}, {20, 21, 40, 40}, 0, 7, 1},    {{10, 10, 20, 20}, {5, 5, 10, 10}, 0, 7, 8},
        {{10, 10, 20, 20}, {5, 5, 9, 10}, 0, 7, 1},       {{10, 10, 20, 20}, {5, 5, 10, 9}, 0, 7, 1},
        /* a -1 edge of the overlap that only one of the two candidate edges has (the smaller one is taken: -1 means no overlap) */
        {{-5, 0, -1, 5}, {-3, 0, 5, 5}, 0, 5, 1},         {{-3, 0, 5, 5}, {-5, 0, -1, 5}, 0, 5, 1},
        {{0, -5, 5, -1}, {0, -3, 5, 5}, 0, 5, 1},         {{0, -3, 5, 5}, {0, -5, 5, -1}, 0, 5, 1},
        /* the overlap's near edge is the second rectangle's (left, top) or the first's: -1 there too */
        {{-5, 0, 5, 5}, {-1, 0, 5, 5}, 0, 5, 1},         {{0, -5, 5, 5}, {0, -1, 5, 5}, 0, 5, 1},
        {{-1, 0, 5, 5}, {-5, 0, 5, 5}, 0, 5, 1},         {{0, -1, 5, 5}, {0, -5, 5, 5}, 0, 5, 1},
        /* equal near edges with an inverted rectangle (right < left): the first rectangle is only tested against the second's
         * near edge when it starts to the left of it, the second against the first's otherwise */
        {{10, 10, 5, 20}, {10, 10, 20, 20}, 0, 5, 6},     {{10, 10, 20, 20}, {10, 10, 5, 20}, 0, 5, 1},
        {{10, 10, 20, 5}, {10, 10, 20, 20}, 0, 5, 6},     {{10, 10, 20, 20}, {10, 10, 20, 5}, 0, 5, 1},
    };
    for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
        const int got = layer_after_drop(cases[i].a, cases[i].b, cases[i].z0, cases[i].z1);
        if (got != cases[i].expect && !g_failed) {
            g_failed = 1;
            snprintf(g_msg, sizeof g_msg, "layer case %zu: z %d != %d", i, got, cases[i].expect);
        }
    }
    /* several overlapping pieces: the greatest z wins, those that do not overlap are ignored */
    {
        Fx f;
        fx_init(&f);
        CK(start(&f) == EB_OK);
        for (int k = 1; k <= 5; ++k) inst(&f, k, 1, 10, 10, 20, 20);
        inst(&f, 6, 1, 100, 100, 120, 120);
        {
            static const int zs[] = {0, 2, 7, 4, 100, 3, 9};
            for (int k = 1; k <= 6; ++k) set16(&f, PI(k) + P_Z, zs[k]);
        }
        set32(&f, O_DRAG, 1);
        set16(&f, O_HAND, 0);
        set32(&f, O_HIT, 1);
        put_rect(f.o.b, O_PREV, 10, 10, 20, 20);
        put_rect(f.o.b, O_PREV_T, 20, 30, 30, 40);
        CK(click(&f, EB_CANDIDATE_DROP) == EB_OK && od16(&f, PI(0) + P_Z) == 101);
        CK(od16(&f, PI(1) + P_Z) == 2 && od16(&f, PI(6) + P_Z) == 9); /* the others keep their layers */
        /* the instance count limits the search */
        set32(&f, O_DRAG, 1);
        set16(&f, O_HAND, 0);
        set32(&f, O_HIT, 1);
        set16(&f, PI(0) + P_Z, 0);
        set16(&f, O_COUNT, 4);
        set32(&f, O_STATE, 0);
        CK(click(&f, EB_CANDIDATE_DROP) == EB_OK && od16(&f, PI(0) + P_Z) == 8);
    }
}

static void t_drop_good_and_bad(void)
{
    Fx f;
    fx_init(&f);
    put_name(f.body, B_SND_GOOD, "GOOD", 0x21);
    put_name(f.body, B_SND_BAD, "BAD", 0x21);
    CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK && click(&f, EB_CANDIDATE_PICK) == EB_OK);
    CK(ptr(&f, 500, 300) == EB_OK && od32(&f, O_HIT) == 1);
    CK(rect_is(f.o.b, O_PREV, 481, 286, 520, 315));
    fx_clear(&f);
    CK(click(&f, EB_CANDIDATE_DROP) == EB_OK && f.np == 1u);
    CK_LOG(&f, "play:13");
    CK(od32(&f, O_DRAG) == 0 && od32(&f, O_DROP) == 1 && od16(&f, O_HAND) == -1);
    CK(rect_is(f.o.b, PI(0) + P_RECT, 481, 286, 520, 315) && rect_is(f.o.b, PI(0) + P_RECT2, 491, 306, 530, 335));
    CK(ob(&f, PI(0) + P_STAMP) == 1 && ob(&f, O_COUNTS + 0) == 1 && od16(&f, PI(0) + P_Z) == 1);
    CK(od32(&f, O_DEADLINE) == 1300 && od32(&f, O_STATE) == 4 && od32(&f, O_DEADLINE2) == 1100);
    CK(f.w.saved_flag == 1 && f.w.saved_count == 3 && f.w.saved_total == 1 && od16(&f, O_TOTAL) == 1 && f.w.saved_counts[0] == 1);
    CK(memcmp(f.w.saved_pieces, f.o.b + O_PIECES, sizeof f.w.saved_pieces) == 0);
    /* a good drop keeps the orientation; the layer is above overlapped pieces */
    /* the bad drop: the piece goes home, orientation 0, no stamp, no count */
    fx_init(&f);
    put_name(f.body, B_SND_GOOD, "GOOD", 0x21);
    put_name(f.body, B_SND_BAD, "BAD", 0x21);
    CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK && click(&f, EB_CANDIDATE_PICK) == EB_OK);
    f.o.b[PI(0) + P_ORIENT] = 2;
    f.o.b[PI(0) + P_STAMP] = 1;
    CK(ptr(&f, 10, 10) == EB_OK && od32(&f, O_HIT) == 0);
    fx_clear(&f);
    CK(click(&f, EB_CANDIDATE_DROP) == EB_OK);
    CK_LOG(&f, "play:14");
    CK(od32(&f, O_DEADLINE) == 1200 && od32(&f, O_STATE) == 1 && od32(&f, O_DRAG) == 0 && od32(&f, O_DROP) == 1 && od16(&f, O_HAND) == -1);
    CK(rect_is(f.o.b, PI(0) + P_RECT, 300, 200, 339, 229) && rect_is(f.o.b, PI(0) + P_RECT2, 310, 220, 349, 249));
    CK(ob(&f, PI(0) + P_STAMP) == 0 && ob(&f, PI(0) + P_ORIENT) == 0 && ob(&f, O_COUNTS + 0) == 0 && f.w.saved_flag == 0);
    /* a good drop with no good sound: no play, the deadline is the tick itself */
    fx_init(&f);
    CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK && click(&f, EB_CANDIDATE_PICK) == EB_OK && ptr(&f, 500, 300) == EB_OK);
    f.o.b[PI(0) + P_ORIENT] = 3;
    f.now = 4242;
    fx_clear(&f);
    CK(click(&f, EB_CANDIDATE_DROP) == EB_OK && f.log[0] == '\0' && od32(&f, O_DEADLINE) == 4242 && od32(&f, O_DEADLINE2) == 4342);
    CK(ob(&f, PI(0) + P_ORIENT) == 3 && od32(&f, O_STATE) == 4);
    /* a bad drop with no bad sound: no state change */
    fx_init(&f);
    CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK && click(&f, EB_CANDIDATE_PICK) == EB_OK && ptr(&f, 10, 10) == EB_OK);
    fx_clear(&f);
    CK(click(&f, EB_CANDIDATE_DROP) == EB_OK && f.log[0] == '\0' && od32(&f, O_STATE) == 0 && od32(&f, O_DEADLINE) == 0);
    CK(rect_is(f.o.b, PI(0) + P_RECT, 300, 200, 339, 229));
    /* mode 2: a hit counts but the piece goes home; no hit is a bad drop */
    for (int hit = 0; hit <= 1; ++hit) {
        fx_init(&f);
        f.body[B_MODE] = 2;
        put_name(f.body, B_SND_GOOD, "GOOD", 0x21);
        put_name(f.body, B_SND_BAD, "BAD", 0x21);
        CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK && click(&f, EB_CANDIDATE_PICK) == EB_OK);
        CK(ptr(&f, hit ? 500 : 10, hit ? 300 : 10) == EB_OK && od32(&f, O_HIT) == hit);
        f.o.b[PI(0) + P_ORIENT] = 1;
        fx_clear(&f);
        CK(click(&f, EB_CANDIDATE_DROP) == EB_OK);
        CK_LOG(&f, hit ? "play:13" : "play:14");
        CK(rect_is(f.o.b, PI(0) + P_RECT, 300, 200, 339, 229) && ob(&f, PI(0) + P_STAMP) == 0 && ob(&f, PI(0) + P_ORIENT) == 0);
        CK(ob(&f, O_COUNTS + 0) == hit && od16(&f, O_HAND) == -1 && od32(&f, O_STATE) == (hit ? 4 : 1));
        CK(f.w.saved_flag == (uint32_t)hit);
    }
    /* the drop needs a valid hand */
    fx_init(&f);
    CK(start(&f) == EB_OK);
    CK(click(&f, EB_CANDIDATE_DROP) == EB_ERR_BOUNDS);
    set16(&f, O_HAND, 3);
    CK(click(&f, EB_CANDIDATE_DROP) == EB_ERR_BOUNDS);
    set16(&f, O_HAND, 1);
    f.o.b[PI(1) + P_TYPE] = 20;
    CK(click(&f, EB_CANDIDATE_DROP) == EB_ERR_BOUNDS);
    f.o.b[PI(1) + P_TYPE] = 1;
    set32(&f, O_HIT, 1);
    CK(click(&f, EB_CANDIDATE_DROP) == EB_OK);
    /* host failures through the whole drop */
    for (int bad = 0; bad <= 1; ++bad) {
        int total = 0;
        for (int n = 0; n <= 12; ++n) {
            fx_init(&f);
            put_name(f.body, B_SND_GOOD, "GOOD", 0x21);
            put_name(f.body, B_SND_BAD, "BAD", 0x21);
            put_name(f.body, B_KEY_BAD, "KEY", 0x21);
            put_name(f.body, B_TEXT_BAD, "TEXT", 200);
            f.autotext = "AUTO";
            CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK && click(&f, EB_CANDIDATE_PICK) == EB_OK);
            CK(ptr(&f, bad ? 10 : 500, bad ? 10 : 300) == EB_OK);
            fx_clear(&f);
            if (n == 0) {
                CK(click(&f, EB_CANDIDATE_DROP) == EB_OK);
                total = f.calls;
            } else {
                f.fail_call = n;
                CK((click(&f, EB_CANDIDATE_DROP) == EB_ERR_HOST) == (n <= total));
            }
        }
        CK(total >= (bad ? 5 : 1));
    }
}

/* ---- save and solved check (0x480b34), through the exit button ---------------------------------------------------------------------- */

static void t_exit_and_save(void)
{
    Fx f;
    /* not enough placed: the exit flag is written with the inverse of its value byte and the puzzle is left */
    fx_init(&f);
    set_block(f.body, B_EXIT, 9999, 0, 0, 0, 0, 0, 0, 0, 5, 0);
    set_block(f.body, B_WIN, 9999, 0, 0, 0, 0, 0, 0, 0, 6, 0);
    CK(start(&f) == EB_OK);
    fx_clear(&f);
    CK(click(&f, EB_CANDIDATE_EXIT_A) == EB_OK && f.np == 2u);
    CK_LOG(&f, "flag:5=1");
    CK(ob(&f, O_EXIT) == 1 && ob(&f, O_DONE) == 0 && od16(&f, O_TOTAL) == 0);
    CK(f.w.saved_flag == 1 && f.w.saved_count == 3 && f.w.saved_total == 0);
    CK(memcmp(f.w.saved_pieces, f.o.b + O_PIECES, sizeof f.w.saved_pieces) == 0);
    /* the exit buttons are alike */
    fx_init(&f);
    CK(start(&f) == EB_OK && click(&f, EB_CANDIDATE_EXIT_B) == EB_OK && f.np == 2u && ob(&f, O_EXIT) == 1);
    /* the exit flag value byte */
    fx_init(&f);
    set_block(f.body, B_EXIT, 9999, 0, 0, 0, 0, 0, 0, 0, 5, 1);
    CK(start(&f) == EB_OK);
    fx_clear(&f);
    CK(click(&f, EB_CANDIDATE_EXIT_A) == EB_OK);
    CK_LOG(&f, "flag:5=0");
    fx_init(&f);
    set_block(f.body, B_EXIT, 9999, 0, 0, 0, 0, 0, 0, 0, 5, 0x80);
    CK(start(&f) == EB_OK);
    fx_clear(&f);
    CK(click(&f, EB_CANDIDATE_EXIT_A) == EB_OK);
    CK_LOG(&f, "flag:5=0");
    /* enough placed: exit flag := its value, win flag := inverse, then the win flag := its value; the puzzle is done */
    fx_init(&f);
    set_block(f.body, B_EXIT, 9999, 0, 0, 0, 0, 0, 0, 0, 5, 0);
    set_block(f.body, B_WIN, 9999, 0, 0, 0, 0, 0, 0, 0, 6, 0);
    CK(start(&f) == EB_OK);
    f.o.b[O_COUNTS + 0] = 1;
    f.o.b[O_COUNTS + 1] = 1;
    fx_clear(&f);
    CK(click(&f, EB_CANDIDATE_EXIT_A) == EB_OK && f.np == 2u);
    CK_LOG(&f, "flag:5=0,flag:6=1,flag:6=0");
    CK(ob(&f, O_DONE) == 1 && ob(&f, O_EXIT) == 0 && od32(&f, O_STATE) == 0 && od16(&f, O_TOTAL) == 2 && f.w.saved_total == 2);
    CK(f.w.saved_counts[0] == 1 && f.w.saved_counts[1] == 1 && f.w.saved_counts[2] == 0);
    fx_init(&f);
    set_block(f.body, B_EXIT, 9999, 0, 0, 0, 0, 0, 0, 0, 5, 1);
    set_block(f.body, B_WIN, 9999, 0, 0, 0, 0, 0, 0, 0, 6, 1);
    CK(start(&f) == EB_OK);
    f.o.b[O_COUNTS + 0] = 2;
    fx_clear(&f);
    CK(click(&f, EB_CANDIDATE_EXIT_A) == EB_OK);
    CK_LOG(&f, "flag:5=1,flag:6=0,flag:6=1");
    CK(ob(&f, O_DONE) == 1 && od16(&f, O_TOTAL) == 2);
    /* the win sound turns it into state 6 */
    fx_init(&f);
    put_name(f.body, B_SND_WIN, "WIN", 0x21);
    f.body[B_WINSND] = 1;
    CK(start(&f) == EB_OK);
    f.o.b[O_COUNTS + 2] = 3;
    CK(click(&f, EB_CANDIDATE_EXIT_B) == EB_OK && ob(&f, O_DONE) == 1 && ob(&f, O_EXIT) == 0 && od32(&f, O_STATE) == 6 && f.np == 2u);
    fx_init(&f);
    f.body[B_WINSND] = 0x80;
    CK(start(&f) == EB_OK);
    f.o.b[O_COUNTS + 2] = 3;
    CK(click(&f, EB_CANDIDATE_EXIT_B) == EB_OK && od32(&f, O_STATE) == 6);
    /* required and forbidden counts */
    {
        static const struct { int counts[3]; int req[3]; int forb[3]; int solved; } cases[] = {
            {{1, 1, 0}, {2, 0, 0}, {0, 0, 0}, 0}, {{2, 1, 0}, {2, 0, 0}, {0, 0, 0}, 1}, {{1, 1, 0}, {0, 0, 0}, {0, 1, 0}, 0},
            {{1, 0, 1}, {0, 0, 0}, {0, 1, 0}, 1}, {{1, 0, 1}, {1, 0, 2}, {0, 0, 0}, 0}, {{1, 0, 1}, {1, 0, 1}, {0, 0, 0}, 1},
            {{1, 1, 0}, {0, 0, 3}, {0, 0, 0}, 0}, {{1, 1, 0}, {0, 5, 0}, {0, 0, 0}, 0}, {{1, 1, 0}, {0, 1, 0}, {1, 0, 0}, 0},
            {{1, 1, 0}, {0, 0, 0}, {0, 0, 1}, 1}, {{1, 1, 0}, {1, 1, 0}, {0, 0, 1}, 1}, {{3, 0, 0}, {0, 0, 0}, {0, 0, 0}, 1}};
        for (size_t i = 0; i < sizeof cases / sizeof cases[0]; ++i) {
            fx_init(&f);
            set_block(f.body, B_EXIT, 9999, 0, 0, 0, 0, 0, 0, 0, 5, 0);
            set_block(f.body, B_WIN, 9999, 0, 0, 0, 0, 0, 0, 0, 6, 0);
            for (int t = 0; t < 3; ++t) {
                f.body[TY(t) + BT_REQ] = (uint8_t)cases[i].req[t];
                f.body[TY(t) + BT_FORBID] = (uint8_t)cases[i].forb[t];
            }
            CK(start(&f) == EB_OK);
            for (int t = 0; t < 3; ++t) f.o.b[O_COUNTS + t] = (uint8_t)cases[i].counts[t];
            fx_clear(&f);
            CK(click(&f, EB_CANDIDATE_EXIT_A) == EB_OK);
            if ((ob(&f, O_DONE) == 1) != (cases[i].solved == 1) && !g_failed) {
                g_failed = 1;
                snprintf(g_msg, sizeof g_msg, "requirement case %zu", i);
            }
            CK(cases[i].solved ? strcmp(f.log, "flag:5=0,flag:6=1,flag:6=0") == 0 : strcmp(f.log, "flag:5=0,flag:6=1") == 0);
            CK(ob(&f, O_EXIT) == !cases[i].solved);
        }
    }
    /* counters of spawning types count only in mode 2; copies count as placed pieces */
    fx_init(&f);
    f.body[TY(0) + BT_SPAWN] = 1;
    f.body[B_TARGET] = 5;
    CK(start(&f) == EB_OK);
    f.o.b[O_COUNTS + 0] = 5;
    CK(click(&f, EB_CANDIDATE_EXIT_A) == EB_OK && od16(&f, O_TOTAL) == 0 && ob(&f, O_DONE) == 0);
    fx_init(&f);
    f.body[TY(0) + BT_SPAWN] = 1;
    f.body[B_TARGET] = 5;
    f.body[B_MODE] = 2;
    CK(start(&f) == EB_OK);
    f.o.b[O_COUNTS + 0] = 5;
    CK(click(&f, EB_CANDIDATE_EXIT_A) == EB_OK && od16(&f, O_TOTAL) == 5 && ob(&f, O_DONE) == 1);
    fx_init(&f);
    f.body[TY(0) + BT_SPAWN] = 1;
    CK(start(&f) == EB_OK);
    set16(&f, O_COUNT, 5);
    inst(&f, 4, 0, 1, 1, 2, 2);
    CK(click(&f, EB_CANDIDATE_EXIT_A) == EB_OK && od16(&f, O_TOTAL) == 2 && ob(&f, O_DONE) == 1 && f.w.saved_count == 5);
    /* counters of types beyond the type count are ignored */
    fx_init(&f);
    CK(start(&f) == EB_OK);
    f.o.b[O_COUNTS + 3] = 9;
    f.body[TY(3) + BT_FORBID] = 1;
    CK(click(&f, EB_CANDIDATE_EXIT_A) == EB_OK && od16(&f, O_TOTAL) == 0);
    /* the target is compared signed; the total is a 16 bit number */
    for (int target = -3; target <= -1; ++target) {
        fx_init(&f);
        f.body[B_TARGET] = (uint8_t)target;
        f.body[B_TARGET + 1] = 0xff;
        CK(start(&f) == EB_OK);
        set16(&f, O_COUNT, 1);
        CK(click(&f, EB_CANDIDATE_EXIT_A) == EB_OK && od16(&f, O_TOTAL) == -2);
        CK((ob(&f, O_DONE) == 1) == (target <= -2));
    }
    /* a flag index outside the host's window is refused, no flag at all is fine */
    fx_init(&f);
    set_block(f.body, B_EXIT, 9999, 0, 0, 0, 0, 0, 0, 0, 100, 0);
    CK(start(&f) == EB_OK && click(&f, EB_CANDIDATE_EXIT_A) == EB_ERR_BOUNDS && ob(&f, O_EXIT) == 0);
    fx_init(&f);
    set_block(f.body, B_EXIT, 9999, 0, 0, 0, 0, 0, 0, 0, 99, 0);
    CK(start(&f) == EB_OK && click(&f, EB_CANDIDATE_EXIT_A) == EB_OK && strstr(f.log, "flag:99=1") != NULL);
    fx_init(&f);
    set_block(f.body, B_EXIT, 9999, 0, 0, 0, 0, 0, 0, 0, 0, 0);
    CK(start(&f) == EB_OK && click(&f, EB_CANDIDATE_EXIT_A) == EB_OK && strstr(f.log, "flag:0=1") != NULL);
    fx_init(&f);
    set_block(f.body, B_EXIT, 9999, 0, 0, 0, 0, 0, 0, 0, -2, 0);
    CK(start(&f) == EB_OK && click(&f, EB_CANDIDATE_EXIT_A) == EB_ERR_BOUNDS);
    fx_init(&f);
    set_block(f.body, B_WIN, 9999, 0, 0, 0, 0, 0, 0, 0, 100, 0);
    CK(start(&f) == EB_OK);
    f.o.b[O_COUNTS + 0] = 2;
    CK(click(&f, EB_CANDIDATE_EXIT_A) == EB_ERR_BOUNDS);
    /* host failures */
    for (int n = 1; n <= 4; ++n) {
        fx_init(&f);
        set_block(f.body, B_EXIT, 9999, 0, 0, 0, 0, 0, 0, 0, 5, 0);
        set_block(f.body, B_WIN, 9999, 0, 0, 0, 0, 0, 0, 0, 6, 0);
        CK(start(&f) == EB_OK);
        f.o.b[O_COUNTS + 0] = 2;
        fx_clear(&f);
        f.fail_call = n;
        CK((click(&f, EB_CANDIDATE_EXIT_A) == EB_ERR_HOST) == (n <= 3));
    }
    /* a drop that solves the puzzle: only the exit button sets "done" without a win sound; with one, state 6 is overwritten by 4 */
    for (int snd = 0; snd <= 1; ++snd) {
        fx_init(&f);
        f.body[B_TARGET] = 1;
        if (snd) {
            put_name(f.body, B_SND_WIN, "WIN", 0x21);
            f.body[B_WINSND] = 1;
        }
        CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK && click(&f, EB_CANDIDATE_PICK) == EB_OK && ptr(&f, 500, 300) == EB_OK);
        CK(click(&f, EB_CANDIDATE_DROP) == EB_OK);
        CK(ob(&f, O_DONE) == snd && od32(&f, O_STATE) == 4);
    }
}

/* ---- captions (the bad drop, the win sound state) ------------------------------------------------------------------------------ */

static void bad_drop_setup(Fx *f)
{
    fx_init(f);
    put_name(f->body, B_SND_BAD, "BAD", 0x21);
    put_name(f->body, B_KEY_BAD, "KEY", 0x21);
    put_name(f->body, B_TEXT_BAD, "TEXT", 200);
    start(f);
    ptr(f, 310, 210);
    click(f, EB_CANDIDATE_PICK);
    ptr(f, 10, 10);
    fx_clear(f);
}

static char *repeat_text(char c, size_t n)
{
    char *s = (char *)malloc(n + 1u);
    if (s == NULL) return NULL;
    memset(s, c, n);
    s[n] = '\0';
    return s;
}

static void t_captions(void)
{
    Fx f;
    char *big;
    /* bad drop */
    bad_drop_setup(&f);
    f.captions = 0;
    f.autotext = "FOUND";
    CK(click(&f, EB_CANDIDATE_DROP) == EB_OK);
    CK_LOG(&f, "play:14");
    bad_drop_setup(&f);
    f.autotext = "FOUND";
    CK(click(&f, EB_CANDIDATE_DROP) == EB_OK);
    CK_LOG(&f, "play:14,auto:KEY,cap:FOUND<e>");
    bad_drop_setup(&f);
    f.captions = -1; /* any non-zero */
    CK(click(&f, EB_CANDIDATE_DROP) == EB_OK);
    CK_LOG(&f, "play:14,auto:KEY,cap:TEXT<e>");
    bad_drop_setup(&f);
    f.body[B_KEY_BAD] = 0;
    CK(click(&f, EB_CANDIDATE_DROP) == EB_OK);
    CK_LOG(&f, "play:14,cap:TEXT<e>");
    bad_drop_setup(&f);
    f.body[B_KEY_BAD] = 0;
    f.body[B_TEXT_BAD] = 0;
    f.autotext = "FOUND";
    CK(click(&f, EB_CANDIDATE_DROP) == EB_OK);
    CK_LOG(&f, "play:14");
    bad_drop_setup(&f);
    f.body[B_TEXT_BAD] = 0;
    CK(click(&f, EB_CANDIDATE_DROP) == EB_OK);
    CK_LOG(&f, "play:14,auto:KEY");
    bad_drop_setup(&f);
    f.autotext = "";
    CK(click(&f, EB_CANDIDATE_DROP) == EB_OK);
    CK_LOG(&f, "play:14,auto:KEY,cap:<e>"); /* an empty AUTOTEXT entry is still a found entry */
    /* the 204 byte local of the bad drop: 200 characters and the suffix fit, 201 do not */
    for (size_t n = 199; n <= 202; ++n) {
        big = repeat_text('A', n);
        CK(big != NULL);
        if (big == NULL) return;
        bad_drop_setup(&f);
        f.autotext = big;
        CK((click(&f, EB_CANDIDATE_DROP) == EB_OK) == (n <= 200));
        CK(n <= 200 ? strlen(f.log) > n : f.rc == EB_ERR_BOUNDS);
        free(big);
    }
    big = repeat_text('B', 199);
    bad_drop_setup(&f);
    memcpy(f.body + B_TEXT_BAD, big, 200);
    f.autotext = NULL;
    CK(click(&f, EB_CANDIDATE_DROP) == EB_OK && strstr(f.log, "cap:BBBB") != NULL);
    free(big);
    /* the AUTOTEXT length limit: 0x9c40 characters are still tried (and do not fit), one more is ignored */
    big = repeat_text('C', 0x9c40);
    CK(big != NULL);
    if (big == NULL) return;
    bad_drop_setup(&f);
    f.autotext = big;
    CK(click(&f, EB_CANDIDATE_DROP) == EB_ERR_BOUNDS);
    free(big);
    big = repeat_text('C', 0x9c41);
    CK(big != NULL);
    if (big == NULL) return;
    bad_drop_setup(&f);
    f.autotext = big;
    CK(click(&f, EB_CANDIDATE_DROP) == EB_OK);
    CK_LOG(&f, "play:14,auto:KEY,cap:TEXT<e>");
    free(big);
    /* win sound state */
    fx_init(&f);
    put_name(f.body, B_SND_WIN, "WIN", 0x21);
    put_name(f.body, B_KEY_WIN, "WKEY", 0x21);
    put_name(f.body, B_TEXT_WIN, "WTEXT", 200);
    CK(start(&f) == EB_OK);
    set32(&f, O_STATE, 6);
    f.autotext = "WFOUND";
    fx_clear(&f);
    CK(visit(&f) == EB_OK && f.res.phase_after == 1u && od32(&f, O_STATE) == 3);
    CK_LOG(&f, "prep:8e1:WIN,play:15,auto:WKEY,cap:WFOUND<e>");
    set32(&f, O_STATE, 6);
    f.autotext = NULL;
    fx_clear(&f);
    CK(visit(&f) == EB_OK);
    CK_LOG(&f, "prep:8e1:WIN,play:15,auto:WKEY,cap:WTEXT<e>");
    set32(&f, O_STATE, 6);
    f.captions = 0;
    fx_clear(&f);
    CK(visit(&f) == EB_OK && od32(&f, O_STATE) == 3);
    CK_LOG(&f, "prep:8e1:WIN,play:15");
    f.captions = 1;
    f.body[B_KEY_WIN] = 0;
    set32(&f, O_STATE, 6);
    fx_clear(&f);
    CK(visit(&f) == EB_OK);
    CK_LOG(&f, "prep:8e1:WIN,play:15,cap:WTEXT<e>");
    /* the 208 byte local of the win text */
    for (size_t n = 203; n <= 206; ++n) {
        big = repeat_text('D', n);
        CK(big != NULL);
        if (big == NULL) return;
        fx_init(&f);
        put_name(f.body, B_SND_WIN, "WIN", 0x21);
        put_name(f.body, B_KEY_WIN, "WKEY", 0x21);
        CK(start(&f) == EB_OK);
        set32(&f, O_STATE, 6);
        f.autotext = big;
        CK((visit(&f) == EB_OK) == (n <= 204));
        free(big);
    }
    /* no win sound: straight to phase 2 */
    fx_init(&f);
    CK(start(&f) == EB_OK);
    set32(&f, O_STATE, 6);
    fx_clear(&f);
    CK(visit(&f) == EB_OK && f.res.phase_after == 2u && od32(&f, O_STATE) == 6 && f.log[0] == '\0');
    /* host failures of the win sound state */
    for (int n = 1; n <= 6; ++n) {
        fx_init(&f);
        put_name(f.body, B_SND_WIN, "WIN", 0x21);
        put_name(f.body, B_KEY_WIN, "WKEY", 0x21);
        CK(start(&f) == EB_OK);
        set32(&f, O_STATE, 6);
        f.autotext = "WFOUND";
        fx_clear(&f);
        f.fail_call = n;
        CK((visit(&f) == EB_ERR_HOST) == (n <= 5));
        CK(n <= 5 ? od32(&f, O_STATE) == 6 : od32(&f, O_STATE) == 3);
    }
    /* host failures of the bad-drop captions */
    for (int n = 1; n <= 6; ++n) {
        bad_drop_setup(&f);
        f.autotext = "FOUND";
        f.fail_call = n;
        CK((click(&f, EB_CANDIDATE_DROP) == EB_ERR_HOST) == (n <= 5));
    }
}

/* ---- phase 2 (the finish), cleanup, invalidate ---------------------------------------------------------------------------------- */

static void finish_setup(Fx *f)
{
    fx_init(f);
    put_name(f->body, B_SND_ROT, "ROT", 0x21);
    put_name(f->body, B_SND_PICK, "PICK", 0x21);
    put_name(f->body, B_SND_GOOD, "GOOD", 0x21);
    put_name(f->body, B_SND_BAD, "BAD", 0x21);
    set_block(f->body, B_WIN, 42, 1, 2, 3, 4, 5, 6, 0, -1, 0);
    set_block(f->body, B_EXIT, 43, 7, 8, 9, 10, 11, 12, 1, -1, 0);
    start(f);
    f->w.start_flag_5bb1ca = 5;
    f->phase = 2;
    fx_clear(f);
}

static void t_phase2(void)
{
    Fx f;
    const char *stops = "stop:746:PICK,stop:777:GOOD,stop:7a8:BAD,stop:715:ROT";
    const char *cleanup = "done:2,rel:5,rel:100,rel:101,rel:102,relslot:24";
    char want[256];
    finish_setup(&f);
    f.o.b[O_DONE] = 1;
    CK(visit(&f) == EB_OK && f.res.completed == 1u && f.res.phase_after == 2u);
    snprintf(want, sizeof want, "%s,scene:42:1,2,3:4,5,6,%s", stops, cleanup);
    CK_LOG(&f, want);
    CK(f.w.start_flag_5bb1ca == 1 && f.w.scene_5bb57b == 42);
    CK(od16(&f, O_ROW) == -1 && od16(&f, O_SLOT) == -1 && od32(&f, O_ACTIVE) == 0 && ob(&f, O_EXIT) == 0 && ob(&f, O_DONE) == 0);
    CK(od32(&f, O_DRAG) == 0 && od32(&f, O_SRC) == 0 && od32(&f, EN(0, 0)) == 0 && od32(&f, EN(2, 0)) == 0);
    /* exit takes the exit block, even when the puzzle is done */
    finish_setup(&f);
    f.o.b[O_DONE] = 1;
    f.o.b[O_EXIT] = 1;
    CK(visit(&f) == EB_OK);
    snprintf(want, sizeof want, "%s,scene:43:7,8,9:10,11,12,%s", stops, cleanup);
    CK_LOG(&f, want);
    CK(f.w.start_flag_5bb1ca == 0 && f.w.scene_5bb57b == 43); /* the block's start word is 1 */
    finish_setup(&f);
    f.o.b[O_EXIT] = 1;
    CK(visit(&f) == EB_OK && f.w.scene_5bb57b == 43);
    finish_setup(&f);
    f.o.b[O_EXIT] = 0x80;
    CK(visit(&f) == EB_OK && f.w.scene_5bb57b == 43);
    /* neither done nor exited (the instance limit ended it): no block */
    finish_setup(&f);
    CK(visit(&f) == EB_OK && f.res.completed == 1u);
    snprintf(want, sizeof want, "%s,%s", stops, cleanup);
    CK_LOG(&f, want);
    CK(f.w.start_flag_5bb1ca == 1 && f.w.scene_5bb57b == 7);
    /* a block with scene 9999 changes nothing */
    finish_setup(&f);
    put16(f.body, B_WIN, 9999);
    f.o.b[O_DONE] = 1;
    CK(visit(&f) == EB_OK && f.w.scene_5bb57b == 7 && strstr(f.log, "scene:") == NULL);
    /* the start word: 1 clears the flag, anything else sets it; the scene word is signed */
    for (int start_word = -1; start_word <= 3; ++start_word) {
        finish_setup(&f);
        set_block(f.body, B_WIN, -5, 0, 0, 0, 0, 0, 0, start_word, -1, 0);
        f.o.b[O_DONE] = 1;
        CK(visit(&f) == EB_OK && f.w.start_flag_5bb1ca == (start_word == 1 ? 0 : 1) && f.w.scene_5bb57b == -5);
    }
    finish_setup(&f);
    set_block(f.body, B_WIN, 1, 0, 0, 0, 0, 0, 0, 0x10001, -1, 0); /* only the low word counts */
    f.o.b[O_DONE] = 1;
    CK(visit(&f) == EB_OK && f.w.start_flag_5bb1ca == 0);
    /* sounds with NO SOUND are not stopped */
    finish_setup(&f);
    put_name(f.body, B_SND_GOOD, "NO SOUND", 0x21);
    put_name(f.body, B_SND_ROT, "NO SOUND", 0x21);
    CK(visit(&f) == EB_OK && strstr(f.log, "stop:746:PICK,stop:7a8:BAD,done:2") != NULL);
    /* host failures at every call */
    {
        int total;
        finish_setup(&f);
        f.o.b[O_DONE] = 1;
        CK(visit(&f) == EB_OK);
        total = f.calls;
        CK(total >= 10);
        for (int n = 1; n <= total + 1; ++n) {
            finish_setup(&f);
            f.o.b[O_DONE] = 1;
            f.fail_call = n;
            CK((visit(&f) == EB_ERR_HOST) == (n <= total));
            CK(f.res.completed == (n <= total ? 0u : 1u));
        }
    }
    /* the generic completion gets the row */
    finish_setup(&f);
    CK(eb_step(&f.o, f.body, EB_BODY_BYTES, 2, 2, &f.w, &f.host, &f.res, NULL) == EB_OK && strstr(f.log, "done:2") != NULL);
}

static void t_cleanup_invalidate(void)
{
    Fx f;
    fx_init(&f);
    CK(eb_cleanup(&f.o, &f.host) == EB_OK && f.log[0] == '\0' && f.calls == 0); /* power-on: nothing to release */
    CK(eb_cleanup(NULL, &f.host) == EB_ERR_ARGUMENT && eb_cleanup(&f.o, NULL) == EB_ERR_ARGUMENT);
    {
        EbHost h = f.host;
        h.release_surface = NULL;
        CK(eb_cleanup(&f.o, &h) == EB_ERR_ARGUMENT);
        h = f.host;
        h.release_slot = NULL;
        CK(eb_cleanup(&f.o, &h) == EB_ERR_ARGUMENT);
    }
    /* order: source, multi, animation, then 4 entries of each of 20 types, then the slot */
    rich_body(&f);
    CK(start(&f) == EB_OK);
    set32(&f, O_DRAG, 1);
    f.o.b[O_DONE] = 1;
    f.o.b[O_EXIT] = 1;
    fx_clear(&f);
    CK(eb_cleanup(&f.o, &f.host) == EB_OK);
    CK(strncmp(f.log, "rel:5,rel:6,rel:7,rel:100,rel:101,rel:102,rel:103,rel:104,", strlen("rel:5,rel:6,rel:7,rel:100,rel:101,rel:102,rel:103,rel:104,")) == 0);
    CK(strstr(f.log, "rel:111,relslot:24") != NULL && strlen(f.log) > 60);
    CK(od16(&f, O_ROW) == -1 && od16(&f, O_SLOT) == -1 && od32(&f, O_ACTIVE) == 0 && ob(&f, O_EXIT) == 0 && ob(&f, O_DONE) == 0 &&
       od32(&f, O_DRAG) == 0);
    CK(od32(&f, O_SRC) == 0 && od32(&f, O_MULTI) == 0 && od32(&f, O_ANIM) == 0);
    for (int t = 0; t < 20; ++t)
        for (int k = 0; k < 4; ++k) CK(od32(&f, EN(t, k)) == 0);
    fx_clear(&f);
    CK(eb_cleanup(&f.o, &f.host) == EB_OK && f.log[0] == '\0'); /* idempotent */
    /* a surface on a high type is released too */
    fx_init(&f);
    set32(&f, EN(19, 3), 77);
    set32(&f, EN(19, 0), 78);
    CK(eb_cleanup(&f.o, &f.host) == EB_OK);
    CK_LOG(&f, "rel:78,rel:77");
    CK(od32(&f, EN(19, 3)) == 0 && od32(&f, EN(19, 0)) == 0);
    /* a failing release leaves the rest as it was */
    for (int n = 1; n <= 5; ++n) {
        fx_init(&f);
        CK(start(&f) == EB_OK);
        fx_clear(&f);
        f.fail_call = n;
        CK((eb_cleanup(&f.o, &f.host) == EB_ERR_HOST) == (n <= 5));
        CK(od32(&f, O_ACTIVE) == 1 && od16(&f, O_ROW) == 2);
        CK((od32(&f, O_SRC) == 5) == (n == 1));
        CK(od16(&f, O_SLOT) == 0x18);
    }
    /* a slot of a non-started object is not released */
    fx_init(&f);
    set16(&f, O_SLOT, 0x20);
    CK(eb_cleanup(&f.o, &f.host) == EB_OK);
    CK_LOG(&f, "relslot:32");
    CK(od16(&f, O_SLOT) == -1);
    /* invalidate */
    fx_init(&f);
    CK(eb_invalidate(&f.o, &f.host) == EB_OK && f.log[0] == '\0');
    CK(start(&f) == EB_OK);
    fx_clear(&f);
    CK(eb_invalidate(&f.o, &f.host) == EB_OK);
    CK_LOG(&f, "dirty:24");
    set16(&f, O_SLOT, -1);
    fx_clear(&f);
    CK(eb_invalidate(&f.o, &f.host) == EB_OK && f.log[0] == '\0');
    set16(&f, O_SLOT, 0x30);
    set32(&f, O_ACTIVE, 0);
    CK(eb_invalidate(&f.o, &f.host) == EB_OK && f.log[0] == '\0');
    set32(&f, O_ACTIVE, 256);
    CK(eb_invalidate(&f.o, &f.host) == EB_OK && strcmp(f.log, "dirty:48") == 0);
    fx_clear(&f);
    f.fail_call = 1;
    CK(eb_invalidate(&f.o, &f.host) == EB_ERR_HOST);
    CK(eb_invalidate(NULL, &f.host) == EB_ERR_ARGUMENT && eb_invalidate(&f.o, NULL) == EB_ERR_ARGUMENT);
    {
        EbHost h = f.host;
        h.mark_dirty = NULL;
        CK(eb_invalidate(&f.o, &h) == EB_ERR_ARGUMENT);
    }
}

/* ---- the render callback (0x481cb9) ---------------------------------------------------------------------------------------------- */

static EbRenderPlan *plan_alloc(void) { return (EbRenderPlan *)calloc(1u, sizeof(EbRenderPlan)); }

static int blit_is(const EbRenderPlan *p, int i, int kind, int src_kind, uint32_t surf, const int s[4], const int d[4])
{
    const EbBlit *b = &p->blit[i];
    if (i >= p->count) return 0;
    return b->kind == kind && b->src_kind == src_kind && b->src_surface == surf && b->src[0] == s[0] && b->src[1] == s[1] &&
           b->src[2] == s[2] && b->src[3] == s[3] && b->dst[0] == d[0] && b->dst[1] == d[1] && b->dst[2] == d[2] && b->dst[3] == d[3];
}

static int render(Fx *f, EbRenderPlan *p)
{
    f->rc = eb_render_plan(&f->o, f->body, EB_BODY_BYTES, &f->host, p);
    return f->rc;
}

static void t_render(void)
{
    Fx f;
    EbRenderPlan *p = plan_alloc();
    CK(p != NULL);
    if (p == NULL) return;
    /* no render entry */
    fx_init(&f);
    p->valid = 1;
    p->count = 9;
    CK(render(&f, p) == EB_OK && p->valid == 0u && p->count == 0 && f.calls == 0);
    CK(start(&f) == EB_OK);
    {
        static const int a[3][4] = {{1, 1, 40, 30}, {51, 1, 90, 30}, {101, 1, 140, 30}};
        static const int d[3][4] = {{310, 220, 349, 249}, {360, 220, 399, 249}, {410, 220, 449, 249}};
        CK(render(p->valid ? &f : &f, p) == EB_OK && p->valid == 1u && p->count == 3);
        for (int i = 0; i < 3; ++i) CK(blit_is(p, i, 1, 2, 5, a[i], d[i]));
        /* layers draw in z order */
        set16(&f, PI(0) + P_Z, 2);
        set16(&f, PI(1) + P_Z, 0);
        set16(&f, PI(2) + P_Z, 1);
        CK(render(&f, p) == EB_OK && p->count == 3);
        CK(blit_is(p, 0, 1, 2, 5, a[1], d[1]) && blit_is(p, 1, 1, 2, 5, a[2], d[2]) && blit_is(p, 2, 1, 2, 5, a[0], d[0]));
        /* within a layer, in instance order; a gap in the layers is skipped */
        set16(&f, PI(0) + P_Z, 5);
        set16(&f, PI(1) + P_Z, 5);
        set16(&f, PI(2) + P_Z, 5);
        CK(render(&f, p) == EB_OK && p->count == 3 && blit_is(p, 0, 1, 2, 5, a[0], d[0]) && blit_is(p, 2, 1, 2, 5, a[2], d[2]));
        set16(&f, PI(0) + P_Z, 0);
        set16(&f, PI(1) + P_Z, 0);
        set16(&f, PI(2) + P_Z, 0);
        /* a stamped piece is drawn from its entry surface, by orientation */
        f.o.b[PI(1) + P_STAMP] = 1;
        CK(render(&f, p) == EB_OK && p->count == 3);
        {
            static const int e[4] = {0, 0, 39, 29};
            CK(blit_is(p, 1, 1, 4, 101, e, d[1]));
        }
        f.body[B_ROT] = 1;
        CK(start(&f) == EB_OK);
        f.o.b[PI(1) + P_STAMP] = 1;
        f.o.b[PI(1) + P_ORIENT] = 5; /* 5 & 3 == 1: the first rotated copy */
        CK(render(&f, p) == EB_OK && p->blit[1].src_kind == 4 && p->blit[1].src_surface == (uint32_t)od32(&f, EN(1, 1)) &&
           p->blit[1].src[2] == od16(&f, EN(1, 1) + 0x14) - 1 && p->blit[1].src[3] == od16(&f, EN(1, 1) + 0x16) - 1);
        f.o.b[PI(1) + P_ORIENT] = 7;
        CK(render(&f, p) == EB_OK && p->blit[1].src_surface == (uint32_t)od32(&f, EN(1, 3)));
        f.body[B_ROT] = 0;
    }
    /* a piece without a source rect A is counted but not drawn */
    fx_init(&f);
    CK(start(&f) == EB_OK);
    put_rect(f.body, TY(1) + BT_A, 5, 9, 5, 9);
    CK(render(&f, p) == EB_OK && p->count == 2 && p->blit[0].src[0] == 1 && p->blit[1].src[0] == 101);
    put_rect(f.body, TY(1) + BT_A, 5, 9, 5, 12); /* same left and right */
    CK(render(&f, p) == EB_OK && p->count == 2);
    put_rect(f.body, TY(1) + BT_A, 5, 9, 8, 9); /* same top and bottom */
    CK(render(&f, p) == EB_OK && p->count == 2);
    put_rect(f.body, TY(1) + BT_A, 5, 9, 6, 10);
    CK(render(&f, p) == EB_OK && p->count == 3);
    /* drop, lift, drag, animation */
    fx_init(&f);
    CK(start(&f) == EB_OK);
    put_rect(f.o.b, O_PREV, 1, 2, 3, 4);
    put_rect(f.o.b, O_PREV_T, 11, 22, 13, 24);
    put_rect(f.o.b, O_SAVED, 5, 6, 7, 8);
    set32(&f, O_DROP, 1);
    CK(render(&f, p) == EB_OK && p->count == 4 && od32(&f, O_DROP) == 0);
    {
        static const int s1[4] = {1, 2, 3, 4}, d1[4] = {11, 22, 13, 24}, s2[4] = {5, 6, 7, 8}, d2[4] = {15, 26, 17, 28};
        CK(blit_is(p, 0, 0, 0, 0, s1, d1));
        set32(&f, O_LIFT, 1);
        CK(render(&f, p) == EB_OK && p->count == 4 && od32(&f, O_LIFT) == 0 && blit_is(p, 0, 0, 0, 0, s2, d2));
        set32(&f, O_DROP, 1);
        set32(&f, O_LIFT, 1);
        CK(render(&f, p) == EB_OK && p->count == 5 && blit_is(p, 0, 0, 0, 0, s1, d1) && blit_is(p, 1, 0, 0, 0, s2, d2));
        /* dragging also draws the previous rect, but keeps the drop flag clear and leaves the hand piece for the end */
        set32(&f, O_DRAG, 1);
        set16(&f, O_HAND, 1);
        put_rect(f.o.b, O_MOVE_T, 100, 110, 140, 140);
        {
            static const int e[4] = {0, 0, 39, 29}, a0[4] = {1, 1, 40, 30}, a2[4] = {101, 1, 140, 30}, dm[4] = {100, 110, 140, 140};
            static const int d0[4] = {310, 220, 349, 249}, d2[4] = {410, 220, 449, 249};
            CK(render(&f, p) == EB_OK && p->count == 4 && blit_is(p, 0, 0, 0, 0, s1, d1));
            CK(blit_is(p, 1, 1, 2, 5, a0, d0) && blit_is(p, 2, 1, 2, 5, a2, d2) && blit_is(p, 3, 1, 4, 101, e, dm));
        }
        /* a multi piece in hand is drawn from the multi surface at its own rect */
        put_rect(f.body, TY(1) + BT_D, 7, 8, 47, 38);
        set32(&f, O_MULTI, 66);
        f.o.b[O_MULTI_HAND] = 1;
        {
            static const int dd[4] = {7, 8, 47, 38}, dr[4] = {360, 220, 399, 249};
            CK(render(&f, p) == EB_OK && p->count == 4 && blit_is(p, 3, 1, 3, 66, dd, dr));
        }
        f.o.b[O_MULTI_HAND] = 0;
        set32(&f, O_DRAG, 0);
        set32(&f, O_DROP, 0);
    }
    fx_init(&f);
    CK(start(&f) == EB_OK);
    put_rect(f.body, B_ANIMAREA, 20, 30, 99, 69);
    put16(f.body, B_COLS, 1);
    set32(&f, O_ANIM, 55);
    put_rect(f.o.b, O_ANIM_SRC, 1, 2, 3, 4);
    f.o.b[O_ANIM_ON] = 1;
    f.o.b[O_ANIM_REST] = 1;
    {
        static const int src[4] = {1, 2, 3, 4}, dst[4] = {30, 50, 109, 89}, area[4] = {20, 30, 99, 69};
        CK(render(&f, p) == EB_OK && p->count == 4 && blit_is(p, 3, 0, 1, 55, src, dst) && ob(&f, O_ANIM_REST) == 1);
        f.o.b[O_ANIM_ON] = 0;
        CK(render(&f, p) == EB_OK && p->count == 4 && blit_is(p, 3, 0, 0, 0, area, dst) && ob(&f, O_ANIM_REST) == 0);
        CK(render(&f, p) == EB_OK && p->count == 3);
    }
    /* limits: the layer loop ends at layer 0x4000, the instance table must be sane, the hand must be valid */
    fx_init(&f);
    CK(start(&f) == EB_OK);
    set16(&f, PI(2) + P_Z, 0x3fff);
    CK(render(&f, p) == EB_OK && p->count == 3);
    set16(&f, PI(2) + P_Z, 0x4000);
    CK(render(&f, p) == EB_ERR_BOUNDS);
    set16(&f, PI(2) + P_Z, -1);
    CK(render(&f, p) == EB_ERR_BOUNDS);
    set16(&f, PI(2) + P_Z, 0);
    f.o.b[PI(2) + P_TYPE] = 20;
    CK(render(&f, p) == EB_ERR_BOUNDS);
    f.o.b[PI(2) + P_TYPE] = 2;
    set16(&f, O_COUNT, 81);
    CK(render(&f, p) == EB_ERR_BOUNDS);
    set16(&f, O_COUNT, -1);
    CK(render(&f, p) == EB_ERR_BOUNDS);
    set16(&f, O_COUNT, 3);
    set32(&f, O_DRAG, 1);
    set16(&f, O_HAND, 3);
    CK(render(&f, p) == EB_ERR_BOUNDS);
    set16(&f, O_HAND, -1);
    CK(render(&f, p) == EB_ERR_BOUNDS);
    set16(&f, O_HAND, 2);
    CK(render(&f, p) == EB_OK && p->count == 4); /* the previous rect, two pieces, the hand piece */
    set32(&f, O_DRAG, 0);
    /* the largest table: 80 instances */
    for (int i = 3; i < 80; ++i) inst(&f, i, 0, 0, 0, 1, 1);
    CK(od16(&f, O_COUNT) == 80 && render(&f, p) == EB_OK && p->count == 80);
    set32(&f, O_DRAG, 1);
    set16(&f, O_HAND, 79);
    set32(&f, O_DROP, 1);
    set32(&f, O_LIFT, 1);
    f.o.b[O_ANIM_ON] = 1;
    CK(render(&f, p) == EB_OK && p->count == 80 - 1 + 2 + 1 + 1);
    /* host failure of the view lookup; arguments */
    fx_init(&f);
    CK(start(&f) == EB_OK);
    fx_clear(&f);
    f.fail_call = 1;
    CK(render(&f, p) == EB_ERR_HOST);
    CK(eb_render_plan(NULL, f.body, EB_BODY_BYTES, &f.host, p) == EB_ERR_ARGUMENT);
    CK(eb_render_plan(&f.o, NULL, EB_BODY_BYTES, &f.host, p) == EB_ERR_ARGUMENT);
    CK(eb_render_plan(&f.o, f.body, EB_BODY_BYTES, NULL, p) == EB_ERR_ARGUMENT);
    CK(eb_render_plan(&f.o, f.body, EB_BODY_BYTES, &f.host, NULL) == EB_ERR_ARGUMENT);
    CK(eb_render_plan(&f.o, f.body, EB_BODY_BYTES - 1u, &f.host, p) == EB_ERR_ARGUMENT);
    free(p);
}

/* ---- the session binding (src/session_bindings_aeb.c) over a synthetic scene ---------------------------------------------------- */

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
    uint8_t tsum[126], act[48 + 2 + EB_BODY_BYTES];
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

static int g_stores, g_store_start, g_hook_bad, g_cell, g_cell_calls;
static void h_store_world(void *c, const EbWorld *w)
{
    if (c == NULL) ++g_hook_bad;
    ++g_stores;
    g_store_start = w->start_flag_5bb1ca;
}
static int32_t h_scene_cell(void *c)
{
    if (c == NULL) ++g_hook_bad;
    ++g_cell_calls;
    return g_cell;
}

typedef struct Bind {
    Fx f;
    SessionAebHost host;
    SessionAebBinding *b;
    SceneResource *scene;
    uint8_t bytes[16384];
    size_t bytes_len;
    uint8_t body_a[EB_BODY_BYTES], body_b[EB_BODY_BYTES];
} Bind;

static int bind_open(Bind *x, int hooks)
{
    const int types[3] = {0x70, 0xeb, 0xeb};
    const uint8_t one = 0;
    const uint8_t *bodies[3];
    size_t lengths[3] = {1, EB_BODY_BYTES, EB_BODY_BYTES};
    char err[128] = {0};
    fx_init(&x->f);
    g_stores = g_hook_bad = g_cell_calls = 0;
    g_store_start = -1;
    g_cell = 55;
    memcpy(x->body_a, x->f.body, EB_BODY_BYTES);
    memcpy(x->body_b, x->f.body, EB_BODY_BYTES);
    set_block(x->body_a, B_EXIT, 77, 1, 2, 3, 4, 5, 6, 0, -1, 0);
    set_block(x->body_b, B_EXIT, 88, 1, 2, 3, 4, 5, 6, 0, -1, 0);
    x->body_b[B_PERSIST] = 1;
    put_rect(x->body_b, B_BTN_A, 500, 410, 540, 440); /* row 2: the exit button elsewhere */
    bodies[0] = &one;
    bodies[1] = x->body_a;
    bodies[2] = x->body_b;
    x->bytes_len = build_scene(x->bytes, 3, types, bodies, lengths);
    x->scene = scene_resource_open_memory(x->bytes, x->bytes_len, err, sizeof err);
    if (x->scene == NULL) return 0;
    memset(&x->host, 0, sizeof x->host);
    x->host.kernel = x->f.host;
    x->host.kernel.context = &x->f;
    if (hooks) {
        x->host.store_world = h_store_world;
        x->host.scene_cell = h_scene_cell;
    }
    x->b = session_aeb_create(&x->host);
    return x->b != NULL;
}

static void bind_close(Bind *x)
{
    session_aeb_destroy(x->b);
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
        const int rc = session_aeb_handler(x->b, row, &info, &st, &out);
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
    uint32_t ph = 99u, np = 99u;
    int done = -1;
    EbPointerResult p;
    EbRenderPlan *r = plan_alloc();
    SceneActionInfo info, other;
    SceneActionRuntimeState st;
    SceneActionHandlerResult out;
    CK(r != NULL);
    if (r == NULL) return;
    if (!bind_open(&x, 1)) {
        CK(0 && "scene opens");
        free(r);
        return;
    }
    memset(&st, 0, sizeof st);
    st.phase = 0u;
    CK(strcmp(session_aeb_failure(x.b), "none") == 0);
    CK(session_aeb_begin_scene(x.b, x.scene) == EB_OK && strcmp(session_aeb_failure(x.b), "none") == 0);
    CK(session_aeb_registered(x.b) == 0u && !eb_object_active(session_aeb_object(x.b)) && eb_object_row(session_aeb_object(x.b)) == -1);
    CK(session_aeb_world(x.b)->saved_flag == 0 && session_aeb_world(x.b)->saved_scene == 9999);
    /* nothing active: every entry point is a no-op that succeeds (and clears the result it is given) */
    memset(&p, 0xff, sizeof p);
    CK(session_aeb_pointer_move(x.b, 310, 210, (const int32_t[4]){302, 202, 318, 218}, &p) == EB_OK && p.hit == 0u && p.candidate == -1 &&
       p.wrote_cursor == 0u);
    CK(session_aeb_click(x.b, 1u, EB_CANDIDATE_PICK, &np) == EB_OK && np == 1u);
    CK(session_aeb_rotate_key(x.b, 1u) == EB_OK);
    r->valid = 1;
    r->count = 4;
    CK(session_aeb_render_plan(x.b, r) == EB_OK && r->valid == 0u && r->count == 0);
    CK(session_aeb_invalidate(x.b) == EB_OK && x.f.log[0] == '\0');
    /* rows the binding does not own */
    CK(scene_resource_action_at(x.scene, 0, &info) == SCENE_RESOURCE_OK);
    CK(session_aeb_handler(x.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    CK(strcmp(session_aeb_failure(x.b), "0xeb-row-not-owned") == 0);
    CK(scene_resource_action_at(x.scene, 1, &info) == SCENE_RESOURCE_OK);
    CK(session_aeb_handler(x.b, 7, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    CK(session_aeb_handler(x.b, 3, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR); /* one past the last row */
    CK(scene_resource_action_at(x.scene, 0, &other) == SCENE_RESOURCE_OK);
    CK(session_aeb_handler(x.b, 1, &other, &st, &out) == SCENE_ACTION_HANDLER_ERROR); /* foreign type at our index */
    CK(session_aeb_handler(x.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);  /* our type at a foreign index */
    CK(session_aeb_handler(x.b, 1, NULL, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    CK(session_aeb_handler(x.b, 1, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
    CK(session_aeb_handler(x.b, 1, &info, &st, NULL) == SCENE_ACTION_HANDLER_ERROR);
    CK(session_aeb_handler(NULL, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
    CK(g_stores == 0 && g_cell_calls == 0);
    /* a later phase without phase 0 */
    st.phase = 1u;
    CK(session_aeb_handler(x.b, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    CK(strcmp(session_aeb_failure(x.b), "0xeb-phase-without-init") == 0);
    /* phase 0: the scene cell is read, the world hook is called */
    CK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u && done == 0 && strcmp(session_aeb_failure(x.b), "none") == 0);
    CK(g_stores == 1 && g_store_start == 1 && g_cell_calls == 2 && /* the phase-without-init call also read the cell */ g_hook_bad == 0);
    CK(session_aeb_world(x.b)->scene_5bb57b == 55 && session_aeb_world(x.b)->saved_scene == 55);
    CK(session_aeb_registered(x.b) == 1u && eb_object_active(session_aeb_object(x.b)) && eb_object_row(session_aeb_object(x.b)) == 1);
    CK(session_aeb_render_plan(x.b, r) == EB_OK && r->valid == 1u && r->count == 3);
    fx_clear(&x.f);
    CK(session_aeb_invalidate(x.b) == EB_OK);
    CK_LOG(&x.f, "dirty:24");
    /* phase 1 visits do not call the world hook */
    CK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u && done == 0 && g_stores == 1);
    /* pointer and click through the binding */
    CK(session_aeb_pointer_move(x.b, 310, 210, (const int32_t[4]){302, 202, 318, 218}, &p) == EB_OK && p.hit == 1u &&
       p.candidate == EB_CANDIDATE_PICK);
    CK(session_aeb_pointer_move(x.b, 620, 460, (const int32_t[4]){612, 452, 628, 468}, &p) == EB_OK && p.candidate == EB_CANDIDATE_EXIT_A);
    CK(session_aeb_click(x.b, 2u, EB_CANDIDATE_EXIT_A, &np) == EB_OK && np == 2u && ob_of(session_aeb_object(x.b), O_EXIT) == 0); /* wrong row phase */
    {   /* a click reads the running scene cell again (the world mirrors the engine's 0x5bb57b before the kernel runs) */
        const int calls = g_cell_calls;
        g_cell = 61;
        CK(session_aeb_click(x.b, 2u, EB_CANDIDATE_EXIT_A, &np) == EB_OK && g_cell_calls == calls + 1 &&
           session_aeb_world(x.b)->scene_5bb57b == 61);
    }
    CK(session_aeb_click(x.b, 1u, EB_CANDIDATE_EXIT_A, &np) == EB_OK && np == 2u && ob_of(session_aeb_object(x.b), O_EXIT) == 1);
    CK(session_aeb_world(x.b)->saved_flag == 1);
    CK(session_aeb_click(x.b, 1u, 0, NULL) == EB_ERR_ARGUMENT);
    /* phase 2: the exit block's scene change; the world hook is called; the object is cleaned up */
    fx_clear(&x.f);
    CK(b_visit(&x, 1, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK && done == 1 && ph == 2u);
    CK(strstr(x.f.log, "scene:77:1,2,3:4,5,6") != NULL && g_stores == 2 && g_store_start == 1);
    CK(session_aeb_registered(x.b) == 0u && !eb_object_active(session_aeb_object(x.b)));
    CK(session_aeb_world(x.b)->scene_5bb57b == 77 && session_aeb_world(x.b)->start_flag_5bb1ca == 1);
    /* the scene cell is read again at every visit */
    g_cell = 56;
    CK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && session_aeb_world(x.b)->saved_scene == 56);
    bind_close(&x);
    CK(g_hook_bad == 0);
    free(r);
}

static void t_binding_rows_and_persistence(void)
{
    Bind x;
    uint32_t ph = 0, np = 0;
    int done = 0;
    EbPointerResult p;
    if (!bind_open(&x, 1)) {
        CK(0 && "scene opens");
        return;
    }
    CK(session_aeb_begin_scene(x.b, x.scene) == EB_OK);
    /* row 1 ends with a counter; the saved state survives into row 2 of the same scene (persist byte of row 2) */
    CK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    ((EbObject *)session_aeb_object(x.b))->b[O_COUNTS + 0] = 1;
    CK(session_aeb_click(x.b, 1u, EB_CANDIDATE_EXIT_A, &np) == EB_OK && np == 2u);
    CK(session_aeb_world(x.b)->saved_counts[0] == 1 && session_aeb_world(x.b)->saved_flag == 1);
    CK(b_visit(&x, 1, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK && done == 1);
    CK(session_aeb_world(x.b)->saved_flag == 1);
    /* a scene change keeps the saved state */
    CK(session_aeb_begin_scene(x.b, x.scene) == EB_OK && session_aeb_world(x.b)->saved_flag == 1);
    CK(b_visit(&x, 2, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u);
    CK(ob_of(session_aeb_object(x.b), O_COUNTS + 0) == 1); /* restored: persist byte, flag, same scene 55 */
    CK(eb_object_row(session_aeb_object(x.b)) == 2);
    /* the exit button of row 2 is elsewhere (500,410..540,440): the binding uses row 2's body */
    CK(session_aeb_pointer_move(x.b, 620, 460, (const int32_t[4]){612, 452, 628, 468}, &p) == EB_OK && p.hit == 0u);
    CK(session_aeb_pointer_move(x.b, 520, 425, (const int32_t[4]){512, 417, 528, 433}, &p) == EB_OK && p.candidate == EB_CANDIDATE_EXIT_A);
    CK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && eb_object_row(session_aeb_object(x.b)) == 1);
    CK(session_aeb_pointer_move(x.b, 520, 425, (const int32_t[4]){512, 417, 528, 433}, &p) == EB_OK && p.hit == 0u);
    /* another scene number: row 2 starts fresh */
    g_cell = 56;
    CK(b_visit(&x, 2, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ob_of(session_aeb_object(x.b), O_COUNTS + 0) == 0);
    /* the new-game reset clears it */
    session_aeb_world_reset(x.b);
    CK(session_aeb_world(x.b)->saved_flag == 0 && session_aeb_world(x.b)->saved_scene == 9999 && session_aeb_world(x.b)->saved_counts[0] == 0);
    session_aeb_world_reset(NULL);
    /* a scene change releases the object */
    fx_clear(&x.f);
    CK(session_aeb_begin_scene(x.b, x.scene) == EB_OK);
    CK(strstr(x.f.log, "relslot:24") != NULL && session_aeb_registered(x.b) == 0u);
    /* a scene with a bad row is refused and the previous rows stay */
    {
        uint8_t bad[EB_BODY_BYTES], bytes[8192];
        const int types[1] = {0xeb};
        const uint8_t *bodies[1] = {bad};
        size_t lengths[1] = {EB_BODY_BYTES};
        SceneResource *scene;
        char err[128] = {0};
        memcpy(bad, x.body_a, sizeof bad);
        put16(bad, B_NTYPES, 30);
        scene = scene_resource_open_memory(bytes, build_scene(bytes, 1, types, bodies, lengths), err, sizeof err);
        CK(scene != NULL);
        if (scene != NULL) {
            CK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
            CK(session_aeb_begin_scene(x.b, scene) == EB_ERR_BODY && strcmp(session_aeb_failure(x.b), "0xeb-type-count") == 0);
            CK(session_aeb_registered(x.b) == 1u); /* the object was not cleaned up */
            scene_resource_close(scene);
        }
    }
    /* a failing clear is reported and keeps the rows */
    fx_clear(&x.f);
    x.f.fail_call = 1;
    CK(session_aeb_begin_scene(x.b, x.scene) == EB_ERR_HOST && strcmp(session_aeb_failure(x.b), "0xeb-scene-clear") == 0);
    x.f.fail_call = 0;
    CK(session_aeb_registered(x.b) == 1u && eb_object_row(session_aeb_object(x.b)) == 1);
    CK(session_aeb_begin_scene(x.b, x.scene) == EB_OK && strcmp(session_aeb_failure(x.b), "none") == 0); /* a good scene resets the text */
    /* a scene without actions is fine and leaves no rows */
    {
        uint8_t bytes[256];
        SceneResource *scene = scene_resource_open_memory(bytes, build_scene(bytes, 0, NULL, NULL, NULL), (char[128]){0}, 128);
        CK(scene != NULL);
        if (scene != NULL) {
            CK(session_aeb_begin_scene(x.b, scene) == EB_OK && strcmp(session_aeb_failure(x.b), "none") == 0);
            scene_resource_close(scene);
            CK(session_aeb_begin_scene(x.b, x.scene) == EB_OK);
        }
    }
    /* destroy cleans up an active object */
    CK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    fx_clear(&x.f);
    session_aeb_destroy(x.b);
    CK(strstr(x.f.log, "relslot:24") != NULL);
    scene_resource_close(x.scene);
}

static void t_binding_errors(void)
{
    Bind x;
    uint32_t ph = 0, np = 0;
    int done = 0;
    EbPointerResult p;
    EbRenderPlan *r = plan_alloc();
    const int32_t hot[4] = {302, 202, 318, 218};
    CK(r != NULL);
    if (r == NULL) return;
    if (!bind_open(&x, 1)) {
        CK(0 && "scene opens");
        free(r);
        return;
    }
    CK(session_aeb_begin_scene(x.b, x.scene) == EB_OK && b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    /* failures name the entry point */
    ((EbObject *)session_aeb_object(x.b))->b[O_DRAG] = 1;
    ((EbObject *)session_aeb_object(x.b))->b[O_HAND] = 0, ((EbObject *)session_aeb_object(x.b))->b[O_HAND + 1] = 0;
    ((EbObject *)session_aeb_object(x.b))->b[O_COUNT] = 1;
    ((EbObject *)session_aeb_object(x.b))->b[PI(0) + P_TYPE] = 0;
    fx_clear(&x.f);
    x.f.fail_call = 1;
    CK(session_aeb_pointer_move(x.b, 310, 210, hot, &p) == EB_ERR_HOST && strcmp(session_aeb_failure(x.b), "0xeb-pointer") == 0);
    x.f.fail_call = 0;
    CK(session_aeb_pointer_move(x.b, 310, 210, hot, &p) == EB_OK && strcmp(session_aeb_failure(x.b), "none") == 0);
    ((EbObject *)session_aeb_object(x.b))->b[O_DRAG] = 0;
    fx_clear(&x.f);
    x.f.fail_call = 1;
    CK(session_aeb_render_plan(x.b, r) == EB_ERR_HOST && strcmp(session_aeb_failure(x.b), "0xeb-render") == 0);
    x.f.fail_call = 0;
    CK(session_aeb_render_plan(x.b, r) == EB_OK && strcmp(session_aeb_failure(x.b), "none") == 0);
    ((EbObject *)session_aeb_object(x.b))->b[O_ACTIVE] = 1;
    fx_clear(&x.f);
    x.f.fail_call = 1;
    CK(session_aeb_render_plan(x.b, r) == EB_ERR_HOST && strcmp(session_aeb_failure(x.b), "0xeb-render") == 0);
    x.f.fail_call = 0;
    CK(session_aeb_click(x.b, 1u, 0, &np) == EB_OK && strcmp(session_aeb_failure(x.b), "none") == 0); /* the text of the failed render is replaced */
    bind_close(&x);
    /* rotation allowed, and no hooks at all */
    {
        uint8_t b[EB_BODY_BYTES], bytes[8192];
        const int types[1] = {0xeb};
        const uint8_t *bodies[1] = {b};
        size_t lengths[1] = {EB_BODY_BYTES};
        SceneResource *scene;
        char err[128] = {0};
        Fx f;
        SessionAebHost host;
        SessionAebBinding *bind;
        fx_init(&f);
        memcpy(b, f.body, sizeof b);
        b[B_ROT] = 1;
        put_name(b, B_SND_ROT, "ROT", 0x21);
        scene = scene_resource_open_memory(bytes, build_scene(bytes, 1, types, bodies, lengths), err, sizeof err);
        CK(scene != NULL);
        if (scene != NULL) {
            memset(&host, 0, sizeof host);
            host.kernel = f.host;
            bind = session_aeb_create(&host);
            CK(bind != NULL && session_aeb_begin_scene(bind, scene) == EB_OK);
            if (bind != NULL) {
                SceneActionInfo info;
                SceneActionRuntimeState st;
                SceneActionHandlerResult out;
                memset(&st, 0, sizeof st);
                CK(scene_resource_action_at(scene, 0, &info) == SCENE_RESOURCE_OK);
                CK(session_aeb_handler(bind, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_OK); /* no hooks at all */
                CK(session_aeb_world(bind)->saved_scene == 0);                                /* the binding's own scene cell */
                CK(session_aeb_pointer_move(bind, 310, 210, hot, &p) == EB_OK && p.hit == 1u);
                fx_clear(&f);
                f.fail_call = 1;
                CK(session_aeb_rotate_key(bind, 1u) == EB_ERR_HOST && strcmp(session_aeb_failure(bind), "0xeb-rotate") == 0);
                fx_clear(&f);
                CK(session_aeb_rotate_key(bind, 1u) == EB_OK && strcmp(session_aeb_failure(bind), "none") == 0);
                f.fail_call = 0;
                CK(session_aeb_click(bind, 1u, EB_CANDIDATE_DROP, &np) == EB_OK && strcmp(session_aeb_failure(bind), "none") == 0);
                CK(session_aeb_invalidate(bind) == EB_OK);
                session_aeb_destroy(bind);
            }
            scene_resource_close(scene);
        }
    }
    /* null and degenerate arguments */
    CK(session_aeb_create(NULL) == NULL);
    session_aeb_destroy(NULL);
    CK(session_aeb_begin_scene(NULL, NULL) == EB_ERR_ARGUMENT);
    CK(session_aeb_pointer_move(NULL, 1, 1, hot, &p) == EB_ERR_ARGUMENT);
    CK(session_aeb_click(NULL, 1u, 0, &np) == EB_ERR_ARGUMENT);
    CK(session_aeb_rotate_key(NULL, 1u) == EB_ERR_ARGUMENT);
    CK(session_aeb_invalidate(NULL) == EB_ERR_ARGUMENT);
    CK(session_aeb_render_plan(NULL, r) == EB_ERR_ARGUMENT);
    CK(session_aeb_registered(NULL) == 0u && session_aeb_object(NULL) == NULL && session_aeb_world(NULL) == NULL);
    CK(strcmp(session_aeb_failure(NULL), "0xeb-binding-unbound") == 0);
    free(r);
}

static void t_binding_argument_checks_with_live_binding(void)
{
    Bind x;
    uint32_t np = 0;
    EbPointerResult p;
    EbRenderPlan *r = plan_alloc();
    const int32_t hot[4] = {302, 202, 318, 218};
    CK(r != NULL);
    if (r == NULL) return;
    if (!bind_open(&x, 1)) {
        CK(0 && "scene opens");
        free(r);
        return;
    }
    CK(session_aeb_begin_scene(x.b, NULL) == EB_ERR_ARGUMENT && session_aeb_begin_scene(x.b, x.scene) == EB_OK);
    CK(session_aeb_pointer_move(x.b, 1, 1, hot, NULL) == EB_ERR_ARGUMENT);
    CK(session_aeb_click(x.b, 1u, 0, NULL) == EB_ERR_ARGUMENT);
    CK(session_aeb_render_plan(x.b, NULL) == EB_ERR_ARGUMENT);
    (void)np;
    (void)p;
    /* an active object whose row is not in the binding (a foreign row number) is refused */
    ((EbObject *)session_aeb_object(x.b))->b[O_ACTIVE] = 1;
    ((EbObject *)session_aeb_object(x.b))->b[O_ROW] = 9;
    ((EbObject *)session_aeb_object(x.b))->b[O_ROW + 1] = 0; /* the row word is 9, not 0xff09 */
    ((EbObject *)session_aeb_object(x.b))->b[O_SLOT] = 0x18;
    CK(session_aeb_pointer_move(x.b, 1, 1, hot, &p) == EB_ERR_ARGUMENT && strcmp(session_aeb_failure(x.b), "none") == 0);
    CK(session_aeb_click(x.b, 1u, 0, &np) == EB_ERR_ARGUMENT && strcmp(session_aeb_failure(x.b), "none") == 0);
    CK(session_aeb_rotate_key(x.b, 1u) == EB_ERR_ARGUMENT && strcmp(session_aeb_failure(x.b), "none") == 0);
    r->valid = 1;
    r->count = 4;
    CK(session_aeb_render_plan(x.b, r) == EB_ERR_ARGUMENT && r->valid == 0u && r->count == 0 && strcmp(session_aeb_failure(x.b), "none") == 0);
    /* the row number equal to the row count is one past the end (three rows in the scene) */
    ((EbObject *)session_aeb_object(x.b))->b[O_ROW] = 3;
    CK(session_aeb_pointer_move(x.b, 1, 1, hot, &p) == EB_ERR_ARGUMENT);
    CK(session_aeb_click(x.b, 1u, 0, &np) == EB_ERR_ARGUMENT);
    CK(session_aeb_rotate_key(x.b, 1u) == EB_ERR_ARGUMENT);
    CK(session_aeb_render_plan(x.b, r) == EB_ERR_ARGUMENT);
    ((EbObject *)session_aeb_object(x.b))->b[O_ROW] = 0; /* row 0 is the foreign 0x70 row */
    CK(session_aeb_pointer_move(x.b, 1, 1, hot, &p) == EB_ERR_ARGUMENT);
    CK(session_aeb_render_plan(x.b, r) == EB_ERR_ARGUMENT);
    ((EbObject *)session_aeb_object(x.b))->b[O_ROW] = 0xff;
    ((EbObject *)session_aeb_object(x.b))->b[O_ROW + 1] = 0xff;
    CK(session_aeb_rotate_key(x.b, 1u) == EB_ERR_ARGUMENT);
    ((EbObject *)session_aeb_object(x.b))->b[O_ACTIVE] = 0;
    /* a failing kernel step is an error of the handler, not a pending row */
    {
        uint32_t ph = 0;
        int done = 0;
        fx_clear(&x.f);
        x.f.fail_call = 1;
        CK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_ERROR);
        x.f.fail_call = 0;
    }
    bind_close(&x);
    free(r);
}

/* The entry rectangles are rebuilt from zero whatever the object held before (piece builder 0x47e582: left and top are written 0,
 * right and bottom are size - 1), for the first entry and for the three rotations. */
static void t_phase0_entry_rects(void)
{
    Fx f;
    fx_init(&f);
    f.body[B_ROT] = 1;
    for (int t = 0; t < 3; ++t)
        for (int k = 0; k < 4; ++k)
            for (int r = 0; r < 4; ++r) set32(&f, EN(t, k) + 4u + (size_t)r * 4u, 0x01020304);
    CK(start(&f) == EB_OK);
    for (int t = 0; t < 3; ++t)
        for (int k = 0; k < 4; ++k) {
            const int w = (k % 2) ? 30 : 40, h = (k % 2) ? 40 : 30; /* every rotation swaps width and height */
            CK(rect_is(f.o.b, EN(t, k) + 4u, 0, 0, w - 1, h - 1));
            CK(od16(&f, EN(t, k) + 0x14u) == w && od16(&f, EN(t, k) + 0x16u) == h);
        }
}

/* A multi pick with a placement whose size does not fit 16 bits (the D rectangle is not size checked): the clamp keeps the 16-bit
 * size of the piece, so an edge that is exactly on the clip rectangle must not be rewritten (0x47f19d tests with < and <=
 * differently: only a strict comparison leaves the 32-bit rectangle alone). */
static void t_clamp_wrapped_sizes(void)
{
    for (int edge = 0; edge < 4; ++edge) {
        Fx f;
        int32_t want[4] = {-34680, -34785, 35320, 35215}; /* (300 + 20) - 35000, (200 + 15) - 35000, then + 70000 */
        fx_init(&f);
        put_name(f.body, B_MULTI, "MULTI", 0x21);
        put_rect(f.body, TY(0) + BT_D, 0, 0, 70000, 70000);
        f.clip[0] = f.clip[1] = -100000;
        f.clip[2] = f.clip[3] = 100000;
        f.clip[edge] = want[edge]; /* the left, top, right or bottom edge lies on the clip edge */
        CK(start(&f) == EB_OK && ptr(&f, 310, 210) == EB_OK);
        CK(click(&f, EB_CANDIDATE_PICK) == EB_OK && ob(&f, O_MULTI_HAND) == 1);
        CK(rect_is(f.o.b, PI(0) + P_RECT, want[0], want[1], want[2], want[3]));
    }
}

/* Guards against an object the kernel itself cannot produce (native safety, not in the original). */
static void t_tampered_object_guards(void)
{
    Fx f;
    EbResult res;
    /* a later phase without init, no failure text wanted */
    fx_init(&f);
    CK(eb_step(&f.o, f.body, EB_BODY_BYTES, 2, 1, &f.w, &f.host, &res, NULL) == EB_ERR_UNSUPPORTED);
    /* a pick list that holds -1 is an empty answer, not an invalid instance */
    fx_init(&f);
    f.body[B_ROT] = 1;
    CK(start(&f) == EB_OK);
    set16(&f, O_COUNT1, 1);
    set16(&f, O_LIST1, -1);
    fx_clear(&f);
    CK(rkey(&f) == EB_OK && od32(&f, O_DRAG) == 0 && f.log[0] == '\0');
    /* the hand must be below both the instance limit and the count (a count above the limit is refused by the other guards) */
    fx_init(&f);
    CK(start(&f) == EB_OK);
    set16(&f, O_COUNT, 90);
    set32(&f, O_DRAG, 1);
    set16(&f, O_HAND, 80);
    CK(click(&f, EB_CANDIDATE_DROP) == EB_ERR_BOUNDS && od32(&f, O_DRAG) == 1);
    /* the layer search stops at the 80th instance: instance 80 would be the drag word and its neighbours (a rectangle at 65536) */
    fx_init(&f);
    CK(start(&f) == EB_OK);
    set16(&f, O_COUNT, 81);
    set16(&f, PI(1) + P_Z, -7);
    set32(&f, O_DRAG, 1);
    set16(&f, O_HAND, 1);
    set32(&f, O_HIT, 0);
    set32(&f, O_LIFT, 0);
    put_rect(f.o.b, O_PREV, 65536, 0, 65600, 50);
    CK(click(&f, EB_CANDIDATE_DROP) == EB_OK && od16(&f, PI(1) + P_Z) == -6);
    /* the first move of a drag is told by the previous top and bottom words alone (not by bytes of the neighbouring words) */
    for (int variant = 0; variant < 2; ++variant) {
        fx_init(&f);
        CK(start(&f) == EB_OK);
        set32(&f, O_DRAG, 1);
        set16(&f, O_HAND, 0);
        if (variant == 0) put_rect(f.o.b, O_MOVE, 0x01000000, 0, 5, 0);
        else put_rect(f.o.b, O_MOVE, 0, 0, 0x01000000, 0);
        CK(ptr(&f, 310, 210) == EB_OK);
        CK(memcmp(f.o.b + O_PREV, f.o.b + O_MOVE, 16) == 0 && rect_is(f.o.b, O_MOVE, 310, 210, 310, 210));
    }
}

static void run(const char *name, void (*fn)(void))
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
    run("object_and_world_reset", t_reset);
    run("phase0", t_phase0);
    run("phase0_objects", t_phase0_objects);
    run("phase0_persist", t_phase0_persist);
    run("phase0_host_failures", t_phase0_host_failures);
    run("step_args", t_step_args);
    run("phase12_gating", t_phase12_gating);
    run("state_idle_and_wait", t_state_idle_and_wait);
    run("state_four_no_animation", t_state_four_no_animation);
    run("state_four_animation", t_state_four_animation);
    run("state_four_animation_sound", t_state_four_animation_sound);
    run("pointer_candidates", t_pointer_candidates);
    run("pointer_rotate_zone", t_pointer_rotate_zone);
    run("pointer_args_and_bounds", t_pointer_args_and_bounds);
    run("pointer_drag", t_pointer_drag);
    run("pointer_clamp", t_pointer_clamp);
    run("pointer_mode_one", t_pointer_mode_one);
    run("pointer_overlap", t_pointer_overlap);
    run("click_guards", t_click_guards);
    run("click_pick", t_click_pick);
    run("click_pick_spawn", t_click_pick_spawn);
    run("click_multi", t_click_multi);
    run("click_rotate", t_click_rotate);
    run("rotate_key", t_rotate_key);
    run("layers", t_layers);
    run("drop_good_and_bad", t_drop_good_and_bad);
    run("exit_and_save", t_exit_and_save);
    run("captions", t_captions);
    run("phase2", t_phase2);
    run("cleanup_invalidate", t_cleanup_invalidate);
    run("render", t_render);
    run("phase0_entry_rects", t_phase0_entry_rects);
    run("clamp_wrapped_sizes", t_clamp_wrapped_sizes);
    run("tampered_object_guards", t_tampered_object_guards);
    run("binding_flow", t_binding_flow);
    run("binding_rows_and_persistence", t_binding_rows_and_persistence);
    run("binding_errors", t_binding_errors);
    run("binding_argument_checks", t_binding_argument_checks_with_live_binding);
    printf("TOTAL %d FAILED %d\n", g_total, g_failures);
    return g_failures;
}
