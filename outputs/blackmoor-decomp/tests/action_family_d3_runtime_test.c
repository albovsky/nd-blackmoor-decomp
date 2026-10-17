/* RT-53 unit tests of the raw 0xd3 Collision Puzzle kernel (src/action_family_d3_runtime.c) and its session binding
 * (src/session_bindings_ad3.c). Prints "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count.
 * Fixtures are synthetic bodies (no original bytes). tests/test_action_family_d3_runtime.py builds and runs this with and
 * without ASan/UBSan and under source mutations. Expected values are written out from the body layout in
 * src/action_family_d3_runtime.h, not copied from the kernel. */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_d3_runtime.h"
#include "scene_resource.h"
#include "session_bindings_ad3.h"

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
            snprintf(g_msg, sizeof g_msg, "line %d: log \"%.120s\" != \"%.120s\"", __LINE__, \
                     (fx)->log, (expected));                                                 \
        }                                                                                    \
    } while (0)

/* Body offsets (the header describes the layout). */
enum {
    O_PERSIST = 0x21, O_ROWS = 0x22, O_COLS = 0x24, O_PIECES = 0x26, O_TYPES = 0x28, O_START = 0xa8, O_PSRC = 0xd0,
    O_TSRC = 0x170, O_AH = 0x210, O_AV = 0x220, O_WALL = 0x230, O_OX = 0x240, O_OY = 0x244, O_GAP = 0x248, O_STEPS = 0x24a,
    O_SA = 0x24f, O_CA = 0x270, O_SB = 0x280, O_CB = 0x2a1, O_SC = 0x2b1, O_CC = 0x2d2, O_SOLV = 0x2e2, O_DELAY = 0x2fb,
    O_SD = 0x2fd, O_CD = 0x31e, O_CANC = 0x32e, O_CRECT = 0x347
};

/* Failable host callbacks (the sweep fails the n-th call of any of them). */
enum {
    CB_ALLOC = 1, CB_REGISTER, CB_LOAD, CB_SETSURF, CB_RELSURF, CB_RELSLOT, CB_DIRTY, CB_ORIGIN, CB_CLEARITEM, CB_PREPARE,
    CB_STOP, CB_PLAY, CB_BUSY, CB_TRANSITION, CB_STOREFLAG, CB_LAST = CB_STOREFLAG
};

typedef struct Fx {
    CpzObject o;
    CpzWorld world;
    CpzHost host;
    uint8_t body[CPZ_BODY_BYTES];
    char log[32768];
    uint32_t now;
    int32_t busy_value;
    int32_t vx, vy;
    int fail_call, calls, failed_cb, n_alloc, n_clear, n_origin, n_dirty, n_relsurf, n_relslot, n_prepare, n_stop, n_play;
    unsigned failed_mask;
    int16_t dirty_slot, setsurf_slot, played_channel, flag_limit;
    uint32_t setsurf_surface, relsurf_handle;
    const uint8_t *prepare_ptr, *stop_ptr;
    int prep_hist[16], n_prep_hist, stop_hist[16], n_stop_hist; /* record offsets in the body, -1 when outside it */
    int16_t reg_slot, relslot_seen;
    char registered_label[40], loaded_name[40];
    uint32_t phase;
    int completed, initialized;
    const char *failure;
} Fx;

static void put16(uint8_t *b, size_t off, int v) { b[off] = (uint8_t)v; b[off + 1] = (uint8_t)(v >> 8); }
static int16_t rd16(const uint8_t *b, size_t off) { return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8)); }
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
static void set_str(uint8_t *b, size_t off, const char *s) { memcpy(b + off, s, strlen(s) + 1u); }
static void set_nosound(uint8_t *b, size_t off) { memcpy(b + off, "NO SOUND", 9u); }

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

static const char *const effect_names[] = {"?", "active", "start", "gridreset", "clearitem", "gridsetup", "slot", "slotreg",
                                           "load", "slotsurf", "phase", "state", "prep", "stop", "play", "busy", "tick",
                                           "x57b", "x599", "x595", "x39ff", "x59b", "x59f", "x5a3", "mode", "evflag",
                                           "complete", "relsurf", "relslot", "blit"};

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
    if (fail_hit(f, CB_REGISTER)) return 1;
    f->reg_slot = slot;
    snprintf(f->registered_label, sizeof f->registered_label, "%s", label);
    return 0;
}
static int h_load(void *c, const char *name, uint32_t *surface)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_LOAD)) return 1;
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
    if (fail_hit(f, CB_RELSURF)) return 1;
    ++f->n_relsurf;
    f->relsurf_handle = s;
    return 0;
}
static int h_relslot(void *c, int16_t slot)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_RELSLOT)) return 1;
    ++f->n_relslot;
    f->relslot_seen = slot;
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
static int h_clear(void *c)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_CLEARITEM)) return 1;
    ++f->n_clear;
    return 0;
}
static int h_prepare(void *c, const uint8_t *r)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_PREPARE)) return 1;
    ++f->n_prepare;
    f->prepare_ptr = r;
    if (f->n_prep_hist < 16) f->prep_hist[f->n_prep_hist++] = (r >= f->body && r < f->body + CPZ_BODY_BYTES) ? (int)(r - f->body) : -1;
    return 0;
}
static int h_stop(void *c, const uint8_t *r)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_STOP)) return 1;
    ++f->n_stop;
    f->stop_ptr = r;
    if (f->n_stop_hist < 16) f->stop_hist[f->n_stop_hist++] = (r >= f->body && r < f->body + CPZ_BODY_BYTES) ? (int)(r - f->body) : -1;
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
    if (fail_hit(f, CB_BUSY)) return 1;
    *r = f->busy_value;
    logf_(f, "busyq:%d", ch);
    return 0;
}
static uint32_t h_tick(void *c) { return ((Fx *)c)->now; }
static int h_flag_invalid(void *c, int16_t i) { return i < 0 || i >= ((Fx *)c)->flag_limit; }
static int h_transition(void *c, const CpzTransition *t)
{
    Fx *f = (Fx *)c;
    if (fail_hit(f, CB_TRANSITION)) return 1;
    logf_(f, "tr:%d:%d:%d:%d:%d:%d:%d", t->scene, t->word[0], t->word[1], t->word[2], t->dword[0], t->dword[1], t->dword[2]);
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

static void set_type(uint8_t *b, int a, int c, int t) { put16(b, (size_t)(O_TYPES + 16 * a + 2 * c), t); }
static void set_piece(uint8_t *b, int k, int a, int c)
{
    put16(b, (size_t)(O_START + 4 * k), c);
    put16(b, (size_t)(O_START + 4 * k + 2), a);
}

/* The default body: puzzle surface "PUZ", a 3 x 4 grid, 2 pieces (piece 1 at row 1 column 0, piece 2 at row 0 column 1), the
 * target of piece 1 at (1, 3) and of piece 2 at (2, 1) (its overlay source is empty: left == right). Cells are 30 x 21 (odd
 * height, so the per-step division truncates), origin (100, 50), gap 4, 4 animation steps. The view origin of the fixture host
 * is (7, 11). Sounds A..D "SNDA".."SNDD" on channels 11..14, delay 2 s; solved block: scene 40, words 1 2 3, dwords 11 22 33,
 * start word 1, event flag 7 := 3; cancel block: scene 50, words 4 5 6, dwords 44 55 66, start word 0, flag 8 := 9; cancel
 * rectangle (10, 20, 59, 39). The persist byte is 0. */
static void body_init(uint8_t *b)
{
    memset(b, 0, CPZ_BODY_BYTES);
    set_str(b, 0, "PUZ");
    put16(b, O_ROWS, 3);
    put16(b, O_COLS, 4);
    put16(b, O_PIECES, 2);
    set_type(b, 1, 3, 1);
    set_type(b, 2, 1, 2);
    set_piece(b, 0, 1, 0);
    set_piece(b, 1, 0, 1);
    for (int k = 0; k < 10; ++k) put_rect(b, (size_t)(O_PSRC + 16 * k), 1000 + 50 * k, 3 + 10 * k, 1030 + 50 * k, 24 + 10 * k);
    for (int t = 0; t < 10; ++t) put_rect(b, (size_t)(O_TSRC + 16 * t), 2000 + 50 * t, 5, 2030 + 50 * t, 26);
    put_rect(b, O_TSRC + 16, 2050, 5, 2050, 26); /* the overlay of type 2 is empty */
    put_rect(b, O_AH, 3000, 10, 3016, 19);       /* 16 x 9 */
    put_rect(b, O_AV, 3100, 10, 3109, 26);       /* 9 x 16 */
    put_rect(b, O_WALL, 3200, 0, 3230, 21);
    put32(b, O_OX, 100);
    put32(b, O_OY, 50);
    put16(b, O_GAP, 4);
    put16(b, O_STEPS, 4);
    set_str(b, O_SA, "SNDA");
    put16(b, O_CA, 11);
    set_str(b, O_SB, "SNDB");
    put16(b, O_CB, 12);
    set_str(b, O_SC, "SNDC");
    put16(b, O_CC, 13);
    set_block(b, O_SOLV, 40, 1, 2, 3, 11, 22, 33, 1, 7, 3);
    put16(b, O_DELAY, 2);
    set_str(b, O_SD, "SNDD");
    put16(b, O_CD, 14);
    set_block(b, O_CANC, 50, 4, 5, 6, 44, 55, 66, 0, 8, 9);
    put_rect(b, O_CRECT, 10, 20, 59, 39);
}

static void fx_init(Fx *f)
{
    memset(f, 0, sizeof(*f));
    cpz_object_reset(&f->o);
    f->host.context = f;
    f->host.alloc_slot = h_alloc;
    f->host.register_slot = h_register;
    f->host.load_surface = h_load;
    f->host.set_slot_surface = h_setsurf;
    f->host.release_surface = h_relsurf;
    f->host.release_slot = h_relslot;
    f->host.mark_dirty = h_dirty;
    f->host.view_origin = h_origin;
    f->host.clear_pending_item = h_clear;
    f->host.sound_prepare = h_prepare;
    f->host.sound_stop = h_stop;
    f->host.sound_play = h_play;
    f->host.sound_busy = h_busy;
    f->host.tick = h_tick;
    f->host.event_flag_invalid = h_flag_invalid;
    f->host.transition = h_transition;
    f->host.store_event_flag = h_store_flag;
    f->host.observe = observe;
    f->now = 1000u;
    f->vx = 7;
    f->vy = 11;
    f->flag_limit = 100;
    body_init(f->body);
}

static int visit(Fx *f, int16_t row, uint32_t phase)
{
    CpzResult r;
    const char *why = "stale"; /* the kernel must clear it */
    int rc;
    memset(&r, 0x5a, sizeof r);
    rc = cpz_step(&f->o, f->body, CPZ_BODY_BYTES, row, phase, &f->world, &f->host, &r, &why);
    f->phase = r.phase_after;
    f->completed = r.completed;
    f->initialized = r.initialized;
    f->failure = why;
    return rc;
}
static int click(Fx *f, uint32_t row_phase, int32_t candidate, int32_t start_flag, CpzClickResult *c)
{
    return cpz_click(&f->o, f->body, CPZ_BODY_BYTES, row_phase, candidate, start_flag, &f->host, c);
}
static int render(Fx *f, CpzRenderResult *r) { return cpz_render(&f->o, &f->world, f->body, CPZ_BODY_BYTES, &f->host, r); }
/* The pointer at the absolute point (px, py): the view-relative arguments are px - view, py - view. */
static int ptr(Fx *f, int32_t px, int32_t py, CpzPointerResult *p)
{
    return cpz_pointer(&f->o, &f->world, f->body, CPZ_BODY_BYTES, px - f->vx, py - f->vy, f->vx, f->vy, p);
}

#define LOGCLR(f) ((f)->log[0] = '\0')
#define ROW 3

static void start(Fx *f)
{
    CHECK(visit(f, ROW, 0u) == CPZ_OK && f->phase == 1u && f->initialized == 1);
    LOGCLR(f);
}

/* Geometry written out from the header: the cell (a, b) rectangle including the view origin. */
static int32_t cw_of(const Fx *f) { return rd32(f->body, O_PSRC + 8) - rd32(f->body, O_PSRC); }
static int32_t ch_of(const Fx *f) { return rd32(f->body, O_PSRC + 12) - rd32(f->body, O_PSRC + 4); }
static void crect(const Fx *f, int a, int b, int32_t r[4])
{
    const int32_t gap = rd16(f->body, O_GAP);
    r[0] = gap * b + f->vx + rd32(f->body, O_OX) + b * cw_of(f);
    r[2] = r[0] + cw_of(f);
    r[1] = gap * a + f->vy + rd32(f->body, O_OY) + a * ch_of(f);
    r[3] = r[1] + ch_of(f);
}
/* The overlay rectangle of the cell: the cell rectangle, moved for the edge arrows (0x10 / 0x13 beside the cell, 0x11 / 0x12
 * above or below it, centered on the other axis; the offsets use C division, truncating toward zero). */
static void brect(const Fx *f, int a, int b, int type, int32_t r[4])
{
    const int32_t gh = rd16(f->body, O_GAP) / 2;
    crect(f, a, b, r);
    if (type == 0x10 || type == 0x13) {
        const int32_t w = rd32(f->body, O_AH + 8) - rd32(f->body, O_AH), h = rd32(f->body, O_AH + 12) - rd32(f->body, O_AH + 4);
        const int32_t off = (ch_of(f) - h) / 2;
        r[1] += off;
        r[3] -= off;
        r[0] = type == 0x10 ? r[0] - gh - w / 2 : r[2] + gh - w / 2;
        r[2] = r[0] + w;
    } else if (type == 0x11 || type == 0x12) {
        const int32_t w = rd32(f->body, O_AV + 8) - rd32(f->body, O_AV), h = rd32(f->body, O_AV + 12) - rd32(f->body, O_AV + 4);
        const int32_t off = (cw_of(f) - w) / 2;
        r[0] += off;
        r[2] -= off;
        r[1] = type == 0x11 ? r[1] - gh - h / 2 : r[3] + gh - h / 2;
        r[3] = r[1] + h;
    }
}

static int rect_eq(const int32_t *x, const int32_t *y) { return x[0] == y[0] && x[1] == y[1] && x[2] == y[2] && x[3] == y[3]; }

/* After phase 0 the persistent grid holds, for every cell of the body's R x C, the type, the visible flag, the piece number and
 * the two rectangles the header describes. */
static int cells_match(const Fx *f)
{
    const int rows = rd16(f->body, O_ROWS), cols = rd16(f->body, O_COLS), pieces = rd16(f->body, O_PIECES);
    for (int a = 0; a < rows; ++a) {
        for (int b = 0; b < cols; ++b) {
            const CpzCell *c = &f->world.cell[a][b];
            int32_t cell[4], base[4];
            int piece = 0;
            const int type = rd16(f->body, (size_t)(O_TYPES + 16 * a + 2 * b));
            for (int k = 0; k < pieces; ++k)
                if (rd16(f->body, (size_t)(O_START + 4 * k)) == b && rd16(f->body, (size_t)(O_START + 4 * k + 2)) == a) piece = k + 1;
            crect(f, a, b, cell);
            brect(f, a, b, type, base);
            if (c->type != type || c->piece != piece || c->visible != (type != 0 || piece != 0) || !rect_eq(c->rect, cell) ||
                !rect_eq(c->base, base))
                return 0;
        }
    }
    return 1;
}

/* ---- body validation ---------------------------------------------------------------------------------------------------- */

static void t_validate(void)
{
    uint8_t b[CPZ_BODY_BYTES + 8];
    const char *why = NULL;
    const struct { size_t off; const char *text; } sounds[4] = {
        {O_SA, "0xd3-sound-unterminated"}, {O_SB, "0xd3-sound-unterminated"}, {O_SC, "0xd3-sound-unterminated"},
        {O_SD, "0xd3-sound-unterminated"}};
    body_init(b);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_OK && why == NULL);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, NULL) == CPZ_OK);
    CHECK(cpz_validate_body(NULL, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-body-length") == 0);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES - 1u, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-body-length") == 0);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES + 1u, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-body-length") == 0);
    CHECK(cpz_validate_body(b, 0u, NULL) == CPZ_ERR_BODY);
    /* the name: 0x21 bytes, the terminator may be the last one; the byte after it does not count */
    memset(b, 'A', CPZ_NAME_BYTES);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-name-unterminated") == 0);
    b[CPZ_NAME_BYTES - 1u] = 0;
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_OK && why == NULL);
    body_init(b);
    memset(b, 'A', CPZ_NAME_BYTES);
    b[CPZ_NAME_BYTES] = 0; /* the NUL one byte after the name does not count */
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-name-unterminated") == 0);
    /* each sound record (0x21 bytes) */
    for (int i = 0; i < 4; ++i) {
        body_init(b);
        memset(b + sounds[i].off, 'S', CPZ_SOUND_BYTES);
        b[sounds[i].off + CPZ_SOUND_BYTES] = 0;
        CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY && strcmp(why, sounds[i].text) == 0);
        b[sounds[i].off + CPZ_SOUND_BYTES - 1u] = 0;
        CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_OK && why == NULL);
    }
    /* grid size 0..8 and piece count 0..10 */
    body_init(b);
    put16(b, O_ROWS, 8);
    put16(b, O_COLS, 8);
    put16(b, O_PIECES, 10);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_OK);
    put16(b, O_ROWS, 0);
    put16(b, O_COLS, 0);
    put16(b, O_PIECES, 0);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_OK);
    put16(b, O_ROWS, 9);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-grid-size") == 0);
    put16(b, O_ROWS, -1);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-grid-size") == 0);
    put16(b, O_ROWS, 3);
    put16(b, O_COLS, 9);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-grid-size") == 0);
    put16(b, O_COLS, -1);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-grid-size") == 0);
    put16(b, O_COLS, 0x7fff);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY);
    put16(b, O_COLS, 4);
    put16(b, O_PIECES, 11);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-piece-count") == 0);
    put16(b, O_PIECES, -1);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-piece-count") == 0);
    put16(b, O_PIECES, 2);
    /* animation steps >= 1 (the original divides by it) */
    put16(b, O_STEPS, 1);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_OK);
    put16(b, O_STEPS, 0x7fff);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_OK);
    put16(b, O_STEPS, 0);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-animation-steps") == 0);
    put16(b, O_STEPS, -1);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-animation-steps") == 0);
    /* the order of the checks: name, grid size, piece count, steps, sounds */
    body_init(b);
    memset(b, 'A', CPZ_NAME_BYTES);
    put16(b, O_ROWS, 9);
    put16(b, O_PIECES, 11);
    put16(b, O_STEPS, 0);
    memset(b + O_SA, 'S', CPZ_SOUND_BYTES);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-name-unterminated") == 0);
    b[0] = 0;
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-grid-size") == 0);
    put16(b, O_ROWS, 3);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-piece-count") == 0);
    put16(b, O_PIECES, 2);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-animation-steps") == 0);
    put16(b, O_STEPS, 4);
    CHECK(cpz_validate_body(b, CPZ_BODY_BYTES, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-sound-unterminated") == 0);
}

static void t_reset(void)
{
    CpzObject o;
    CpzWorld w;
    memset(&o, 0xa5, sizeof o);
    cpz_object_reset(&o);
    CHECK(o.slot == -1 && o.row == -1 && o.surface == 0u && o.state == 0 && o.flag28 == 0 && o.piece == 0 && o.moved == 0 &&
          o.active == 0 && o.canceled == 0 && o.solved == 0 && o.deadline == 0u && o.cell_w == 0 && o.cell_h == 0 &&
          o.dir == 0 && o.step == 0 && o.at_row == 0 && o.at_col == 0 && o.saved[0] == 0 && o.saved[1] == 0 &&
          o.saved[2] == 0 && o.saved[3] == 0);
    memset(&w, 0xa5, sizeof w);
    w.start_flag_5bb1ca = 77;
    cpz_grid_reset(&w);
    CHECK(w.grid_ready == 0 && w.start_flag_5bb1ca == 77);
    {
        const uint8_t *p = (const uint8_t *)w.cell;
        int zero = 1;
        for (size_t i = 0; i < sizeof w.cell; ++i)
            if (p[i] != 0) zero = 0;
        CHECK(zero);
    }
}

/* ---- phase 0 -------------------------------------------------------------------------------------------------------------- */

static void t_phase0(void)
{
    Fx f;
    fx_init(&f);
    f.world.start_flag_5bb1ca = 0;
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && f.failure == NULL);
    CHECK_LOG(&f, "active:1:0,start:1:0,gridreset:0:0,clearitem:0:0,gridsetup:1:0,slot:24:0,slotreg:24:0,load:77:0,"
                  "slotsurf:24:77,prep:591:0,prep:640:0,prep:689:0,phase:1:0");
    CHECK(f.phase == 1u && f.initialized == 1 && f.completed == 0);
    CHECK(f.o.row == ROW && f.o.active == 1 && f.o.flag28 == 1 && f.o.slot == 24 && f.o.surface == 77u);
    CHECK(f.o.cell_w == 30 && f.o.cell_h == 21);
    CHECK(f.o.state == CPZ_STATE_IDLE && f.o.solved == 0 && f.o.canceled == 0 && f.o.piece == 0 && f.o.dir == 0 &&
          f.o.step == 0 && f.o.moved == 0 && f.o.saved[0] == 0 && f.o.saved[1] == 0 && f.o.saved[2] == 0 && f.o.saved[3] == 0);
    CHECK(f.world.start_flag_5bb1ca == 1 && f.world.grid_ready == 1);
    CHECK(strcmp(f.registered_label, "COLLISION PUZZLE OVERLAYS") == 0 && strcmp(f.loaded_name, "PUZ") == 0);
    CHECK(f.setsurf_slot == 24 && f.setsurf_surface == 77u && f.n_clear == 1 && f.n_origin == 1);
    CHECK(f.n_prepare == 3 && f.prepare_ptr == f.body + O_SC);
    CHECK(f.n_prep_hist == 3 && f.prep_hist[0] == O_SA && f.prep_hist[1] == O_SB && f.prep_hist[2] == O_SC && f.reg_slot == 24);
    CHECK(cells_match(&f));
    /* the three sound records are prepared in the order A, B, C by pointer */
    {
        Fx g;
        fx_init(&g);
        CHECK(visit(&g, ROW, 0u) == CPZ_OK);
        CHECK(g.prepare_ptr == g.body + O_SC && g.n_stop == 0 && g.n_play == 0);
    }
    /* any other row number is stored; the sound D is not prepared in phase 0 */
    fx_init(&f);
    CHECK(visit(&f, 0, 0u) == CPZ_OK && f.o.row == 0);
    CHECK(strstr(f.log, "prep:") != NULL && strstr(f.log, "prep:" "765") == NULL);
    /* NO SOUND records are not prepared: each of A, B and C on its own */
    fx_init(&f);
    set_nosound(f.body, O_SA);
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && f.n_prepare == 2);
    CHECK(f.prep_hist[0] == O_SB && f.prep_hist[1] == O_SC);
    CHECK(strstr(f.log, "prep:591") == NULL && strstr(f.log, "prep:640:0,prep:689") != NULL);
    fx_init(&f);
    set_nosound(f.body, O_SB);
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && f.n_prepare == 2);
    CHECK(strstr(f.log, "prep:640") == NULL && strstr(f.log, "prep:591:0,prep:689") != NULL);
    fx_init(&f);
    set_nosound(f.body, O_SC);
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && f.n_prepare == 2);
    CHECK(strstr(f.log, "prep:689") == NULL && strstr(f.log, "prep:591:0,prep:640:0,phase") != NULL);
    fx_init(&f);
    set_nosound(f.body, O_SA);
    set_nosound(f.body, O_SB);
    set_nosound(f.body, O_SC);
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && f.n_prepare == 0 && strstr(f.log, "prep") == NULL);
    /* the NO SOUND test is the 9 bytes "NO SOUND\0": a longer name, a lower case name and a short one are real sounds */
    fx_init(&f);
    set_str(f.body, O_SA, "NO SOUND2");
    set_str(f.body, O_SB, "no sound");
    set_str(f.body, O_SC, "NO SOUN");
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && f.n_prepare == 3);
    fx_init(&f);
    memcpy(f.body + O_SA, "NO SOUND\0junk", 14u);
    memcpy(f.body + O_SB, "NO SOUND\0", 9u);
    memcpy(f.body + O_SC, "NO SOUNE", 9u);
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && f.n_prepare == 1 && strstr(f.log, "prep:689") != NULL);
    /* a name that differs from NO SOUND only in its first or last byte is a real sound (the whole 9 bytes are compared) */
    fx_init(&f);
    set_str(f.body, O_SA, "XO SOUND");
    set_nosound(f.body, O_SB);
    set_nosound(f.body, O_SC);
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && f.n_prepare == 1 && f.prep_hist[0] == O_SA);
    fx_init(&f);
    set_nosound(f.body, O_SA);
    set_str(f.body, O_SB, "NO SOUNX");
    set_nosound(f.body, O_SC);
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && f.n_prepare == 1 && f.prep_hist[0] == O_SB);
    fx_init(&f);
    set_nosound(f.body, O_SA);
    set_nosound(f.body, O_SB);
    set_str(f.body, O_SC, "NO_SOUND");
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && f.n_prepare == 1 && f.prep_hist[0] == O_SC);
    /* an empty puzzle surface name is still loaded */
    fx_init(&f);
    f.body[0] = 0;
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && strstr(f.log, "load:77") != NULL && f.loaded_name[0] == '\0');
    /* a surface the object already holds is kept: no load */
    fx_init(&f);
    f.o.surface = 55u;
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && strstr(f.log, "load") == NULL && f.o.surface == 55u);
    CHECK(strstr(f.log, "slotsurf:24:55") != NULL && f.setsurf_surface == 55u);
    /* the run resets the state a previous run left */
    fx_init(&f);
    f.o.state = CPZ_STATE_WAIT_SOUND;
    f.o.solved = 1;
    f.o.canceled = 1;
    f.o.piece = 5;
    f.o.dir = 0x12;
    f.o.step = 2;
    f.o.moved = 1;
    f.o.saved[0] = 1;
    f.o.saved[1] = 2;
    f.o.saved[2] = 3;
    f.o.saved[3] = 4;
    f.o.deadline = 9u;
    CHECK(visit(&f, ROW, 0u) == CPZ_OK);
    CHECK(f.o.state == 0 && f.o.solved == 0 && f.o.canceled == 0 && f.o.piece == 0 && f.o.dir == 0 && f.o.step == 0 &&
          f.o.moved == 0 && f.o.saved[0] == 0 && f.o.saved[1] == 0 && f.o.saved[2] == 0 && f.o.saved[3] == 0);
    /* a negative row is refused before any effect; a null observer is allowed */
    fx_init(&f);
    CHECK(visit(&f, -1, 0u) == CPZ_ERR_ARGUMENT && strcmp(f.failure, "0xd3-row") == 0 && f.log[0] == '\0' && f.o.active == 0);
    f.host.observe = NULL;
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && f.log[0] == '\0' && f.o.slot == 24 && f.o.active == 1);
}

/* The persist byte (body +0x21): 0 resets the persistent grid at phase 0, anything else keeps it; the grid setup runs once. */
static void t_persist(void)
{
    Fx f;
    int vals[3] = {1, 2, 0xff};
    fx_init(&f);
    memset(&f.world, 0xa5, sizeof f.world);
    f.world.grid_ready = 1;
    CHECK(visit(&f, ROW, 0u) == CPZ_OK);
    /* persist 0: reset (also the cells outside the body's grid), then the setup runs again */
    CHECK(strstr(f.log, "gridreset:0:0,clearitem:0:0,gridsetup:1:0") != NULL);
    CHECK(cells_match(&f) && f.world.cell[7][7].type == 0 && f.world.cell[7][7].visible == 0 && f.world.cell[5][5].piece == 0);
    for (int i = 0; i < 3; ++i) {
        fx_init(&f);
        f.body[O_PERSIST] = (uint8_t)vals[i];
        memset(&f.world, 0xa5, sizeof f.world);
        f.world.grid_ready = 1;
        CHECK(visit(&f, ROW, 0u) == CPZ_OK && f.phase == 1u);
        /* the grid is kept as it is, the setup is skipped and says so */
        CHECK(strstr(f.log, "gridreset") == NULL && strstr(f.log, "clearitem:0:0,gridsetup:0:0,slot:24") != NULL);
        CHECK(f.world.cell[0][0].type == (int16_t)0xa5a5 && f.world.cell[2][3].piece == (int16_t)0xa5a5 &&
              f.world.cell[0][0].rect[0] == (int32_t)0xa5a5a5a5 && f.world.grid_ready == 1);
        CHECK(f.o.cell_w == 30 && f.o.cell_h == 21); /* the object's cell size is derived either way */
        /* not ready: the setup runs even though the grid is not reset */
        fx_init(&f);
        f.body[O_PERSIST] = (uint8_t)vals[i];
        CHECK(visit(&f, ROW, 0u) == CPZ_OK && strstr(f.log, "gridreset") == NULL && strstr(f.log, "gridsetup:1:0") != NULL);
        CHECK(cells_match(&f) && f.world.grid_ready == 1);
    }
    /* not ready and not reset: the setup overwrites every field of the cells it covers, whatever was there */
    fx_init(&f);
    f.body[O_PERSIST] = 1;
    memset(&f.world, 0xa5, sizeof f.world);
    f.world.grid_ready = 0;
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && strstr(f.log, "gridsetup:1:0") != NULL && cells_match(&f));
    CHECK(f.world.cell[3][3].type == (int16_t)0xa5a5); /* outside the body's grid: untouched */
    /* the second run of the same body keeps the pieces where the first run left them */
    fx_init(&f);
    f.body[O_PERSIST] = 1;
    CHECK(visit(&f, ROW, 0u) == CPZ_OK);
    f.world.cell[1][0].piece = 0;
    f.world.cell[2][2].piece = 1;
    f.world.cell[2][2].visible = 1;
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && strstr(f.log, "gridsetup:0:0") != NULL);
    CHECK(f.world.cell[1][0].piece == 0 && f.world.cell[2][2].piece == 1);
    /* a persist byte of 0 forgets them */
    f.body[O_PERSIST] = 0;
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && f.world.cell[1][0].piece == 1 && f.world.cell[2][2].piece == 0 && cells_match(&f));
}

/* The one-time grid setup: arrows, walls, targets, unknown types, piece placement, odd and negative gaps. */
static void t_grid_setup(void)
{
    Fx f;
    /* every cell type of the header in one grid: 2 x 8 */
    fx_init(&f);
    put16(f.body, O_ROWS, 2);
    put16(f.body, O_COLS, 8);
    put16(f.body, O_PIECES, 0);
    for (int i = 0; i < 16; ++i) set_type(f.body, i / 8, i % 8, 0);
    {
        const int types[16] = {1, 5, 10, 0x10, 0x11, 0x12, 0x13, 0x14, 0, 0x0f, 0x15, 11, 0x20, 2, 3, 4};
        for (int i = 0; i < 16; ++i) set_type(f.body, i / 8, i % 8, types[i]);
    }
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && cells_match(&f));
    CHECK(f.world.cell[0][3].base[0] == f.world.cell[0][3].rect[0] - 2 - 8 && f.world.cell[0][3].base[2] - f.world.cell[0][3].base[0] == 16);
    CHECK(f.world.cell[0][3].base[1] == f.world.cell[0][3].rect[1] + 6 && f.world.cell[0][3].base[3] == f.world.cell[0][3].rect[3] - 6);
    CHECK(f.world.cell[0][6].base[0] == f.world.cell[0][6].rect[2] + 2 - 8);
    CHECK(f.world.cell[0][4].base[1] == f.world.cell[0][4].rect[1] - 2 - 8 && f.world.cell[0][4].base[3] - f.world.cell[0][4].base[1] == 16);
    CHECK(f.world.cell[0][4].base[0] == f.world.cell[0][4].rect[0] + 10 && f.world.cell[0][4].base[2] == f.world.cell[0][4].rect[2] - 10);
    CHECK(f.world.cell[0][5].base[1] == f.world.cell[0][5].rect[3] + 2 - 8);
    CHECK(f.world.cell[0][0].visible == 1 && f.world.cell[1][0].visible == 0 && f.world.cell[1][2].visible == 1 &&
          f.world.cell[1][3].visible == 1 && f.world.cell[0][7].visible == 1);
    /* the setup stores the rectangle without the arrow moves for the wall / targets / unknown types */
    CHECK(rect_eq(f.world.cell[0][7].base, f.world.cell[0][7].rect) && rect_eq(f.world.cell[1][3].base, f.world.cell[1][3].rect));
    /* odd and negative gaps: the cell stride uses the gap, the arrow offsets use gap / 2 truncated toward zero */
    {
        const int gaps[6] = {3, -3, -4, 1, -1, 0};
        for (int g = 0; g < 6; ++g) {
            fx_init(&f);
            put16(f.body, O_ROWS, 2);
            put16(f.body, O_COLS, 4);
            put16(f.body, O_PIECES, 0);
            put16(f.body, O_GAP, gaps[g]);
            for (int i = 0; i < 8; ++i) set_type(f.body, i / 4, i % 4, 0x10 + (i % 4));
            CHECK(visit(&f, ROW, 0u) == CPZ_OK && cells_match(&f));
        }
    }
    /* negative and large types are drawn as visible cells without an overlay move */
    fx_init(&f);
    put16(f.body, O_ROWS, 1);
    put16(f.body, O_COLS, 3);
    put16(f.body, O_PIECES, 0);
    set_type(f.body, 0, 0, -1);
    set_type(f.body, 0, 1, 0x7fff);
    set_type(f.body, 0, 2, -32768);
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && cells_match(&f) && f.world.cell[0][0].visible == 1 && f.world.cell[0][2].visible == 1);
    /* an arrow taller than the cell: the centering offset (21 - 22) / 2 truncates to 0, not -1 */
    fx_init(&f);
    put16(f.body, O_ROWS, 1);
    put16(f.body, O_COLS, 2);
    put16(f.body, O_PIECES, 0);
    put_rect(f.body, O_AH, 3000, 10, 3016, 32); /* 16 x 22 */
    put_rect(f.body, O_AV, 3100, 10, 3140, 26); /* 40 x 16: (30 - 40) / 2 = -5 */
    set_type(f.body, 0, 0, 0x10);
    set_type(f.body, 0, 1, 0x11);
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && cells_match(&f));
    CHECK(f.world.cell[0][0].base[1] == f.world.cell[0][0].rect[1] && f.world.cell[0][1].base[0] == f.world.cell[0][1].rect[0] - 5);
    /* an odd arrow width: w / 2 truncates (17 / 2 = 8), the vertical one (cell width - 9) / 2 */
    fx_init(&f);
    put16(f.body, O_ROWS, 1);
    put16(f.body, O_COLS, 2);
    put16(f.body, O_PIECES, 0);
    put_rect(f.body, O_AH, 3000, 10, 3017, 19);
    put_rect(f.body, O_AV, 3100, 10, 3108, 27);
    set_type(f.body, 0, 0, 0x13);
    set_type(f.body, 0, 1, 0x12);
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && cells_match(&f));
    /* pieces: start words are (column, row); a piece makes its cell visible; later pieces win a shared cell; pieces outside
     * the grid or beyond the count are not placed */
    fx_init(&f);
    put16(f.body, O_PIECES, 3);
    set_piece(f.body, 0, 2, 3);
    set_piece(f.body, 1, 2, 3);
    set_piece(f.body, 2, 0, 0);
    set_piece(f.body, 3, 1, 1); /* beyond the count */
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && cells_match(&f));
    CHECK(f.world.cell[2][3].piece == 2 && f.world.cell[0][0].piece == 3 && f.world.cell[1][1].piece == 0 && f.world.cell[1][1].visible == 0);
    fx_init(&f);
    put16(f.body, O_PIECES, 3);
    set_piece(f.body, 0, 3, 0);  /* row 3 is outside the 3 rows */
    set_piece(f.body, 1, 0, 4);  /* column 4 is outside the 4 columns */
    set_piece(f.body, 2, -1, 0);
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && cells_match(&f));
    {
        int count = 0;
        for (int a = 0; a < 8; ++a)
            for (int b = 0; b < 8; ++b) count += f.world.cell[a][b].piece != 0;
        CHECK(count == 0);
    }
    /* a piece on a target keeps the target's overlay rectangle */
    fx_init(&f);
    set_piece(f.body, 0, 2, 1);
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && cells_match(&f) && f.world.cell[2][1].piece == 1 && f.world.cell[2][1].type == 2);
    /* the cell size is taken from piece 1's source rectangle, whatever the others are */
    fx_init(&f);
    put_rect(f.body, O_PSRC, 5, 6, 45, 36);
    put_rect(f.body, O_PSRC + 16, 0, 0, 7, 7);
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && f.o.cell_w == 40 && f.o.cell_h == 30 && cells_match(&f));
    /* the origin, gap and view origin all enter the rectangles */
    fx_init(&f);
    put32(f.body, O_OX, -20);
    put32(f.body, O_OY, 99);
    f.vx = -3;
    f.vy = 40;
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && cells_match(&f) && f.world.cell[2][3].rect[0] == 4 * 3 - 3 - 20 + 3 * 30);
    CHECK(f.world.cell[2][3].rect[1] == 4 * 2 + 40 + 99 + 2 * 21);
}

/* ---- the pointer ---------------------------------------------------------------------------------------------------------- */

/* A point inside the zone of direction `dir` (0x10 left, 0x11 up, 0x12 down, 0x13 right) of the cell (a, b). */
static void zone_pt(const Fx *f, int a, int b, int dir, int32_t *px, int32_t *py)
{
    int32_t r[4];
    crect(f, a, b, r);
    switch (dir) {
    case 0x11: *px = (r[0] + r[2]) / 2; *py = r[1]; break;
    case 0x12: *px = (r[0] + r[2]) / 2; *py = r[3]; break;
    case 0x10: *px = r[0]; *py = (r[1] + r[3]) / 2; break;
    default: *px = r[2]; *py = (r[1] + r[3]) / 2; break;
    }
}

static int cand_of(int dir) { return dir == 0x10 ? 0x2780 : dir == 0x11 ? 0x2781 : dir == 0x12 ? 0x2782 : 0x2783; }
static int cursor_of(int dir) { return dir == 0x10 ? 0x19 : dir == 0x11 ? 0x17 : dir == 0x12 ? 0x18 : 0x1a; }

/* The zone of the header, written out: a quarter of the width left and right, half the height above and below, in the order
 * up, right, down, left; inclusive where the header says so. 0 = no zone. */
static int ref_zone(const int32_t r[4], int32_t w, int32_t h, int32_t px, int32_t py)
{
    const int32_t q = w / 4, hh = h / 2;
    if (r[1] <= py && py < r[1] + hh && r[0] + q < px && px < r[2] - q) return 0x11;
    if (r[1] <= py && py <= r[3] && r[2] - q < px && px <= r[2]) return 0x13;
    if (r[3] - hh <= py && py <= r[3] && r[0] + q < px && px < r[2] - q) return 0x12;
    if (r[1] <= py && py <= r[3] && r[0] <= px && px < r[0] + q) return 0x10;
    return 0;
}

/* One piece in the middle of a free 3 x 4 grid: every point around the cell is classified like the reference. */
static void zones_for_size(int w, int h)
{
    Fx f;
    int32_t r[4];
    fx_init(&f);
    put_rect(f.body, O_PSRC, 0, 0, w, h);
    put16(f.body, O_PIECES, 1);
    set_type(f.body, 1, 3, 0);
    set_type(f.body, 2, 1, 0);
    set_piece(f.body, 0, 1, 1);
    start(&f);
    crect(&f, 1, 1, r);
    for (int32_t py = r[1] - 3; py <= r[3] + 3; ++py) {
        for (int32_t px = r[0] - 3; px <= r[2] + 3; ++px) {
            CpzPointerResult p;
            const int z = ref_zone(r, w, h, px, py);
            f.o.piece = 0;
            f.o.dir = 0;
            CHECK(ptr(&f, px, py, &p) == CPZ_OK);
            if (z != 0) {
                CHECK(p.hit == 1u && p.candidate == cand_of(z) && p.cursor_written == 1u && p.cursor_kind == cursor_of(z) &&
                      p.cursor_sub == 1);
                CHECK(f.o.piece == 1 && f.o.at_row == 1 && f.o.at_col == 1 && f.o.dir == z);
            } else {
                CHECK(p.hit == 0u && p.candidate == -1 && p.cursor_written == 0u && f.o.dir == 0);
            }
            if (g_failed) {
                snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (cell %d x %d at %d,%d)", w, h, px, py);
                return;
            }
        }
    }
}

static void t_pointer_zones(void)
{
    zones_for_size(30, 21);
    zones_for_size(31, 20);
    zones_for_size(33, 7);
    zones_for_size(29, 1);
    zones_for_size(3, 3);
    zones_for_size(2, 2);
    zones_for_size(1, 5);
    zones_for_size(40, 40);
}

static void t_pointer_basics(void)
{
    Fx f;
    CpzPointerResult p;
    int32_t px, py;
    fx_init(&f);
    /* an inactive puzzle: nothing happens, the object is untouched */
    memset(&p, 0x55, sizeof p);
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, 30, 30, 7, 11, &p) == CPZ_OK);
    CHECK(p.hit == 0u && p.candidate == -1 && p.cursor_written == 0u && p.cursor_kind == 0 && p.cursor_sub == 0);
    start(&f);
    /* a move in progress: nothing happens, the object is untouched */
    f.o.state = CPZ_STATE_MOVING;
    f.o.piece = 9;
    f.o.dir = 0x12;
    zone_pt(&f, 0, 1, 0x12, &px, &py);
    CHECK(ptr(&f, px, py, &p) == CPZ_OK && p.hit == 0u && p.candidate == -1 && p.cursor_written == 0u);
    CHECK(f.o.piece == 9 && f.o.dir == 0x12 && f.o.at_row == 0 && f.o.at_col == 0);
    f.o.state = CPZ_STATE_IDLE;
    f.o.piece = 0;
    f.o.dir = 0;
    /* other states (not moving) hit */
    for (int s = 0; s <= 4; ++s) {
        if (s == CPZ_STATE_MOVING) continue;
        f.o.state = s;
        f.o.dir = 0;
        CHECK(ptr(&f, px, py, &p) == CPZ_OK && p.hit == 1u && p.candidate == 0x2782);
    }
    f.o.state = CPZ_STATE_IDLE;
    /* piece 2 at (0, 1) can go down: object and result */
    CHECK(ptr(&f, px, py, &p) == CPZ_OK && p.hit == 1u && p.candidate == 0x2782 && p.cursor_kind == 0x18 && p.cursor_sub == 1);
    CHECK(f.o.piece == 2 && f.o.at_row == 0 && f.o.at_col == 1 && f.o.dir == 0x12);
    /* piece 1 at (1, 0) can go up, right and down but not left */
    zone_pt(&f, 1, 0, 0x10, &px, &py);
    CHECK(ptr(&f, px, py, &p) == CPZ_OK && p.hit == 0u && p.candidate == -1 && f.o.dir == 0 && f.o.piece == 0);
    zone_pt(&f, 1, 0, 0x13, &px, &py);
    CHECK(ptr(&f, px, py, &p) == CPZ_OK && p.hit == 1u && p.candidate == 0x2783 && p.cursor_kind == 0x1a);
    CHECK(f.o.piece == 1 && f.o.at_row == 1 && f.o.at_col == 0 && f.o.dir == 0x13);
    zone_pt(&f, 1, 0, 0x11, &px, &py);
    CHECK(ptr(&f, px, py, &p) == CPZ_OK && p.hit == 1u && p.candidate == 0x2781 && p.cursor_kind == 0x17 && f.o.dir == 0x11);
    /* a miss over empty ground: no hit, the direction is cleared, the piece number is left at the last piece scanned */
    CHECK(ptr(&f, 5, 5, &p) == CPZ_OK && p.hit == 0u && p.candidate == -1 && p.cursor_written == 0u && f.o.dir == 0);
    CHECK(f.o.piece == 1 && f.o.at_row == 1 && f.o.at_col == 0); /* (1,0) is the last piece scanned */
    /* the cursor over the interior of a cell (between the zones) is a miss */
    {
        int32_t r[4];
        crect(&f, 1, 0, r);
        CHECK(ptr(&f, (r[0] + r[2]) / 2, (r[1] + r[3]) / 2, &p) == CPZ_OK && p.hit == 0u);
    }
    /* sign extension of the 16-bit arguments and the view origin: x = 0x10000 + v is v; the origin is added after */
    zone_pt(&f, 1, 0, 0x13, &px, &py);
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, px - f.vx + 0x10000, py - f.vy + 0x20000, f.vx, f.vy, &p) == CPZ_OK &&
          p.hit == 1u && p.candidate == 0x2783);
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, px - f.vx - 0x10000, py - f.vy - 0x10000, f.vx, f.vy, &p) == CPZ_OK &&
          p.hit == 1u && p.candidate == 0x2783);
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, px - 100, py - 100, 100, 100, &p) == CPZ_OK && p.hit == 1u);
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, px - f.vx, py - f.vy, f.vx, f.vy + 1, &p) == CPZ_OK && p.hit == 1u &&
          p.candidate == 0x2783); /* the right zone is tall enough for one more row */
    /* arguments */
    CHECK(cpz_pointer(NULL, &f.world, f.body, CPZ_BODY_BYTES, 0, 0, 0, 0, &p) == CPZ_ERR_ARGUMENT);
    CHECK(cpz_pointer(&f.o, NULL, f.body, CPZ_BODY_BYTES, 0, 0, 0, 0, &p) == CPZ_ERR_ARGUMENT);
    CHECK(cpz_pointer(&f.o, &f.world, NULL, CPZ_BODY_BYTES, 0, 0, 0, 0, &p) == CPZ_ERR_ARGUMENT);
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, 0, 0, 0, 0, NULL) == CPZ_ERR_ARGUMENT);
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES - 1u, 0, 0, 0, 0, &p) == CPZ_ERR_ARGUMENT);
    f.body[0] = 'A';
    memset(f.body, 'A', CPZ_NAME_BYTES);
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, 0, 0, 0, 0, &p) == CPZ_ERR_ARGUMENT);
}

/* The scan order: row-major over the cells, the first piece whose zone and move check accept wins. Negative gaps make the
 * cells overlap, so two pieces claim the same point. */
static void t_pointer_order(void)
{
    Fx f;
    CpzPointerResult p;
    int32_t a[4], b[4];
    fx_init(&f);
    put16(f.body, O_GAP, -10);
    put16(f.body, O_PIECES, 2);
    set_piece(f.body, 0, 1, 1); /* piece 1 at row 1 column 1 */
    set_piece(f.body, 1, 0, 0); /* piece 2 at row 0 column 0: scanned first */
    set_type(f.body, 1, 3, 0);
    set_type(f.body, 2, 1, 0);
    start(&f);
    crect(&f, 0, 0, a);
    crect(&f, 1, 1, b);
    /* the point is in the right zone of (0, 0) and the left zone of (1, 1) */
    {
        const int32_t px = b[0] + 5, py = b[1] + 2;
        CHECK(ref_zone(a, 30, 21, px, py) == 0x13 && ref_zone(b, 30, 21, px, py) == 0x10);
        CHECK(ptr(&f, px, py, &p) == CPZ_OK && p.hit == 1u && p.candidate == 0x2783);
        CHECK(f.o.piece == 2 && f.o.at_row == 0 && f.o.at_col == 0 && f.o.dir == 0x13);
        /* if (0, 0) cannot go right the second claimant wins; the refusal cleared the piece and the direction first */
        set_type(f.body, 0, 0, 0x13);
        CHECK(visit(&f, ROW, 0u) == CPZ_OK && cells_match(&f));
        CHECK(ptr(&f, px, py, &p) == CPZ_OK && p.hit == 1u && p.candidate == 0x2780);
        CHECK(f.o.piece == 1 && f.o.at_row == 1 && f.o.at_col == 1 && f.o.dir == 0x10);
    }
}

static void t_pointer_cancel(void)
{
    Fx f;
    CpzPointerResult p;
    fx_init(&f);
    start(&f);
    /* the cancel rectangle (10, 20, 59, 39) is view relative and inclusive; no view origin is added */
    for (int y = 18; y <= 41; ++y) {
        for (int x = 8; x <= 61; ++x) {
            const int inside = x >= 10 && x <= 59 && y >= 20 && y <= 39;
            f.o.dir = 0x13;
            CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, x, y, 7, 11, &p) == CPZ_OK);
            if (inside) {
                /* no piece cell is near */
                CHECK(p.hit == 1u && p.candidate == 0x277f && p.cursor_written == 1u && p.cursor_kind == 9 && p.cursor_sub == 1);
            } else {
                CHECK(p.hit == 0u && p.candidate == -1 && p.cursor_written == 0u);
            }
            CHECK(f.o.dir == 0); /* a miss over the pieces clears the direction; the cancel rectangle is checked after that */
            if (g_failed) {
                snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (%d,%d)", x, y);
                return;
            }
        }
    }
    /* sign extension: the cancel test uses the 16-bit values */
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, 0x10000 + 30, 0x30000 + 30, 7, 11, &p) == CPZ_OK && p.candidate == 0x277f);
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, 30 - 0x10000, 30 - 0x10000, 7, 11, &p) == CPZ_OK && p.candidate == 0x277f);
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, 0x8000 + 30, 30, 7, 11, &p) == CPZ_OK && p.hit == 0u);
    /* a cancel rectangle with negative bounds */
    put_rect(f.body, O_CRECT, -30, -20, -5, -1);
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, -30, -20, 7, 11, &p) == CPZ_OK && p.candidate == 0x277f);
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, -5, -1, 7, 11, &p) == CPZ_OK && p.candidate == 0x277f);
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, -31, -10, 7, 11, &p) == CPZ_OK && p.hit == 0u);
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, -4, -10, 7, 11, &p) == CPZ_OK && p.hit == 0u);
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, -10, -21, 7, 11, &p) == CPZ_OK && p.hit == 0u);
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, -10, 0, 7, 11, &p) == CPZ_OK && p.hit == 0u);
    /* a piece zone wins over the cancel rectangle (the rectangle covers the piece's cell) */
    put_rect(f.body, O_CRECT, 0, 0, 400, 400);
    {
        int32_t px, py;
        zone_pt(&f, 1, 0, 0x13, &px, &py);
        CHECK(ptr(&f, px, py, &p) == CPZ_OK && p.hit == 1u && p.candidate == 0x2783);
        CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, 1, 1, f.vx, f.vy, &p) == CPZ_OK && p.hit == 1u && p.candidate == 0x277f && f.o.dir == 0);
    }
    /* the cancel rectangle works in every state but moving, even solved */
    f.o.solved = 1;
    f.o.state = CPZ_STATE_WAIT_DELAY;
    CHECK(cpz_pointer(&f.o, &f.world, f.body, CPZ_BODY_BYTES, 30, 30, 7, 11, &p) == CPZ_OK && p.candidate == 0x277f);
}

/* ---- the move check, through the pointer ---------------------------------------------------------------------------------- */

static int opposite(int d) { return d == 0x10 ? 0x13 : d == 0x13 ? 0x10 : d == 0x11 ? 0x12 : 0x11; }

/* A 3 x 4 grid with piece 1 alone at (a, b) and the others empty; `block` modifies the body; the pointer is over the zone of
 * direction d of the piece. Returns whether the pointer hit, i.e. whether the move check accepted. */
static int try_dir(int a, int b, int d, void (*block)(uint8_t *, int, int, int), int extra_piece)
{
    Fx f;
    CpzPointerResult p;
    int32_t px, py;
    int hit;
    fx_init(&f);
    for (int i = 0; i < 12; ++i) set_type(f.body, i / 4, i % 4, 0);
    put16(f.body, O_PIECES, extra_piece ? 2 : 1);
    set_piece(f.body, 0, a, b);
    if (block != NULL) block(f.body, a, b, d);
    if (extra_piece) {
        /* the extra piece stands on the neighbor in direction d; the kernel must refuse because the cell is taken */
        const int na = a + (d == 0x12) - (d == 0x11), nb = b + (d == 0x13) - (d == 0x10);
        set_piece(f.body, 1, na, nb);
    }
    start(&f);
    f.o.step = 3; /* a refusal clears the step counter; an acceptance leaves it */
    zone_pt(&f, a, b, d, &px, &py);
    if (ptr(&f, px, py, &p) != CPZ_OK) return -1;
    hit = p.hit == 1u && p.candidate == cand_of(d);
    if (hit) {
        if (f.o.piece != 1 || f.o.at_row != a || f.o.at_col != b || f.o.dir != d || f.o.step != 3) return -2;
    } else {
        /* the refusal clears piece, direction and step; the miss leaves them cleared */
        if (f.o.piece != 0 && !extra_piece) return -3;
        if (f.o.dir != 0 || f.o.step != 0 || p.hit != 0u) return -4;
    }
    return hit;
}

static void blk_own_same(uint8_t *b, int a, int c, int d) { set_type(b, a, c, d); }
static void blk_own_other(uint8_t *b, int a, int c, int d)
{
    set_type(b, a, c, d == 0x10 ? 0x13 : 0x10); /* an arrow of another direction does not block */
}
static void blk_nb_opposite(uint8_t *b, int a, int c, int d)
{
    set_type(b, a + (d == 0x12) - (d == 0x11), c + (d == 0x13) - (d == 0x10), opposite(d));
}
static void blk_nb_same(uint8_t *b, int a, int c, int d)
{
    set_type(b, a + (d == 0x12) - (d == 0x11), c + (d == 0x13) - (d == 0x10), d);
}
static void blk_nb_wall(uint8_t *b, int a, int c, int d)
{
    set_type(b, a + (d == 0x12) - (d == 0x11), c + (d == 0x13) - (d == 0x10), 0x14);
}
static void blk_nb_target(uint8_t *b, int a, int c, int d)
{
    set_type(b, a + (d == 0x12) - (d == 0x11), c + (d == 0x13) - (d == 0x10), 3);
}
static void blk_nb_perp(uint8_t *b, int a, int c, int d)
{
    set_type(b, a + (d == 0x12) - (d == 0x11), c + (d == 0x13) - (d == 0x10), (d == 0x10 || d == 0x13) ? 0x11 : 0x10);
}
static void blk_nb_unknown(uint8_t *b, int a, int c, int d)
{
    set_type(b, a + (d == 0x12) - (d == 0x11), c + (d == 0x13) - (d == 0x10), 0x15);
}
static void blk_own_wall(uint8_t *b, int a, int c, int d)
{
    (void)d;
    set_type(b, a, c, 0x14);
}
static void blk_own_opposite(uint8_t *b, int a, int c, int d) { set_type(b, a, c, opposite(d)); }
static void blk_own_perp(uint8_t *b, int a, int c, int d)
{
    set_type(b, a, c, (d == 0x10 || d == 0x13) ? 0x11 : 0x10);
}
static void blk_own_target(uint8_t *b, int a, int c, int d)
{
    (void)d;
    set_type(b, a, c, 1);
}

static int g_case;
#define TRY(...) (g_case = __LINE__, try_dir(__VA_ARGS__))
static void t_move_check(void)
{
    static const int dirs[4] = {0x10, 0x11, 0x12, 0x13};
    for (int i = 0; i < 4; ++i) {
        const int d = dirs[i];
        const int da = (d == 0x12) - (d == 0x11), db = (d == 0x13) - (d == 0x10);
        /* the piece in the middle of the 3 x 4 grid, (1, 1) - (1, 2) for the horizontal moves */
        const int a = 1, b = d == 0x13 ? 1 : (d == 0x10 ? 2 : 1);
        int r;
        r = TRY(a, b, d, NULL, 0);
        CHECK(r == 1);
        r = TRY(a, b, d, blk_own_other, 0);
        CHECK(r == 1);
        r = TRY(a, b, d, blk_own_perp, 0);
        CHECK(r == 1);
        r = TRY(a, b, d, blk_own_opposite, 0);
        CHECK(r == 1);
        r = TRY(a, b, d, blk_own_wall, 0);
        CHECK(r == 1);
        r = TRY(a, b, d, blk_own_target, 0);
        CHECK(r == 1);
        r = TRY(a, b, d, blk_nb_same, 0);
        CHECK(r == 1);
        r = TRY(a, b, d, blk_nb_perp, 0);
        CHECK(r == 1);
        r = TRY(a, b, d, blk_nb_target, 0);
        CHECK(r == 1);
        r = TRY(a, b, d, blk_nb_unknown, 0);
        CHECK(r == 1);
        r = TRY(a, b, d, blk_own_same, 0);
        CHECK(r == 0);
        r = TRY(a, b, d, blk_nb_opposite, 0);
        CHECK(r == 0);
        r = TRY(a, b, d, blk_nb_wall, 0);
        CHECK(r == 0);
        r = TRY(a, b, d, NULL, 1);
        CHECK(r == 0);
        /* the grid edge: the piece in the last cell of that direction (rows 3, columns 4 differ) */
        {
            const int ea = d == 0x11 ? 0 : (d == 0x12 ? 2 : 1), eb = d == 0x10 ? 0 : (d == 0x13 ? 3 : 1);
            r = TRY(ea, eb, d, NULL, 0);
            CHECK(r == 0);
            /* one cell before the edge it is free */
            r = TRY(ea - da, eb - db, d, NULL, 0);
            CHECK(r == 1);
        }
        if (g_failed) {
            snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (direction 0x%x, call at line %d, result %d)", d, g_case, r);
            return;
        }
    }
    /* the move check on all rows and columns of a bigger grid: every interior cell can go in all four directions */
    for (int a = 0; a < 3; ++a)
        for (int b = 0; b < 4; ++b)
            for (int i = 0; i < 4; ++i) {
                const int d = dirs[i];
                const int edge = (d == 0x10 && b == 0) || (d == 0x13 && b == 3) || (d == 0x11 && a == 0) || (d == 0x12 && a == 2);
                CHECK(TRY(a, b, d, NULL, 0) == (edge ? 0 : 1));
            }
}

/* ---- animation, the phase 1 state machine ---------------------------------------------------------------------------------- */

static void dir_delta(const Fx *f, int d, int32_t steps, int32_t *dx, int32_t *dy)
{
    *dx = d == 0x10 ? -(cw_of(f) / steps) : (d == 0x13 ? cw_of(f) / steps : 0);
    *dy = d == 0x11 ? -(ch_of(f) / steps) : (d == 0x12 ? ch_of(f) / steps : 0);
}

/* Starts a slide: piece 1 alone at (a, b); the pointer and the click; returns after the click (state MOVING). */
static void begin_slide(Fx *f, int a, int b, int d, int steps)
{
    CpzPointerResult p;
    CpzClickResult c;
    int32_t px, py;
    put16(f->body, O_PIECES, 1);
    put16(f->body, O_STEPS, steps);
    for (int i = 0; i < 12; ++i) set_type(f->body, i / 4, i % 4, 0);
    set_piece(f->body, 0, a, b);
    start(f);
    zone_pt(f, a, b, d, &px, &py);
    CHECK(ptr(f, px, py, &p) == CPZ_OK && p.hit == 1u && p.candidate == cand_of(d));
    CHECK(click(f, 1u, p.candidate, 0, &c) == CPZ_OK && c.move_started == 1u && f->o.state == CPZ_STATE_MOVING);
    LOGCLR(f);
}

/* Every tick of a slide of one cell: the rectangle moves by cell size / steps (truncated), the last tick snaps. */
static void check_slide(int d, int steps)
{
    Fx f;
    const int a = 1, b = d == 0x13 ? 2 : 1; /* the neighbor in direction d is a grid edge cell: the slide ends there */
    const int na = a + (d == 0x12) - (d == 0x11), nb = b + (d == 0x13) - (d == 0x10);
    int32_t dx, dy, cell[4], ncell[4], expect[4], saved[4];
    fx_init(&f);
    begin_slide(&f, a, b, d, steps);
    crect(&f, a, b, cell);
    crect(&f, na, nb, ncell);
    dir_delta(&f, d, steps, &dx, &dy);
    memcpy(expect, cell, sizeof expect);
    for (int s = 1; s <= steps; ++s) {
        memcpy(saved, f.world.cell[a][b].rect, sizeof saved);
        LOGCLR(&f);
        CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.phase == 1u && f.completed == 0);
        if (s < steps) {
            expect[0] += dx;
            expect[2] = expect[0] + cw_of(&f);
            expect[1] += dy;
            expect[3] = expect[1] + ch_of(&f);
            CHECK(rect_eq(f.world.cell[a][b].rect, expect));
            CHECK(rect_eq(f.o.saved, saved));
            CHECK(f.o.step == s && f.o.moved == 0 && f.o.state == CPZ_STATE_MOVING && f.world.cell[a][b].piece == 1);
            CHECK(f.world.cell[na][nb].piece == 0 && f.log[0] == '\0' && f.o.at_row == a && f.o.at_col == b);
        } else {
            /* the last tick: the piece arrives; the old cell is emptied and its rectangle restored; the saved rectangle is
             * the one before this tick's step */
            CHECK(rect_eq(f.o.saved, saved));
            CHECK(f.world.cell[a][b].piece == 0 && f.world.cell[a][b].visible == 0 && rect_eq(f.world.cell[a][b].rect, cell));
            CHECK(f.world.cell[na][nb].piece == 1 && f.world.cell[na][nb].visible == 1 && rect_eq(f.world.cell[na][nb].rect, ncell));
            CHECK(f.o.at_row == na && f.o.at_col == nb && f.o.step == 0 && f.o.moved == 1);
            /* the wall stops it: the refusal of the move check cleared the piece number (and the direction), so the stop is on an
             * empty cell type (0 == 0): sound B, channel 12 */
            CHECK(f.o.state == CPZ_STATE_IDLE && f.o.piece == 0 && f.o.dir == 0);
            CHECK_LOG(&f, "play:12:0,state:0:0");
        }
        if (g_failed) {
            snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (direction 0x%x steps %d tick %d)", d, steps, s);
            return;
        }
    }
}

static void t_animation(void)
{
    static const int dirs[4] = {0x10, 0x11, 0x12, 0x13};
    static const int steps[] = {1, 2, 3, 4, 5, 6, 7, 9, 21, 40};
    for (int i = 0; i < 4; ++i)
        for (size_t s = 0; s < sizeof steps / sizeof steps[0]; ++s) {
            check_slide(dirs[i], steps[s]);
            if (g_failed) return;
        }
}

/* A piece that keeps going: no sound and no state change between cells; it stops at the grid edge. */
static void t_slide_chain(void)
{
    Fx f;
    int ticks = 0;
    fx_init(&f);
    begin_slide(&f, 1, 3, 0x10, 2); /* from (1, 3) to the left edge (1, 0): three cells of two ticks */
    f.world.cell[1][0].type = 0;
    while (f.o.state == CPZ_STATE_MOVING && ticks < 20) {
        CHECK(visit(&f, ROW, 1u) == CPZ_OK);
        ++ticks;
        if (ticks == 2) {
            CHECK(f.o.at_col == 2 && f.o.state == CPZ_STATE_MOVING && f.o.moved == 1 && f.log[0] == '\0');
        }
        if (ticks == 4) CHECK(f.o.at_col == 1 && f.o.state == CPZ_STATE_MOVING && f.log[0] == '\0');
    }
    CHECK(ticks == 6 && f.o.at_col == 0 && f.o.state == CPZ_STATE_IDLE);
    CHECK_LOG(&f, "play:12:0,state:0:0");
    CHECK(f.world.cell[1][0].piece == 1 && f.world.cell[1][1].piece == 0 && f.world.cell[1][3].piece == 0);
    /* the idle visit after the move clears the moved flag and looks for the solution (piece 1 is on type 0: not solved) */
    CHECK(f.o.moved == 1);
    LOGCLR(&f);
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.moved == 0 && f.o.solved == 0 && f.o.state == CPZ_STATE_IDLE && f.log[0] == '\0');
    /* the cell the piece left stays visible when it has a type */
    fx_init(&f);
    begin_slide(&f, 1, 2, 0x10, 1);
    set_type(f.body, 1, 2, 0x11);
    f.world.cell[1][2].type = 0x11;
    f.world.cell[1][2].visible = 1;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.world.cell[1][2].piece == 0 && f.world.cell[1][2].visible == 1);
}

/* A MOVING object without a direction cannot step: nothing moves and nothing is counted. */
static void t_moving_without_direction(void)
{
    Fx f;
    CpzWorld before;
    fx_init(&f);
    begin_slide(&f, 1, 1, 0x13, 4);
    f.o.dir = 0;
    before = f.world;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.state == CPZ_STATE_MOVING && f.o.step == 0 && f.o.moved == 0 && f.log[0] == '\0');
    CHECK(memcmp(&before, &f.world, sizeof before) == 0);
    f.o.dir = 0x25; /* a value that is none of the four */
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.state == CPZ_STATE_MOVING && f.o.step == 0 && memcmp(&before, &f.world, sizeof before) == 0);
}

static void stop_on(Fx *f, int type, int sound_a_none)
{
    begin_slide(f, 1, 2, 0x13, 1); /* to (1, 3): the grid edge */
    if (sound_a_none) set_nosound(f->body, O_SB);
    f->world.cell[1][3].type = (int16_t)type;
}

/* The move check that ends the slide clears the piece number (obj+0x39) before the stop sound is chosen, so the test "does the
 * piece rest on the cell type that equals its number" compares the cell type with 0: an empty cell plays sound B (channel 12), any
 * other cell type plays sound C (channel 13), even the target of the piece itself. */
static void t_stop_sounds(void)
{
    Fx f;
    fx_init(&f);
    stop_on(&f, 0, 0);
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.state == CPZ_STATE_IDLE && f.o.piece == 0);
    CHECK_LOG(&f, "play:12:0,state:0:0");
    {
        const int types[] = {1, 2, 3, 10, 0x10, 0x11, 0x12, 0x13, 0x14, 0x15, -1};
        for (size_t i = 0; i < sizeof types / sizeof types[0]; ++i) {
            fx_init(&f);
            stop_on(&f, types[i], 0);
            CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.state == CPZ_STATE_IDLE);
            CHECK_LOG(&f, "play:13:0,state:0:0");
            if (g_failed) return;
        }
    }
    /* NO SOUND records stay silent but the state still returns to idle */
    fx_init(&f);
    stop_on(&f, 0, 1);
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.state == CPZ_STATE_IDLE);
    CHECK_LOG(&f, "state:0:0");
    fx_init(&f);
    begin_slide(&f, 1, 2, 0x13, 1);
    set_nosound(f.body, O_SC);
    f.world.cell[1][3].type = 3;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK);
    CHECK_LOG(&f, "state:0:0");
    /* B silent: C still plays on a non-empty cell; C silent: B still plays on an empty one */
    fx_init(&f);
    stop_on(&f, 5, 1);
    CHECK(visit(&f, ROW, 1u) == CPZ_OK);
    CHECK_LOG(&f, "play:13:0,state:0:0");
    fx_init(&f);
    begin_slide(&f, 1, 2, 0x13, 1);
    set_nosound(f.body, O_SC);
    CHECK(visit(&f, ROW, 1u) == CPZ_OK);
    CHECK_LOG(&f, "play:12:0,state:0:0");
    /* the channel words are signed 16-bit */
    fx_init(&f);
    begin_slide(&f, 1, 2, 0x13, 1);
    put16(f.body, O_CB, -5);
    CHECK(visit(&f, ROW, 1u) == CPZ_OK);
    CHECK_LOG(&f, "play:-5:0,state:0:0");
    CHECK(f.played_channel == -5);
    fx_init(&f);
    begin_slide(&f, 1, 2, 0x13, 1);
    f.world.cell[1][3].type = 4;
    put16(f.body, O_CC, 0x7fff);
    CHECK(visit(&f, ROW, 1u) == CPZ_OK);
    CHECK_LOG(&f, "play:32767:0,state:0:0");
}

static void t_solved_scan(void)
{
    Fx f;
    /* nothing placed yet and a piece off its target: not solved, no effect */
    fx_init(&f);
    start(&f);
    f.now = 1234u;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.solved == 0 && f.o.state == CPZ_STATE_IDLE && f.log[0] == '\0' && f.phase == 1u);
    /* both pieces on their targets: the scan marks the puzzle solved */
    f.world.cell[1][0].piece = 0;
    f.world.cell[1][3].piece = 1;
    f.world.cell[0][1].piece = 0;
    f.world.cell[2][1].piece = 2;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.solved == 1 && f.o.state == CPZ_STATE_SOLVED);
    CHECK_LOG(&f, "state:1:0");
    /* one of the two on its target is not enough, in either order of the scan */
    for (int which = 0; which < 2; ++which) {
        fx_init(&f);
        start(&f);
        memset(f.world.cell, 0, sizeof f.world.cell);
        f.world.cell[1][3].type = 1;
        f.world.cell[2][1].type = 2;
        f.world.cell[which == 0 ? 1 : 2][which == 0 ? 3 : 1].piece = (int16_t)(which == 0 ? 1 : 2);
        f.world.cell[which == 0 ? 0 : 0][which == 0 ? 0 : 0].piece = (int16_t)(which == 0 ? 2 : 1);
        CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.solved == 0 && f.o.state == CPZ_STATE_IDLE);
    }
    /* the last cell of the grid is scanned too, and so is the last row and column of the body's grid, but not beyond */
    fx_init(&f);
    start(&f);
    memset(f.world.cell, 0, sizeof f.world.cell);
    f.world.cell[2][3].piece = 5;
    f.world.cell[2][3].type = 4;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.solved == 0);
    f.world.cell[2][3].type = 5;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.solved == 1);
    fx_init(&f);
    start(&f);
    memset(f.world.cell, 0, sizeof f.world.cell);
    f.world.cell[3][0].piece = 5; /* row 3 is outside the 3 rows: ignored */
    f.world.cell[0][4].piece = 5; /* column 4 is outside the 4 columns: ignored */
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.solved == 1);
    fx_init(&f);
    start(&f);
    memset(f.world.cell, 0, sizeof f.world.cell);
    f.world.cell[2][0].piece = 5;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.solved == 0);
    memset(f.world.cell, 0, sizeof f.world.cell);
    f.world.cell[0][3].piece = 5;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.solved == 0);
    /* without any piece the puzzle is solved at once (the scan finds nothing wrong) */
    fx_init(&f);
    put16(f.body, O_PIECES, 0);
    start(&f);
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.solved == 1 && f.o.state == CPZ_STATE_SOLVED);
    /* an object already solved goes to state SOLVED without a scan; the moved flag is cleared on every idle visit */
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    f.o.moved = 1;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.state == CPZ_STATE_SOLVED && f.o.moved == 0);
    CHECK_LOG(&f, "state:1:0");
    fx_init(&f);
    start(&f);
    f.o.moved = 1;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.moved == 0 && f.o.solved == 0);
}

static void t_state_delay_and_sound(void)
{
    Fx f;
    /* state 1: the deadline is the tick plus the delay in seconds; state 4 follows */
    fx_init(&f);
    start(&f);
    f.o.state = CPZ_STATE_SOLVED;
    f.o.solved = 1;
    f.now = 5000u;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.state == CPZ_STATE_WAIT_DELAY && f.o.deadline == 7000u);
    CHECK_LOG(&f, "tick:5000:0,state:4:0");
    put16(f.body, O_DELAY, 0);
    f.o.state = CPZ_STATE_SOLVED;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.deadline == 5000u);
    put16(f.body, O_DELAY, -3);
    f.o.state = CPZ_STATE_SOLVED;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.deadline == 2000u);
    put16(f.body, O_DELAY, 32767);
    f.o.state = CPZ_STATE_SOLVED;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.deadline == 5000u + 32767000u);
    f.now = 0xfffffff0u;
    put16(f.body, O_DELAY, 1);
    f.o.state = CPZ_STATE_SOLVED;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.deadline == (uint32_t)(0xfffffff0u + 1000u) && f.o.deadline == 0x3d8u);
    /* state 4: wait for the deadline; the comparison is unsigned and inclusive */
    fx_init(&f);
    start(&f);
    f.o.state = CPZ_STATE_WAIT_DELAY;
    f.o.deadline = 9000u;
    f.now = 8999u;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.state == CPZ_STATE_WAIT_DELAY && f.phase == 1u);
    CHECK_LOG(&f, "tick:8999:0");
    LOGCLR(&f);
    f.now = 9000u;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.state == CPZ_STATE_WAIT_SOUND && f.phase == 1u);
    CHECK_LOG(&f, "tick:9000:0,prep:765:0,play:14:0,state:3:0");
    CHECK(f.prepare_ptr == f.body + O_SD && f.played_channel == 14 && f.n_prepare == 4); /* three from phase 0, one now */
    fx_init(&f);
    start(&f);
    f.o.state = CPZ_STATE_WAIT_DELAY;
    f.o.deadline = 1u;
    f.now = 0x80000000u; /* unsigned: 0x80000000 >= 1 */
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.state == CPZ_STATE_WAIT_SOUND);
    fx_init(&f);
    start(&f);
    f.o.state = CPZ_STATE_WAIT_DELAY;
    f.o.deadline = 0x80000000u;
    f.now = 1u; /* 1 < 0x80000000 */
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.state == CPZ_STATE_WAIT_DELAY);
    /* state 4 with the final sound NO SOUND: straight to phase 2 */
    fx_init(&f);
    start(&f);
    set_nosound(f.body, O_SD);
    f.o.state = CPZ_STATE_WAIT_DELAY;
    f.o.deadline = 0u;
    f.now = 5u;
    f.n_prepare = 0;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.phase == 2u && f.o.state == CPZ_STATE_WAIT_DELAY && f.completed == 0);
    CHECK_LOG(&f, "tick:5:0,phase:2:0");
    CHECK(f.n_prepare == 0 && f.n_play == 0);
    /* state 3: wait while the channel is busy (any nonzero), then stop the sound and go to phase 2 */
    {
        const int32_t busy[] = {1, 2, -1, 0x10000};
        for (size_t i = 0; i < sizeof busy / sizeof busy[0]; ++i) {
            fx_init(&f);
            start(&f);
            f.o.state = CPZ_STATE_WAIT_SOUND;
            f.busy_value = busy[i];
            CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.phase == 1u && f.o.state == CPZ_STATE_WAIT_SOUND);
            CHECK_LOG(&f, i == 0 ? "busyq:14,busy:14:1" : (i == 1 ? "busyq:14,busy:14:2" : (i == 2 ? "busyq:14,busy:14:-1" : "busyq:14,busy:14:65536")));
            CHECK(f.n_stop == 0);
        }
    }
    fx_init(&f);
    start(&f);
    f.o.state = CPZ_STATE_WAIT_SOUND;
    f.busy_value = 0;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.phase == 2u && f.completed == 0 && f.o.state == CPZ_STATE_WAIT_SOUND);
    CHECK_LOG(&f, "busyq:14,busy:14:0,stop:765:0,phase:2:0");
    CHECK(f.stop_ptr == f.body + O_SD);
    /* an unknown state does nothing */
    for (int s = 5; s <= 8; ++s) {
        fx_init(&f);
        start(&f);
        f.o.state = s;
        CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.phase == 1u && f.log[0] == '\0' && f.o.state == s);
    }
    fx_init(&f);
    start(&f);
    f.o.state = -1;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.log[0] == '\0' && f.o.state == -1);
    /* a phase that is none of 0, 1, 2 does nothing */
    fx_init(&f);
    start(&f);
    CHECK(visit(&f, ROW, 3u) == CPZ_OK && f.phase == 3u && f.log[0] == '\0' && f.initialized == 0 && f.completed == 0);
    CHECK(visit(&f, ROW, 0xffffffffu) == CPZ_OK && f.phase == 0xffffffffu && f.log[0] == '\0');
}

/* ---- phase 2, the finish blocks ------------------------------------------------------------------------------------------- */

static void t_phase2_solved(void)
{
    Fx f;
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    f.world.start_flag_5bb1ca = 9;
    CHECK(visit(&f, ROW, 2u) == CPZ_OK && f.failure == NULL);
    CHECK_LOG(&f, "start:1:0,stop:591:0,stop:640:0,stop:689:0,tr:40:1:2:3:11:22:33,x57b:40:0,x599:1:0,x595:2:0,x39ff:3:0,x59b:11:0,x59f:22:0,x5a3:33:0,"
                  "start:0:0,mode:4:0,sf:7:3,evflag:7:3,complete:3:0,relsurf:77:0,relslot:24:0");
    CHECK(f.completed == 1 && f.phase == 0u && f.initialized == 0);
    CHECK(f.world.start_flag_5bb1ca == 0 && f.o.active == 0 && f.o.row == -1 && f.o.slot == -1 && f.o.surface == 0u);
    CHECK(f.o.solved == 0 && f.o.canceled == 0 && f.n_relsurf == 1 && f.relsurf_handle == 77u && f.n_relslot == 1);
    CHECK(f.relslot_seen == 24 && f.n_stop_hist == 3 && f.stop_hist[0] == O_SA && f.stop_hist[1] == O_SB && f.stop_hist[2] == O_SC);
    /* the transition request carries the signed words and dwords */
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    set_block(f.body, O_SOLV, -2, -1, 32767, -32768, -5, 0x7fffffff, (int32_t)0x80000000, 1, 7, 0xff);
    CHECK(visit(&f, ROW, 2u) == CPZ_OK);
    CHECK(strstr(f.log, "x57b:-2:0,x599:-1:0,x595:32767:0,x39ff:-32768:0,x59b:-5:0,x59f:2147483647:0,x5a3:-2147483648:0") != NULL);
    CHECK(strstr(f.log, "busyq") == NULL);
    /* the request itself (the host call, before the effects) */
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    CHECK(visit(&f, ROW, 2u) == CPZ_OK && strstr(f.log, "tr:40:1:2:3:11:22:33,x57b") != NULL);
    /* start word: 1 stores 0, any other stores 1 */
    {
        const int starts[] = {0, 2, -1, 0x100, 1};
        for (size_t i = 0; i < sizeof starts / sizeof starts[0]; ++i) {
            fx_init(&f);
            start(&f);
            f.o.solved = 1;
            put16(f.body, O_SOLV + 20, starts[i]);
            f.world.start_flag_5bb1ca = 5;
            CHECK(visit(&f, ROW, 2u) == CPZ_OK && f.world.start_flag_5bb1ca == (starts[i] == 1 ? 0 : 1));
            CHECK(strstr(f.log, starts[i] == 1 ? "x5a3:33:0,start:0:0,mode" : "x5a3:33:0,start:1:0,mode") != NULL);
        }
    }
    /* scene 9999: no scene change, no mode, no start flag write; the event flag is still stored */
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    put16(f.body, O_SOLV, 9999);
    f.world.start_flag_5bb1ca = 5;
    CHECK(visit(&f, ROW, 2u) == CPZ_OK && strstr(f.log, "tr:") == NULL && strstr(f.log, "x57b") == NULL && strstr(f.log, "mode") == NULL);
    CHECK(strstr(f.log, "stop:689:0,sf:7:3,evflag:7:3,complete:3:0") != NULL && f.world.start_flag_5bb1ca == 1);
    /* event flag -1: none; 0 is a flag; the value is a byte */
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    put16(f.body, O_SOLV + 22, -1);
    CHECK(visit(&f, ROW, 2u) == CPZ_OK && strstr(f.log, "evflag") == NULL && strstr(f.log, "sf:") == NULL && strstr(f.log, "mode:4:0,complete") != NULL);
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    put16(f.body, O_SOLV + 22, 0);
    f.body[O_SOLV + 24] = 0xfe;
    CHECK(visit(&f, ROW, 2u) == CPZ_OK && strstr(f.log, "sf:0:254,evflag:0:254,complete") != NULL);
    /* both none: only the sound stops, the completion and the cleanup */
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    put16(f.body, O_SOLV, 9999);
    put16(f.body, O_SOLV + 22, -1);
    CHECK(visit(&f, ROW, 2u) == CPZ_OK);
    CHECK_LOG(&f, "start:1:0,stop:591:0,stop:640:0,stop:689:0,complete:3:0,relsurf:77:0,relslot:24:0");
    /* stops: NO SOUND records are skipped, each on its own */
    fx_init(&f);
    start(&f);
    set_nosound(f.body, O_SA);
    f.o.solved = 1;
    put16(f.body, O_SOLV, 9999);
    put16(f.body, O_SOLV + 22, -1);
    CHECK(visit(&f, ROW, 2u) == CPZ_OK && strstr(f.log, "start:1:0,stop:640:0,stop:689:0,complete") != NULL && f.n_stop == 2);
    fx_init(&f);
    start(&f);
    set_nosound(f.body, O_SB);
    f.o.solved = 1;
    put16(f.body, O_SOLV, 9999);
    put16(f.body, O_SOLV + 22, -1);
    CHECK(visit(&f, ROW, 2u) == CPZ_OK && strstr(f.log, "start:1:0,stop:591:0,stop:689:0,complete") != NULL && f.n_stop == 2);
    fx_init(&f);
    start(&f);
    set_nosound(f.body, O_SC);
    f.o.solved = 1;
    put16(f.body, O_SOLV, 9999);
    put16(f.body, O_SOLV + 22, -1);
    CHECK(visit(&f, ROW, 2u) == CPZ_OK && strstr(f.log, "start:1:0,stop:591:0,stop:640:0,complete") != NULL && f.n_stop == 2);
    /* the sound D is not stopped by phase 2 (state 3 stopped it) */
    CHECK(f.stop_ptr == f.body + O_SB);
}

static void t_phase2_cancel(void)
{
    Fx f;
    /* canceled: the cancel block, whatever the solved flag says */
    for (int solved = 0; solved <= 1; ++solved) {
        fx_init(&f);
        start(&f);
        f.o.canceled = 1;
        f.o.solved = solved;
        CHECK(visit(&f, ROW, 2u) == CPZ_OK);
        CHECK_LOG(&f, "start:1:0,stop:591:0,stop:640:0,stop:689:0,tr:50:4:5:6:44:55:66,x57b:50:0,x599:4:0,x595:5:0,x39ff:6:0,x59b:44:0,x59f:55:0,x5a3:66:0,"
                      "start:1:0,mode:4:0,sf:8:9,evflag:8:9,complete:3:0,relsurf:77:0,relslot:24:0");
        CHECK(strstr(f.log, "tr:50:4:5:6:44:55:66") != NULL && strstr(f.log, "sf:8:9") != NULL && strstr(f.log, "tr:40") == NULL);
        CHECK(f.completed == 1 && f.phase == 0u && f.world.start_flag_5bb1ca == 1 && f.o.active == 0);
    }
    /* neither canceled nor solved (the executor can reach phase 2 this way): no block, completion and cleanup only */
    fx_init(&f);
    start(&f);
    CHECK(visit(&f, ROW, 2u) == CPZ_OK);
    CHECK_LOG(&f, "start:1:0,stop:591:0,stop:640:0,stop:689:0,complete:3:0,relsurf:77:0,relslot:24:0");
    /* cancel block with scene 9999 and the start word 1 */
    fx_init(&f);
    start(&f);
    f.o.canceled = 1;
    put16(f.body, O_CANC, 9999);
    put16(f.body, O_CANC + 22, -1);
    put16(f.body, O_CANC + 20, 1);
    f.world.start_flag_5bb1ca = 0;
    CHECK(visit(&f, ROW, 2u) == CPZ_OK && strstr(f.log, "x57b") == NULL && strstr(f.log, "evflag") == NULL && f.world.start_flag_5bb1ca == 1);
    fx_init(&f);
    start(&f);
    f.o.canceled = 1;
    put16(f.body, O_CANC + 20, 1);
    CHECK(visit(&f, ROW, 2u) == CPZ_OK && strstr(f.log, "x5a3:66:0,start:0:0,mode:4:0") != NULL && f.world.start_flag_5bb1ca == 0);
}

static void t_phase2_flag_refused(void)
{
    Fx f;
    /* a flag index outside the host's window is refused before any effect (native refusal) and the object stays in phase 2 */
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    f.flag_limit = 7; /* flag 7 is outside 0..6 */
    CHECK(visit(&f, ROW, 2u) == CPZ_ERR_BOUNDS && strcmp(f.failure, "0xd3-event-flag-index") == 0);
    CHECK(f.log[0] == '\0' && f.completed == 0 && f.phase == 2u && f.o.active == 1 && f.o.slot == 24 && f.world.start_flag_5bb1ca == 1);
    f.flag_limit = 8; /* 7 is the last valid index */
    CHECK(visit(&f, ROW, 2u) == CPZ_OK && f.completed == 1);
    /* the canceled object is checked against the cancel block's flag, the solved object against the solved block's */
    fx_init(&f);
    start(&f);
    f.o.canceled = 1;
    f.o.solved = 1;
    f.flag_limit = 8; /* the solved flag (7) is valid; the cancel flag (8) is not */
    CHECK(visit(&f, ROW, 2u) == CPZ_ERR_BOUNDS && f.log[0] == '\0');
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    f.flag_limit = 8;
    put16(f.body, O_CANC + 22, 99); /* the cancel block is not used */
    CHECK(visit(&f, ROW, 2u) == CPZ_OK);
    /* flag -1 needs no host check even when the window is empty */
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    f.flag_limit = 0;
    put16(f.body, O_SOLV + 22, -1);
    CHECK(visit(&f, ROW, 2u) == CPZ_OK && f.completed == 1);
    /* a negative flag other than -1 is refused by the host window */
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    put16(f.body, O_SOLV + 22, -2);
    CHECK(visit(&f, ROW, 2u) == CPZ_ERR_BOUNDS && f.log[0] == '\0');
    /* neither solved nor canceled: no check, whatever the blocks say */
    fx_init(&f);
    start(&f);
    put16(f.body, O_SOLV + 22, 5000);
    put16(f.body, O_CANC + 22, 5000);
    CHECK(visit(&f, ROW, 2u) == CPZ_OK && f.completed == 1);
}

/* ---- arguments, phases without phase 0 ------------------------------------------------------------------------------------- */

static void t_step_args(void)
{
    Fx f;
    CpzResult r;
    const char *why = NULL;
    fx_init(&f);
    CHECK(cpz_step(NULL, f.body, CPZ_BODY_BYTES, ROW, 0u, &f.world, &f.host, &r, &why) == CPZ_ERR_ARGUMENT && strcmp(why, "0xd3-argument") == 0);
    CHECK(cpz_step(&f.o, NULL, CPZ_BODY_BYTES, ROW, 0u, &f.world, &f.host, &r, &why) == CPZ_ERR_ARGUMENT);
    CHECK(cpz_step(&f.o, f.body, CPZ_BODY_BYTES, ROW, 0u, NULL, &f.host, &r, &why) == CPZ_ERR_ARGUMENT);
    CHECK(cpz_step(&f.o, f.body, CPZ_BODY_BYTES, ROW, 0u, &f.world, NULL, &r, &why) == CPZ_ERR_ARGUMENT);
    CHECK(cpz_step(&f.o, f.body, CPZ_BODY_BYTES, ROW, 0u, &f.world, &f.host, NULL, &why) == CPZ_ERR_ARGUMENT);
    CHECK(cpz_step(&f.o, f.body, CPZ_BODY_BYTES, ROW, 0u, &f.world, &f.host, &r, NULL) == CPZ_OK);
    /* every host callback is required (the observer is optional) */
    {
        CpzHost h = f.host;
        void **slots[17];
        int n = 0;
        slots[n++] = (void **)&h.alloc_slot;
        slots[n++] = (void **)&h.register_slot;
        slots[n++] = (void **)&h.load_surface;
        slots[n++] = (void **)&h.set_slot_surface;
        slots[n++] = (void **)&h.release_surface;
        slots[n++] = (void **)&h.release_slot;
        slots[n++] = (void **)&h.mark_dirty;
        slots[n++] = (void **)&h.view_origin;
        slots[n++] = (void **)&h.clear_pending_item;
        slots[n++] = (void **)&h.sound_prepare;
        slots[n++] = (void **)&h.sound_stop;
        slots[n++] = (void **)&h.sound_play;
        slots[n++] = (void **)&h.sound_busy;
        slots[n++] = (void **)&h.tick;
        slots[n++] = (void **)&h.event_flag_invalid;
        slots[n++] = (void **)&h.transition;
        slots[n++] = (void **)&h.store_event_flag;
        for (int i = 0; i < n; ++i) {
            void *saved = *slots[i];
            Fx g;
            CpzClickResult c;
            CpzRenderResult *rr = (CpzRenderResult *)malloc(sizeof *rr);
            fx_init(&g);
            *slots[i] = NULL;
            CHECK(cpz_step(&g.o, g.body, CPZ_BODY_BYTES, ROW, 0u, &g.world, &h, &r, &why) == CPZ_ERR_ARGUMENT);
            CHECK(cpz_click(&g.o, g.body, CPZ_BODY_BYTES, 1u, 0x277f, 1, &h, &c) == CPZ_ERR_ARGUMENT);
            if (rr != NULL) {
                CHECK(cpz_render(&g.o, &g.world, g.body, CPZ_BODY_BYTES, &h, rr) == CPZ_ERR_ARGUMENT);
                free(rr);
            }
            *slots[i] = saved;
        }
    }
    /* a bad body is refused before any effect, in every phase */
    fx_init(&f);
    f.body[O_STEPS] = 0;
    f.body[O_STEPS + 1] = 0;
    for (uint32_t ph = 0; ph <= 3; ++ph) {
        CHECK(visit(&f, ROW, ph) == CPZ_ERR_BODY && strcmp(f.failure, "0xd3-animation-steps") == 0 && f.log[0] == '\0');
        CHECK(f.phase == ph && f.initialized == 0 && f.completed == 0 && f.o.active == 0);
    }
    CHECK(cpz_step(&f.o, f.body, CPZ_BODY_BYTES - 1u, ROW, 0u, &f.world, &f.host, &r, &why) == CPZ_ERR_BODY && strcmp(why, "0xd3-body-length") == 0);
    /* phases 1 and 2 need phase 0 of the same row */
    fx_init(&f);
    CHECK(visit(&f, ROW, 1u) == CPZ_ERR_UNSUPPORTED && strcmp(f.failure, "0xd3-phase-1-without-init") == 0 && f.log[0] == '\0' && f.phase == 1u);
    CHECK(visit(&f, ROW, 2u) == CPZ_ERR_UNSUPPORTED && strcmp(f.failure, "0xd3-phase-2-without-init") == 0 && f.log[0] == '\0' && f.phase == 2u);
    start(&f);
    CHECK(visit(&f, ROW + 1, 1u) == CPZ_ERR_UNSUPPORTED && strcmp(f.failure, "0xd3-phase-1-without-init") == 0 && f.log[0] == '\0');
    CHECK(visit(&f, ROW + 1, 2u) == CPZ_ERR_UNSUPPORTED && strcmp(f.failure, "0xd3-phase-2-without-init") == 0 && f.log[0] == '\0');
    CHECK(f.o.active == 1 && f.o.row == ROW && f.o.slot == 24);
    /* an inactive object with the right row number */
    f.o.active = 0;
    CHECK(visit(&f, ROW, 1u) == CPZ_ERR_UNSUPPORTED);
    CHECK(visit(&f, ROW, 2u) == CPZ_ERR_UNSUPPORTED);
    /* any other phase needs no init and does nothing */
    fx_init(&f);
    CHECK(visit(&f, ROW, 7u) == CPZ_OK && f.phase == 7u && f.log[0] == '\0');
    /* the second phase-0 visit allocates a new entry (the original does the same: the cleanup precedes it) */
    fx_init(&f);
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && visit(&f, ROW, 0u) == CPZ_OK && f.o.slot == 25);
}

/* ---- click ---------------------------------------------------------------------------------------------------------------- */

static void t_click(void)
{
    Fx f;
    CpzClickResult c;
    fx_init(&f);
    /* inactive: nothing */
    memset(&c, 0x55, sizeof c);
    CHECK(click(&f, 1u, 0x277f, 1, &c) == CPZ_OK && c.cancel_asked == 0u && c.move_started == 0u && c.sound_played == 0u && c.new_phase == 1u);
    CHECK(f.o.canceled == 0);
    start(&f);
    /* the cancel candidate: canceled := 1, row phase := 2 */
    memset(&c, 0x55, sizeof c);
    CHECK(click(&f, 1u, 0x277f, 0, &c) == CPZ_OK && c.cancel_asked == 1u && c.move_started == 0u && c.sound_played == 0u && c.new_phase == 2u);
    CHECK(f.o.canceled == 1 && f.o.state == CPZ_STATE_IDLE);
    CHECK_LOG(&f, "phase:2:0");
    LOGCLR(&f);
    f.o.canceled = 0;
    /* a cancel with a direction pending cancels (it is checked first) and plays nothing */
    f.o.dir = 0x12;
    CHECK(click(&f, 1u, 0x277f, 1, &c) == CPZ_OK && c.cancel_asked == 1u && c.move_started == 0u && f.o.state == CPZ_STATE_IDLE);
    CHECK(f.n_play == 0);
    f.o.canceled = 0;
    LOGCLR(&f);
    /* no pending direction and a non-cancel candidate: nothing */
    f.o.dir = 0;
    for (int cand = -1; cand <= 0x2783; cand += 0x2784 / 7 + 1) {
        if (cand == 0x277f) continue;
        CHECK(click(&f, 1u, cand, 1, &c) == CPZ_OK && c.cancel_asked == 0u && c.move_started == 0u && c.new_phase == 1u && f.o.state == 0);
    }
    CHECK(f.log[0] == '\0' && f.n_play == 0);
    /* a pending direction starts the slide and plays sound A on channel 11 when the process flag is nonzero */
    f.o.dir = 0x13;
    f.o.piece = 1;
    CHECK(click(&f, 1u, 0x2783, 1, &c) == CPZ_OK && c.cancel_asked == 0u && c.move_started == 1u && c.sound_played == 1u && c.new_phase == 1u);
    CHECK(f.o.state == CPZ_STATE_MOVING && f.o.canceled == 0);
    CHECK_LOG(&f, "state:2:0,play:11:0");
    CHECK(f.played_channel == 11);
    /* the candidate is not looked at for a move, only the direction */
    fx_init(&f);
    start(&f);
    f.o.dir = 0x10;
    CHECK(click(&f, 1u, 0x1234, 0, &c) == CPZ_OK && c.move_started == 1u && c.sound_played == 0u && f.o.state == CPZ_STATE_MOVING);
    CHECK_LOG(&f, "state:2:0");
    /* the process flag: any nonzero value counts; zero is silent */
    {
        const int32_t flags[] = {0, 1, 2, -1, 0x10000};
        for (size_t i = 0; i < sizeof flags / sizeof flags[0]; ++i) {
            fx_init(&f);
            start(&f);
            f.o.dir = 0x11;
            CHECK(click(&f, 1u, 0x2781, flags[i], &c) == CPZ_OK && c.move_started == 1u && c.sound_played == (flags[i] != 0));
            CHECK(f.n_play == (flags[i] != 0));
        }
    }
    /* sound A NO SOUND: silent */
    fx_init(&f);
    start(&f);
    set_nosound(f.body, O_SA);
    f.o.dir = 0x11;
    CHECK(click(&f, 1u, 0x2781, 1, &c) == CPZ_OK && c.move_started == 1u && c.sound_played == 0u && f.n_play == 0);
    /* the guards: solved, not idle, row phase other than 1 */
    for (int g = 0; g < 7; ++g) {
        fx_init(&f);
        start(&f);
        f.o.dir = 0x11;
        switch (g) {
        case 0: f.o.solved = 1; break;
        case 1: f.o.state = CPZ_STATE_SOLVED; break;
        case 2: f.o.state = CPZ_STATE_MOVING; break;
        case 3: f.o.state = CPZ_STATE_WAIT_SOUND; break;
        case 4: f.o.state = CPZ_STATE_WAIT_DELAY; break;
        case 5: break;
        default: break;
        }
        memset(&c, 0x55, sizeof c);
        CHECK(click(&f, g == 5 ? 0u : (g == 6 ? 2u : 1u), g >= 5 ? 0x277f : 0x2781, 1, &c) == CPZ_OK);
        CHECK(c.cancel_asked == 0u && c.move_started == 0u && c.sound_played == 0u && f.o.canceled == 0);
        CHECK(c.new_phase == (g == 5 ? 0u : (g == 6 ? 2u : 1u)) && f.log[0] == '\0' && f.n_play == 0);
        CHECK(f.o.state == (g == 0 || g >= 5 ? 0 : (g == 1 ? 1 : (g == 2 ? 2 : (g == 3 ? 3 : 4)))));
    }
    /* guards with the cancel candidate too */
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    CHECK(click(&f, 1u, 0x277f, 1, &c) == CPZ_OK && c.cancel_asked == 0u && f.o.canceled == 0);
    f.o.solved = 0;
    f.o.state = CPZ_STATE_MOVING;
    CHECK(click(&f, 1u, 0x277f, 1, &c) == CPZ_OK && c.cancel_asked == 0u && f.o.canceled == 0);
    f.o.state = CPZ_STATE_IDLE;
    CHECK(click(&f, 3u, 0x277f, 1, &c) == CPZ_OK && c.cancel_asked == 0u && c.new_phase == 3u && f.o.canceled == 0);
    /* arguments */
    CHECK(cpz_click(NULL, f.body, CPZ_BODY_BYTES, 1u, 0, 0, &f.host, &c) == CPZ_ERR_ARGUMENT);
    CHECK(cpz_click(&f.o, NULL, CPZ_BODY_BYTES, 1u, 0, 0, &f.host, &c) == CPZ_ERR_ARGUMENT);
    CHECK(cpz_click(&f.o, f.body, CPZ_BODY_BYTES, 1u, 0, 0, NULL, &c) == CPZ_ERR_ARGUMENT);
    CHECK(cpz_click(&f.o, f.body, CPZ_BODY_BYTES, 1u, 0, 0, &f.host, NULL) == CPZ_ERR_ARGUMENT);
    CHECK(cpz_click(&f.o, f.body, CPZ_BODY_BYTES - 1u, 1u, 0, 0, &f.host, &c) == CPZ_ERR_ARGUMENT);
    /* a failing sound: the state change precedes it (the original has no recovery) */
    fx_init(&f);
    start(&f);
    f.o.dir = 0x11;
    f.fail_call = f.calls + 1;
    CHECK(click(&f, 1u, 0x2781, 1, &c) == CPZ_ERR_HOST && f.failed_cb == CB_PLAY && f.o.state == CPZ_STATE_MOVING);
}

static void t_invalidate_cleanup(void)
{
    Fx f;
    fx_init(&f);
    /* invalidate: only an active object with a slot marks it */
    CHECK(cpz_invalidate(&f.o, &f.host) == CPZ_OK && f.n_dirty == 0);
    start(&f);
    CHECK(cpz_invalidate(&f.o, &f.host) == CPZ_OK && f.n_dirty == 1 && f.dirty_slot == 24);
    f.o.active = 0;
    CHECK(cpz_invalidate(&f.o, &f.host) == CPZ_OK && f.n_dirty == 1);
    f.o.active = 1;
    f.o.slot = CPZ_NO_SLOT;
    CHECK(cpz_invalidate(&f.o, &f.host) == CPZ_OK && f.n_dirty == 1);
    CHECK(cpz_invalidate(NULL, &f.host) == CPZ_ERR_ARGUMENT && cpz_invalidate(&f.o, NULL) == CPZ_ERR_ARGUMENT);
    {
        CpzHost h = f.host;
        h.mark_dirty = NULL;
        CHECK(cpz_invalidate(&f.o, &h) == CPZ_ERR_ARGUMENT);
    }
    /* cleanup: releases the surface and the slot, then resets */
    fx_init(&f);
    start(&f);
    f.o.canceled = 1;
    f.o.solved = 1;
    CHECK(cpz_cleanup(&f.o, &f.host) == CPZ_OK);
    CHECK_LOG(&f, "relsurf:77:0,relslot:24:0");
    CHECK(f.o.surface == 0u && f.o.slot == -1 && f.o.row == -1 && f.o.active == 0 && f.o.canceled == 0 && f.o.solved == 0);
    CHECK(f.relsurf_handle == 77u && f.relslot_seen == 24);
    /* a second cleanup on the reset object does nothing */
    LOGCLR(&f);
    CHECK(cpz_cleanup(&f.o, &f.host) == CPZ_OK && f.log[0] == '\0' && f.n_relsurf == 1 && f.n_relslot == 1);
    /* a slot without a surface and a surface without a slot */
    fx_init(&f);
    start(&f);
    f.o.surface = 0u;
    CHECK(cpz_cleanup(&f.o, &f.host) == CPZ_OK);
    CHECK_LOG(&f, "relslot:24:0");
    fx_init(&f);
    start(&f);
    f.o.slot = CPZ_NO_SLOT;
    CHECK(cpz_cleanup(&f.o, &f.host) == CPZ_OK);
    CHECK_LOG(&f, "relsurf:77:0");
    /* the other fields (state, piece, ...) are not part of the reset 0x461827 */
    fx_init(&f);
    start(&f);
    f.o.state = 3;
    f.o.piece = 4;
    f.o.dir = 0x12;
    CHECK(cpz_cleanup(&f.o, &f.host) == CPZ_OK && f.o.state == 3 && f.o.piece == 4 && f.o.dir == 0x12);
    /* a failing surface release keeps the surface; a failing slot release keeps the slot */
    fx_init(&f);
    start(&f);
    f.fail_call = f.calls + 1;
    CHECK(cpz_cleanup(&f.o, &f.host) == CPZ_ERR_HOST && f.o.surface == 77u && f.o.slot == 24 && f.o.active == 1);
    fx_init(&f);
    start(&f);
    f.fail_call = f.calls + 2;
    CHECK(cpz_cleanup(&f.o, &f.host) == CPZ_ERR_HOST && f.o.surface == 0u && f.o.slot == 24 && f.o.active == 1);
    CHECK(cpz_cleanup(NULL, &f.host) == CPZ_ERR_ARGUMENT && cpz_cleanup(&f.o, NULL) == CPZ_ERR_ARGUMENT);
    {
        CpzHost h = f.host;
        h.release_surface = NULL;
        CHECK(cpz_cleanup(&f.o, &h) == CPZ_ERR_ARGUMENT);
        h = f.host;
        h.release_slot = NULL;
        CHECK(cpz_cleanup(&f.o, &h) == CPZ_ERR_ARGUMENT);
    }
}

/* ---- render --------------------------------------------------------------------------------------------------------------- */

static int blit_is(const CpzBlit *b, int kind, int piece, uint32_t surface, const uint8_t *body, size_t src, const int32_t dst[4])
{
    return b->kind == kind && b->piece == piece && b->src_surface == surface && b->src[0] == rd32(body, src) &&
           b->src[1] == rd32(body, src + 4) && b->src[2] == rd32(body, src + 8) && b->src[3] == rd32(body, src + 12) &&
           rect_eq(b->dst, dst);
}

static void t_render_basics(void)
{
    Fx f;
    static CpzRenderResult r;
    int32_t d[4];
    fx_init(&f);
    /* no slot: nothing */
    memset(&r, 0x55, sizeof r);
    CHECK(render(&f, &r) == CPZ_OK && r.valid == 0u && r.count == 0u);
    start(&f);
    memset(&r, 0x55, sizeof r);
    CHECK(render(&f, &r) == CPZ_OK && r.valid == 1u && r.count == 3u);
    /* the cells are drawn row by row: (0,1) piece 2, (1,0) piece 1, (1,3) the target of piece 1; (2,1) has an empty overlay */
    crect(&f, 0, 1, d);
    CHECK(blit_is(&r.blit[0], CPZ_BLIT_PIECE, 2, 77u, f.body, O_PSRC + 16, d));
    crect(&f, 1, 0, d);
    CHECK(blit_is(&r.blit[1], CPZ_BLIT_PIECE, 1, 77u, f.body, O_PSRC, d));
    crect(&f, 1, 3, d);
    CHECK(blit_is(&r.blit[2], CPZ_BLIT_TARGET, 0, 77u, f.body, O_TSRC, d));
    CHECK(strstr(f.log, "blit:6:2,blit:6:1,blit:1:0") != NULL);
    /* the surface of the blits is the object's */
    f.o.surface = 99u;
    CHECK(render(&f, &r) == CPZ_OK && r.blit[0].src_surface == 99u && r.blit[2].src_surface == 99u);
    f.o.surface = 77u;
    /* the render changes nothing */
    {
        CpzObject o = f.o;
        CpzWorld w = f.world;
        CHECK(render(&f, &r) == CPZ_OK && memcmp(&o, &f.o, sizeof o) == 0 && memcmp(&w, &f.world, sizeof w) == 0);
    }
    /* a render entry in slot 0 is still an entry (only -1 means none) */
    f.o.slot = 0;
    CHECK(render(&f, &r) == CPZ_OK && r.valid == 1u && r.count == 3u);
    f.o.slot = 24;
    /* an overlay is drawn at the base rectangle, not at the rectangle of a piece standing there */
    f.world.cell[1][3].rect[0] += 3;
    f.world.cell[1][3].rect[2] += 3;
    CHECK(render(&f, &r) == CPZ_OK && r.blit[2].kind == CPZ_BLIT_TARGET && rect_eq(r.blit[2].dst, f.world.cell[1][3].base) &&
          !rect_eq(r.blit[2].dst, f.world.cell[1][3].rect));
    f.world.cell[1][3].rect[0] -= 3;
    f.world.cell[1][3].rect[2] -= 3;
    /* a piece draws its current (moving) rectangle, not the cell's */
    f.world.cell[1][0].rect[0] += 5;
    f.world.cell[1][0].rect[2] += 5;
    CHECK(render(&f, &r) == CPZ_OK && r.blit[1].dst[0] == f.world.cell[1][0].rect[0] && r.blit[1].dst[2] == f.world.cell[1][0].rect[2]);
    /* invisible cells are skipped even when they hold a type or piece */
    f.world.cell[1][0].visible = 0;
    f.world.cell[1][3].visible = 0;
    CHECK(render(&f, &r) == CPZ_OK && r.count == 1u && r.blit[0].piece == 2);
    /* the rows and columns are those of the body; the view origin is read once per render */
    f.world.cell[2][3].visible = 1;
    f.world.cell[2][3].type = 5;
    f.world.cell[3][0].visible = 1;
    f.world.cell[3][0].type = 5;
    f.world.cell[0][4].visible = 1;
    f.world.cell[0][4].type = 5;
    f.n_origin = 0;
    CHECK(render(&f, &r) == CPZ_OK && r.count == 2u && r.blit[1].kind == CPZ_BLIT_TARGET && f.n_origin == 1);
    /* arguments and refusals */
    CHECK(cpz_render(NULL, &f.world, f.body, CPZ_BODY_BYTES, &f.host, &r) == CPZ_ERR_ARGUMENT);
    CHECK(cpz_render(&f.o, NULL, f.body, CPZ_BODY_BYTES, &f.host, &r) == CPZ_ERR_ARGUMENT);
    CHECK(cpz_render(&f.o, &f.world, NULL, CPZ_BODY_BYTES, &f.host, &r) == CPZ_ERR_ARGUMENT);
    CHECK(cpz_render(&f.o, &f.world, f.body, CPZ_BODY_BYTES, NULL, &r) == CPZ_ERR_ARGUMENT);
    CHECK(cpz_render(&f.o, &f.world, f.body, CPZ_BODY_BYTES, &f.host, NULL) == CPZ_ERR_ARGUMENT);
    CHECK(cpz_render(&f.o, &f.world, f.body, CPZ_BODY_BYTES - 1u, &f.host, &r) == CPZ_ERR_ARGUMENT);
}

/* All ten targets, the arrows, the wall and ten pieces in one 2 x 8 grid. */
static void t_render_kinds(void)
{
    Fx f;
    static CpzRenderResult r;
    size_t n = 0;
    fx_init(&f);
    put16(f.body, O_ROWS, 2);
    put16(f.body, O_COLS, 8);
    put16(f.body, O_PIECES, 10);
    for (int t = 0; t < 10; ++t) put_rect(f.body, (size_t)(O_TSRC + 16 * t), 2000 + 50 * t, 5, 2030 + 50 * t, 26);
    for (int i = 0; i < 16; ++i) set_type(f.body, i / 8, i % 8, 0);
    for (int i = 0; i < 10; ++i) {
        set_type(f.body, i / 8, i % 8, i + 1);
        set_piece(f.body, i, i / 8, i % 8);
    }
    set_type(f.body, 1, 2, 0x10);
    set_type(f.body, 1, 3, 0x11);
    set_type(f.body, 1, 4, 0x12);
    set_type(f.body, 1, 5, 0x13);
    set_type(f.body, 1, 6, 0x14);
    start(&f);
    CHECK(render(&f, &r) == CPZ_OK && r.valid == 1u && r.count == 10u + 10u + 5u);
    for (int i = 0; i < 10; ++i) {
        int32_t d[4];
        const int a = i / 8, b = i % 8;
        crect(&f, a, b, d);
        CHECK(blit_is(&r.blit[n++], CPZ_BLIT_TARGET, 0, 77u, f.body, (size_t)(O_TSRC + 16 * i), d));
        CHECK(blit_is(&r.blit[n++], CPZ_BLIT_PIECE, i + 1, 77u, f.body, (size_t)(O_PSRC + 16 * i), d));
        if (i == 7) {
            /* row 1 starts after the 8th cell: the first two cells hold targets 9 and 10 */
        }
    }
    /* cells 10..14 of the grid are the five overlays of row 1 columns 2..6 */
    {
        int32_t d[4];
        brect(&f, 1, 2, 0x10, d);
        CHECK(blit_is(&r.blit[n++], CPZ_BLIT_ARROW_H, 0, 77u, f.body, O_AH, d));
        brect(&f, 1, 3, 0x11, d);
        CHECK(blit_is(&r.blit[n++], CPZ_BLIT_ARROW_V, 0, 77u, f.body, O_AV, d));
        brect(&f, 1, 4, 0x12, d);
        CHECK(blit_is(&r.blit[n++], CPZ_BLIT_ARROW_V, 0, 77u, f.body, O_AV, d));
        brect(&f, 1, 5, 0x13, d);
        CHECK(blit_is(&r.blit[n++], CPZ_BLIT_ARROW_H, 0, 77u, f.body, O_AH, d));
        brect(&f, 1, 6, 0x14, d);
        CHECK(blit_is(&r.blit[n++], CPZ_BLIT_WALL, 0, 77u, f.body, O_WALL, d));
    }
    CHECK(n == 25u);
    /* an empty wall source (right == left) is not drawn; neither is an empty target source; unknown types never */
    fx_init(&f);
    put16(f.body, O_ROWS, 1);
    put16(f.body, O_COLS, 6);
    put16(f.body, O_PIECES, 0);
    put_rect(f.body, O_WALL, 3200, 0, 3200, 21);
    put_rect(f.body, O_TSRC + 16 * 3, 2150, 5, 2150, 26);
    set_type(f.body, 0, 0, 0x14);
    set_type(f.body, 0, 1, 4);
    set_type(f.body, 0, 2, 0x15);
    set_type(f.body, 0, 3, 0x0f);
    set_type(f.body, 0, 4, 11);
    set_type(f.body, 0, 5, 3);
    start(&f);
    CHECK(render(&f, &r) == CPZ_OK && r.count == 1u && r.blit[0].kind == CPZ_BLIT_TARGET && r.blit[0].src[0] == 2100);
    /* a wall source that differs only in the right edge is drawn */
    put_rect(f.body, O_WALL, 3200, 0, 3201, 21);
    CHECK(render(&f, &r) == CPZ_OK && r.count == 2u && r.blit[0].kind == CPZ_BLIT_WALL);
    /* the arrow sources need no emptiness check */
    put_rect(f.body, O_AH, 5, 5, 5, 5);
    set_type(f.body, 0, 2, 0x10);
    f.world.cell[0][2].type = 0x10;
    f.world.cell[0][2].visible = 1;
    CHECK(render(&f, &r) == CPZ_OK && r.count == 3u && r.blit[1].kind == CPZ_BLIT_ARROW_H && r.blit[1].src[0] == 5);
}

static void t_render_restore(void)
{
    Fx f;
    static CpzRenderResult r;
    int32_t d[4];
    fx_init(&f);
    begin_slide(&f, 1, 1, 0x13, 4);
    CHECK(visit(&f, ROW, 1u) == CPZ_OK); /* one step: saved = the cell rectangle */
    f.vx = 20;
    f.vy = 30; /* the restore subtracts the view origin of the render time */
    CHECK(render(&f, &r) == CPZ_OK && r.valid == 1u && r.count == 2u);
    CHECK(r.blit[0].kind == CPZ_BLIT_RESTORE && r.blit[0].piece == 1 && r.blit[0].src_surface == 0u);
    CHECK(rect_eq(r.blit[0].dst, f.o.saved));
    CHECK(r.blit[0].src[0] == f.o.saved[0] - 20 && r.blit[0].src[1] == f.o.saved[1] - 30 && r.blit[0].src[2] == f.o.saved[2] - 20 &&
          r.blit[0].src[3] == f.o.saved[3] - 30);
    CHECK(blit_is(&r.blit[1], CPZ_BLIT_PIECE, 1, 77u, f.body, O_PSRC, f.world.cell[1][1].rect));
    CHECK(strstr(f.log, "blit:5:1,blit:6:1") != NULL);
    /* only the moving piece's cell restores: piece 2 elsewhere draws no restore */
    put16(f.body, O_PIECES, 2);
    f.world.cell[0][0].piece = 2;
    f.world.cell[0][0].visible = 1;
    CHECK(render(&f, &r) == CPZ_OK && r.count == 3u && r.blit[0].kind == CPZ_BLIT_PIECE && r.blit[0].piece == 2);
    CHECK(r.blit[1].kind == CPZ_BLIT_RESTORE && r.blit[2].kind == CPZ_BLIT_PIECE && r.blit[2].piece == 1);
    /* the moving piece is the one the pointer chose (obj piece), so a different number restores nothing */
    f.o.piece = 2;
    CHECK(render(&f, &r) == CPZ_OK && r.count == 3u && r.blit[0].kind == CPZ_BLIT_RESTORE && r.blit[0].piece == 2);
    f.o.piece = 7;
    CHECK(render(&f, &r) == CPZ_OK && r.count == 2u);
    f.o.piece = 1;
    /* the restore comes before the overlay of the same cell? no: after it, before the piece */
    f.world.cell[1][1].type = 0x14;
    CHECK(render(&f, &r) == CPZ_OK && r.count == 4u && r.blit[0].kind == CPZ_BLIT_PIECE);
    brect(&f, 1, 1, 0x14, d);
    CHECK(r.blit[1].kind == CPZ_BLIT_WALL && r.blit[2].kind == CPZ_BLIT_RESTORE && r.blit[3].kind == CPZ_BLIT_PIECE);
    /* the overlay is drawn at the base rectangle while the piece's own rectangle has moved on */
    CHECK(rect_eq(r.blit[1].dst, f.world.cell[1][1].base) && !rect_eq(r.blit[1].dst, f.world.cell[1][1].rect));
    f.world.cell[1][1].type = 1;
    CHECK(render(&f, &r) == CPZ_OK && r.count == 4u && r.blit[1].kind == CPZ_BLIT_TARGET && rect_eq(r.blit[1].dst, f.world.cell[1][1].base) &&
          !rect_eq(r.blit[1].dst, f.world.cell[1][1].rect));
    f.world.cell[1][1].type = 0;
    /* idle: restores only on the tick after a finished move (moved == 1) */
    f.o.state = CPZ_STATE_IDLE;
    f.o.moved = 0;
    CHECK(render(&f, &r) == CPZ_OK && r.count == 2u && r.blit[0].kind == CPZ_BLIT_PIECE);
    f.o.moved = 1;
    CHECK(render(&f, &r) == CPZ_OK && r.count == 3u && r.blit[1].kind == CPZ_BLIT_RESTORE);
    /* other states do not restore either */
    for (int s = 1; s <= 4; ++s) {
        if (s == CPZ_STATE_MOVING) continue;
        f.o.state = s;
        f.o.moved = 0;
        CHECK(render(&f, &r) == CPZ_OK && r.count == 2u);
    }
    /* a piece number outside 1..10 is refused (native); the original indexes its table out of range */
    f.o.state = CPZ_STATE_IDLE;
    f.world.cell[1][1].piece = 11;
    CHECK(render(&f, &r) == CPZ_ERR_BOUNDS);
    f.world.cell[1][1].piece = -1;
    CHECK(render(&f, &r) == CPZ_ERR_BOUNDS);
    f.world.cell[1][1].piece = 10;
    CHECK(render(&f, &r) == CPZ_OK);
    f.world.cell[1][1].piece = 1;
    /* the most blits a render can produce stay inside the array: 64 overlays, 10 pieces and a restore */
    fx_init(&f);
    put16(f.body, O_ROWS, 8);
    put16(f.body, O_COLS, 8);
    put16(f.body, O_PIECES, 10);
    for (int i = 0; i < 64; ++i) set_type(f.body, i / 8, i % 8, 1);
    for (int i = 0; i < 10; ++i) set_piece(f.body, i, i / 8, i % 8);
    start(&f);
    f.o.state = CPZ_STATE_MOVING;
    f.o.piece = 4;
    CHECK(render(&f, &r) == CPZ_OK && r.count == 64u + 10u + 1u && r.count <= CPZ_MAX_BLITS);
    /* a failing view origin */
    f.fail_call = f.calls + 1;
    CHECK(render(&f, &r) == CPZ_ERR_HOST && f.failed_cb == CB_ORIGIN);
}

/* ---- host failures -------------------------------------------------------------------------------------------------------- */

#define MEASURE(f) do { const int fc = (f)->fail_call; (f)->fail_call = 0; (f)->calls = 0; (f)->fail_call = fc; } while (0)

static int sc_phase0(Fx *f) { return visit(f, ROW, 0u); }
static int sc_finish_solved(Fx *f)
{
    int fc = f->fail_call;
    f->fail_call = 0;
    start(f);
    f->o.solved = 1;
    f->calls = 0;
    f->fail_call = fc;
    return visit(f, ROW, 2u);
}
static int sc_finish_cancel(Fx *f)
{
    int fc = f->fail_call;
    f->fail_call = 0;
    start(f);
    f->o.canceled = 1;
    f->calls = 0;
    f->fail_call = fc;
    return visit(f, ROW, 2u);
}
static int sc_moving_stop(Fx *f)
{
    int fc = f->fail_call;
    f->fail_call = 0;
    begin_slide(f, 1, 2, 0x13, 1);
    f->calls = 0;
    f->fail_call = fc;
    return visit(f, ROW, 1u);
}
static int sc_wait_delay(Fx *f)
{
    int fc = f->fail_call;
    f->fail_call = 0;
    start(f);
    f->o.state = CPZ_STATE_WAIT_DELAY;
    f->o.deadline = 0u;
    f->calls = 0;
    f->fail_call = fc;
    return visit(f, ROW, 1u);
}
static int sc_wait_sound(Fx *f)
{
    int fc = f->fail_call;
    f->fail_call = 0;
    start(f);
    f->o.state = CPZ_STATE_WAIT_SOUND;
    f->busy_value = 0;
    f->calls = 0;
    f->fail_call = fc;
    return visit(f, ROW, 1u);
}
static int sc_click(Fx *f)
{
    CpzClickResult c;
    int fc = f->fail_call;
    f->fail_call = 0;
    start(f);
    f->o.dir = 0x13;
    f->calls = 0;
    f->fail_call = fc;
    return click(f, 1u, 0x2783, 1, &c);
}
static int sc_render(Fx *f)
{
    static CpzRenderResult r;
    int fc = f->fail_call;
    f->fail_call = 0;
    start(f);
    f->calls = 0;
    f->fail_call = fc;
    return render(f, &r);
}
static int sc_invalidate(Fx *f)
{
    int fc = f->fail_call;
    f->fail_call = 0;
    start(f);
    f->calls = 0;
    f->fail_call = fc;
    return cpz_invalidate(&f->o, &f->host);
}
static int sc_cleanup(Fx *f)
{
    int fc = f->fail_call;
    f->fail_call = 0;
    start(f);
    f->calls = 0;
    f->fail_call = fc;
    return cpz_cleanup(&f->o, &f->host);
}

static void t_host_failure_sweep(void)
{
    static int (*const scenarios[])(Fx *) = {sc_phase0, sc_finish_solved, sc_finish_cancel, sc_moving_stop, sc_wait_delay,
                                             sc_wait_sound, sc_click, sc_render, sc_invalidate, sc_cleanup};
    unsigned mask = 0u;
    for (size_t s = 0; s < sizeof scenarios / sizeof scenarios[0]; ++s) {
        Fx f;
        int total;
        fx_init(&f);
        if (scenarios[s](&f) != CPZ_OK) {
            snprintf(g_msg, sizeof g_msg, "scenario %zu does not run clean", s);
            g_failed = 1;
            return;
        }
        total = f.calls;
        for (int n = 1; n <= total; ++n) {
            fx_init(&f);
            f.fail_call = n;
            if (scenarios[s](&f) != CPZ_ERR_HOST || f.failed_cb == 0) {
                snprintf(g_msg, sizeof g_msg, "scenario %zu: failing host call %d of %d was not reported", s, n, total);
                g_failed = 1;
                return;
            }
            mask |= 1u << f.failed_cb;
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
    /* phase 0 fails at the slot allocation: the object is marked active, the grid exists, there is no slot; phase 1 not reached */
    fx_init(&f);
    f.fail_call = 5; /* clear item (1), origin (2), alloc (3) ... order: clear, origin, alloc */
    f.fail_call = 3;
    CHECK(visit(&f, ROW, 0u) == CPZ_ERR_HOST && strcmp(f.failure, "0xd3-host") == 0);
    CHECK(f.phase == 0u && f.initialized == 0 && f.completed == 0 && f.o.slot == -1 && f.o.surface == 0u && f.o.active == 1);
    CHECK_LOG(&f, "active:1:0,start:1:0,gridreset:0:0,clearitem:0:0,gridsetup:1:0");
    /* the failed phase 0 did not write the later fields */
    CHECK(f.o.flag28 == 1 && f.o.state == 0 && f.world.start_flag_5bb1ca == 1);
    /* a failing finish stays in phase 2 with the object intact; a failing cleanup reports after the completion */
    fx_init(&f);
    start(&f);
    f.o.canceled = 1;
    f.fail_call = f.calls + 4; /* stops A, B, C pass; the transition fails */
    CHECK(visit(&f, ROW, 2u) == CPZ_ERR_HOST && f.phase == 2u && f.completed == 0 && f.o.active == 1 && f.failed_cb == CB_TRANSITION);
    CHECK(strstr(f.log, "complete") == NULL && strstr(f.log, "relsurf") == NULL && strstr(f.log, "x57b") == NULL);
    fx_init(&f);
    start(&f);
    f.o.canceled = 1;
    f.fail_call = f.calls + 5; /* the event flag store fails after the scene cells */
    CHECK(visit(&f, ROW, 2u) == CPZ_ERR_HOST && f.failed_cb == CB_STOREFLAG && f.phase == 2u && f.completed == 0);
    CHECK(strstr(f.log, "mode:4:0") != NULL && strstr(f.log, "evflag") == NULL && strstr(f.log, "complete") == NULL);
    fx_init(&f);
    start(&f);
    f.o.solved = 1;
    f.fail_call = f.calls + 6; /* stops (3), transition, store, then the surface release */
    CHECK(visit(&f, ROW, 2u) == CPZ_ERR_HOST && f.failed_cb == CB_RELSURF && f.completed == 1 && f.phase == 0u);
    CHECK(strstr(f.log, "complete:3:0") != NULL && strstr(f.log, "relsurf") == NULL && f.o.active == 1);
    /* a failing busy query keeps the state; a failing sound keeps the state before the sound */
    fx_init(&f);
    start(&f);
    f.o.state = CPZ_STATE_WAIT_SOUND;
    f.fail_call = f.calls + 1;
    CHECK(visit(&f, ROW, 1u) == CPZ_ERR_HOST && f.o.state == CPZ_STATE_WAIT_SOUND && f.phase == 1u);
    fx_init(&f);
    start(&f);
    f.o.state = CPZ_STATE_WAIT_DELAY;
    f.o.deadline = 0u;
    f.n_prepare = 0;
    f.fail_call = f.calls + 2; /* the prepare passes, the play fails */
    CHECK(visit(&f, ROW, 1u) == CPZ_ERR_HOST && f.failed_cb == CB_PLAY && f.o.state == CPZ_STATE_WAIT_DELAY && f.n_prepare == 1);
    /* the moving tick fails at the view origin before anything moved */
    fx_init(&f);
    begin_slide(&f, 1, 1, 0x13, 4);
    f.fail_call = f.calls + 1;
    CHECK(visit(&f, ROW, 1u) == CPZ_ERR_HOST && f.failed_cb == CB_ORIGIN && f.o.step == 0 && f.o.state == CPZ_STATE_MOVING);
    /* the move that ends in a failing sound keeps the state MOVING (the state store follows the sound) */
    fx_init(&f);
    begin_slide(&f, 1, 2, 0x13, 1);
    f.fail_call = f.calls + 2; /* origin passes, the stop sound fails */
    CHECK(visit(&f, ROW, 1u) == CPZ_ERR_HOST && f.failed_cb == CB_PLAY && f.o.state == CPZ_STATE_MOVING && f.world.cell[1][3].piece == 1);
}

/* ---- full play-throughs ----------------------------------------------------------------------------------------------------- */

/* One whole move: the pointer, the click and the ticks until the state returns to idle. Returns the tick count (or -1). */
static int play_move(Fx *f, int a, int b, int d, int32_t start_flag)
{
    CpzPointerResult p;
    CpzClickResult c;
    int32_t px, py;
    int ticks = 0;
    zone_pt(f, a, b, d, &px, &py);
    if (ptr(f, px, py, &p) != CPZ_OK || p.hit != 1u || p.candidate != cand_of(d)) return -1;
    if (click(f, f->phase, p.candidate, start_flag, &c) != CPZ_OK || c.move_started != 1u) return -1;
    while (f->o.state == CPZ_STATE_MOVING && ticks < 200) {
        if (visit(f, ROW, 1u) != CPZ_OK) return -1;
        ++ticks;
    }
    return f->o.state == CPZ_STATE_IDLE ? ticks : -1;
}

static void t_playthrough_solve(void)
{
    Fx f;
    static CpzRenderResult r;
    CpzPointerResult p;
    CpzClickResult c;
    fx_init(&f);
    f.world.start_flag_5bb1ca = 0;
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && f.phase == 1u);
    CHECK(render(&f, &r) == CPZ_OK && r.count == 3u);
    /* piece 2 down from (0, 1): two cells of four ticks, stops on its target (2, 1): sound C (a non-empty cell type) */
    LOGCLR(&f);
    CHECK(play_move(&f, 0, 1, 0x12, 1) == 8);
    CHECK(f.world.cell[2][1].piece == 2 && f.world.cell[0][1].piece == 0 && f.o.at_row == 2 && f.o.at_col == 1);
    CHECK(strstr(f.log, "state:2:0,play:11:0,play:13:0,state:0:0") != NULL); /* type 2 is not empty: sound C */
    /* the idle visit: not solved yet (piece 1 is off its target) */
    LOGCLR(&f);
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.solved == 0 && f.log[0] == '\0');
    CHECK(render(&f, &r) == CPZ_OK && r.count == 3u); /* the target of piece 2 has no overlay: its piece, piece 1, the target 1 */
    /* piece 1 right from (1, 0): three cells, stops on (1, 3) = its target, sound C again */
    LOGCLR(&f);
    CHECK(play_move(&f, 1, 0, 0x13, 1) == 12);
    CHECK(f.world.cell[1][3].piece == 1 && f.o.at_col == 3);
    CHECK(strstr(f.log, "play:11:0,play:13:0,state:0:0") != NULL);
    /* solved: the next idle visit says so; then the delay, the final sound and the finish */
    LOGCLR(&f);
    f.now = 10000u;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.solved == 1 && f.o.state == CPZ_STATE_SOLVED);
    CHECK_LOG(&f, "state:1:0");
    /* a click is refused while solved */
    CHECK(ptr(&f, 0, 0, &p) == CPZ_OK);
    CHECK(click(&f, 1u, 0x277f, 1, &c) == CPZ_OK && c.cancel_asked == 0u);
    LOGCLR(&f);
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.state == CPZ_STATE_WAIT_DELAY && f.o.deadline == 12000u);
    f.now = 11999u;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.state == CPZ_STATE_WAIT_DELAY && f.phase == 1u);
    f.now = 12000u;
    LOGCLR(&f);
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.state == CPZ_STATE_WAIT_SOUND);
    CHECK_LOG(&f, "tick:12000:0,prep:765:0,play:14:0,state:3:0");
    f.busy_value = 1;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.phase == 1u);
    f.busy_value = 0;
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.phase == 2u);
    LOGCLR(&f);
    CHECK(visit(&f, ROW, 2u) == CPZ_OK && f.completed == 1 && f.phase == 0u);
    CHECK(strstr(f.log, "tr:40:1:2:3:11:22:33") != NULL && strstr(f.log, "sf:7:3") != NULL && f.world.start_flag_5bb1ca == 0);
    CHECK(f.o.active == 0 && f.o.slot == -1 && f.o.row == -1);
    /* the grid survives the finish: both pieces rest on their targets, so a second round with the persist byte set is solved at once */
    f.body[O_PERSIST] = 1;
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && f.phase == 1u);
    CHECK(f.world.cell[1][3].piece == 1 && f.world.cell[2][1].piece == 2 && f.world.cell[1][0].piece == 0);
    CHECK(visit(&f, ROW, 1u) == CPZ_OK && f.o.solved == 1);
    /* a persist byte of 0 starts over */
    f.body[O_PERSIST] = 0;
    f.o.state = CPZ_STATE_IDLE;
    f.o.solved = 0;
    f.o.canceled = 0;
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && f.world.cell[1][0].piece == 1 && f.world.cell[1][3].piece == 0);
}

static void t_playthrough_cancel(void)
{
    Fx f;
    CpzPointerResult p;
    CpzClickResult c;
    fx_init(&f);
    start(&f);
    CHECK(play_move(&f, 1, 0, 0x11, 0) == 4); /* piece 1 up to (0, 0), an empty cell: sound B; no click sound (flag 0) */
    CHECK(strstr(f.log, "play:12:0") != NULL && strstr(f.log, "play:11") == NULL);
    LOGCLR(&f);
    CHECK(ptr(&f, 17 + f.vx, 25 + f.vy, &p) == CPZ_OK && p.hit == 1u && p.candidate == 0x277f && p.cursor_kind == 9);
    CHECK(click(&f, 1u, p.candidate, 1, &c) == CPZ_OK && c.cancel_asked == 1u && c.new_phase == 2u && f.o.canceled == 1);
    /* the executor stores phase 2; the visit finishes with the cancel block */
    LOGCLR(&f);
    CHECK(visit(&f, ROW, 2u) == CPZ_OK && f.completed == 1 && f.phase == 0u);
    CHECK(strstr(f.log, "tr:50:4:5:6:44:55:66") != NULL && strstr(f.log, "sf:8:9") != NULL && f.world.start_flag_5bb1ca == 1);
    CHECK(f.o.canceled == 0 && f.o.active == 0);
    /* pointer and click find an idle puzzle */
    CHECK(ptr(&f, 17 + f.vx, 25 + f.vy, &p) == CPZ_OK && p.hit == 0u);
    CHECK(click(&f, 1u, 0x277f, 1, &c) == CPZ_OK && c.cancel_asked == 0u);
}

/* ---- random bodies under the sanitizers ------------------------------------------------------------------------------------ */

static uint32_t g_rng = 12345u;
static uint32_t rnd(void)
{
    g_rng = g_rng * 1664525u + 1013904223u;
    return g_rng >> 8;
}

static void t_fuzz_bodies(void)
{
    static CpzRenderResult r;
    for (int round = 0; round < 120; ++round) {
        Fx f;
        const int rows = (int)(rnd() % 9u), cols = (int)(rnd() % 9u), pieces = (int)(rnd() % 11u);
        fx_init(&f);
        put16(f.body, O_ROWS, rows);
        put16(f.body, O_COLS, cols);
        put16(f.body, O_PIECES, pieces);
        put16(f.body, O_STEPS, (int)(1u + rnd() % 9u));
        for (int i = 0; i < 64; ++i) put16(f.body, (size_t)(O_TYPES + 2 * i), (int)(rnd() % 3u == 0u ? rnd() % 0x20u : 0u));
        for (int i = 0; i < 10; ++i) {
            put16(f.body, (size_t)(O_START + 4 * i), (int)(rnd() % 10u) - 1);
            put16(f.body, (size_t)(O_START + 4 * i + 2), (int)(rnd() % 10u) - 1);
        }
        for (int i = 0; i < 10; ++i)
            put_rect(f.body, (size_t)(O_PSRC + 16 * i), (int32_t)(rnd() % 50u), (int32_t)(rnd() % 50u), (int32_t)(rnd() % 100u),
                     (int32_t)(rnd() % 100u));
        put16(f.body, O_GAP, (int)(rnd() % 20u) - 10);
        if (rnd() % 7u == 0u) put32(f.body, O_OX, (int32_t)(0x7fffff00u + rnd() % 256u)); /* arithmetic wraps like the original */
        f.body[O_PERSIST] = (uint8_t)(rnd() % 2u);
        if (rnd() % 5u == 0u) put_rect(f.body, O_PSRC, 0, 0, 0, 0);
        if (rnd() % 4u == 0u) put_rect(f.body, O_AH, 0, 0, (int32_t)(rnd() % 80u), (int32_t)(rnd() % 80u));
        if (rnd() % 4u == 0u) put_rect(f.body, O_AV, 0, 0, (int32_t)(rnd() % 80u), (int32_t)(rnd() % 80u));
        CHECK(visit(&f, ROW, 0u) == CPZ_OK);
        for (int step = 0; step < 150 && !g_failed; ++step) {
            CpzPointerResult p;
            CpzClickResult c;
            const int op = (int)(rnd() % 6u);
            if (op <= 1) {
                CHECK(ptr(&f, (int32_t)(rnd() % 200u) - 20, (int32_t)(rnd() % 200u) - 20, &p) == CPZ_OK);
            } else if (op == 2) {
                CHECK(click(&f, 1u, p.hit ? p.candidate : 0x2780, 1, &c) == CPZ_OK);
            } else {
                CHECK(visit(&f, ROW, 1u) == CPZ_OK);
            }
            if (f.o.state == CPZ_STATE_WAIT_DELAY) f.now += 700u;
            f.busy_value = (int32_t)(rnd() % 2u);
            CHECK(render(&f, &r) == CPZ_OK && r.count <= CPZ_MAX_BLITS);
            if (f.phase == 2u) {
                CHECK(visit(&f, ROW, 2u) == CPZ_OK);
                CHECK(visit(&f, ROW, 0u) == CPZ_OK);
            }
            memset(&p, 0, sizeof p);
        }
        /* the grid reset and a second phase 0 over whatever is left */
        cpz_grid_reset(&f.world);
        f.body[O_PERSIST] = 0;
        CHECK(visit(&f, ROW, 0u) == CPZ_OK && cpz_cleanup(&f.o, &f.host) == CPZ_OK);
    }
}

/* ---- the session binding (src/session_bindings_ad3.c) over a synthetic scene ------------------------------------------------- */

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

static size_t build_scene(uint8_t *out, size_t rows, const int *types, const uint8_t *const *bodies, const size_t *lengths)
{
    uint8_t tsum[126], act[48 + 2 + CPZ_BODY_BYTES];
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
static int g_store_ready, g_store_cell_piece;
static void h_store_world(void *c, const CpzWorld *w)
{
    if (c == NULL) ++g_hook_bad;
    ++g_stores;
    g_store_start = w->start_flag_5bb1ca;
    g_store_ready = w->grid_ready;
    g_store_cell_piece = w->cell[1][0].piece;
}

typedef struct Bind {
    Fx f;
    SessionAd3Host host;
    SessionAd3Binding *b;
    SceneResource *scene;
    uint8_t bytes[8192];
    uint8_t bytes_before[8192];
    size_t bytes_len;
    uint8_t body_a[CPZ_BODY_BYTES], body_b[CPZ_BODY_BYTES];
} Bind;

static int bind_open(Bind *x, int hooks)
{
    const int types[3] = {0x70, 0xd3, 0xd3};
    const uint8_t one = 0;
    const uint8_t *bodies[3];
    size_t lengths[3] = {1, CPZ_BODY_BYTES, CPZ_BODY_BYTES};
    char err[128] = {0};
    fx_init(&x->f);
    g_stores = g_store_start = g_hook_bad = g_store_ready = g_store_cell_piece = 0;
    memcpy(x->body_a, x->f.body, CPZ_BODY_BYTES);
    memcpy(x->body_b, x->f.body, CPZ_BODY_BYTES);
    /* row 2: another surface and layout: one piece at (2, 2), the cancel rectangle elsewhere, scene 41 on solving, persist 1 */
    set_str(x->body_b, 0, "OTHER");
    put16(x->body_b, O_PIECES, 1);
    set_piece(x->body_b, 0, 2, 2);
    put_rect(x->body_b, O_CRECT, 300, 300, 330, 330);
    put_rect(x->body_b, O_PSRC, 500, 600, 530, 621); /* same 30 x 21 size, another source: tells the two bodies apart */
    set_block(x->body_b, O_SOLV, 41, 1, 2, 3, 11, 22, 33, 1, 7, 3);
    x->body_b[O_PERSIST] = 1;
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
    x->b = session_ad3_create(&x->host);
    return x->b != NULL;
}

static void bind_close(Bind *x)
{
    session_ad3_destroy(x->b);
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
        const int rc = session_ad3_handler(x->b, row, &info, &st, &out);
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
    CpzPointerResult p;
    CpzClickResult c;
    static CpzRenderResult r;
    if (!bind_open(&x, 1)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_ad3_begin_scene(x.b, x.scene) == CPZ_OK && strcmp(session_ad3_failure(x.b), "none") == 0);
    CHECK(session_ad3_registered(x.b) == 0u && session_ad3_object(x.b)->active == 0 && session_ad3_object(x.b)->row == -1);
    LOGCLR(&x.f);
    {
        SceneActionInfo info, other;
        SceneActionRuntimeState st;
        SceneActionHandlerResult out;
        memset(&st, 0, sizeof st);
        CHECK(scene_resource_action_at(x.scene, 0, &info) == SCENE_RESOURCE_OK);
        CHECK(session_ad3_handler(x.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(strcmp(session_ad3_failure(x.b), "0xd3-row-not-owned") == 0);
        CHECK(scene_resource_action_at(x.scene, 1, &info) == SCENE_RESOURCE_OK);
        CHECK(session_ad3_handler(x.b, 7, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_ad3_handler(x.b, 3, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR); /* one past the last row */
        CHECK(scene_resource_action_at(x.scene, 0, &other) == SCENE_RESOURCE_OK);
        CHECK(session_ad3_handler(x.b, 1, &other, &st, &out) == SCENE_ACTION_HANDLER_ERROR); /* foreign type at our index */
        CHECK(session_ad3_handler(x.b, 0, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);  /* our type at a foreign index */
        CHECK(strcmp(session_ad3_failure(x.b), "0xd3-row-not-owned") == 0);                   /* refused by the binding, not by the body check */
        CHECK(x.f.log[0] == '\0' && g_stores == 0);
        CHECK(session_ad3_handler(x.b, 1, NULL, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_ad3_handler(x.b, 1, &info, NULL, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_ad3_handler(x.b, 1, &info, &st, NULL) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(session_ad3_handler(NULL, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        st.phase = 1u;
        CHECK(session_ad3_handler(x.b, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
        CHECK(strcmp(session_ad3_failure(x.b), "0xd3-phase-1-without-init") == 0);
    }
    /* pointer, click, render and invalidate before the puzzle starts: no host call at all */
    memset(&p, 0x55, sizeof p);
    CHECK(session_ad3_pointer_move(x.b, 15, 5, &p) == CPZ_OK && p.hit == 0u && p.candidate == -1 && p.cursor_written == 0u && x.f.n_origin == 0);
    memset(&c, 0x55, sizeof c);
    CHECK(session_ad3_click(x.b, 1u, 0x277f, 1, &c) == CPZ_OK && c.cancel_asked == 0u && c.new_phase == 1u);
    CHECK(session_ad3_click(x.b, 4u, 0x277f, 1, &c) == CPZ_OK && c.new_phase == 4u);
    memset(&r, 0x55, sizeof r);
    CHECK(session_ad3_render(x.b, &r) == CPZ_OK && r.valid == 0u && r.count == 0u);
    CHECK(session_ad3_invalidate(x.b) == CPZ_OK && x.f.n_dirty == 0);
    /* phase 0 of row 1 */
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u && done == 0);
    CHECK(g_stores == 1 && g_store_start == 1 && g_store_ready == 1 && g_store_cell_piece == 1 && g_hook_bad == 0);
    CHECK(session_ad3_registered(x.b) == 1u && session_ad3_object(x.b)->active == 1 && session_ad3_object(x.b)->row == 1);
    CHECK(session_ad3_world(x.b)->grid_ready == 1 && session_ad3_world(x.b)->cell[1][3].type == 1);
    CHECK(strcmp(x.f.loaded_name, "PUZ") == 0);
    CHECK(session_ad3_render(x.b, &r) == CPZ_OK && r.valid == 1u && r.count == 3u);
    CHECK(session_ad3_invalidate(x.b) == CPZ_OK && x.f.n_dirty == 1 && x.f.dirty_slot == 24);
    /* the pointer: the view origin (7, 11) is added by the binding */
    {
        int32_t px, py;
        zone_pt(&x.f, 0, 1, 0x12, &px, &py);
        x.f.n_origin = 0;
        CHECK(session_ad3_pointer_move(x.b, px - 7, py - 11, &p) == CPZ_OK && p.hit == 1u && p.candidate == 0x2782 && x.f.n_origin == 1);
        CHECK(session_ad3_pointer_move(x.b, px, py, &p) == CPZ_OK && p.hit == 0u);
        x.f.vx = 8;
        CHECK(session_ad3_pointer_move(x.b, px - 7, py - 11, &p) == CPZ_OK && p.hit == 1u); /* the down zone is wide */
        x.f.vx = 7;
        CHECK(session_ad3_pointer_move(x.b, px - 7, py - 11, &p) == CPZ_OK && p.hit == 1u);
        CHECK(session_ad3_pointer_move(x.b, 20, 30, &p) == CPZ_OK && p.hit == 1u && p.candidate == 0x277f);
        /* the view origin is added per axis: the right edge of piece 2's cell and the top edge of piece 1's cell are inclusive, so a
         * swapped or missing origin misses them */
        zone_pt(&x.f, 0, 1, 0x13, &px, &py);
        CHECK(session_ad3_pointer_move(x.b, px - 7, py - 11, &p) == CPZ_OK && p.hit == 1u && p.candidate == 0x2783);
        zone_pt(&x.f, 1, 0, 0x11, &px, &py);
        CHECK(session_ad3_pointer_move(x.b, px - 7, py - 11, &p) == CPZ_OK && p.hit == 1u && p.candidate == 0x2781);
        zone_pt(&x.f, 0, 1, 0x12, &px, &py);
        /* a failing origin */
        x.f.calls = 0;
        x.f.fail_call = 1;
        CHECK(session_ad3_pointer_move(x.b, 20, 30, &p) == CPZ_ERR_HOST && strcmp(session_ad3_failure(x.b), "0xd3-pointer-origin") == 0);
        x.f.fail_call = 0;
        /* the click: the process flag and the phase come from the caller; the candidate retained by the release */
        CHECK(session_ad3_pointer_move(x.b, px - 7, py - 11, &p) == CPZ_OK && p.hit == 1u);
        CHECK(session_ad3_click(x.b, 2u, 0x2782, 1, &c) == CPZ_OK && c.move_started == 0u && c.new_phase == 2u);
        CHECK(session_ad3_click(x.b, 1u, 0x2782, 0, &c) == CPZ_OK && c.move_started == 1u && c.sound_played == 0u && c.new_phase == 1u);
        CHECK(strcmp(session_ad3_failure(x.b), "none") == 0 && session_ad3_object(x.b)->state == CPZ_STATE_MOVING);
        CHECK(memcmp(x.bytes, x.bytes_before, x.bytes_len) == 0);
    }
    /* the move runs through phase 1 visits; the pointer does nothing while the piece slides */
    x.f.calls = 0;
    CHECK(session_ad3_pointer_move(x.b, 20, 30, &p) == CPZ_OK && p.hit == 0u && p.candidate == -1);
    for (int i = 0; i < 8; ++i) CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u && done == 0);
    CHECK(session_ad3_object(x.b)->state == CPZ_STATE_IDLE && session_ad3_world(x.b)->cell[2][1].piece == 2);
    CHECK(g_stores == 1); /* phase 1 visits write no world */
    /* the cancel click asks for phase 2; the visit finishes the row */
    CHECK(session_ad3_pointer_move(x.b, 20, 30, &p) == CPZ_OK && p.candidate == 0x277f);
    CHECK(session_ad3_click(x.b, 1u, 0x277f, 1, &c) == CPZ_OK && c.cancel_asked == 1u && c.new_phase == 2u);
    CHECK(b_visit(&x, 1, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 0u && done == 1);
    CHECK(g_stores == 2 && g_store_start == 1);
    CHECK(strstr(x.f.log, "tr:50:4:5:6:44:55:66") != NULL);
    CHECK(session_ad3_registered(x.b) == 0u && session_ad3_object(x.b)->active == 0 && session_ad3_object(x.b)->row == -1);
    CHECK(x.f.n_relsurf == 1 && x.f.n_relslot == 1);
    CHECK(session_ad3_render(x.b, &r) == CPZ_OK && r.valid == 0u);
    CHECK(session_ad3_world(x.b)->grid_ready == 1); /* the grid outlives the row */
    bind_close(&x);
}

static void t_binding_second_row(void)
{
    Bind x;
    uint32_t ph = 0u;
    int done = 0;
    CpzPointerResult p;
    static CpzRenderResult r;
    if (!bind_open(&x, 1)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_ad3_begin_scene(x.b, x.scene) == CPZ_OK);
    /* row 2 loads another surface; its persist byte is 1, a fresh grid is set up from its body */
    CHECK(b_visit(&x, 2, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u);
    CHECK(strcmp(x.f.loaded_name, "OTHER") == 0 && session_ad3_object(x.b)->row == 2 && session_ad3_world(x.b)->cell[2][2].piece == 1);
    CHECK(session_ad3_world(x.b)->cell[1][0].piece == 0 && session_ad3_world(x.b)->cell[0][1].piece == 0);
    /* the cancel rectangle of row 2 is at 300..330 and the one of row 1 is dead */
    CHECK(session_ad3_pointer_move(x.b, 20, 30, &p) == CPZ_OK && p.hit == 0u);
    CHECK(session_ad3_pointer_move(x.b, 310, 310, &p) == CPZ_OK && p.hit == 1u && p.candidate == 0x277f);
    CHECK(session_ad3_render(x.b, &r) == CPZ_OK && r.count == 2u && r.blit[0].kind == CPZ_BLIT_TARGET && r.blit[1].kind == CPZ_BLIT_PIECE &&
          r.blit[1].piece == 1);
    /* the blits come from the active row's body (row 2), not from another row's */
    CHECK(r.blit[1].src[0] == 500 && r.blit[1].src[1] == 600 && r.blit[1].src[2] == 530 && r.blit[1].src[3] == 621);
    /* the finish of row 2 uses its own solved block (scene 41) */
    ((CpzObject *)session_ad3_object(x.b))->solved = 1;
    CHECK(b_visit(&x, 2, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK && done == 1);
    CHECK(strstr(x.f.log, "tr:41:1:2:3:11:22:33") != NULL && strstr(x.f.log, "tr:40:") == NULL);
    /* the grid persists across rows and across scene changes (persist byte 1 of row 2 kept it): row 1 with persist 1 keeps row 2's pieces */
    x.body_a[O_PERSIST] = 1; /* the stored copy is unchanged: the scene's row 1 has persist 0 */
    CHECK(session_ad3_world(x.b)->cell[2][2].piece == 1);
    CHECK(session_ad3_begin_scene(x.b, x.scene) == CPZ_OK && session_ad3_world(x.b)->cell[2][2].piece == 1 && session_ad3_world(x.b)->grid_ready == 1);
    /* row 2 again with persist 1: setup is skipped, the piece that is there stays */
    CHECK(b_visit(&x, 2, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    CHECK(strstr(x.f.log, "gridsetup:0:0") != NULL);
    /* the new-game reset empties the grid */
    session_ad3_grid_reset(x.b);
    CHECK(session_ad3_world(x.b)->grid_ready == 0 && session_ad3_world(x.b)->cell[2][2].piece == 0 && session_ad3_world(x.b)->cell[2][2].visible == 0);
    session_ad3_grid_reset(NULL);
    /* row 1 (persist 0) resets by itself */
    CHECK(session_ad3_begin_scene(x.b, x.scene) == CPZ_OK);
    CHECK(b_visit(&x, 2, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && session_ad3_world(x.b)->cell[2][2].piece == 1);
    CHECK(session_ad3_begin_scene(x.b, x.scene) == CPZ_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && session_ad3_world(x.b)->cell[2][2].piece == 0 &&
          session_ad3_world(x.b)->cell[1][0].piece == 1);
    bind_close(&x);
}

static void t_binding_without_hooks(void)
{
    Bind x;
    uint32_t ph = 0u;
    int done = 0;
    CpzClickResult c;
    CpzPointerResult p;
    if (!bind_open(&x, 0)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_ad3_begin_scene(x.b, x.scene) == CPZ_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && ph == 1u);
    CHECK(session_ad3_world(x.b)->start_flag_5bb1ca == 1);
    CHECK(session_ad3_pointer_move(x.b, 20, 30, &p) == CPZ_OK && p.candidate == 0x277f);
    CHECK(session_ad3_click(x.b, 1u, 0x277f, 1, &c) == CPZ_OK && c.cancel_asked == 1u);
    CHECK(b_visit(&x, 1, 2u, &ph, &done) == SCENE_ACTION_HANDLER_OK && done == 1 && ph == 0u);
    CHECK(g_stores == 0);
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
    CHECK(session_ad3_begin_scene(x.b, x.scene) == CPZ_OK);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK && session_ad3_registered(x.b) == 1u);
    LOGCLR(&x.f);
    /* the next scene's begin runs the previous scene's clear (0x461862) */
    CHECK(session_ad3_begin_scene(x.b, x.scene) == CPZ_OK);
    CHECK_LOG(&x.f, "relsurf:77:0,relslot:24:0");
    CHECK(session_ad3_registered(x.b) == 0u && session_ad3_object(x.b)->active == 0 && session_ad3_object(x.b)->row == -1);
    /* the rows are the new scene's: the old phase-1 state is gone */
    {
        SceneActionInfo info;
        SceneActionRuntimeState st;
        SceneActionHandlerResult out;
        memset(&st, 0, sizeof st);
        st.phase = 1u;
        CHECK(scene_resource_action_at(x.scene, 1, &info) == SCENE_RESOURCE_OK);
        CHECK(session_ad3_handler(x.b, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED);
    }
    /* a failing clear is reported and keeps the old rows */
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    x.f.calls = 0;
    x.f.fail_call = 1;
    CHECK(session_ad3_begin_scene(x.b, x.scene) == CPZ_ERR_HOST && strcmp(session_ad3_failure(x.b), "0xd3-scene-clear") == 0);
    x.f.fail_call = 0;
    CHECK(b_visit(&x, 1, 1u, &ph, &done) == SCENE_ACTION_HANDLER_OK && session_ad3_registered(x.b) == 1u);
    /* destroying runs the clear as well */
    LOGCLR(&x.f);
    session_ad3_destroy(x.b);
    x.b = NULL;
    CHECK_LOG(&x.f, "relsurf:77:0,relslot:25:0");
    scene_resource_close(x.scene);
    CHECK(session_ad3_begin_scene(NULL, NULL) == CPZ_ERR_ARGUMENT);
}

static void t_binding_refuses_bad_body(void)
{
    Bind x;
    uint8_t bad[CPZ_BODY_BYTES];
    const int types[3] = {0x70, 0xd3, 0xd3};
    const uint8_t one = 0;
    const uint8_t *bodies[3];
    size_t lengths[3] = {1, CPZ_BODY_BYTES, CPZ_BODY_BYTES};
    char err[128] = {0};
    SceneResource *bad_scene;
    static uint8_t other[8192];
    if (!bind_open(&x, 1)) {
        CHECK(0 && "scene opens");
        return;
    }
    memcpy(bad, x.body_b, CPZ_BODY_BYTES);
    put16(bad, O_STEPS, 0);
    bodies[0] = &one;
    bodies[1] = x.body_a;
    bodies[2] = bad;
    {
        const size_t n = build_scene(other, 3, types, bodies, lengths);
        bad_scene = scene_resource_open_memory(other, n, err, sizeof err);
        CHECK(bad_scene != NULL);
        if (bad_scene != NULL) {
            CHECK(session_ad3_begin_scene(x.b, bad_scene) == CPZ_ERR_BODY);
            CHECK(strcmp(session_ad3_failure(x.b), "0xd3-animation-steps") == 0);
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
        CHECK(session_ad3_handler(x.b, 1, &info, &st, &out) == SCENE_ACTION_HANDLER_ERROR);
        CHECK(strcmp(session_ad3_failure(x.b), "0xd3-row-not-owned") == 0);
    }
    /* a short typed body is refused too */
    lengths[2] = CPZ_BODY_BYTES - 1u;
    bodies[2] = x.body_b;
    {
        const size_t n = build_scene(other, 3, types, bodies, lengths);
        bad_scene = scene_resource_open_memory(other, n, err, sizeof err);
        CHECK(bad_scene == NULL); /* the scene parser already refuses a 0xd3 row that is not 855 bytes long */
        scene_resource_close(bad_scene);
    }
    /* rows of other types are not looked at: a 0x70 row with a one byte body was accepted */
    CHECK(session_ad3_begin_scene(x.b, x.scene) == CPZ_OK);
    CHECK(strcmp(session_ad3_failure(x.b), "none") == 0); /* a good scene clears the earlier refusal text */
    CHECK(session_ad3_begin_scene(x.b, NULL) == CPZ_ERR_ARGUMENT);
    bind_close(&x);
}

static void t_binding_host_error_and_args(void)
{
    Bind x;
    uint32_t ph = 0u;
    int done = 0;
    CpzPointerResult p;
    CpzClickResult c;
    static CpzRenderResult r;
    if (!bind_open(&x, 1)) {
        CHECK(0 && "scene opens");
        return;
    }
    CHECK(session_ad3_begin_scene(x.b, x.scene) == CPZ_OK);
    x.f.calls = 0;
    x.f.fail_call = 3; /* the slot allocation of phase 0 (clear item, origin, alloc) */
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_ERROR);
    CHECK(strcmp(session_ad3_failure(x.b), "0xd3-host") == 0 && g_stores == 0);
    x.f.fail_call = 0;
    /* the object is half initialized (active, no slot): the pointer needs the row's body and works, the render finds no entry */
    CHECK(session_ad3_render(x.b, &r) == CPZ_OK && r.valid == 0u);
    CHECK(b_visit(&x, 1, 0u, &ph, &done) == SCENE_ACTION_HANDLER_OK);
    /* failed click: the failure text names the click */
    x.f.calls = 0;
    x.f.fail_call = 1; /* the sound play */
    ((CpzObject *)session_ad3_object(x.b))->dir = 0x13;
    CHECK(session_ad3_click(x.b, 1u, 0x2783, 1, &c) == CPZ_ERR_HOST && strcmp(session_ad3_failure(x.b), "0xd3-click") == 0);
    x.f.fail_call = 0;
    ((CpzObject *)session_ad3_object(x.b))->state = CPZ_STATE_IDLE;
    CHECK(session_ad3_click(x.b, 1u, 0x277f, 1, &c) == CPZ_OK && strcmp(session_ad3_failure(x.b), "none") == 0);
    x.f.calls = 0;
    x.f.fail_call = 1;
    CHECK(session_ad3_render(x.b, &r) == CPZ_ERR_HOST && strcmp(session_ad3_failure(x.b), "0xd3-render") == 0); /* the view origin */
    x.f.fail_call = 0;
    CHECK(session_ad3_render(x.b, &r) == CPZ_OK && strcmp(session_ad3_failure(x.b), "none") == 0);
    /* invalidate failure */
    x.f.calls = 0;
    x.f.fail_call = 1;
    CHECK(session_ad3_invalidate(x.b) == CPZ_ERR_HOST);
    x.f.fail_call = 0;
    /* NULL arguments */
    CHECK(session_ad3_pointer_move(NULL, 1, 1, &p) == CPZ_ERR_ARGUMENT && session_ad3_pointer_move(x.b, 1, 1, NULL) == CPZ_ERR_ARGUMENT);
    CHECK(session_ad3_click(NULL, 1u, 0, 0, &c) == CPZ_ERR_ARGUMENT && session_ad3_click(x.b, 1u, 0, 0, NULL) == CPZ_ERR_ARGUMENT);
    CHECK(session_ad3_render(NULL, &r) == CPZ_ERR_ARGUMENT && session_ad3_render(x.b, NULL) == CPZ_ERR_ARGUMENT);
    CHECK(session_ad3_invalidate(NULL) == CPZ_ERR_ARGUMENT);
    CHECK(session_ad3_registered(NULL) == 0u && session_ad3_object(NULL) == NULL && session_ad3_world(NULL) == NULL);
    CHECK(strcmp(session_ad3_failure(NULL), "0xd3-binding-unbound") == 0);
    CHECK(session_ad3_create(NULL) == NULL);
    session_ad3_destroy(NULL);
    /* a pointer without a view origin provider is refused */
    {
        SessionAd3Host h = x.host;
        SessionAd3Binding *b2;
        h.kernel.view_origin = NULL;
        b2 = session_ad3_create(&h);
        CHECK(b2 != NULL);
        if (b2 != NULL) {
            CpzObject *o2;
            CHECK(session_ad3_begin_scene(b2, x.scene) == CPZ_OK);
            /* the object is made active by hand (phase 0 itself needs the provider): the pointer is refused, nothing is called */
            o2 = (CpzObject *)session_ad3_object(b2);
            o2->active = 1;
            o2->row = 1;
            CHECK(session_ad3_pointer_move(b2, 20, 30, &p) == CPZ_ERR_HOST && strcmp(session_ad3_failure(b2), "0xd3-pointer-origin") == 0);
            /* a row the binding does not own: the pointer, click and render refuse before any host call */
            o2->row = 0; /* a 0x70 row */
            CHECK(session_ad3_pointer_move(b2, 20, 30, &p) == CPZ_ERR_ARGUMENT);
            CHECK(session_ad3_click(b2, 1u, 0x277f, 1, &c) == CPZ_ERR_ARGUMENT);
            o2->slot = 24;
            CHECK(session_ad3_render(b2, &r) == CPZ_ERR_ARGUMENT);
            o2->row = 99; /* past the last row */
            CHECK(session_ad3_pointer_move(b2, 20, 30, &p) == CPZ_ERR_ARGUMENT);
            CHECK(session_ad3_click(b2, 1u, 0x277f, 1, &c) == CPZ_ERR_ARGUMENT);
            CHECK(session_ad3_render(b2, &r) == CPZ_ERR_ARGUMENT);
            o2->row = -1;
            CHECK(session_ad3_pointer_move(b2, 20, 30, &p) == CPZ_ERR_ARGUMENT);
            o2->active = 0;
            o2->slot = CPZ_NO_SLOT;
            session_ad3_destroy(b2);
        }
    }
    bind_close(&x);
}

/* Arrow extents that are negative and odd: the half extents truncate toward zero (-17 / 2 == -8, not -9). */
static void t_arrow_negative_extents(void)
{
    Fx f;
    fx_init(&f);
    put16(f.body, O_ROWS, 1);
    put16(f.body, O_COLS, 4);
    put16(f.body, O_PIECES, 0);
    put_rect(f.body, O_AH, 3017, 10, 3000, 19); /* -17 x 9 */
    put_rect(f.body, O_AV, 3108, 27, 3100, 10); /* 8 x -17 */
    set_type(f.body, 0, 0, 0x10);
    set_type(f.body, 0, 1, 0x13);
    set_type(f.body, 0, 2, 0x11);
    set_type(f.body, 0, 3, 0x12);
    CHECK(visit(&f, ROW, 0u) == CPZ_OK && cells_match(&f));
    CHECK(f.world.cell[0][0].base[0] == f.world.cell[0][0].rect[0] - 2 + 8 && f.world.cell[0][0].base[2] == f.world.cell[0][0].base[0] - 17);
    CHECK(f.world.cell[0][1].base[0] == f.world.cell[0][1].rect[2] + 2 + 8);
    CHECK(f.world.cell[0][2].base[1] == f.world.cell[0][2].rect[1] - 2 + 8 && f.world.cell[0][2].base[3] == f.world.cell[0][2].base[1] - 17);
    CHECK(f.world.cell[0][3].base[1] == f.world.cell[0][3].rect[3] + 2 + 8);
}

/* The cell a piece leaves is hidden only when its type is 0: any other type (negative, large, an overlay) keeps being drawn. */
static void t_old_cell_visibility(void)
{
    static const int types[] = {0, -1, 0x7fff, 5, 0x20, 1};
    for (size_t i = 0; i < sizeof types / sizeof types[0]; ++i) {
        Fx f;
        int guard = 0;
        fx_init(&f);
        begin_slide(&f, 1, 1, 0x13, 3);
        f.world.cell[1][1].type = (int16_t)types[i];
        while (guard++ < 40 && f.o.at_col == 1) CHECK(visit(&f, ROW, 1u) == CPZ_OK);
        CHECK(f.o.at_col == 2 && f.world.cell[1][1].piece == 0);
        CHECK(f.world.cell[1][1].visible == (types[i] != 0 ? 1 : 0));
        if (g_failed) {
            snprintf(g_msg + strlen(g_msg), sizeof g_msg - strlen(g_msg), " (type %d)", types[i]);
            return;
        }
    }
}

/* Pieces recorded outside the body's R x C (a larger puzzle's leftovers in the persistent grid) never claim the pointer. */
static void t_pointer_stale_pieces(void)
{
    Fx f;
    CpzPointerResult p;
    int32_t px, py;
    fx_init(&f);
    start(&f); /* 3 rows x 4 columns */
    /* control: a piece inside the grid with a free left neighbor is hit */
    f.world.cell[2][2].piece = 3;
    f.world.cell[2][2].visible = 1;
    crect(&f, 2, 2, f.world.cell[2][2].rect);
    zone_pt(&f, 2, 2, 0x10, &px, &py);
    CHECK(ptr(&f, px, py, &p) == CPZ_OK && p.hit == 1u && p.candidate == 0x2780);
    f.world.cell[2][2].piece = 0;
    f.o.piece = 0;
    f.o.dir = 0;
    /* the same piece one row below the last row and one column right of the last column is invisible to the pointer */
    f.world.cell[3][1].piece = 3;
    crect(&f, 3, 1, f.world.cell[3][1].rect);
    zone_pt(&f, 3, 1, 0x10, &px, &py);
    CHECK(ptr(&f, px, py, &p) == CPZ_OK && p.hit == 0u && p.candidate == -1 && f.o.dir == 0);
    f.world.cell[3][1].piece = 0;
    f.world.cell[0][4].piece = 3;
    crect(&f, 0, 4, f.world.cell[0][4].rect);
    zone_pt(&f, 0, 4, 0x10, &px, &py);
    CHECK(ptr(&f, px, py, &p) == CPZ_OK && p.hit == 0u && p.candidate == -1 && f.o.dir == 0);
    f.world.cell[0][4].piece = 0;
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
    run("object_and_grid_reset", t_reset);
    run("phase0", t_phase0);
    run("persist_byte", t_persist);
    run("grid_setup", t_grid_setup);
    run("pointer_zones", t_pointer_zones);
    run("pointer_basics", t_pointer_basics);
    run("pointer_order", t_pointer_order);
    run("pointer_cancel", t_pointer_cancel);
    run("move_check", t_move_check);
    run("animation", t_animation);
    run("slide_chain", t_slide_chain);
    run("moving_without_direction", t_moving_without_direction);
    run("stop_sounds", t_stop_sounds);
    run("solved_scan", t_solved_scan);
    run("state_delay_and_sound", t_state_delay_and_sound);
    run("phase2_solved", t_phase2_solved);
    run("phase2_cancel", t_phase2_cancel);
    run("phase2_flag_refused", t_phase2_flag_refused);
    run("step_args", t_step_args);
    run("click", t_click);
    run("invalidate_cleanup", t_invalidate_cleanup);
    run("render_basics", t_render_basics);
    run("render_kinds", t_render_kinds);
    run("render_restore", t_render_restore);
    run("arrow_negative_extents", t_arrow_negative_extents);
    run("old_cell_visibility", t_old_cell_visibility);
    run("pointer_stale_pieces", t_pointer_stale_pieces);
    run("host_failure_sweep", t_host_failure_sweep);
    run("host_failure_effects", t_host_failure_effects);
    run("playthrough_solve", t_playthrough_solve);
    run("playthrough_cancel", t_playthrough_cancel);
    run("fuzz_bodies", t_fuzz_bodies);
    run("binding_flow", t_binding_flow);
    run("binding_second_row", t_binding_second_row);
    run("binding_without_hooks", t_binding_without_hooks);
    run("binding_scene_change_clears", t_binding_scene_change_clears);
    run("binding_refuses_bad_body", t_binding_refuses_bad_body);
    run("binding_host_error_and_args", t_binding_host_error_and_args);
    printf("TOTAL %d FAILED %d\n", g_total, g_failures);
    return g_failures;
}
