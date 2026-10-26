#include "scene_executor.h"

#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define CHECK(expr) do { if (!(expr)) { \
    fprintf(stderr, "CHECK line=%d expression=%s\n", __LINE__, #expr); \
    return 1; \
} } while (0)

typedef struct Fixture {
    SceneResource *source, *incoming, *single, *unsupported;
    SceneActionExecutor *executor;
    ActionCoreWorld world;
    SceneConditionState conditions;
    int32_t flags[4];
    size_t trace[32], calls;
    SceneActionHandler handler;
} Fixture;

/* Defensive only: no test raises a signal or deliberately creates a fault.
 * A native failure exits the child normally instead of involving Python's
 * address space or a macOS crash-report dialog. */
static void unexpected_signal(int signum)
{
    static const char message[] = "CHECK unexpected native signal\n";
    (void)signum;
    (void)write(STDERR_FILENO, message, sizeof(message) - 1u);
    _exit(1);
}

static SceneResource *open_scene(const char *path)
{
    FILE *file = fopen(path, "rb");
    uint8_t bytes[16384];
    size_t count;
    char error[160] = "";
    SceneResource *scene;
    if (file == NULL) return NULL;
    count = fread(bytes, 1u, sizeof(bytes), file);
    if (ferror(file) || !feof(file)) { (void)fclose(file); return NULL; }
    (void)fclose(file);
    scene = scene_resource_open_memory(bytes, count, error, sizeof(error));
    if (scene == NULL) fprintf(stderr, "CHECK fixture parser: %s\n", error);
    return scene;
}

static int pending(void *context, size_t row, const SceneActionInfo *action,
    const SceneActionRuntimeState *before, SceneActionHandlerResult *result)
{
    Fixture *f = context;
    if (action->type != 0x95 || f->calls >= sizeof(f->trace) / sizeof(f->trace[0]))
        return SCENE_ACTION_HANDLER_ERROR;
    f->trace[f->calls++] = row;
    result->disposition = SCENE_ACTION_HANDLER_PENDING;
    result->phase = before->phase + 1u;
    return SCENE_ACTION_HANDLER_OK;
}

static int step(Fixture *f)
{
    SceneExecutorStepInfo info;
    CHECK(scene_executor_step(f->executor, &f->conditions, &f->handler, 1u, &info) == SCENE_EXECUTOR_OK);
    CHECK(info.kind == SCENE_EXECUTOR_STEP_PROCESSED);
    return 0;
}

static int setup(Fixture *f, char **paths)
{
    size_t failed = SIZE_MAX;
    memset(f, 0, sizeof(*f));
    f->source = open_scene(paths[0]);
    f->incoming = open_scene(paths[1]);
    f->single = open_scene(paths[2]);
    f->unsupported = open_scene(paths[3]);
    CHECK(f->source != NULL && f->incoming != NULL && f->single != NULL && f->unsupported != NULL);
    f->flags[0] = 1; f->flags[2] = 1;
    f->world.event_flags = f->flags;
    f->world.event_flag_count = 4u;
    CHECK(action_core_initialize_values(&f->world) == ACTION_CORE_OK);
    f->conditions.event_flags = f->flags;
    f->conditions.event_flag_count = 4u;
    f->handler = (SceneActionHandler){ 0x95, pending, f };
    CHECK(scene_executor_create(f->source, &f->world, 240u, &f->executor, &failed) == SCENE_EXECUTOR_OK);
    CHECK(failed == SIZE_MAX && scene_executor_action_high_water(f->executor) == 4u);
    CHECK(step(f) == 0);
    CHECK(f->calls == 2u && f->trace[0] == 0u && f->trace[1] == 3u);
    CHECK(f->world.short_values[0] == 41);
    return 0;
}

static void cleanup(Fixture *f)
{
    /* Borrowed HIFF storage outlives all staged/live trees and ACT slots. */
    scene_executor_destroy(f->executor);
    scene_resource_close(f->source);
    scene_resource_close(f->incoming);
    scene_resource_close(f->single);
    scene_resource_close(f->unsupported);
}

static int make_plan(Fixture *f, size_t incoming, SceneActionSlotPlan *plan)
{
    uint8_t occupied[SCENE_ACTION_SLOT_LIMIT] = {0}, types[SCENE_ACTION_SLOT_LIMIT] = {0};
    size_t count = scene_executor_action_high_water(f->executor);
    for (size_t i = 0; i < count; ++i) {
        SceneExecutorSlotInfo slot;
        CHECK(scene_executor_get_slot(f->executor, i, &slot) == SCENE_EXECUTOR_OK);
        occupied[i] = slot.occupied;
        types[i] = slot.runtime_type;
    }
    CHECK(scene_action_slots_plan_no_art(count, occupied, types, 0, incoming, plan) == SCENE_ACTION_SLOTS_OK);
    return 0;
}

static int check_source(Fixture *f, uint32_t phase, int hole_is_source)
{
    SceneExecutorSlotInfo slot;
    SceneActionRuntimeState state;
    int32_t status;
    CHECK(scene_executor_get_slot(f->executor, 0u, &slot) == SCENE_EXECUTOR_OK);
    CHECK(slot.occupied && slot.source == f->source && slot.source_index == 0u && slot.runtime_type == 0x95);
    CHECK(scene_executor_get_action_state(f->executor, 0u, &state) == SCENE_EXECUTOR_OK);
    CHECK(state.completed == 0u && state.phase == phase);
    for (size_t node = 1u; node <= 3u; ++node) {
        CHECK(scene_executor_test_condition_node_status(f->executor, 0u, node, &status) == SCENE_EXECUTOR_OK);
        CHECK(status == 1);
    }
    CHECK(scene_executor_get_slot(f->executor, 2u, &slot) == SCENE_EXECUTOR_OK);
    CHECK(slot.occupied && slot.source == f->source && slot.source_index == 2u && slot.runtime_type == 0x4d);
    CHECK(scene_executor_get_action_state(f->executor, 2u, &state) == SCENE_EXECUTOR_OK);
    CHECK(state.completed == 1u && state.phase == 0u);
    if (hole_is_source) {
        CHECK(scene_executor_get_slot(f->executor, 1u, &slot) == SCENE_EXECUTOR_OK);
        CHECK(slot.occupied && slot.source == f->source && slot.runtime_type == 0x0a);
    }
    return 0;
}

static int retained_state_and_order(Fixture *f)
{
    SceneActionSlotPlan plan;
    SceneExecutorAppend *append = NULL;
    SceneExecutorSlotInfo before, after;
    SceneActionRuntimeState state;
    size_t failed = SIZE_MAX;
    int32_t status;
    CHECK(check_source(f, 1u, 1) == 0);
    CHECK(scene_executor_get_slot(f->executor, 0u, &before) == SCENE_EXECUTOR_OK);
    CHECK(make_plan(f, 2u, &plan) == 0);
    CHECK(plan.retired[1] && plan.assigned[0] == 1u && plan.assigned[1] == 4u);
    CHECK(scene_executor_prepare_append(f->executor, f->incoming, &plan, &append, &failed) == SCENE_EXECUTOR_OK);
    CHECK(append != NULL && failed == SIZE_MAX && check_source(f, 1u, 1) == 0);
    CHECK(f->calls == 2u && scene_executor_action_high_water(f->executor) == 4u && f->world.short_values[0] == 41);
    CHECK(scene_executor_commit_append(f->executor, append) == SCENE_EXECUTOR_OK);
    scene_executor_discard_append(append);
    CHECK(scene_executor_action_high_water(f->executor) == 5u && check_source(f, 1u, 0) == 0);
    CHECK(scene_executor_get_slot(f->executor, 0u, &after) == SCENE_EXECUTOR_OK);
    CHECK(after.action.raw_body == before.action.raw_body && after.action.dependency_records == before.action.dependency_records);
    CHECK(scene_executor_get_slot(f->executor, 1u, &after) == SCENE_EXECUTOR_OK);
    CHECK(after.source == f->incoming && after.source_index == 0u && after.occupied);
    CHECK(scene_executor_get_action_state(f->executor, 1u, &state) == SCENE_EXECUTOR_OK);
    CHECK(state.phase == 0u && state.completed == 0u);
    CHECK(scene_executor_test_condition_node_status(f->executor, 1u, 1u, &status) == SCENE_EXECUTOR_OK && status == 0);
    CHECK(scene_executor_get_slot(f->executor, 3u, &after) == SCENE_EXECUTOR_OK);
    CHECK(after.source == f->source && after.source_index == 3u && after.occupied);
    CHECK(scene_executor_get_action_state(f->executor, 3u, &state) == SCENE_EXECUTOR_OK && state.phase == 1u);
    CHECK(scene_executor_get_slot(f->executor, 4u, &after) == SCENE_EXECUTOR_OK);
    CHECK(after.source == f->incoming && after.source_index == 1u && after.occupied);
    /* A completed source 4d stays occupied and must not apply again. */
    f->world.short_values[0] = 99;
    f->calls = 0u;
    CHECK(step(f) == 0);
    CHECK(f->calls == 4u && f->trace[0] == 0u && f->trace[1] == 1u && f->trace[2] == 3u && f->trace[3] == 4u);
    CHECK(f->world.short_values[0] == 99 && check_source(f, 2u, 0) == 0);
    CHECK(scene_executor_get_action_state(f->executor, 3u, &state) == SCENE_EXECUTOR_OK && state.phase == 2u);
    return 0;
}

static int erase_trim_and_repeat(Fixture *f)
{
    SceneActionSlotPlan plan;
    SceneExecutorAppend *append = NULL;
    SceneExecutorSlotInfo slot;
    SceneActionRuntimeState state;
    size_t failed;
    CHECK(scene_executor_erase_action(f->executor, 3u, 1u) == SCENE_EXECUTOR_OK);
    CHECK(scene_executor_get_slot(f->executor, 3u, &slot) == SCENE_EXECUTOR_OK && !slot.occupied && slot.runtime_type == 0u);
    CHECK(scene_executor_get_action_state(f->executor, 3u, &state) == SCENE_EXECUTOR_OK && state.completed == 1u);
    CHECK(scene_executor_action_high_water(f->executor) == 4u);
    CHECK(make_plan(f, 1u, &plan) == 0);
    CHECK(plan.retained_high_water == 3u && plan.final_high_water == 3u && plan.assigned[0] == 1u);
    CHECK(scene_executor_prepare_append(f->executor, f->single, &plan, &append, &failed) == SCENE_EXECUTOR_OK);
    CHECK(scene_executor_commit_append(f->executor, append) == SCENE_EXECUTOR_OK);
    scene_executor_discard_append(append);
    CHECK(scene_executor_action_high_water(f->executor) == 3u);
    CHECK(scene_executor_erase_action(f->executor, 1u, 1u) == SCENE_EXECUTOR_OK);
    CHECK(make_plan(f, 2u, &plan) == 0 && plan.retained_high_water == 3u);
    CHECK(plan.assigned[0] == 1u && plan.assigned[1] == 3u && plan.final_high_water == 4u);
    CHECK(scene_executor_prepare_append(f->executor, f->incoming, &plan, &append, &failed) == SCENE_EXECUTOR_OK);
    CHECK(scene_executor_commit_append(f->executor, append) == SCENE_EXECUTOR_OK);
    scene_executor_discard_append(append);
    CHECK(check_source(f, 1u, 0) == 0);
    f->calls = 0u;
    CHECK(step(f) == 0 && f->calls == 3u);
    CHECK(f->trace[0] == 0u && f->trace[1] == 1u && f->trace[2] == 3u);
    return 0;
}

static int preparation_is_inert(Fixture *f)
{
    SceneActionSlotPlan plan, bad;
    SceneExecutorAppend *append = NULL;
    size_t failed = SIZE_MAX;
    CHECK(make_plan(f, 2u, &plan) == 0);
    bad = plan; bad.assigned[0] = 0u; /* An occupied survivor cannot be overwritten. */
    CHECK(scene_executor_prepare_append(f->executor, f->incoming, &bad, &append, &failed) == SCENE_EXECUTOR_ERR_ARGUMENT);
    CHECK(append == NULL && check_source(f, 1u, 1) == 0);
    CHECK(make_plan(f, 1u, &plan) == 0);
    CHECK(scene_executor_prepare_append(f->executor, f->unsupported, &plan, &append, &failed) == SCENE_EXECUTOR_ERR_UNSUPPORTED);
    CHECK(append == NULL && failed == 0u && check_source(f, 1u, 1) == 0);
    CHECK(make_plan(f, 2u, &plan) == 0);
    CHECK(scene_executor_prepare_append(f->executor, f->incoming, &plan, &append, &failed) == SCENE_EXECUTOR_OK);
    CHECK(check_source(f, 1u, 1) == 0 && f->calls == 2u && f->world.short_values[0] == 41);
    scene_executor_discard_append(append);
    CHECK(scene_executor_action_high_water(f->executor) == 4u && check_source(f, 1u, 1) == 0);
    return 0;
}

static int stale_preparation(Fixture *f)
{
    SceneActionSlotPlan plan;
    SceneExecutorAppend *append = NULL;
    size_t failed;
    CHECK(make_plan(f, 2u, &plan) == 0);
    CHECK(scene_executor_prepare_append(f->executor, f->incoming, &plan, &append, &failed) == SCENE_EXECUTOR_OK);
    CHECK(step(f) == 0 && check_source(f, 2u, 1) == 0);
    CHECK(scene_executor_commit_append(f->executor, append) == SCENE_EXECUTOR_ERR_ARGUMENT);
    CHECK(scene_executor_action_high_water(f->executor) == 4u && check_source(f, 2u, 1) == 0);
    scene_executor_discard_append(append);
    CHECK(make_plan(f, 2u, &plan) == 0);
    CHECK(scene_executor_prepare_append(f->executor, f->incoming, &plan, &append, &failed) == SCENE_EXECUTOR_OK);
    CHECK(scene_executor_commit_append(f->executor, append) == SCENE_EXECUTOR_OK);
    scene_executor_discard_append(append);
    CHECK(scene_executor_action_high_water(f->executor) == 5u && check_source(f, 2u, 0) == 0);
    return 0;
}

int main(int argc, char **argv)
{
    Fixture fixture;
    int status = 1;
    (void)signal(SIGABRT, unexpected_signal); (void)signal(SIGBUS, unexpected_signal);
    (void)signal(SIGFPE, unexpected_signal); (void)signal(SIGILL, unexpected_signal);
    (void)signal(SIGSEGV, unexpected_signal);
    if (argc != 6 || setup(&fixture, argv + 2) != 0) return 1;
    if (strcmp(argv[1], "retained") == 0) status = retained_state_and_order(&fixture);
    else if (strcmp(argv[1], "erase") == 0) status = erase_trim_and_repeat(&fixture);
    else if (strcmp(argv[1], "prepare") == 0) status = preparation_is_inert(&fixture);
    else if (strcmp(argv[1], "stale") == 0) status = stale_preparation(&fixture);
    cleanup(&fixture);
    if (status == 0) printf("PASS scene_no_art_executor %s\n", argv[1]);
    return status;
}
