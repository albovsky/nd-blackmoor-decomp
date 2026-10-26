#ifndef BLACKMOOR_SCENE_ACTION_SLOTS_H
#define BLACKMOOR_SCENE_ACTION_SLOTS_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define SCENE_ACTION_SLOT_LIMIT 240u

typedef struct SceneActionSlotPlan {
    size_t source_high_water;
    size_t retained_high_water;
    size_t final_high_water;
    size_t incoming_count;
    uint8_t retired[SCENE_ACTION_SLOT_LIMIT];
    uint16_t assigned[SCENE_ACTION_SLOT_LIMIT];
} SceneActionSlotPlan;

enum {
    SCENE_ACTION_SLOTS_OK = 0,
    SCENE_ACTION_SLOTS_ERR_ARGUMENT = 1,
    SCENE_ACTION_SLOTS_ERR_LIMIT = 2
};

/* Pure NO_ART_SCENE slot plan: current runtime types select retirement, then
 * only trailing vacancies are trimmed. Before EACH incoming row, high-water
 * must be below 240 even if there is an internal hole; insert into the first
 * hole or append. Completion is not vacancy, and occupied runtime type 0 is
 * still occupied. No survivor is moved and no resource/provider is touched.
 *
 * occupied and runtime_types cover high_water entries, and may be NULL only
 * when high_water is zero. Nonzero occupied bytes mean occupied. Inputs are
 * never changed. out is required, and is cleared on any failure. Counts above
 * 240 return ERR_LIMIT; other invalid arguments return ERR_ARGUMENT.
 * On success retired marks occupied source rows to remove; assigned entries
 * [0,incoming_count) are global slots in incoming resource order. Remaining
 * assigned entries have no meaning. incoming_count=0 still retires/trims and
 * does not run the per-incoming capacity guard. */
int scene_action_slots_plan_no_art(size_t high_water,
    const uint8_t *occupied, const uint8_t *runtime_types,
    int32_t overlay_flag, size_t incoming_count, SceneActionSlotPlan *out);

#ifdef __cplusplus
}
#endif
#endif
