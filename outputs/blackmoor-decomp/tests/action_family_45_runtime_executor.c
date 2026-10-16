/* RT-38 executor-level check: the production scene executor (dependency gate, handler dispatch, DIRECT_COMPLETED / PENDING
 * bookkeeping) runs a synthetic scene of three raw 0x45 rows with the real binding. The scene file is written by
 * tests/test_action_family_45_runtime.py: row 0 (mode 3, +5 seconds on timer 2) cannot apply while the timer is idle and stays
 * open, row 1 (mode 1) starts timer 2, row 2 (mode 0, timer 2) is gated on event flag 3 == 1. Prints "PASS"/"FAIL <reason>"; the
 * exit status is 0 on PASS. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_executor.h"
#include "session_bindings_a45.h"

#define FLAGS 8u

static uint8_t g_records[SESSION_TIMER_RECORD_COUNT][SESSION_TIMER_RECORD_BYTES];

static uint8_t *time_record(void *context, unsigned index)
{
    (void)context;
    return index < SESSION_TIMER_RECORD_COUNT ? g_records[index] : NULL;
}

#define EXPECT(cond)                              \
    do {                                          \
        if (!(cond)) {                            \
            printf("FAIL line %d: %s\n", __LINE__, #cond); \
            return 1;                             \
        }                                         \
    } while (0)

static uint32_t get32(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}

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
    SessionA45Host host;
    SessionA45Binding *binding;
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
    world.event_flags = flags;
    world.event_flag_count = FLAGS;
    memset(&state, 0, sizeof state);
    state.event_flags = flags;
    state.event_flag_count = FLAGS;
    memset(&host, 0, sizeof host);
    host.time_record = time_record;
    binding = session_a45_create(&host);
    EXPECT(binding != NULL);
    handler.type = SESSION_A45_TYPE;
    handler.callback = session_a45_handler;
    handler.context = binding;
    memset(&frame, 0, sizeof frame);
    memset(g_records, 0, sizeof g_records);
    EXPECT(scene_executor_create(scene, &world, 0u, &ex, &failed) == SCENE_EXECUTOR_OK);

    /* tick 1: row 0 finds the timer idle and stays open, row 1 starts it, row 2 waits behind its gate */
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(get32(g_records[2]) == 1u && get32(g_records[2] + SESSION_TIMER_SECONDS) == 0u);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 0u);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);
    EXPECT(scene_executor_get_action_state(ex, 2u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u);
    EXPECT(session_a45_completed(binding) == 1ul && session_a45_pending(binding) == 1ul);

    /* tick 2: row 0 is visited again, the timer now runs and gains five seconds */
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(get32(g_records[2] + SESSION_TIMER_SECONDS) == 5u && get32(g_records[2] + SESSION_TIMER_ELAPSED_MS) == 5000u);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);
    EXPECT(session_a45_completed(binding) == 2ul && session_a45_pending(binding) == 1ul);

    /* tick 3: the flag opens the gate and the record is cleared */
    flags[3] = 1;
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(get32(g_records[2]) == 0u && get32(g_records[2] + SESSION_TIMER_SECONDS) == 0u && g_records[2][0x28] == 'N');
    EXPECT(scene_executor_get_action_state(ex, 2u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);
    EXPECT(session_a45_completed(binding) == 3ul && session_a45_pending(binding) == 1ul);

    scene_executor_destroy(ex);
    session_a45_destroy(binding);
    scene_resource_close(scene);
    free(bytes);
    printf("PASS\n");
    return 0;
}
