/* RT-55 corpus check: runs every raw 0xf5 row of the decoded scene resources given on the command line through the production
 * parser, the session binding and the kernel with a scripted host. Pass 0 of a row: begin_scene validates the body, phase 0
 * initialises the quiz, a scripted player types the character of a flying balloon on every visit (the key goes through the
 * binding, the pop is confirmed by the hit counter), the clock runs out (time-up), the wait for the end passes and the finish
 * block runs (phase 2, passed or normal exit, generic completion). Pass 1 (a fresh binding): phase 0, one idle visit, then the
 * click rectangle is hit with the pointer, the click ends the run and the finish runs. Output is derived counts only: one
 * "ROW_FAIL ..." line per failing row and a final "SUMMARY ..." line. Resource bytes stay in work/. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_af5.h"

typedef struct {
    int loads, releases, plays, transitions, flag_stores, registers, stops, prepares;
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
static int release_slot(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int mark_dirty(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int view_rects(void *c, int32_t a[4], int32_t l[4])
{
    static const int32_t va[4] = {7, 11, 647, 491}, vl[4] = {0, 0, 640, 480};
    (void)c;
    memcpy(a, va, sizeof va);
    memcpy(l, vl, sizeof vl);
    return 0;
}
static int clear_item(void *c) { (void)c; return 0; }
static int font_acquire(void *c) { (void)c; return 0; }
static int font_release(void *c) { (void)c; return 0; }
static int sound_prepare(void *c, const uint8_t *r) { (void)r; ((Ctx *)c)->prepares++; return 0; }
static int sound_stop(void *c, const uint8_t *r) { (void)r; ((Ctx *)c)->stops++; return 0; }
static int sound_play(void *c, int16_t ch) { (void)ch; ((Ctx *)c)->plays++; return 0; }
static uint32_t tick(void *c) { return ((Ctx *)c)->now; }
static int32_t rnd(void *c)
{
    Ctx *x = (Ctx *)c;
    x->seed = x->seed * 1103515245u + 12345u;
    return (int32_t)((x->seed >> 16) & 0x7fffu);
}
static int flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 4096; }
static int transition(void *c, const TqzTransition *t) { (void)t; ((Ctx *)c)->transitions++; return 0; }
static int store_flag(void *c, int16_t i, uint32_t v) { (void)i; (void)v; ((Ctx *)c)->flag_stores++; return 0; }
static int engine_mode(void *c, int32_t m) { (void)c; (void)m; return 0; }

enum { O_RECT = 0x55e };

static int32_t rd32(const uint8_t *b, size_t o)
{
    return (int32_t)((uint32_t)b[o] | ((uint32_t)b[o + 1] << 8) | ((uint32_t)b[o + 2] << 16) | ((uint32_t)b[o + 3] << 24));
}

typedef struct {
    SessionAf5Binding *b;
    const SceneActionInfo *info;
    size_t row;
    uint32_t phase;
    unsigned long visits, renders, blits;
} Run;

static int visit(Run *r, int *completed)
{
    SceneActionRuntimeState st;
    SceneActionHandlerResult out;
    TqzRenderResult rr;
    memset(&st, 0, sizeof st);
    memset(&out, 0, sizeof out);
    st.phase = r->phase;
    if (session_af5_handler(r->b, r->row, r->info, &st, &out) != SCENE_ACTION_HANDLER_OK) return 0;
    r->phase = out.phase;
    r->visits++;
    *completed = out.disposition == SCENE_ACTION_HANDLER_COMPLETED;
    if (!*completed && session_af5_object(r->b)->active != 0) { /* an ended quiz has nothing left to draw */
        if (session_af5_render(r->b, &rr) != TQZ_OK || !rr.valid) return 0;
        r->renders++;
        r->blits += rr.count;
        if (session_af5_render_score(r->b, &rr) != TQZ_OK || !rr.valid) return 0;
        r->blits += rr.count;
        if (session_af5_render_clock(r->b, &rr) != TQZ_OK || !rr.valid) return 0;
        r->blits += rr.count;
    }
    return 1;
}

int main(int argc, char **argv)
{
    static Ctx ctx;
    SessionAf5Host host;
    unsigned long rows = 0, validated = 0, phase0 = 0, timeup = 0, passed = 0, normal = 0, click_end = 0, error = 0, scenes = 0;
    unsigned long typed = 0, hit = 0, visits = 0, renders = 0, blits = 0, finish_blocks = 0;
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
    host.kernel.clear_pending_item = clear_item;
    host.kernel.font_acquire = font_acquire;
    host.kernel.font_release = font_release;
    host.kernel.sound_prepare = sound_prepare;
    host.kernel.sound_stop = sound_stop;
    host.kernel.sound_play = sound_play;
    host.kernel.tick = tick;
    host.kernel.random = rnd;
    host.kernel.event_flag_invalid = flag_invalid;
    host.kernel.transition = transition;
    host.kernel.store_event_flag = store_flag;
    host.kernel.engine_mode = engine_mode;
    ctx.seed = 12345u;
    for (int a = 1; a < argc; ++a) {
        FILE *f = fopen(argv[a], "rb");
        long n;
        unsigned char *bytes;
        char err[128] = {0};
        SceneResource *scene;
        size_t count, f5rows = 0;
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
            if (scene_resource_action_at(scene, i, &info) == 0 && info.type == SESSION_AF5_TYPE) ++f5rows;
        }
        if (f5rows == 0) { scene_resource_close(scene); free(bytes); continue; }
        ++scenes;
        for (int pass = 0; pass < 2; ++pass) {
            SessionAf5Binding *binding = session_af5_create(&host);
            if (binding == NULL || session_af5_begin_scene(binding, scene) != TQZ_OK) {
                printf("SCENE_FAIL %s %s\n", argv[a], binding ? session_af5_failure(binding) : "create");
                if (pass == 0) { error += f5rows; rows += f5rows; }
                session_af5_destroy(binding);
                break;
            }
            for (size_t i = 0; i < count; ++i) {
                SceneActionInfo info;
                Run run;
                int good = 1, completed = 0, was_passed = 0;
                const char *why = "phase0";
                const TqzObject *o;
                if (scene_resource_action_at(scene, i, &info) != 0 || info.type != SESSION_AF5_TYPE) continue;
                if (pass == 0) { ++rows; ++validated; }
                memset(&run, 0, sizeof run);
                run.b = binding;
                run.info = &info;
                run.row = i;
                o = session_af5_object(binding);
                ctx.now = 1000000u;
                good = visit(&run, &completed) && run.phase == 1u && !completed && o->active != 0;
                if (good && pass == 0) {
                    unsigned long row_typed = 0, row_hit = 0;
                    ++phase0;
                    why = "play";
                    for (int v = 0; good && v < 120 && o->state == TQZ_STATE_PLAY; ++v) {
                        int pick = -1;
                        ctx.now += 150u;
                        for (int k = 0; k < TQZ_BALLOONS && pick < 0; ++k)
                            if (o->balloon[k].state == TQZ_BALLOON_FLYING && o->balloon[k].ch < 0x80) pick = k;
                        if (pick >= 0 && session_af5_key(binding, run.phase, (int8_t)o->balloon[pick].ch)) {
                            const int32_t before = o->hits;
                            ++row_typed;
                            good = visit(&run, &completed) && !completed;
                            if (good && o->hits == before + 1) ++row_hit;
                        } else {
                            good = visit(&run, &completed) && !completed;
                        }
                    }
                    typed += row_typed;
                    hit += row_hit;
                    why = "timeup";
                    for (int g = 0; good && o->state == TQZ_STATE_PLAY && g < 20000; ++g) {
                        ctx.now += 1000u;
                        good = visit(&run, &completed) && !completed;
                    }
                    good = good && o->state != TQZ_STATE_PLAY;
                    if (good) ++timeup;
                    why = "finish";
                    for (int g = 0; good && !completed && g < 20000; ++g) {
                        ctx.now += 500u;
                        if (run.phase == 2u) was_passed = o->passed != 0;
                        good = visit(&run, &completed);
                    }
                    good = good && completed && run.phase == 0u && o->active == 0 && row_typed > 0 && row_typed == row_hit;
                    if (good) {
                        if (was_passed) ++passed; else ++normal;
                        ++finish_blocks;
                    }
                } else if (good) {
                    TqzPointerResult pr;
                    uint32_t new_phase = 0;
                    const int32_t cx = (rd32(info.typed_body, O_RECT) + rd32(info.typed_body, O_RECT + 8)) / 2;
                    const int32_t cy = (rd32(info.typed_body, O_RECT + 4) + rd32(info.typed_body, O_RECT + 12)) / 2;
                    why = "click";
                    ctx.now += 150u;
                    good = visit(&run, &completed) && !completed;
                    good = good && session_af5_pointer_move(binding, cx, cy, &pr) == TQZ_OK && pr.hit && pr.candidate == TQZ_CANDIDATE;
                    good = good && session_af5_click(binding, run.phase, pr.candidate, &new_phase) == 1 && new_phase == 2u;
                    run.phase = new_phase;
                    for (int g = 0; good && !completed && g < 20000; ++g) {
                        ctx.now += 500u;
                        good = visit(&run, &completed);
                    }
                    good = good && completed && run.phase == 0u && o->active == 0;
                    if (good) ++click_end;
                }
                visits += run.visits;
                renders += run.renders;
                blits += run.blits;
                if (!good) {
                    ++error;
                    printf("ROW_FAIL %s %zu pass=%d stage=%s %s\n", argv[a], i, pass, why, session_af5_failure(binding));
                }
            }
            session_af5_destroy(binding);
        }
        scene_resource_close(scene);
        free(bytes);
    }
    printf("SUMMARY scenes=%lu rows=%lu validated=%lu phase0=%lu timeup=%lu passed=%lu normal=%lu click_end=%lu finish_blocks=%lu "
           "chars_typed=%lu chars_hit=%lu visits=%lu renders=%lu blits=%lu transitions=%d loads=%d releases=%d error=%lu\n",
           scenes, rows, validated, phase0, timeup, passed, normal, click_end, finish_blocks, typed, hit, visits, renders, blits,
           ctx.transitions, ctx.loads, ctx.releases, error);
    return error == 0 ? 0 : 1;
}
