/* RT-25 corpus check (raw 0x3e cel-video rows; derived from the RT-23 driver): runs every raw 0x3e row of the decoded scene resources given on the
 * command line through the production parser, the session binding and the kernel with a
 * scripted host (all-zero event/presence state, a synthetic CIFTREE cel header with two layers, a
 * sound whose frame position advances one frame per visit and then stops, reader passes between
 * visits, the first listed response chosen). Output is
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
enum { MAX_FRAMES = 32768 };
static uint8_t g_block[0x2a + MAX_FRAMES * 0x8c];
static int g_sync_ticks, g_sync_stop;
static int cel_header(void *c, const uint8_t *n, const uint8_t **b, size_t *sz)
{
    int f;
    (void)c; (void)n;
    memset(g_block, 0, 0x2a);
    g_block[0x24] = 2; g_block[0x26] = 1;
    for (f = 0; f < MAX_FRAMES; ++f) {
        uint8_t *fr = g_block + 0x2a + (size_t)f * 0x8c;
        snprintf((char *)fr, 33, "a%d", f);
        snprintf((char *)fr + 0x21, 33, "b%d", f);
    }
    *b = g_block; *sz = sizeof g_block;
    return 0;
}
static int cel_index(void *c, const uint8_t *n, int16_t *i) { (void)c; *i = (int16_t)(n[0] == 0 ? 1 : 2); return 0; }
static int cel_info(void *c, int16_t i, uint8_t *k, uint8_t *t) { (void)c; (void)i; *k = 0; *t = 1; return 0; }
static int cel_layer(void *c, int16_t t, const uint8_t *n, Convo3fCelLayer *l)
{
    (void)c; (void)n;
    memset(l, 0, sizeof *l);
    l->loaded = 1u; l->surface = (uint32_t)t; l->src[2] = 63; l->src[3] = 47; l->dst[2] = 63; l->dst[3] = 47;
    return 0;
}
static int cel_free(void *c, int16_t s, int l, uint32_t sf) { (void)c; (void)s; (void)l; (void)sf; return 0; }
static int cel_nop(void *c) { (void)c; return 0; }
static int sync_init(void *c, uint16_t ch, uint16_t fr, uint32_t p) { (void)c; (void)ch; (void)fr; (void)p; g_sync_ticks = 0; return 0; }
static int sync_frame(void *c, uint16_t ch, int *playing, int32_t *raw)
{
    (void)c; (void)ch;
    *playing = g_sync_ticks < g_sync_stop;
    *raw = g_sync_ticks / 2;
    return 0;
}
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
    host.kernel.cel_load_header = cel_header; host.kernel.cel_tree_index = cel_index;
    host.kernel.cel_tree_info = cel_info; host.kernel.cel_load_layer = cel_layer;
    host.kernel.cel_free_layer = cel_free; host.kernel.cel_release_header = cel_nop;
    host.kernel.cel_reader_create = cel_nop; host.kernel.cel_reader_resume = cel_nop;
    host.kernel.cel_reader_destroy = cel_nop;
    host.kernel.sound_sync_init = sync_init; host.kernel.sound_sync_frame = sync_frame;
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
            int tier, status = 0, steps = 0, was_listed = 0;
            const char *outcome = "ok";
            if (scene_resource_action_at(scene, i, &info) != 0 || info.type != 0x3e) { continue; }
            img = session_a3f_image(b, i);
            if (img == NULL) { tier = 2; }
            else { tier = img[C3F_HOOK_A] != 0x14 || img[C3F_HOOK_B] != 0x14 ? 2 : ((img[C3F_PRIMARY_COUNT] | (img[C3F_PRIMARY_COUNT + 1] << 8)) != 0 ? 1 : 0); }
            memset(ctx.events, 0, sizeof ctx.events);
            ctx.transitions = ctx.pops = ctx.inv = ctx.layouts = 0;
            g_sync_stop = 5000;
            while (steps++ < 3000) {
                int pass, ran;
                for (pass = 0; pass < 4 && session_a3f_cel_active(b); ++pass) { (void)session_a3f_cel_reader_pass(b, &ran); }
                ++g_sync_ticks;
                memset(&out, 0, sizeof out);
                status = session_a3f_handler(b, i, &info, &st, &out);
                g_visits[tier]++;
                if (status != SCENE_ACTION_HANDLER_OK) { break; }
                if (out.disposition == SCENE_ACTION_HANDLER_DIRECT_COMPLETED) { break; }
                st.phase = out.phase;
                if (st.phase == 1u && session_a3f_response_count(b) > 0) {
                    if (!was_listed) { g_listed[tier]++; was_listed = 1; }
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
