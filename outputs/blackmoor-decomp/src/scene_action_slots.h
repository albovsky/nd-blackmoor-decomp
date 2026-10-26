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

#define SCENE_ACTION_NORMAL_SLOT_LIMIT 120u
#define SCENE_ACTION_RESOURCE_LIMIT 999u

typedef struct SceneNormalActionSlotPlan {
    SceneActionSlotPlan slots;
    size_t resource_count;
    uint16_t resource_to_global[SCENE_ACTION_RESOURCE_LIMIT];
    uint16_t accepted_resource_indices[SCENE_ACTION_SLOT_LIMIT];
} SceneNormalActionSlotPlan;

/* Normal-art policy: retain occupied CURRENT runtime 0x2d slots only, retire
 * every other occupied type, then trim trailing vacancies without moving any
 * survivor. Completion is independent of occupancy and is not an input.
 *
 * Before EVERY resource ACT, high-water must be below 120, including for a
 * known constructor skip. A zero constructor_accepted entry skips that ACT
 * without consuming a slot. A nonzero entry fills the first hole or appends.
 * The caller establishes constructor results; no constructor, resource,
 * dependency, provider or host work takes place here.
 *
 * Slot arrays cover high_water (up to 240), and may be NULL when it is zero.
 * The accepted mask covers resource_count (up to 999), and may be NULL when
 * it is zero. Inputs are never mutated. out is required and is entirely zero
 * on failure. Invalid counts return ERR_LIMIT, other bad args ERR_ARGUMENT.
 * Zero resource ACTs still retire/trim but do not run the 120 guard.
 *
 * On success slots.incoming_count is the accepted count (at most 120), with
 * slots.assigned and accepted_resource_indices in compact resource order.
 * resource_to_global maps each resource-local ACT to its global slot;
 * skipped and unused map entries are UINT16_MAX. Other unused entries have
 * no meaning. Existing 0x2d source indices and slots remain unchanged. */
int scene_action_slots_plan_normal(size_t high_water,
    const uint8_t *occupied, const uint8_t *runtime_types,
    size_t resource_count, const uint8_t *constructor_accepted,
    SceneNormalActionSlotPlan *out);

#ifdef __cplusplus
}
#endif
#endif
