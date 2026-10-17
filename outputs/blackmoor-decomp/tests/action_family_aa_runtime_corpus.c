/* RT-52 corpus check: runs every raw 0xaa row of the decoded scene resources given on the command line (in the owned game
 * that is the one row 3 of resource 1535) through the production parser, the session binding and the kernel with a scripted
 * host. Pass 0: phase 0 (time mode), the alarm-mode button, the increase button (the proposed alarm hour moves one hour), the
 * set button, the wait for the final delay, the final sound and the finish (phase 2, generic completion, the alarm written into
 * the game clock). Pass 1: phase 0, the cancel button and the finish. Output is derived counts only: one "ROW_FAIL ..." line per
 * failing row and a final "SUMMARY ..." line. Resource bytes stay in work/. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_resource.h"
#include "session_bindings_aaa.h"

typedef struct {
    int loads, releases, plays, scene_changes, flag_stores;
    uint32_t now;
    AlcWorld world;      /* the process cells the host owns */
    int world_stores;
} Ctx;

static int alloc_slot(void *c, int16_t *s) { (void)c; *s = 0x18; return 0; }
static int register_slot(void *c, int16_t s, const char *label)
{
    (void)c; (void)s;
    return strcmp(label, "ALARM CLOCK OVERLAYS") != 0;
}
static int load_surface(void *c, const char *n, uint32_t *s) { ((Ctx *)c)->loads++; *s = n[0] != '\0' ? 5u : 0u; return 0; }
static int set_slot_surface(void *c, int16_t s, uint32_t surf) { (void)c; (void)s; (void)surf; return 0; }
static int release_surface(void *c, uint32_t s) { (void)s; ((Ctx *)c)->releases++; return 0; }
static int release_slot(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int mark_dirty(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int view_origin(void *c, int32_t *x, int32_t *y) { (void)c; *x = 0; *y = 0; return 0; }
static int sound_prepare(void *c, const uint8_t *r) { (void)c; (void)r; return 0; }
static int sound_stop(void *c, const uint8_t *r) { (void)c; (void)r; return 0; }
static int sound_play(void *c, int16_t ch) { (void)ch; ((Ctx *)c)->plays++; return 0; }
static int sound_busy(void *c, int16_t ch, int32_t *r) { (void)c; (void)ch; *r = 0; return 0; }
static uint32_t tick(void *c) { Ctx *x = (Ctx *)c; x->now += 700u; return x->now; }
static int touch_idle_timer(void *c) { (void)c; return 0; }
static int flag_invalid(void *c, int16_t i) { (void)c; return i < 0 || i >= 4096; }
static int transition(void *c, const AlcTransition *t) { (void)t; ((Ctx *)c)->scene_changes++; return 0; }
static int store_flag(void *c, int16_t i, uint32_t v) { (void)i; (void)v; ((Ctx *)c)->flag_stores++; return 0; }
static void load_world(void *c, AlcWorld *w) { *w = ((Ctx *)c)->world; }
static void store_world(void *c, const AlcWorld *w) { Ctx *x = (Ctx *)c; x->world = *w; ++x->world_stores; }

typedef struct { SessionAaaBinding *b; const SceneActionInfo *info; size_t row; uint32_t phase; } Run;

static int visit(Run *r, SceneActionHandlerResult *out, int *completed)
{
    SceneActionRuntimeState st;
    AlcRenderResult rr;
    memset(&st, 0, sizeof st);
    memset(out, 0, sizeof *out);
    st.phase = r->phase;
    if (session_aaa_handler(r->b, r->row, r->info, &st, out) != SCENE_ACTION_HANDLER_OK) return 0;
    r->phase = out->phase;
    *completed = out->disposition == SCENE_ACTION_HANDLER_COMPLETED;
    if (!*completed && session_aaa_render(r->b, &rr) != ALC_OK) return 0;
    return 1;
}

static int32_t rd32(const uint8_t *b, size_t o)
{
    return (int32_t)((uint32_t)b[o] | ((uint32_t)b[o + 1] << 8) | ((uint32_t)b[o + 2] << 16) | ((uint32_t)b[o + 3] << 24));
}

static int16_t rd16(const uint8_t *b, size_t o) { return (int16_t)(uint16_t)(b[o] | (b[o + 1] << 8)); }

/* A finish block asks for a scene change unless its scene word is 9999 and for an event flag store unless its flag word is -1. */
static int block_effects_ok(const Ctx *ctx, const uint8_t *body, size_t block, int scenes_before, int flags_before)
{
    return ctx->scene_changes - scenes_before == (rd16(body, block) != ALC_NO_SCENE ? 1 : 0) &&
           ctx->flag_stores - flags_before == (rd16(body, block + 22u) != ALC_NO_FLAG ? 1 : 0);
}

/* Visits phase 1 until the object reaches `state` (the press deadline passes on the scripted ticks). */
static int reach_state(Run *r, int state)
{
    SceneActionHandlerResult out;
    int completed = 0;
    for (int v = 0; v < 8 && session_aaa_object(r->b)->state != state; ++v)
        if (!visit(r, &out, &completed) || completed) return 0;
    return session_aaa_object(r->b)->state == state;
}

/* The pointer over the middle of the button rectangle at `off`, the accepted release, and the visits until the button's state. */
static int press(Run *r, const uint8_t *body, size_t off, int state)
{
    AlcPointerResult pr;
    AlcClickResult cr;
    const int32_t x = (rd32(body, off) + rd32(body, off + 8)) / 2, y = (rd32(body, off + 4) + rd32(body, off + 12)) / 2;
    if (session_aaa_pointer_move(r->b, x, y, &pr) != ALC_OK || pr.hit != 1u || pr.candidate != ALC_CANDIDATE_BUTTON) return 0;
    if (session_aaa_click(r->b, r->phase, &cr) != ALC_OK || cr.fired != 1u) return 0;
    return reach_state(r, state);
}

int main(int argc, char **argv)
{
    static Ctx ctx;
    SessionAaaHost host;
    unsigned long rows = 0, set = 0, canceled = 0, error = 0, scenes = 0, presses = 0;
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
    host.kernel.sound_prepare = sound_prepare;
    host.kernel.sound_stop = sound_stop;
    host.kernel.sound_play = sound_play;
    host.kernel.sound_busy = sound_busy;
    host.kernel.tick = tick;
    host.kernel.touch_idle_timer = touch_idle_timer;
    host.kernel.event_flag_invalid = flag_invalid;
    host.kernel.transition = transition;
    host.kernel.store_event_flag = store_flag;
    host.load_world = load_world;
    host.store_world = store_world;
    for (int a = 1; a < argc; ++a) {
        FILE *f = fopen(argv[a], "rb");
        long n;
        unsigned char *bytes;
        char err[128] = {0};
        SceneResource *scene;
        size_t count, aarows = 0;
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
            if (scene_resource_action_at(scene, i, &info) == 0 && info.type == SESSION_AAA_TYPE) ++aarows;
        }
        if (aarows == 0) { scene_resource_close(scene); free(bytes); continue; }
        ++scenes;
        for (int pass = 0; pass < 2; ++pass) {
            SessionAaaBinding *binding = session_aaa_create(&host);
            if (binding == NULL || session_aaa_begin_scene(binding, scene) != ALC_OK) {
                printf("SCENE_FAIL %s %s\n", argv[a], binding ? session_aaa_failure(binding) : "create");
                if (pass == 0) { error += aarows; rows += aarows; }
                session_aaa_destroy(binding);
                break;
            }
            for (size_t i = 0; i < count; ++i) {
                SceneActionInfo info;
                SceneActionHandlerResult out;
                Run run;
                const uint8_t *body;
                int good = 1, completed = 0;
                int scenes_before, flags_before;
                if (scene_resource_action_at(scene, i, &info) != 0 || info.type != SESSION_AAA_TYPE) continue;
                body = info.typed_body;
                if (pass == 0) ++rows;
                run.b = binding;
                run.info = &info;
                run.row = i;
                run.phase = 0u;
                memset(&ctx.world, 0, sizeof ctx.world);
                ctx.world.start_flag_5bb1ca = 1;
                ctx.world.hour_585d51 = 10;
                ctx.world.minute_585d4f = 20; /* 10:20 AM */
                ctx.now = 1000u;
                scenes_before = ctx.scene_changes;
                flags_before = ctx.flag_stores;
                good = visit(&run, &out, &completed) && run.phase == 1u && !completed;
                good = good && session_aaa_object(binding)->state == ALC_STATE_TIME &&
                       session_aaa_object(binding)->time_hour == 9 && session_aaa_object(binding)->time_quarter == 1 &&
                       session_aaa_object(binding)->alarm_hour == 10 && session_aaa_registered(binding) == 1u;
                if (pass == 0) {
                    const int hour_before = good ? session_aaa_object(binding)->alarm_hour : 0;
                    ++presses;
                    good = good && press(&run, body, 0x61u, ALC_STATE_ALARM);     /* alarm-mode button */
                    ++presses;
                    good = good && press(&run, body, 0x91u, ALC_STATE_INCREASE);  /* increase button */
                    good = good && reach_state(&run, ALC_STATE_ALARM);
                    good = good && session_aaa_object(binding)->alarm_hour == (hour_before + 1) % 12;
                    ++presses;
                    good = good && press(&run, body, 0x71u, ALC_STATE_SET);       /* set button */
                    for (int v = 0; good && v < 80 && !completed; ++v) good = visit(&run, &out, &completed);
                    good = good && completed && out.phase == 0u && session_aaa_object(binding)->active == 0 &&
                           ctx.world.minute_585d4f == 0 && ctx.world.hour_585d51 == 12; /* 12:00 PM */
                    good = good && block_effects_ok(&ctx, body, 0x296u, scenes_before, flags_before);
                    if (good) ++set;
                } else {
                    ++presses;
                    good = good && press(&run, body, 0x81u, ALC_STATE_CANCEL);    /* cancel button */
                    for (int v = 0; good && v < 40 && !completed; ++v) good = visit(&run, &out, &completed);
                    good = good && completed && out.phase == 0u && session_aaa_object(binding)->active == 0 &&
                           ctx.world.hour_585d51 == 10 && ctx.world.minute_585d4f == 20 &&
                           block_effects_ok(&ctx, body, 0x2e2u, scenes_before, flags_before);
                    if (good) ++canceled;
                }
                if (!good) {
                    ++error;
                    printf("ROW_FAIL %s %zu pass=%d %s\n", argv[a], i, pass, session_aaa_failure(binding));
                }
            }
            session_aaa_destroy(binding);
        }
        scene_resource_close(scene);
        free(bytes);
    }
    printf("SUMMARY scenes=%lu rows=%lu set=%lu canceled=%lu error=%lu presses=%lu loads=%d releases=%d plays=%d "
           "scene_changes=%d flag_stores=%d world_stores=%d\n",
           scenes, rows, set, canceled, error, presses, ctx.loads, ctx.releases, ctx.plays, ctx.scene_changes,
           ctx.flag_stores, ctx.world_stores);
    return error == 0 ? 0 : 1;
}
