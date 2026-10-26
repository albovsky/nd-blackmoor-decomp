#include "scene_executor.h"

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define CHECK(expr) do { if (!(expr)) { \
    fprintf(stderr, "CHECK line=%d expression=%s\n", __LINE__, #expr); return 1; \
} } while (0)

static void unexpected_signal(int signum)
{
    static const char message[] = "CHECK unexpected native signal\n";
    (void)signum; (void)write(STDERR_FILENO, message, sizeof(message) - 1u); _exit(1);
}
static SceneResource *open_scene(const char *path)
{
    uint8_t bytes[8192];
    char error[160];
    size_t count;
    FILE *file = fopen(path, "rb");
    SceneResource *scene;
    if (file == NULL) return NULL;
    count = fread(bytes, 1u, sizeof(bytes), file);
    if (ferror(file) || !feof(file)) { (void)fclose(file); return NULL; }
    (void)fclose(file);
    scene = scene_resource_open_memory(bytes, count, error, sizeof(error));
    if (scene == NULL) fprintf(stderr, "CHECK fixture parser: %s\n", error);
    return scene;
}

static int same_metadata(const SceneActionInfo *a, const SceneActionInfo *b)
{
    CHECK(strcmp(a->description, b->description) == 0 && a->type == b->type && a->subtype == b->subtype);
    CHECK(a->payload_kind == b->payload_kind && a->raw_body == b->raw_body && a->raw_body_length == b->raw_body_length);
    CHECK(a->typed_body == b->typed_body && a->typed_body_length == b->typed_body_length);
    CHECK(a->dependency_records == b->dependency_records && a->dependency_count == b->dependency_count);
    return 0;
}
static int row_matches(const SceneResource *view, size_t row, const SceneResource *source, size_t local)
{
    SceneResourceActionRef origin;
    SceneActionInfo actual, expected;
    SceneDependencyInfo dependency, original;
    CHECK(scene_resource_action_origin(view, row, &origin) == SCENE_RESOURCE_OK);
    CHECK(origin.source == source && origin.index == local);
    CHECK(scene_resource_action_at(view, row, &actual) == SCENE_RESOURCE_OK);
    CHECK(scene_resource_action_at(source, local, &expected) == SCENE_RESOURCE_OK);
    CHECK(same_metadata(&actual, &expected) == 0 && actual.dependency_count == 1u);
    CHECK(scene_resource_dependency_at(view, row, 0u, &dependency) == SCENE_RESOURCE_OK);
    CHECK(scene_resource_dependency_at(source, local, 0u, &original) == SCENE_RESOURCE_OK);
    CHECK(dependency.raw_bytes == original.raw_bytes && dependency.opcode == 2u && dependency.or_after == original.or_after);
    CHECK(memcmp(dependency.fields, original.fields, sizeof(dependency.fields)) == 0);
    return 0;
}

static int reordered_and_nested(SceneResource *a, SceneResource *b)
{
    const SceneResourceActionRef refs[] = {{a, 2u}, {b, 0u}, {a, 0u}};
    char error[160];
    SceneResource *middle = scene_resource_open_action_view(b, refs, 3u, error, sizeof(error));
    SceneResource *final;
    SceneResourceSummary descriptor, summary;
    CHECK(middle != NULL && scene_resource_action_count(middle) == 3u);
    CHECK(row_matches(middle, 0u, a, 2u) == 0 && row_matches(middle, 1u, b, 0u) == 0 && row_matches(middle, 2u, a, 0u) == 0);
    CHECK(scene_resource_get_summary(b, &descriptor) == SCENE_RESOURCE_OK);
    CHECK(scene_resource_get_summary(middle, &summary) == SCENE_RESOURCE_OK);
    CHECK(summary.action_count == 3u && strcmp(summary.title, descriptor.title) == 0);
    {
        const SceneResourceActionRef nested[] = {{middle, 1u}, {middle, 0u}};
        final = scene_resource_open_action_view(middle, nested, 2u, error, sizeof(error));
    }
    CHECK(final != NULL);
    scene_resource_close(middle);
    /* Only flattened original sources/bytes are borrowed. No metadata or
     * summary in the final view depends on the closed intermediate owner. */
    CHECK(row_matches(final, 0u, b, 0u) == 0 && row_matches(final, 1u, a, 2u) == 0);
    CHECK(scene_resource_get_summary(final, &summary) == SCENE_RESOURCE_OK && summary.action_count == 2u);
    CHECK(strcmp(summary.title, descriptor.title) == 0 && strcmp(summary.background, descriptor.background) == 0);
    CHECK(strcmp(summary.audio, descriptor.audio) == 0 && memcmp(summary.raw_tail, descriptor.raw_tail, sizeof(summary.raw_tail)) == 0);
    scene_resource_close(final);
    CHECK(scene_resource_action_count(a) == 3u && scene_resource_action_count(b) == 2u);
    CHECK(row_matches(a, 2u, a, 2u) == 0 && row_matches(b, 0u, b, 0u) == 0);
    return 0;
}

static int holes_and_refusals(SceneResource *a, SceneResource *b)
{
    const SceneResourceActionRef refs[] = {{NULL, 0u}, {a, 1u}, {NULL, 0u}};
    const SceneResourceActionRef invalid = {a, 3u};
    const SceneResourceActionRef valid = {a, 0u};
    char error[160] = "";
    SceneResource *view = scene_resource_open_action_view(b, refs, 3u, error, sizeof(error));
    SceneResource *empty;
    SceneActionInfo before, after, hole;
    SceneResourceActionRef origin;
    SceneDependencyInfo dependency;
    CHECK(view != NULL && scene_resource_action_at(a, 0u, &before) == SCENE_RESOURCE_OK);
    memset(&hole, 0x6d, sizeof(hole));
    CHECK(scene_resource_action_at(view, 0u, &hole) == SCENE_RESOURCE_OK);
    CHECK(hole.type == 0u && hole.subtype == 0u && hole.description[0] == '\0');
    CHECK(hole.raw_body == NULL && hole.raw_body_length == 0u && hole.typed_body == NULL && hole.typed_body_length == 0u);
    CHECK(hole.dependency_records == NULL && hole.dependency_count == 0u);
    CHECK(scene_resource_action_origin(view, 0u, &origin) == SCENE_RESOURCE_ERR_NOT_FOUND);
    CHECK(scene_resource_dependency_at(view, 0u, 0u, &dependency) == SCENE_RESOURCE_ERR_NOT_FOUND);
    CHECK(row_matches(view, 1u, a, 1u) == 0);
    CHECK(scene_resource_open_action_view(b, &invalid, 1u, error, sizeof(error)) == NULL && error[0] != '\0');
    CHECK(scene_resource_open_action_view(NULL, &valid, 1u, error, sizeof(error)) == NULL);
    CHECK(scene_resource_open_action_view(b, NULL, 1u, error, sizeof(error)) == NULL);
    CHECK(scene_resource_open_action_view(b, &valid, SCENE_RESOURCE_MAX_ACTIONS + 1u, error, sizeof(error)) == NULL);
    {
        const SceneResourceActionRef from_hole = {view, 0u};
        CHECK(scene_resource_open_action_view(b, &from_hole, 1u, error, sizeof(error)) == NULL);
    }
    empty = scene_resource_open_action_view(b, NULL, 0u, error, sizeof(error));
    CHECK(empty != NULL && scene_resource_action_count(empty) == 0u);
    scene_resource_close(empty); scene_resource_close(view);
    CHECK(scene_resource_action_at(a, 0u, &after) == SCENE_RESOURCE_OK && same_metadata(&before, &after) == 0);
    CHECK(row_matches(a, 0u, a, 0u) == 0 && scene_resource_action_count(a) == 3u && scene_resource_action_count(b) == 2u);
    return 0;
}

typedef struct Dispatch {
    ActionCoreWorld *world;
    const uint8_t *body;
    unsigned calls;
} Dispatch;
static int pending(void *context, size_t row, const SceneActionInfo *action,
    const SceneActionRuntimeState *before, SceneActionHandlerResult *result)
{
    Dispatch *d = context;
    if (row != 1u || action->type != 0x95 || strcmp(action->description, "b0") != 0 ||
        action->raw_body != d->body || before->phase != d->calls || d->world->short_values[1] != 22 ||
        d->world->short_values[0] != (d->calls == 0u ? 9999 : 11)) return SCENE_ACTION_HANDLER_ERROR;
    ++d->calls; result->disposition = SCENE_ACTION_HANDLER_PENDING; result->phase = before->phase + 1u;
    return SCENE_ACTION_HANDLER_OK;
}

static int executor_survives_compact_views(SceneResource *a, SceneResource *b)
{
    const SceneResourceActionRef refs[] = {{a, 2u}, {b, 0u}, {a, 0u}};
    const void *trees[3];
    char error[160];
    SceneResource *middle = scene_resource_open_action_view(b, refs, 3u, error, sizeof(error));
    SceneResource *compact;
    SceneActionExecutor *executor = NULL;
    SceneActionInfo b0;
    SceneExecutorSlotInfo slot;
    SceneExecutorStepInfo step;
    SceneActionRuntimeState state;
    ActionCoreWorld world = {0};
    SceneConditionState conditions = {0};
    int32_t flags[3] = {1, 1, 1}, cached;
    size_t failed = SIZE_MAX;
    Dispatch dispatch = {&world, NULL, 0};
    SceneActionHandler handler = {0x95, pending, &dispatch};
    CHECK(middle != NULL);
    {
        const SceneResourceActionRef nested[] = {{middle, 0u}, {middle, 1u}, {middle, 2u}};
        compact = scene_resource_open_action_view(middle, nested, 3u, error, sizeof(error));
    }
    CHECK(compact != NULL && scene_resource_action_at(b, 0u, &b0) == SCENE_RESOURCE_OK);
    dispatch.body = b0.raw_body;
    world.event_flags = flags; world.event_flag_count = 3u;
    conditions.event_flags = flags; conditions.event_flag_count = 3u;
    CHECK(action_core_initialize_values(&world) == ACTION_CORE_OK);
    /* Executor input is COMPACT. Sparse provider views expose holes, but a
     * hole has no original action origin and is not an executor input row. */
    CHECK(scene_executor_create(compact, &world, 240u, &executor, &failed) == SCENE_EXECUTOR_OK && failed == SIZE_MAX);
    for (size_t i = 0; i < 3u; ++i) {
        CHECK(scene_executor_get_slot(executor, i, &slot) == SCENE_EXECUTOR_OK);
        CHECK(slot.occupied && slot.source == refs[i].source && slot.source_index == refs[i].index && slot.condition_tree != NULL);
        trees[i] = slot.condition_tree;
    }
    CHECK(scene_executor_test_condition_node_status(executor, 1u, 1u, &cached) == SCENE_EXECUTOR_OK && cached == 0);
    scene_resource_close(compact); scene_resource_close(middle);
    for (size_t i = 0; i < 3u; ++i) {
        CHECK(scene_executor_get_slot(executor, i, &slot) == SCENE_EXECUTOR_OK);
        CHECK(slot.source == refs[i].source && slot.source_index == refs[i].index && slot.condition_tree == trees[i]);
    }
    CHECK(scene_executor_step(executor, &conditions, &handler, 1u, &step) == SCENE_EXECUTOR_OK);
    CHECK(step.kind == SCENE_EXECUTOR_STEP_PROCESSED && step.actions_applied == 3u && dispatch.calls == 1u);
    CHECK(world.short_values[0] == 11 && world.short_values[1] == 22);
    CHECK(scene_executor_test_condition_node_status(executor, 1u, 1u, &cached) == SCENE_EXECUTOR_OK && cached == 1);
    flags[0] = 0;
    CHECK(scene_executor_step(executor, &conditions, &handler, 1u, &step) == SCENE_EXECUTOR_OK);
    CHECK(step.actions_applied == 0u && dispatch.calls == 1u);
    CHECK(scene_executor_test_condition_node_status(executor, 1u, 1u, &cached) == SCENE_EXECUTOR_OK && cached == 0);
    flags[0] = 1;
    CHECK(scene_executor_step(executor, &conditions, &handler, 1u, &step) == SCENE_EXECUTOR_OK && dispatch.calls == 2u);
    CHECK(scene_executor_get_action_state(executor, 1u, &state) == SCENE_EXECUTOR_OK && state.phase == 2u && !state.completed);
    for (size_t i = 0; i < 3u; ++i) {
        CHECK(scene_executor_get_slot(executor, i, &slot) == SCENE_EXECUTOR_OK);
        CHECK(slot.condition_tree == trees[i] && slot.source == refs[i].source && slot.source_index == refs[i].index);
    }
    scene_executor_destroy(executor);
    return 0;
}

int main(int argc, char **argv)
{
    SceneResource *a, *b;
    int status = 1;
    (void)signal(SIGABRT, unexpected_signal); (void)signal(SIGBUS, unexpected_signal);
    (void)signal(SIGFPE, unexpected_signal); (void)signal(SIGILL, unexpected_signal); (void)signal(SIGSEGV, unexpected_signal);
    if (argc != 4) return 1;
    a = open_scene(argv[2]); b = open_scene(argv[3]);
    if (a == NULL || b == NULL) { scene_resource_close(a); scene_resource_close(b); return 1; }
    if (strcmp(argv[1], "nested") == 0) status = reordered_and_nested(a, b);
    else if (strcmp(argv[1], "holes") == 0) status = holes_and_refusals(a, b);
    else if (strcmp(argv[1], "executor") == 0) status = executor_survives_compact_views(a, b);
    /* Original source bytes outlive every view and executor borrow. */
    scene_resource_close(a); scene_resource_close(b);
    if (!status) printf("PASS scene_action_view %s\n", argv[1]);
    return status;
}
