/* RT-54 corpus check: runs every raw 0xe4 row of the decoded scene resources given on the command line (in the owned game
 * those are the one row each of resources 2295 and 2296, a 5 x 7 board of 26 piece kinds) through the production parser, the
 * session binding and the kernel with a scripted host. Pass 0: validation (begin_scene), phase 0 (board filled, no two equal
 * neighbours), a shuffle, a swap that scores (three in a row: score, time bonus, refill with the matched pieces shown until the
 * deadline), the countdown (time text, then TIME!), the end sound, the high score screen and the restart; then a game won
 * through the target score (WIN!!!, end sound, high score screen, the finish with the win scene block and event flag). Pass 1:
 * phase 0 and the exit button (the click asks for phase 2, the finish applies the exit scene block). Output is derived counts
 * only: one "ROW_FAIL ..." line per failing row and a final "SUMMARY ..." line. Resource bytes stay in work/ and are never
 * printed. The board is scripted through the host's rand so that a scoring swap is known to exist after a shuffle: cells
 * (0,0), (0,1), (0,2) and (1,1) hold kinds a, b, a, a and swapping (0,1) with (1,1) makes the row a a a. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_ae4.h"

typedef struct {
    int loads, releases, plays, stops, prepares, scene_changes, flag_stores, renders, text_ops, blit_ops, slots, slot_releases;
    uint32_t now;
    int32_t queue[128];
    int queue_n, queue_i;
    uint32_t lcg;
    int16_t last_scene;
    int16_t last_flag;
} Ctx;

static int alloc_slot(void *c, int16_t *s) { (void)c; *s = 0x18; ((Ctx *)c)->slots++; return 0; }
static int register_slot(void *c, int16_t s, const char *label)
{
    (void)c; (void)s;
    return strcmp(label, "MATCH PUZZLE OVERLAYS") != 0;
}
static int load_surface(void *c, int kind, const char *n, uint32_t *s)
{
    ((Ctx *)c)->loads++;
    *s = n[0] != '\0' ? 5u + (uint32_t)kind : 0u;
    return 0;
}
static int set_slot_surface(void *c, int16_t s, uint32_t surf) { (void)c; (void)s; (void)surf; return 0; }
static int release_surface(void *c, uint32_t s) { (void)s; ((Ctx *)c)->releases++; return 0; }
static int release_slot(void *c, int16_t s) { (void)s; ((Ctx *)c)->slot_releases++; return 0; }
static int mark_dirty(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int view_rects(void *c, int32_t v[4], int32_t f[4])
{
    (void)c;
    v[0] = 10; v[1] = 10; v[2] = 629; v[3] = 384;
    f[0] = 0; f[1] = 0; f[2] = 619; f[3] = 374;
    return 0;
}
static int sound_prepare(void *c, const uint8_t *r) { (void)r; ((Ctx *)c)->prepares++; return 0; }
static int sound_stop(void *c, const uint8_t *r) { (void)r; ((Ctx *)c)->stops++; return 0; }
static int sound_play(void *c, int16_t ch) { (void)ch; ((Ctx *)c)->plays++; return 0; }
static int sound_busy(void *c, int16_t ch, int32_t *r) { (void)c; (void)ch; *r = 0; return 0; }
static uint32_t tick(void *c) { return ((Ctx *)c)->now; }
static int random_value(void *c, int32_t *v)
{
    Ctx *x = (Ctx *)c;
    if (x->queue_i < x->queue_n) {
        *v = x->queue[x->queue_i++];
    } else {
        x->lcg = x->lcg * 214013u + 2531011u;
        *v = (int32_t)((x->lcg >> 16) & 0x7fffu);
    }
    return 0;
}
static int stop_ambient(void *c) { (void)c; return 0; }
static int font_release(void *c, int16_t f) { (void)c; (void)f; return 0; }
static int text_extent(void *c, int16_t f, int16_t *h) { (void)c; (void)f; *h = 14; return 0; }
static int flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 4096; }
static int transition(void *c, const E4rTransition *t) { ((Ctx *)c)->scene_changes++; ((Ctx *)c)->last_scene = t->scene; return 0; }
static int store_flag(void *c, int16_t i, uint32_t v) { (void)v; ((Ctx *)c)->flag_stores++; ((Ctx *)c)->last_flag = i; return 0; }

typedef struct {
    SessionAe4Binding *b;
    const SceneActionInfo *info;
    size_t row;
    uint32_t phase;
    int completed;
} Run;

static int16_t rd16(const uint8_t *b, size_t o) { return (int16_t)(uint16_t)(b[o] | (b[o + 1] << 8)); }
static int32_t rd32(const uint8_t *b, size_t o)
{
    return (int32_t)((uint32_t)b[o] | ((uint32_t)b[o + 1] << 8) | ((uint32_t)b[o + 2] << 16) | ((uint32_t)b[o + 3] << 24));
}

static Ctx *g_ctx;
static E4rRenderResult g_render;

/* One handler visit as the executor makes it, then the render callback like the engine's draw pass. */
static int visit(Run *r)
{
    SceneActionRuntimeState st;
    SceneActionHandlerResult out;
    memset(&st, 0, sizeof st);
    memset(&out, 0, sizeof out);
    st.phase = r->phase;
    if (session_ae4_handler(r->b, r->row, r->info, &st, &out) != SCENE_ACTION_HANDLER_OK) return 0;
    r->phase = out.phase;
    r->completed = out.disposition == SCENE_ACTION_HANDLER_COMPLETED;
    if (!r->completed) {
        if (session_ae4_render(r->b, &g_render) != E4R_OK) return 0;
        ++g_ctx->renders;
        for (uint16_t i = 0; i < g_render.count; ++i) {
            if (g_render.op[i].kind == E4R_OP_TEXT) ++g_ctx->text_ops; else ++g_ctx->blit_ops;
        }
    }
    return 1;
}

static const E4rObject *obj(const Run *r) { return session_ae4_state(r->b); }
static int32_t ofield(const Run *r, size_t off) { return rd32(obj(r)->b, off); }
static int state(const Run *r) { return ofield(r, E4R_O_STATE); }
#define CELLOFF(rr, cc) ((size_t)E4R_O_CELLS + (size_t)(rr) * 200u + (size_t)(cc) * 20u)

/* Visits until the state is PLAY with no check pending; the clock is moved to each deadline (refill, shuffle). */
static int settle(Run *r)
{
    for (int i = 0; i < 64; ++i) {
        const E4rObject *o = obj(r);
        const int st = state(r);
        if (st == E4R_STATE_PLAY && o->b[E4R_O_CHECK_FIRST] == 0 && o->b[E4R_O_CHECK_SECOND] == 0) return 1;
        if (st == E4R_STATE_REFILL && (uint32_t)ofield(r, E4R_O_DEADLINE) > g_ctx->now) g_ctx->now = (uint32_t)ofield(r, E4R_O_DEADLINE);
        if (st == E4R_STATE_SHUFFLE && (uint32_t)ofield(r, E4R_O_SHUFFLE_END) > g_ctx->now)
            g_ctx->now = (uint32_t)ofield(r, E4R_O_SHUFFLE_END);
        if (st != E4R_STATE_PLAY && st != E4R_STATE_REFILL && st != E4R_STATE_SHUFFLE) return 0;
        if (!visit(r) || r->completed) return 0;
    }
    return 0;
}

static int cell_xy(const Run *r, int row, int col, int32_t *x, int32_t *y)
{
    const uint8_t *b = obj(r)->b;
    *x = (rd32(b, CELLOFF(row, col) + 4) + rd32(b, CELLOFF(row, col) + 12)) / 2;
    *y = (rd32(b, CELLOFF(row, col) + 8) + rd32(b, CELLOFF(row, col) + 16)) / 2;
    return 1;
}

/* The pointer over a piece (hit test 0x475da4) and the accepted release (click 0x47608e). */
static int click_piece(Run *r, int row, int col)
{
    E4rPointerResult pr;
    E4rClickResult cr;
    int32_t x, y;
    cell_xy(r, row, col, &x, &y);
    if (session_ae4_pointer_move(r->b, x, y, &pr) != E4R_OK || pr.hit != 1u || pr.candidate != E4R_CANDIDATE_PIECE) return 0;
    if (session_ae4_click(r->b, r->phase, pr.candidate, &cr) != E4R_OK || cr.fired != 1u || cr.phase_changed != 0u) return 0;
    return 1;
}

static int click_rect(Run *r, const uint8_t *body, size_t off, int32_t candidate, E4rClickResult *cr)
{
    E4rPointerResult pr;
    const int32_t x = (rd32(body, off) + rd32(body, off + 8)) / 2, y = (rd32(body, off + 4) + rd32(body, off + 12)) / 2;
    if (session_ae4_pointer_move(r->b, x, y, &pr) != E4R_OK || pr.hit != 1u || pr.candidate != candidate) return 0;
    return session_ae4_click(r->b, r->phase, pr.candidate, cr) == E4R_OK && cr->fired == 1u;
}

/* The scripted board: kinds a, b, a, a at (0,0), (0,1), (0,2), (1,1); everything else a pattern without equal neighbours. */
static int engineered(Ctx *ctx, int rows, int cols, int kinds)
{
    const int m = kinds - 1;
    int board[10][10];
    if (rows < 2 || cols < 4 || m < 12 || rows * cols > 100) return 0;
    for (int r = 0; r < rows; ++r)
        for (int c = 0; c < cols; ++c) board[r][c] = (r * 3 + c * 5 + 1) % m;
    board[0][0] = 1; board[0][1] = 2; board[0][2] = 1; board[1][1] = 1;
    for (int r = 0; r < rows; ++r)
        for (int c = 0; c < cols; ++c) {
            if (r > 0 && board[r][c] == board[r - 1][c]) return 0;
            if (c > 0 && board[r][c] == board[r][c - 1]) return 0;
            ctx->queue[r * cols + c] = board[r][c];
        }
    ctx->queue_n = rows * cols;
    ctx->queue_i = 0;
    return 1;
}

static int board_ok(const Run *r, int rows, int cols, int kinds)
{
    const uint8_t *b = obj(r)->b;
    for (int row = 0; row < rows; ++row)
        for (int col = 0; col < cols; ++col) {
            const int k = rd16(b, CELLOFF(row, col) + 2);
            if (b[CELLOFF(row, col)] != 1 || b[CELLOFF(row, col) + 1] != 0 || k < 0 || k > kinds - 2) return 0;
            if (row > 0 && k == rd16(b, CELLOFF(row - 1, col) + 2)) return 0;
            if (col > 0 && k == rd16(b, CELLOFF(row, col - 1) + 2)) return 0;
        }
    return 1;
}

/* The shuffle button with the scripted board, until it has been applied. */
static int shuffle(Run *r, const uint8_t *body, int rows, int cols, int kinds)
{
    E4rClickResult cr;
    if (!engineered(g_ctx, rows, cols, kinds)) return 0;
    if (!click_rect(r, body, 0x678u, E4R_CANDIDATE_SHUFFLE, &cr)) return 0;
    if (state(r) != E4R_STATE_SHUFFLE || obj(r)->b[E4R_O_SHUFFLE_DOWN] != 1) return 0;
    if (!settle(r)) return 0;
    return obj(r)->b[E4R_O_SHUFFLE_DOWN] == 0 && rd16(obj(r)->b, CELLOFF(0, 0) + 2) == 1 && rd16(obj(r)->b, CELLOFF(0, 1) + 2) == 2 &&
           rd16(obj(r)->b, CELLOFF(1, 1) + 2) == 1 && board_ok(r, rows, cols, kinds);
}

/* Select (0,1), swap with (1,1): the row a a a scores. Returns the score gained or -1. */
static int32_t scoring_swap(Run *r, const uint8_t *body)
{
    const int32_t before = ofield(r, E4R_O_SCORE), time_before = ofield(r, E4R_O_TIME_END);
    if (!click_piece(r, 0, 1) || !click_piece(r, 1, 1)) return -1;
    if (!visit(r) || state(r) != E4R_STATE_REFILL) return -1;
    if (obj(r)->b[CELLOFF(0, 0) + 1] != 1 || obj(r)->b[CELLOFF(0, 1) + 1] != 1 || obj(r)->b[CELLOFF(0, 2) + 1] != 1 ||
        obj(r)->b[CELLOFF(0, 3) + 1] != 0 || obj(r)->b[E4R_O_SHOW_NAME] != 1)
        return -1;
    if (ofield(r, E4R_O_TIME_END) - time_before != rd16(body, 0x656) * 1000) return -1; /* the three-run time bonus */
    if (!settle(r)) return -1;
    return ofield(r, E4R_O_SCORE) - before;
}

static int walk_to_scores(Run *r)
{
    for (int i = 0; i < 24; ++i) {
        if (state(r) == E4R_STATE_SCORES) return 1;
        if (state(r) == E4R_STATE_END_WAIT && (uint32_t)ofield(r, E4R_O_DEADLINE) > g_ctx->now) g_ctx->now = (uint32_t)ofield(r, E4R_O_DEADLINE);
        if (!visit(r) || r->completed) return 0;
    }
    return 0;
}

#define GATE(id, cond)                       \
    do {                                     \
        if (good && !(cond)) {               \
            good = 0;                        \
            fail_step = (id);                \
        }                                    \
    } while (0)

static int block_ok(const uint8_t *body, size_t block, int scenes_before, int flags_before)
{
    return g_ctx->scene_changes - scenes_before == (rd16(body, block) != E4R_NO_SCENE ? 1 : 0) &&
           g_ctx->flag_stores - flags_before == (rd16(body, block + 22u) != E4R_NO_FLAG ? 1 : 0) &&
           (rd16(body, block) == E4R_NO_SCENE || g_ctx->last_scene == rd16(body, block));
}

int main(int argc, char **argv)
{
    static Ctx ctx;
    SessionAe4Host host;
    unsigned long rows = 0, validated = 0, won = 0, timed_out = 0, exited = 0, matches = 0, shuffles = 0, error = 0, scenes = 0;
    g_ctx = &ctx;
    memset(&host, 0, sizeof host);
    host.kernel.context = &ctx;
    host.kernel.alloc_slot = alloc_slot;
    host.kernel.register_slot = register_slot;
    host.kernel.load_surface = load_surface;
    host.kernel.set_slot_surface = set_slot_surface;
    host.kernel.release_surface = release_surface;
    host.kernel.release_slot = release_slot;
    host.kernel.mark_dirty = mark_dirty;
    host.kernel.view_rects = view_rects;
    host.kernel.sound_prepare = sound_prepare;
    host.kernel.sound_stop = sound_stop;
    host.kernel.sound_play = sound_play;
    host.kernel.sound_busy = sound_busy;
    host.kernel.tick = tick;
    host.kernel.random = random_value;
    host.kernel.stop_ambient = stop_ambient;
    host.kernel.font_release = font_release;
    host.kernel.text_extent = text_extent;
    host.kernel.event_flag_invalid = flag_invalid;
    host.kernel.transition = transition;
    host.kernel.store_event_flag = store_flag;
    for (int a = 1; a < argc; ++a) {
        FILE *f = fopen(argv[a], "rb");
        long n;
        unsigned char *bytes;
        char err[128] = {0};
        SceneResource *scene;
        size_t count, e4rows = 0;
        if (f == NULL) continue;
        fseek(f, 0, SEEK_END);
        n = ftell(f);
        fseek(f, 0, SEEK_SET);
        bytes = (unsigned char *)malloc((size_t)n);
        if (bytes == NULL || fread(bytes, 1, (size_t)n, f) != (size_t)n) { fclose(f); free(bytes); continue; }
        fclose(f);
        scene = scene_resource_open_memory(bytes, (size_t)n, err, sizeof err);
        if (scene == NULL) { free(bytes); continue; }
        count = scene_resource_action_count(scene);
        for (size_t i = 0; i < count; ++i) {
            SceneActionInfo info;
            if (scene_resource_action_at(scene, i, &info) == 0 && info.type == SESSION_AE4_TYPE) ++e4rows;
        }
        if (e4rows == 0) { scene_resource_close(scene); free(bytes); continue; }
        ++scenes;
        for (int pass = 0; pass < 2; ++pass) {
            SessionAe4Binding *binding = session_ae4_create(&host);
            if (binding == NULL || session_ae4_begin_scene(binding, scene) != E4R_OK) {
                printf("SCENE_FAIL %s %s\n", argv[a], binding ? session_ae4_failure(binding) : "create");
                if (pass == 0) { error += e4rows; rows += e4rows; }
                session_ae4_destroy(binding);
                break;
            }
            for (size_t i = 0; i < count; ++i) {
                SceneActionInfo info;
                Run run;
                const uint8_t *body;
                int good = 1, rowsn, colsn, kinds, per;
                int scenes_before, flags_before, fail_step = 0;
                int32_t target;
                if (scene_resource_action_at(scene, i, &info) != 0 || info.type != SESSION_AE4_TYPE) continue;
                body = info.typed_body;
                if (pass == 0) { ++rows; ++validated; }
                rowsn = rd16(body, 0x42);
                colsn = rd16(body, 0x44);
                kinds = rd16(body, 0x46);
                per = rd16(body, 0x644);
                target = rd32(body, 0x640);
                run.b = binding;
                run.info = &info;
                run.row = i;
                run.phase = 0u;
                run.completed = 0;
                ctx.now = 100000u;
                ctx.lcg = 7u + (unsigned)i;
                ctx.queue_n = ctx.queue_i = 0;
                scenes_before = ctx.scene_changes;
                flags_before = ctx.flag_stores;
                /* Phase 0: the board is filled without equal neighbours, the surfaces and slot are acquired. */
                GATE(1, visit(&run) && run.phase == 1u && !run.completed && state(&run) == E4R_STATE_PLAY &&
                       session_ae4_registered(binding) == 1u && ofield(&run, E4R_O_ACTIVE) == 1 && ofield(&run, E4R_O_SCORE) == 0 &&
                       board_ok(&run, rowsn, colsn, kinds) && (uint32_t)ofield(&run, E4R_O_TIME_END) == ctx.now + (uint32_t)(rd16(body, 0x63e) * 1000));
                if (pass == 0) {
                    int32_t gained = -1;
                    const int32_t limit = rd16(body, 0x63e);
                    /* A shuffle, then a swap that scores and its refill. */
                    GATE(10, shuffle(&run, body, rowsn, colsn, kinds));
                    if (good) ++shuffles;
                    if (good) gained = scoring_swap(&run, body);
                    GATE(11, gained == 3 * per && board_ok(&run, rowsn, colsn, kinds));
                    if (good) ++matches;
                    {
                        char want[16];
                        snprintf(want, sizeof want, "%d", (int)gained);
                        GATE(12, obj(&run)->b[E4R_O_SHOW_NAME] == 0 && strcmp((const char *)obj(&run)->b + E4R_O_SCORE_TEXT, want) == 0);
                    }
                    /* The countdown: the time text, then TIME!, the end sound, the high score screen and the restart. */
                    if (good) {
                        const uint32_t end = (uint32_t)ofield(&run, E4R_O_TIME_END);
                        ctx.now = end - 125000u;
                        GATE(20, visit(&run) && strcmp((const char *)obj(&run)->b + E4R_O_TIME_TEXT, " 2m  5s") == 0 &&
                                     state(&run) == E4R_STATE_PLAY);
                        ctx.now = end - 499u;
                        GATE(21, visit(&run) && state(&run) == E4R_STATE_END && ofield(&run, E4R_O_WON) == 0 &&
                                     strcmp((const char *)obj(&run)->b + E4R_O_TIME_TEXT, "TIME!") == 0);
                        if (good) ++timed_out;
                        GATE(22, visit(&run) && state(&run) == E4R_STATE_END_WAIT && walk_to_scores(&run));
                        /* The visit that reached the score screen set the erase of the whole view; its render drew it first. */
                        GATE(23, g_render.valid == 1u && g_render.count == 8u && g_render.op[0].label == E4R_LABEL_ERASE_ALL &&
                                     g_render.op[1].label == E4R_LABEL_SCORES_BACKDROP && g_render.op[1].surface_role == E4R_SURFACE_SCORE &&
                                     obj(&run)->b[E4R_O_ERASE_ALL] == 0);
                        GATE(24, session_ae4_render(binding, &g_render) == E4R_OK && g_render.count == 7u);
                        ctx.now = (uint32_t)ofield(&run, E4R_O_DEADLINE);
                        GATE(25, visit(&run) && state(&run) == E4R_STATE_PLAY && ofield(&run, E4R_O_SCORE) == 0 &&
                                     session_ae4_world(binding)->high_score[0] == gained && session_ae4_world(binding)->high_score[1] == 0 &&
                                     limit > 0 && board_ok(&run, rowsn, colsn, kinds));
                    }
                    /* A game won through the target score. */
                    for (int cycle = 0; good && cycle < 400 && state(&run) == E4R_STATE_PLAY && ofield(&run, E4R_O_WON) == 0; ++cycle) {
                        GATE(30, shuffle(&run, body, rowsn, colsn, kinds));
                        if (good) ++shuffles;
                        GATE(31, scoring_swap(&run, body) == 3 * per);
                        if (good) ++matches;
                        GATE(32, visit(&run));
                    }
                    GATE(33, state(&run) == E4R_STATE_END && ofield(&run, E4R_O_WON) == 1 && ofield(&run, E4R_O_SCORE) >= target &&
                                 strcmp((const char *)obj(&run)->b + E4R_O_TIME_TEXT, "WIN!!!") == 0);
                    if (good) ++won;
                    GATE(34, visit(&run) && state(&run) == E4R_STATE_END_WAIT && walk_to_scores(&run));
                    if (good) {
                        const int32_t score = ofield(&run, E4R_O_SCORE);
                        ctx.now = (uint32_t)ofield(&run, E4R_O_DEADLINE);
                        GATE(35, visit(&run) && run.phase == 2u && !run.completed && session_ae4_world(binding)->high_score[0] == score &&
                                     session_ae4_world(binding)->high_score[1] == 3 * per && session_ae4_world(binding)->high_score[2] == 0);
                        /* The finish: win scene block, event flag, generic completion, cleanup. */
                        GATE(36, visit(&run) && run.completed && run.phase == 2u && ofield(&run, E4R_O_ACTIVE) == 0 &&
                                     session_ae4_registered(binding) == 0u && block_ok(body, 0x77du, scenes_before, flags_before));
                    }
                } else {
                    E4rClickResult cr;
                    /* The exit button asks for phase 2; the finish applies the exit scene block. */
                    GATE(40, click_rect(&run, body, 0x7e2u, E4R_CANDIDATE_EXIT, &cr) && cr.phase_changed == 1u && cr.phase == 2u);
                    if (good) run.phase = cr.phase;
                    GATE(41, visit(&run) && run.completed && ofield(&run, E4R_O_ACTIVE) == 0 &&
                                 block_ok(body, 0x7c9u, scenes_before, flags_before));
                    if (good) ++exited;
                }
                if (!good) {
                    ++error;
                    printf("ROW_FAIL %s %zu pass=%d step=%d %s\n", argv[a], i, pass, fail_step, session_ae4_failure(binding));
                }
            }
            session_ae4_destroy(binding);
        }
        scene_resource_close(scene);
        free(bytes);
    }
    printf("SUMMARY scenes=%lu rows=%lu validated=%lu won=%lu timed_out=%lu exited=%lu matches=%lu shuffles=%lu error=%lu loads=%d "
           "releases=%d slots=%d slot_releases=%d plays=%d prepares=%d stops=%d scene_changes=%d flag_stores=%d renders=%d blit_ops=%d text_ops=%d\n",
           scenes, rows, validated, won, timed_out, exited, matches, shuffles, error, ctx.loads, ctx.releases, ctx.slots,
           ctx.slot_releases, ctx.plays, ctx.prepares, ctx.stops, ctx.scene_changes, ctx.flag_stores, ctx.renders, ctx.blit_ops,
           ctx.text_ops);
    return error == 0 ? 0 : 1;
}
