/* RT-37 executor-level check: the production scene executor (dependency gate, handler dispatch, DIRECT_COMPLETED
 * bookkeeping) runs a synthetic scene of raw 0x68, 0x69 and 0x65 rows with the real binding. The scene file is written by
 * tests/test_action_family_65_68_69_runtime.py: row 0 (raw 0x68, timer 3) is gated on event flag 3 == 1, row 1 (raw 0x69,
 * timer 3, subtype 2) and row 2 (raw 0x65) have no dependency. Prints "PASS"/"FAIL <reason>"; the exit status is 0 on PASS. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_executor.h"
#include "session_bindings_a65_a68_a69.h"

#define FLAGS 8u

static uint8_t g_records[SESSION_TIMER_RECORD_COUNT][SESSION_TIMER_RECORD_BYTES];
static unsigned g_saves;

static uint8_t *time_record(void *context, unsigned index)
{
    (void)context;
    return index < SESSION_TIMER_RECORD_COUNT ? g_records[index] : NULL;
}

static void save_game(void *context, const char *name, int report_failure)
{
    (void)context;
    (void)name;
    (void)report_failure;
    ++g_saves;
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
    SessionA65Host host;
    SessionA65Binding *binding;
    SceneActionHandler handlers[3];
    SceneExecutorStepInfo info;
    SceneExecutorFrameInput frame;
    SceneActionRuntimeState st;
    unsigned i;

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
    host.save_game = save_game;
    binding = session_a65_create(&host);
    EXPECT(binding != NULL);
    handlers[0].type = SESSION_A65_TYPE;
    handlers[0].callback = session_a65_handler;
    handlers[0].context = binding;
    handlers[1].type = SESSION_A68_TYPE;
    handlers[1].callback = session_a68_handler;
    handlers[1].context = binding;
    handlers[2].type = SESSION_A69_TYPE;
    handlers[2].callback = session_a69_handler;
    handlers[2].context = binding;
    memset(&frame, 0, sizeof frame);
    memset(g_records, 0x77, sizeof g_records);
    EXPECT(scene_executor_create(scene, &world, 0u, &ex, &failed) == SCENE_EXECUTOR_OK);

    /* tick 1: the two ungated rows run (the timer is cleared, the game is saved), the gated start waits for flag 3 */
    EXPECT(scene_executor_step_frame(ex, &state, handlers, 3u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.actions_applied == 2u && g_saves == 1u);
    EXPECT(g_records[3][0] == 0 && g_records[3][0x28] == 'N' && g_records[3][0xde] == 0xff && g_records[3][0x10] == 0);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 0u);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);
    EXPECT(scene_executor_get_action_state(ex, 2u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);
    for (i = 0; i < SESSION_TIMER_RECORD_COUNT; ++i) {
        if (i != 3u) EXPECT(g_records[i][0] == 0x77 && g_records[i][0x105] == 0x77);
    }

    /* tick 2 with the flag still 0: nothing runs again (completed rows are skipped, the gate is closed) */
    EXPECT(scene_executor_step_frame(ex, &state, handlers, 3u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.actions_applied == 0u && g_saves == 1u && g_records[3][0] == 0);

    /* tick 3: the flag opens the gate and the timer starts */
    flags[3] = 1;
    EXPECT(scene_executor_step_frame(ex, &state, handlers, 3u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.actions_applied == 1u && g_records[3][0] == 1 && g_records[3][1] == 0 && g_records[3][0x28] == 'N');
    EXPECT(session_a68_visits(binding) == 1ul && session_a69_visits(binding) == 1ul && session_a65_visits(binding) == 1ul);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);

    scene_executor_destroy(ex);
    session_a65_destroy(binding);
    scene_resource_close(scene);
    free(bytes);
    printf("PASS\n");
    return 0;
}
