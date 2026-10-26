#include "scene_action_slots.h"

#include <signal.h>
#include <stdio.h>
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
static int cleared(const SceneNormalActionSlotPlan *plan)
{
    const uint8_t *bytes = (const uint8_t *)plan;
    for (size_t i = 0; i < sizeof(*plan); ++i) if (bytes[i] != 0u) return 0;
    return 1;
}

static int current_types_and_nonzero_d2_mapping(void)
{
    uint8_t occupied[] = {1, 1, 1, 1, 1, 0, 1, 0};
    uint8_t types[] = {0x36, 0x3f, 0x00, 0x2d, 0x9f, 0x2d, 0x95, 0x00};
    uint8_t accepted[] = {0, 1, 2, 1, 1};
    const uint8_t occupied_before[] = {1, 1, 1, 1, 1, 0, 1, 0};
    const uint8_t types_before[] = {0x36, 0x3f, 0x00, 0x2d, 0x9f, 0x2d, 0x95, 0x00};
    const uint8_t accepted_before[] = {0, 1, 2, 1, 1};
    const uint16_t global[] = {0, 1, 2, 4};
    SceneNormalActionSlotPlan plan;
    CHECK(scene_action_slots_plan_normal(8u, occupied, types, 5u, accepted, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.resource_count == 5u && plan.slots.source_high_water == 8u);
    CHECK(plan.slots.retained_high_water == 4u && plan.slots.final_high_water == 5u && plan.slots.incoming_count == 4u);
    /* Occupied type0/36/3f/9f/95 retire. Slot3's occupied D2 survives even
     * when complete: completion is deliberately not a vacancy input. */
    for (size_t i = 0; i < 8u; ++i) CHECK(plan.slots.retired[i] == (occupied[i] != 0u && i != 3u));
    CHECK(plan.resource_to_global[0] == UINT16_MAX);
    for (size_t i = 0; i < 4u; ++i) {
        CHECK(plan.slots.assigned[i] == global[i]);
        CHECK(plan.accepted_resource_indices[i] == i + 1u);
        CHECK(plan.resource_to_global[i + 1u] == global[i]);
    }
    for (size_t i = 5u; i < SCENE_ACTION_RESOURCE_LIMIT; ++i) CHECK(plan.resource_to_global[i] == UINT16_MAX);
    CHECK(memcmp(occupied, occupied_before, sizeof(occupied)) == 0);
    CHECK(memcmp(types, types_before, sizeof(types)) == 0);
    CHECK(memcmp(accepted, accepted_before, sizeof(accepted)) == 0);
    return 0;
}

static int skip_order_and_full_resource_map(void)
{
    uint8_t occupied[] = {1, 1, 1, 1, 1};
    uint8_t types[] = {0x4d, 0x2d, 0x0b, 0x36, 0x3f};
    uint8_t accepted[SCENE_ACTION_RESOURCE_LIMIT] = {0};
    uint8_t before[SCENE_ACTION_RESOURCE_LIMIT];
    SceneNormalActionSlotPlan plan;
    /* 999 known skips are legal: resource count is not accepted-row count. */
    CHECK(scene_action_slots_plan_normal(5u, occupied, types, SCENE_ACTION_RESOURCE_LIMIT, accepted, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.slots.retained_high_water == 2u && plan.slots.final_high_water == 2u && plan.slots.incoming_count == 0u);
    for (size_t i = 0; i < SCENE_ACTION_RESOURCE_LIMIT; ++i) CHECK(plan.resource_to_global[i] == UINT16_MAX);
    accepted[996] = 1u; accepted[998] = 1u;
    memcpy(before, accepted, sizeof(before));
    CHECK(scene_action_slots_plan_normal(5u, occupied, types, SCENE_ACTION_RESOURCE_LIMIT, accepted, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.slots.incoming_count == 2u && plan.slots.final_high_water == 3u);
    CHECK(plan.accepted_resource_indices[0] == 996u && plan.accepted_resource_indices[1] == 998u);
    CHECK(plan.slots.assigned[0] == 0u && plan.slots.assigned[1] == 2u);
    for (size_t i = 0; i < SCENE_ACTION_RESOURCE_LIMIT; ++i)
        CHECK(plan.resource_to_global[i] == (i == 996u ? 0u : i == 998u ? 2u : UINT16_MAX));
    CHECK(memcmp(accepted, before, sizeof(before)) == 0);
    return 0;
}

static int guard_precedes_every_resource_act(void)
{
    uint8_t occupied[120], types[120], skip = 0u, accept = 1u;
    uint8_t incoming[121];
    SceneNormalActionSlotPlan plan;
    memset(occupied, 1, sizeof(occupied)); memset(types, 0x36, sizeof(types));
    occupied[4] = 0u; types[119] = 0x2d;
    /* After clear, the survivor at119 keeps H120 despite119 holes. The
     * guard fires BEFORE even a skipped constructor. */
    memset(&plan, 0xa5, sizeof(plan));
    CHECK(scene_action_slots_plan_normal(120u, occupied, types, 1u, &skip, &plan) == SCENE_ACTION_SLOTS_ERR_LIMIT);
    CHECK(cleared(&plan));
    CHECK(scene_action_slots_plan_normal(120u, occupied, types, 1u, &accept, &plan) == SCENE_ACTION_SLOTS_ERR_LIMIT);
    CHECK(cleared(&plan));
    CHECK(scene_action_slots_plan_normal(120u, occupied, types, 0, NULL, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.slots.retained_high_water == 120u && plan.slots.final_high_water == 120u);
    memset(incoming, 1, sizeof(incoming)); incoming[120] = 0u;
    CHECK(scene_action_slots_plan_normal(0, NULL, NULL, 120u, incoming, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.slots.incoming_count == 120u && plan.slots.final_high_water == 120u);
    CHECK(plan.slots.assigned[119] == 119u && plan.accepted_resource_indices[119] == 119u);
    memset(&plan, 0xa5, sizeof(plan));
    CHECK(scene_action_slots_plan_normal(0, NULL, NULL, 121u, incoming, &plan) == SCENE_ACTION_SLOTS_ERR_LIMIT);
    CHECK(cleared(&plan)); /* No partial accepted map leaks on late failure. */
    CHECK(incoming[120] == 0u && occupied[4] == 0u && types[119] == 0x2d);
    return 0;
}

static int zero_resources_and_argument_errors(void)
{
    uint8_t occupied[] = {1, 0, 1}, types[] = {0x3f, 0x2d, 0x00}, accept = 1u;
    uint8_t far_occupied[SCENE_ACTION_SLOT_LIMIT] = {0}, far_types[SCENE_ACTION_SLOT_LIMIT] = {0};
    SceneNormalActionSlotPlan plan;
    CHECK(scene_action_slots_plan_normal(3u, occupied, types, 0, NULL, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.slots.retired[0] == 1u && plan.slots.retired[1] == 0u && plan.slots.retired[2] == 1u);
    CHECK(plan.slots.source_high_water == 3u && plan.slots.retained_high_water == 0u && plan.slots.final_high_water == 0u);
    CHECK(scene_action_slots_plan_normal(0, NULL, NULL, 0, NULL, &plan) == SCENE_ACTION_SLOTS_OK);
    for (size_t i = 0; i < SCENE_ACTION_RESOURCE_LIMIT; ++i) CHECK(plan.resource_to_global[i] == UINT16_MAX);
    far_occupied[239] = 1u; far_types[239] = 0x2d;
    CHECK(scene_action_slots_plan_normal(240u, far_occupied, far_types, 0, NULL, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.slots.retained_high_water == 240u && plan.slots.final_high_water == 240u);
    CHECK(scene_action_slots_plan_normal(240u, far_occupied, far_types, 1u, &accept, &plan) == SCENE_ACTION_SLOTS_ERR_LIMIT);
    CHECK(cleared(&plan));
    far_types[239] = 0x36;
    CHECK(scene_action_slots_plan_normal(240u, far_occupied, far_types, 0, NULL, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.slots.retired[239] == 1u && plan.slots.retained_high_water == 0u);
    CHECK(scene_action_slots_plan_normal(0, NULL, NULL, 0, NULL, NULL) == SCENE_ACTION_SLOTS_ERR_ARGUMENT);
    memset(&plan, 0xa5, sizeof(plan));
    CHECK(scene_action_slots_plan_normal(1u, NULL, types, 1u, &accept, &plan) == SCENE_ACTION_SLOTS_ERR_ARGUMENT);
    CHECK(cleared(&plan));
    CHECK(scene_action_slots_plan_normal(1u, occupied, NULL, 0, NULL, &plan) == SCENE_ACTION_SLOTS_ERR_ARGUMENT);
    CHECK(cleared(&plan));
    CHECK(scene_action_slots_plan_normal(0, NULL, NULL, 1u, NULL, &plan) == SCENE_ACTION_SLOTS_ERR_ARGUMENT);
    CHECK(cleared(&plan));
    CHECK(scene_action_slots_plan_normal(241u, NULL, NULL, 0, NULL, &plan) == SCENE_ACTION_SLOTS_ERR_LIMIT);
    CHECK(cleared(&plan));
    CHECK(scene_action_slots_plan_normal(0, NULL, NULL, 1000u, NULL, &plan) == SCENE_ACTION_SLOTS_ERR_LIMIT);
    CHECK(cleared(&plan));
    return 0;
}

int main(int argc, char **argv)
{
    int status = 1;
    (void)signal(SIGABRT, unexpected_signal); (void)signal(SIGBUS, unexpected_signal);
    (void)signal(SIGFPE, unexpected_signal); (void)signal(SIGILL, unexpected_signal); (void)signal(SIGSEGV, unexpected_signal);
    if (argc != 2) return 1;
    if (strcmp(argv[1], "mapping") == 0) status = current_types_and_nonzero_d2_mapping();
    else if (strcmp(argv[1], "skips") == 0) status = skip_order_and_full_resource_map();
    else if (strcmp(argv[1], "capacity") == 0) status = guard_precedes_every_resource_act();
    else if (strcmp(argv[1], "empty") == 0) status = zero_resources_and_argument_errors();
    if (!status) printf("PASS scene_normal_action_slots %s\n", argv[1]);
    return status;
}
