/* RT-29 executor-level check: the production scene executor (dependency gate, handler dispatch, DIRECT_COMPLETED
 * bookkeeping, transition request) runs a synthetic scene with the real 0x6e and 0x6f bindings sharing one saved-scene
 * record. The scene file is written by tests/test_action_family_6f_runtime.py: row 0 (0x6e, subtype 1) has no dependency,
 * row 1 (0x6f, subtype 1) is gated on event flag 3 == 1, row 2 (0x6e, subtype 2) is gated on event flag 4 == 1.
 * Prints "PASS"/"FAIL <reason>"; the exit status is 0 on PASS. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_executor.h"
#include "session_bindings_a6e.h"
#include "session_bindings_a6f.h"

#define FLAGS 8u

static SceneActionExecutor *g_executor;
static int g_applies;

static int provide(void *context, SceneStackCurrent *c)
{
    (void)context;
    memset(c, 0, sizeof *c);
    c->scene_5bb57b = 4700;
    c->scene_5bb57f = 4701;
    c->word_5bb50b = 3;
    c->word_5bb593 = 4;
    c->dword_5bb5af = 9;
    return 0;
}

/* what the app does: hand the request to the session, which hands it to the executor */
static int apply(void *context, const SceneStackPop *pop, const SceneTransitionRequest *request)
{
    (void)context;
    (void)pop;
    ++g_applies;
    return scene_executor_request_transition(g_executor, request) == SCENE_EXECUTOR_OK ? 0 : 1;
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
    SessionA6EHost push_host;
    SessionA6FHost pop_host;
    SceneStackSlot slot;
    SessionA6EBinding *push;
    SessionA6FBinding *pop;
    SceneActionHandler handlers[2];
    SceneExecutorStepInfo info;
    SceneExecutorFrameInput frame;
    SceneActionRuntimeState st0, st1, st2;

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
    memset(&push_host, 0, sizeof push_host);
    push_host.load_current = provide;
    memset(&pop_host, 0, sizeof pop_host);
    pop_host.apply = apply;
    scene_stack_slot_clear(&slot);
    scene_stack_slot_init_words(&slot);
    push = session_a6e_create(&push_host, &slot);
    pop = session_a6f_create(&pop_host, &slot);
    EXPECT(push != NULL && pop != NULL);
    handlers[0].type = SESSION_A6E_TYPE;
    handlers[0].callback = session_a6e_handler;
    handlers[0].context = push;
    handlers[1].type = SESSION_A6F_TYPE;
    handlers[1].callback = session_a6f_handler;
    handlers[1].context = pop;
    memset(&frame, 0, sizeof frame);
    EXPECT(scene_executor_create(scene, &world, 0u, &g_executor, &failed) == SCENE_EXECUTOR_OK);

    /* tick 1: the ungated 0x6e row saves the scene, the two gated rows wait */
    EXPECT(scene_executor_step_frame(g_executor, &state, handlers, 2u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.actions_applied == 1u && info.kind != SCENE_EXECUTOR_STEP_TRANSITION);
    EXPECT(session_a6e_pushes(push) == 1ul && session_a6f_pops(pop) == 0ul && g_applies == 0);
    EXPECT(slot.scene_5c3a05 == 4700 && slot.scene_5c3a07 == 4701 && slot.word_5c3a0d == 2);
    EXPECT(scene_executor_get_action_state(g_executor, 0u, &st0) == SCENE_EXECUTOR_OK && st0.completed == 1u);

    /* tick 2: both gates open. The pop (row 1) completes, asks for the scene change and ends the pass: row 2 is not visited */
    flags[3] = 1;
    flags[4] = 1;
    EXPECT(scene_executor_step_frame(g_executor, &state, handlers, 2u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.kind == SCENE_EXECUTOR_STEP_TRANSITION && info.actions_applied == 1u);
    EXPECT(info.transition.target_scene == 4701);
    EXPECT(info.transition.opaque_words[0] == 3 && info.transition.opaque_words[1] == 4 && info.transition.opaque_words[2] == 1);
    EXPECT(info.transition.opaque_dwords[0] == 0 && info.transition.opaque_dwords[1] == 9 && info.transition.opaque_dwords[2] == 0);
    EXPECT(g_applies == 1 && session_a6f_pops(pop) == 1ul && session_a6e_pushes(push) == 1ul);
    EXPECT(scene_executor_get_action_state(g_executor, 1u, &st1) == SCENE_EXECUTOR_OK && st1.completed == 1u && st1.phase == 0u);
    EXPECT(scene_executor_get_action_state(g_executor, 2u, &st2) == SCENE_EXECUTOR_OK && st2.completed == 0u);
    EXPECT(slot.scene_5c3a05 == 0x270f && slot.scene_5c3a07 == 0x270f); /* the record is empty again */

    /* tick 3: the scene change is pending, the executor is stopped and visits nothing */
    EXPECT(scene_executor_step_frame(g_executor, &state, handlers, 2u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.kind == SCENE_EXECUTOR_STEP_STOPPED && info.actions_applied == 0u);
    EXPECT(session_a6e_pushes(push) == 1ul);

    scene_executor_destroy(g_executor);
    session_a6e_destroy(push);
    session_a6f_destroy(pop);
    scene_resource_close(scene);
    free(bytes);
    printf("PASS\n");
    return 0;
}
