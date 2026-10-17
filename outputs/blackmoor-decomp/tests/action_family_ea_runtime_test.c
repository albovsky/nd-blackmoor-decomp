/* RT-45 unit tests of the raw 0xea Onebuild puzzle kernel (src/action_family_ea_runtime.c). Prints
 * "PASS <name>" / "FAIL <name>: <message>"; the exit status is the failure count. Fixtures are synthetic bodies (no
 * original bytes). tests/test_action_family_ea_runtime.py builds and runs this with and without ASan/UBSan and under
 * source mutations. Expected values come from the disassembly of 0x4867bd and its helpers (see the header). */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_ea_runtime.h"

static const char *g_name;
static int g_failed, g_total, g_failures;
static char g_msg[512];
#define CHECK(cond)                                                        \
    do {                                                                   \
        if (!(cond) && !g_failed) {                                        \
            g_failed = 1;                                                  \
            snprintf(g_msg, sizeof g_msg, "line %d: %s", __LINE__, #cond); \
        }                                                                  \
    } while (0)
#define CHECK_HAS(fx, text)                                                                  \
    do {                                                                                     \
        if (strstr((fx)->log, (text)) == NULL && !g_failed) {                                \
            g_failed = 1;                                                                    \
            snprintf(g_msg, sizeof g_msg, "line %d: log lacks \"%s\" in \"%.140s\"", __LINE__, \
                     (text), (fx)->log);                                                     \
        }                                                                                    \
    } while (0)
#define CHECK_LACKS(fx, text)                                                                \
    do {                                                                                     \
        if (strstr((fx)->log, (text)) != NULL && !g_failed) {                                \
            g_failed = 1;                                                                    \
            snprintf(g_msg, sizeof g_msg, "line %d: log has \"%s\"", __LINE__, (text));      \
        }                                                                                    \
    } while (0)

/* Object offsets used by the assertions (the header documents them). */
enum {
    O_SLOT = 0x1c, O_ROW = 0x26, O_PIECES = 0x28, O_DRAG = 0xa92, O_DROP = 0xa96, O_LIFT = 0xa9a, O_HAND = 0xa9e,
    O_PREV = 0xaa0, O_MOVE = 0xab0, O_MOVE_T = 0xad0, O_SND_A = 0xb21, O_SND_B = 0xb52, O_PLACED_OK = 0xb83, O_DROP_SND = 0xb87,
    O_ACTIVE = 0xba7, O_EXIT = 0xbab, O_STATE = 0xbac, O_DONE = 0xbb0, O_CAPTION = 0xbc1, O_PW = 0xbc5, O_PH = 0xbc7,
    O_DEADLINE = 0xbc9, O_DEADLINE2 = 0xbcd, O_COUNT_UNPLACED = 0xbf9, O_COUNT_PLACED = 0xc23, O_PLACED_N = 0xc25,
    O_CLICK_ANIM = 0xc2b, O_FLAG_2F = 0xc2f, O_ANIM_COL = 0xc33, O_ANIM_FRAME = 0xc35, O_HAS_ANIM = 0xb8b,
    O_ANIM_REST = 0xb8f, O_ANIM_ON = 0xb93, O_ANIM_SRC = 0xb97, O_MULTI = 0x1e
};
enum { P_Z = 0, P_RECT = 2, P_RECT2 = 0x12, P_ORIENT = 0x22, P_PLACED = 0x23, P_ENT = 0x24, P_FLAG84 = 0x84 };

typedef struct Fx {
    EaObject obj;
    EaWorld world;
    EaHost host;
    uint8_t body[EA_BODY_BYTES];
    char log[4096];
    int fail_alloc, fail_load, fail_play, fail_flag;
    int32_t busy[8];
    int nbusy, ibusy;
    uint32_t ticks[16];
    int nticks, iticks;
    int32_t rands[8];
    int nrands, irands;
    int32_t captions;
    const char *autotext;
    uint32_t next_handle;
    int16_t dw[512], dh[512];
    int releases;
    int completes;
    uint32_t phase;
} Fx;

static void put16(uint8_t *b, size_t off, int v) { b[off] = (uint8_t)v; b[off + 1] = (uint8_t)(v >> 8); }
static void put32(uint8_t *b, size_t off, int32_t v)
{
    for (int i = 0; i < 4; ++i) b[off + (size_t)i] = (uint8_t)((uint32_t)v >> (8 * i));
}
static int16_t get16(const uint8_t *b, size_t off) { return (int16_t)(b[off] | (b[off + 1] << 8)); }
static int32_t get32(const uint8_t *b, size_t off)
{
    return (int32_t)((uint32_t)b[off] | ((uint32_t)b[off + 1] << 8) | ((uint32_t)b[off + 2] << 16) |
                     ((uint32_t)b[off + 3] << 24));
}

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

static int h_view(void *c, EaView *v)
{
    (void)c;
    v->origin_x = 10;
    v->origin_y = 20;
    v->clip[0] = 0;
    v->clip[1] = 0;
    v->clip[2] = 639;
    v->clip[3] = 479;
    return 0;
}
static int h_alloc(void *c, int16_t *slot)
{
    if (((Fx *)c)->fail_alloc) return 1;
    *slot = 0x18;
    return 0;
}
static int h_register(void *c, int16_t slot, const char *label) { logf_((Fx *)c, "reg:%d:%s", slot, label); return 0; }
static int h_release_slot(void *c, int16_t slot) { logf_((Fx *)c, "relslot:%d", slot); return 0; }
static int h_dirty(void *c, int16_t slot) { logf_((Fx *)c, "dirty:%d", slot); return 0; }
static int h_load(void *c, const char *name, const char *tag, uint32_t *s)
{
    Fx *f = (Fx *)c;
    if (f->fail_load) return 1;
    logf_(f, "load:%s:%s", name, tag);
    *s = 5u;
    return 0;
}
static int h_create(void *c, int16_t w, int16_t h, const char *tag, uint32_t *s)
{
    Fx *f = (Fx *)c;
    (void)tag;
    *s = f->next_handle++;
    f->dw[*s & 511u] = w;
    f->dh[*s & 511u] = h;
    logf_(f, "create:%dx%d=%u", w, h, *s);
    return 0;
}
static int h_blit(void *c, uint32_t src, uint32_t dst, const int32_t sr[4], const int32_t dr[4])
{
    logf_((Fx *)c, "blit:%u>%u:%d,%d,%d,%d>%d,%d,%d,%d", src, dst, sr[0], sr[1], sr[2], sr[3], dr[0], dr[1], dr[2], dr[3]);
    return 0;
}
static int h_copy(void *c, uint32_t dst, uint32_t src)
{
    Fx *f = (Fx *)c;
    f->dw[dst & 511u] = f->dw[src & 511u];
    f->dh[dst & 511u] = f->dh[src & 511u];
    logf_(f, "copy:%u<%u", dst, src);
    return 0;
}
/* The real 0x4c7070 swaps the surface's width and height; the entry sizes come from the swapped struct. */
static int h_rotate(void *c, uint32_t s, int16_t *w, int16_t *h)
{
    Fx *f = (Fx *)c;
    const int16_t t = f->dw[s & 511u];
    f->dw[s & 511u] = f->dh[s & 511u];
    f->dh[s & 511u] = t;
    *w = f->dw[s & 511u];
    *h = f->dh[s & 511u];
    return 0;
}
static int h_release(void *c, uint32_t s) { ((Fx *)c)->releases++; (void)s; return 0; }
static int h_clear(void *c) { logf_((Fx *)c, "clr"); return 0; }
static int h_prepare(void *c, uint32_t id, const uint8_t *rec) { logf_((Fx *)c, "prep:%x:%s", id, (const char *)rec); return 0; }
static int h_stop(void *c, uint32_t id, const uint8_t *rec) { logf_((Fx *)c, "stop:%x:%s", id, (const char *)rec); return 0; }
static int h_play(void *c, int16_t ch) { logf_((Fx *)c, "play:%d", ch); return ((Fx *)c)->fail_play; }
static int h_busy(void *c, int16_t ch, int32_t *r)
{
    Fx *f = (Fx *)c;
    *r = f->ibusy < f->nbusy ? f->busy[f->ibusy++] : 0;
    logf_(f, "busy:%d=%d", ch, *r);
    return 0;
}
static uint32_t h_tick(void *c)
{
    Fx *f = (Fx *)c;
    return f->iticks < f->nticks ? f->ticks[f->iticks++] : f->ticks[f->nticks - 1];
}
static int h_rand(void *c, int32_t *v)
{
    Fx *f = (Fx *)c;
    *v = f->irands < f->nrands ? f->rands[f->irands++] : 0;
    return 0;
}
static int h_captions(void *c, int32_t *e) { *e = ((Fx *)c)->captions; return 0; }
static int h_autotext(void *c, const char *key, const char **t)
{
    Fx *f = (Fx *)c;
    (void)key;
    *t = f->autotext;
    return 0;
}
static int h_caption(void *c, const char *text) { logf_((Fx *)c, "cap:%s", text); return 0; }
static int h_flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 100; }
static int h_transition(void *c, const EaTransition *t)
{
    logf_((Fx *)c, "scene:%d:%d:%d:%d:%d:%d:%d", t->scene, t->word[0], t->word[1], t->word[2], t->dword[0], t->dword[1],
          t->dword[2]);
    return 0;
}
static int h_store_flag(void *c, int16_t i, uint32_t v) { logf_((Fx *)c, "flag:%d=%u", i, v); return ((Fx *)c)->fail_flag; }
static int h_complete(void *c, int16_t row) { ((Fx *)c)->completes++; logf_((Fx *)c, "done:%d", row); return 0; }

static void set_name(uint8_t *b, size_t off, const char *s, size_t span)
{
    memset(b + off, 0, span);
    memcpy(b + off, s, strlen(s));
}

static void rect32(uint8_t *b, size_t off, int l, int t, int r, int bt)
{
    put32(b, off, l);
    put32(b, off + 4, t);
    put32(b, off + 8, r);
    put32(b, off + 12, bt);
}

/* A three-piece synthetic puzzle: piece i has rect A 40 x 30, no rect B, target rect C at (100 + 50 i, 100), start
 * rect D at (300 + 10 i, 200). The area rect covers the screen, tolerance 6, rotation by key allowed. */
static void build_body(uint8_t *b)
{
    static const size_t sound[] = {0x614, 0x645, 0x676, 0x6a7, 0x6d8, 0x709, 0x72a, 0x74b, 0x77c, 0x79d, 0xa79, 0xaaa, 0xacb, 0xdc4};
    memset(b, 0, EA_BODY_BYTES);
    set_name(b, 0, "PIECES", 0x21);
    put16(b, 0x21, 3);
    b[0x24] = 1;
    b[0x2a] = 1;
    put16(b, 0x2b, 6);
    put16(b, 0x26, 10);
    put16(b, 0x28, 10);
    for (int i = 0; i < 3; ++i) {
        const size_t p = 0x7f + (size_t)i * 0x42;
        rect32(b, p, 1, 1, 40, 30);
        rect32(b, p + 0x20, 100 + 50 * i, 100, 139 + 50 * i, 129);
        rect32(b, p + 0x30, 300 + 10 * i, 200, 339 + 10 * i, 229);
    }
    rect32(b, 0x5a7, 0, 0, 639, 479);
    set_name(b, 0x5c7, "NO_FILE", 0x21);
    for (size_t i = 0; i < sizeof sound / sizeof sound[0]; ++i) set_name(b, sound[i], "NO SOUND", 0x21);
    put16(b, 0xda7, 18);
    put16(b, 0xda9, 9);
    put16(b, 0xdab, 4242);
    put16(b, 0xdad, 1);
    put16(b, 0xdaf, 2);
    put16(b, 0xdb1, 3);
    put32(b, 0xdb3, 4);
    put32(b, 0xdb7, 5);
    put32(b, 0xdbb, 6);
    put16(b, 0xdbf, 1);
    put16(b, 0xdc1, 7);
    b[0xdc3] = 9;
    put16(b, 0xede, 9999);
    put16(b, 0xef4, -1);
    rect32(b, 0xef7, 600, 440, 639, 479);
    put16(b, 0xdc1 + 0x2d - 0x2d, 7);
}

static void fx_init(Fx *f)
{
    memset(f, 0, sizeof *f);
    ea_object_reset(&f->obj);
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
    f->host.rand_value = h_rand;
    f->host.captions_enabled = h_captions;
    f->host.autotext_lookup = h_autotext;
    f->host.caption_show = h_caption;
    f->host.event_flag_invalid = h_flag_invalid;
    f->host.transition = h_transition;
    f->host.store_event_flag = h_store_flag;
    f->host.complete = h_complete;
    f->next_handle = 100u;
    f->ticks[0] = 1000u;
    f->nticks = 1;
}

static int step(Fx *f, int16_t row)
{
    EaResult r;
    const int rc = ea_step(&f->obj, f->body, EA_BODY_BYTES, row, f->phase, &f->world, &f->host, &r, NULL);
    if (rc == EA_OK) f->phase = r.phase_after;
    return rc;
}

static int init_puzzle(Fx *f)
{
    f->phase = 0;
    return step(f, 2);
}

static int ptr(Fx *f, int x, int y, EaPointerResult *out)
{
    const int32_t rect[4] = {x - 8, y - 8, x + 8, y + 8};
    return ea_pointer_move(&f->obj, f->body, EA_BODY_BYTES, (int16_t)x, (int16_t)y, rect, &f->host, out);
}

static int click(Fx *f, int32_t candidate)
{
    uint32_t np = f->phase;
    const int rc = ea_click(&f->obj, f->body, EA_BODY_BYTES, f->phase, candidate, &f->host, &np);
    if (rc == EA_OK) f->phase = np;
    return rc;
}

static void t_phase0(void)
{
    Fx f;
    fx_init(&f);
    CHECK(init_puzzle(&f) == EA_OK);
    CHECK(f.phase == 1u);
    CHECK(f.world.start_flag_5bb1ca == 1);
    CHECK(get32(f.obj.b, O_ACTIVE) == 1 && get16(f.obj.b, O_ROW) == 2 && get16(f.obj.b, O_HAND) == -1);
    CHECK(get16(f.obj.b, O_SLOT) == 0x18);
    CHECK_HAS(&f, "clr,load:PIECES:DF Piece Source Surface,create:40x30=100,blit:5>100:1,1,40,30>0,0,39,29");
    CHECK_HAS(&f, "reg:24:ONEBUILD PUZZLE OVERLAYS");
    /* piece 1: start rect D plus the view origin (10, 20); entry 0 is 40 x 30 and rect A is the source */
    CHECK(get32(f.obj.b, O_PIECES + 0x85 + P_RECT) == 310 && get32(f.obj.b, O_PIECES + 0x85 + P_RECT + 4) == 200);
    CHECK(get32(f.obj.b, O_PIECES + 0x85 + P_RECT2) == 320 && get32(f.obj.b, O_PIECES + 0x85 + P_RECT2 + 4) == 220);
    CHECK(f.obj.b[O_PIECES + P_FLAG84] == 1 && get16(f.obj.b, O_PIECES + P_Z) == 0);
    CHECK(get16(f.obj.b, O_PIECES + P_ENT + 0x14) == 40 && get16(f.obj.b, O_PIECES + P_ENT + 0x16) == 30);
}

static void t_rotated_entries(void)
{
    Fx f;
    fx_init(&f);
    CHECK(init_puzzle(&f) == EA_OK);
    /* rotation allowed: entries 1..3 are copies whose width and height swap each time */
    CHECK_HAS(&f, "create:40x30=101,copy:101<100,create:30x40=102,copy:102<101,create:40x30=103,copy:103<102");
    CHECK(get16(f.obj.b, O_PIECES + P_ENT + 0x18 + 0x14) == 30 && get16(f.obj.b, O_PIECES + P_ENT + 0x18 + 0x16) == 40);
    CHECK(get32(f.obj.b, O_PIECES + P_ENT + 0x18 + 4 + 8) == 29 && get32(f.obj.b, O_PIECES + P_ENT + 0x18 + 4 + 12) == 39);
    CHECK(get16(f.obj.b, O_PIECES + P_ENT + 0x30 + 0x14) == 40);
}

static void t_loose_pieces_and_layers(void)
{
    Fx f;
    fx_init(&f);
    f.body[0x7f + 0x41] = 1; /* piece 0 starts placed */
    f.body[0x7f + 0x40] = 2;
    f.body[0x56] = 1;
    put16(f.body, 0x57, 2); /* layer table: piece number 2 sits at depth 0, piece 1 at depth 1 */
    put16(f.body, 0x59, 1);
    CHECK(init_puzzle(&f) == EA_OK);
    CHECK(get32(f.obj.b, O_PIECES + P_RECT) == 100 && get32(f.obj.b, O_PIECES + P_RECT + 4) == 100);
    CHECK(f.obj.b[O_PIECES + P_PLACED] == 1 && f.obj.b[O_PIECES + P_ORIENT] == 0);
    CHECK(get16(f.obj.b, O_PIECES + P_Z) == 1);
    CHECK(get32(f.obj.b, O_PIECES + P_ENT + 0x18) == 0); /* a placed piece has no rotated surfaces */
}

static void t_validation(void)
{
    uint8_t b[EA_BODY_BYTES];
    const char *why = NULL;
    build_body(b);
    CHECK(ea_validate_body(b, EA_BODY_BYTES, NULL) == EA_OK);
    CHECK(ea_validate_body(b, EA_BODY_BYTES - 1u, &why) == EA_ERR_BODY);
    put16(b, 0x21, 21);
    CHECK(ea_validate_body(b, EA_BODY_BYTES, &why) == EA_ERR_BODY && strcmp(why, "0xea-piece-count") == 0);
    put16(b, 0x21, 3);
    memset(b + 0x614, 'A', 0x21);
    CHECK(ea_validate_body(b, EA_BODY_BYTES, &why) == EA_ERR_BODY && strcmp(why, "0xea-unterminated-field") == 0);
    build_body(b);
    rect32(b, 0x5e8, 0, 0, 10, 10);
    CHECK(ea_validate_body(b, EA_BODY_BYTES, &why) == EA_ERR_BODY && strcmp(why, "0xea-grid-columns-zero") == 0);
    build_body(b);
    rect32(b, 0x7f, 1, 1, 1 + 5000, 30);
    CHECK(ea_validate_body(b, EA_BODY_BYTES, &why) == EA_ERR_BODY && strcmp(why, "0xea-piece-size") == 0);
    build_body(b);
    b[0x7f + 0x42 + 0x40] = 4; /* a start orientation names one of four entries */
    CHECK(ea_validate_body(b, EA_BODY_BYTES, &why) == EA_ERR_BODY && strcmp(why, "0xea-piece-orientation") == 0);
    b[0x7f + 0x42 + 0x40] = 3;
    CHECK(ea_validate_body(b, EA_BODY_BYTES, NULL) == EA_OK);
}

static void t_host_failures(void)
{
    Fx f;
    EaResult r;
    fx_init(&f);
    f.fail_alloc = 1;
    CHECK(init_puzzle(&f) == EA_ERR_HOST);
    fx_init(&f);
    f.fail_load = 1;
    CHECK(init_puzzle(&f) == EA_ERR_HOST);
    fx_init(&f);
    f.phase = 1; /* never initialised */
    CHECK(ea_step(&f.obj, f.body, EA_BODY_BYTES, 2, 1, &f.world, &f.host, &r, NULL) == EA_ERR_UNSUPPORTED);
    CHECK(ea_step(&f.obj, f.body, EA_BODY_BYTES, 2, 2, &f.world, &f.host, &r, NULL) == EA_ERR_UNSUPPORTED);
}

static void t_pointer_candidates(void)
{
    Fx f;
    EaPointerResult p;
    fx_init(&f);
    CHECK(init_puzzle(&f) == EA_OK);
    /* the hit test uses the untranslated piece rectangles (300..339, 310..349, 320..359 by 200..229) */
    CHECK(ptr(&f, 320, 210, &p) == EA_OK && p.hit == 1 && p.candidate == 0x2777 && p.cursor == 18 && p.cursor_flag == 1);
    CHECK(p.cursor_record == 0x5b161cu + 18u * 0x20u);
    CHECK(get16(f.obj.b, O_COUNT_UNPLACED) == 3);
    CHECK(ptr(&f, 355, 215, &p) == EA_OK && get16(f.obj.b, O_COUNT_UNPLACED) == 1);
    /* the piece rectangle edges are inclusive on all four sides */
    CHECK(ptr(&f, 339, 215, &p) == EA_OK && get16(f.obj.b, O_COUNT_UNPLACED) == 3);
    CHECK(ptr(&f, 300, 200, &p) == EA_OK && get16(f.obj.b, O_COUNT_UNPLACED) == 1);
    CHECK(ptr(&f, 300, 229, &p) == EA_OK && get16(f.obj.b, O_COUNT_UNPLACED) == 1);
    CHECK(ptr(&f, 299, 215, &p) == EA_OK && p.hit == 0 && ptr(&f, 300, 230, &p) == EA_OK && p.hit == 0);
    CHECK(ptr(&f, 639, 479, &p) == EA_OK && p.candidate == 0x2779 && ptr(&f, 600, 440, &p) == EA_OK && p.candidate == 0x2779);
    CHECK(ptr(&f, 620, 460, &p) == EA_OK && p.hit == 1 && p.candidate == 0x2779 && p.cursor == 9);
    CHECK(ptr(&f, 50, 50, &p) == EA_OK && p.hit == 0 && p.candidate == -1 && p.wrote_cursor == 0);
    /* rotation locked to the zone (both flags): the 10 x 10 corner of a piece is the rotate zone, the rest picks */
    f.body[0x25] = 1;
    CHECK(ptr(&f, 320, 210, &p) == EA_OK && p.candidate == 0x2778 && p.cursor == 0x14 && p.cursor_flag == 0);
    CHECK(p.cursor_record == 0x5b188cu && get16(f.obj.b, O_COUNT_PLACED) == 2);
    CHECK(ptr(&f, 305, 225, &p) == EA_OK && p.candidate == 0x2777);
}

static void t_pick_drag_drop(void)
{
    Fx f;
    EaPointerResult p;
    fx_init(&f);
    set_name(f.body, 0x6a7, "Pick", 0x21);
    put16(f.body, 0x6a7 + 0x21, 3);
    set_name(f.body, 0x6d8, "Drop", 0x21);
    put16(f.body, 0x6d8 + 0x21, 4);
    f.ticks[0] = 5000u;
    CHECK(init_puzzle(&f) == EA_OK);
    CHECK(ptr(&f, 355, 215, &p) == EA_OK && p.candidate == 0x2777);
    f.log[0] = 0;
    CHECK(click(&f, 0x2777) == EA_OK);
    CHECK_HAS(&f, "prep:10b52:Pick,play:3");
    CHECK(get32(f.obj.b, O_STATE) == 1 && get32(f.obj.b, O_DEADLINE) == 5300 && get32(f.obj.b, O_DROP_SND) == 0);
    CHECK(get32(f.obj.b, O_DRAG) == 1 && get16(f.obj.b, O_HAND) == 2); /* only piece 2 reaches x = 355 */
    CHECK(get32(f.obj.b, O_LIFT) == 1 && get16(f.obj.b, O_PW) == 39 && get16(f.obj.b, O_PH) == 29);
    /* a click while the pick sound plays is ignored; once its deadline passes the machine returns to idle */
    CHECK(click(&f, 0x2777) == EA_OK && get32(f.obj.b, O_STATE) == 1);
    f.ticks[0] = 5299u;
    CHECK(step(&f, 2) == EA_OK && get32(f.obj.b, O_STATE) == 1);
    f.ticks[0] = 5300u;
    f.log[0] = 0;
    CHECK(step(&f, 2) == EA_OK && get32(f.obj.b, O_STATE) == 0);
    CHECK_HAS(&f, "stop:10b52:Pick");
    /* the held piece follows the pointer rectangle centre; piece 2's target is (200,100)..(239,129) */
    CHECK(ptr(&f, 219, 114, &p) == EA_OK && p.candidate == 0x277a); /* the previous rectangle is still empty */
    CHECK(ptr(&f, 219, 114, &p) == EA_OK && p.hit == 1 && p.candidate == 0x277b);
    CHECK(get32(f.obj.b, O_MOVE) == 200 && get32(f.obj.b, O_MOVE + 4) == 100);
    CHECK(get32(f.obj.b, O_MOVE_T) == 210 && get32(f.obj.b, O_MOVE_T + 4) == 120);
    f.log[0] = 0;
    CHECK(click(&f, 0x277b) == EA_OK);
    CHECK(f.obj.b[O_PIECES + 2 * 0x85 + P_PLACED] == 1 && get32(f.obj.b, O_PLACED_OK) == 1 && get16(f.obj.b, O_PLACED_N) == 1);
    CHECK(get32(f.obj.b, O_DRAG) == 0 && get32(f.obj.b, O_DROP) == 1 && get16(f.obj.b, O_HAND) == -1);
    CHECK(get32(f.obj.b, O_PIECES + 2 * 0x85 + P_RECT) == 200 && get32(f.obj.b, O_PIECES + 2 * 0x85 + P_RECT2) == 210);
    CHECK(get32(f.obj.b, O_DROP_SND) == 1 && get32(f.obj.b, O_STATE) == 1);
    CHECK_HAS(&f, "prep:10b52:Drop,play:4");
    CHECK(get16(f.obj.b, O_PIECES + 2 * 0x85 + P_Z) == 1); /* no other piece overlaps: layer 0 + 1 */
}

static void t_drop_outside_restores(void)
{
    Fx f;
    EaPointerResult p;
    fx_init(&f);
    CHECK(init_puzzle(&f) == EA_OK);
    CHECK(ptr(&f, 355, 215, &p) == EA_OK);
    CHECK(click(&f, 0x2777) == EA_OK);
    CHECK(ptr(&f, 500, 300, &p) == EA_OK && p.candidate == 0x277a); /* far from the target rectangle */
    /* below the clip rectangle the moving rectangle is pushed back up, keeping its size */
    CHECK(ptr(&f, 500, 475, &p) == EA_OK);
    CHECK(get32(f.obj.b, O_MOVE + 12) == 479 && get32(f.obj.b, O_MOVE + 4) == 450);
    CHECK(ptr(&f, 5, 300, &p) == EA_OK && get32(f.obj.b, O_MOVE) == 0 && get32(f.obj.b, O_MOVE + 8) == 39);
    CHECK(ptr(&f, 500, 300, &p) == EA_OK);
    CHECK(ptr(&f, 500, 300, &p) == EA_OK && p.candidate == 0x277a);
    CHECK(click(&f, 0x277a) == EA_OK);
    CHECK(f.obj.b[O_PIECES + 2 * 0x85 + P_PLACED] == 0 && get32(f.obj.b, O_PLACED_OK) == 0 && get16(f.obj.b, O_PLACED_N) == 0);
    /* flag 0x23 clear: the piece takes the previous moving rectangle back */
    CHECK(get32(f.obj.b, O_PIECES + 2 * 0x85 + P_RECT) == get32(f.obj.b, O_PREV));
    CHECK(f.obj.b[O_PIECES + 2 * 0x85 + P_FLAG84] == 1);
    /* flag 0x23 set: back to the start rectangle (rect D) and the start orientation */
    fx_init(&f);
    f.body[0x23] = 1;
    CHECK(init_puzzle(&f) == EA_OK);
    CHECK(ptr(&f, 355, 215, &p) == EA_OK && click(&f, 0x2777) == EA_OK);
    CHECK(ptr(&f, 500, 300, &p) == EA_OK && ptr(&f, 500, 300, &p) == EA_OK && click(&f, 0x277a) == EA_OK);
    CHECK(get32(f.obj.b, O_PIECES + 2 * 0x85 + P_RECT) == 320 && get32(f.obj.b, O_PIECES + 2 * 0x85 + P_RECT2) == 330);
    CHECK(f.obj.b[O_PIECES + 2 * 0x85 + P_FLAG84] == 0);
}

static void t_top_piece_by_layer(void)
{
    Fx f;
    EaPointerResult p;
    fx_init(&f);
    CHECK(init_puzzle(&f) == EA_OK);
    put16(f.obj.b, O_PIECES + 2 * 0x85 + P_Z, 5);
    put16(f.obj.b, O_PIECES + 1 * 0x85 + P_Z, 3);
    CHECK(ptr(&f, 325, 215, &p) == EA_OK && get16(f.obj.b, O_COUNT_UNPLACED) == 3);
    CHECK(click(&f, 0x2777) == EA_OK && get16(f.obj.b, O_HAND) == 2); /* the greatest layer wins */
    fx_init(&f);
    CHECK(init_puzzle(&f) == EA_OK);
    CHECK(ptr(&f, 325, 215, &p) == EA_OK && click(&f, 0x2777) == EA_OK && get16(f.obj.b, O_HAND) == 0); /* ties: the first */
}

static void t_ordered_mode(void)
{
    Fx f;
    EaPointerResult p;
    fx_init(&f);
    f.body[0x2d] = 1;
    put16(f.body, 0x2e, 1); /* the first piece to place must be piece number 1 (index 0) */
    CHECK(init_puzzle(&f) == EA_OK);
    CHECK(ptr(&f, 355, 215, &p) == EA_OK);
    CHECK(click(&f, 0x2777) == EA_OK);
    CHECK(get16(f.obj.b, O_HAND) == 2);
    CHECK(ptr(&f, 219, 114, &p) == EA_OK);
    CHECK(ptr(&f, 219, 114, &p) == EA_OK && p.candidate == 0x277b);
    CHECK(click(&f, 0x277b) == EA_OK);
    /* piece 2 is not the expected piece: it goes back like a bad drop */
    CHECK(f.obj.b[O_PIECES + 2 * 0x85 + P_PLACED] == 0 && get32(f.obj.b, O_PLACED_OK) == 0 && get16(f.obj.b, O_PLACED_N) == 0);
    /* the expected piece is accepted */
    CHECK(ptr(&f, 305, 215, &p) == EA_OK && click(&f, 0x2777) == EA_OK && get16(f.obj.b, O_HAND) == 0);
    CHECK(ptr(&f, 119, 114, &p) == EA_OK && ptr(&f, 119, 114, &p) == EA_OK && p.candidate == 0x277b);
    CHECK(click(&f, 0x277b) == EA_OK && f.obj.b[O_PIECES + P_PLACED] == 1 && get16(f.obj.b, O_PLACED_N) == 1);
}

static void t_rotate_key(void)
{
    Fx f;
    EaPointerResult p;
    fx_init(&f);
    CHECK(init_puzzle(&f) == EA_OK);
    CHECK(ptr(&f, 355, 215, &p) == EA_OK);
    CHECK(get16(f.obj.b, O_COUNT_UNPLACED) == 1);
    CHECK(ea_rotate_key(&f.obj, f.body, EA_BODY_BYTES, f.phase, &f.host) == EA_OK);
    CHECK(f.obj.b[O_PIECES + 2 * 0x85 + P_ORIENT] == 1 && get32(f.obj.b, O_DRAG) == 1 && get16(f.obj.b, O_HAND) == 2);
    /* the piece turns about its centre: 40 x 30 becomes 30 x 40 */
    CHECK(get16(f.obj.b, O_PW) == 29 && get16(f.obj.b, O_PH) == 39);
    /* the 40 x 30 piece at (320,200) turns about its centre (340,215) into 30 x 40 at (325,195) */
    CHECK(get32(f.obj.b, O_PIECES + 2 * 0x85 + P_RECT) == 325 && get32(f.obj.b, O_PIECES + 2 * 0x85 + P_RECT + 4) == 195);
    CHECK(get32(f.obj.b, O_PIECES + 2 * 0x85 + P_RECT + 8) == 354 && get32(f.obj.b, O_PIECES + 2 * 0x85 + P_RECT + 12) == 234);
    for (int i = 0; i < 3; ++i) CHECK(ea_rotate_key(&f.obj, f.body, EA_BODY_BYTES, f.phase, &f.host) == EA_OK);
    CHECK(f.obj.b[O_PIECES + 2 * 0x85 + P_ORIENT] == 0); /* four turns wrap back */
    f.body[0x25] = 1; /* rotation locked to the zone: the key does nothing */
    CHECK(ea_rotate_key(&f.obj, f.body, EA_BODY_BYTES, f.phase, &f.host) == EA_OK && f.obj.b[O_PIECES + 2 * 0x85 + P_ORIENT] == 0);
}

static void place_all(Fx *f)
{
    EaPointerResult p;
    for (int i = 0; i < 3; ++i) {
        CHECK(ptr(f, 305 + 10 * i, 215, &p) == EA_OK);
        CHECK(click(f, 0x2777) == EA_OK);
        {
            const int hand = get16(f->obj.b, O_HAND);
            const int dx = 119 + 50 * hand;
            CHECK(hand == i);
            CHECK(ptr(f, dx, 114, &p) == EA_OK);
            CHECK(ptr(f, dx, 114, &p) == EA_OK && p.candidate == 0x277b);
            CHECK(click(f, 0x277b) == EA_OK);
        }
    }
}

static void t_solve_and_finish(void)
{
    Fx f;
    fx_init(&f);
    CHECK(init_puzzle(&f) == EA_OK);
    place_all(&f);
    CHECK(get16(f.obj.b, O_PLACED_N) == 3);
    /* force the end state: every piece placed, the exit-area click arrives and the idle state runs the solved check */
    for (int i = 0; i < 3; ++i) f.obj.b[O_PIECES + (size_t)i * 0x85 + P_PLACED] = 1;
    put32(f.obj.b, O_CLICK_ANIM, 1);
    CHECK(step(&f, 2) == EA_OK);
    CHECK(get32(f.obj.b, O_STATE) == 6 && f.obj.b[O_DONE] == 1);
    CHECK(step(&f, 2) == EA_OK); /* state 6: the win record is "NO SOUND": straight to phase 2 */
    CHECK(f.phase == 2u);
    f.log[0] = 0;
    CHECK(step(&f, 2) == EA_OK);
    CHECK(f.phase == 0u && f.completes == 1);
    CHECK_HAS(&f, "scene:4242:1:2:3:4:5:6");
    CHECK_HAS(&f, "flag:7=9");
    CHECK_HAS(&f, "done:2");
    CHECK(f.world.start_flag_5bb1ca == 0); /* the start-flag word is 1, so the flag becomes 0 */
    CHECK(get16(f.obj.b, O_SLOT) == -1 && get32(f.obj.b, O_ACTIVE) == 0 && get16(f.obj.b, O_ROW) == -1);
    CHECK(f.releases == 1 + 12); /* the source image and the 12 piece surfaces (3 pieces x 4 entries) */
    CHECK_HAS(&f, "relslot:24");
}

static void t_win_sound_path(void)
{
    Fx f;
    fx_init(&f);
    set_name(f.body, 0xdc4, "Win", 0x21);
    put16(f.body, 0xdc4 + 0x21, 9);
    f.captions = 1;
    set_name(f.body, 0xdf5, "KEY", 0x21);
    set_name(f.body, 0xe16, "fallback", 200);
    CHECK(init_puzzle(&f) == EA_OK);
    for (int i = 0; i < 3; ++i) f.obj.b[O_PIECES + (size_t)i * 0x85 + P_PLACED] = 1;
    put32(f.obj.b, O_CLICK_ANIM, 1);
    CHECK(step(&f, 2) == EA_OK && get32(f.obj.b, O_STATE) == 6);
    f.log[0] = 0;
    CHECK(step(&f, 2) == EA_OK && get32(f.obj.b, O_STATE) == 5 && f.phase == 1u);
    CHECK_HAS(&f, "prep:dc4:Win,play:9,cap:fallback<e>");
    f.autotext = "from autotext";
    put32(f.obj.b, O_STATE, 6);
    f.log[0] = 0;
    CHECK(step(&f, 2) == EA_OK);
    CHECK_HAS(&f, "cap:from autotext<e>");
    CHECK_LACKS(&f, "fallback");
    f.busy[0] = 1;
    f.nbusy = 1;
    f.ibusy = 0;
    CHECK(step(&f, 2) == EA_OK && f.phase == 1u); /* the win sound is still busy */
    CHECK(step(&f, 2) == EA_OK && f.phase == 2u);
}

static void t_exit_button(void)
{
    Fx f;
    EaPointerResult p;
    fx_init(&f);
    CHECK(init_puzzle(&f) == EA_OK);
    CHECK(ptr(&f, 620, 460, &p) == EA_OK && p.candidate == 0x2779);
    CHECK(click(&f, 0x2779) == EA_OK && f.phase == 2u && f.obj.b[O_EXIT] == 1);
    f.log[0] = 0;
    CHECK(step(&f, 2) == EA_OK && f.phase == 0u);
    CHECK_LACKS(&f, "scene:"); /* the exit block names scene 9999 and flag index -1 */
    CHECK_LACKS(&f, "flag:");
    CHECK_HAS(&f, "done:2");
    CHECK(f.world.start_flag_5bb1ca == 1); /* phase 2 stores the start flag even when no scene change follows */
}

static void t_feedback_and_captions(void)
{
    Fx f;
    EaPointerResult p;
    fx_init(&f);
    set_name(f.body, 0x74b, "Good", 0x21);
    put16(f.body, 0x76c, 6);
    set_name(f.body, 0x7be, "K0", 0x21);
    set_name(f.body, 0x821, "text zero", 200);
    set_name(f.body, 0x6d8, "Drop", 0x21);
    put16(f.body, 0x6d8 + 0x21, 4);
    f.captions = 1;
    f.ticks[0] = 100u;
    f.rands[0] = 3; /* 3 % 3 = 0: the first record, no alternate */
    f.nrands = 1;
    CHECK(init_puzzle(&f) == EA_OK);
    CHECK(ptr(&f, 355, 215, &p) == EA_OK);
    CHECK(click(&f, 0x2777) == EA_OK);
    CHECK(ptr(&f, 219, 114, &p) == EA_OK);
    CHECK(ptr(&f, 219, 114, &p) == EA_OK);
    CHECK(click(&f, 0x277b) == EA_OK);
    f.log[0] = 0;
    f.ticks[0] = 100u + 300u;
    CHECK(step(&f, 2) == EA_OK);
    CHECK_HAS(&f, "stop:10b52:Drop,prep:10b21:Good,play:6,cap:text zero<e>");
    CHECK(get32(f.obj.b, O_STATE) == 2 && get32(f.obj.b, O_CAPTION) == 1 && get32(f.obj.b, O_DEADLINE) == 400 + 2000);
    f.log[0] = 0;
    f.ticks[0] = 9000u;
    CHECK(step(&f, 2) == EA_OK); /* the good sound is not busy: the caption is cleared and the state returns to idle */
    CHECK_HAS(&f, "stop:10b21:Good,cap:<n><e>");
    CHECK(get32(f.obj.b, O_STATE) == 0 && get32(f.obj.b, O_CAPTION) == 0);
}

static void t_alternate_sound_reroll(void)
{
    Fx f;
    EaPointerResult p;
    fx_init(&f);
    set_name(f.body, 0x6d8, "Drop", 0x21);
    put16(f.body, 0x6d8 + 0x21, 4);
    set_name(f.body, 0x72a, "Alt2", 0x21);
    /* first draw 1 -> alternate 1 is "NO SOUND": re-draw 2 -> alternate 2 is used */
    f.rands[0] = 1;
    f.rands[1] = 2;
    f.nrands = 2;
    CHECK(init_puzzle(&f) == EA_OK);
    CHECK(ptr(&f, 355, 215, &p) == EA_OK);
    CHECK(click(&f, 0x2777) == EA_OK);
    CHECK(ptr(&f, 500, 300, &p) == EA_OK);
    CHECK(ptr(&f, 500, 300, &p) == EA_OK);
    f.log[0] = 0;
    CHECK(click(&f, 0x277a) == EA_OK);
    CHECK_HAS(&f, "prep:10b52:Alt2,play:4");
    CHECK(f.irands == 2);
    /* draw 2 with alternate 2 unusable: draw again, 1 with alternate 1 usable */
    fx_init(&f);
    set_name(f.body, 0x6d8, "Drop", 0x21);
    put16(f.body, 0x6d8 + 0x21, 4);
    set_name(f.body, 0x709, "Alt1", 0x21);
    f.rands[0] = 2;
    f.rands[1] = 1;
    f.nrands = 2;
    CHECK(init_puzzle(&f) == EA_OK);
    CHECK(ptr(&f, 355, 215, &p) == EA_OK && click(&f, 0x2777) == EA_OK);
    CHECK(ptr(&f, 500, 300, &p) == EA_OK && ptr(&f, 500, 300, &p) == EA_OK);
    f.log[0] = 0;
    CHECK(click(&f, 0x277a) == EA_OK);
    CHECK_HAS(&f, "prep:10b52:Alt1,play:4");
    CHECK(f.irands == 2);
}

static void t_invalidate_and_cleanup(void)
{
    Fx f;
    fx_init(&f);
    CHECK(ea_invalidate(&f.obj, &f.host) == EA_OK && strstr(f.log, "dirty") == NULL); /* inactive: nothing */
    CHECK(init_puzzle(&f) == EA_OK);
    CHECK(ea_invalidate(&f.obj, &f.host) == EA_OK);
    CHECK_HAS(&f, "dirty:24");
    CHECK(ea_cleanup(&f.obj, &f.host) == EA_OK && get16(f.obj.b, O_SLOT) == -1 && get32(f.obj.b, O_ACTIVE) == 0);
    CHECK(ea_cleanup(&f.obj, &f.host) == EA_OK); /* idempotent */
}

static void t_render_plan(void)
{
    Fx f;
    EaPointerResult p;
    EaRenderPlan plan;
    fx_init(&f);
    CHECK(init_puzzle(&f) == EA_OK);
    CHECK(ea_render_plan(&f.obj, f.body, EA_BODY_BYTES, &f.host, &plan) == EA_OK && plan.valid == 1);
    CHECK(plan.count == 3); /* all pieces at layer 0, drawn from the entry surfaces */
    CHECK(plan.blit[0].kind == 1 && plan.blit[0].src_kind == 3 && plan.blit[0].src_surface == 100u);
    CHECK(plan.blit[0].dst[0] == 310 && plan.blit[0].dst[1] == 220); /* piece 0: start rectangle plus the view origin */
    /* picking a piece draws the restore rectangle and the saved piece area, then the others, then the held piece */
    CHECK(ptr(&f, 355, 215, &p) == EA_OK && click(&f, 0x2777) == EA_OK);
    CHECK(ea_render_plan(&f.obj, f.body, EA_BODY_BYTES, &f.host, &plan) == EA_OK);
    CHECK(plan.count == 1 + 1 + 2 + 1); /* lift restore, 2 pieces left on the board, the held piece */
    CHECK(plan.blit[0].kind == 0 && plan.blit[0].src_kind == 0);
    CHECK(plan.blit[plan.count - 1].kind == 1 && plan.blit[plan.count - 1].src_kind == 3);
    CHECK(get32(f.obj.b, O_LIFT) == 0); /* consumed */
    /* the held piece is still dragging: the previous-rectangle restore, two pieces and the held piece */
    CHECK(ea_render_plan(&f.obj, f.body, EA_BODY_BYTES, &f.host, &plan) == EA_OK && plan.count == 4);
    ea_object_reset(&f.obj);
    CHECK(ea_render_plan(&f.obj, f.body, EA_BODY_BYTES, &f.host, &plan) == EA_OK && plan.valid == 0);
}

static void t_exit_area_wait(void)
{
    Fx f;
    fx_init(&f);
    set_name(f.body, 0x645, "Tick", 0x21);
    put16(f.body, 0x666, 8);
    rect32(f.body, 0x7f + 0x20, 100, 100, 139, 129); /* a nonzero target keeps piece 0 required */
    f.ticks[0] = 7000u;
    CHECK(init_puzzle(&f) == EA_OK);
    CHECK(click(&f, 0x277c) == EA_OK && get32(f.obj.b, O_CLICK_ANIM) == 1);
    f.log[0] = 0;
    CHECK(step(&f, 2) == EA_OK); /* idle, no animation, pieces still loose: the done sound and an 800 ms wait */
    CHECK(get32(f.obj.b, O_STATE) == 4 && f.obj.b[O_DONE] == 0 && get32(f.obj.b, O_FLAG_2F) == 1);
    CHECK(get32(f.obj.b, O_DEADLINE2) == 7800 && get32(f.obj.b, O_CLICK_ANIM) == 0);
    CHECK_HAS(&f, "prep:645:Tick,play:8");
    f.ticks[0] = 7799u;
    CHECK(step(&f, 2) == EA_OK && get32(f.obj.b, O_STATE) == 4);
    f.ticks[0] = 7800u;
    CHECK(step(&f, 2) == EA_OK && get32(f.obj.b, O_STATE) == 0 && get32(f.obj.b, O_FLAG_2F) == 0);
    /* a click while the puzzle waits is ignored */
    put32(f.obj.b, O_STATE, 4);
    CHECK(click(&f, 0x277c) == EA_OK && get32(f.obj.b, O_CLICK_ANIM) == 0);
}

static void t_animation(void)
{
    Fx f;
    int steps = 0;
    fx_init(&f);
    set_name(f.body, 0x5c7, "Anim", 0x21);
    rect32(f.body, 0x5e8, 500, 100, 539, 139);
    put16(f.body, 0x608, 2); /* rows */
    put16(f.body, 0x60a, 2); /* columns */
    put16(f.body, 0x60c, 3);
    put16(f.body, 0x60e, 4);
    put16(f.body, 0x610, 1); /* gap */
    put16(f.body, 0x612, 2); /* repeats */
    f.ticks[0] = 100u;
    CHECK(init_puzzle(&f) == EA_OK);
    CHECK(get32(f.obj.b, O_HAS_ANIM) == 1 && get32(f.obj.b, O_MULTI) == 5);
    CHECK_HAS(&f, "load:Anim:Multi Anim Surface");
    CHECK(click(&f, 0x277c) == EA_OK);
    f.ticks[0] = 200u;
    CHECK(step(&f, 2) == EA_OK && get32(f.obj.b, O_STATE) == 3 && get32(f.obj.b, O_DEADLINE2) == 300);
    CHECK(step(&f, 2) == EA_OK); /* first frame: cell (0,0) */
    CHECK(get32(f.obj.b, O_STATE) == 4 && get32(f.obj.b, O_ANIM_ON) == 1 && get16(f.obj.b, O_ANIM_FRAME) == 1);
    CHECK(get32(f.obj.b, O_ANIM_SRC) == 3 && get32(f.obj.b, O_ANIM_SRC + 4) == 4);
    CHECK(get32(f.obj.b, O_ANIM_SRC + 8) == 3 + 39 && get32(f.obj.b, O_ANIM_SRC + 12) == 4 + 39);
    f.ticks[0] = 300u;
    CHECK(step(&f, 2) == EA_OK && get32(f.obj.b, O_STATE) == 3 && get32(f.obj.b, O_DEADLINE2) == 400);
    CHECK(step(&f, 2) == EA_OK); /* second frame: column 1 of row 0 */
    CHECK(get32(f.obj.b, O_ANIM_SRC) == 3 + 40 && get32(f.obj.b, O_ANIM_SRC + 4) == 4);
    for (; steps < 60 && get32(f.obj.b, O_ANIM_REST) == 0; ++steps) {
        f.ticks[0] += 100u;
        CHECK(step(&f, 2) == EA_OK);
    }
    /* 2 rows x 2 columns x 2 repeats = 8 frames, then the strip rests and the check/done sound follows */
    CHECK(steps == 14 && get32(f.obj.b, O_ANIM_ON) == 0 && get16(f.obj.b, O_ANIM_COL) == 0);
    CHECK(get32(f.obj.b, O_DEADLINE2) == (int32_t)(f.ticks[0] + 800u));
    CHECK(get32(f.obj.b, O_STATE) == 4 && get32(f.obj.b, O_FLAG_2F) == 1 && f.obj.b[O_DONE] == 0);
    {
        EaRenderPlan plan;
        CHECK(ea_render_plan(&f.obj, f.body, EA_BODY_BYTES, &f.host, &plan) == EA_OK);
        CHECK(plan.blit[plan.count - 1].kind == 0 && plan.blit[plan.count - 1].src_kind == 0); /* the rest blit */
        CHECK(get32(f.obj.b, O_ANIM_REST) == 0);
    }
}

typedef void (*TestFn)(void);
static const struct { const char *name; TestFn fn; } tests[] = {
    {"phase0_builds_pieces", t_phase0},
    {"rotated_entries", t_rotated_entries},
    {"loose_pieces_and_layers", t_loose_pieces_and_layers},
    {"body_validation", t_validation},
    {"host_failures_and_phase_guards", t_host_failures},
    {"pointer_candidates", t_pointer_candidates},
    {"pick_drag_drop", t_pick_drag_drop},
    {"drop_outside_restores", t_drop_outside_restores},
    {"top_piece_by_layer", t_top_piece_by_layer},
    {"ordered_mode", t_ordered_mode},
    {"rotate_key", t_rotate_key},
    {"solve_and_finish", t_solve_and_finish},
    {"win_sound_path", t_win_sound_path},
    {"exit_button", t_exit_button},
    {"feedback_and_captions", t_feedback_and_captions},
    {"alternate_sound_reroll", t_alternate_sound_reroll},
    {"invalidate_and_cleanup", t_invalidate_and_cleanup},
    {"exit_area_wait", t_exit_area_wait},
    {"animation_strip", t_animation},
    {"render_plan", t_render_plan},
};

int main(void)
{
    for (size_t i = 0; i < sizeof tests / sizeof tests[0]; ++i) {
        g_name = tests[i].name;
        g_failed = 0;
        g_msg[0] = '\0';
        tests[i].fn();
        ++g_total;
        if (g_failed) {
            ++g_failures;
            printf("FAIL %s: %s\n", g_name, g_msg);
        } else {
            printf("PASS %s\n", g_name);
        }
    }
    printf("TOTAL %d FAILED %d\n", g_total, g_failures);
    return g_failures;
}
