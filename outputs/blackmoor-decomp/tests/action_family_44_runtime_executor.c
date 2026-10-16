/* RT-34 executor-level check: the production scene executor drives synthetic raw 0x44 rows through the real binding
 * (session_bindings_a44.c): first visit = 0x4121b8 (scripted text writer, generic completion, replacement by a 0xd8 record),
 * later visits = 0x48c1c0 on the record, a link click stores row phase 2, the finishing visit changes the scene.
 * The scene file is written by tests/test_action_family_44_runtime.py: row 0 (subtype 1) and row 1 (subtype 2, gated on
 * event flag 3 == 1) are inline-text rows with the same header. Prints "PASS"/"FAIL <reason>"; exit 0 on PASS. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "scene_executor.h"
#include "session_bindings_a44.h"

#define FLAGS 8u

typedef struct {
    unsigned texts;
    unsigned changes;
    SceneTransitionRequest request;
    int32_t start;
    int slots;
    uint32_t surfaces;
    unsigned released_surfaces;
    unsigned released_slots;
    uint32_t now;
} Rig;

#define EXPECT(cond)                                       \
    do {                                                   \
        if (!(cond)) {                                     \
            printf("FAIL line %d: %s\n", __LINE__, #cond); \
            return 1;                                      \
        }                                                  \
    } while (0)

static int write_text(void *c, const uint8_t *object, size_t bytes, A44TextResult *out)
{
    Rig *r = c;
    (void)object;
    (void)bytes;
    ++r->texts;
    out->has_links = 1u;
    out->link_count = 2;
    out->link_value[0] = 71;
    out->link_value[1] = 72;
    for (int i = 0; i < 2; ++i) {
        int32_t rect[4] = {10 + 100 * i, 10, 20 + 100 * i, 20};
        memcpy(out->link_rect[i], rect, 16u);
    }
    return 0;
}
static int transition(void *c, const SceneTransitionRequest *request)
{
    Rig *r = c;
    r->request = *request;
    ++r->changes;
    return 0;
}
static int set_start_flag(void *c, int32_t v) { ((Rig *)c)->start = v; return 0; }
static int alloc_slot(void *c, int16_t *s) { *s = (int16_t)((Rig *)c)->slots++; return 0; }
static int register_slot(void *c, int16_t s, uint32_t surf, const char *l) { (void)c; (void)s; (void)surf; (void)l; return 0; }
static int load_surface(void *c, const char *n, const char *l, uint32_t *s) { (void)n; (void)l; *s = ++((Rig *)c)->surfaces; return 0; }
static int set_slot_surface(void *c, int16_t s, uint32_t surf) { (void)c; (void)s; (void)surf; return 0; }
static int release_surface(void *c, uint32_t s) { (void)s; ++((Rig *)c)->released_surfaces; return 0; }
static int release_slot(void *c, int16_t s) { (void)s; ++((Rig *)c)->released_slots; return 0; }
static int mark_dirty(void *c, int16_t s) { (void)c; (void)s; return 0; }
static int text_surface(void *c, int i, uint32_t *s, int32_t *h) { (void)c; *s = 500u + (uint32_t)i; *h = 900; return 0; }
static uint32_t tick(void *c) { return ((Rig *)c)->now; }

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
    Rig rig;
    SessionA44Host host;
    SessionA44Binding *binding;
    SceneActionHandler handler;
    SceneExecutorStepInfo info;
    SceneExecutorFrameInput frame;
    SceneActionRuntimeState st0, st1;
    D8HitInput in = {-1, 0, 0, 0, 0};
    D8HitOutput hit;
    D8ClickOutput click;

    if (argc != 3 || (f = fopen(argv[1], "rb")) == NULL) return 2;
    fseek(f, 0, SEEK_END);
    n = ftell(f);
    fseek(f, 0, SEEK_SET);
    bytes = malloc((size_t)n);
    if (bytes == NULL || fread(bytes, 1, (size_t)n, f) != (size_t)n) return 2;
    fclose(f);
    scene = scene_resource_open_memory(bytes, (size_t)n, err, sizeof err);
    EXPECT(scene != NULL);
    memset(&rig, 0, sizeof rig);
    rig.start = -1;
    rig.slots = 0x18;
    memset(&world, 0, sizeof world);
    world.event_flags = flags;
    world.event_flag_count = FLAGS;
    memset(&state, 0, sizeof state);
    state.event_flags = flags;
    state.event_flag_count = FLAGS;
    memset(&host, 0, sizeof host);
    host.context = &rig;
    host.write_text = write_text;
    host.transition = transition;
    host.set_start_flag = set_start_flag;
    host.kernel.alloc_slot = alloc_slot;
    host.kernel.register_slot = register_slot;
    host.kernel.load_surface = load_surface;
    host.kernel.set_slot_surface = set_slot_surface;
    host.kernel.release_surface = release_surface;
    host.kernel.release_slot = release_slot;
    host.kernel.mark_dirty = mark_dirty;
    host.kernel.text_surface = text_surface;
    host.kernel.tick = tick;
    binding = session_a44_create(&host, &world);
    EXPECT(binding != NULL);
    EXPECT(session_a44_begin_scene(binding, scene) == D8_OK);
    handler.type = SESSION_A44_TYPE;
    handler.callback = session_a44_handler;
    handler.context = binding;
    memset(&frame, 0, sizeof frame);
    EXPECT(scene_executor_create(scene, &world, 0u, &ex, &failed) == SCENE_EXECUTOR_OK);

    /* tick 1: row 0 (ungated) runs 0x4121b8: text written once, the row is a pending 0xd8 record; row 1 waits for flag 3 */
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(info.actions_applied == 1u && rig.texts == 1u && session_a44_active_row(binding) == -1);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st0) == SCENE_EXECUTOR_OK && st0.completed == 0u && st0.phase == 0u);

    /* tick 2: the record's phase 0 initialises the singleton and the row moves to phase 1 */
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(session_a44_active_row(binding) == 0 && rig.start == 1 && rig.slots == 0x1a);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st0) == SCENE_EXECUTOR_OK && st0.completed == 0u && st0.phase == 1u);
    EXPECT(rig.texts == 1u);

    /* a click on link 0: the host stores row phase 2 (accepted candidate) and the next tick finishes with a scene change */
    EXPECT(session_a44_hit_test(binding, 20, 20, &in, &hit) == D8_OK && hit.hit == 1u && hit.candidate_5c39e5 == D8_CAND_LINK);
    EXPECT(session_a44_click(binding, hit.candidate_5c39e5, &click) == D8_OK && click.phase_written == 1u && click.phase == 2u);
    EXPECT(scene_executor_accept_action_candidate(ex, 0u) == SCENE_EXECUTOR_OK);
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(rig.changes == 1u && rig.request.target_scene == 71);
    EXPECT(session_a44_active_row(binding) == -1 && rig.released_slots == 2u);
    EXPECT(scene_executor_get_action_state(ex, 0u, &st0) == SCENE_EXECUTOR_OK && st0.completed == 1u && st0.phase == 0u);

    /* the gated subtype-2 row has not run */
    EXPECT(scene_executor_get_action_state(ex, 1u, &st1) == SCENE_EXECUTOR_OK && st1.completed == 0u && rig.texts == 1u);

    /* flag 3 opens the gate: the subtype-2 row walks the same path (first visit, init, click, finish) and completes with
     * phase 0; its dependency reset happens only on the first visit (the record stores subtype 1) */
    flags[3] = 1;
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK && rig.texts == 2u);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st1) == SCENE_EXECUTOR_OK && st1.completed == 0u && st1.phase == 0u);
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(session_a44_active_row(binding) == 1);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st1) == SCENE_EXECUTOR_OK && st1.completed == 0u && st1.phase == 1u);
    EXPECT(session_a44_hit_test(binding, 120, 20, &in, &hit) == D8_OK && hit.hit == 1u);
    EXPECT(session_a44_click(binding, hit.candidate_5c39e5, &click) == D8_OK);
    EXPECT(scene_executor_accept_action_candidate(ex, 1u) == SCENE_EXECUTOR_OK);
    EXPECT(scene_executor_step_frame(ex, &state, &handler, 1u, &frame, &info) == SCENE_EXECUTOR_OK);
    EXPECT(rig.changes == 2u && rig.request.target_scene == 72 && session_a44_active_row(binding) == -1);
    EXPECT(scene_executor_get_action_state(ex, 1u, &st1) == SCENE_EXECUTOR_OK && st1.completed == 1u && st1.phase == 0u);

    /* row 2 (subtype 2, gate never opens) is only visited directly: the first visit reports the dependency reset, phase 0 */
    {
        SceneActionInfo info3;
        SceneActionRuntimeState before3 = {0u, 0u};
        SceneActionHandlerResult out3 = {SCENE_ACTION_HANDLER_PENDING, 9u};
        EXPECT(scene_resource_action_at(scene, 2u, &info3) == SCENE_RESOURCE_OK);
        EXPECT(session_a44_handler(binding, 2u, &info3, &before3, &out3) == SCENE_ACTION_HANDLER_OK);
        EXPECT(out3.disposition == SCENE_ACTION_HANDLER_RESET_DEPENDENCIES && out3.phase == 0u && rig.texts == 3u);
    }

    /* a scene whose rows cannot be built (keyed row, no text resolver) leaves no row of the previous scene owned */
    {
        FILE *g = fopen(argv[2], "rb");
        unsigned char *bad;
        long bad_n;
        SceneResource *scene2;
        SceneActionInfo info2;
        SceneActionRuntimeState before = {0u, 0u};
        SceneActionHandlerResult out = {SCENE_ACTION_HANDLER_PENDING, 9u};
        EXPECT(g != NULL);
        fseek(g, 0, SEEK_END);
        bad_n = ftell(g);
        fseek(g, 0, SEEK_SET);
        bad = malloc((size_t)bad_n);
        EXPECT(bad != NULL && fread(bad, 1, (size_t)bad_n, g) == (size_t)bad_n);
        fclose(g);
        scene2 = scene_resource_open_memory(bad, (size_t)bad_n, err, sizeof err);
        EXPECT(scene2 != NULL);
        EXPECT(session_a44_begin_scene(binding, scene2) != D8_OK);
        EXPECT(scene_resource_action_at(scene2, 0u, &info2) == SCENE_RESOURCE_OK);
        EXPECT(session_a44_handler(binding, 0u, &info2, &before, &out) == SCENE_ACTION_HANDLER_UNSUPPORTED && rig.texts == 3u);
        scene_resource_close(scene2);
        free(bad);
    }

    scene_executor_destroy(ex);
    session_a44_destroy(binding);
    scene_resource_close(scene);
    free(bytes);
    printf("PASS\n");
    return 0;
}
