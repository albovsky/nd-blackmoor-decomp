/* RT-59 corpus check: runs every raw 0xda row of the decoded scene resources given on the command line through the production
 * parser, the session binding and the kernel with a scripted host. Each row is played to its end several times:
 *  - "played" games (many seeds): begin_scene validates the body, phase 0 initialises the puzzle, a scripted player rolls
 *    (pointer on button 0, click 0x27ba), sometimes passes (button 1 in modes 1 and 3) and presses the reset button once
 *    (button 2); the computer's turns run by themselves; the kernel renders every visit; the game ends by the winning score
 *    (state 7 or 8, row phase 2, the finish block, generic completion);
 *  - "left" games: phase 0, a few turns, then the finish rectangle is hit with the pointer (candidate 0x27bb) and clicked; the
 *    game is left (finish kind 0) and the finish runs.
 * Output is derived counts only: one "ROW_FAIL ..." line per failing game and a final "SUMMARY ..." line. Resource bytes and
 * decoded strings stay in work/ and are never printed. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_ada.h"

enum { PLAYED_SEEDS = 24, LEFT_SEEDS = 4, VISIT_LIMIT = 600000, VISIT_STEP_MS = 90 };

typedef struct {
    int loads, releases, plays, stops, prepares, registers, slot_releases, transitions, flag_stores, engine_modes, captions_shown,
        captions_text, randoms, completes, row_phase_2, blits;
    uint32_t now, seed;
} Ctx;

static int alloc_slot(void *c, int16_t *s) { (void)c; *s = 0x19; return 0; }
static int register_slot(void *c, int16_t s, int32_t t, int cb, uint32_t surf, const char *l)
{
    (void)s; (void)t; (void)cb; (void)surf; (void)l;
    ((Ctx *)c)->registers++;
    return 0;
}
static int load_surface(void *c, const char *n, uint32_t *s) { ((Ctx *)c)->loads++; *s = n[0] != '\0' ? 5u : 0u; return 0; }
static int set_slot_surface(void *c, int16_t s, uint32_t surf) { (void)c; (void)s; (void)surf; return 0; }
static int release_surface(void *c, uint32_t s) { (void)s; ((Ctx *)c)->releases++; return 0; }
static int release_slot(void *c, int16_t s) { (void)s; ((Ctx *)c)->slot_releases++; return 0; }
static int mark_dirty(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int view_origin(void *c, int32_t *x, int32_t *y) { (void)c; *x = 7; *y = 11; return 0; }
static int clear_item(void *c) { (void)c; return 0; }
static int sound_prepare(void *c, const uint8_t *n) { (void)n; ((Ctx *)c)->prepares++; return 0; }
static int sound_stop(void *c, const uint8_t *n) { (void)n; ((Ctx *)c)->stops++; return 0; }
static int sound_busy(void *c, int16_t ch) { (void)c; (void)ch; return 0; }
static int sound_play(void *c, int16_t ch) { (void)ch; ((Ctx *)c)->plays++; return 0; }
static const char *caption_text(void *c, const char *name)
{
    (void)name;
    ((Ctx *)c)->captions_text++;
    return "caption";
}
static int caption_show(void *c, const char *text) { (void)text; ((Ctx *)c)->captions_shown++; return 0; }
static uint32_t tick(void *c) { return ((Ctx *)c)->now; }
static int32_t rnd(void *c)
{
    Ctx *x = (Ctx *)c;
    x->seed = x->seed * 1103515245u + 12345u;
    ((Ctx *)c)->randoms++;
    return (int32_t)((x->seed >> 16) & 0x7fffu);
}
static int flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 4096; }
static int transition(void *c, const BulTransition *t) { (void)t; ((Ctx *)c)->transitions++; return 0; }
static int store_flag(void *c, int16_t i, uint32_t v) { (void)i; (void)v; ((Ctx *)c)->flag_stores++; return 0; }
static int engine_mode(void *c, int32_t m) { (void)m; ((Ctx *)c)->engine_modes++; return 0; }
static void observe(void *c, int effect, int32_t a, int32_t b)
{
    (void)a; (void)b;
    if (effect == BUL_FX_COMPLETE) ((Ctx *)c)->completes++;
    if (effect == BUL_FX_ROW_PHASE && a == 2) ((Ctx *)c)->row_phase_2++;
}

static int32_t rd32(const uint8_t *b, size_t o)
{
    return (int32_t)((uint32_t)b[o] | ((uint32_t)b[o + 1] << 8) | ((uint32_t)b[o + 2] << 16) | ((uint32_t)b[o + 3] << 24));
}

typedef struct {
    SessionAdaBinding *b;
    const SceneActionInfo *info;
    size_t row;
    uint32_t phase;
    unsigned long visits, renders, blits, rolls, passes, resets, steps;
    uint32_t reset_countdown;
} Run;

/* One executor visit of the handler plus the render pass of the tick (the app renders every tick while the entry is registered). */
static int visit(Run *r, Ctx *ctx, int *completed)
{
    SceneActionRuntimeState st;
    SceneActionHandlerResult out;
    BulRenderResult rr;
    memset(&st, 0, sizeof st);
    memset(&out, 0, sizeof out);
    st.phase = r->phase;
    if (session_ada_handler(r->b, r->row, r->info, &st, &out) != SCENE_ACTION_HANDLER_OK) return 0;
    r->phase = out.phase;
    r->visits++;
    *completed = out.disposition == SCENE_ACTION_HANDLER_COMPLETED;
    if (!*completed && session_ada_registered(r->b)) {
        if (session_ada_render(r->b, &rr) != BUL_OK) return 0;
        if (rr.valid) {
            r->renders++;
            r->blits += rr.count;
            ctx->blits += rr.count;
        }
    }
    return 1;
}

/* Point at the center of a body rectangle and click the candidate the hit test wrote; returns the pointer result. */
static int press(Run *r, size_t rect_offset, int32_t candidate, int32_t expect_button, BulClickResult *click)
{
    BulPointerResult pr;
    const uint8_t *body = r->info->typed_body;
    const int32_t cx = (rd32(body, rect_offset) + rd32(body, rect_offset + 8)) / 2;
    const int32_t cy = (rd32(body, rect_offset + 4) + rd32(body, rect_offset + 12)) / 2;
    if (session_ada_pointer_move(r->b, cx, cy, &pr) != BUL_OK) return 0;
    if (!pr.hit || pr.candidate != candidate || pr.button != expect_button) return 0;
    if (session_ada_click(r->b, r->phase, pr.candidate, click) != BUL_OK) return 0;
    return click->handled != 0u;
}

/* The player's decision on a visit: nothing to do unless it is the player's turn and the puzzle is idle. Returns 0 on failure. */
static int play_turn(Run *r, Ctx *ctx, const BulObject *o, int *acted)
{
    const uint8_t *body = r->info->typed_body;
    BulClickResult click;
    *acted = 0;
    if (r->phase != 1u || !o->active || o->state != BUL_STATE_IDLE || o->anim_active != 0) return 1;
    if (body[BUL_B_TWO_PLAYERS] == 0 && o->mode >= 2) return 1; /* the computer's turn runs by itself */
    ctx->seed = ctx->seed * 1103515245u + 12345u;
    if (r->reset_countdown > 0u && --r->reset_countdown == 0u) {
        if (!press(r, BUL_B_BUTTON_RECT + 32u, BUL_CANDIDATE_BUTTON, 2, &click)) return 0;
        ++r->resets;
        *acted = 1;
        return 1;
    }
    if ((o->mode == 1 || o->mode == 3) && ((ctx->seed >> 20) & 3u) == 0u) {
        if (!press(r, BUL_B_BUTTON_RECT + 16u, BUL_CANDIDATE_BUTTON, 1, &click)) return 0;
        ++r->passes;
    } else {
        if (!press(r, BUL_B_BUTTON_RECT, BUL_CANDIDATE_BUTTON, 0, &click)) return 0;
        ++r->rolls;
    }
    *acted = 1;
    return 1;
}

int main(int argc, char **argv)
{
    static Ctx ctx;
    SessionAdaHost host;
    unsigned long rows = 0, validated = 0, phase0 = 0, played = 0, ended = 0, won = 0, lost = 0, left = 0, error = 0, scenes = 0;
    unsigned long visits = 0, renders = 0, blits = 0, rolls = 0, passes = 0, resets = 0, finish_blocks = 0;
    memset(&host, 0, sizeof host);
    host.kernel.context = &ctx;
    host.kernel.alloc_slot = alloc_slot;
    host.kernel.register_slot = register_slot;
    host.kernel.load_surface = load_surface;
    host.kernel.set_slot_surface = set_slot_surface;
    host.kernel.release_surface = release_surface;
    host.kernel.release_slot = release_slot;
    host.kernel.mark_dirty = mark_dirty;
    host.kernel.view_origin = view_origin;
    host.kernel.clear_pending_item = clear_item;
    host.kernel.sound_prepare = sound_prepare;
    host.kernel.sound_stop = sound_stop;
    host.kernel.sound_busy = sound_busy;
    host.kernel.sound_play = sound_play;
    host.kernel.caption_text = caption_text;
    host.kernel.caption_show = caption_show;
    host.kernel.tick = tick;
    host.kernel.random = rnd;
    host.kernel.event_flag_invalid = flag_invalid;
    host.kernel.transition = transition;
    host.kernel.store_event_flag = store_flag;
    host.kernel.engine_mode = engine_mode;
    host.kernel.observe = observe;
    for (int a = 1; a < argc; ++a) {
        FILE *f = fopen(argv[a], "rb");
        long n;
        unsigned char *bytes;
        char err[128] = {0};
        SceneResource *scene;
        size_t count, darows = 0;
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
            if (scene_resource_action_at(scene, i, &info) == 0 && info.type == SESSION_ADA_TYPE) ++darows;
        }
        if (darows == 0) { scene_resource_close(scene); free(bytes); continue; }
        ++scenes;
        /* The first game of each row counts the row; the games are separate bindings (a power-on object each). */
        for (int game = 0; game < PLAYED_SEEDS + LEFT_SEEDS; ++game) {
            const int is_left = game >= PLAYED_SEEDS;
            SessionAdaBinding *binding = session_ada_create(&host);
            if (binding == NULL || session_ada_begin_scene(binding, scene) != BUL_OK) {
                printf("SCENE_FAIL %s %s\n", argv[a], binding ? session_ada_failure(binding) : "create");
                if (game == 0) { error += darows; rows += darows; }
                session_ada_destroy(binding);
                break;
            }
            for (size_t i = 0; i < count; ++i) {
                SceneActionInfo info;
                Run run;
                int good = 1, completed = 0, acted = 0, saw_win = 0, saw_lose = 0, saw_end = 0;
                const char *why = "phase0";
                const BulObject *o;
                if (scene_resource_action_at(scene, i, &info) != 0 || info.type != SESSION_ADA_TYPE) continue;
                if (game == 0) { ++rows; ++validated; }
                memset(&run, 0, sizeof run);
                run.b = binding;
                run.info = &info;
                run.row = i;
                run.reset_countdown = 3u + (uint32_t)(game % 5);
                o = session_ada_object(binding);
                ctx.now = 1000000u;
                ctx.seed = 0x1234u + (uint32_t)game * 7919u + (uint32_t)i * 104729u;
                good = visit(&run, &ctx, &completed) && run.phase == 1u && !completed && o->active != 0;
                if (good) {
                    ++phase0;
                    if (is_left) {
                        BulClickResult click;
                        why = "left";
                        for (int v = 0; good && v < 40; ++v) {
                            ctx.now += VISIT_STEP_MS;
                            good = visit(&run, &ctx, &completed) && !completed;
                            if (good && v >= 10 && o->state == BUL_STATE_IDLE && o->anim_active == 0) break;
                        }
                        good = good && press(&run, BUL_B_FINISH_RECT, BUL_CANDIDATE_FINISH, -1, &click);
                        if (good && click.new_phase == 2u) run.phase = 2u;
                        for (int g = 0; good && !completed && g < VISIT_LIMIT; ++g) {
                            ctx.now += VISIT_STEP_MS;
                            if (o->finish_kind != 0) good = 0;
                            else good = visit(&run, &ctx, &completed);
                        }
                        good = good && completed && run.phase == 0u && o->active == 0 && o->finish_kind == 0;
                        if (good) { ++left; ++finish_blocks; }
                    } else {
                        why = "play";
                        ++played;
                        for (long v = 0; good && !completed && v < VISIT_LIMIT; ++v) {
                            ctx.now += VISIT_STEP_MS;
                            if (o->state == BUL_STATE_WIN) saw_win = 1;
                            if (o->state == BUL_STATE_LOSE) saw_lose = 1;
                            if (o->finish_kind != 0) saw_end = 1;
                            good = play_turn(&run, &ctx, o, &acted);
                            if (!good) { why = "turn"; break; }
                            good = visit(&run, &ctx, &completed);
                            if (!good) { why = "visit"; break; }
                        }
                        good = good && completed && run.phase == 0u && o->active == 0 && saw_end && (saw_win != saw_lose);
                        if (good) {
                            ++ended;
                            if (saw_win) ++won; else ++lost;
                            ++finish_blocks;
                        } else if (why[0] == 'p') {
                            why = "finish";
                        }
                    }
                }
                visits += run.visits;
                renders += run.renders;
                blits += run.blits;
                rolls += run.rolls;
                passes += run.passes;
                resets += run.resets;
                if (!good) {
                    ++error;
                    printf("ROW_FAIL %s %zu game=%d stage=%s %s\n", argv[a], i, game, why, session_ada_failure(binding));
                }
            }
            session_ada_destroy(binding);
        }
        scene_resource_close(scene);
        free(bytes);
    }
    printf("SUMMARY scenes=%lu rows=%lu validated=%lu phase0=%lu played=%lu ended=%lu won=%lu lost=%lu left=%lu finish_blocks=%lu "
           "rolls=%lu passes=%lu resets=%lu visits=%lu renders=%lu blits=%lu captions_shown=%d plays=%d transitions=%d "
           "flag_stores=%d engine_modes=%d completes=%d loads=%d releases=%d registers=%d slot_releases=%d error=%lu\n",
           scenes, rows, validated, phase0, played, ended, won, lost, left, finish_blocks, rolls, passes, resets, visits, renders,
           blits, ctx.captions_shown, ctx.plays, ctx.transitions, ctx.flag_stores, ctx.engine_modes, ctx.completes, ctx.loads,
           ctx.releases, ctx.registers, ctx.slot_releases, error);
    return error == 0 ? 0 : 1;
}
