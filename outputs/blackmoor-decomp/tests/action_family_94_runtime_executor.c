/* RT-32 executor-level check: the production scene executor (dependency gate, handler dispatch, PENDING / COMPLETED
 * bookkeeping) runs a synthetic scene of raw 0x94 rows with the real 0x94 binding. The scene file is written by
 * tests/test_action_family_94_runtime.py: row 0 (subtype 1) is gated on event flag 3 == 1, row 1 (subtype 1) has no
 * dependency; both capture a 3 x 3 rectangle of an 8 x 6 stand-in display. Prints "PASS"/"FAIL <reason>"; the exit status
 * is 0 on PASS. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_executor.h"
#include "session_bindings_a94.h"

#define FLAGS 8u

static int32_t g_flag = -1;
static unsigned g_flag_calls, g_refresh_calls, g_files;

static void set_flag(void *c, int32_t v) { (void)c; g_flag = v; ++g_flag_calls; }
static void refresh(void *c) { (void)c; ++g_refresh_calls; }
static int display(void *c, SessionA94Display *d)
{
    (void)c;
    memset(d, 0, sizeof *d);
    d->screen.width = 8;
    d->screen.height = 6;
    d->screen.bytes_per_pixel = 2;
    d->screen.bits_per_pixel = 16;
    d->screen.shifts[1] = 5; d->screen.shifts[2] = 10;
    d->screen.masks[0] = d->screen.masks[1] = d->screen.masks[2] = 0x1f;
    d->screen.channel_bits[0] = d->screen.channel_bits[1] = d->screen.channel_bits[2] = 5;
    return 0;
}
static int capture(void *c, uint8_t *dst, size_t n) { (void)c; memset(dst, 0x5a, n); return 0; }
static int write_file(void *c, const char *path, const uint8_t *bytes, size_t n)
{
    (void)c; (void)path; (void)bytes; (void)n;
    ++g_files;
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
    SessionA94Host host;
    SessionA94Binding *binding;
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
    host.set_capture_flag = set_flag;
    host.request_refresh = refresh;
    host.display = display;
    host.capture = capture;
    host.write_file = write_file;
    binding = session_a94_create(&host);
    EXPECT(binding != NULL);
    handler.type = SESSION_A94_TYPE;
    handler.callback = session_a94_handler;
    handler.context = binding;
    memset(&frame, 0, sizeof frame);
    EXPECT(scene_executor_create(scene, &world, 0u, &ex, &failed) == SCENE_EXECUTOR_OK);

    /* tick 1: the ungated row (1) starts (phase 0 -> 2); the gated row (0) waits for flag 3 */
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.actions_applied == 1u && g_flag == 1 && g_flag_calls == 1u && g_refresh_calls == 1u && g_files == 0u);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st1) == SCENE_EXECUTOR_OK && st1.completed == 0u && st1.phase == 2u);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st0) == SCENE_EXECUTOR_OK && st0.completed == 0u && st0.phase == 0u);
    /* tick 2: row 1 captures and writes its file (phase 2 -> 3), the flag is cleared */
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.actions_applied == 1u && g_files == 1u && g_flag == 0 && g_flag_calls == 2u);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st1) == SCENE_EXECUTOR_OK && st1.completed == 0u && st1.phase == 3u);
    /* tick 3: phase 3 completes the row (generic completion, phase 0) */
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st1) == SCENE_EXECUTOR_OK && st1.completed == 1u && st1.phase == 0u);
    EXPECT(g_files == 1u && g_flag_calls == 2u);
    /* tick 4: nothing left to visit while the gate is shut */
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.actions_applied == 0u && g_files == 1u);
    /* the flag opens the gate: row 0 runs its three phases */
    flags[3] = 1;
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK && info.actions_applied == 1u);
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK && g_files == 2u);
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st0) == SCENE_EXECUTOR_OK && st0.completed == 1u && st0.phase == 0u);
    EXPECT(session_a94_files_written(binding) == 2ul && g_refresh_calls == 2u && g_flag_calls == 4u);

    scene_executor_destroy(ex);
    session_a94_destroy(binding);
    scene_resource_close(scene);
    free(bytes);
    printf("PASS\n");
    return 0;
}
