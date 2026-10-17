/* RT-56 corpus check: runs every raw 0xeb row of the decoded scene resources given on the command line (in the owned game
 * those are the one row each of resources 1600 and 2305) through the production parser, the session binding and the kernel
 * with a scripted host. Every number the script uses is read from the row itself (type count, rects, flags, spawn bytes), so
 * the same script plays whatever the row declares.
 *
 * Pass 0 plays the puzzle as a player does: the pointer is moved over an unplaced piece (candidate PICK), the release picks
 * it up (for a Multi_Piece row twice: first the source piece, then its copy), the pointer is scanned over the drop area until
 * the kernel reports a drop hit, the second button rotates the piece in hand once when the row allows rotation, and the
 * release drops it. A piece of a forbidden type is dropped outside the area (a bad drop sends it home). When every piece is
 * placed (or the copies the target asks for exist) the exit button is released; the finish applies the win or exit scene block
 * (derived from the row) and reports the generic completion. Pass 1 places one piece, releases the exit button, checks the
 * saved puzzle state and enters the same row again (the persist byte decides whether the pieces come back). Pass 2 is the
 * exit button right after phase 0.
 *
 * Output is derived counts only: one "ROW_FAIL ..." line per failing row and a final "SUMMARY ..." line. Resource bytes stay in
 * work/ and are never printed. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_aeb.h"

/* Raw offsets, written down here independently of the kernel (see the kernel header comment). */
enum {
    O_ROW = 0x1e, O_COUNTS = 0x7a0, O_PIECES = 0x7b4, O_DRAG = 0x1344, O_HAND = 0x1350, O_COUNT = 0x13a2, O_MULTI_HAND = 0x13b1, O_HW = 0x13e3, O_HH = 0x13e5,
    O_ACTIVE = 0x13c5, O_STATE = 0x13ca, O_DONE = 0x13ce, O_HIT = 0x13df, O_COUNT1 = 0x1417,
    P_RECT = 2, P_ORIENT = 0x22, P_TYPE = 0x23, P_STAMP = 0x24, PIECE_STRIDE = 0x25
};
enum {
    B_PERSIST = 0x42, B_NTYPES = 0x43, B_TARGET = 0x45, B_ROT = 0x48, B_AREA = 0x4e, B_TYPES = 0x99, BT_SPAWN = 0x50, BT_REQ = 0x51,
    BT_FORBID = 0x52, B_WIN = 0x8c8, B_EXIT = 0x9fb, B_BTN_A = 0xa14, B_FLAG = 0x16
};

typedef struct {
    int allocs, registers, slot_releases, loads, creates, copies, rotates, releases, blits, sounds, stops, busy_calls, clears;
    int transitions, flag_stores, completes, captions, store_world_calls;
    int16_t last_scene, last_flag, last_complete;
    uint32_t now, next_handle;
    int16_t dw[4096], dh[4096];
    int scene_cell;
} Ctx;

static Ctx g_ctx;

static int h_view(void *c, EbView *v)
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
static int h_alloc(void *c, int16_t *s) { (void)c; ((Ctx *)c)->allocs++; *s = 0x18; return 0; }
static int h_register(void *c, int16_t s, const char *label)
{
    (void)s;
    ((Ctx *)c)->registers++;
    return strcmp(label, "MULTIBUILD PUZZLE OVERLAYS") != 0;
}
static int h_release_slot(void *c, int16_t s) { (void)s; ((Ctx *)c)->slot_releases++; return 0; }
static int h_dirty(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int h_load(void *c, const char *name, const char *tag, uint32_t *s)
{
    Ctx *x = (Ctx *)c;
    (void)tag;
    x->loads++;
    *s = name[0] != '\0' ? x->next_handle++ : 0u;
    x->dw[*s & 4095u] = 100;
    x->dh[*s & 4095u] = 100;
    return 0;
}
static int h_create(void *c, int16_t w, int16_t h, const char *tag, uint32_t *s)
{
    Ctx *x = (Ctx *)c;
    x->creates++;
    *s = x->next_handle++;
    x->dw[*s & 4095u] = w;
    x->dh[*s & 4095u] = h;
    return strcmp(tag, "pDFSurface for Multibuild Puzzle Piece") != 0;
}
static int h_blit(void *c, uint32_t a, uint32_t b, const int32_t sr[4], const int32_t dr[4])
{
    (void)a; (void)b; (void)sr; (void)dr;
    ((Ctx *)c)->blits++;
    return 0;
}
static int h_copy(void *c, uint32_t dst, uint32_t src)
{
    Ctx *x = (Ctx *)c;
    x->copies++;
    x->dw[dst & 4095u] = x->dw[src & 4095u];
    x->dh[dst & 4095u] = x->dh[src & 4095u];
    return 0;
}
static int h_rotate(void *c, uint32_t s, int16_t *w, int16_t *h)
{
    Ctx *x = (Ctx *)c;
    const int16_t t = x->dw[s & 4095u];
    x->rotates++;
    x->dw[s & 4095u] = x->dh[s & 4095u];
    x->dh[s & 4095u] = t;
    *w = x->dw[s & 4095u];
    *h = x->dh[s & 4095u];
    return 0;
}
static int h_release(void *c, uint32_t s) { (void)s; ((Ctx *)c)->releases++; return 0; }
static int h_clear(void *c) { ((Ctx *)c)->clears++; return 0; }
static int h_prepare(void *c, uint32_t id, const uint8_t *r) { (void)c; (void)id; (void)r; return 0; }
static int h_stop(void *c, uint32_t id, const uint8_t *r) { (void)id; (void)r; ((Ctx *)c)->stops++; return 0; }
static int h_play(void *c, int16_t ch) { (void)ch; ((Ctx *)c)->sounds++; return 0; }
static int h_busy(void *c, int16_t ch, int32_t *r) { (void)ch; ((Ctx *)c)->busy_calls++; *r = 0; return 0; }
static uint32_t h_tick(void *c) { return ((Ctx *)c)->now; }
static int h_captions(void *c, int32_t *e) { (void)c; *e = 1; return 0; }
static int h_autotext(void *c, const char *key, const char **t) { (void)c; (void)key; *t = NULL; return 0; }
static int h_caption(void *c, const char *text) { (void)text; ((Ctx *)c)->captions++; return 0; }
static int h_flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 4096; }
static int h_transition(void *c, const EbTransition *t)
{
    ((Ctx *)c)->transitions++;
    ((Ctx *)c)->last_scene = t->scene;
    return 0;
}
static int h_store_flag(void *c, int16_t i, uint32_t v)
{
    (void)v;
    ((Ctx *)c)->flag_stores++;
    ((Ctx *)c)->last_flag = i;
    return 0;
}
static int h_complete(void *c, int16_t row) { ((Ctx *)c)->completes++; ((Ctx *)c)->last_complete = row; return 0; }
static int32_t h_scene_cell(void *c) { return ((Ctx *)c)->scene_cell; }
static void h_store_world(void *c, const EbWorld *w) { (void)w; ((Ctx *)c)->store_world_calls++; }

static void make_host(SessionAebHost *host)
{
    memset(host, 0, sizeof *host);
    host->kernel.context = &g_ctx;
    host->kernel.view = h_view;
    host->kernel.alloc_slot = h_alloc;
    host->kernel.register_slot = h_register;
    host->kernel.release_slot = h_release_slot;
    host->kernel.mark_dirty = h_dirty;
    host->kernel.load_surface = h_load;
    host->kernel.create_surface = h_create;
    host->kernel.blit = h_blit;
    host->kernel.copy_surface = h_copy;
    host->kernel.rotate_surface = h_rotate;
    host->kernel.release_surface = h_release;
    host->kernel.clear_pending_item = h_clear;
    host->kernel.sound_prepare = h_prepare;
    host->kernel.sound_stop = h_stop;
    host->kernel.sound_play = h_play;
    host->kernel.sound_busy = h_busy;
    host->kernel.tick = h_tick;
    host->kernel.captions_enabled = h_captions;
    host->kernel.autotext_lookup = h_autotext;
    host->kernel.caption_show = h_caption;
    host->kernel.event_flag_invalid = h_flag_invalid;
    host->kernel.transition = h_transition;
    host->kernel.store_event_flag = h_store_flag;
    host->kernel.complete = h_complete;
    host->scene_cell = h_scene_cell;
    host->store_world = h_store_world;
}

static int16_t rd16(const uint8_t *b, size_t o) { return (int16_t)(uint16_t)(b[o] | (b[o + 1] << 8)); }
static int32_t rd32(const uint8_t *b, size_t o)
{
    return (int32_t)((uint32_t)b[o] | ((uint32_t)b[o + 1] << 8) | ((uint32_t)b[o + 2] << 16) | ((uint32_t)b[o + 3] << 24));
}

typedef struct {
    SessionAebBinding *b;
    const SceneActionInfo *info;
    const uint8_t *body;
    size_t row;
    uint32_t phase;
    int completed;
    EbRenderPlan *plan;
} Run;

static unsigned long g_picks, g_good, g_bad, g_spawns, g_rotations, g_renders, g_blits, g_nospot;

static const uint8_t *obj(const Run *r) { return session_aeb_object(r->b)->b; }
static int32_t ostate(const Run *r) { return rd32(obj(r), O_STATE); }

/* One handler visit as the executor makes it, then the render pass like the engine's draw pass. */
static int visit(Run *r)
{
    SceneActionRuntimeState st;
    SceneActionHandlerResult out;
    memset(&st, 0, sizeof st);
    memset(&out, 0, sizeof out);
    st.phase = r->phase;
    if (session_aeb_handler(r->b, r->row, r->info, &st, &out) != SCENE_ACTION_HANDLER_OK) return 0;
    r->phase = out.phase;
    r->completed = out.disposition == SCENE_ACTION_HANDLER_COMPLETED;
    if (!r->completed && session_aeb_registered(r->b) != 0u) {
        if (session_aeb_render_plan(r->b, r->plan) != EB_OK || r->plan->valid != 1u || r->plan->count < 0 ||
            r->plan->count > EB_MAX_BLITS)
            return 0;
        ++g_renders;
        g_blits += (unsigned long)r->plan->count;
    }
    return 1;
}

static int move(Run *r, int x, int y, EbPointerResult *pr)
{
    const int32_t rect[4] = {x - 8, y - 8, x + 8, y + 8};
    return session_aeb_pointer_move(r->b, (int16_t)x, (int16_t)y, rect, pr) == EB_OK;
}

static int click(Run *r, int32_t candidate, uint32_t *np) { return session_aeb_click(r->b, r->phase, candidate, np) == EB_OK; }

static size_t piece_off(int i) { return (size_t)O_PIECES + (size_t)i * PIECE_STRIDE; }
static size_t type_off(int t) { return (size_t)B_TYPES + (size_t)t * 0x53u; }
static int spawns(const Run *r, int t) { return r->body[type_off(t) + BT_SPAWN] != 0; }
static int forbidden(const Run *r, int t) { return r->body[type_off(t) + BT_FORBID] != 0; }
static int count_of(const Run *r) { return rd16(obj(r), O_COUNT); }
static int ntypes(const Run *r) { return rd16(r->body, B_NTYPES); }
static int dragging(const Run *r) { return rd32(obj(r), O_DRAG) != 0; }
static int hand_type(const Run *r) { return obj(r)[piece_off(rd16(obj(r), O_HAND)) + P_TYPE]; }

static int piece_point(const Run *r, int j, int attempt, int *x, int *y)
{
    const uint8_t *o = obj(r);
    const size_t P = piece_off(j);
    const int32_t l = rd32(o, P + P_RECT), t = rd32(o, P + P_RECT + 4), rr = rd32(o, P + P_RECT + 8), b = rd32(o, P + P_RECT + 12);
    static const int qx[5] = {2, 1, 3, 1, 3}, qy[5] = {2, 1, 1, 3, 3};
    *x = (int)(l + (rr - l) * qx[attempt % 5] / 4);
    *y = (int)(t + (b - t) * qy[attempt % 5] / 4);
    return rr >= l && b >= t;
}

/* The next piece a player would take: not placed, not of a forbidden type; a source piece of a spawning type until the
 * copies the target asks for exist. Returns the instance index or -1. */
static int next_piece(const Run *r)
{
    const int n = ntypes(r);
    for (int j = 0; j < count_of(r); ++j) {
        const uint8_t *o = obj(r);
        const int t = o[piece_off(j) + P_TYPE];
        if (t >= n || forbidden(r, t)) continue;
        if (spawns(r, t)) {
            if (j >= n || count_of(r) - n >= rd16(r->body, B_TARGET)) continue;
        } else if (o[piece_off(j) + P_STAMP] != 0) {
            continue;
        }
        return j;
    }
    return -1;
}

/* Everything the row asks for is placed: every non-spawning type is stamped (or forbidden), and the target number of copies
 * exists. */
static int all_placed(const Run *r)
{
    int spawn_types = 0;
    for (int t = 0; t < ntypes(r); ++t) spawn_types += spawns(r, t);
    return next_piece(r) == -1 && (spawn_types == 0 || count_of(r) - ntypes(r) >= rd16(r->body, B_TARGET));
}

/* The spot where the piece in hand sits in the picture the pieces make up: the sheet rects A of the non-spawning types tile
 * the picture, so a piece goes to the drop area's corner plus its A rect's offset from the smallest A corner. */
static int jigsaw_spot(const Run *r, int *x, int *y)
{
    int32_t min_l = 0x7fffffff, min_t = 0x7fffffff;
    const int type = hand_type(r);
    for (int t = 0; t < ntypes(r); ++t) {
        if (spawns(r, t)) continue;
        if (rd32(r->body, type_off(t)) < min_l) min_l = rd32(r->body, type_off(t));
        if (rd32(r->body, type_off(t) + 4) < min_t) min_t = rd32(r->body, type_off(t) + 4);
    }
    if (spawns(r, type) || min_l == 0x7fffffff) return 0;
    *x = (int)(rd32(r->body, B_AREA) + 1 + (rd32(r->body, type_off(type)) - min_l) + rd16(obj(r), O_HW) / 2);
    *y = (int)(rd32(r->body, B_AREA + 4) + 1 + (rd32(r->body, type_off(type) + 4) - min_t) + rd16(obj(r), O_HH) / 2);
    return 1;
}

/* The kernel checks overlaps against the previous moving rectangle, so a spot is probed with two identical moves: the second one
 * sees the piece resting there. Returns 1 on a drop hit, 0 on none, -1 when the pointer did not report the drop candidate. */
static int probe(Run *r, int x, int y)
{
    EbPointerResult pr;
    for (int k = 0; k < 2; ++k)
        if (!move(r, x, y, &pr) || pr.candidate != EB_CANDIDATE_DROP) return -1;
    return rd32(obj(r), O_HIT) == 1;
}

/* The jigsaw spot (and its neighbours), then a scan over the drop area, until a probe hits. */
static int find_drop_spot(Run *r, int *hx, int *hy)
{
    const int l = rd32(r->body, B_AREA), t = rd32(r->body, B_AREA + 4), rr = rd32(r->body, B_AREA + 8), b = rd32(r->body, B_AREA + 12);
    int jx = 0, jy = 0, hit;
    if (jigsaw_spot(r, &jx, &jy)) {
        for (int ring = 0; ring <= 3; ++ring)
            for (int dy = -ring; dy <= ring; ++dy)
                for (int dx = -ring; dx <= ring; ++dx) {
                if ((dx < 0 ? -dx : dx) != ring && (dy < 0 ? -dy : dy) != ring) continue;
                hit = probe(r, jx + dx, jy + dy);
                if (hit < 0) return -1;
                if (hit == 1) {
                    *hx = jx + dx;
                    *hy = jy + dy;
                    return 1;
                }
            }
    }
    for (int y = t; y <= b; y += 5)
        for (int x = l; x <= rr; x += 5) {
            hit = probe(r, x, y);
            if (hit < 0) return -1;
            if (hit == 1) {
                *hx = x;
                *hy = y;
                return 1;
            }
        }
    return 0;
}

/* Drops the piece in hand: inside the area when it may be placed there, else (forbidden type, or no spot) outside it. */
static int drop(Run *r, int bad)
{
    EbPointerResult pr;
    uint32_t np = 99u;
    const int16_t hand = rd16(obj(r), O_HAND);
    const int type = hand_type(r);
    int hx = 0, hy = 0, found = 0;
    if (!bad && !forbidden(r, type)) {
        found = find_drop_spot(r, &hx, &hy);
        if (found < 0) return 0;
    }
    if (found == 0 && !bad && !forbidden(r, type)) ++g_nospot;
    if (found == 1) {
        if (rd32(obj(r), O_HIT) != 1) return 0; /* the scan stopped on the spot, the pointer is still there */
    } else {
        if (!move(r, -3000, -3000, &pr) || pr.candidate != EB_CANDIDATE_DROP || rd32(obj(r), O_HIT) != 0) return 0;
    }
    if (!click(r, EB_CANDIDATE_DROP, &np) || np != 1u || dragging(r) || rd16(obj(r), O_HAND) != -1) return 0;
    if (found == 1) {
        if (obj(r)[piece_off(hand) + P_STAMP] != 1) return 0;
        ++g_good;
    } else {
        if (obj(r)[piece_off(hand) + P_STAMP] != 0) return 0;
        ++g_bad;
    }
    return 1;
}

/* Picks the piece `j` up (a Multi_Piece row needs a second release for the copy). */
static int pick(Run *r, int j, int attempt)
{
    EbPointerResult pr;
    uint32_t np = 99u;
    int x, y;
    const int before = count_of(r);
    if (!piece_point(r, j, attempt, &x, &y)) return 0;
    if (!move(r, x, y, &pr) || pr.hit != 1u || pr.candidate != EB_CANDIDATE_PICK) return 0;
    if (!click(r, EB_CANDIDATE_PICK, &np) || np != 1u) return 0;
    if (obj(r)[O_MULTI_HAND] != 0) {
        const int16_t hand = rd16(obj(r), O_HAND);
        if (!piece_point(r, hand, 0, &x, &y)) return 0;
        if (!move(r, x, y, &pr) || pr.hit != 1u || pr.candidate != EB_CANDIDATE_PICK) return 0;
        if (!click(r, EB_CANDIDATE_PICK, &np) || np != 1u || obj(r)[O_MULTI_HAND] != 0) return 0;
    }
    if (!dragging(r) || rd16(obj(r), O_HAND) < 0) return 0;
    ++g_picks;
    g_spawns += (unsigned long)(count_of(r) - before);
    return 1;
}

/* A full turn: four second-button releases, each turning the piece a quarter (orientation 0 again, the original size). */
static int rotate_full_turn(Run *r)
{
    const int16_t hand = rd16(obj(r), O_HAND);
    for (int k = 1; k <= 4; ++k) {
        if (session_aeb_rotate_key(r->b, r->phase) != EB_OK) return 0;
        if (obj(r)[piece_off(hand) + P_ORIENT] != k % 4) return 0;
        ++g_rotations;
    }
    return 1;
}

/* Lets the animation and sound deadlines pass until the handler is idle again (or the puzzle ended). */
static int settle(Run *r)
{
    for (int i = 0; i < 40; ++i) {
        if (r->completed || (ostate(r) == 0 && obj(r)[O_DONE] == 0)) return 1;
        if (obj(r)[O_DONE] != 0 && ostate(r) == 0) return 1;
        g_ctx.now += 1000u;
        if (!visit(r)) return 0;
    }
    return r->completed || ostate(r) == 0 || obj(r)[O_DONE] != 0;
}

static int click_exit(Run *r, uint32_t *np)
{
    EbPointerResult pr;
    const int x = (rd32(r->body, B_BTN_A) + rd32(r->body, B_BTN_A + 8)) / 2, y = (rd32(r->body, B_BTN_A + 4) + rd32(r->body, B_BTN_A + 12)) / 2;
    if (!move(r, x, y, &pr) || pr.hit != 1u || pr.candidate != EB_CANDIDATE_EXIT_A) return 0;
    return click(r, EB_CANDIDATE_EXIT_A, np);
}

static int block_transitions(const uint8_t *body, size_t block) { return rd16(body, block) != EB_NO_SCENE ? 1 : 0; }

#define GATE(id, cond)               \
    do {                             \
        if (good && !(cond)) {       \
            good = 0;                \
            fail_step = (id);        \
        }                            \
    } while (0)

static int sum_counts(const Run *r)
{
    int s = 0;
    for (int t = 0; t < ntypes(r); ++t) s += obj(r)[O_COUNTS + (size_t)t];
    return s;
}

int main(int argc, char **argv)
{
    SessionAebHost host;
    unsigned long rows = 0, validated = 0, won = 0, exited = 0, reentered = 0, errors = 0, scenes = 0, forbidden_dropped = 0, stuck = 0;
    EbRenderPlan *plan = (EbRenderPlan *)calloc(1u, sizeof(EbRenderPlan));
    if (plan == NULL) return 2;
    make_host(&host);
    for (int a = 1; a < argc; ++a) {
        FILE *f = fopen(argv[a], "rb");
        long n;
        unsigned char *bytes;
        char err[128] = {0};
        SceneResource *scene;
        size_t count, eb_rows = 0;
        if (f == NULL) continue;
        fseek(f, 0, SEEK_END);
        n = ftell(f);
        fseek(f, 0, SEEK_SET);
        bytes = (unsigned char *)malloc((size_t)n);
        if (bytes == NULL || fread(bytes, 1, (size_t)n, f) != (size_t)n) {
            fclose(f);
            free(bytes);
            continue;
        }
        fclose(f);
        scene = scene_resource_open_memory(bytes, (size_t)n, err, sizeof err);
        if (scene == NULL) {
            free(bytes);
            continue;
        }
        count = scene_resource_action_count(scene);
        for (size_t i = 0; i < count; ++i) {
            SceneActionInfo info;
            if (scene_resource_action_at(scene, i, &info) == SCENE_RESOURCE_OK && info.type == SESSION_AEB_TYPE) ++eb_rows;
        }
        if (eb_rows == 0) {
            scene_resource_close(scene);
            free(bytes);
            continue;
        }
        ++scenes;
        for (int pass = 0; pass < 3; ++pass) {
            SessionAebBinding *binding = session_aeb_create(&host);
            if (binding == NULL || session_aeb_begin_scene(binding, scene) != EB_OK) {
                printf("SCENE_FAIL %s %s\n", argv[a], binding ? session_aeb_failure(binding) : "create");
                if (pass == 0) {
                    errors += eb_rows;
                    rows += eb_rows;
                }
                session_aeb_destroy(binding);
                break;
            }
            for (size_t i = 0; i < count; ++i) {
                SceneActionInfo info;
                Run run;
                int good = 1, fail_step = 0, iter;
                int slots_before, transitions_before;
                if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK || info.type != SESSION_AEB_TYPE) continue;
                if (pass == 0) {
                    ++rows;
                    ++validated;
                }
                run.b = binding;
                run.info = &info;
                run.body = info.typed_body;
                run.row = i;
                run.phase = 0u;
                run.completed = 0;
                run.plan = plan;
                g_ctx.now = 100000u;
                g_ctx.next_handle = 5u;
                g_ctx.scene_cell = 1000 + (int)i;
                slots_before = g_ctx.slot_releases;
                transitions_before = g_ctx.transitions;
                /* Phase 0: the singleton is active for this row, the render entry is registered, the pieces are laid out. */
                GATE(1, visit(&run) && run.phase == 1u && !run.completed && session_aeb_registered(binding) == 1u &&
                            rd32(obj(&run), O_ACTIVE) == 1 && rd16(obj(&run), O_ROW) == (int16_t)i && count_of(&run) >= ntypes(&run) &&
                            ostate(&run) == 0 && g_ctx.registers > 0 && session_aeb_world(binding)->start_flag_5bb1ca == 1);
                {
                    EbPointerResult pr;
                    GATE(2, move(&run, -3000, -3000, &pr) && pr.hit == 0u && pr.candidate == -1);
                }
                if (pass == 0) {
                    int attempt = 0, done_seen = 0, give_up = 0, forbidden_tried = 0, rotated = (run.body[B_ROT] == 0);
                    for (iter = 0; good && iter < 600 && !run.completed; ++iter) {
                        g_ctx.now += 1000u;
                        if (obj(&run)[O_DONE] != 0) done_seen = 1;
                        if (!visit(&run)) {
                            GATE(10, 0);
                            break;
                        }
                        if (run.completed) break;
                        if (obj(&run)[O_DONE] != 0) {
                            done_seen = 1;
                            continue;
                        }
                        if (run.phase != 1u || ostate(&run) != 0 || session_aeb_registered(binding) != 1u) continue;
                        if (dragging(&run)) {
                            const int type = hand_type(&run);
                            if (!rotated) {
                                GATE(11, rotate_full_turn(&run));
                                rotated = 1;
                            }
                            if (forbidden(&run, type)) ++forbidden_dropped;
                            const unsigned long nospot = g_nospot;
                            GATE(12, drop(&run, (iter % 11) == 5 && !all_placed(&run) ? 1 : 0));
                            if (!good) break;
                            if (g_nospot != nospot) give_up = 1; /* the kernel found no free spot for this piece */
                            GATE(13, settle(&run));
                        } else if (all_placed(&run) || give_up) {
                            uint32_t np = 99u;
                            GATE(20, click_exit(&run, &np) && np == 2u);
                            if (!good) break;
                            if (obj(&run)[O_DONE] != 0) done_seen = 1;
                            run.phase = np;
                        } else {
                            int j = next_piece(&run);
                            if (!forbidden_tried) {
                                /* A forbidden type is taken up once and dropped outside the area. */
                                forbidden_tried = 1;
                                for (int k = 0; k < count_of(&run); ++k)
                                    if (obj(&run)[piece_off(k) + P_TYPE] < ntypes(&run) && forbidden(&run, obj(&run)[piece_off(k) + P_TYPE])) {
                                        j = k;
                                        break;
                                    }
                            }
                            GATE(21, j >= 0 && pick(&run, j, attempt++));
                        }
                    }
                    GATE(30, run.completed && run.phase == 2u && (done_seen || give_up));
                    if (give_up) ++stuck;
                    GATE(31, g_ctx.completes > 0 && g_ctx.last_complete == (int16_t)i && session_aeb_registered(binding) == 0u &&
                                 rd32(obj(&run), O_ACTIVE) == 0 && g_ctx.slot_releases > slots_before);
                    {
                        const size_t block = done_seen ? B_WIN : B_EXIT;
                        GATE(32, g_ctx.transitions - transitions_before == block_transitions(run.body, block) &&
                                     (block_transitions(run.body, block) == 0 || g_ctx.last_scene == rd16(run.body, block)));
                    }
                    GATE(33, session_aeb_world(binding)->saved_flag == 1u && g_ctx.store_world_calls > 0);
                    if (good && done_seen) ++won;
                } else if (pass == 1) {
                    /* One piece placed, then the exit button; the saved state, then the same row entered again. */
                    uint32_t np = 99u;
                    uint8_t counts[EB_MAX_TYPES];
                    int saved_count = 0, done = 0;
                    const int j = next_piece(&run);
                    GATE(40, j >= 0);
                    GATE(46, pick(&run, j, 0) && settle(&run));
                    GATE(47, drop(&run, 0));
                    GATE(48, settle(&run));
                    memcpy(counts, obj(&run) + O_COUNTS, sizeof counts);
                    saved_count = count_of(&run);
                    GATE(41, click_exit(&run, &np) && np == 2u);
                    if (good) {
                        run.phase = np;
                        done = obj(&run)[O_DONE] != 0;
                    }
                    GATE(42, visit(&run) && run.completed && session_aeb_registered(binding) == 0u);
                    GATE(43, g_ctx.transitions - transitions_before == block_transitions(run.body, done ? B_WIN : B_EXIT));
                    GATE(44, session_aeb_world(binding)->saved_flag == 1u && session_aeb_world(binding)->saved_count == saved_count &&
                                 memcmp(session_aeb_world(binding)->saved_counts, counts, sizeof counts) == 0);
                    run.phase = 0u;
                    run.completed = 0;
                    GATE(45, session_aeb_begin_scene(binding, scene) == EB_OK && visit(&run) && run.phase == 1u &&
                                 session_aeb_registered(binding) == 1u && session_aeb_world(binding)->saved_flag == 1u &&
                                 (run.body[B_PERSIST] != 0 || sum_counts(&run) == 0));
                    if (good) ++reentered;
                    if (good) ++exited;
                } else {
                    uint32_t np = 99u;
                    GATE(50, click_exit(&run, &np) && np == 2u);
                    if (good) run.phase = np;
                    GATE(51, visit(&run) && run.completed && session_aeb_registered(binding) == 0u &&
                                 g_ctx.transitions - transitions_before == block_transitions(run.body, B_EXIT));
                    if (good) ++exited;
                }
                if (!good) {
                    ++errors;
                    printf("ROW_FAIL %s %zu pass=%d step=%d %s\n", argv[a], i, pass, fail_step, session_aeb_failure(binding));
                }
            }
            session_aeb_destroy(binding);
        }
        scene_resource_close(scene);
        free(bytes);
    }
    printf("SUMMARY scenes=%lu rows=%lu validated=%lu won=%lu exited=%lu reentered=%lu picks=%lu good_drops=%lu bad_drops=%lu "
           "forbidden_dropped=%lu stuck=%lu spawns=%lu rotations=%lu error=%lu loads=%d creates=%d copies=%d rotates=%d releases=%d sounds=%d "
           "stops=%d transitions=%d flag_stores=%d completes=%d renders=%lu blits=%lu\n",
           scenes, rows, validated, won, exited, reentered, g_picks, g_good, g_bad, forbidden_dropped, stuck, g_spawns, g_rotations, errors,
           g_ctx.loads, g_ctx.creates, g_ctx.copies, g_ctx.rotates, g_ctx.releases, g_ctx.sounds, g_ctx.stops, g_ctx.transitions,
           g_ctx.flag_stores, g_ctx.completes, g_renders, g_blits);
    free(plan);
    return errors == 0 ? 0 : 1;
}
