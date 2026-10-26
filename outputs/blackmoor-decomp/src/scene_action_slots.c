#include "scene_action_slots.h"

#include <string.h>

/* 0x43e484's current-runtime-type switch. Completion controls the caller's
 * conversation release, not whether the slot is retired. This pure plan
 * neither releases objects nor resets surviving state/condition trees. */
static int retires_on_no_art(uint8_t type, int32_t overlay_flag)
{
    switch (type) {
    case 0x0a:
    case 0x20:
    case 0x47:
    case 0x81:
    case 0x82:
    case 0x83:
    case 0x39:
    case 0x3a:
    case 0x3b:
    case 0x3c:
    case 0x3e:
    case 0x3f:
        return 1;
    case 0x4b:
    case 0x4c:
    case 0x51:
        return overlay_flag != 0;
    default:
        return 0;
    }
}

int scene_action_slots_plan_no_art(size_t high_water,
    const uint8_t *occupied, const uint8_t *runtime_types,
    int32_t overlay_flag, size_t incoming_count, SceneActionSlotPlan *out)
{
    SceneActionSlotPlan plan = { 0 };
    uint8_t live[SCENE_ACTION_SLOT_LIMIT] = { 0 };
    size_t current;

    if (out != NULL) memset(out, 0, sizeof(*out));
    if (high_water > SCENE_ACTION_SLOT_LIMIT || incoming_count > SCENE_ACTION_SLOT_LIMIT)
        return SCENE_ACTION_SLOTS_ERR_LIMIT;
    if (out == NULL || (high_water != 0u && (occupied == NULL || runtime_types == NULL)))
        return SCENE_ACTION_SLOTS_ERR_ARGUMENT;

    plan.source_high_water = high_water;
    plan.incoming_count = incoming_count;
    for (size_t i = 0; i < high_water; ++i) {
        if (occupied[i] != 0u) {
            if (retires_on_no_art(runtime_types[i], overlay_flag)) plan.retired[i] = 1u;
            else live[i] = 1u;
        }
    }

    /* 0x43e8b8 trims only the trailing vacancy run. Internal holes and
     * survivor indices stay exactly where they were. */
    current = high_water;
    while (current != 0u && live[current - 1u] == 0u) --current;
    plan.retained_high_water = current;

    for (size_t i = 0; i < incoming_count; ++i) {
        size_t slot = 0u;
        /* 0x43a5c1..0x43a5ec checks the current high-water BEFORE each
         * constructor. A hole does not relax this original limit. */
        if (current >= SCENE_ACTION_SLOT_LIMIT) return SCENE_ACTION_SLOTS_ERR_LIMIT;
        /* 0x40b37e..0x40b3a0 chooses the first hole, otherwise appends. */
        while (slot < current && live[slot] != 0u) ++slot;
        plan.assigned[i] = (uint16_t)slot;
        live[slot] = 1u;
        if (slot == current) ++current;
    }
    plan.final_high_water = current;
    *out = plan;
    return SCENE_ACTION_SLOTS_OK;
}
