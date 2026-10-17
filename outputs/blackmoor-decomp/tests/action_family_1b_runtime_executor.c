/* RT-40 executor-level check: the production scene executor (dependency gate mode 1, pre-gate request clear, handler dispatch,
 * the accepted-release candidate that stores phase 2) runs the synthetic scene of tests/test_action_family_1b_runtime.py with the
 * real binding: row 0 hotspot (selector 7 gives the rectangle 100,200,300,400; held item 5 goes to scene 4005, any other held
 * item to the fixed block, scene 1500), row 1 the same behind event flag 3 == 1. Prints "PASS"/"FAIL <reason>". */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_executor.h"
#include "session_bindings_a1b.h"

#define FLAGS 8u
#define EXPECT(cond)                                       \
    do {                                                   \
        if (!(cond)) {                                     \
            printf("FAIL line %d: %s\n", __LINE__, #cond); \
            return 1;                                      \
        }                                                  \
    } while (0)

typedef struct {
    SceneActionExecutor *executor;
    int16_t selector, held;
    int32_t start_flag;
} Host;

static int load_world(void *context, Action1bWorld *world)
{
    Host *h = (Host *)context;
    world->selector = h->selector;
    world->held_item = h->held;
    world->start_flag_5bb1ca = h->start_flag;
    return 0;
}

static void store_world(void *context, const Action1bWorld *world)
{
    ((Host *)context)->start_flag = world->start_flag_5bb1ca;
}

static int transition(void *context, const SceneTransitionRequest *request)
{
    return scene_executor_request_transition(((Host *)context)->executor, request) == SCENE_EXECUTOR_OK ? 0 : 1;
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
    SessionA1bHost hooks;
    SessionA1bBinding *binding;
    SceneActionHandler handler;
    SceneExecutorStepInfo info;
    SceneExecutorFrameInput frame;
    SceneActionRuntimeState st;
    SessionInputHotspot row;

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
    host.selector = 7;
    host.held = 5;
    memset(&hooks, 0, sizeof hooks);
    hooks.context = &host;
    hooks.load_world = load_world;
    hooks.store_world = store_world;
    hooks.transition = transition;
    binding = session_a1b_create(&hooks);
    EXPECT(binding != NULL && session_a1b_begin_scene(binding, scene) == ACTION17_OK);
    handler.type = SESSION_A1B_TYPE;
    handler.callback = session_a1b_handler;
    handler.context = binding;
    memset(&frame, 0, sizeof frame);
    EXPECT(scene_executor_create(scene, &world, 0u, &ex, &failed) == SCENE_EXECUTOR_OK);
    host.executor = ex;
    EXPECT(scene_executor_set_pre_gate(ex, SESSION_A1B_TYPE, session_a1b_pre_gate, binding) == SCENE_EXECUTOR_OK);

    /* tick 1: both rows register (start flag, phase 1) and offer their rectangle */
    flags[3] = 1;
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.kind == SCENE_EXECUTOR_STEP_PROCESSED && host.start_flag == 1);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 1u);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st) == SCENE_EXECUTOR_OK && st.completed == 0u && st.phase == 1u);
    EXPECT(session_a1b_pointer_row(binding, 0u, &row) == 1 && row.rectangle.left == 100 && row.rectangle.top == 200 &&
           row.rectangle.right == 300 && row.rectangle.bottom == 400);
    EXPECT(session_a1b_pointer_row(binding, 1u, &row) == 1);

    /* tick 2: the selector no longer matches (row 0 clears its request) and the flag closes row 1's gate: the pre-gate still
     * clears row 1's request although its handler is not called */
    host.selector = 8;
    flags[3] = 0;
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(session_a1b_pointer_row(binding, 0u, &row) == 0 && session_a1b_pointer_row(binding, 1u, &row) == 0);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st) == SCENE_EXECUTOR_OK && st.phase == 1u);

    /* tick 3: the accepted release names row 0: phase 2 runs in the same tick, the held item picks scene 4005 */
    host.selector = 7;
    frame.hotspot_activation_event = 1u;
    frame.activation_candidate_valid = 1u;
    frame.activation_candidate = 0;
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.kind == SCENE_EXECUTOR_STEP_TRANSITION && info.transition.target_scene == 4005 &&
           info.transition.opaque_dwords[0] == 50 && info.transition.opaque_words[0] == 1);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 2u);

    scene_executor_destroy(ex);
    session_a1b_destroy(binding);
    scene_resource_close(scene);
    free(bytes);
    printf("PASS\n");
    return 0;
}
