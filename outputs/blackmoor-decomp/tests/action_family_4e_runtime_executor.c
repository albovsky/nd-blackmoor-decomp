/* RT-44 executor-level check: the production scene executor (dependency gate mode 1, handler dispatch, generic completion by
 * subtype) runs the synthetic scene of tests/test_action_family_4e_runtime.py with the real binding: row 0 sets float slot 30
 * to 5 (subtype 1), row 1 sets slot 31 to 50% of slot 30 behind event flag 3 == 1 (subtype 1), row 2 sets slot 32 to 1 plus
 * 100% of itself (subtype 2: completes without keeping the completion byte, so it is recomputed from zero on every tick).
 * Prints "PASS"/"FAIL <reason>". */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_executor.h"
#include "session_bindings_a4e.h"

#define FLAGS 8u
#define EXPECT(cond)                                       \
    do {                                                   \
        if (!(cond)) {                                     \
            printf("FAIL line %d: %s\n", __LINE__, #cond); \
            return 1;                                      \
        }                                                  \
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
    SessionA4EBinding *binding;
    SceneActionHandler handler;
    SceneExecutorStepInfo info;
    SceneExecutorFrameInput frame;
    SceneActionRuntimeState st;

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
    action_core_initialize_values(&world);
    world.event_flags = flags;
    world.event_flag_count = FLAGS;
    memset(&state, 0, sizeof state);
    state.event_flags = flags;
    state.event_flag_count = FLAGS;
    binding = session_a4e_create(&world);
    EXPECT(binding != NULL);
    handler.type = SESSION_A4E_TYPE;
    handler.callback = session_a4e_handler;
    handler.context = binding;
    memset(&frame, 0, sizeof frame);
    EXPECT(scene_executor_create(scene, &world, 0u, &ex, &failed) == SCENE_EXECUTOR_OK);

    /* tick 1: rows 0 and 2 run; row 1 waits behind its gate */
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(world.float_values[0] == 5.0f && world.float_values[1] == 9999.0f && world.float_values[2] == 2.0f);
    EXPECT(session_a4e_visits(binding) == 2ul);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u);
    EXPECT(scene_executor_get_action_state(ex, 2u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 0u);

    /* tick 2: the flag opens row 1 (50% of the 5.0 row 0 left); row 2 is recomputed, not accumulated */
    flags[3] = 1;
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(world.float_values[0] == 5.0f && world.float_values[1] == 2.5f && world.float_values[2] == 2.0f);
    EXPECT(session_a4e_visits(binding) == 4ul);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);
    EXPECT(scene_executor_get_action_state(ex, 2u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u);

    scene_executor_destroy(ex);
    session_a4e_destroy(binding);
    scene_resource_close(scene);
    free(bytes);
    printf("PASS\n");
    return 0;
}
