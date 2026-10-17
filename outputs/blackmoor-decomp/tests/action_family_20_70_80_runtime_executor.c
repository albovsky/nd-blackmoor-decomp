/* RT-48 executor-level check: the production scene executor (dependency gate mode 0, handler dispatch, direct completion)
 * drives the real bindings for raw 0x20, 0x70 and 0x80. Arguments: erase-scene, transition-scene, plain-0x70-scene (written by
 * tests/test_action_family_20_70_80_runtime.py). Prints "PASS"/"FAIL <reason>".
 *
 *  erase scene   row 0: 0x70 behind event flag 1, row 1: 0x80 behind flag 2, row 2: 0x20 behind flag 3, row 3: 0x70 (no gate).
 *                With flag 3 set the 0x20 row runs first among the open rows and erases (retires) every row, so the open 0x70
 *                row 3 is skipped in the same pass (the original erases the rows below the high-water count, then the loop
 *                reaches unloaded rows); opening flags 1 and 2 afterwards changes nothing.
 *  transition    row 0: 0x80 with the literal scene 6301 (the stored tuple supplies the other words); the step reports TRANSITION.
 *  plain 0x70    row 0: 0x70 completes directly with the phase it had; a second tick does not visit it again. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_executor.h"
#include "session_bindings_a20_a70_a80.h"

#define FLAGS 8u
#define EXPECT(cond)                                       \
    do {                                                   \
        if (!(cond)) {                                     \
            printf("FAIL line %d: %s\n", __LINE__, #cond); \
            return 1;                                      \
        }                                                  \
    } while (0)

typedef struct {
    SceneActionExecutor *ex;
    size_t rows;
    unsigned long unloads, erases;
} Ctx;

static int c_erase(void *c, uint32_t *n)
{
    Ctx *x = (Ctx *)c;
    size_t i;
    for (i = 0; i < x->rows; ++i) {
        if (scene_executor_retire_action(x->ex, i) != SCENE_EXECUTOR_OK) return 1;
    }
    *n = (uint32_t)x->rows;
    ++x->erases;
    return 0;
}

static int c_load20(void *c, Action20World *w)
{
    (void)c;
    memset(w, 0, sizeof *w);
    w->scene_5bb57f = 2877;
    return 0;
}

static int c_unload(void *c)
{
    ++((Ctx *)c)->unloads;
    return 0;
}

static int c_load_object(void *c, int uses, Action80Object *o)
{
    (void)c;
    (void)uses;
    memset(o, 0, sizeof *o);
    o->scene_6ba = 4321;
    o->word_6bc = 7;
    o->dword_6ca = 9;
    return 0;
}

static int c_transition(void *c, const SceneTransitionRequest *r)
{
    return scene_executor_request_transition(((Ctx *)c)->ex, r) == SCENE_EXECUTOR_OK ? 0 : 1;
}

static unsigned char *load(const char *path, long *n)
{
    FILE *f = fopen(path, "rb");
    unsigned char *bytes;
    if (f == NULL) return NULL;
    fseek(f, 0, SEEK_END);
    *n = ftell(f);
    fseek(f, 0, SEEK_SET);
    bytes = malloc((size_t)*n);
    if (bytes == NULL || fread(bytes, 1, (size_t)*n, f) != (size_t)*n) return NULL;
    fclose(f);
    return bytes;
}

typedef struct {
    int32_t flags[FLAGS];
    ActionCoreWorld world;
    SceneConditionState state;
    SceneResource *scene;
    unsigned char *bytes;
    Ctx ctx;
    SessionA20Binding *b20;
    SessionA70Binding *b70;
    SessionA80Binding *b80;
    SceneActionHandler handlers[3];
} Rig;

static int rig_open(Rig *r, const char *path)
{
    long n = 0;
    char err[128] = {0};
    size_t failed;
    SessionA20Host h20;
    SessionA70Host h70;
    SessionA80Host h80;

    memset(r, 0, sizeof *r);
    r->bytes = load(path, &n);
    if (r->bytes == NULL) return 1;
    r->scene = scene_resource_open_memory(r->bytes, (size_t)n, err, sizeof err);
    if (r->scene == NULL) return 1;
    memset(&r->world, 0, sizeof r->world);
    action_core_initialize_values(&r->world);
    r->world.event_flags = r->flags;
    r->world.event_flag_count = FLAGS;
    r->state.event_flags = r->flags;
    r->state.event_flag_count = FLAGS;
    if (scene_executor_create(r->scene, &r->world, 0u, &r->ctx.ex, &failed) != SCENE_EXECUTOR_OK) return 1;
    r->ctx.rows = scene_resource_action_count(r->scene);
    memset(&h20, 0, sizeof h20);
    memset(&h70, 0, sizeof h70);
    memset(&h80, 0, sizeof h80);
    h20.context = h70.context = h80.context = &r->ctx;
    h20.load_world = c_load20;
    h20.erase_rows = c_erase;
    h70.unload_scene_sound = c_unload;
    h80.load_object = c_load_object;
    h80.transition = c_transition;
    r->b20 = session_a20_create(&h20);
    r->b70 = session_a70_create(&h70);
    r->b80 = session_a80_create(&h80);
    if (r->b20 == NULL || r->b70 == NULL || r->b80 == NULL) return 1;
    r->handlers[0].type = SESSION_A20_TYPE;
    r->handlers[0].callback = session_a20_handler;
    r->handlers[0].context = r->b20;
    r->handlers[1].type = SESSION_A70_TYPE;
    r->handlers[1].callback = session_a70_handler;
    r->handlers[1].context = r->b70;
    r->handlers[2].type = SESSION_A80_TYPE;
    r->handlers[2].callback = session_a80_handler;
    r->handlers[2].context = r->b80;
    return 0;
}

static int rig_tick(Rig *r, SceneExecutorStepInfo *info)
{
    SceneExecutorFrameInput frame;
    memset(&frame, 0, sizeof frame);
    return scene_executor_step_frame(r->ctx.ex, &r->state, r->handlers, 3u, &frame, info);
}

int main(int argc, char **argv)
{
    Rig r;
    SceneExecutorStepInfo info;
    SceneActionRuntimeState st;
    size_t i;

    if (argc != 4) return 2;

    /* erase scene */
    EXPECT(rig_open(&r, argv[1]) == 0);
    EXPECT(rig_tick(&r, &info) == SCENE_EXECUTOR_OK);                       /* nothing is open: the 0x70 row 3 runs */
    EXPECT(session_a70_visits(r.b70) == 1ul && session_a20_visits(r.b20) == 0ul);
    EXPECT(scene_executor_get_action_state(r.ctx.ex, 3u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u);
    r.flags[3] = 1;
    EXPECT(rig_tick(&r, &info) == SCENE_EXECUTOR_OK);
    EXPECT(session_a20_visits(r.b20) == 1ul && r.ctx.erases == 1ul);
    for (i = 0; i < 4u; ++i) {
        EXPECT(scene_executor_get_action_state(r.ctx.ex, i, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);
    }
    r.flags[1] = 1;
    r.flags[2] = 1;
    EXPECT(rig_tick(&r, &info) == SCENE_EXECUTOR_OK);                       /* retired rows are never visited again */
    EXPECT(session_a70_visits(r.b70) == 1ul && session_a80_visits(r.b80) == 0ul && session_a20_visits(r.b20) == 1ul);
    scene_executor_destroy(r.ctx.ex);
    scene_resource_close(r.scene);
    free(r.bytes);

    /* erase scene again: the 0x20 row and the later open 0x70 row open in the same pass */
    EXPECT(rig_open(&r, argv[1]) == 0);
    r.flags[3] = 1;
    EXPECT(rig_tick(&r, &info) == SCENE_EXECUTOR_OK);
    EXPECT(session_a20_visits(r.b20) == 1ul);
    EXPECT(session_a70_visits(r.b70) == 0ul);                               /* row 3 was erased before its turn */
    scene_executor_destroy(r.ctx.ex);
    scene_resource_close(r.scene);
    free(r.bytes);

    /* transition scene */
    EXPECT(rig_open(&r, argv[2]) == 0);
    EXPECT(rig_tick(&r, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.kind == SCENE_EXECUTOR_STEP_TRANSITION);
    EXPECT(info.transition.target_scene == 6301 && info.transition.opaque_words[0] == 7 && info.transition.opaque_words[2] == 1);
    EXPECT(info.transition.opaque_dwords[2] == 9);
    EXPECT(scene_executor_get_action_state(r.ctx.ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u);
    scene_executor_destroy(r.ctx.ex);
    scene_resource_close(r.scene);
    free(r.bytes);

    /* plain 0x70 */
    EXPECT(rig_open(&r, argv[3]) == 0);
    EXPECT(rig_tick(&r, &info) == SCENE_EXECUTOR_OK);
    EXPECT(session_a70_visits(r.b70) == 1ul && r.ctx.unloads == 1ul);
    EXPECT(scene_executor_get_action_state(r.ctx.ex, 0u, &st) == SCENE_EXECUTOR_OK && st.completed == 1u && st.phase == 0u);
    EXPECT(rig_tick(&r, &info) == SCENE_EXECUTOR_OK);
    EXPECT(session_a70_visits(r.b70) == 1ul);
    scene_executor_destroy(r.ctx.ex);
    scene_resource_close(r.scene);
    free(r.bytes);
    printf("PASS\n");
    return 0;
}
