/* RT-28 executor-level check: the production scene executor (dependency gate, handler dispatch, DIRECT_COMPLETED
 * bookkeeping) runs a synthetic scene of raw 0x6e rows with the real 0x6e binding. The scene file is written by
 * tests/test_action_family_6e_runtime.py: row 0 (subtype 1) is gated on event flag 3 == 1, row 1 (subtype 2) has no
 * dependency. Prints "PASS"/"FAIL <reason>"; the exit status is 0 on PASS. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_executor.h"
#include "session_bindings_a6e.h"

#define FLAGS 8u

static int provide(void *context, SceneStackCurrent *c)
{
    (void)context;
    memset(c, 0, sizeof *c);
    c->scene_5bb57b = c->scene_5bb57f = 4700;
    c->word_5bb50b = 3;
    c->dword_5bb5af = 9;
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
    SceneActionExecutor *ex = NULL;
    size_t failed;
    SessionA6EHost host;
    SceneStackSlot slot;
    SessionA6EBinding *binding;
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
    host.load_current = provide;
    scene_stack_slot_clear(&slot);
    binding = session_a6e_create(&host, &slot);
    EXPECT(binding != NULL);
    handler.type = SESSION_A6E_TYPE;
    handler.callback = session_a6e_handler;
    handler.context = binding;
    memset(&frame, 0, sizeof frame);
    EXPECT(scene_executor_create(scene, &world, 0u, &ex, &failed) == SCENE_EXECUTOR_OK);

    /* tick 1: the ungated row (1) runs and completes, the gated row (0) waits for flag 3 */
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.actions_applied == 1u);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st0) == SCENE_EXECUTOR_OK && st0.completed == 0u && st0.phase == 0u);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st1) == SCENE_EXECUTOR_OK && st1.completed == 1u && st1.phase == 0u);
    EXPECT(session_a6e_pushes(binding) == 1ul);
    EXPECT(slot.scene_5c3a05 == 4700 && slot.word_5c3a09 == 3 && slot.word_5c3a0d == 2 && slot.dword_5c3a13 == 9);

    /* tick 2 with the flag still 0: nothing visited again (the completed row is skipped) */
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.actions_applied == 0u && session_a6e_pushes(binding) == 1ul);

    /* tick 3: the flag opens the gate */
    flags[3] = 1;
    scene_stack_slot_clear(&slot);
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.actions_applied == 1u && session_a6e_pushes(binding) == 2ul);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st0) == SCENE_EXECUTOR_OK && st0.completed == 1u && st0.phase == 0u);
    EXPECT(slot.scene_5c3a05 == 4700);

    scene_executor_destroy(ex);
    session_a6e_destroy(binding);
    scene_resource_close(scene);
    free(bytes);
    printf("PASS\n");
    return 0;
}
