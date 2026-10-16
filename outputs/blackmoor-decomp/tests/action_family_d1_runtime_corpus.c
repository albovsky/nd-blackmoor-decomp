/* RT-35 corpus check: runs every raw 0xd1 row of the decoded scene resources given on the command line through the
 * production parser, the session binding and the kernel with a scripted host. Per row: phase 0, then the puzzle is
 * solved by clicking each wheel until its frame equals the target (running phase 1 visits with advancing ticks), the
 * finish runs (phase 2, generic completion) and a second pass takes the exit instead. Output is derived counts only:
 * one "ROW ..." line per row and a final "SUMMARY ..." line. Resource bytes stay in work/. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_ad1.h"

typedef struct { int loads, releases, plays, scene_changes, flag_stores; uint32_t now; } Ctx;

static int alloc_slot(void *c, int16_t *s) { (void)c; *s = 0x18; return 0; }
static int register_slot(void *c, int16_t s, const char *label)
{
    (void)c; (void)s;
    return strcmp(label, "TURNING PUZZLE OVERLAYS") != 0;
}
static int load_surface(void *c, const char *n, uint32_t *s) { ((Ctx *)c)->loads++; *s = n[0] != '\0' ? 5u : 0u; return 0; }
static int set_slot_surface(void *c, int16_t s, uint32_t surf) { (void)c; (void)s; (void)surf; return 0; }
static int release_surface(void *c, uint32_t s) { (void)s; ((Ctx *)c)->releases++; return 0; }
static int release_slot(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int mark_dirty(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int view_origin(void *c, int32_t *x, int32_t *y) { (void)c; *x = 0; *y = 0; return 0; }
static int clear_item(void *c) { (void)c; return 0; }
static int sound_prepare(void *c, int r, const uint8_t *b) { (void)c; (void)r; (void)b; return 0; }
static int sound_stop(void *c, int r, const uint8_t *b) { (void)c; (void)r; (void)b; return 0; }
static int sound_play(void *c, int16_t ch) { (void)ch; ((Ctx *)c)->plays++; return 0; }
static int sound_busy(void *c, int16_t ch, int32_t *r) { (void)c; (void)ch; *r = 0; return 0; }
static uint32_t tick(void *c) { Ctx *x = (Ctx *)c; x->now += 50u; return x->now; }
static int flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 4096; }
static int transition(void *c, const D1Transition *t) { (void)t; ((Ctx *)c)->scene_changes++; return 0; }
static int store_flag(void *c, int16_t i, uint32_t v) { (void)i; (void)v; ((Ctx *)c)->flag_stores++; return 0; }

typedef struct { SessionAd1Binding *b; const SceneActionInfo *info; size_t row; uint32_t phase; } Run;

static int visit(Run *r, SceneActionHandlerResult *out, int *completed)
{
    SceneActionRuntimeState st;
    memset(&st, 0, sizeof st);
    memset(out, 0, sizeof *out);
    st.phase = r->phase;
    if (session_ad1_handler(r->b, r->row, r->info, &st, out) != SCENE_ACTION_HANDLER_OK) return 0;
    r->phase = out->phase;
    *completed = out->disposition == SCENE_ACTION_HANDLER_COMPLETED;
    return 1;
}

/* Hit the centre of tile `tile` and click. */
static int click_tile(Run *r, const uint8_t *body, int tile)
{
    D1PointerResult pr;
    uint32_t np;
    const int32_t *hit = NULL;
    int32_t rect[4];
    for (int k = 0; k < 4; ++k) {
        const size_t o = 0x147u + (size_t)tile * 16u + (size_t)k * 4u;
        rect[k] = (int32_t)((uint32_t)body[o] | ((uint32_t)body[o + 1] << 8) | ((uint32_t)body[o + 2] << 16) | ((uint32_t)body[o + 3] << 24));
    }
    (void)hit;
    if (session_ad1_pointer_move(r->b, (int16_t)((rect[0] + rect[2]) / 2), (int16_t)((rect[1] + rect[3]) / 2), &pr) != D1_OK ||
        pr.candidate != D1_CANDIDATE_TILE)
        return 0;
    if (session_ad1_click(r->b, r->phase, pr.candidate, 1, &np) != D1_OK) return 0;
    r->phase = np;
    return 1;
}

int main(int argc, char **argv)
{
    static Ctx ctx;
    SessionAd1Host host;
    unsigned long rows = 0, solved = 0, exited = 0, error = 0, scenes = 0, tiles = 0;
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
    host.kernel.sound_play = sound_play;
    host.kernel.sound_busy = sound_busy;
    host.kernel.tick = tick;
    host.kernel.event_flag_invalid = flag_invalid;
    host.kernel.transition = transition;
    host.kernel.store_event_flag = store_flag;
    for (int a = 1; a < argc; ++a) {
        FILE *f = fopen(argv[a], "rb");
        long n;
        unsigned char *bytes;
        char err[128] = {0};
        SceneResource *scene;
        size_t count, d1rows = 0;
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
            if (scene_resource_action_at(scene, i, &info) == 0 && info.type == SESSION_AD1_TYPE) ++d1rows;
        }
        if (d1rows == 0) { scene_resource_close(scene); free(bytes); continue; }
        ++scenes;
        for (int pass = 0; pass < 2; ++pass) {
            SessionAd1Binding *binding = session_ad1_create(&host);
            if (binding == NULL || session_ad1_begin_scene(binding, scene) != D1_OK) {
                printf("SCENE_FAIL %s %s\n", argv[a], binding ? session_ad1_failure(binding) : "create");
                if (pass == 0) { error += d1rows; rows += d1rows; }
                session_ad1_destroy(binding);
                break;
            }
            for (size_t i = 0; i < count; ++i) {
                SceneActionInfo info;
                SceneActionHandlerResult out;
                Run run;
                int good = 1, completed = 0, guard = 0;
                if (scene_resource_action_at(scene, i, &info) != 0 || info.type != SESSION_AD1_TYPE) continue;
                if (pass == 0) ++rows;
                run.b = binding;
                run.info = &info;
                run.row = i;
                run.phase = 0u;
                good = visit(&run, &out, &completed) && run.phase == 1u;
                if (pass == 0) {
                    const int16_t nt = (int16_t)(info.typed_body[0x21] | (info.typed_body[0x22] << 8));
                    for (int t = 0; good && t < nt; ++t) {
                        const D1Object *o = session_ad1_object(binding);
                        const int16_t target = (int16_t)(info.typed_body[0x30a + 2 * t] | (info.typed_body[0x30b + 2 * t] << 8));
                        ++tiles;
                        while (good && o->frame[t] != target && guard++ < 400) {
                            good = click_tile(&run, info.typed_body, t);
                            for (int v = 0; good && v < 20 && !(o->state == D1_STATE_IDLE && o->moving[t] == 0); ++v)
                                good = visit(&run, &out, &completed);
                        }
                        good = good && o->frame[t] == target;
                    }
                    for (int v = 0; good && v < 400 && !completed; ++v) good = visit(&run, &out, &completed);
                    good = good && completed && out.phase == 0u && session_ad1_object(binding)->active == 0;
                    if (good) ++solved;
                } else {
                    D1PointerResult pr;
                    uint32_t np = 1u;
                    int32_t ex[2];
                    for (int k = 0; k < 2; ++k) {
                        const size_t o = 0x38fu + (size_t)k * 4u;
                        ex[k] = (int32_t)((uint32_t)info.typed_body[o] | ((uint32_t)info.typed_body[o + 1] << 8) | ((uint32_t)info.typed_body[o + 2] << 16) | ((uint32_t)info.typed_body[o + 3] << 24));
                    }
                    good = good && session_ad1_pointer_move(binding, (int16_t)(ex[0] + 1), (int16_t)(ex[1] + 1), &pr) == D1_OK &&
                           pr.candidate == D1_CANDIDATE_EXIT &&
                           session_ad1_click(binding, run.phase, pr.candidate, 1, &np) == D1_OK && np == 2u;
                    run.phase = np;
                    good = good && visit(&run, &out, &completed) && completed && out.phase == 0u;
                    if (good) ++exited;
                }
                if (!good) {
                    ++error;
                    printf("ROW_FAIL %s %zu pass=%d %s\n", argv[a], i, pass, session_ad1_failure(binding));
                }
            }
            session_ad1_destroy(binding);
        }
        scene_resource_close(scene);
        free(bytes);
    }
    printf("SUMMARY scenes=%lu rows=%lu solved=%lu exited=%lu error=%lu tiles=%lu loads=%d releases=%d scene_changes=%d flag_stores=%d\n",
           scenes, rows, solved, exited, error, tiles, ctx.loads, ctx.releases, ctx.scene_changes, ctx.flag_stores);
    return error == 0 ? 0 : 1;
}
