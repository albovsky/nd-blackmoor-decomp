/* RT-42 executor-level check: the production scene executor (dependency gate mode 0, handler dispatch, generic completion by
 * subtype) runs the synthetic scene of tests/test_action_family_47_runtime.py with the real binding: row 0 adds CURJ00 to the
 * kind-4 table (subtype 1), row 1 adds CURJ01 to it behind event flag 3 == 1 (subtype 1), row 2 adds CURJ00 to the kind-3 table
 * with code 7 (subtype 2: completes without keeping the completion byte, so it is visited again and finds its own entry).
 * Prints "PASS"/"FAIL <reason>". */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_executor.h"
#include "session_bindings_a47.h"

#define FLAGS 8u
#define EXPECT(cond)                                       \
    do {                                                   \
        if (!(cond)) {                                     \
            printf("FAIL line %d: %s\n", __LINE__, #cond); \
            return 1;                                      \
        }                                                  \
    } while (0)

static unsigned lookups;

static ActionFamily51LookupStatus lookup(void *context, const uint8_t *key, size_t key_length, const uint8_t **text, size_t *length)
{
    (void)context;
    (void)key;
    (void)key_length;
    ++lookups;
    *text = (const uint8_t *)"";
    *length = 0u;
    return ACTION_FAMILY_51_LOOKUP_FOUND;
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
    SessionA47Host hooks;
    SessionA47Binding *binding;
    const A47Tables *tables;
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
    memset(&hooks, 0, sizeof hooks);
    hooks.lookup = lookup;
    binding = session_a47_create(&hooks);
    EXPECT(binding != NULL);
    tables = session_a47_tables(binding);
    handler.type = SESSION_A47_TYPE;
    handler.callback = session_a47_handler;
    handler.context = binding;
    memset(&frame, 0, sizeof frame);
    EXPECT(scene_executor_create(scene, &world, 0u, &ex, &failed) == SCENE_EXECUTOR_OK);

    /* tick 1: rows 0 and 2 add (the tables were empty: no lookup); row 1 waits behind its gate */
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(lookups == 0u && session_a47_adds(binding) == 2ul && tables->count[1] == 1 && tables->count[0] == 1);
    EXPECT(strcmp((const char *)tables->name[1][0], "CURJ00") == 0 && tables->link_value[0][0] == 5 && tables->link_value[1][0] == A47_NO_LINK);
    EXPECT(tables->page2_slot[0] == 1u && tables->page2_slot[1] == 1u);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u);
    EXPECT(scene_executor_get_action_state(ex, 2u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 0u);

    /* tick 2: the flag opens row 1 (one lookup against CURJ00, then the add); row 2 finds its own entry first (no lookup, no add) */
    flags[3] = 1;
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(lookups == 1u && session_a47_adds(binding) == 3ul && tables->count[1] == 2 && tables->count[0] == 1);
    EXPECT(strcmp((const char *)tables->name[1][1], "CURJ01") == 0);
    EXPECT(session_a47_visits(binding) == 4ul);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);
    EXPECT(scene_executor_get_action_state(ex, 2u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u);

    scene_executor_destroy(ex);
    session_a47_destroy(binding);
    scene_resource_close(scene);
    free(bytes);
    printf("PASS\n");
    return 0;
}
