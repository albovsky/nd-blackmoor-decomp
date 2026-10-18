/* RT-60 corpus check: runs every raw 0xee row of the decoded scene resources given on the command line through the production
 * parser, the session binding and the kernel with a scripted host. Per row: begin_scene validates the body; phase 0 lays out the
 * grid and deals; the pointer is checked against an independent reference of the hit test (page tabs first, then the tiles shrunk
 * by 3 pixels) on the centre, the corners and the pixels just outside every rectangle of every page; a perfect game flips every
 * pair (switching pages through the tabs) until the game is won or the tries run out; mismatching flips show the flip-back
 * delay (a third flip is blocked, the deadline is strict, the tiles turn back); repeated mismatches run the tries out (lose); the
 * win and the lose game leave through the handler and the scene block (scene change, event flag, generic completion, surface and
 * entry release). A second pass with captions enabled counts the flips whose caption the kernel refuses (longer than the 104-byte
 * local of the original). Output is derived counts only: one "ROW_FAIL ..." line per failing check and a final "SUMMARY ..." line.
 * The resource bytes, names and texts stay in work/. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_aee.h"

typedef struct Ctx {
    uint32_t now;
    uint32_t lcg;
    int captions;
    int prepares, plays, transitions, flag_stores, completes, rsurf, rslot, loads, dirty, recenters, caps_shown, autotexts;
    int16_t scene;
    int16_t flag_index;
    int32_t flag_value;
    int32_t start_flag;
    int32_t start_flag_stores;
} Ctx;

static int rd16(const uint8_t *b, size_t o) { return (int16_t)(uint16_t)(b[o] | (b[o + 1] << 8)); }
static int32_t rd32(const uint8_t *b, size_t o)
{
    return (int32_t)((uint32_t)b[o] | ((uint32_t)b[o + 1] << 8) | ((uint32_t)b[o + 2] << 16) | ((uint32_t)b[o + 3] << 24));
}

static int h_view(void *c, MpView *v)
{
    (void)c;
    v->view[0] = 7;
    v->view[1] = 11;
    v->view[2] = 647;
    v->view[3] = 491;
    v->clip[0] = 0;
    v->clip[1] = 0;
    v->clip[2] = 640;
    v->clip[3] = 480;
    return 0;
}
static int h_start(void *c, int32_t v)
{
    ((Ctx *)c)->start_flag = v;
    ((Ctx *)c)->start_flag_stores++;
    return 0;
}
static int h_pend(void *c) { (void)c; return 0; }
static int h_recenter(void *c) { ((Ctx *)c)->recenters++; return 0; }
static int h_alloc(void *c, int16_t *slot) { (void)c; *slot = 0x20; return 0; }
static int h_reg(void *c, int16_t s, const char *l) { (void)c; (void)s; (void)l; return 0; }
static int h_ssurf(void *c, int16_t s, uint32_t surface) { (void)c; (void)s; (void)surface; return 0; }
static int h_rslot(void *c, int16_t s) { (void)s; ((Ctx *)c)->rslot++; return 0; }
static int h_dirty(void *c, int16_t s) { (void)s; ((Ctx *)c)->dirty++; return 0; }
static int h_load(void *c, const char *name, const char *tag, uint32_t *s)
{
    (void)name;
    (void)tag;
    ((Ctx *)c)->loads++;
    *s = 0x7001u;
    return 0;
}
static int h_rsurf(void *c, uint32_t s) { (void)s; ((Ctx *)c)->rsurf++; return 0; }
static int32_t h_rand(void *c)
{
    Ctx *x = (Ctx *)c;
    x->lcg = x->lcg * 1664525u + 1013904223u;
    return (int32_t)((x->lcg >> 8) & 0x7fffu);
}
static uint32_t h_tick(void *c) { return ((Ctx *)c)->now; }
static int h_prep(void *c, uint32_t id, const uint8_t *r) { (void)id; (void)r; ((Ctx *)c)->prepares++; return 0; }
static int h_play(void *c, int16_t ch) { (void)ch; ((Ctx *)c)->plays++; return 0; }
static int h_busy(void *c, int16_t ch, int32_t *r) { (void)c; (void)ch; *r = 0; return 0; }
static int h_caps(void *c, int32_t *e) { *e = ((Ctx *)c)->captions; return 0; }
static int h_auto(void *c, const char *key, const char **t)
{
    (void)key;
    ((Ctx *)c)->autotexts++;
    *t = NULL; /* every key is "not found": the record text is the caption */
    return 0;
}
static int h_cap(void *c, const char *t) { (void)t; ((Ctx *)c)->caps_shown++; return 0; }
static int h_inv(void *c, int16_t i) { (void)c; return i < 0 || i >= 4096; }
static int h_trans(void *c, const MpTransition *t)
{
    Ctx *x = (Ctx *)c;
    x->transitions++;
    x->scene = t->scene;
    x->start_flag = t->start_flag;
    return 0;
}
static int h_flag(void *c, int16_t i, int32_t v)
{
    Ctx *x = (Ctx *)c;
    x->flag_stores++;
    x->flag_index = i;
    x->flag_value = v;
    return 0;
}
static int h_done(void *c, int16_t row) { (void)row; ((Ctx *)c)->completes++; return 0; }

typedef struct Run {
    SessionAeeBinding *b;
    const SceneActionInfo *info;
    const uint8_t *body;
    size_t row;
    uint32_t phase;
    Ctx *ctx;
    unsigned long failures, nav_fail;
    unsigned long tile_hits, tile_misses, tab_hits, pairs, mismatches, flipbacks, blocked, caption_bounds;
} Run;

#define EXPECT(run, cond)                                                                                  \
    do {                                                                                                   \
        if (!(cond)) {                                                                                     \
            ++(run)->failures;                                                                             \
            printf("ROW_FAIL row=%zu line=%d check=%s\n", (run)->row, __LINE__, #cond);                    \
        }                                                                                                  \
    } while (0)

/* Body offsets (header comment of the kernel). */
enum { B_TILES = 0x111, B_TABHOT = 0x2a1, B_DELAY = 0x331, B_TRIES = 0x341, B_PAGES = 0x347, B_COLS = 0x34b, B_ROWS = 0x34f,
       B_TABS = 0x35b, B_BWIN = 0x168e, B_BLOSE = 0x16a8, B_PCTNEED = 0x339, B_NEED = 0x33d };
enum { O_PAGE = 0x28c, O_PAIRS = 0x290, O_TRIES = 0x294, O_WON = 0x28, O_LOST = 0x2c, O_FLIPBACK = 0x34, O_DEADLINE = 0x38,
       O_NEEDED = 0x2a0, O_TOTAL = 0x284, O_PERPAGE = 0x280, O_FIRST = 0x1c, O_SECOND = 0x20, O_STATE = 0x10 };

static MpObject *obj(Run *r) { return (MpObject *)session_aee_object(r->b); }
static int32_t of(Run *r, size_t off) { return rd32(obj(r)->b, off); }
static void set_of(Run *r, size_t off, int32_t v)
{
    for (int i = 0; i < 4; ++i) obj(r)->b[off + (size_t)i] = (uint8_t)((uint32_t)v >> (8 * i));
}
static int32_t cell_id(Run *r, int i) { return rd32(obj(r)->cells, (size_t)i * 12u); }
static int32_t cell_up(Run *r, int i) { return rd32(obj(r)->cells, (size_t)i * 12u + 4u); }
static int32_t cell_done(Run *r, int i) { return rd32(obj(r)->cells, (size_t)i * 12u + 8u); }

/* One handler visit. Returns 1 when the visit completed the row. */
static int visit(Run *r)
{
    SceneActionRuntimeState st;
    SceneActionHandlerResult out;
    memset(&st, 0, sizeof st);
    memset(&out, 0, sizeof out);
    st.phase = r->phase;
    if (session_aee_handler(r->b, r->row, r->info, &st, &out) != SCENE_ACTION_HANDLER_OK) {
        ++r->failures;
        printf("ROW_FAIL row=%zu line=%d check=handler status\n", r->row, __LINE__);
        return 1;
    }
    r->phase = out.phase;
    return out.disposition == SCENE_ACTION_HANDLER_COMPLETED;
}

static void begin(Run *r, SceneResource *scene)
{
    r->phase = 0;
    EXPECT(r, session_aee_begin_scene(r->b, scene) == MP_OK); /* the clear of the previous game releases its entry */
    memset(r->ctx, 0, sizeof *r->ctx);
    r->ctx->now = 5000;
    r->ctx->lcg = 0x1234567u + (uint32_t)r->row;
    (void)visit(r);
    EXPECT(r, r->phase == 1u && session_aee_registered(r->b) == 1u);
}

/* Reference of the pointer hit test, written from the header comment and not from the kernel: tabs of the current page first,
 * then the tiles of the page (shrunk by 3 pixels), a tile only while it is face down and unmatched. */
static int ref_hit(Run *r, int page, int x, int y, int *kind, int *index)
{
    const uint8_t *body = r->body;
    const int per_page = rd32(body, B_COLS) * rd32(body, B_ROWS);
    if (body[B_TABS] != 0) {
        for (int j = 0; j < 3; ++j) {
            const size_t k = B_TABHOT + (size_t)page * 0x30u + (size_t)j * 0x10u;
            if (rd32(body, k + 4) <= y && y <= rd32(body, k + 12) && rd32(body, k) <= x && x <= rd32(body, k + 8)) {
                *kind = 1;
                *index = j;
                return 1;
            }
        }
    }
    for (int j = 0; j < per_page; ++j) {
        const size_t t = B_TILES + (size_t)j * 16u;
        const int cell = page * per_page + j;
        if (rd32(body, t + 4) + 3 <= y && y <= rd32(body, t + 12) - 3 && rd32(body, t) + 3 <= x && x <= rd32(body, t + 8) - 3 &&
            cell_up(r, cell) == 0 && cell_done(r, cell) == 0) {
            *kind = 2;
            *index = j;
            return 1;
        }
    }
    return 0;
}

static void check_point(Run *r, int x, int y)
{
    MpPointerResult p;
    int kind = 0, index = -1;
    const int page = of(r, O_PAGE);
    const int want = ref_hit(r, page, x, y, &kind, &index);
    EXPECT(r, session_aee_pointer_move(r->b, (int16_t)x, (int16_t)y, &p) == MP_OK);
    EXPECT(r, p.hit == want);
    if (want && p.hit) {
        EXPECT(r, p.candidate == (kind == 1 ? MP_CANDIDATE_TAB : MP_CANDIDATE_TILE));
        EXPECT(r, of(r, 0x27c) == index);
        if (kind == 1) ++r->tab_hits; else ++r->tile_hits;
    } else {
        EXPECT(r, p.candidate == -1);
        ++r->tile_misses;
    }
}

static void tile_tests(Run *r)
{
    const int pages = rd32(r->body, B_PAGES), per_page = rd32(r->body, B_COLS) * rd32(r->body, B_ROWS);
    for (int page = 0; page < pages; ++page) {
        set_of(r, O_PAGE, page);
        for (int j = 0; j < per_page; ++j) {
            const size_t t = B_TILES + (size_t)j * 16u;
            const int l = rd32(r->body, t), tp = rd32(r->body, t + 4), rt = rd32(r->body, t + 8), bt = rd32(r->body, t + 12);
            check_point(r, (l + rt) / 2, (tp + bt) / 2);
            check_point(r, l + 3, tp + 3);
            check_point(r, rt - 3, bt - 3);
            check_point(r, l + 2, (tp + bt) / 2);
            check_point(r, rt - 2, (tp + bt) / 2);
            check_point(r, (l + rt) / 2, tp + 2);
            check_point(r, (l + rt) / 2, bt - 2);
        }
        if (r->body[B_TABS] != 0)
            for (int j = 0; j < 3; ++j) {
                const size_t k = B_TABHOT + (size_t)page * 0x30u + (size_t)j * 0x10u;
                check_point(r, rd32(r->body, k), rd32(r->body, k + 4));
                check_point(r, rd32(r->body, k + 8), rd32(r->body, k + 12));
                check_point(r, rd32(r->body, k) - 1, rd32(r->body, k + 4));
                check_point(r, rd32(r->body, k + 8) + 1, rd32(r->body, k + 12) + 1);
            }
    }
    set_of(r, O_PAGE, 0);
    check_point(r, -1, -1);
    check_point(r, 639, 479);
}

/* Point at (x, y), then click with the candidate the pointer wrote. Returns the click status, -1 when nothing was hit. */
static int tap(Run *r, int x, int y)
{
    MpPointerResult p;
    int rc = session_aee_pointer_move(r->b, (int16_t)x, (int16_t)y, &p);
    if (rc != MP_OK) return rc;
    if (!p.hit) return -1;
    return session_aee_click(r->b, r->phase, p.candidate);
}

/* Switch to `page` through the tab strip of the current page. Returns 1 when the page is shown. */
static int goto_page(Run *r, int page)
{
    if (of(r, O_PAGE) == page) return 1;
    if (r->body[B_TABS] == 0) return 0;
    {
        const size_t k = B_TABHOT + (size_t)of(r, O_PAGE) * 0x30u + (size_t)page * 0x10u;
        (void)tap(r, (rd32(r->body, k) + rd32(r->body, k + 8)) / 2, (rd32(r->body, k + 4) + rd32(r->body, k + 12)) / 2);
    }
    if (of(r, O_PAGE) != page) {
        ++r->nav_fail;
        return 0;
    }
    return 1;
}

/* Flip cell `cell` (global index). Returns the click status, or -1 when the tile cannot be reached. */
static int flip_cell(Run *r, int cell)
{
    const int per_page = rd32(r->body, B_COLS) * rd32(r->body, B_ROWS);
    const int page = cell / per_page, j = cell % per_page;
    const size_t t = B_TILES + (size_t)j * 16u;
    int rc;
    if (!goto_page(r, page)) return -1;
    rc = tap(r, (rd32(r->body, t) + rd32(r->body, t + 8)) / 2, (rd32(r->body, t + 4) + rd32(r->body, t + 12)) / 2);
    if (rc == -1) ++r->nav_fail;
    return rc;
}

static int flip_pair(Run *r, int a, int b, int *bounds)
{
    int rc = flip_cell(r, a);
    if (rc == MP_ERR_BOUNDS) { ++*bounds; return rc; }
    if (rc != MP_OK) return rc;
    rc = flip_cell(r, b);
    if (rc == MP_ERR_BOUNDS) ++*bounds;
    return rc;
}

static int ref_needed(const uint8_t *body)
{
    const int total = rd32(body, B_PAGES) * rd32(body, B_COLS) * rd32(body, B_ROWS), half = total / 2;
    int need;
    if (rd32(body, B_PCTNEED) == -1) need = rd32(body, B_NEED);
    else need = (int)(((double)(float)rd32(body, B_PCTNEED) / 100.0) * (double)(float)half);
    if (need <= 2) need = 2;
    if (!(need < half)) need = half;
    return need;
}

/* The leave: phase 1 until the handler asks for phase 2, then the finish; checks the block against the body. */
static void expect_exit(Run *r, size_t block, int played_ok)
{
    int guard = 0;
    const int has_scene = rd16(r->body, block) != 9999;
    const int has_flag = rd16(r->body, block + 22) != -1;
    (void)played_ok;
    while (r->phase == 1u && guard++ < 64) (void)visit(r);
    EXPECT(r, r->phase == 2u);
    EXPECT(r, visit(r) == 1);
    EXPECT(r, r->ctx->transitions == (has_scene ? 1 : 0));
    if (has_scene) {
        EXPECT(r, r->ctx->scene == rd16(r->body, block));
        EXPECT(r, r->ctx->start_flag == (rd16(r->body, block + 20) != 1));
    }
    EXPECT(r, r->ctx->flag_stores == (has_flag ? 1 : 0));
    if (has_flag) {
        EXPECT(r, r->ctx->flag_index == rd16(r->body, block + 22));
        EXPECT(r, r->ctx->flag_value == rd16(r->body, block + 24));
    }
    EXPECT(r, r->ctx->completes == 1);
    EXPECT(r, r->ctx->rsurf == 1 && r->ctx->rslot == 1);
    EXPECT(r, session_aee_registered(r->b) == 0u && mp_object_active(session_aee_object(r->b)) == 0);
}

/* A perfect game: every unmatched cell is paired with another cell of the same picture. Returns 1 when the game ended. */
static int perfect_game(Run *r, int *bounds)
{
    const int total = of(r, O_TOTAL);
    for (int guard = 0; guard < 80 && of(r, O_WON) == 0 && of(r, O_LOST) == 0; ++guard) {
        int a = -1, b = -1;
        for (int i = 0; i < total && b < 0; ++i) {
            if (cell_done(r, i) != 0 || cell_up(r, i) != 0) continue;
            if (a < 0) { a = i; continue; }
            if (cell_id(r, i) == cell_id(r, a)) b = i;
        }
        if (a < 0 || b < 0) break;
        if (flip_pair(r, a, b, bounds) != MP_OK) return 0;
        ++r->pairs;
    }
    return of(r, O_WON) != 0 || of(r, O_LOST) != 0;
}

/* Two unmatched face-down cells with different pictures (a mismatch). */
static int find_mismatch(Run *r, int *a, int *b)
{
    const int total = of(r, O_TOTAL);
    for (int i = 0; i < total; ++i) {
        if (cell_done(r, i) != 0 || cell_up(r, i) != 0) continue;
        for (int j = i + 1; j < total; ++j)
            if (cell_done(r, j) == 0 && cell_up(r, j) == 0 && cell_id(r, j) != cell_id(r, i)) {
                *a = i;
                *b = j;
                return 1;
            }
    }
    return 0;
}

static void layout_checks(Run *r)
{
    const int pages = rd32(r->body, B_PAGES), per_page = rd32(r->body, B_COLS) * rd32(r->body, B_ROWS);
    MpRenderPlan plan;
    EXPECT(r, of(r, O_PERPAGE) == per_page && of(r, O_TOTAL) == per_page * pages);
    EXPECT(r, of(r, O_NEEDED) == ref_needed(r->body));
    EXPECT(r, of(r, O_TRIES) == 0 && of(r, O_PAIRS) == 0 && of(r, O_STATE) == 0);
    EXPECT(r, session_aee_render_plan(r->b, &plan) == MP_OK && plan.valid == 1);
    EXPECT(r, plan.count == 1 + (r->body[B_TABS] != 0 ? 1 : 0) + per_page);
    EXPECT(r, session_aee_render_plan(r->b, &plan) == MP_OK && plan.count == (r->body[B_TABS] != 0 ? 1 : 0) + per_page); /* no restore */
    {
        int ids_ok = 1;
        for (int i = 0; i < of(r, O_TOTAL); ++i) ids_ok &= cell_id(r, i) >= 0 && cell_id(r, i) < 12;
        EXPECT(r, ids_ok);
    }
    r->ctx->dirty = 0;
    EXPECT(r, session_aee_invalidate(r->b) == MP_OK && r->ctx->dirty == 1);
}

int main(int argc, char **argv)
{
    static Ctx ctx;
    SessionAeeHost host;
    unsigned long rows = 0, validated = 0, error = 0, scenes = 0, wins = 0, loses = 0, win_exits = 0, lose_exits = 0, tiles = 0;
    unsigned long tile_hits = 0, tile_misses = 0, tab_hits = 0, pairs = 0, mismatches = 0, flipbacks = 0, blocked = 0, nav_fail = 0;
    unsigned long caption_bounds = 0, caption_runs = 0, recenter_rows = 0, pages_total = 0;
    memset(&host, 0, sizeof host);
    host.kernel.context = &ctx;
    host.kernel.view = h_view;
    host.kernel.set_start_flag = h_start;
    host.kernel.clear_pending_item = h_pend;
    host.kernel.recenter_cursor = h_recenter;
    host.kernel.alloc_slot = h_alloc;
    host.kernel.register_slot = h_reg;
    host.kernel.set_slot_surface = h_ssurf;
    host.kernel.release_slot = h_rslot;
    host.kernel.mark_dirty = h_dirty;
    host.kernel.load_surface = h_load;
    host.kernel.release_surface = h_rsurf;
    host.kernel.random = h_rand;
    host.kernel.tick = h_tick;
    host.kernel.sound_prepare = h_prep;
    host.kernel.sound_play = h_play;
    host.kernel.sound_busy = h_busy;
    host.kernel.captions_enabled = h_caps;
    host.kernel.autotext_lookup = h_auto;
    host.kernel.caption_show = h_cap;
    host.kernel.event_flag_invalid = h_inv;
    host.kernel.transition = h_trans;
    host.kernel.store_event_flag = h_flag;
    host.kernel.complete = h_done;
    for (int a = 1; a < argc; ++a) {
        FILE *f = fopen(argv[a], "rb");
        long n;
        unsigned char *bytes;
        char err[128] = {0};
        SceneResource *scene;
        size_t count;
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
            printf("SCENE_FAIL file=%d\n", a);
            ++error;
            free(bytes);
            continue;
        }
        ++scenes;
        count = scene_resource_action_count(scene);
        for (size_t row = 0; row < count; ++row) {
            SceneActionInfo info;
            SessionAeeBinding *b;
            Run run;
            if (scene_resource_action_at(scene, row, &info) != SCENE_RESOURCE_OK || info.type != SESSION_AEE_TYPE) continue;
            ++rows;
            memset(&run, 0, sizeof run);
            b = session_aee_create(&host);
            if (b == NULL) {
                ++error;
                continue;
            }
            run.b = b;
            run.info = &info;
            run.body = info.typed_body;
            run.row = row;
            run.ctx = &ctx;
            memset(&ctx, 0, sizeof ctx);
            if (mp_validate_body(info.typed_body, info.typed_body_length, NULL) == MP_OK && session_aee_begin_scene(b, scene) == MP_OK)
                ++validated;
            tiles += (unsigned long)(rd32(run.body, B_PAGES) * rd32(run.body, B_COLS) * rd32(run.body, B_ROWS));
            pages_total += (unsigned long)rd32(run.body, B_PAGES);
            {
                /* phase 0, the layout and the pointer */
                begin(&run, scene);
                layout_checks(&run);
                if (run.body[0x345] != 0) {
                    ++recenter_rows;
                    EXPECT(&run, ctx.recenters == 1);
                }
                tile_tests(&run);
            }
            {
                /* the perfect game */
                int bounds = 0;
                const int allowed = rd32(run.body, B_TRIES), needed = ref_needed(run.body);
                begin(&run, scene);
                EXPECT(&run, perfect_game(&run, &bounds) == 1);
                EXPECT(&run, bounds == 0);
                if (allowed >= needed) {
                    EXPECT(&run, of(&run, O_WON) == 1 && of(&run, O_LOST) == 0);
                    EXPECT(&run, of(&run, O_PAIRS) == needed && of(&run, O_TRIES) == needed);
                    if (run.failures == 0) ++wins;
                    expect_exit(&run, B_BWIN, 0);
                    if (run.failures == 0) ++win_exits;
                } else {
                    EXPECT(&run, of(&run, O_LOST) == 1 && of(&run, O_WON) == 0);
                    EXPECT(&run, of(&run, O_TRIES) == (allowed > 1 ? allowed : 1));
                    if (run.failures == 0) ++loses;
                    expect_exit(&run, B_BLOSE, 0);
                    if (run.failures == 0) ++lose_exits;
                }
            }
            {
                /* the flip-back delay */
                int a = -1, c = -1, third = -1;
                begin(&run, scene);
                if (find_mismatch(&run, &a, &c)) {
                    int bounds = 0;
                    uint32_t deadline;
                    ctx.now = 123456u;
                    EXPECT(&run, flip_pair(&run, a, c, &bounds) == MP_OK);
                    deadline = (uint32_t)of(&run, O_DEADLINE);
                    EXPECT(&run, deadline == ctx.now + (uint32_t)rd32(run.body, B_DELAY));
                    EXPECT(&run, of(&run, O_FLIPBACK) == 1 && of(&run, O_TRIES) == 1 && of(&run, O_PAIRS) == 0);
                    EXPECT(&run, cell_up(&run, a) == 1 && cell_up(&run, c) == 1);
                    /* a third tile does not turn while the pair is shown */
                    for (int i = 0; i < of(&run, O_TOTAL) && third < 0; ++i)
                        if (i != a && i != c && cell_up(&run, i) == 0) third = i;
                    if (third >= 0) {
                        (void)flip_cell(&run, third);
                        EXPECT(&run, cell_up(&run, third) == 0);
                        ++blocked;
                    }
                    ctx.now = deadline; /* strict compare: nothing yet */
                    (void)visit(&run);
                    EXPECT(&run, of(&run, O_FLIPBACK) == 1 && cell_up(&run, a) == 1);
                    ctx.now = deadline + 1u;
                    (void)visit(&run);
                    {
                        /* the unsigned compare of the original: a wrapped deadline (0xffffffff + 1) is not below the tick */
                        const int turned = of(&run, O_FLIPBACK) == 0;
                        EXPECT(&run, turned == (deadline < deadline + 1u));
                        if (turned) {
                            EXPECT(&run, cell_up(&run, a) == 0 && cell_up(&run, c) == 0 && of(&run, O_FIRST) == 0 && of(&run, O_SECOND) == 0);
                            ++flipbacks;
                        }
                    }
                    ++mismatches;
                }
            }
            {
                /* the tries run out */
                int a = -1, c = -1, guard = 0;
                const int allowed = rd32(run.body, B_TRIES);
                begin(&run, scene);
                while (of(&run, O_LOST) == 0 && of(&run, O_WON) == 0 && guard++ < 300 && find_mismatch(&run, &a, &c)) {
                    int bounds = 0;
                    uint32_t deadline;
                    if (flip_pair(&run, a, c, &bounds) != MP_OK) break;
                    if (of(&run, O_LOST) != 0) break;
                    deadline = (uint32_t)of(&run, O_DEADLINE);
                    ctx.now = deadline + 1u;
                    (void)visit(&run);
                    if (of(&run, O_FLIPBACK) != 0) { ++run.nav_fail; break; }
                }
                if (allowed <= 300) {
                    EXPECT(&run, of(&run, O_LOST) == 1 && of(&run, O_WON) == 0);
                    EXPECT(&run, of(&run, O_TRIES) == (allowed > 1 ? allowed : 1));
                    {
                        MpPointerResult p;
                        const size_t t = B_TILES;
                        EXPECT(&run, session_aee_pointer_move(b, (int16_t)((rd32(run.body, t) + rd32(run.body, t + 8)) / 2),
                                                              (int16_t)((rd32(run.body, t + 4) + rd32(run.body, t + 12)) / 2), &p) == MP_OK && p.hit == 0);
                    }
                    if (of(&run, O_LOST) == 1) {
                        const unsigned long before = run.failures;
                        expect_exit(&run, B_BLOSE, 0);
                        if (run.failures == before) ++lose_exits;
                    }
                }
            }
            {
                /* captions enabled: how many flips does the kernel refuse (caption longer than the 104-byte local) */
                int bounds = 0;
                begin(&run, scene);
                ctx.captions = 1;
                (void)perfect_game(&run, &bounds);
                caption_bounds += (unsigned long)bounds;
                ++caption_runs;
            }
            error += run.failures;
            tile_hits += run.tile_hits;
            tile_misses += run.tile_misses;
            tab_hits += run.tab_hits;
            pairs += run.pairs;
            nav_fail += run.nav_fail;
            session_aee_destroy(b);
        }
        scene_resource_close(scene);
        free(bytes);
    }
    printf("SUMMARY scenes=%lu rows=%lu validated=%lu pages=%lu tiles=%lu recenter_rows=%lu tile_hits=%lu point_misses=%lu tab_hits=%lu "
           "pairs=%lu mismatches=%lu flipbacks=%lu blocked=%lu wins=%lu loses=%lu win_exits=%lu lose_exits=%lu nav_fail=%lu "
           "caption_runs=%lu caption_bounds=%lu error=%lu\n",
           scenes, rows, validated, pages_total, tiles, recenter_rows, tile_hits, tile_misses, tab_hits, pairs, mismatches, flipbacks,
           blocked, wins, loses, win_exits, lose_exits, nav_fail, caption_runs, caption_bounds, error);
    return error == 0 ? 0 : 1;
}
