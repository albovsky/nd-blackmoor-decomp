/* RT-33 executor-level check: the production scene executor (dependency gate, handler dispatch, DIRECT_COMPLETED
 * bookkeeping) runs a synthetic scene of raw 0x2e rows with the real 0x2e binding and the random-movie object active.
 * The scene file is written by tests/test_action_family_2e_runtime.py: row 0 (subtype 1) is mode 1 (event flag 5 := 9, no
 * scene change, start flag word 0) gated on event flag 3 == 1; row 1 (subtype 2) is mode 2 with no dependency.
 * Prints "PASS"/"FAIL <reason>"; the exit status is 0 on PASS. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_executor.h"
#include "session_bindings_a2e.h"

#define FLAGS 8u

static int32_t g_start = -1;
static unsigned g_starts;

static void set_start_flag(void *context, int32_t value)
{
    (void)context;
    g_start = value;
    ++g_starts;
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
    SceneActionExecutor *ex = NULL;
    size_t failed;
    SessionA2EHost host;
    SessionA2EBinding *binding;
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
    binding = session_a2e_create(&host, &world);
    EXPECT(binding != NULL);
    session_a2e_set_movie(binding, &movie);
    handler.type = SESSION_A2E_TYPE;
    handler.callback = session_a2e_handler;
    handler.context = binding;
    memset(&frame, 0, sizeof frame);
    EXPECT(scene_executor_create(scene, &world, 0u, &ex, &failed) == SCENE_EXECUTOR_OK);

    /* tick 1: the ungated mode-2 row (1) runs and completes; the gated mode-1 row (0) waits for flag 3 */
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.actions_applied == 1u);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st0) == SCENE_EXECUTOR_OK && st0.completed == 0u && st0.phase == 0u);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st1) == SCENE_EXECUTOR_OK && st1.completed == 1u && st1.phase == 0u);
    EXPECT(session_a2e_visits(binding) == 1ul && session_a2e_movie(binding)->row == 1 && session_a2e_movie(binding)->mode == 2);
    EXPECT(session_a2e_movie(binding)->state_1de == 0 && session_a2e_movie(binding)->flag_206 == 1);
    EXPECT(flags[5] == 0 && g_starts == 0u);

    /* tick 2 with the flag still 0: nothing visited again (the completed row is skipped) */
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.actions_applied == 0u && session_a2e_visits(binding) == 1ul);

    /* tick 3: the flag opens the gate; mode 1 stores flag 5 := 9, the start flag (word 0 != 1 gives 1) and state 1de := 2 */
    flags[3] = 1;
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.actions_applied == 1u && session_a2e_visits(binding) == 2ul);
    EXPECT(flags[5] == 9 && g_start == 1 && g_starts == 1u);
    EXPECT(session_a2e_movie(binding)->row == 0 && session_a2e_movie(binding)->mode == 1 && session_a2e_movie(binding)->state_1de == 2 &&
           session_a2e_movie(binding)->flag_206 == 0);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st0) == SCENE_EXECUTOR_OK && st0.completed == 1u && st0.phase == 0u);

    scene_executor_destroy(ex);
    session_a2e_destroy(binding);
    scene_resource_close(scene);
    free(bytes);
    printf("PASS\n");
    return 0;
}
