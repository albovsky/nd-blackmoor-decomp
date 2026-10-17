/* RT-39 executor-level check: the production scene executor (dependency gate mode 0, handler dispatch, generic completion by
 * subtype) runs the synthetic scene of tests/test_action_family_4b_runtime.py with the real binding: row 0 inline "Hi there"
 * (subtype 1), row 1 key KEYHIT behind event flag 3 == 1 (subtype 1), row 2 key NOSUCH (subtype 2: completes without keeping
 * the completion byte, so it writes every tick), row 3 inline empty (subtype 1), row 4 a 0x45 row (no handler: stops the
 * scene, so it is not part of this scene's tick; the scene file holds only rows 0..3 here). Prints "PASS"/"FAIL <reason>". */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_executor.h"
#include "session_bindings_a4b.h"

#define FLAGS 8u
#define EXPECT(cond)                                       \
    do {                                                   \
        if (!(cond)) {                                     \
            printf("FAIL line %d: %s\n", __LINE__, #cond); \
            return 1;                                      \
        }                                                  \
    } while (0)

typedef struct {
    unsigned writes;
    char log[8][80];
} Host;

static ActionFamily51LookupStatus lookup(void *context, const uint8_t *key, size_t key_length, const uint8_t **text, size_t *length)
{
    (void)context;
    if (key_length == 6u && memcmp(key, "KEYHIT", 6u) == 0) {
        *text = (const uint8_t *)"Found text";
        *length = 10u;
        return ACTION_FAMILY_51_LOOKUP_FOUND;
    }
    return ACTION_FAMILY_51_LOOKUP_NOT_FOUND;
}

static SessionA4bWriteStatus write_caption(void *context, const uint8_t *text, size_t length)
{
    Host *h = (Host *)context;
    if (h->writes < 8u) {
        snprintf(h->log[h->writes], sizeof h->log[0], "%.*s", (int)(length < 40u ? length : 40u), (const char *)text);
    }
    ++h->writes;
    return SESSION_A4B_WRITE_OK;
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
    Host host;
    SessionA4bHost hooks;
    SessionA4bBinding *binding;
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
    memset(&hooks, 0, sizeof hooks);
    hooks.context = &host;
    hooks.lookup = lookup;
    hooks.write_caption = write_caption;
    binding = session_a4b_create(&hooks);
    EXPECT(binding != NULL && session_a4b_begin_scene(binding, scene, NULL, NULL) == SESSION_A4B_OK);
    handler.type = SESSION_A4B_TYPE;
    handler.callback = session_a4b_handler;
    handler.context = binding;
    memset(&frame, 0, sizeof frame);
    EXPECT(scene_executor_create(scene, &world, 0u, &ex, &failed) == SCENE_EXECUTOR_OK);

    /* tick 1: rows 0, 2 and 3 write in row order; row 1 waits behind its gate */
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(host.writes == 3u && strcmp(host.log[0], "Hi there<e>") == 0 && strncmp(host.log[1], "Game Error (please contact", 26) == 0 &&
           strcmp(host.log[2], "<e>") == 0);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u);
    EXPECT(scene_executor_get_action_state(ex, 2u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 0u);
    EXPECT(scene_executor_get_action_state(ex, 3u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u);

    /* tick 2: the flag opens row 1; row 2 (subtype 2) writes again, rows 0 and 3 are not visited */
    flags[3] = 1;
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(host.writes == 5u && strcmp(host.log[3], "Found text<e>") == 0 && strncmp(host.log[4], "Game Error", 10) == 0);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);
    EXPECT(scene_executor_get_action_state(ex, 2u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u);
    EXPECT(session_a4b_writes(binding) == 5ul);

    scene_executor_destroy(ex);
    session_a4b_destroy(binding);
    scene_resource_close(scene);
    free(bytes);
    printf("PASS\n");
    return 0;
}
