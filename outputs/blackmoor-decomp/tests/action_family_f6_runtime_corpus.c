/* RT-47 corpus check: runs every raw 0xf6 row of the decoded scene resources given on the command line through the
 * production parser, the session binding and the kernel with a scripted host. Per row: phase 0, then the card game is
 * played to its end (the human clicks the first column button or card that answers a pointer probe, every other visit
 * is a phase 1 visit with advancing ticks), the finish runs (phase 2, generic completion) and a second pass takes the
 * exit instead. Output is derived counts only: "ROW_FAIL ..." lines and a final "SUMMARY ..." line. Resource bytes
 * stay in work/. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_af6.h"

typedef struct {
    int loads, releases, plays, captions, scene_changes, flag_stores;
    uint32_t now, seed;
} Ctx;

static int alloc_slot(void *c, int16_t *s) { (void)c; *s = 0x18; return 0; }
static int register_slot(void *c, int16_t s, const char *label)
{
    (void)c; (void)s;
    return strcmp(label, "MATCH PUZZLE OVERLAYS") != 0;
}
static int load_surface(void *c, const char *n, uint32_t *s) { ((Ctx *)c)->loads++; *s = n[0] != '\0' ? 5u : 0u; return 0; }
static int set_slot_surface(void *c, int16_t s, uint32_t surf) { (void)c; (void)s; (void)surf; return 0; }
static int release_surface(void *c, uint32_t s) { (void)s; ((Ctx *)c)->releases++; return 0; }
static int release_slot(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int mark_dirty(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int view_origin(void *c, int32_t *x, int32_t *y) { (void)c; *x = 0; *y = 0; return 0; }
static int clear_item(void *c) { (void)c; return 0; }
static int sound_prepare(void *c, const uint8_t *r) { (void)c; (void)r; return 0; }
static int sound_play(void *c, int16_t ch) { (void)ch; ((Ctx *)c)->plays++; return 0; }
static int sound_busy(void *c, int16_t ch, int32_t *r) { (void)c; (void)ch; *r = 0; return 0; }
static uint32_t tick(void *c) { Ctx *x = (Ctx *)c; x->now += 400u; return x->now; }
static int32_t rnd(void *c)
{
    Ctx *x = (Ctx *)c;
    x->seed = x->seed * 214013u + 2531011u;
    return (int32_t)((x->seed >> 16) & 0x7fffu);
}
static int autotext(void *c, const char *key, const char **text) { (void)c; (void)key; *text = "caption"; return 0; }
static int caption(void *c, const char *t, size_t n) { (void)t; (void)n; ((Ctx *)c)->captions++; return 0; }
static int flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 4096; }
static int transition(void *c, const F6Transition *t) { (void)t; ((Ctx *)c)->scene_changes++; return 0; }
static int store_flag(void *c, int16_t i, uint32_t v) { (void)i; (void)v; ((Ctx *)c)->flag_stores++; return 0; }

typedef struct { SessionAf6Binding *b; const SceneActionInfo *info; size_t row; uint32_t phase; } Run;

static int visit(Run *r, SceneActionHandlerResult *out, int *completed)
{
    SceneActionRuntimeState st;
    memset(&st, 0, sizeof st);
    memset(out, 0, sizeof *out);
    st.phase = r->phase;
    if (session_af6_handler(r->b, r->row, r->info, &st, out) != SCENE_ACTION_HANDLER_OK) return 0;
    r->phase = out->phase;
    *completed = out->disposition == SCENE_ACTION_HANDLER_COMPLETED;
    return 1;
}

static int32_t rd32(const uint8_t *b, size_t o)
{
    return (int32_t)((uint32_t)b[o] | ((uint32_t)b[o + 1] << 8) | ((uint32_t)b[o + 2] << 16) | ((uint32_t)b[o + 3] << 24));
}

/* Probes the centre of every column button and card rectangle; clicks the first one that answers. */
static int human_click(Run *r, const uint8_t *body, int cols, int rows)
{
    F6PointerResult pr;
    uint32_t np = 1u;
    for (int k = 0; k < cols; ++k) {
        for (int pass = 0; pass < 1 + rows; ++pass) {
            const size_t o = pass == 0 ? 0x653u + (size_t)k * 16u : 0x723u + (size_t)(pass - 1) * 0xd0u + (size_t)k * 16u;
            const int16_t x = (int16_t)((rd32(body, o) + rd32(body, o + 8)) / 2);
            const int16_t y = (int16_t)((rd32(body, o + 4) + rd32(body, o + 12)) / 2);
            if (session_af6_pointer_move(r->b, x, y, &pr) != F6_OK || pr.hit == 0u) continue;
            if (pr.candidate != F6_CANDIDATE_BUTTON && pr.candidate != F6_CANDIDATE_CARD) continue;
            if (session_af6_click(r->b, r->phase, pr.candidate, &np) != F6_OK) return -1;
            r->phase = np;
            return 1;
        }
    }
    return 0;
}

int main(int argc, char **argv)
{
    static Ctx ctx;
    SessionAf6Host host;
    unsigned long rows = 0, played = 0, exited = 0, error = 0, scenes = 0;
    memset(&host, 0, sizeof host);
    ctx.seed = 20241017u;
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
    host.kernel.sound_play = sound_play;
    host.kernel.sound_busy = sound_busy;
    host.kernel.tick = tick;
    host.kernel.random = rnd;
    host.kernel.autotext = autotext;
    host.kernel.caption = caption;
    host.kernel.transition = transition;
    host.kernel.store_event_flag = store_flag;
    host.kernel.event_flag_invalid = flag_invalid;
    for (int a = 1; a < argc; ++a) {
        FILE *f = fopen(argv[a], "rb");
        long n;
        unsigned char *bytes;
        char err[128] = {0};
        SceneResource *scene;
        size_t count, frows = 0;
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
            if (scene_resource_action_at(scene, i, &info) == 0 && info.type == SESSION_AF6_TYPE) ++frows;
        }
        if (frows == 0) { scene_resource_close(scene); free(bytes); continue; }
        ++scenes;
        for (int pass = 0; pass < 2; ++pass) {
            SessionAf6Binding *binding = session_af6_create(&host);
            if (binding == NULL || session_af6_begin_scene(binding, scene) != F6_OK) {
                printf("SCENE_FAIL %s %s\n", argv[a], binding ? session_af6_failure(binding) : "create");
                if (pass == 0) { error += frows; rows += frows; }
                session_af6_destroy(binding);
                break;
            }
            for (size_t i = 0; i < count; ++i) {
                SceneActionInfo info;
                SceneActionHandlerResult out;
                Run run;
                int good = 1, completed = 0;
                if (scene_resource_action_at(scene, i, &info) != 0 || info.type != SESSION_AF6_TYPE) continue;
                if (pass == 0) ++rows;
                run.b = binding;
                run.info = &info;
                run.row = i;
                run.phase = 0u;
                good = visit(&run, &out, &completed) && run.phase == 1u;
                if (pass == 0) {
                    const F6Object *o = session_af6_object(binding);
                    const int cols = (int16_t)(info.typed_body[0x25] | (info.typed_body[0x26] << 8));
                    const int nrows = (int16_t)(info.typed_body[0x27] | (info.typed_body[0x28] << 8));
                    for (int v = 0; good && v < 200000 && run.phase == 1u; ++v) {
                        if (o->state == 4 && o->player == 1) {
                            const int c = human_click(&run, info.typed_body, cols, nrows);
                            if (c < 0) { good = 0; break; }
                            if (c == 0 && o->state == 4) {
                                good = 0; /* nothing answers while the human is to move */
                                break;
                            }
                        }
                        good = visit(&run, &out, &completed);
                    }
                    good = good && run.phase == 2u;
                    good = good && visit(&run, &out, &completed) && completed && out.phase == 0u && o->active == 0;
                    if (good) ++played;
                } else {
                    F6PointerResult pr;
                    uint32_t np = 1u;
                    const uint8_t *eb = info.typed_body + 0x1336;
                    const int16_t x = (int16_t)(rd32(eb, 0) + 1), y = (int16_t)(rd32(eb, 4) + 1);
                    good = good && session_af6_pointer_move(binding, x, y, &pr) == F6_OK;
                    if (good && (pr.candidate != F6_CANDIDATE_EXIT || pr.hit == 0u)) {
                        /* the exit is only active in state 4: run visits until the machine waits for the human */
                        const F6Object *o = session_af6_object(binding);
                        for (int v = 0; good && v < 200000 && !(o->state == 4 && o->player == 1) && run.phase == 1u; ++v)
                            good = visit(&run, &out, &completed);
                        good = good && session_af6_pointer_move(binding, x, y, &pr) == F6_OK;
                    }
                    good = good && pr.candidate == F6_CANDIDATE_EXIT &&
                           session_af6_click(binding, run.phase, pr.candidate, &np) == F6_OK && np == 2u;
                    run.phase = np;
                    good = good && visit(&run, &out, &completed) && completed && out.phase == 0u;
                    if (good) ++exited;
                }
                if (!good) {
                    ++error;
                    printf("ROW_FAIL %s %zu pass=%d %s\n", argv[a], i, pass, session_af6_failure(binding));
                }
            }
            session_af6_destroy(binding);
        }
        scene_resource_close(scene);
        free(bytes);
    }
    printf("SUMMARY scenes=%lu rows=%lu played=%lu exited=%lu error=%lu loads=%d releases=%d plays=%d captions=%d scene_changes=%d flag_stores=%d\n",
           scenes, rows, played, exited, error, ctx.loads, ctx.releases, ctx.plays, ctx.captions, ctx.scene_changes, ctx.flag_stores);
    return error == 0 ? 0 : 1;
}
