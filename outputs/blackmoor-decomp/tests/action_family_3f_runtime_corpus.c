/* RT-23 corpus check: runs every raw 0x3f row of the decoded scene resources given on the
 * command line through the production parser, the session binding and the kernel with a
 * scripted host (all-zero event/presence state, sound backend that ends at once, a layout
 * stand-in that supplies no response sounds, the first listed response chosen). Output is
 * derived counts only: one "ROW <file> <row> <tier> <outcome>" line per row and a final
 * "SUMMARY ..." line. Resource bytes stay in work/. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_a3f.h"

typedef struct {
    int transitions, pops, inv, layouts;
    SceneTransitionRequest last;
    int32_t events[32768], presence[32768];
} Ctx;

static ActionSoundBackendStatus load(void *c, const ActionSoundAudioCommand *m) { (void)c; (void)m; return ACTION_SOUND_BACKEND_OK; }
static ActionSoundBackendStatus play(void *c, uint16_t ch) { (void)c; (void)ch; return ACTION_SOUND_BACKEND_OK; }
static ActionSoundBackendStatus playing(void *c, uint16_t ch, int *s) { (void)c; (void)ch; *s = 0; return ACTION_SOUND_BACKEND_OK; }
static ActionSoundBackendStatus unload(void *c, uint16_t ch) { (void)c; (void)ch; return ACTION_SOUND_BACKEND_OK; }
static int add(void *c, int16_t i, int f) { (void)i; (void)f; ((Ctx *)c)->inv++; return 0; }
static int rm(void *c, int16_t i) { (void)i; ((Ctx *)c)->inv++; return 0; }
static int acq(void *c, const char *n, int16_t a, int16_t b, int16_t *slot) { (void)c; (void)n; (void)a; (void)b; *slot = 7; return 0; }
static int rel(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int layout(void *c, const Convo3fLayoutRequest *q, Convo3fWorld *w) { (void)q; (void)w; ((Ctx *)c)->layouts++; return 0; }
static int pop(void *c, Convo3fWorld *w) { Ctx *x = c; x->pops++; w->xfer_5bb57b = 1; w->mode_583999 = 4; return 0; }
static int world(void *c, Convo3fWorld *w)
{
    Ctx *x = c; /* the binding owns the conversation state; the host fills what it owns */
    w->events = x->events; w->event_count = 32768u;
    w->presence = x->presence; w->presence_count = 32768u;
    w->held_item = -1; w->mode_583999 = 3;
    return 0;
}
static int transition(void *c, const SceneTransitionRequest *r) { Ctx *x = c; x->transitions++; x->last = *r; return 0; }

static unsigned long g_rows[3], g_ok[3], g_unsupported[3], g_error[3], g_trans[3], g_listed[3], g_visits[3];

int main(int argc, char **argv)
{
    static Ctx ctx;
    ActionSoundBackend snd = {&ctx, NULL, NULL, load, play, playing, unload};
    SessionA3fHost host;
    int a;
    memset(&host, 0, sizeof host);
    host.kernel.context = &ctx;
    host.kernel.sound = &snd;
    host.kernel.inventory_add = add; host.kernel.inventory_remove = rm;
    host.kernel.acquire_surface = acq; host.kernel.release_surface = rel;
    host.kernel.layout_text_box = layout; host.kernel.scene_stack_pop = pop;
    host.load_world = world; host.transition = transition;
    for (a = 1; a < argc; ++a) {
        FILE *fp = fopen(argv[a], "rb");
        unsigned char *bytes;
        long n;
        char err[128] = {0};
        SceneResource *scene;
        SessionA3fBinding *b;
        size_t rows, i;
        if (fp == NULL) { continue; }
        fseek(fp, 0, SEEK_END); n = ftell(fp); fseek(fp, 0, SEEK_SET);
        bytes = malloc((size_t)n);
        if (fread(bytes, 1, (size_t)n, fp) != (size_t)n) { fclose(fp); free(bytes); continue; }
        fclose(fp);
        scene = scene_resource_open_memory(bytes, (size_t)n, err, sizeof err);
        if (scene == NULL) { free(bytes); continue; }
        b = session_a3f_create(&host);
        if (b == NULL || session_a3f_begin_scene(b, scene) != 0) { printf("SCENE_FAIL %s\n", argv[a]); }
        rows = scene_resource_action_count(scene);
        for (i = 0; b != NULL && i < rows; ++i) {
            SceneActionInfo info;
            SceneActionRuntimeState st = {0, 0u};
            SceneActionHandlerResult out;
            const uint8_t *img;
            int tier, status = 0, steps = 0;
            const char *outcome = "ok";
            if (scene_resource_action_at(scene, i, &info) != 0 || info.type != 0x3f) { continue; }
            img = session_a3f_image(b, i);
            if (img == NULL) { tier = 2; }
            else { tier = img[C3F_HOOK_A] != 0x14 || img[C3F_HOOK_B] != 0x14 ? 2 : ((img[C3F_PRIMARY_COUNT] | (img[C3F_PRIMARY_COUNT + 1] << 8)) != 0 ? 1 : 0); }
            memset(ctx.events, 0, sizeof ctx.events);
            ctx.transitions = ctx.pops = ctx.inv = ctx.layouts = 0;
            while (steps++ < 16) {
                memset(&out, 0, sizeof out);
                status = session_a3f_handler(b, i, &info, &st, &out);
                g_visits[tier]++;
                if (status != SCENE_ACTION_HANDLER_OK) { break; }
                if (out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED) { break; }
                st.phase = out.phase;
                if (st.phase == 1u && session_a3f_response_count(b) > 0) {
                    if (steps == 1) { g_listed[tier]++; }
                    (void)session_a3f_choose_response(b, 0); /* the pointer path 0x4e78c2 */
                }
            }
            if (status == SCENE_ACTION_HANDLER_UNSUPPORTED) { outcome = "unsupported"; }
            else if (status != SCENE_ACTION_HANDLER_OK) { outcome = "error"; }
            else if (out.disposition != SCENE_ACTION_HANDLER_DIRECT_COMPLETED) { outcome = "stuck"; }
            g_rows[tier]++;
            if (strcmp(outcome, "ok") == 0) { g_ok[tier]++; g_trans[tier] += (unsigned long)(ctx.transitions != 0); }
            else if (strcmp(outcome, "unsupported") == 0) { g_unsupported[tier]++; }
            else { g_error[tier]++; }
            printf("ROW %s %zu %c %s %s\n", argv[a], i, "ABC"[tier], outcome,
                   status == 0 ? "-" : session_a3f_failure(b));
        }
        session_a3f_destroy(b);
        scene_resource_close(scene);
        free(bytes);
    }
    for (a = 0; a < 3; ++a) {
        printf("SUMMARY tier=%c rows=%lu ok=%lu unsupported=%lu error=%lu with_transition=%lu listed=%lu visits=%lu\n", "ABC"[a],
               g_rows[a], g_ok[a], g_unsupported[a], g_error[a], g_trans[a], g_listed[a], g_visits[a]);
    }
    return 0;
}
