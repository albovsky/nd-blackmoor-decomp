#include "scene_action_slots.h"

#include <stdio.h>
#include <string.h>

#define CHECK(expr) do { if (!(expr)) { \
    fprintf(stderr, "CHECK line=%d expression=%s\n", __LINE__, #expr); \
    return 1; \
} } while (0)

static int all_zero(const SceneActionSlotPlan *plan)
{
    const unsigned char *bytes = (const unsigned char *)plan;
    for (size_t i = 0; i < sizeof(*plan); ++i) if (bytes[i] != 0u) return 0;
    return 1;
}

static int retirement_matrix(void)
{
    uint8_t types[] = {
        0x0a, 0x20, 0x47, 0x81, 0x82, 0x83,
        0x39, 0x3a, 0x3b, 0x3c, 0x3e, 0x3f,
        0x4b, 0x4c, 0x51,
        0x00, 0x36, 0x2d, 0x0b, 0x62, 0x2e, 0x9f, 0x95, 0x4d
    };
    uint8_t occupied[sizeof(types)], original_occupied[sizeof(types)], original_types[sizeof(types)];
    SceneActionSlotPlan plan;
    memset(occupied, 1, sizeof(occupied));
    memcpy(original_occupied, occupied, sizeof(occupied));
    memcpy(original_types, types, sizeof(types));
    CHECK(scene_action_slots_plan_no_art(sizeof(types), occupied, types, 0, 0, &plan) == SCENE_ACTION_SLOTS_OK);
    for (size_t i = 0; i < sizeof(types); ++i) CHECK(plan.retired[i] == (i < 12u));
    CHECK(plan.retained_high_water == sizeof(types) && plan.final_high_water == sizeof(types));
    CHECK(memcmp(occupied, original_occupied, sizeof(occupied)) == 0);
    CHECK(memcmp(types, original_types, sizeof(types)) == 0);
    /* Any nonzero overlay value selects all three conditional types. The
     * 0a row retires for BOTH overlay branches. */
    CHECK(scene_action_slots_plan_no_art(sizeof(types), occupied, types, -1, 0, &plan) == SCENE_ACTION_SLOTS_OK);
    for (size_t i = 0; i < sizeof(types); ++i) CHECK(plan.retired[i] == (i < 15u));
    CHECK(plan.source_high_water == sizeof(types) && plan.incoming_count == 0u);
    CHECK(memcmp(occupied, original_occupied, sizeof(occupied)) == 0);
    CHECK(memcmp(types, original_types, sizeof(types)) == 0);
    return 0;
}

static int stable_slots(void)
{
    /* Retain S4408's source owners and an occupied type-0 row. Completion
     * is intentionally absent from the API: a completed retained row must
     * remain occupied just like any other survivor. */
    const uint8_t types[] = { 0x2d, 0x0b, 0x62, 0x2e, 0x9f, 0x00, 0x36 };
    uint8_t occupied[] = { 1, 1, 1, 1, 1, 1, 2 };
    const uint8_t before[] = { 1, 1, 1, 1, 1, 1, 2 };
    SceneActionSlotPlan plan;
    CHECK(scene_action_slots_plan_no_art(7u, occupied, types, 0, 2u, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.retained_high_water == 7u && plan.final_high_water == 9u);
    CHECK(plan.assigned[0] == 7u && plan.assigned[1] == 8u);
    for (size_t i = 0; i < 7u; ++i) CHECK(plan.retired[i] == 0u);
    CHECK(memcmp(occupied, before, sizeof(before)) == 0);
    return 0;
}

static int holes_and_trim(void)
{
    const uint8_t types[] = { 0x2d, 0x3f, 0x36, 0x00, 0x4b, 0x3f, 0x62, 0x00 };
    uint8_t occupied[] = { 1, 1, 1, 0, 1, 0, 1, 0 };
    const uint8_t before[] = { 1, 1, 1, 0, 1, 0, 1, 0 };
    const uint16_t expected[] = { 1, 3, 4, 5, 7 };
    SceneActionSlotPlan plan;
    CHECK(scene_action_slots_plan_no_art(8u, occupied, types, 1, 5u, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.source_high_water == 8u && plan.retained_high_water == 7u && plan.final_high_water == 8u);
    CHECK(plan.incoming_count == 5u && plan.retired[1] == 1u && plan.retired[4] == 1u);
    CHECK(plan.retired[3] == 0u && plan.retired[5] == 0u && plan.retired[7] == 0u);
    for (size_t i = 0; i < 5u; ++i) CHECK(plan.assigned[i] == expected[i]);
    CHECK(memcmp(occupied, before, sizeof(before)) == 0);
    /* With overlay zero, slot4 survives and cannot be reused. */
    CHECK(scene_action_slots_plan_no_art(8u, occupied, types, 0, 4u, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.retired[4] == 0u && plan.assigned[0] == 1u && plan.assigned[1] == 3u);
    CHECK(plan.assigned[2] == 5u && plan.assigned[3] == 7u);
    return 0;
}

static int capacity_guard(void)
{
    uint8_t occupied[SCENE_ACTION_SLOT_LIMIT], types[SCENE_ACTION_SLOT_LIMIT];
    SceneActionSlotPlan plan;
    memset(occupied, 1, sizeof(occupied));
    memset(types, 0x36, sizeof(types));
    occupied[4] = 0;
    memset(&plan, 0xa5, sizeof(plan));
    CHECK(scene_action_slots_plan_no_art(240u, occupied, types, 0, 1u, &plan) == SCENE_ACTION_SLOTS_ERR_LIMIT);
    CHECK(all_zero(&plan));
    /* No incoming ACT means no constructor guard, even at high-water240. */
    CHECK(scene_action_slots_plan_no_art(240u, occupied, types, 0, 0, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.retained_high_water == 240u && plan.final_high_water == 240u);
    /* A trailing retired conversation trims first, permitting the existing
     * internal hole and then the new trailing slot to be filled. */
    types[239] = 0x3f;
    CHECK(scene_action_slots_plan_no_art(240u, occupied, types, 0, 2u, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.retired[239] == 1u && plan.retained_high_water == 239u && plan.final_high_water == 240u);
    CHECK(plan.assigned[0] == 4u && plan.assigned[1] == 239u);
    /* A later incoming row must rerun the guard; failures expose no partial
     * retirement or insertion plan. */
    memset(&plan, 0xa5, sizeof(plan));
    CHECK(scene_action_slots_plan_no_art(240u, occupied, types, 0, 3u, &plan) == SCENE_ACTION_SLOTS_ERR_LIMIT);
    CHECK(all_zero(&plan));
    CHECK(occupied[4] == 0u && occupied[239] == 1u && types[239] == 0x3f);
    return 0;
}

static int empty_and_retired(void)
{
    uint8_t occupied[] = { 1, 0, 1 }, types[] = { 0x3f, 0x2d, 0x0a };
    SceneActionSlotPlan plan;
    CHECK(scene_action_slots_plan_no_art(0, NULL, NULL, 0, 2u, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.source_high_water == 0u && plan.retained_high_water == 0u && plan.final_high_water == 2u);
    CHECK(plan.assigned[0] == 0u && plan.assigned[1] == 1u);
    CHECK(scene_action_slots_plan_no_art(3u, occupied, types, 0, 0, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.source_high_water == 3u && plan.retained_high_water == 0u && plan.final_high_water == 0u);
    CHECK(plan.retired[0] == 1u && plan.retired[1] == 0u && plan.retired[2] == 1u);
    CHECK(scene_action_slots_plan_no_art(0, NULL, NULL, 1, 240u, &plan) == SCENE_ACTION_SLOTS_OK);
    CHECK(plan.final_high_water == 240u && plan.assigned[239] == 239u);
    return 0;
}

static int argument_failures(void)
{
    uint8_t occupied = 1, type = 0x36;
    SceneActionSlotPlan plan;
    CHECK(scene_action_slots_plan_no_art(0, NULL, NULL, 0, 0, NULL) == SCENE_ACTION_SLOTS_ERR_ARGUMENT);
    memset(&plan, 0xa5, sizeof(plan));
    CHECK(scene_action_slots_plan_no_art(1u, NULL, &type, 0, 0, &plan) == SCENE_ACTION_SLOTS_ERR_ARGUMENT);
    CHECK(all_zero(&plan));
    memset(&plan, 0xa5, sizeof(plan));
    CHECK(scene_action_slots_plan_no_art(1u, &occupied, NULL, 0, 0, &plan) == SCENE_ACTION_SLOTS_ERR_ARGUMENT);
    CHECK(all_zero(&plan));
    memset(&plan, 0xa5, sizeof(plan));
    CHECK(scene_action_slots_plan_no_art(241u, NULL, NULL, 0, 0, &plan) == SCENE_ACTION_SLOTS_ERR_LIMIT);
    CHECK(all_zero(&plan));
    memset(&plan, 0xa5, sizeof(plan));
    CHECK(scene_action_slots_plan_no_art(0, NULL, NULL, 0, 241u, &plan) == SCENE_ACTION_SLOTS_ERR_LIMIT);
    CHECK(all_zero(&plan));
    return 0;
}

int main(int argc, char **argv)
{
    int status = 1;
    if (argc != 2) { fprintf(stderr, "one test case is required\n"); return 1; }
    if (strcmp(argv[1], "matrix") == 0) status = retirement_matrix();
    else if (strcmp(argv[1], "stable") == 0) status = stable_slots();
    else if (strcmp(argv[1], "holes") == 0) status = holes_and_trim();
    else if (strcmp(argv[1], "capacity") == 0) status = capacity_guard();
    else if (strcmp(argv[1], "empty") == 0) status = empty_and_retired();
    else if (strcmp(argv[1], "arguments") == 0) status = argument_failures();
    else fprintf(stderr, "unknown test case: %s\n", argv[1]);
    if (status == 0) printf("PASS scene_action_slots %s\n", argv[1]);
    return status;
}
