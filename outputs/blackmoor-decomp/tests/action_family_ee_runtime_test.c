/* RT-60 unit tests of the raw 0xee Memory puzzle kernel (src/action_family_ee_runtime.c) and the session binding
 * (src/session_bindings_aee.c). Prints "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count. Fixtures
 * are synthetic bodies (no original bytes). The Python wrapper tests/test_action_family_ee_runtime.py builds and runs this with
 * and without ASan/UBSan and under source mutations. Expected values are written out by hand from the layout in
 * src/action_family_ee_runtime.h (and the facts quoted in the packet), not by calling the kernel. The comparison with the original
 * x86 code is the oracle's job (RT-60 worker B). */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_ee_runtime.h"
#include "scene_resource.h"
#include "session_bindings_aee.h"

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
    B_NAME = 0x00, B_PICS = 0x21, B_TABSRC = 0xe1, B_TILES = 0x111, B_TABTGT = 0x291, B_TABHOT = 0x2a1, B_DELAY = 0x331,
    B_PCTIDS = 0x335, B_PCTNEED = 0x339, B_NEED = 0x33d, B_TRIES = 0x341, B_RECENTER = 0x345, B_SHUFFLE = 0x346, B_PAGES = 0x347,
    B_COLS = 0x34b, B_ROWS = 0x34f, B_SCOLS = 0x353, B_SROWS = 0x357, B_TABS = 0x35b, B_FLIP1 = 0x35c, B_FLIP2 = 0x412,
    B_MATCH = 0x4c8, B_WRONG = 0x856, B_WIN = 0xf72, B_BWIN = 0x168e, B_BLOSE = 0x16a8
};
/* Object offsets. */
enum {
    O_VTABLE = 0x00, O_SLOT = 0x04, O_ROW = 0x06, O_SURFACE = 0x08, O_BODY = 0x0c, O_STATE = 0x10, O_CELLS = 0x14, O_USED = 0x18,
    O_FIRST = 0x1c, O_SECOND = 0x20, O_ACTIVE = 0x24, O_WON = 0x28, O_LOST = 0x2c, O_REDRAW = 0x30, O_FLIPBACK = 0x34,
    O_DEADLINE = 0x38, O_TILERECT = 0x3c, O_TABTGT = 0x1bc, O_TABHOT = 0x1cc, O_VIEWCOPY = 0x25c, O_VIEW = 0x26c, O_HIT = 0x27c,
    O_PERPAGE = 0x280, O_TOTAL = 0x284, O_SLOTS = 0x288, O_PAGE = 0x28c, O_PAIRS = 0x290, O_TRIES = 0x294, O_HALFTOTAL = 0x298,
    O_HALFPAGE = 0x29c, O_NEEDED = 0x2a0, O_IDS = 0x2a4, O_SNDMATCH = 0x2b8, O_SNDWRONG = 0x2bc, O_SNDWIN = 0x2c0
};
enum { SB_SCENE = 0, SB_W1 = 2, SB_W2 = 4, SB_W3 = 6, SB_D1 = 8, SB_D2 = 12, SB_D3 = 16, SB_START = 20, SB_FLAG = 22, SB_VALUE = 24 };
enum { SR_NAME = 0, SR_CHANNEL = 0x21, SR_KEY = 0x31, SR_TEXT = 0x52, SR_BYTES = 0xb6 };
#define ROW 3
#define HANDLE 0x1000u
#define SURFACE 0x7001u

static void put16(uint8_t *b, size_t off, int v) { b[off] = (uint8_t)v; b[off + 1] = (uint8_t)(v >> 8); }
static void put32(uint8_t *b, size_t off, int32_t v)
{
    for (int i = 0; i < 4; ++i) b[off + (size_t)i] = (uint8_t)((uint32_t)v >> (8 * i));
}
static int32_t get32(const uint8_t *b, size_t off)
{
    return (int32_t)((uint32_t)b[off] | ((uint32_t)b[off + 1] << 8) | ((uint32_t)b[off + 2] << 16) | ((uint32_t)b[off + 3] << 24));
}
static int16_t get16(const uint8_t *b, size_t off) { return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8)); }
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
    put16(b, off + SB_VALUE, value);
}
static void set_sound(uint8_t *b, size_t list, int i, const char *name, int channel, const char *key, const char *text)
{
    const size_t r = list + (size_t)i * SR_BYTES;
    memset(b + r, 0, SR_BYTES);
    set_str(b, r + SR_NAME, name);
    put16(b, r + SR_CHANNEL, channel);
    set_str(b, r + SR_KEY, key);
    set_str(b, r + SR_TEXT, text);
}

/* The fixture body: one page of 2 x 2 tiles, 2 x 2 picture slots (4 ids), tile j at (100 + 50 (j % 6), 200 + 50 (j / 6)) 40 wide, tries
 * allowed 3, flip-back delay 500, pairs needed 2 (fixed), no tabs, no recenter, every sound "NO SOUND". Win block: scene 100, words
 * 1 2 3, dwords 11 12 13, start word 0, flag 5 value 9. Lose block: scene 200, words 4 5 6, dwords 21 22 23, start word 1, flag -1. */
static void make_body(uint8_t *b)
{
    memset(b, 0, MP_BODY_BYTES);
    set_str(b, B_NAME, "OVERLAY");
    for (int i = 0; i < 12; ++i) put_rect(b, B_PICS + (size_t)i * 16u, i * 16 + 1, i * 16 + 2, i * 16 + 9, i * 16 + 10);
    for (int p = 0; p < 3; ++p) put_rect(b, B_TABSRC + (size_t)p * 16u, 500 + p, 10, 520 + p, 30);
    for (int i = 0; i < 24; ++i) {
        const int l = 100 + (i % 6) * 50, t = 200 + (i / 6) * 50;
        put_rect(b, B_TILES + (size_t)i * 16u, l, t, l + 40, t + 40);
    }
    put_rect(b, B_TABTGT, 300, 10, 330, 40);
    for (int p = 0; p < 3; ++p)
        for (int k = 0; k < 3; ++k) {
            const int l = 400 + p * 100 + k * 20;
            put_rect(b, B_TABHOT + (size_t)p * 0x30u + (size_t)k * 0x10u, l, 10, l + 15, 30);
        }
    put32(b, B_DELAY, 500);
    put32(b, B_PCTIDS, 100);
    put32(b, B_PCTNEED, -1);
    put32(b, B_NEED, 2);
    put32(b, B_TRIES, 3);
    put32(b, B_PAGES, 1);
    put32(b, B_COLS, 2);
    put32(b, B_ROWS, 2);
    put32(b, B_SCOLS, 2);
    put32(b, B_SROWS, 2);
    for (int i = 0; i < 1; ++i) set_sound(b, B_FLIP1, i, "NO SOUND", 0, "", "");
    set_sound(b, B_FLIP2, 0, "NO SOUND", 0, "", "");
    for (int i = 0; i < 5; ++i) set_sound(b, B_MATCH, i, "NO SOUND", 0, "", "");
    for (int i = 0; i < 10; ++i) set_sound(b, B_WRONG, i, "NO SOUND", 0, "", "");
    for (int i = 0; i < 10; ++i) set_sound(b, B_WIN, i, "NO SOUND", 0, "", "");
    set_block(b, B_BWIN, 100, 1, 2, 3, 11, 12, 13, 0, 5, 9);
    set_block(b, B_BLOSE, 200, 4, 5, 6, 21, 22, 23, 1, -1, 7);
}

typedef struct Fx {
    MpHost host;
    MpObject obj;
    uint8_t body[MP_BODY_BYTES];
    char log[4096];
    uint32_t now;
    int32_t rnd[64];
    int rnd_n, rnd_i, cycle, rand_calls;
    int busy_n;
    int fail_at, calls;
    int captions;
    const char *auto_key, *auto_text;
    int16_t next_slot;
    MpView view;
    int rc;
    MpResult res;
    const char *why;
    const char *name_seen;
} Fx;

#define FAILABLE(f) (++(f)->calls == (f)->fail_at)
#define LOG(f, ...)                                                                                     \
    do {                                                                                                \
        const size_t n_ = strlen((f)->log);                                                             \
        snprintf((f)->log + n_, sizeof (f)->log - n_, __VA_ARGS__);                                     \
    } while (0)

static int cb_view(void *c, MpView *v)
{
    Fx *f = (Fx *)c;
    LOG(f, "view;");
    if (FAILABLE(f)) return 1;
    *v = f->view;
    return 0;
}
static int cb_start(void *c, int32_t v)
{
    Fx *f = (Fx *)c;
    LOG(f, "start=%d;", (int)v);
    return FAILABLE(f);
}
static int cb_pend(void *c)
{
    Fx *f = (Fx *)c;
    LOG(f, "pend;");
    return FAILABLE(f);
}
static int cb_recenter(void *c)
{
    Fx *f = (Fx *)c;
    LOG(f, "recenter;");
    return FAILABLE(f);
}
static int cb_alloc(void *c, int16_t *slot)
{
    Fx *f = (Fx *)c;
    LOG(f, "alloc;");
    if (FAILABLE(f)) return 1;
    *slot = f->next_slot;
    return 0;
}
static int cb_reg(void *c, int16_t slot, const char *label)
{
    Fx *f = (Fx *)c;
    LOG(f, "reg=%d:%s;", slot, label);
    return FAILABLE(f);
}
static int cb_ssurf(void *c, int16_t slot, uint32_t s)
{
    Fx *f = (Fx *)c;
    LOG(f, "ssurf=%d:%u;", slot, (unsigned)s);
    return FAILABLE(f);
}
static int cb_rslot(void *c, int16_t slot)
{
    Fx *f = (Fx *)c;
    LOG(f, "rslot=%d;", slot);
    return FAILABLE(f);
}
static int cb_dirty(void *c, int16_t slot)
{
    Fx *f = (Fx *)c;
    LOG(f, "dirty=%d;", slot);
    return FAILABLE(f);
}
static int cb_load(void *c, const char *name, const char *tag, uint32_t *s)
{
    Fx *f = (Fx *)c;
    LOG(f, "load=%s/%s;", name, tag);
    if (FAILABLE(f)) return 1;
    *s = SURFACE;
    return 0;
}
static int cb_rsurf(void *c, uint32_t s)
{
    Fx *f = (Fx *)c;
    LOG(f, "rsurf=%u;", (unsigned)s);
    return FAILABLE(f);
}
static int32_t cb_rand(void *c)
{
    Fx *f = (Fx *)c;
    ++f->rand_calls;
    if (f->cycle) return f->cycle++ - 1;
    return f->rnd_i < f->rnd_n ? f->rnd[f->rnd_i++] : 0;
}
static uint32_t cb_tick(void *c) { return ((Fx *)c)->now; }
static int cb_prep(void *c, uint32_t id, const uint8_t *rec)
{
    Fx *f = (Fx *)c;
    LOG(f, "prep=%x:%s;", (unsigned)id, (const char *)rec);
    return FAILABLE(f);
}
static int cb_play(void *c, int16_t ch)
{
    Fx *f = (Fx *)c;
    LOG(f, "play=%d;", ch);
    return FAILABLE(f);
}
static int cb_busy(void *c, int16_t ch, int32_t *r)
{
    Fx *f = (Fx *)c;
    LOG(f, "busy=%d;", ch);
    if (FAILABLE(f)) return 1;
    *r = f->busy_n > 0 ? f->busy_n-- : 0;
    return 0;
}
static int cb_caps(void *c, int32_t *e)
{
    Fx *f = (Fx *)c;
    LOG(f, "caps;");
    if (FAILABLE(f)) return 1;
    *e = f->captions;
    return 0;
}
static int cb_auto(void *c, const char *key, const char **text)
{
    Fx *f = (Fx *)c;
    LOG(f, "auto=%s;", key);
    if (FAILABLE(f)) return 1;
    *text = f->auto_key != NULL && strcmp(f->auto_key, key) == 0 ? f->auto_text : NULL;
    return 0;
}
static int cb_cap(void *c, const char *text)
{
    Fx *f = (Fx *)c;
    LOG(f, "cap=%s;", text);
    return FAILABLE(f);
}
static int cb_inv(void *c, int16_t index)
{
    Fx *f = (Fx *)c;
    LOG(f, "inv=%d;", index);
    return index >= 4096 || index < 0;
}
static int cb_trans(void *c, const MpTransition *t)
{
    Fx *f = (Fx *)c;
    LOG(f, "trans=%d,%d,%d,%d,%d,%d,%d,s%d;", t->scene, t->word[0], t->word[1], t->word[2], (int)t->dword[0], (int)t->dword[1],
        (int)t->dword[2], (int)t->start_flag);
    return FAILABLE(f);
}
static int cb_flag(void *c, int16_t i, int32_t v)
{
    Fx *f = (Fx *)c;
    LOG(f, "flag=%d,%d;", i, (int)v);
    return FAILABLE(f);
}
static int cb_done(void *c, int16_t row)
{
    Fx *f = (Fx *)c;
    LOG(f, "done=%d;", row);
    return FAILABLE(f);
}

static void fill_host(MpHost *h, void *ctx)
{
    memset(h, 0, sizeof *h);
    h->context = ctx;
    h->view = cb_view;
    h->set_start_flag = cb_start;
    h->clear_pending_item = cb_pend;
    h->recenter_cursor = cb_recenter;
    h->alloc_slot = cb_alloc;
    h->register_slot = cb_reg;
    h->set_slot_surface = cb_ssurf;
    h->release_slot = cb_rslot;
    h->mark_dirty = cb_dirty;
    h->load_surface = cb_load;
    h->release_surface = cb_rsurf;
    h->random = cb_rand;
    h->tick = cb_tick;
    h->sound_prepare = cb_prep;
    h->sound_play = cb_play;
    h->sound_busy = cb_busy;
    h->captions_enabled = cb_caps;
    h->autotext_lookup = cb_auto;
    h->caption_show = cb_cap;
    h->event_flag_invalid = cb_inv;
    h->transition = cb_trans;
    h->store_event_flag = cb_flag;
    h->complete = cb_done;
}

static void fx_init(Fx *f)
{
    memset(f, 0, sizeof *f);
    make_body(f->body);
    fill_host(&f->host, f);
    mp_object_reset(&f->obj);
    f->now = 10000;
    f->next_slot = 0x18;
    f->view.view[0] = 10;
    f->view.view[1] = 20;
    f->view.view[2] = 650;
    f->view.view[3] = 500;
    f->view.clip[0] = 0;
    f->view.clip[1] = 5;
    f->view.clip[2] = 640;
    f->view.clip[3] = 485;
}

static void rnd_set(Fx *f, int n, const int32_t *v)
{
    memcpy(f->rnd, v, (size_t)n * sizeof(int32_t));
    f->rnd_n = n;
    f->rnd_i = 0;
}

static int visit(Fx *f, uint32_t phase)
{
    f->log[0] = 0;
    f->why = NULL;
    f->rc = mp_step(&f->obj, f->body, MP_BODY_BYTES, HANDLE, ROW, phase, &f->host, &f->res, &f->why);
    return f->rc;
}

/* A standard deal: 2 x 2, ids 4, cells [0 1 1 0]. */
static void start(Fx *f)
{
    static const int32_t deal[4] = {0, 3, 1, 2};
    fx_init(f);
    rnd_set(f, 4, deal);
    CHECK_INT(visit(f, 0), MP_OK);
}

static int cell_id(const Fx *f, int i) { return get32(f->obj.cells, (size_t)i * 12u); }
static int cell_up(const Fx *f, int i) { return get32(f->obj.cells, (size_t)i * 12u + 4u); }
static int cell_done(const Fx *f, int i) { return get32(f->obj.cells, (size_t)i * 12u + 8u); }
static int32_t ob(const Fx *f, size_t off) { return get32(f->obj.b, off); }

/* The centre of tile j of the fixture body. */
static int tile_x(int j) { return 120 + (j % 6) * 50; }
static int tile_y(int j) { return 220 + (j / 6) * 50; }

static int click(Fx *f, int32_t candidate, uint32_t phase)
{
    f->log[0] = 0;
    f->rc = mp_click(&f->obj, f->body, MP_BODY_BYTES, HANDLE, phase, candidate, &f->host);
    return f->rc;
}

/* Point at tile j, then click it with the candidate the pointer wrote (as the app does on an accepted release). */
static int flip(Fx *f, int j)
{
    MpPointerResult p;
    int rc = mp_pointer(&f->obj, f->body, MP_BODY_BYTES, (int16_t)tile_x(j), (int16_t)tile_y(j), &p);
    if (rc != MP_OK) return rc;
    if (!p.hit) return -1;
    return click(f, p.candidate, 1u);
}

/* ---- validation --------------------------------------------------------------------------------------------------------------- */

static int validate(const uint8_t *body, size_t n, const char **why)
{
    *why = NULL;
    return mp_validate_body(body, n, why);
}

static void t_validate(void)
{
    uint8_t b[MP_BODY_BYTES];
    const char *why;
    make_body(b);
    CHECK_INT(validate(b, MP_BODY_BYTES, &why), MP_OK);
    CHECK_INT(mp_validate_body(b, MP_BODY_BYTES, NULL), MP_OK);
    CHECK_INT(validate(NULL, MP_BODY_BYTES, &why), MP_ERR_BODY);
    CHECK(why != NULL && strstr(why, "short") != NULL);
    CHECK_INT(validate(b, MP_BODY_BYTES - 1u, &why), MP_ERR_BODY);
    CHECK_INT(mp_validate_body(b, MP_BODY_BYTES - 1u, NULL), MP_ERR_BODY);
    CHECK_INT(validate(b, MP_BODY_BYTES + 100u, &why), MP_OK);
    memset(b, 'A', 0x21);
    CHECK_INT(validate(b, MP_BODY_BYTES, &why), MP_ERR_BODY);
    CHECK(strstr(why, "name") != NULL);
    make_body(b);
    b[0x20] = 'X'; /* a 32-character name ends with the NUL at 0x20? no: the field is 0x21 bytes, a NUL must be within them */
    CHECK_INT(validate(b, MP_BODY_BYTES, &why), MP_OK);
    memset(b, 'A', 0x20);
    b[0x20] = 0;
    CHECK_INT(validate(b, MP_BODY_BYTES, &why), MP_OK);
    make_body(b);
    {
        const struct { size_t off; int bad[2]; int good[2]; const char *word; } r[] = {
            {B_PAGES, {0, 4}, {1, 3}, "pages"}, {B_COLS, {0, 7}, {1, 6}, "columns"}, {B_ROWS, {0, 5}, {1, 4}, "rows"},
            {B_SCOLS, {0, 7}, {1, 6}, "picture-columns"}, {B_SROWS, {0, 3}, {1, 2}, "picture-rows"}};
        for (size_t i = 0; i < sizeof r / sizeof r[0]; ++i) {
            for (int k = 0; k < 2; ++k) {
                make_body(b);
                put32(b, r[i].off, r[i].bad[k]);
                CHECK_INT(validate(b, MP_BODY_BYTES, &why), MP_ERR_BODY);
                CHECK(why != NULL && strstr(why, r[i].word) != NULL);
                make_body(b);
                put32(b, B_COLS, 2); /* the other dimension stays even */
                put32(b, B_ROWS, 2);
                put32(b, r[i].off, r[i].good[k]);
                CHECK_INT(validate(b, MP_BODY_BYTES, &why), MP_OK);
            }
        }
    }
    make_body(b);
    put32(b, B_COLS, 3);
    put32(b, B_ROWS, 1); /* 3 cells per page */
    put32(b, B_PAGES, 1);
    CHECK_INT(validate(b, MP_BODY_BYTES, &why), MP_ERR_BODY);
    CHECK(strstr(why, "odd") != NULL);
    put32(b, B_PAGES, 2); /* 3 per page, shuffle off: still odd per page */
    CHECK_INT(validate(b, MP_BODY_BYTES, &why), MP_ERR_BODY);
    b[B_SHUFFLE] = 1; /* shuffle over all pages: 6 cells */
    CHECK_INT(validate(b, MP_BODY_BYTES, &why), MP_OK);
    put32(b, B_PAGES, 1); /* one page: the shuffle byte is ignored, 3 cells */
    CHECK_INT(validate(b, MP_BODY_BYTES, &why), MP_ERR_BODY);
    make_body(b);
    put32(b, B_COLS, 2);
    put32(b, B_ROWS, 1);
    put32(b, B_PAGES, 3); /* 2 per page, 6 cells: even whether the shuffle covers all pages or not */
    CHECK_INT(validate(b, MP_BODY_BYTES, &why), MP_OK);
    b[B_SHUFFLE] = 1;
    CHECK_INT(validate(b, MP_BODY_BYTES, &why), MP_OK);
    {
        /* every sound list: the first and the last record, each of the three strings */
        static const struct { size_t base; int count; } lists[] = {{B_FLIP1, 1}, {B_FLIP2, 1}, {B_MATCH, 5}, {B_WRONG, 10}, {B_WIN, 10}};
        static const struct { size_t off, span; const char *word; } fields[] = {
            {SR_NAME, 0x21, "sound-name"}, {SR_KEY, 0x21, "caption-key"}, {SR_TEXT, 0x64, "caption-text"}};
        for (size_t l = 0; l < 5; ++l)
            for (int pass = 0; pass < 2; ++pass)
                for (size_t fl = 0; fl < 3; ++fl) {
                    const int i = pass == 0 ? 0 : lists[l].count - 1;
                    const size_t at = lists[l].base + (size_t)i * SR_BYTES + fields[fl].off;
                    make_body(b);
                    memset(b + at, 'Q', fields[fl].span);
                    CHECK_INT(validate(b, MP_BODY_BYTES, &why), MP_ERR_BODY);
                    CHECK(why != NULL && strstr(why, fields[fl].word) != NULL);
                    b[at + fields[fl].span - 1u] = 0; /* terminated in the last byte: valid */
                    CHECK_INT(validate(b, MP_BODY_BYTES, &why), MP_OK);
                    b[at + fields[fl].span - 1u] = 'Q'; /* a NUL in the byte after the field does not terminate it */
                    b[at + fields[fl].span] = 0;
                    CHECK_INT(validate(b, MP_BODY_BYTES, &why), MP_ERR_BODY);
                }
    }
    /* percentages that overflow int32 cannot occur with the validated counts: the largest is 2^31 - 1 percent of 72 */
    make_body(b);
    put32(b, B_PCTIDS, 0x7fffffff);
    put32(b, B_PCTNEED, 0x7fffffff);
    CHECK_INT(validate(b, MP_BODY_BYTES, &why), MP_OK);
}

static void t_reset(void)
{
    MpObject o;
    memset(&o, 0xaa, sizeof o);
    mp_object_reset(&o);
    CHECK_INT(get32(o.b, O_VTABLE), (int32_t)0x0052d568);
    CHECK_INT(mp_object_slot(&o), -1);
    CHECK_INT(mp_object_row(&o), -1);
    CHECK_INT(get16(o.b, O_SLOT), -1);
    CHECK_INT(get16(o.b, O_ROW), -1);
    CHECK_INT(mp_object_active(&o), 0);
    CHECK_INT(mp_object_state(&o), 0);
    for (size_t i = 8; i < MP_OBJECT_BYTES; ++i) CHECK(o.b[i] == 0);
    for (size_t i = 0; i < sizeof o.cells; ++i) CHECK(o.cells[i] == 0);
    for (size_t i = 0; i < sizeof o.used; ++i) CHECK(o.used[i] == 0);
    CHECK_INT(MP_RUNTIME_TYPE, 0xee);
    CHECK_INT(MP_BODY_BYTES, 5826);
    CHECK_INT(MP_OBJECT_BYTES, 0x2c4);
}

/* ---- phase 0 and the deal ------------------------------------------------------------------------------------------------- */

static void t_phase0(void)
{
    Fx f;
    fx_init(&f);
    start(&f);
    CHECK_LOG(&f, "start=1;pend;view;alloc;reg=24:WHALESURVIVOR GAME PUZZLE OVERLAYS;load=OVERLAY/Memory Puzzle Overlay Surface;"
                  "ssurf=24:28673;");
    CHECK(f.res.initialized == 1 && f.res.completed == 0 && f.res.phase_after == 1u);
    CHECK_INT(mp_object_row(&f.obj), ROW);
    CHECK_INT(mp_object_slot(&f.obj), 0x18);
    CHECK_INT(mp_object_active(&f.obj), 1);
    CHECK_INT(mp_object_state(&f.obj), 0);
    CHECK_INT(ob(&f, O_BODY), HANDLE);
    CHECK_INT(ob(&f, O_SURFACE), SURFACE);
    CHECK_INT(ob(&f, O_VTABLE), (int32_t)MP_VTABLE);
    CHECK_INT(ob(&f, O_PERPAGE), 4);
    CHECK_INT(ob(&f, O_TOTAL), 4);
    CHECK_INT(ob(&f, O_HALFPAGE), 2);
    CHECK_INT(ob(&f, O_HALFTOTAL), 2);
    CHECK_INT(ob(&f, O_SLOTS), 4);
    CHECK_INT(ob(&f, O_IDS), 4);
    CHECK_INT(ob(&f, O_NEEDED), 2);
    CHECK_INT(ob(&f, O_TRIES), 0);
    CHECK_INT(ob(&f, O_PAIRS), 0);
    CHECK_INT(ob(&f, O_WON), 0);
    CHECK_INT(ob(&f, O_LOST), 0);
    CHECK_INT(ob(&f, O_REDRAW), 1);
    CHECK_INT(ob(&f, O_FLIPBACK), 0);
    CHECK_INT(ob(&f, O_DEADLINE), 0);
    CHECK_INT(ob(&f, O_FIRST), 0);
    CHECK_INT(ob(&f, O_SECOND), 0);
    CHECK_INT(ob(&f, O_PAGE), 0);
    CHECK_INT(ob(&f, O_CELLS), (int32_t)MP_GUEST_CELLS);
    CHECK_INT(ob(&f, O_USED), (int32_t)MP_GUEST_USED);
    for (int k = 0; k < 4; ++k) {
        CHECK_INT(ob(&f, O_VIEW + 4 * (size_t)k), f.view.view[k]);
        CHECK_INT(ob(&f, O_VIEWCOPY + 4 * (size_t)k), f.view.view[k]);
    }
    for (int j = 0; j < 4; ++j) {
        const size_t r = O_TILERECT + (size_t)j * 16u;
        CHECK_INT(ob(&f, r), 100 + (j % 6) * 50 + 10);
        CHECK_INT(ob(&f, r + 4), 200 + (j / 6) * 50 + 20);
        CHECK_INT(ob(&f, r + 8), 100 + (j % 6) * 50 + 40 + 10);
        CHECK_INT(ob(&f, r + 12), 200 + (j / 6) * 50 + 40 + 20);
    }
    CHECK_INT(ob(&f, O_TILERECT + 4 * 16), 0); /* only per-page tiles are translated */
    CHECK_INT(f.rnd_i, 4);
    CHECK_INT(cell_id(&f, 0), 0);
    CHECK_INT(cell_id(&f, 1), 1);
    CHECK_INT(cell_id(&f, 2), 1);
    CHECK_INT(cell_id(&f, 3), 0);
    for (int i = 0; i < 4; ++i) CHECK(cell_up(&f, i) == 0 && cell_done(&f, i) == 0);
    CHECK_INT(get32(f.obj.used, 0), 1);
    CHECK_INT(get32(f.obj.used, 4), 1);
    CHECK_INT(get32(f.obj.used, 8), 0);
    CHECK_INT(ob(&f, 0x2b4), 3); /* the cell index under work after the deal */
    CHECK_INT(ob(&f, 0x2ac), 4); /* the loop counter of the cell initialisation */
    CHECK_INT(ob(&f, 0x2b0), 0);
    for (size_t i = 4u * 12u; i < sizeof f.obj.cells; ++i) CHECK(f.obj.cells[i] == 0); /* cells beyond the table stay zero */
    /* a second phase 0 over a live object keeps the loaded surface (no second load) and resets every counter of the game */
    {
        static const int32_t deal[4] = {0, 3, 1, 2};
        put32(f.obj.b, O_FIRST, 1);
        put32(f.obj.b, O_SECOND, 2);
        put32(f.obj.b, O_TRIES, 9);
        put32(f.obj.b, O_PAIRS, 9);
        put32(f.obj.b, O_DEADLINE, 9);
        put32(f.obj.b, O_FLIPBACK, 1);
        put32(f.obj.b, O_PAGE, 1);
        put32(f.obj.b, O_WON, 1);
        put32(f.obj.b, O_LOST, 1);
        put32(f.obj.b, O_STATE, 3);
        put32(f.obj.b, O_REDRAW, 0);
        put32(f.obj.cells, 10 * 12, 7);
        put32(f.obj.cells, 1 * 12 + 4, 1);
        put32(f.obj.cells, 1 * 12 + 8, 1);
        rnd_set(&f, 4, deal);
        CHECK_INT(visit(&f, 0), MP_OK);
        CHECK(strstr(f.log, "load=") == NULL);
        CHECK(strstr(f.log, "ssurf=24:28673;") != NULL);
        CHECK(ob(&f, O_FIRST) == 0 && ob(&f, O_SECOND) == 0 && ob(&f, O_TRIES) == 0 && ob(&f, O_PAIRS) == 0);
        CHECK(ob(&f, O_DEADLINE) == 0 && ob(&f, O_FLIPBACK) == 0 && ob(&f, O_PAGE) == 0 && ob(&f, O_WON) == 0);
        CHECK(ob(&f, O_LOST) == 0 && ob(&f, O_STATE) == 0 && ob(&f, O_REDRAW) == 1);
        CHECK_INT(get32(f.obj.cells, 10 * 12), 0);
        CHECK(cell_up(&f, 1) == 0 && cell_done(&f, 1) == 0);
    }
}

static void t_phase0_options(void)
{
    Fx f;
    fx_init(&f);
    /* recenter byte */
    f.body[B_RECENTER] = 1;
    f.cycle = 1;
    CHECK_INT(visit(&f, 0), MP_OK);
    CHECK(strstr(f.log, "start=1;pend;recenter;view;alloc;") == f.log);
    /* tabs: three pages, hot rectangles and the target translated by the view origin */
    fx_init(&f);
    f.body[B_TABS] = 1;
    put32(f.body, B_PAGES, 3);
    f.cycle = 1;
    CHECK_INT(visit(&f, 0), MP_OK);
    for (int p = 0; p < 3; ++p)
        for (int k = 0; k < 3; ++k) {
            const size_t r = O_TABHOT + (size_t)p * 0x30u + (size_t)k * 0x10u;
            const int l = 400 + p * 100 + k * 20;
            CHECK_INT(ob(&f, r), l + 10);
            CHECK_INT(ob(&f, r + 4), 10 + 20);
            CHECK_INT(ob(&f, r + 8), l + 15 + 10);
            CHECK_INT(ob(&f, r + 12), 30 + 20);
        }
    CHECK_INT(ob(&f, O_TABTGT), 310);
    CHECK_INT(ob(&f, O_TABTGT + 4), 30);
    CHECK_INT(ob(&f, O_TABTGT + 8), 340);
    CHECK_INT(ob(&f, O_TABTGT + 12), 60);
    CHECK_INT(ob(&f, O_TOTAL), 12);
    CHECK_INT(ob(&f, O_HALFTOTAL), 6);
    CHECK_INT(ob(&f, O_HALFPAGE), 2);
    CHECK_INT(ob(&f, 0x2b0), 3); /* the loop counters are left behind in the object */
    for (int k = 0; k < 4; ++k) CHECK_INT(ob(&f, O_VIEWCOPY + 4 * (size_t)k), f.view.view[k]); /* the tab loop stays inside its table */
    /* tabs off: nothing translated */
    fx_init(&f);
    put32(f.body, B_PAGES, 3);
    f.cycle = 1;
    CHECK_INT(visit(&f, 0), MP_OK);
    CHECK_INT(ob(&f, O_TABTGT), 0);
    CHECK_INT(ob(&f, O_TABHOT), 0);
    /* a view with a negative origin wraps nothing: plain two's complement addition */
    fx_init(&f);
    f.view.view[0] = -7;
    f.view.view[1] = -9;
    f.cycle = 1;
    CHECK_INT(visit(&f, 0), MP_OK);
    CHECK_INT(ob(&f, O_TILERECT), 93);
    CHECK_INT(ob(&f, O_TILERECT + 4), 191);
    /* the tile rectangle count is per page: a 4 x 3 page translates 12 tiles */
    fx_init(&f);
    put32(f.body, B_COLS, 4);
    put32(f.body, B_ROWS, 3);
    f.cycle = 1;
    CHECK_INT(visit(&f, 0), MP_OK);
    CHECK_INT(ob(&f, O_TILERECT + 11 * 16), 100 + 5 * 50 + 10);
    CHECK_INT(ob(&f, O_TILERECT + 12 * 16), 0);
}

static void deal_run(Fx *f, int32_t pages, int32_t cols, int32_t rows, int shuffle, int32_t pct_ids, int32_t pct_need, int32_t need)
{
    fx_init(f);
    put32(f->body, B_PAGES, pages);
    put32(f->body, B_COLS, cols);
    put32(f->body, B_ROWS, rows);
    f->body[B_SHUFFLE] = (uint8_t)shuffle;
    put32(f->body, B_PCTIDS, pct_ids);
    put32(f->body, B_PCTNEED, pct_need);
    put32(f->body, B_NEED, need);
}

static void t_deal(void)
{
    Fx f;
    /* the largest table: 3 pages of 6x4 shuffled together fill all 72 cells and nothing past them */
    deal_run(&f, 3, 6, 4, 1, 100, -1, 2);
    f.cycle = 1;
    CHECK_INT(visit(&f, 0), MP_OK);
    CHECK_INT(ob(&f, O_TOTAL), 72);
    for (int i = 0; i < 72; ++i) CHECK(cell_id(&f, i) >= 0);
    /* two pages dealt page by page: cells [0 0 1 1] */
    {
        static const int32_t r[5] = {0, 1, 5, 0, 3};
        deal_run(&f, 2, 2, 1, 0, 100, -1, 2);
        rnd_set(&f, 5, r);
        CHECK_INT(visit(&f, 0), MP_OK);
        CHECK_INT(f.rnd_i, 5);
        CHECK(cell_id(&f, 0) == 0 && cell_id(&f, 1) == 0 && cell_id(&f, 2) == 1 && cell_id(&f, 3) == 1);
        CHECK_INT(ob(&f, O_TOTAL), 4);
        CHECK_INT(ob(&f, O_PERPAGE), 2);
    }
    /* shuffle over all pages: cells [2 3 2 3] */
    {
        static const int32_t r[5] = {2, 2, 3, 0, 3};
        deal_run(&f, 2, 2, 1, 1, 100, -1, 2);
        rnd_set(&f, 5, r);
        CHECK_INT(visit(&f, 0), MP_OK);
        CHECK_INT(f.rnd_i, 5);
        CHECK(cell_id(&f, 0) == 2 && cell_id(&f, 1) == 3 && cell_id(&f, 2) == 2 && cell_id(&f, 3) == 3);
    }
    /* the same draws with the shuffle byte set on ONE page behave like a page deal (the byte is forced off) */
    {
        static const int32_t r[2] = {1, 1};
        deal_run(&f, 1, 2, 1, 1, 100, -1, 2);
        rnd_set(&f, 2, r);
        CHECK_INT(visit(&f, 0), MP_OK);
        CHECK(cell_id(&f, 0) == 1 && cell_id(&f, 1) == 1);
        CHECK_INT(ob(&f, 0x2b4), 1); /* the page deal leaves the last cell index behind */
    }
    /* more pairs than ids: the picks after the last free id draw one number and do not mark it */
    {
        static const int32_t r[12] = {0, 1, 5, 3, 2, 5, 3, 7, 5, 3, 0, 5};
        static const int want[12] = {0, 0, 1, 1, 2, 2, 3, 3, 1, 1, 0, 0};
        deal_run(&f, 2, 3, 2, 0, 100, -1, 2);
        rnd_set(&f, 12, r);
        CHECK_INT(visit(&f, 0), MP_OK);
        CHECK_INT(f.rnd_i, 12);
        for (int i = 0; i < 12; ++i) CHECK_INT(cell_id(&f, i), want[i]);
        for (int i = 0; i < 4; ++i) CHECK_INT(get32(f.obj.used, (size_t)i * 4u), 1);
    }
    /* a pick draw that is already used is redrawn (id 0 is used by the first pair) */
    {
        static const int32_t r[6] = {0, 1, 0, 1, 2, 3};
        deal_run(&f, 1, 2, 2, 0, 100, -1, 2);
        rnd_set(&f, 6, r);
        CHECK_INT(visit(&f, 0), MP_OK);
        /* cell 0: id 0, partner 1; cell 2: draw 0 (used) redrawn, 1 -> id 1, partner draw 2 -> cell 2 itself (rejected), 3 -> cell 3 */
        CHECK_INT(f.rnd_i, 6);
        CHECK(cell_id(&f, 0) == 0 && cell_id(&f, 1) == 0 && cell_id(&f, 2) == 1 && cell_id(&f, 3) == 1);
    }
    /* id count: 3 x 2 slots = 6, percentage of the slots truncated, floor 4, cap at the slot count */
    {
        static const struct { int32_t pct; int32_t ids; } c[] = {{0, 4}, {-1, 4}, {50, 4}, {66, 4}, {67, 4}, {75, 4}, {84, 5}, {90, 5}, {99, 5}, {100, 6}, {300, 6}};
        for (size_t i = 0; i < sizeof c / sizeof c[0]; ++i) {
            deal_run(&f, 1, 2, 2, 0, c[i].pct, -1, 2);
            put32(f.body, B_SCOLS, 3);
            put32(f.body, B_SROWS, 2);
            f.cycle = 1;
            CHECK_INT(visit(&f, 0), MP_OK);
            CHECK_INT(ob(&f, O_SLOTS), 6);
            CHECK_INT(ob(&f, O_IDS), c[i].ids);
        }
    }
    /* pairs needed: 4 x 3 = 12 cells, 6 pairs; percentage of pairs or the fixed value, floor 2, cap at the pair count */
    {
        static const struct { int32_t pct; int32_t fixed; int32_t need; } c[] = {
            {50, 9, 3}, {0, 9, 2}, {100, 9, 6}, {300, 9, 6}, {34, 9, 2}, {84, 9, 5}, {-1, 1, 2}, {-1, 2, 2}, {-1, 3, 3}, {-1, 4, 4},
            {-1, 6, 6}, {-1, 9, 6}, {-2, 4, 0 + 2}};
        for (size_t i = 0; i < sizeof c / sizeof c[0]; ++i) {
            deal_run(&f, 1, 4, 3, 0, 100, c[i].pct, c[i].fixed);
            f.cycle = 1;
            CHECK_INT(visit(&f, 0), MP_OK);
            CHECK_INT(ob(&f, O_HALFTOTAL), 6);
            CHECK_INT(ob(&f, O_NEEDED), c[i].need);
        }
        /* two pages: the pair count is that of all pages (6 of 12 cells), not of one page */
        deal_run(&f, 2, 2, 3, 0, 100, 100, 2);
        f.cycle = 1;
        CHECK_INT(visit(&f, 0), MP_OK);
        CHECK_INT(ob(&f, O_HALFTOTAL), 6);
        CHECK_INT(ob(&f, O_HALFPAGE), 3);
        CHECK_INT(ob(&f, O_NEEDED), 6);
        /* one pair only: the floor 2 is capped to the pair count 1 */
        deal_run(&f, 1, 2, 1, 0, 100, -1, 5);
        f.cycle = 1;
        CHECK_INT(visit(&f, 0), MP_OK);
        CHECK_INT(ob(&f, O_NEEDED), 1);
    }
    /* ten pages of tiles cannot exist; the largest deal (3 pages x 6 x 4 = 72 cells) fills every cell exactly once */
    deal_run(&f, 3, 6, 4, 1, 100, -1, 2);
    put32(f.body, B_SCOLS, 6);
    put32(f.body, B_SROWS, 2);
    f.cycle = 1;
    CHECK_INT(visit(&f, 0), MP_OK);
    {
        int count[12] = {0};
        for (int i = 0; i < 72; ++i) {
            CHECK(cell_id(&f, i) >= 0 && cell_id(&f, i) < 12);
            if (cell_id(&f, i) >= 0 && cell_id(&f, i) < 12) ++count[cell_id(&f, i)];
        }
        for (int i = 0; i < 12; ++i) CHECK(count[i] % 2 == 0);
        for (int i = 0; i < 12; ++i) CHECK_INT(get32(f.obj.used, (size_t)i * 4u), 1);
    }
}

/* ---- pointer ------------------------------------------------------------------------------------------------------------------- */

static void t_pointer(void)
{
    Fx f;
    MpPointerResult p;
    fx_init(&f);
    /* inactive object: nothing is touched */
    put32(f.obj.b, O_HIT, 77);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, 110, 210, &p), MP_OK);
    CHECK(p.hit == 0 && p.candidate == -1 && p.wrote_cursor == 0);
    CHECK_INT(ob(&f, O_HIT), 77);
    start(&f);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, 110, 210, &p), MP_OK);
    CHECK(p.hit == 1 && p.candidate == 0x2769 && p.wrote_cursor == 1 && p.cursor == 0 && p.cursor_flag == 1);
    CHECK_INT(ob(&f, O_HIT), 0);
    /* every edge of tile 0 (100,200)-(140,240) shrinks by 3 pixels; the view origin is not added */
    {
        static const struct { int x, y, hit; } e[] = {{103, 203, 1}, {102, 203, 0}, {103, 202, 0}, {137, 237, 1}, {138, 237, 0},
                                                     {137, 238, 0}, {103, 237, 1}, {137, 203, 1}, {113, 213, 1}};
        for (size_t i = 0; i < sizeof e / sizeof e[0]; ++i) {
            CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, (int16_t)e[i].x, (int16_t)e[i].y, &p), MP_OK);
            CHECK_INT(p.hit, e[i].hit);
            CHECK_INT(ob(&f, O_HIT), e[i].hit ? 0 : -1);
            CHECK_INT(p.candidate, e[i].hit ? 0x2769 : -1);
        }
    }
    for (int j = 1; j < 4; ++j) {
        CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, (int16_t)tile_x(j), (int16_t)tile_y(j), &p), MP_OK);
        CHECK(p.hit == 1);
        CHECK_INT(ob(&f, O_HIT), j);
    }
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, 320, 220, &p), MP_OK); /* tile 4 does not exist on a 2 x 2 page */
    CHECK(p.hit == 0);
    /* negative coordinates and the far corner */
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, -5, -5, &p), MP_OK);
    CHECK(p.hit == 0 && p.candidate == -1 && p.wrote_cursor == 0 && p.cursor == 0 && p.cursor_flag == 0);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, 32767, 32767, &p), MP_OK);
    CHECK(p.hit == 0);
    /* the pointer writes only what it reports: a face-up and a matched tile are not hit */
    put32(f.obj.cells, 4, 1);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, (int16_t)tile_x(0), (int16_t)tile_y(0), &p), MP_OK);
    CHECK(p.hit == 0);
    put32(f.obj.cells, 4, 0);
    put32(f.obj.cells, 8, 1);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, (int16_t)tile_x(0), (int16_t)tile_y(0), &p), MP_OK);
    CHECK(p.hit == 0);
    put32(f.obj.cells, 8, 0);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, (int16_t)tile_x(0), (int16_t)tile_y(0), &p), MP_OK);
    CHECK(p.hit == 1);
    /* overlapping tiles: the first free one in index order wins */
    put_rect(f.body, B_TILES + 16, 100, 200, 140, 240);
    put32(f.obj.cells, 4, 1);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, 110, 210, &p), MP_OK);
    CHECK(p.hit == 1);
    CHECK_INT(ob(&f, O_HIT), 1);
    put32(f.obj.cells, 4, 0);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, 110, 210, &p), MP_OK);
    CHECK_INT(ob(&f, O_HIT), 0);
    /* won or lost: the receiver returns before it looks at anything */
    put32(f.obj.b, O_HIT, 55);
    put32(f.obj.b, O_WON, 1);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, 110, 210, &p), MP_OK);
    CHECK(p.hit == 0 && p.candidate == -1);
    CHECK_INT(ob(&f, O_HIT), 55);
    put32(f.obj.b, O_WON, 0);
    put32(f.obj.b, O_LOST, 1);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, 110, 210, &p), MP_OK);
    CHECK(p.hit == 0);
    CHECK_INT(ob(&f, O_HIT), 55);
    put32(f.obj.b, O_LOST, 0);
    /* arguments */
    CHECK_INT(mp_pointer(NULL, f.body, MP_BODY_BYTES, 0, 0, &p), MP_ERR_ARGUMENT);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, 0, 0, NULL), MP_ERR_ARGUMENT);
    CHECK_INT(mp_pointer(&f.obj, NULL, MP_BODY_BYTES, 0, 0, &p), MP_ERR_ARGUMENT);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES - 1u, 0, 0, &p), MP_ERR_ARGUMENT);
    /* a tile index outside the table (a body that was edited after the deal) is refused */
    put32(f.obj.b, O_PAGE, 1);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, 110, 210, &p), MP_ERR_BOUNDS);
    put32(f.obj.b, O_PAGE, -1);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, 110, 210, &p), MP_ERR_BOUNDS);
}

static void tabs_fixture(Fx *f)
{
    fx_init(f);
    f->body[B_TABS] = 1;
    put32(f->body, B_PAGES, 2);
    put32(f->body, B_COLS, 2);
    put32(f->body, B_ROWS, 1);
    f->cycle = 1;
    CHECK_INT(visit(f, 0), MP_OK);
}

static void t_tabs(void)
{
    Fx f;
    MpPointerResult p;
    tabs_fixture(&f);
    /* page 0, hot rectangle k at (400 + 20 k, 10)-(415 + 20 k, 30), inclusive, not view relative */
    {
        static const struct { int x, y, hit, k; } e[] = {{420, 10, 1, 1}, {419, 10, 0, -1}, {435, 30, 1, 1}, {436, 30, 0, -1}, {425, 31, 0, -1},
                                                        {425, 9, 0, -1}, {505, 20, 0, -1}, {405, 20, 1, 0}, {445, 20, 1, 2}, {456, 20, 0, -1}};
        for (size_t i = 0; i < sizeof e / sizeof e[0]; ++i) {
            CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, (int16_t)e[i].x, (int16_t)e[i].y, &p), MP_OK);
            CHECK_INT(p.hit, e[i].hit);
            CHECK_INT(p.candidate, e[i].hit ? 0x2768 : -1);
            if (e[i].hit) {
                CHECK_INT(ob(&f, O_HIT), e[i].k);
                CHECK(p.wrote_cursor == 1 && p.cursor == 0 && p.cursor_flag == 1);
            }
        }
    }
    /* the tab test runs before the tiles and ignores the page of the tab strip: page 1 of the object uses the page 1 rectangles */
    put32(f.obj.b, O_PAGE, 1);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, 425, 20, &p), MP_OK);
    CHECK(p.hit == 0);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, 525, 20, &p), MP_OK);
    CHECK(p.hit == 1 && p.candidate == 0x2768);
    CHECK_INT(ob(&f, O_HIT), 1);
    /* page 1 tiles are cells 2 + j */
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, (int16_t)tile_x(1), (int16_t)tile_y(1), &p), MP_OK);
    CHECK(p.hit == 1 && p.candidate == 0x2769);
    CHECK_INT(ob(&f, O_HIT), 1);
    put32(f.obj.cells, 3 * 12 + 4, 1); /* cell 3 = page 1 tile 1 face up */
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, (int16_t)tile_x(1), (int16_t)tile_y(1), &p), MP_OK);
    CHECK(p.hit == 0);
    put32(f.obj.cells, 3 * 12 + 4, 0);
    /* the tab test precedes the tile test */
    put32(f.obj.b, O_PAGE, 0);
    put_rect(f.body, B_TABHOT + 2 * 16, 100, 200, 140, 240);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, 110, 210, &p), MP_OK);
    CHECK(p.hit == 1 && p.candidate == 0x2768);
    CHECK_INT(ob(&f, O_HIT), 2);
    /* tabs off: the same point is a tile */
    f.body[B_TABS] = 0;
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, 110, 210, &p), MP_OK);
    CHECK(p.hit == 1 && p.candidate == 0x2769);
}

/* ---- click ------------------------------------------------------------------------------------------------------------------- */

static void t_click_guards(void)
{
    Fx f;
    MpObject fresh;
    start(&f);
    put32(f.obj.b, O_HIT, 0);
    /* wrong candidate, wrong row phase, wrong state and an inactive object do nothing */
    CHECK_INT(click(&f, 0x2767, 1u), MP_OK);
    CHECK_INT(click(&f, 0x276a, 1u), MP_OK);
    CHECK_INT(click(&f, -1, 1u), MP_OK);
    CHECK_INT(click(&f, 0x2769, 0u), MP_OK);
    CHECK_INT(click(&f, 0x2769, 2u), MP_OK);
    put32(f.obj.b, O_STATE, 1);
    CHECK_INT(click(&f, 0x2769, 1u), MP_OK);
    put32(f.obj.b, O_STATE, 3);
    CHECK_INT(click(&f, 0x2769, 1u), MP_OK);
    put32(f.obj.b, O_STATE, 0);
    CHECK_LOG(&f, "");
    CHECK_INT(cell_up(&f, 0), 0);
    CHECK_INT(ob(&f, O_FIRST), 0);
    CHECK_INT(click(&f, 0x2769, 1u), MP_OK); /* now it acts */
    CHECK_INT(cell_up(&f, 0), 1);
    CHECK_INT(ob(&f, 0x2b4), 0); /* the click stores the cell index it works on */
    /* both flipped cells set without a pending flip-back (not reachable in play): a third tile does not turn */
    start(&f);
    put32(f.obj.b, O_FIRST, (int32_t)MP_GUEST_CELLS);
    put32(f.obj.b, O_SECOND, (int32_t)(MP_GUEST_CELLS + 12u));
    put32(f.obj.b, O_HIT, 2);
    CHECK_INT(click(&f, 0x2769, 1u), MP_OK);
    CHECK_INT(cell_up(&f, 2), 0);
    start(&f);
    put32(f.obj.b, O_HIT, 0);
    CHECK_INT(click(&f, 0x2769, 1u), MP_OK);
    /* inactive object: only the body pointer is stored */
    mp_object_reset(&fresh);
    CHECK_INT(mp_click(&fresh, NULL, 0, 0x55u, 1u, 0x2769, &f.host), MP_OK);
    CHECK_INT(get32(fresh.b, O_BODY), 0x55);
    CHECK_INT(mp_object_active(&fresh), 0);
    CHECK_INT(get32(fresh.b, O_FIRST), 0);
    /* arguments */
    CHECK_INT(mp_click(NULL, f.body, MP_BODY_BYTES, 1u, 1u, 0x2769, &f.host), MP_ERR_ARGUMENT);
    CHECK_INT(mp_click(&f.obj, f.body, MP_BODY_BYTES, 1u, 1u, 0x2769, NULL), MP_ERR_ARGUMENT);
    CHECK_INT(mp_click(&f.obj, NULL, MP_BODY_BYTES, 1u, 1u, 0x2769, &f.host), MP_ERR_ARGUMENT);
    CHECK_INT(mp_click(&f.obj, f.body, MP_BODY_BYTES - 1u, 1u, 1u, 0x2769, &f.host), MP_ERR_ARGUMENT);
    {
        MpHost h = f.host;
        h.complete = NULL;
        CHECK_INT(mp_click(&f.obj, f.body, MP_BODY_BYTES, 1u, 1u, 0x2769, &h), MP_ERR_ARGUMENT);
    }
    CHECK_INT(click(&f, 0x2769, 1u), MP_OK);
    CHECK_INT(ob(&f, O_BODY), HANDLE);
}

static void t_click_pair(void)
{
    Fx f;
    start(&f);
    /* first tile: face up, remembered as the first flipped cell, the flip sound (NO SOUND) plays nothing */
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_LOG(&f, "caps;");
    CHECK_INT(cell_up(&f, 0), 1);
    CHECK_INT(ob(&f, O_FIRST), (int32_t)MP_GUEST_CELLS);
    CHECK_INT(ob(&f, O_SECOND), 0);
    CHECK_INT(ob(&f, 0x2b4), 0);
    /* the same tile again: it is face up, nothing happens */
    CHECK_INT(click(&f, 0x2769, 1u), MP_OK);
    CHECK_LOG(&f, "");
    CHECK_INT(ob(&f, O_SECOND), 0);
    /* the matching tile: a pair */
    CHECK_INT(flip(&f, 3), MP_OK);
    CHECK_LOG(&f, "caps;");
    CHECK_INT(cell_done(&f, 0), 1);
    CHECK_INT(cell_done(&f, 3), 1);
    CHECK_INT(cell_up(&f, 3), 1);
    CHECK_INT(ob(&f, O_PAIRS), 1);
    CHECK_INT(ob(&f, O_TRIES), 1);
    CHECK_INT(ob(&f, O_FIRST), 0);
    CHECK_INT(ob(&f, O_SECOND), 0);
    CHECK_INT(ob(&f, O_WON), 0);
    CHECK_INT(ob(&f, O_LOST), 0);
    CHECK_INT(ob(&f, O_FLIPBACK), 0);
    CHECK_INT(ob(&f, O_SNDMATCH), -1);
    CHECK_INT(ob(&f, 0x2b4), 3);
    /* the second pair wins (2 of 2 needed, 2 of 3 tries) */
    CHECK_INT(flip(&f, 1), MP_OK);
    CHECK_INT(flip(&f, 2), MP_OK);
    CHECK_INT(ob(&f, O_PAIRS), 2);
    CHECK_INT(ob(&f, O_TRIES), 2);
    CHECK_INT(ob(&f, O_WON), 1);
    CHECK_INT(ob(&f, O_LOST), 0);
    CHECK_INT(ob(&f, O_SNDMATCH), -1); /* the match sound is not picked once won */
    /* a matched tile cannot be flipped again */
    put32(f.obj.b, O_WON, 0);
    CHECK_INT(flip(&f, 0), -1);
}

static void t_click_mismatch(void)
{
    Fx f;
    start(&f);
    f.now = 20000;
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_INT(flip(&f, 1), MP_OK); /* ids 0 and 1 */
    CHECK_INT(ob(&f, O_TRIES), 1);
    CHECK_INT(ob(&f, O_PAIRS), 0);
    CHECK_INT(ob(&f, O_FLIPBACK), 1);
    CHECK_INT(ob(&f, O_DEADLINE), 20500);
    CHECK_INT(ob(&f, O_FIRST), (int32_t)MP_GUEST_CELLS);
    CHECK_INT(ob(&f, O_SECOND), (int32_t)(MP_GUEST_CELLS + 12u));
    CHECK_INT(ob(&f, O_SNDWRONG), -1);
    CHECK_INT(cell_up(&f, 0), 1);
    CHECK_INT(cell_up(&f, 1), 1);
    CHECK_INT(cell_done(&f, 0), 0);
    /* a flip while the flip-back is pending does nothing */
    CHECK_INT(click(&f, 0x2769, 1u), MP_OK);
    put32(f.obj.b, O_HIT, 2);
    CHECK_INT(click(&f, 0x2769, 1u), MP_OK);
    CHECK_INT(cell_up(&f, 2), 0);
    CHECK_LOG(&f, "");
    /* the handler waits for the deadline: strictly later than 20500 */
    f.now = 20500;
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(ob(&f, O_FLIPBACK), 1);
    CHECK_INT(cell_up(&f, 0), 1);
    CHECK(f.res.phase_after == 1u && f.res.completed == 0);
    f.now = 20501;
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(ob(&f, O_FLIPBACK), 0);
    CHECK_INT(ob(&f, O_DEADLINE), 0);
    CHECK_INT(ob(&f, O_FIRST), 0);
    CHECK_INT(ob(&f, O_SECOND), 0);
    CHECK_INT(cell_up(&f, 0), 0);
    CHECK_INT(cell_up(&f, 1), 0);
    CHECK_INT(ob(&f, O_TRIES), 1);
    /* a flip-back whose cell pointers are not cells is refused (a corrupt object) */
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_INT(flip(&f, 1), MP_OK);
    f.now = 99999;
    put32(f.obj.b, O_FIRST, 4);
    CHECK_INT(visit(&f, 1), MP_ERR_BOUNDS);
    put32(f.obj.b, O_FIRST, (int32_t)(MP_GUEST_CELLS + 6u));
    CHECK_INT(visit(&f, 1), MP_ERR_BOUNDS);
    put32(f.obj.b, O_FIRST, (int32_t)(MP_GUEST_CELLS + 4u));
    CHECK_INT(visit(&f, 1), MP_ERR_BOUNDS);
    put32(f.obj.b, O_FIRST, (int32_t)(MP_GUEST_CELLS - 12u));
    CHECK_INT(visit(&f, 1), MP_ERR_BOUNDS);
    put32(f.obj.b, O_FIRST, (int32_t)(MP_GUEST_CELLS + 72u * 12u));
    CHECK_INT(visit(&f, 1), MP_ERR_BOUNDS);
    put32(f.obj.b, O_FIRST, (int32_t)MP_GUEST_CELLS);
    put32(f.obj.b, O_SECOND, 0);
    CHECK_INT(visit(&f, 1), MP_ERR_BOUNDS);
    put32(f.obj.b, O_SECOND, (int32_t)(MP_GUEST_CELLS + 71u * 12u));
    CHECK_INT(visit(&f, 1), MP_OK);
    /* the 32-bit tick wraps: a deadline that wrapped is below the tick and flips back at once (unsigned compare) */
    start(&f);
    f.now = 0xfffffff0u;
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_INT(flip(&f, 1), MP_OK);
    CHECK_INT(ob(&f, O_DEADLINE), (int32_t)(0xfffffff0u + 500u));
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(ob(&f, O_FLIPBACK), 0);
    /* negative delay: the deadline is before the tick */
    start(&f);
    put32(f.body, B_DELAY, -1);
    f.now = 5000;
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_INT(flip(&f, 1), MP_OK);
    CHECK_INT(ob(&f, O_DEADLINE), 4999);
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(ob(&f, O_FLIPBACK), 0);
}

static void t_end_conditions(void)
{
    Fx f;
    /* tries allowed 1: the first mismatch loses (allowed <= tries) and plays no wrong sound */
    start(&f);
    put32(f.body, B_TRIES, 1);
    set_sound(f.body, B_WRONG, 0, "Wrong", 8, "", "");
    f.rnd_n = 0;
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_INT(flip(&f, 1), MP_OK);
    CHECK_INT(ob(&f, O_LOST), 1);
    CHECK_INT(ob(&f, O_WON), 0);
    CHECK_INT(ob(&f, O_SNDWRONG), 0); /* the pick did not run: the field keeps its initial value */
    CHECK(strstr(f.log, "prep") == NULL);
    CHECK_INT(ob(&f, O_FLIPBACK), 1); /* the flip-back is still armed */
    /* tries allowed 2, first mismatch: not lost yet and the wrong sound is picked (record 0 is the only one) */
    start(&f);
    put32(f.body, B_TRIES, 2);
    set_sound(f.body, B_WRONG, 0, "Wrong", 8, "", "");
    f.rnd_n = 0;
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_INT(flip(&f, 1), MP_OK);
    CHECK_INT(ob(&f, O_LOST), 0);
    CHECK_INT(ob(&f, O_SNDWRONG), 0);
    CHECK_LOG(&f, "caps;prep=856:Wrong;play=8;caps;");
    /* a match with tries == allowed wins (the trial counter is not above the allowance) */
    start(&f);
    put32(f.obj.b, O_PAIRS, 1);
    put32(f.obj.b, O_TRIES, 2);
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_INT(flip(&f, 3), MP_OK);
    CHECK_INT(ob(&f, O_WON), 1);
    /* tries above the allowance with the pairs complete: neither won nor lost, and the match sound plays */
    start(&f);
    set_sound(f.body, B_MATCH, 2, "Match", 9, "", "");
    put32(f.obj.b, O_PAIRS, 1);
    put32(f.obj.b, O_TRIES, 3);
    f.rnd_n = 0;
    {
        static const int32_t r[1] = {2};
        rnd_set(&f, 1, r);
    }
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_INT(flip(&f, 3), MP_OK);
    CHECK_INT(ob(&f, O_PAIRS), 2);
    CHECK_INT(ob(&f, O_TRIES), 4);
    CHECK_INT(ob(&f, O_WON), 0);
    CHECK_INT(ob(&f, O_LOST), 0);
    CHECK_INT(ob(&f, O_SNDMATCH), 2);
    CHECK_LOG(&f, "caps;prep=634:Match;play=9;caps;");
    /* tries above the allowance with pairs missing: lost */
    start(&f);
    put32(f.obj.b, O_TRIES, 3);
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_INT(flip(&f, 3), MP_OK);
    CHECK_INT(ob(&f, O_PAIRS), 1);
    CHECK_INT(ob(&f, O_LOST), 1);
    CHECK_INT(ob(&f, O_WON), 0);
    /* a mismatch that is not the last try with pairs missing: neither */
    start(&f);
    put32(f.obj.b, O_TRIES, 1);
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_INT(flip(&f, 1), MP_OK);
    CHECK_INT(ob(&f, O_TRIES), 2);
    CHECK_INT(ob(&f, O_LOST), 0);
    CHECK_INT(ob(&f, O_WON), 0);
}

static void t_tab_click(void)
{
    Fx f;
    MpPointerResult p;
    tabs_fixture(&f);
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, 525 - 100, 20, &p), MP_OK); /* page 0 rectangle k = 1 */
    CHECK_INT(ob(&f, O_HIT), 1);
    CHECK_INT(click(&f, 0x2768, 1u), MP_OK);
    CHECK_INT(ob(&f, O_PAGE), 1);
    CHECK_LOG(&f, "play=23;");
    /* tiles of page 1 */
    CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, (int16_t)tile_x(0), (int16_t)tile_y(0), &p), MP_OK);
    CHECK_INT(click(&f, 0x2769, 1u), MP_OK);
    CHECK_INT(cell_up(&f, 2), 1);
    CHECK_INT(cell_up(&f, 0), 0);
    CHECK_INT(ob(&f, O_FIRST), (int32_t)(MP_GUEST_CELLS + 24u));
    /* a hot rectangle beyond the last page, a negative index */
    put32(f.obj.b, O_HIT, 2);
    CHECK_INT(click(&f, 0x2768, 1u), MP_ERR_BOUNDS);
    put32(f.obj.b, O_HIT, -1);
    CHECK_INT(click(&f, 0x2768, 1u), MP_ERR_BOUNDS);
    put32(f.obj.b, O_HIT, 0);
    CHECK_INT(click(&f, 0x2768, 1u), MP_OK);
    CHECK_INT(ob(&f, O_PAGE), 0);
    /* a tile index outside the table */
    put32(f.obj.b, O_HIT, 4);
    put32(f.obj.b, O_PAGE, 1);
    CHECK_INT(click(&f, 0x2769, 1u), MP_ERR_BOUNDS);
    put32(f.obj.b, O_HIT, 4);
    put32(f.obj.b, O_PAGE, 0); /* index 4 of a table of 4 */
    CHECK_INT(click(&f, 0x2769, 1u), MP_ERR_BOUNDS);
    put32(f.obj.b, O_HIT, -1);
    put32(f.obj.b, O_PAGE, 0);
    CHECK_INT(click(&f, 0x2769, 1u), MP_ERR_BOUNDS);
    put32(f.obj.b, O_HIT, 3);
    put32(f.obj.b, O_PAGE, 0);
    CHECK_INT(click(&f, 0x2769, 1u), MP_OK);
    /* a first cell that is not a cell of the table */
    put32(f.obj.b, O_HIT, 1);
    put32(f.obj.b, O_FIRST, 7);
    CHECK_INT(click(&f, 0x2769, 1u), MP_ERR_BOUNDS);
    CHECK_LOG(&f, "");
}

static void t_sounds_and_captions(void)
{
    Fx f;
    char text[200];
    /* the flip sounds: prepare with the record offset, play the channel, then the caption check */
    start(&f);
    set_sound(f.body, B_FLIP1, 0, "Flip", 5, "", "");
    set_sound(f.body, B_FLIP2, 0, "Flop", -3, "", "");
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_LOG(&f, "prep=35c:Flip;play=5;caps;");
    CHECK_INT(flip(&f, 1), MP_OK);
    CHECK_LOG(&f, "prep=412:Flop;play=-3;caps;");
    /* NO SOUND in any letter case plays nothing; a name that only starts with it plays */
    start(&f);
    set_sound(f.body, B_FLIP1, 0, "no sound", 5, "", "");
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_LOG(&f, "caps;");
    start(&f);
    set_sound(f.body, B_FLIP1, 0, "No SoUnD", 5, "", "");
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_LOG(&f, "caps;");
    start(&f);
    set_sound(f.body, B_FLIP1, 0, "NO SOUND2", 5, "", "");
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_LOG(&f, "prep=35c:NO SOUND2;play=5;caps;");
    start(&f);
    set_sound(f.body, B_FLIP1, 0, "NO SOUN", 5, "", "");
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_LOG(&f, "prep=35c:NO SOUN;play=5;caps;");
    start(&f);
    set_sound(f.body, B_FLIP1, 0, "", 5, "", "");
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_LOG(&f, "prep=35c:;play=5;caps;");
    /* captions: found key, not found key, empty key, empty text */
    start(&f);
    f.captions = 1;
    set_sound(f.body, B_FLIP1, 0, "NO SOUND", 0, "K1", "Fallback");
    f.auto_key = "K1";
    f.auto_text = "Hello";
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_LOG(&f, "caps;auto=K1;cap=Hello<n><e>;");
    start(&f);
    f.captions = 1;
    set_sound(f.body, B_FLIP1, 0, "NO SOUND", 0, "K2", "Fallback");
    f.auto_key = "K1";
    f.auto_text = "Hello";
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_LOG(&f, "caps;auto=K2;cap=Fallback<n><e>;");
    start(&f);
    f.captions = 1;
    set_sound(f.body, B_FLIP1, 0, "NO SOUND", 0, "", "Text only");
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_LOG(&f, "caps;cap=Text only<n><e>;");
    start(&f);
    f.captions = 1;
    set_sound(f.body, B_FLIP1, 0, "NO SOUND", 0, "K2", "");
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_LOG(&f, "caps;auto=K2;");
    start(&f);
    f.captions = 1;
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_LOG(&f, "caps;");
    start(&f);
    f.captions = 0;
    set_sound(f.body, B_FLIP1, 0, "NO SOUND", 0, "K1", "Fallback");
    f.auto_key = "K1";
    f.auto_text = "Hello";
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_LOG(&f, "caps;");
    /* the 104-byte local of the caption writer: text + "<n><e>" + NUL */
    memset(text, 'x', sizeof text);
    text[97] = 0;
    start(&f);
    f.captions = 1;
    set_sound(f.body, B_FLIP1, 0, "NO SOUND", 0, "K1", "");
    f.auto_key = "K1";
    f.auto_text = text;
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK(strstr(f.log, "<n><e>;") != NULL);
    text[97] = 'x';
    text[98] = 0;
    start(&f);
    f.captions = 1;
    set_sound(f.body, B_FLIP1, 0, "NO SOUND", 0, "K1", "");
    f.auto_key = "K1";
    f.auto_text = text;
    CHECK_INT(flip(&f, 0), MP_ERR_BOUNDS);
    CHECK(strstr(f.log, "cap=") == NULL);
    /* a text of 99 characters in the record (the field holds up to 99 plus the NUL) */
    memset(text, 'y', sizeof text);
    text[99] = 0;
    start(&f);
    f.captions = 1;
    set_sound(f.body, B_FLIP1, 0, "NO SOUND", 0, "", "");
    memset(f.body + B_FLIP1 + SR_TEXT, 'y', 99);
    f.body[B_FLIP1 + SR_TEXT + 99] = 0;
    CHECK_INT(flip(&f, 0), MP_ERR_BOUNDS);
    /* an AUTOTEXT string longer than 0x9c40 characters is ignored and the record text is used instead; one of exactly 0x9c40 is
     * taken (and then refused by the 104-byte local) */
    {
        static char big[0x9c42];
        memset(big, 'z', sizeof big);
        big[0x9c41] = 0;
        start(&f);
        f.captions = 1;
        set_sound(f.body, B_FLIP1, 0, "NO SOUND", 0, "K1", "Fallback");
        f.auto_key = "K1";
        f.auto_text = big;
        CHECK_INT(flip(&f, 0), MP_OK);
        CHECK_LOG(&f, "caps;auto=K1;cap=Fallback<n><e>;");
        big[0x9c40] = 0;
        start(&f);
        f.captions = 1;
        set_sound(f.body, B_FLIP1, 0, "NO SOUND", 0, "K1", "Fallback");
        f.auto_key = "K1";
        f.auto_text = big;
        CHECK_INT(flip(&f, 0), MP_ERR_BOUNDS);
    }
}

static void t_pick_sounds(void)
{
    Fx f;
    /* a pair with a match sound list [no sound, Ding, ...]: the pick redraws NO SOUND records (case-insensitive) */
    start(&f);
    set_sound(f.body, B_MATCH, 0, "no sound", 1, "", "");
    set_sound(f.body, B_MATCH, 1, "Ding", 2, "", "");
    set_sound(f.body, B_MATCH, 2, "NO SOUND", 3, "", "");
    {
        static const int32_t r[4] = {0, 7, 2, 6};
        rnd_set(&f, 4, r);
    }
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_INT(flip(&f, 3), MP_OK);
    CHECK_INT(ob(&f, O_SNDMATCH), 1);
    CHECK_INT(f.rnd_i, 4);
    CHECK_LOG(&f, "caps;prep=" "57e" ":Ding;play=2;caps;");
    /* the draw is taken modulo the list length (5 match records) */
    start(&f);
    set_sound(f.body, B_MATCH, 4, "Last", 1, "", "");
    {
        static const int32_t r[1] = {9};
        rnd_set(&f, 1, r);
    }
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_INT(flip(&f, 3), MP_OK);
    CHECK_INT(ob(&f, O_SNDMATCH), 4);
    CHECK(strstr(f.log, "Last") != NULL);
    /* the wrong list has 10 records */
    start(&f);
    set_sound(f.body, B_WRONG, 9, "End", 4, "", "");
    {
        static const int32_t r[1] = {19};
        rnd_set(&f, 1, r);
    }
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_INT(flip(&f, 1), MP_OK);
    CHECK_INT(ob(&f, O_SNDWRONG), 9);
    CHECK_LOG(&f, "caps;prep=" "ebc" ":End;play=4;caps;");
    /* a list in which the draws never reach a playable record ends with the stuck refusal */
    start(&f);
    set_sound(f.body, B_MATCH, 4, "Last", 1, "", "");
    f.rnd_n = 0; /* every draw is 0, record 0 is NO SOUND */
    CHECK_INT(flip(&f, 0), MP_OK);
    f.rand_calls = 0;
    CHECK_INT(flip(&f, 3), MP_ERR_STUCK);
    CHECK_INT(f.rand_calls, MP_PICK_LIMIT);
    /* the same for the id pick: a free id exists but every draw returns a used one */
    {
        static const int32_t r[3] = {0, 3, 0};
        deal_run(&f, 1, 2, 2, 0, 100, -1, 2);
        rnd_set(&f, 3, r);
        CHECK_INT(visit(&f, 0), MP_ERR_STUCK);
        CHECK_INT(f.rand_calls, 2 + MP_PICK_LIMIT); /* the pair of cell 0, then MP_PICK_LIMIT draws that never find a free id */
    }
    /* and for the partner cell: every draw returns the cell itself */
    {
        static const int32_t r[1] = {0};
        deal_run(&f, 1, 2, 2, 0, 100, -1, 2);
        rnd_set(&f, 1, r);
        f.rnd[0] = 0;
        f.rnd_n = 1;
        CHECK_INT(visit(&f, 0), MP_ERR_STUCK);
        CHECK_INT(f.rand_calls, 1 + MP_PICK_LIMIT); /* one id draw, then MP_PICK_LIMIT partner draws */
    }
}

/* ---- the handler states and the finish ------------------------------------------------------------------------------------- */

static void win_fixture(Fx *f)
{
    start(f);
    CHECK_INT(flip(f, 0), MP_OK);
    CHECK_INT(flip(f, 3), MP_OK);
    CHECK_INT(flip(f, 1), MP_OK);
    CHECK_INT(flip(f, 2), MP_OK);
    CHECK_INT(ob(f, O_WON), 1);
}

static void t_states_win(void)
{
    Fx f;
    win_fixture(&f);
    put32(f.obj.b, O_REDRAW, 0);
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(mp_object_state(&f.obj), MP_STATE_WIN_PICK);
    CHECK_INT(ob(&f, O_REDRAW), 1);
    CHECK_LOG(&f, "");
    CHECK(f.res.phase_after == 1u);
    /* all win sounds are NO SOUND: the pick ends with -1 and the handler leaves for phase 2 */
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(ob(&f, O_SNDWIN), -1);
    CHECK(f.res.phase_after == 2u);
    CHECK_INT(mp_object_state(&f.obj), MP_STATE_WIN_PICK);
    /* a name that only starts with NO SOUND is a sound: the exact 9-byte compare includes the terminator */
    win_fixture(&f);
    set_sound(f.body, B_WIN, 3, "NO SOUNDX", 7, "", "");
    {
        static const int32_t r[1] = {3};
        rnd_set(&f, 1, r);
    }
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(ob(&f, O_SNDWIN), 3);
    CHECK_INT(mp_object_state(&f.obj), MP_STATE_WIN_WAIT);
    CHECK(f.res.phase_after == 1u);
    /* with a playable record: play it and wait while the channel is busy */
    win_fixture(&f);
    set_sound(f.body, B_WIN, 3, "Fanfare", 7, "", "");
    {
        static const int32_t r[1] = {3};
        rnd_set(&f, 1, r);
    }
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_LOG(&f, "prep=1194:Fanfare;play=7;caps;");
    CHECK_INT(ob(&f, O_SNDWIN), 3);
    CHECK_INT(mp_object_state(&f.obj), MP_STATE_WIN_WAIT);
    CHECK(f.res.phase_after == 1u);
    f.busy_n = 2;
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_LOG(&f, "busy=7;");
    CHECK(f.res.phase_after == 1u);
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK(f.res.phase_after == 1u);
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK(f.res.phase_after == 2u);
    /* the win list has 10 records: a draw of 9 picks the last one, a draw of 10 wraps to the first */
    win_fixture(&f);
    set_sound(f.body, B_WIN, 9, "Last", 3, "", "");
    set_sound(f.body, B_WIN, 0, "First", 4, "", "");
    {
        static const int32_t r9[2] = {9, 10};
        rnd_set(&f, 2, r9);
    }
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(ob(&f, O_SNDWIN), 9);
    CHECK_INT(f.rnd_i, 1);
    win_fixture(&f);
    set_sound(f.body, B_WIN, 0, "First", 4, "", "");
    {
        static const int32_t r10[1] = {10};
        rnd_set(&f, 1, r10);
    }
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(ob(&f, O_SNDWIN), 0);
    /* a stray state value is ignored */
    win_fixture(&f);
    put32(f.obj.b, 0x10, 9);
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK(f.res.phase_after == 1u);
    /* the win check runs before the lose check; both set: the lose state is taken last */
    win_fixture(&f);
    put32(f.obj.b, O_LOST, 1);
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(mp_object_state(&f.obj), MP_STATE_LOSE_PICK);
}

static void t_states_lose(void)
{
    Fx f;
    start(&f);
    put32(f.obj.b, O_LOST, 1);
    put32(f.obj.b, O_REDRAW, 0);
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(mp_object_state(&f.obj), MP_STATE_LOSE_PICK);
    CHECK_INT(ob(&f, O_REDRAW), 1);
    set_sound(f.body, B_WRONG, 6, "Sad", 11, "", "");
    {
        static const int32_t r[1] = {6};
        rnd_set(&f, 1, r);
    }
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_LOG(&f, "prep=c9a:Sad;play=11;caps;");
    CHECK_INT(ob(&f, O_SNDWRONG), 6);
    CHECK_INT(mp_object_state(&f.obj), MP_STATE_LOSE_WAIT);
    f.busy_n = 1;
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_LOG(&f, "busy=11;");
    CHECK(f.res.phase_after == 1u);
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK(f.res.phase_after == 2u);
    /* the wrong list has 10 records: a draw of 9 picks the last one */
    start(&f);
    put32(f.obj.b, O_LOST, 1);
    set_sound(f.body, B_WRONG, 9, "Last", 3, "", "");
    {
        static const int32_t r9[1] = {9};
        rnd_set(&f, 1, r9);
    }
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(ob(&f, O_SNDWRONG), 9);
    /* without a playable record the lose pick goes to phase 2 at once */
    start(&f);
    put32(f.obj.b, O_LOST, 1);
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(ob(&f, O_SNDWRONG), -1);
    CHECK(f.res.phase_after == 2u);
}

static void t_phase2(void)
{
    Fx f;
    /* win: the win block */
    win_fixture(&f);
    CHECK_INT(visit(&f, 2), MP_OK);
    CHECK_LOG(&f, "inv=5;trans=100,1,2,3,11,12,13,s1;flag=5,9;done=3;rsurf=28673;rslot=24;");
    CHECK(f.res.completed == 1 && f.res.initialized == 0);
    CHECK_INT(mp_object_active(&f.obj), 0);
    CHECK_INT(mp_object_row(&f.obj), -1);
    CHECK_INT(mp_object_slot(&f.obj), -1);
    CHECK_INT(ob(&f, O_SURFACE), 0);
    CHECK_INT(ob(&f, O_CELLS), 0);
    CHECK_INT(ob(&f, O_USED), 0);
    CHECK_INT(ob(&f, O_BODY), 0);
    CHECK_INT(ob(&f, O_PERPAGE), 0);
    CHECK_INT(ob(&f, O_NEEDED), 0);
    CHECK_INT(ob(&f, O_IDS), 0);
    CHECK_INT(ob(&f, O_TOTAL), 4); /* the clear keeps the tile count and the view */
    CHECK_INT(ob(&f, O_VTABLE), (int32_t)MP_VTABLE);
    CHECK_INT(ob(&f, O_VIEW), 10);
    CHECK(ob(&f, O_WON) == 0 && ob(&f, O_LOST) == 0 && ob(&f, O_REDRAW) == 0 && ob(&f, O_STATE) == 0);
    /* a failing finish: the puzzle is already inactive, the entry and the surface are still held */
    win_fixture(&f);
    f.calls = 0;
    f.fail_at = 1;
    CHECK_INT(visit(&f, 2), MP_ERR_HOST);
    CHECK_LOG(&f, "inv=5;trans=100,1,2,3,11,12,13,s1;");
    CHECK_INT(mp_object_active(&f.obj), 0);
    CHECK_INT(mp_object_slot(&f.obj), 0x18);
    CHECK_INT(ob(&f, O_SURFACE), SURFACE);
    /* lose: the lose block (start word 1 stores 0, no event flag) */
    start(&f);
    put32(f.obj.b, O_LOST, 1);
    CHECK_INT(visit(&f, 2), MP_OK);
    CHECK_LOG(&f, "trans=200,4,5,6,21,22,23,s0;done=3;rsurf=28673;rslot=24;");
    /* neither won nor lost: no block, only the completion */
    start(&f);
    CHECK_INT(visit(&f, 2), MP_OK);
    CHECK_LOG(&f, "done=3;rsurf=28673;rslot=24;");
    CHECK(f.res.completed == 1);
    /* both won and lost: the win block */
    start(&f);
    put32(f.obj.b, O_LOST, 1);
    put32(f.obj.b, O_WON, 1);
    CHECK_INT(visit(&f, 2), MP_OK);
    CHECK(strstr(f.log, "trans=100,") != NULL);
    /* no scene (9999) and no flag (-1) */
    win_fixture(&f);
    set_block(f.body, B_BWIN, 9999, 1, 2, 3, 11, 12, 13, 0, -1, 9);
    CHECK_INT(visit(&f, 2), MP_OK);
    CHECK_LOG(&f, "done=3;rsurf=28673;rslot=24;");
    win_fixture(&f);
    set_block(f.body, B_BWIN, 9998, 1, 2, 3, 11, 12, 13, 1, 0, -2);
    CHECK_INT(visit(&f, 2), MP_OK);
    CHECK_LOG(&f, "inv=0;trans=9998,1,2,3,11,12,13,s0;flag=0,-2;done=3;rsurf=28673;rslot=24;");
    win_fixture(&f);
    set_block(f.body, B_BWIN, 100, 1, 2, 3, 11, 12, 13, 2, 4095, 5);
    CHECK_INT(visit(&f, 2), MP_OK);
    CHECK(strstr(f.log, "s1;") != NULL && strstr(f.log, "flag=4095,5;") != NULL);
    /* an event flag index the host refuses: nothing happens (validation precedes every effect) */
    win_fixture(&f);
    set_block(f.body, B_BWIN, 100, 1, 2, 3, 11, 12, 13, 0, 4096, 5);
    CHECK_INT(visit(&f, 2), MP_ERR_BOUNDS);
    CHECK_LOG(&f, "inv=4096;");
    CHECK_INT(mp_object_active(&f.obj), 1);
    win_fixture(&f);
    set_block(f.body, B_BWIN, 9999, 1, 2, 3, 11, 12, 13, 0, -7, 5);
    CHECK_INT(visit(&f, 2), MP_ERR_BOUNDS);
    /* the invalid flag of the block that is not taken does not matter */
    win_fixture(&f);
    set_block(f.body, B_BLOSE, 9999, 1, 2, 3, 11, 12, 13, 0, 4096, 5);
    CHECK_INT(visit(&f, 2), MP_OK);
}

static void t_step_refusals(void)
{
    Fx f;
    MpResult res;
    const char *why = NULL;
    fx_init(&f);
    CHECK_INT(mp_step(NULL, f.body, MP_BODY_BYTES, 1, 0, 0, &f.host, &res, &why), MP_ERR_ARGUMENT);
    CHECK_INT(mp_step(&f.obj, NULL, MP_BODY_BYTES, 1, 0, 0, &f.host, &res, &why), MP_ERR_ARGUMENT);
    CHECK_INT(mp_step(&f.obj, f.body, MP_BODY_BYTES, 1, 0, 0, NULL, &res, &why), MP_ERR_ARGUMENT);
    CHECK_INT(mp_step(&f.obj, f.body, MP_BODY_BYTES, 1, 0, 0, &f.host, NULL, &why), MP_ERR_ARGUMENT);
    {
        MpHost h = f.host;
        h.store_event_flag = NULL;
        CHECK_INT(mp_step(&f.obj, f.body, MP_BODY_BYTES, 1, 0, 0, &h, &res, &why), MP_ERR_ARGUMENT);
        CHECK_INT(mp_cleanup(&f.obj, &h), MP_ERR_ARGUMENT);
        CHECK_INT(mp_invalidate(&f.obj, &h), MP_ERR_ARGUMENT);
        CHECK_INT(mp_click(&f.obj, f.body, MP_BODY_BYTES, 1, 1, 0x2769, &h), MP_ERR_ARGUMENT);
        h = f.host;
        h.view = NULL;
        CHECK_INT(mp_step(&f.obj, f.body, MP_BODY_BYTES, 1, 0, 0, &h, &res, &why), MP_ERR_ARGUMENT);
    }
    /* phase 3 and above, phase 1 / 2 without phase 0, phase 1 / 2 of another row */
    CHECK_INT(visit(&f, 3), MP_ERR_UNSUPPORTED);
    CHECK(f.res.phase_after == 3u);
    CHECK_INT(visit(&f, 0xffffffffu), MP_ERR_UNSUPPORTED);
    CHECK_INT(visit(&f, 1), MP_ERR_UNSUPPORTED);
    CHECK_INT(visit(&f, 2), MP_ERR_UNSUPPORTED);
    CHECK(f.res.phase_after == 2u && f.res.completed == 0);
    CHECK_LOG(&f, "");
    start(&f);
    CHECK_INT(mp_step(&f.obj, f.body, MP_BODY_BYTES, 1, ROW + 1, 1, &f.host, &res, &why), MP_ERR_UNSUPPORTED);
    CHECK_INT(mp_step(&f.obj, f.body, MP_BODY_BYTES, 1, ROW + 1, 2, &f.host, &res, &why), MP_ERR_UNSUPPORTED);
    CHECK_INT(mp_step(&f.obj, f.body, MP_BODY_BYTES, 1, ROW - 1, 1, &f.host, &res, &why), MP_ERR_UNSUPPORTED);
    put32(f.obj.b, O_ACTIVE, 0);
    CHECK_INT(visit(&f, 1), MP_ERR_UNSUPPORTED);
    put32(f.obj.b, O_ACTIVE, 1);
    /* an invalid body is refused before any effect, in every phase */
    fx_init(&f);
    f.body[0x20] = 'Z';
    memset(f.body, 'Z', 0x21);
    CHECK_INT(visit(&f, 0), MP_ERR_BODY);
    CHECK_LOG(&f, "");
    CHECK(f.why != NULL && strstr(f.why, "name") != NULL);
    CHECK_INT(mp_object_active(&f.obj), 0);
    CHECK_INT(mp_step(&f.obj, f.body, MP_BODY_BYTES - 1u, 1, ROW, 0, &f.host, &res, NULL), MP_ERR_BODY);
    start(&f);
    memset(f.body, 'Z', 0x21);
    CHECK_INT(visit(&f, 1), MP_ERR_BODY);
    CHECK_INT(visit(&f, 2), MP_ERR_BODY);
    CHECK_LOG(&f, "");
    CHECK_INT(mp_object_active(&f.obj), 1);
    /* the result is cleared and carries the phase of a refused visit */
    memset(&res, 0xff, sizeof res);
    CHECK_INT(mp_step(&f.obj, f.body, MP_BODY_BYTES, 1, ROW, 1, &f.host, &res, &why), MP_ERR_BODY);
    CHECK(res.phase_after == 1u && res.initialized == 0 && res.completed == 0);
    /* the body pointer is stored again by every visit */
    start(&f);
    put32(f.obj.b, O_BODY, 5);
    CHECK_INT(visit(&f, 1), MP_OK);
    CHECK_INT(ob(&f, O_BODY), HANDLE);
}

static void t_host_failures(void)
{
    /* the n-th failable host call fails: the visit reports a host failure, never anything else, and a run without failure ends the
     * sweep */
    int failed_runs = 0;
    for (int n = 1; n < 80; ++n) {
        Fx f;
        int rc[8], ran = 0, any = 0;
        fx_init(&f);
        f.captions = 1;
        f.fail_at = n;
        f.now = 10000;
        set_sound(f.body, B_FLIP1, 0, "Flip", 5, "K1", "Fallback");
        set_sound(f.body, B_WIN, 0, "Win", 6, "", "Text");
        f.auto_key = "K1";
        f.auto_text = "Hello";
        f.cycle = 1;
        rc[ran++] = visit(&f, 0);
        if (rc[0] == MP_OK) rc[ran++] = flip(&f, 0);
        if (ran == 2 && rc[1] == MP_OK) {
            put32(f.obj.b, O_WON, 1);
            rc[ran++] = visit(&f, 1);
            rc[ran++] = visit(&f, 1);
            rc[ran++] = visit(&f, 1);
            rc[ran++] = visit(&f, 1);
            rc[ran++] = visit(&f, 2);
        }
        for (int i = 0; i < ran; ++i) {
            CHECK(rc[i] == MP_OK || rc[i] == MP_ERR_HOST || rc[i] == MP_ERR_UNSUPPORTED || rc[i] == MP_ERR_STUCK);
            if (rc[i] == MP_ERR_HOST) any = 1;
        }
        if (any) ++failed_runs;
        if (f.calls < n) break;
    }
    CHECK(failed_runs >= 20);
    {
        Fx f;
        fx_init(&f);
        f.fail_at = 1; /* the very first failable call is the start-flag store */
        f.cycle = 1;
        CHECK_INT(visit(&f, 0), MP_ERR_HOST);
        CHECK_LOG(&f, "start=1;");
    }
    {
        /* cleanup, invalidate and the finish fail through the host too */
        Fx f;
        start(&f);
        f.calls = 0;
        f.fail_at = 1;
        CHECK_INT(mp_cleanup(&f.obj, &f.host), MP_ERR_HOST); /* the surface release */
        start(&f);
        f.calls = 0;
        f.fail_at = 2;
        CHECK_INT(mp_cleanup(&f.obj, &f.host), MP_ERR_HOST); /* the slot release */
        start(&f);
        f.calls = 0;
        f.fail_at = 1;
        CHECK_INT(mp_invalidate(&f.obj, &f.host), MP_ERR_HOST);
    }
}

/* ---- render, cleanup, invalidate ---------------------------------------------------------------------------------------------- */

static void t_render(void)
{
    Fx f;
    MpRenderPlan plan;
    fx_init(&f);
    plan.valid = 7;
    CHECK_INT(mp_render_plan(&f.obj, f.body, MP_BODY_BYTES, &f.host, &plan), MP_OK);
    CHECK(plan.valid == 0 && plan.count == 0);
    start(&f);
    f.log[0] = 0;
    CHECK_INT(mp_render_plan(&f.obj, f.body, MP_BODY_BYTES, &f.host, &plan), MP_OK);
    CHECK_LOG(&f, "view;");
    CHECK(plan.valid == 1);
    CHECK_INT(plan.count, 5);
    CHECK(plan.blit[0].src_kind == 0 && plan.blit[0].label == MP_LABEL_BACKGROUND);
    CHECK(plan.blit[0].src[0] == 0 && plan.blit[0].src[1] == 5 && plan.blit[0].src[2] == 640 && plan.blit[0].src[3] == 485);
    CHECK(plan.blit[0].dst[0] == 10 && plan.blit[0].dst[1] == 20 && plan.blit[0].dst[2] == 650 && plan.blit[0].dst[3] == 500);
    {
        /* the background restore goes to the copy of the view taken at init, not to the live view cells */
        Fx g;
        MpRenderPlan p2;
        start(&g);
        for (int k = 0; k < 4; ++k) put32(g.obj.b, O_VIEWCOPY + 4 * (size_t)k, 31 + k);
        CHECK_INT(mp_render_plan(&g.obj, g.body, MP_BODY_BYTES, &g.host, &p2), MP_OK);
        CHECK(p2.blit[0].label == MP_LABEL_BACKGROUND);
        for (int k = 0; k < 4; ++k) CHECK_INT(p2.blit[0].dst[k], 31 + k);
    }
    CHECK_INT(ob(&f, O_REDRAW), 0);
    for (int j = 0; j < 4; ++j) {
        const MpBlit *b = &plan.blit[1 + j];
        CHECK(b->src_kind == 0 && b->label == MP_LABEL_HIDDEN);
        CHECK(b->src[0] == 100 + (j % 6) * 50 && b->src[1] == 200 && b->src[2] == 140 + (j % 6) * 50 && b->src[3] == 240);
        CHECK(b->dst[0] == 110 + (j % 6) * 50 && b->dst[1] == 220 && b->dst[2] == 150 + (j % 6) * 50 && b->dst[3] == 260);
    }
    /* second call: no background restore; a face-up tile shows its picture */
    CHECK_INT(flip(&f, 1), MP_OK);
    CHECK_INT(mp_render_plan(&f.obj, f.body, MP_BODY_BYTES, &f.host, &plan), MP_OK);
    CHECK_INT(plan.count, 4);
    CHECK(plan.blit[0].label == MP_LABEL_HIDDEN);
    CHECK(plan.blit[1].src_kind == 1 && plan.blit[1].label == MP_LABEL_VISIBLE);
    CHECK(plan.blit[1].src[0] == 17 && plan.blit[1].src[1] == 18 && plan.blit[1].src[2] == 25 && plan.blit[1].src[3] == 26); /* id 1 */
    CHECK(plan.blit[1].dst[0] == 160 && plan.blit[1].dst[1] == 220 && plan.blit[1].dst[2] == 200 && plan.blit[1].dst[3] == 260);
    CHECK(plan.blit[2].label == MP_LABEL_HIDDEN);
    /* the redraw flag asks for the restore again */
    put32(f.obj.b, O_REDRAW, 1);
    CHECK_INT(mp_render_plan(&f.obj, f.body, MP_BODY_BYTES, &f.host, &plan), MP_OK);
    CHECK_INT(plan.count, 5);
    /* tabs: the tab picture of the page precedes the tiles; page 1 tiles are 2 + j */
    tabs_fixture(&f);
    CHECK_INT(mp_render_plan(&f.obj, f.body, MP_BODY_BYTES, &f.host, &plan), MP_OK);
    CHECK_INT(plan.count, 4);
    CHECK(plan.blit[1].src_kind == 1 && plan.blit[1].label == MP_LABEL_TAB);
    CHECK(plan.blit[1].src[0] == 500 && plan.blit[1].src[2] == 520);
    CHECK(plan.blit[1].dst[0] == 310 && plan.blit[1].dst[1] == 30 && plan.blit[1].dst[2] == 340 && plan.blit[1].dst[3] == 60);
    put32(f.obj.b, O_PAGE, 1);
    put32(f.obj.cells, 3 * 12 + 4, 1);
    CHECK_INT(mp_render_plan(&f.obj, f.body, MP_BODY_BYTES, &f.host, &plan), MP_OK);
    CHECK_INT(plan.count, 3);
    CHECK(plan.blit[0].label == MP_LABEL_TAB && plan.blit[0].src[0] == 501);
    CHECK(plan.blit[1].label == MP_LABEL_HIDDEN && plan.blit[2].label == MP_LABEL_VISIBLE);
    CHECK(plan.blit[2].src[0] == get32(f.obj.cells, 36) * 16 + 1);
    /* a picture id outside the 12 pictures, a cell outside the table, a host failure */
    put32(f.obj.cells, 3 * 12, 12);
    CHECK_INT(mp_render_plan(&f.obj, f.body, MP_BODY_BYTES, &f.host, &plan), MP_ERR_BOUNDS);
    put32(f.obj.cells, 3 * 12, -1);
    CHECK_INT(mp_render_plan(&f.obj, f.body, MP_BODY_BYTES, &f.host, &plan), MP_ERR_BOUNDS);
    put32(f.obj.cells, 3 * 12, 11);
    CHECK_INT(mp_render_plan(&f.obj, f.body, MP_BODY_BYTES, &f.host, &plan), MP_OK);
    put32(f.obj.b, O_PAGE, 2);
    CHECK_INT(mp_render_plan(&f.obj, f.body, MP_BODY_BYTES, &f.host, &plan), MP_ERR_BOUNDS);
    {
        /* one tile per page (a shuffle over two pages): the first tile index past the table is the total itself */
        Fx g;
        fx_init(&g);
        g.body[B_SHUFFLE] = 1;
        put32(g.body, B_PAGES, 2);
        put32(g.body, B_COLS, 1);
        put32(g.body, B_ROWS, 1);
        g.cycle = 1;
        CHECK_INT(visit(&g, 0), MP_OK);
        CHECK_INT(ob(&g, O_TOTAL), 2);
        put32(g.obj.b, O_PAGE, 1);
        CHECK_INT(mp_render_plan(&g.obj, g.body, MP_BODY_BYTES, &g.host, &plan), MP_OK);
        put32(g.obj.b, O_PAGE, 2);
        CHECK_INT(mp_render_plan(&g.obj, g.body, MP_BODY_BYTES, &g.host, &plan), MP_ERR_BOUNDS);
        put32(g.obj.b, O_PAGE, 0);
        put32(g.obj.b, O_HIT, 2);
        CHECK_INT(click(&g, 0x2769, 1u), MP_ERR_BOUNDS); /* index 2 of a table of 2 */
        put32(g.obj.b, O_HIT, 1);
        CHECK_INT(click(&g, 0x2769, 1u), MP_OK);
    }
    put32(f.obj.b, O_PAGE, 0);
    put32(f.obj.b, O_REDRAW, 1);
    f.calls = 0;
    f.fail_at = 1;
    CHECK_INT(mp_render_plan(&f.obj, f.body, MP_BODY_BYTES, &f.host, &plan), MP_ERR_HOST);
    /* arguments */
    CHECK_INT(mp_render_plan(NULL, f.body, MP_BODY_BYTES, &f.host, &plan), MP_ERR_ARGUMENT);
    CHECK_INT(mp_render_plan(&f.obj, f.body, MP_BODY_BYTES, &f.host, NULL), MP_ERR_ARGUMENT);
    CHECK_INT(mp_render_plan(&f.obj, NULL, MP_BODY_BYTES, &f.host, &plan), MP_ERR_ARGUMENT);
    CHECK_INT(mp_render_plan(&f.obj, f.body, MP_BODY_BYTES - 1u, &f.host, &plan), MP_ERR_ARGUMENT);
    CHECK_INT(mp_render_plan(&f.obj, f.body, MP_BODY_BYTES, NULL, &plan), MP_ERR_ARGUMENT);
}

static void t_cleanup_invalidate(void)
{
    Fx f;
    fx_init(&f);
    /* clearing a power-on object does nothing observable */
    CHECK_INT(mp_cleanup(&f.obj, &f.host), MP_OK);
    CHECK_LOG(&f, "");
    CHECK_INT(mp_object_row(&f.obj), -1);
    CHECK_INT(mp_invalidate(&f.obj, &f.host), MP_OK);
    CHECK_LOG(&f, "");
    start(&f);
    f.log[0] = 0;
    CHECK_INT(mp_invalidate(&f.obj, &f.host), MP_OK);
    CHECK_LOG(&f, "dirty=24;");
    put32(f.obj.b, O_ACTIVE, 0);
    f.log[0] = 0;
    CHECK_INT(mp_invalidate(&f.obj, &f.host), MP_OK);
    CHECK_LOG(&f, "");
    put32(f.obj.b, O_ACTIVE, 1);
    put32(f.obj.b, 0x04, 0xffff); /* slot -1 */
    f.log[0] = 0;
    CHECK_INT(mp_invalidate(&f.obj, &f.host), MP_OK);
    CHECK_LOG(&f, "");
    /* cleanup: surface, slot, then the field reset; it keeps the flip state and the deadline */
    start(&f);
    CHECK_INT(flip(&f, 0), MP_OK);
    CHECK_INT(flip(&f, 1), MP_OK);
    put32(f.obj.b, O_TRIES, 7);
    put32(f.obj.b, O_WON, 1);
    put32(f.obj.b, O_LOST, 1);
    put32(f.obj.b, O_REDRAW, 1);
    put32(f.obj.b, 0x2a8, 5);
    put32(f.obj.b, O_PAGE, 1);
    f.log[0] = 0;
    CHECK_INT(mp_cleanup(&f.obj, &f.host), MP_OK);
    CHECK(ob(&f, O_WON) == 0 && ob(&f, O_LOST) == 0 && ob(&f, O_REDRAW) == 0 && ob(&f, 0x2a8) == 0 && ob(&f, O_PAGE) == 0);
    CHECK_LOG(&f, "rsurf=28673;rslot=24;");
    CHECK_INT(ob(&f, O_FLIPBACK), 0);
    CHECK_INT(ob(&f, O_FIRST), 0);
    CHECK_INT(ob(&f, O_SECOND), 0);
    CHECK_INT(ob(&f, O_DEADLINE), 20500 - 20500 + 10500);
    CHECK_INT(ob(&f, O_TRIES), 7);
    CHECK_INT(ob(&f, O_PAIRS), 0);
    CHECK_INT(ob(&f, O_REDRAW), 0);
    CHECK_INT(ob(&f, O_STATE), 0);
    CHECK_INT(ob(&f, O_PAGE), 0);
    CHECK_INT(ob(&f, O_SLOTS), 0);
    CHECK_INT(ob(&f, O_HALFPAGE), 0);
    CHECK_INT(ob(&f, O_HALFTOTAL), 2);
    CHECK_INT(mp_object_active(&f.obj), 0);
    /* the cell bytes are kept (the oracle compares them only while the pointers are set) */
    CHECK_INT(cell_id(&f, 0), 0);
    /* a second cleanup does nothing */
    f.log[0] = 0;
    CHECK_INT(mp_cleanup(&f.obj, &f.host), MP_OK);
    CHECK_LOG(&f, "");
}

/* A random event walk over valid bodies: no refusal other than the documented ones, and the invariants of the cells hold. */
static uint32_t g_seed = 12345u;
static uint32_t rnd32(void)
{
    g_seed = g_seed * 1664525u + 1013904223u;
    return g_seed >> 8;
}

static void t_random_walk(void)
{
    for (int round = 0; round < 40; ++round) {
        Fx f;
        MpPointerResult p;
        int pages = 1 + (int)(rnd32() % 3u), cols = 1 + (int)(rnd32() % 6u), rows = 1 + (int)(rnd32() % 4u);
        int cells;
        fx_init(&f);
        if ((pages * cols * rows) % 2 != 0) cols = cols % 6 + 1;
        if (pages > 1 && ((cols * rows) % 2 != 0)) f.body[B_SHUFFLE] = 1;
        put32(f.body, B_PAGES, pages);
        put32(f.body, B_COLS, cols);
        put32(f.body, B_ROWS, rows);
        put32(f.body, B_SCOLS, 1 + (int)(rnd32() % 6u));
        put32(f.body, B_SROWS, 1 + (int)(rnd32() % 2u));
        put32(f.body, B_PCTIDS, (int)(rnd32() % 150u));
        put32(f.body, B_TRIES, (int)(rnd32() % 30u));
        put32(f.body, B_DELAY, (int)(rnd32() % 100u));
        f.body[B_TABS] = (uint8_t)(rnd32() & 1u);
        if (mp_validate_body(f.body, MP_BODY_BYTES, NULL) != MP_OK) continue;
        f.cycle = 1 + (int)(rnd32() % 50u);
        CHECK_INT(visit(&f, 0), MP_OK);
        cells = ob(&f, O_TOTAL);
        for (int step = 0; step < 300 && !g_failed; ++step) {
            const uint32_t kind = rnd32() % 4u;
            f.now += rnd32() % 80u;
            if (kind == 0u) {
                const int j = (int)(rnd32() % 24u);
                (void)mp_pointer(&f.obj, f.body, MP_BODY_BYTES, (int16_t)tile_x(j), (int16_t)tile_y(j), &p);
                if (p.hit) CHECK_INT(click(&f, p.candidate, 1u), MP_OK);
            } else if (kind == 1u && f.body[B_TABS]) {
                const int k = (int)(rnd32() % 3u);
                CHECK_INT(mp_pointer(&f.obj, f.body, MP_BODY_BYTES, (int16_t)(405 + 20 * k + 100 * ob(&f, O_PAGE)), 20, &p), MP_OK);
                if (p.hit && ob(&f, O_HIT) < pages) CHECK_INT(click(&f, p.candidate, 1u), MP_OK);
            } else {
                const int rc = visit(&f, 1);
                CHECK(rc == MP_OK);
                if (f.res.phase_after == 2u) break;
            }
            {
                int matched = 0, up = 0;
                for (int i = 0; i < cells; ++i) {
                    CHECK(cell_id(&f, i) >= 0 && cell_id(&f, i) < 12);
                    matched += cell_done(&f, i) != 0;
                    up += cell_up(&f, i) != 0 && cell_done(&f, i) == 0;
                }
                CHECK_INT(matched, 2 * ob(&f, O_PAIRS));
                CHECK(up <= 2);
                CHECK(up == (ob(&f, O_FIRST) != 0) + (ob(&f, O_SECOND) != 0));
            }
        }
    }
}

/* ---- the session binding -------------------------------------------------------------------------------------------------------- */

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
    uint8_t tsum[126], act[48 + 2 + MP_BODY_BYTES];
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
    Fx f;
    SessionAeeHost host;
    SessionAeeBinding *b;
    SceneResource *scene;
    uint8_t bytes[16384];
    size_t bytes_len;
    uint8_t body_a[MP_BODY_BYTES], body_b[MP_BODY_BYTES];
} Bind;

static int bind_open(Bind *x)
{
    const int types[3] = {0x70, 0xee, 0xee};
    const uint8_t one = 0;
    const uint8_t *bodies[3];
    size_t lengths[3] = {1, MP_BODY_BYTES, MP_BODY_BYTES};
    char err[128] = {0};
    fx_init(&x->f);
    x->f.cycle = 1;
    memcpy(x->body_a, x->f.body, MP_BODY_BYTES);
    memcpy(x->body_b, x->f.body, MP_BODY_BYTES);
    /* row 2: another overlay name, a 1 x 2 grid and one try */
    set_str(x->body_b, B_NAME, "OTHER");
    put32(x->body_b, B_COLS, 2);
    put32(x->body_b, B_ROWS, 1);
    put32(x->body_b, B_TRIES, 1);
    bodies[0] = &one;
    bodies[1] = x->body_a;
    bodies[2] = x->body_b;
    x->bytes_len = build_scene(x->bytes, 3, types, bodies, lengths);
    x->scene = scene_resource_open_memory(x->bytes, x->bytes_len, err, sizeof err);
    if (x->scene == NULL) return 0;
    memset(&x->host, 0, sizeof x->host);
    x->host.kernel = x->f.host;
    x->host.kernel.context = &x->f;
    x->b = session_aee_create(&x->host);
    return x->b != NULL;
}

static void bind_close(Bind *x)
{
    session_aee_destroy(x->b);
    scene_resource_close(x->scene);
}

static int b_visit(Bind *x, size_t row, uint32_t phase, uint32_t *phase_after, int *completed)
{
    SceneActionInfo info;
    SceneActionRuntimeState st;
    SceneActionHandlerResult out;
    memset(&st, 0, sizeof st);
    memset(&out, 0xff, sizeof out);
    st.phase = phase;
    x->f.log[0] = 0;
    if (scene_resource_action_at(x->scene, row, &info) != SCENE_RESOURCE_OK) return -1;
    {
        const int rc = session_aee_handler(x->b, row, &info, &st, &out);
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
    SessionAeeHost h;
    Bind x;
    void (*slots[32])(void);
    const size_t n = (sizeof(MpHost) - sizeof(void *)) / sizeof(void *);
    CHECK(session_aee_create(NULL) == NULL);
    fill_host(&h.kernel, NULL);
    CHECK(n >= 20 && n <= 31);
    for (size_t i = 0; i < n; ++i) {
        SessionAeeHost g = h;
        memcpy(slots, (const char *)&g.kernel + sizeof(void *), n * sizeof(void *));
        slots[i] = NULL;
        memcpy((char *)&g.kernel + sizeof(void *), slots, n * sizeof(void *));
        CHECK(session_aee_create(&g) == NULL);
    }
    {
        SessionAeeBinding *b = session_aee_create(&h);
        CHECK(b != NULL);
        CHECK_INT(session_aee_registered(b), 0);
        CHECK(session_aee_object(b) != NULL);
        CHECK(strcmp(session_aee_failure(b), "none") == 0);
        CHECK_INT(mp_object_row(session_aee_object(b)), -1);
        session_aee_destroy(b);
    }
    session_aee_destroy(NULL);
    CHECK(session_aee_object(NULL) == NULL);
    CHECK(strstr(session_aee_failure(NULL), "unbound") != NULL);
    CHECK_INT(session_aee_registered(NULL), 0);
    CHECK_INT(session_aee_cleanup(NULL), MP_ERR_ARGUMENT);
    CHECK_INT(session_aee_invalidate(NULL), MP_ERR_ARGUMENT);
    CHECK_INT(session_aee_click(NULL, 1u, 0x2769), MP_ERR_ARGUMENT);
    CHECK_INT(session_aee_pointer_move(NULL, 0, 0, NULL), MP_ERR_ARGUMENT);
    CHECK_INT(session_aee_render_plan(NULL, NULL), MP_ERR_ARGUMENT);
    CHECK(bind_open(&x));
    if (!g_failed) {
        MpPointerResult p;
        MpRenderPlan plan;
        CHECK_INT(session_aee_pointer_move(x.b, 0, 0, NULL), MP_ERR_ARGUMENT);
        CHECK_INT(session_aee_pointer_move(x.b, 0, 0, &p), MP_OK);
        CHECK_INT(session_aee_render_plan(x.b, NULL), MP_ERR_ARGUMENT);
        CHECK_INT(session_aee_begin_scene(x.b, NULL), MP_ERR_ARGUMENT);
        CHECK_INT(session_aee_begin_scene(NULL, x.scene), MP_ERR_ARGUMENT);
        (void)plan;
    }
    bind_close(&x);
}

static void t_binding_flow(void)
{
    Bind x;
    uint32_t pa = 0;
    int done = 0;
    MpPointerResult p;
    MpRenderPlan plan;
    CHECK(bind_open(&x));
    if (g_failed) return;
    CHECK_INT(session_aee_begin_scene(x.b, x.scene), MP_OK);
    /* before phase 0: no entry, nothing active */
    CHECK_INT(session_aee_pointer_move(x.b, tile_x(0), tile_y(0), &p), MP_OK);
    CHECK(p.hit == 0 && p.candidate == -1);
    CHECK_INT(session_aee_render_plan(x.b, &plan), MP_OK);
    CHECK(plan.valid == 0 && plan.count == 0);
    CHECK_INT(session_aee_click(x.b, 1u, 0x2769), MP_OK);
    CHECK_INT(session_aee_invalidate(x.b), MP_OK);
    /* a row that is not a raw 0xee row, a row that does not exist */
    CHECK_INT(b_visit(&x, 0, 0u, &pa, &done), SCENE_ACTION_HANDLER_ERROR);
    CHECK(strstr(session_aee_failure(x.b), "not-owned") != NULL);
    CHECK_INT(b_visit(&x, 3, 0u, &pa, &done), -1);
    /* phase 0 of row 1 */
    CHECK_INT(b_visit(&x, 1, 0u, &pa, &done), SCENE_ACTION_HANDLER_OK);
    CHECK(pa == 1u && done == 0);
    CHECK(strcmp(session_aee_failure(x.b), "none") == 0);
    CHECK_INT(session_aee_registered(x.b), 1);
    CHECK_INT(mp_object_row(session_aee_object(x.b)), 1);
    CHECK_INT(get32(session_aee_object(x.b)->b, O_BODY), 2); /* the opaque body handle of row 1 */
    CHECK(strstr(x.f.log, "load=OVERLAY/") != NULL);
    /* the body the binding copied is the one of its own row: row 2 has another overlay name */
    CHECK_INT(b_visit(&x, 1, 1u, &pa, &done), SCENE_ACTION_HANDLER_OK);
    CHECK(pa == 1u && done == 0);
    CHECK_INT(b_visit(&x, 2, 1u, &pa, &done), SCENE_ACTION_HANDLER_UNSUPPORTED); /* the object belongs to row 1 */
    CHECK_INT(b_visit(&x, 1, 3u, &pa, &done), SCENE_ACTION_HANDLER_UNSUPPORTED);
    /* pointer, click, render and invalidate go to the row of the object */
    CHECK_INT(session_aee_pointer_move(x.b, tile_x(0), tile_y(0), &p), MP_OK);
    CHECK(p.hit == 1 && p.candidate == 0x2769);
    CHECK(strcmp(session_aee_failure(x.b), "none") == 0);
    CHECK_INT(session_aee_pointer_move(x.b, 0, 0, &p), MP_OK);
    CHECK(p.hit == 0 && p.candidate == -1);
    CHECK_INT(session_aee_pointer_move(x.b, tile_x(0), tile_y(0), &p), MP_OK);
    put32((uint8_t *)session_aee_object(x.b)->b, O_BODY, 0);
    CHECK_INT(session_aee_click(x.b, 1u, 0x2769), MP_OK);
    CHECK_INT(get32(session_aee_object(x.b)->b, O_BODY), 2); /* the click stores the handle of the object's row */
    CHECK_INT(cell_up(&x.f, 0), 0); /* the standalone fixture f.obj is another object */
    CHECK_INT(get32(session_aee_object(x.b)->cells, 4), 1);
    CHECK_INT(session_aee_click(x.b, 0u, 0x2769), MP_OK); /* wrong row phase: nothing */
    CHECK_INT(get32(session_aee_object(x.b)->cells, 12 + 4), 0);
    CHECK_INT(session_aee_render_plan(x.b, &plan), MP_OK);
    CHECK(plan.valid == 1);
    CHECK_INT(plan.count, 5);
    CHECK(strcmp(session_aee_failure(x.b), "none") == 0);
    x.f.log[0] = 0;
    CHECK_INT(session_aee_invalidate(x.b), MP_OK);
    CHECK_LOG(&x.f, "dirty=24;");
    /* the object's row must be a present row of the scene */
    {
        MpObject *o = (MpObject *)session_aee_object(x.b);
        static const int16_t rows[4] = {0, 3, -1, 99}; /* not an 0xee row, the row count, none, far away */
        for (int i = 0; i < 4; ++i) {
            put16(o->b, 0x06, rows[i]);
            CHECK_INT(session_aee_pointer_move(x.b, tile_x(0), tile_y(0), &p), MP_ERR_ARGUMENT);
            CHECK_INT(session_aee_click(x.b, 1u, 0x2769), MP_ERR_ARGUMENT);
            CHECK_INT(session_aee_render_plan(x.b, &plan), MP_ERR_ARGUMENT);
            CHECK(plan.valid == 0 && plan.count == 0);
        }
        put16(o->b, 0x06, 1);
    }
    /* failures of the kernel calls keep their reason */
    {
        MpObject *o = (MpObject *)session_aee_object(x.b);
        put32(o->b, O_PAGE, 7);
        CHECK_INT(session_aee_pointer_move(x.b, tile_x(0), tile_y(0), &p), MP_ERR_BOUNDS);
        CHECK(strstr(session_aee_failure(x.b), "pointer") != NULL);
        CHECK_INT(session_aee_render_plan(x.b, &plan), MP_ERR_BOUNDS);
        CHECK(strstr(session_aee_failure(x.b), "render") != NULL);
        put32(o->b, O_HIT, 9);
        CHECK_INT(session_aee_click(x.b, 1u, 0x2768), MP_ERR_BOUNDS);
        CHECK(strstr(session_aee_failure(x.b), "click") != NULL);
        put32(o->b, O_PAGE, 0);
        CHECK_INT(session_aee_pointer_move(x.b, tile_x(0), tile_y(0), &p), MP_OK);
        CHECK(strcmp(session_aee_failure(x.b), "none") == 0);
        CHECK_INT(session_aee_click(x.b, 0u, 0x2768), MP_OK);
        CHECK(strcmp(session_aee_failure(x.b), "none") == 0);
        CHECK_INT(session_aee_render_plan(x.b, &plan), MP_OK);
        CHECK(strcmp(session_aee_failure(x.b), "none") == 0);
    }
    /* win: set the flags, visit phase 1 twice, phase 2 completes */
    {
        MpObject *o = (MpObject *)session_aee_object(x.b);
        put32(o->b, O_WON, 1);
    }
    CHECK_INT(b_visit(&x, 1, 1u, &pa, &done), SCENE_ACTION_HANDLER_OK);
    CHECK_INT(b_visit(&x, 1, 1u, &pa, &done), SCENE_ACTION_HANDLER_OK);
    CHECK(pa == 2u && done == 0);
    CHECK_INT(b_visit(&x, 1, 2u, &pa, &done), SCENE_ACTION_HANDLER_OK);
    CHECK(done == 1);
    CHECK_LOG(&x.f, "inv=5;trans=100,1,2,3,11,12,13,s1;flag=5,9;done=1;rsurf=28673;rslot=24;");
    CHECK_INT(session_aee_registered(x.b), 0);
    CHECK_INT(mp_object_row(session_aee_object(x.b)), -1);
    CHECK_INT(session_aee_pointer_move(x.b, tile_x(0), tile_y(0), &p), MP_OK);
    CHECK(p.hit == 0);
    CHECK_INT(session_aee_click(x.b, 1u, 0x2769), MP_OK);
    CHECK_INT(session_aee_render_plan(x.b, &plan), MP_OK);
    CHECK(plan.valid == 0);
    /* row 2: its own body (1 x 2 grid, one try) */
    CHECK_INT(b_visit(&x, 2, 0u, &pa, &done), SCENE_ACTION_HANDLER_OK);
    CHECK(strstr(x.f.log, "load=OTHER/") != NULL);
    CHECK_INT(get32(session_aee_object(x.b)->b, O_BODY), 3);
    CHECK_INT(get32(session_aee_object(x.b)->b, O_TOTAL), 2);
    /* the new-game / scene clear releases the entry and the surface */
    x.f.log[0] = 0;
    CHECK_INT(session_aee_cleanup(x.b), MP_OK);
    CHECK_LOG(&x.f, "rsurf=28673;rslot=24;");
    CHECK_INT(session_aee_registered(x.b), 0);
    /* destroy clears a live puzzle too */
    CHECK_INT(b_visit(&x, 1, 0u, &pa, &done), SCENE_ACTION_HANDLER_OK);
    x.f.log[0] = 0;
    session_aee_destroy(x.b);
    CHECK_LOG(&x.f, "rsurf=28673;rslot=24;");
    scene_resource_close(x.scene);
}

static void t_binding_results(void)
{
    Bind x;
    uint32_t pa = 0;
    int done = 0;
    CHECK(bind_open(&x));
    if (g_failed) return;
    CHECK_INT(session_aee_begin_scene(x.b, x.scene), MP_OK);
    /* lose path with a host failure in the finish: an error is reported and the failure text is kept */
    CHECK_INT(b_visit(&x, 2, 0u, &pa, &done), SCENE_ACTION_HANDLER_OK);
    {
        MpObject *o = (MpObject *)session_aee_object(x.b);
        put32(o->b, O_LOST, 1);
    }
    x.f.calls = 0;
    x.f.fail_at = 1;
    CHECK_INT(b_visit(&x, 2, 2u, &pa, &done), SCENE_ACTION_HANDLER_ERROR);
    x.f.fail_at = 0;
    CHECK(strcmp(session_aee_failure(x.b), "none") == 0);
    CHECK_INT(mp_object_active(session_aee_object(x.b)), 0);
    CHECK_INT(session_aee_registered(x.b), 1); /* the entry is still held: the finish stopped before the clear */
    /* a refused body keeps its reason */
    CHECK_INT(session_aee_cleanup(x.b), MP_OK);
    x.f.fail_at = 0;
    bind_close(&x);
}

static void t_binding_bad_scene(void)
{
    Bind x;
    uint8_t bad[MP_BODY_BYTES];
    uint8_t bytes[16384];
    const int types[2] = {0xee, 0xee};
    const uint8_t *bodies[2];
    size_t lengths[2] = {MP_BODY_BYTES, MP_BODY_BYTES};
    SceneResource *scene;
    char err[128] = {0};
    uint32_t pa = 0;
    int done = 0;
    CHECK(bind_open(&x));
    if (g_failed) return;
    CHECK_INT(session_aee_begin_scene(x.b, x.scene), MP_OK);
    CHECK_INT(b_visit(&x, 1, 0u, &pa, &done), SCENE_ACTION_HANDLER_OK);
    memcpy(bad, x.body_a, sizeof bad);
    put32(bad, B_PAGES, 9);
    bodies[0] = x.body_a;
    bodies[1] = bad;
    scene = scene_resource_open_memory(bytes, build_scene(bytes, 2, types, bodies, lengths), err, sizeof err);
    CHECK(scene != NULL);
    if (scene != NULL) {
        /* the invalid body is refused with its reason; the previous scene (rows, live puzzle) stays */
        CHECK_INT(session_aee_begin_scene(x.b, scene), MP_ERR_BODY);
        CHECK(strstr(session_aee_failure(x.b), "pages") != NULL);
        CHECK_INT(session_aee_registered(x.b), 1);
        CHECK_INT(b_visit(&x, 1, 1u, &pa, &done), SCENE_ACTION_HANDLER_OK);
        CHECK_INT(b_visit(&x, 2, 0u, &pa, &done), SCENE_ACTION_HANDLER_OK); /* row 2 of the old scene is still there */
        scene_resource_close(scene);
    }
    /* a valid scene clears the live puzzle of the previous one (rslot) and replaces the rows */
    bodies[1] = x.body_b;
    scene = scene_resource_open_memory(bytes, build_scene(bytes, 1, types, bodies, lengths), err, sizeof err);
    CHECK(scene != NULL);
    if (scene != NULL) {
        x.f.log[0] = 0;
        CHECK_INT(session_aee_begin_scene(x.b, scene), MP_OK);
        CHECK(strstr(x.f.log, "rslot=24;") != NULL);
        CHECK_INT(session_aee_registered(x.b), 0);
        CHECK_INT(b_visit(&x, 2, 0u, &pa, &done), SCENE_ACTION_HANDLER_ERROR); /* the new scene has one row */
        {
            SceneActionInfo info;
            SceneActionRuntimeState st;
            SceneActionHandlerResult out;
            memset(&st, 0, sizeof st);
            CHECK(scene_resource_action_at(x.scene, 2, &info) == SCENE_RESOURCE_OK);
            CHECK_INT(session_aee_handler(x.b, 2, &info, &st, &out), SCENE_ACTION_HANDLER_ERROR); /* no such row in the new scene */
            CHECK(scene_resource_action_at(scene, 0, &info) == SCENE_RESOURCE_OK);
            CHECK_INT(session_aee_handler(x.b, 0, &info, &st, &out), SCENE_ACTION_HANDLER_OK); /* a puzzle row at index 0 works */
            CHECK_INT(session_aee_handler(x.b, 0, &info, &st, NULL), SCENE_ACTION_HANDLER_ERROR);
            CHECK_INT(session_aee_handler(x.b, 0, NULL, &st, &out), SCENE_ACTION_HANDLER_ERROR);
            CHECK_INT(session_aee_handler(x.b, 0, &info, NULL, &out), SCENE_ACTION_HANDLER_ERROR);
            CHECK_INT(session_aee_handler(NULL, 0, &info, &st, &out), SCENE_ACTION_HANDLER_ERROR);
            /* the row index decides ownership, not the type of the info handed in: past the rows, and a row without a body */
            CHECK_INT(session_aee_handler(x.b, 1, &info, &st, &out), SCENE_ACTION_HANDLER_ERROR);
            CHECK(strstr(session_aee_failure(x.b), "not-owned") != NULL);
            {
                MpPointerResult p;
                MpRenderPlan plan;
                CHECK_INT(session_aee_pointer_move(x.b, tile_x(0), tile_y(0), &p), MP_OK); /* the puzzle row at index 0 is live */
                CHECK(p.hit == 1);
                CHECK_INT(session_aee_render_plan(x.b, &plan), MP_OK);
                CHECK(plan.valid == 1);
            }
        }
        scene_resource_close(scene);
    }
    /* an empty scene is a valid scene with no rows */
    {
        const int none[1] = {0};
        const uint8_t *nb[1] = {NULL};
        const size_t nl[1] = {0};
        scene = scene_resource_open_memory(bytes, build_scene(bytes, 0, none, nb, nl), err, sizeof err);
        CHECK(scene != NULL);
        if (scene != NULL) {
            CHECK_INT(session_aee_begin_scene(x.b, scene), MP_OK);
            CHECK_INT(b_visit(&x, 1, 0u, &pa, &done), SCENE_ACTION_HANDLER_ERROR);
            scene_resource_close(scene);
        }
    }
    /* a host failure in the previous scene's clear keeps the previous rows */
    CHECK_INT(session_aee_begin_scene(x.b, x.scene), MP_OK);
    CHECK_INT(b_visit(&x, 1, 0u, &pa, &done), SCENE_ACTION_HANDLER_OK);
    x.f.calls = 0;
    x.f.fail_at = 1;
    CHECK_INT(session_aee_begin_scene(x.b, x.scene), MP_ERR_HOST);
    CHECK(strstr(session_aee_failure(x.b), "clear") != NULL);
    x.f.fail_at = 0;
    CHECK_INT(b_visit(&x, 1, 1u, &pa, &done), SCENE_ACTION_HANDLER_OK);
    bind_close(&x);
}

typedef struct Test {
    const char *name;
    void (*fn)(void);
} Test;

static const Test tests[] = {
    {"validate body", t_validate},
    {"object reset", t_reset},
    {"phase 0", t_phase0},
    {"phase 0 options", t_phase0_options},
    {"deal", t_deal},
    {"pointer", t_pointer},
    {"page tabs", t_tabs},
    {"click guards", t_click_guards},
    {"click pair", t_click_pair},
    {"click mismatch and flip-back", t_click_mismatch},
    {"win lose conditions", t_end_conditions},
    {"tab and tile click bounds", t_tab_click},
    {"sounds and captions", t_sounds_and_captions},
    {"sound picks", t_pick_sounds},
    {"win states", t_states_win},
    {"lose states", t_states_lose},
    {"phase 2 blocks", t_phase2},
    {"step refusals", t_step_refusals},
    {"host failures", t_host_failures},
    {"render plan", t_render},
    {"cleanup and invalidate", t_cleanup_invalidate},
    {"random walk", t_random_walk},
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
