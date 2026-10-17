/* RT-36 executor-level check: raw 0x2e mode 0 stops the random movie while the production scene executor runs the scene. The
 * stop erases and completes the raw 0x2d row (here row 1, a stand-in 0x2e row behind a closed dependency gate) through
 * scene_executor_retire_action, the 0x2e row itself stays pending (the original's completion store lands on row -1) and is
 * visited again with the object inactive. The scene file is written by tests/test_action_family_2d_runtime.py: row 0
 * (subtype 1) is mode 0 (scene 9999, no event flag, start flag word 0); row 1 (subtype 1) is mode 2 gated on event flag 3 == 1.
 * Prints "PASS"/"FAIL <reason>"; the exit status is 0 on PASS. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_executor.h"
#include "session_bindings_a2e.h"

#define FLAGS 8u

static SceneActionExecutor *g_ex;
static SessionA2EBinding *g_binding;
static unsigned g_stops;
static int32_t g_start = -1;

static void set_start_flag(void *context, int32_t value)
{
    (void)context;
    g_start = value;
}

static int stop_movie(void *context, int32_t *retire_row)
{
    SessionA2EMovie reset = {0, 2, -1, 0, 0, 0};
    (void)context;
    ++g_stops;
    *retire_row = 1; /* the raw 0x2d row */
    if (scene_executor_retire_action(g_ex, 1u) != SCENE_EXECUTOR_OK) return 1;
    session_a2e_set_movie(g_binding, &reset); /* what the kernel's reset leaves in the shared fields */
    return 0;
}

#define EXPECT(cond)                              \
    do {                                          \
        if (!(cond)) {                            \
            printf("FAIL line %d: %s\n", __LINE__, #cond); \
            return 1;                             \
        }                                         \
    } while (0)

int main(int argc, char **argv)
{
    int32_t flags[FLAGS] = {0};
    FILE *f;
    unsigned char *bytes;
    long n;
    char err[128] = {0};
    SceneResource *scene;
    ActionCoreWorld world;
    SceneConditionState state;
    size_t failed;
    SessionA2EHost host;
    SessionA2EMovie movie = {1, 0, 0, 7, 7, 0};
    SceneActionHandler handler;
    SceneExecutorStepInfo info;
    SceneExecutorFrameInput frame;
    SceneActionRuntimeState st0, st1;

    if (argc != 2 || (f = fopen(argv[1], "rb")) == NULL) return 2;
    fseek(f, 0, SEEK_END);
    n = ftell(f);
    fseek(f, 0, SEEK_SET);
    bytes = malloc((size_t)n);
    if (bytes == NULL || fread(bytes, 1, (size_t)n, f) != (size_t)n) return 2;
    fclose(f);
    scene = scene_resource_open_memory(bytes, (size_t)n, err, sizeof err);
    EXPECT(scene != NULL);
    memset(&world, 0, sizeof world);
    world.event_flags = flags;
    world.event_flag_count = FLAGS;
    memset(&state, 0, sizeof state);
    state.event_flags = flags;
    state.event_flag_count = FLAGS;
    memset(&host, 0, sizeof host);
    host.set_start_flag = set_start_flag;
    host.stop_movie = stop_movie;
    g_binding = session_a2e_create(&host, &world);
    EXPECT(g_binding != NULL);
    session_a2e_set_movie(g_binding, &movie);
    handler.type = SESSION_A2E_TYPE;
    handler.callback = session_a2e_handler;
    handler.context = g_binding;
    memset(&frame, 0, sizeof frame);
    EXPECT(scene_executor_create(scene, &world, 0u, &g_ex, &failed) == SCENE_EXECUTOR_OK);
    EXPECT(scene_executor_retire_action(g_ex, 99u) == SCENE_EXECUTOR_ERR_ARGUMENT);

    /* tick 1: mode 0 stops the movie, retires row 1, applies the start flag and stays pending */
    EXPECT(scene_executor_step_frame(g_ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(g_stops == 1u && g_start == 1);
    EXPECT(scene_executor_get_action_state(g_ex, 0u, &st0) == SCENE_EXECUTOR_OK && st0.completed == 0u && st0.phase == 0u);
    EXPECT(scene_executor_get_action_state(g_ex, 1u, &st1) == SCENE_EXECUTOR_OK && st1.completed == 1u && st1.phase == 0u);
    EXPECT(session_a2e_movie(g_binding)->active == 0 && session_a2e_movie(g_binding)->row == -1);

    /* tick 2: the gate of the retired row opens but the row is skipped; row 0 is visited again, the object is inactive, it completes */
    flags[3] = 1;
    EXPECT(scene_executor_step_frame(g_ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.actions_applied == 1u && g_stops == 1u);
    EXPECT(scene_executor_get_action_state(g_ex, 0u, &st0) == SCENE_EXECUTOR_OK && st0.completed == 1u);
    EXPECT(scene_executor_get_action_state(g_ex, 1u, &st1) == SCENE_EXECUTOR_OK && st1.completed == 1u && st1.phase == 0u);
    EXPECT(session_a2e_movie(g_binding)->mode == 0 && session_a2e_movie(g_binding)->row == 0);

    scene_executor_destroy(g_ex);
    session_a2e_destroy(g_binding);
    scene_resource_close(scene);
    free(bytes);
    printf("PASS\n");
    return 0;
}
