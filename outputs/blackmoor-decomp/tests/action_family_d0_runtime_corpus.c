/* RT-50 corpus check: runs every raw 0xd0 row of the decoded scene resources given on the command line through the
 * production parser, the session binding and the kernel with a scripted host. Per row: begin_scene validates the body,
 * phase 0, then the solution keys are pressed in order (pointer at the centre of the hit rectangle, accepted-release click,
 * the render callback and the phase 1 visits with advancing ticks) until the solved check fires and the finish runs
 * (phase 2, generic completion); a second pass takes the exit instead. Output is derived counts only: one "ROW_FAIL ..."
 * line per failing row and a final "SUMMARY ..." line. Resource bytes stay in work/. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_ad0.h"

typedef struct { int loads, releases, plays, texts, scene_changes, flag_stores; uint32_t now; } Ctx;

static int alloc_slot(void *c, int16_t *s) { (void)c; *s = 0x18; return 0; }
static int register_slot(void *c, int16_t s, const char *label)
{
    (void)c; (void)s;
    return strcmp(label, "PIANO PUZZLE OVERLAYS") != 0;
}
static int load_surface(void *c, const char *n, uint32_t *s) { ((Ctx *)c)->loads++; *s = n[0] != '\0' ? 5u : 0u; return 0; }
static int set_slot_surface(void *c, int16_t s, uint32_t surf) { (void)c; (void)s; (void)surf; return 0; }
static int release_surface(void *c, uint32_t s) { (void)s; ((Ctx *)c)->releases++; return 0; }
static int release_slot(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int mark_dirty(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int view_origin(void *c, int32_t *x, int32_t *y) { (void)c; *x = 0; *y = 0; return 0; }
static int clear_item(void *c) { (void)c; return 0; }
static int sound_prepare(void *c, const uint8_t *r) { (void)c; (void)r; return 0; }
static int sound_stop(void *c, const uint8_t *r) { (void)c; (void)r; return 0; }
static int sound_play(void *c, int16_t ch) { (void)ch; ((Ctx *)c)->plays++; return 0; }
static int sound_busy(void *c, int16_t ch, int32_t *r) { (void)c; (void)ch; *r = 0; return 0; }
static uint32_t tick(void *c) { Ctx *x = (Ctx *)c; x->now += 600u; return x->now; }
static int text_lookup(void *c, const char *key, const char **text)
{
    (void)c;
    *text = key[0] != '\0' ? "corpus text" : NULL;
    return 0;
}
static int text_show(void *c, const char *text) { (void)text; ((Ctx *)c)->texts++; return 0; }
static int flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 4096; }
static int transition(void *c, const D0Transition *t) { (void)t; ((Ctx *)c)->scene_changes++; return 0; }
static int store_flag(void *c, int16_t i, uint32_t v) { (void)i; (void)v; ((Ctx *)c)->flag_stores++; return 0; }

typedef struct { SessionAd0Binding *b; const SceneActionInfo *info; size_t row; uint32_t phase; } Run;

static int visit(Run *r, SceneActionHandlerResult *out, int *completed)
{
    SceneActionRuntimeState st;
    D0RenderResult rr;
    memset(&st, 0, sizeof st);
    memset(out, 0, sizeof *out);
    st.phase = r->phase;
    if (session_ad0_handler(r->b, r->row, r->info, &st, out) != SCENE_ACTION_HANDLER_OK) return 0;
    r->phase = out->phase;
    *completed = out->disposition == SCENE_ACTION_HANDLER_COMPLETED;
    if (!*completed && session_ad0_render(r->b, &rr) != D0_OK) return 0;
    return 1;
}

static int32_t rd32(const uint8_t *b, size_t o)
{
    return (int32_t)((uint32_t)b[o] | ((uint32_t)b[o + 1] << 8) | ((uint32_t)b[o + 2] << 16) | ((uint32_t)b[o + 3] << 24));
}

static int press_key(Run *r, const uint8_t *body, int key)
{
    D0PointerResult pr;
    D0ClickResult cr;
    const size_t o = 0x203u + (size_t)key * 16u;
    const int32_t x = (rd32(body, o) + rd32(body, o + 8)) / 2, y = (rd32(body, o + 4) + rd32(body, o + 12)) / 2;
    if (session_ad0_pointer_move(r->b, x, y, &pr) != D0_OK || pr.candidate != D0_CANDIDATE_KEY) return 0;
    if (session_ad0_click(r->b, r->phase, pr.candidate, 1, &cr) != D0_OK || !cr.key_pressed) return 0;
    r->phase = cr.new_phase;
    return 1;
}

int main(int argc, char **argv)
{
    static Ctx ctx;
    SessionAd0Host host;
    unsigned long rows = 0, solved = 0, exited = 0, error = 0, scenes = 0, keys = 0;
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
    host.kernel.text_lookup = text_lookup;
    host.kernel.text_show = text_show;
    host.kernel.event_flag_invalid = flag_invalid;
    host.kernel.transition = transition;
    host.kernel.store_event_flag = store_flag;
    for (int a = 1; a < argc; ++a) {
        FILE *f = fopen(argv[a], "rb");
        long n;
        unsigned char *bytes;
        char err[128] = {0};
        SceneResource *scene;
        size_t count, d0rows = 0;
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
            if (scene_resource_action_at(scene, i, &info) == 0 && info.type == SESSION_AD0_TYPE) ++d0rows;
        }
        if (d0rows == 0) { scene_resource_close(scene); free(bytes); continue; }
        ++scenes;
        for (int pass = 0; pass < 2; ++pass) {
            SessionAd0Binding *binding = session_ad0_create(&host);
            if (binding == NULL || session_ad0_begin_scene(binding, scene) != D0_OK) {
                printf("SCENE_FAIL %s %s\n", argv[a], binding ? session_ad0_failure(binding) : "create");
                if (pass == 0) { error += d0rows; rows += d0rows; }
                session_ad0_destroy(binding);
                break;
            }
            for (size_t i = 0; i < count; ++i) {
                SceneActionInfo info;
                SceneActionHandlerResult out;
                Run run;
                int good = 1, completed = 0, guard = 0;
                if (scene_resource_action_at(scene, i, &info) != 0 || info.type != SESSION_AD0_TYPE) continue;
                if (pass == 0) ++rows;
                run.b = binding;
                run.info = &info;
                run.row = i;
                run.phase = 0u;
                good = visit(&run, &out, &completed) && run.phase == 1u;
                if (pass == 0) {
                    const int16_t len = (int16_t)(info.typed_body[0x317] | (info.typed_body[0x318] << 8));
                    for (int k = 0; good && k < len; ++k) {
                        const int16_t key = (int16_t)(info.typed_body[0x319 + 2 * k] | (info.typed_body[0x31a + 2 * k] << 8));
                        ++keys;
                        good = press_key(&run, info.typed_body, key);
                        for (int v = 0; good && v < 4; ++v) good = visit(&run, &out, &completed);
                    }
                    for (int v = 0; good && v < 40 && !completed; ++v) good = visit(&run, &out, &completed);
                    good = good && completed && out.phase == 0u && session_ad0_object(binding)->active == 0 && guard == 0;
                    if (good) ++solved;
                } else {
                    D0PointerResult pr;
                    D0ClickResult cr;
                    const int32_t ex = rd32(info.typed_body, 0x7abu) + 1, ey = rd32(info.typed_body, 0x7afu) + 1;
                    good = good && session_ad0_pointer_move(binding, ex, ey, &pr) == D0_OK && pr.candidate == D0_CANDIDATE_EXIT &&
                           session_ad0_click(binding, run.phase, pr.candidate, 1, &cr) == D0_OK && cr.new_phase == 2u;
                    run.phase = cr.new_phase;
                    good = good && visit(&run, &out, &completed) && completed && out.phase == 0u;
                    if (good) ++exited;
                }
                if (!good) {
                    ++error;
                    printf("ROW_FAIL %s %zu pass=%d %s\n", argv[a], i, pass, session_ad0_failure(binding));
                }
            }
            session_ad0_destroy(binding);
        }
        scene_resource_close(scene);
        free(bytes);
    }
    printf("SUMMARY scenes=%lu rows=%lu solved=%lu exited=%lu error=%lu keys=%lu loads=%d releases=%d plays=%d texts=%d scene_changes=%d flag_stores=%d\n",
           scenes, rows, solved, exited, error, keys, ctx.loads, ctx.releases, ctx.plays, ctx.texts, ctx.scene_changes, ctx.flag_stores);
    return error == 0 ? 0 : 1;
}
