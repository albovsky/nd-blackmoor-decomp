/* RT-57 executor-level check: the production scene executor (dependency gate mode 0, handler dispatch, pending phase, direct
 * completion) drives the real bindings for raw 0x6d and 0x9a. Arguments: scene-with-transition, scene-with-plain-rows (written by
 * tests/test_action_family_6d_9a_runtime.py). Prints "PASS"/"FAIL <reason>".
 *
 *  scene 1   row 0: 0x9a (sound 3, scene 6301, event flag 2 := 9), row 1: 0x6d behind event flag 5.
 *            Tick 1 only advances the phase (0 -> 2, row pending, no effect); tick 2 stops the channel, stores the flag,
 *            reports the transition and completes the row with phase 2; the gated 0x6d row is never visited.
 *  scene 2   row 0: 0x6d behind event flag 1, row 1: 0x9a (stop channels 0..13, no scene, no flag).
 *            The 0x9a row needs two ticks; the 0x6d row runs once its flag is set, completes directly with phase 0. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_executor.h"
#include "session_bindings_a6d_a9a.h"

#define FLAGS 8u
#define EXPECT(cond)                                       \
    do {                                                   \
        if (!(cond)) {                                     \
            printf("FAIL line %d: %s\n", __LINE__, #cond); \
            return 1;                                      \
        }                                                  \
    } while (0)

typedef struct {
    SceneActionExecutor *ex;
    int32_t *flags;
    unsigned long unloads, stops, transitions, flag_stores;
} Ctx;

static int c_load6d(void *c, Action6DWorld *w)
{
    (void)c;
    memset(w, 0, sizeof *w);
    return 0;
}

static int c_unload(void *c)
{
    ++((Ctx *)c)->unloads;
    return 0;
}

static int c_stop(void *c, uint16_t channel)
{
    (void)channel;
    ++((Ctx *)c)->stops;
    return 0;
}

static int c_invalid(void *c, int16_t index)
{
    (void)c;
    return index < 0 || (unsigned)index >= FLAGS;
}

static int c_store_flag(void *c, int16_t index, uint32_t value)
{
    Ctx *x = (Ctx *)c;
    x->flags[index] = (int32_t)value;
    ++x->flag_stores;
    return 0;
}

static int c_transition(void *c, const SceneTransitionRequest *r)
{
    ++((Ctx *)c)->transitions;
    return scene_executor_request_transition(((Ctx *)c)->ex, r) == SCENE_EXECUTOR_OK ? 0 : 1;
}

static unsigned char *load(const char *path, long *n)
{
    FILE *f = fopen(path, "rb");
    unsigned char *bytes;
    if (f == NULL) return NULL;
    fseek(f, 0, SEEK_END);
    *n = ftell(f);
    fseek(f, 0, SEEK_SET);
    bytes = malloc((size_t)*n);
    if (bytes == NULL || fread(bytes, 1, (size_t)*n, f) != (size_t)*n) return NULL;
    fclose(f);
    return bytes;
}

typedef struct {
    int32_t flags[FLAGS];
    ActionCoreWorld world;
    SceneConditionState state;
    SceneResource *scene;
    unsigned char *bytes;
    Ctx ctx;
    SessionA6dBinding *b6d;
    SessionA9aBinding *b9a;
    SceneActionHandler handlers[2];
} Rig;

static int rig_open(Rig *r, const char *path)
{
    long n = 0;
    char err[128] = {0};
    size_t failed;
    SessionA6dHost h6d;
    SessionA9aHost h9a;

    memset(r, 0, sizeof *r);
    r->bytes = load(path, &n);
    if (r->bytes == NULL) return 1;
    r->scene = scene_resource_open_memory(r->bytes, (size_t)n, err, sizeof err);
    if (r->scene == NULL) return 1;
    memset(&r->world, 0, sizeof r->world);
    action_core_initialize_values(&r->world);
    r->world.event_flags = r->flags;
    r->world.event_flag_count = FLAGS;
    r->state.event_flags = r->flags;
    r->state.event_flag_count = FLAGS;
    r->ctx.flags = r->flags;
    if (scene_executor_create(r->scene, &r->world, 0u, &r->ctx.ex, &failed) != SCENE_EXECUTOR_OK) return 1;
    memset(&h6d, 0, sizeof h6d);
    memset(&h9a, 0, sizeof h9a);
    h6d.context = h9a.context = &r->ctx;
    h6d.load_world = c_load6d;
    h6d.unload_scene_sound = c_unload;
    h9a.stop_channel = c_stop;
    h9a.event_flag_invalid = c_invalid;
    h9a.store_event_flag = c_store_flag;
    h9a.transition = c_transition;
    r->b6d = session_a6d_create(&h6d);
    r->b9a = session_a9a_create(&h9a);
    if (r->b6d == NULL || r->b9a == NULL) return 1;
    r->handlers[0].type = SESSION_A6D_TYPE;
    r->handlers[0].callback = session_a6d_handler;
    r->handlers[0].context = r->b6d;
    r->handlers[1].type = SESSION_A9A_TYPE;
    r->handlers[1].callback = session_a9a_handler;
    r->handlers[1].context = r->b9a;
    return 0;
}

static void rig_close(Rig *r)
{
    scene_executor_destroy(r->ctx.ex);
    scene_resource_close(r->scene);
    session_a6d_destroy(r->b6d);
    session_a9a_destroy(r->b9a);
    free(r->bytes);
}

static int rig_tick(Rig *r, SceneExecutorStepInfo *info)
{
    SceneExecutorFrameInput frame;
    memset(&frame, 0, sizeof frame);
    return scene_executor_step_frame(r->ctx.ex, &r->state, r->handlers, 2u, &frame, info);
}

int main(int argc, char **argv)
{
    Rig r;
    SceneExecutorStepInfo info;
    SceneActionRuntimeState st;

    if (argc != 3) return 2;

    /* scene 1: 0x9a with a scene change */
    EXPECT(rig_open(&r, argv[1]) == 0);
    EXPECT(rig_tick(&r, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.kind != SCENE_EXECUTOR_STEP_TRANSITION);
    EXPECT(scene_executor_get_action_state(r.ctx.ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 2u);
    EXPECT(r.ctx.stops == 0ul && r.ctx.transitions == 0ul && r.ctx.flag_stores == 0ul);
    EXPECT(rig_tick(&r, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.kind == SCENE_EXECUTOR_STEP_TRANSITION);
    EXPECT(info.transition.target_scene == 6301 && info.transition.opaque_words[0] == 7);
    EXPECT(scene_executor_get_action_state(r.ctx.ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 2u);
    EXPECT(r.ctx.stops == 1ul && r.ctx.transitions == 1ul && r.flags[2] == 9);
    EXPECT(session_a6d_visits(r.b6d) == 0ul && session_a9a_visits(r.b9a) == 2ul);
    rig_close(&r);

    /* scene 2: plain rows */
    EXPECT(rig_open(&r, argv[2]) == 0);
    EXPECT(rig_tick(&r, &info) == SCENE_EXECUTOR_OK);
    EXPECT(scene_executor_get_action_state(r.ctx.ex, 1u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 2u);
    EXPECT(r.ctx.stops == 0ul && r.ctx.unloads == 0ul);
    EXPECT(rig_tick(&r, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.kind != SCENE_EXECUTOR_STEP_TRANSITION);
    EXPECT(scene_executor_get_action_state(r.ctx.ex, 1u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 2u);
    EXPECT(r.ctx.stops == 14ul && r.ctx.transitions == 0ul && r.ctx.flag_stores == 0ul);
    EXPECT(scene_executor_get_action_state(r.ctx.ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u);
    EXPECT(r.ctx.unloads == 0ul);                                           /* the 0x6d row is still gated */
    r.flags[1] = 1;
    EXPECT(rig_tick(&r, &info) == SCENE_EXECUTOR_OK);
    EXPECT(r.ctx.unloads == 1ul && session_a6d_visits(r.b6d) == 1ul);
    EXPECT(scene_executor_get_action_state(r.ctx.ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);
    EXPECT(rig_tick(&r, &info) == SCENE_EXECUTOR_OK);                       /* completed rows are not visited again */
    EXPECT(r.ctx.unloads == 1ul && r.ctx.stops == 14ul);
    rig_close(&r);
    printf("PASS\n");
    return 0;
}
