#ifndef BLACKMOOR_ACTION_CORE_H
#define BLACKMOOR_ACTION_CORE_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_CORE_SHORT_SLOT_COUNT 30u
#define ACTION_CORE_FLOAT_SLOT_COUNT 10u

/* Caller-owned gameplay state touched by the recovered action handlers.
 * event_flag_count bounds the caller's native storage; the original table's
 * capacity and sizing rule have not been established. */
typedef struct action_core_world {
    int16_t short_values[ACTION_CORE_SHORT_SLOT_COUNT];
    float float_values[ACTION_CORE_FLOAT_SLOT_COUNT];
    int16_t difficulty;
    int32_t *event_flags;
    size_t event_flag_count;
} ActionCoreWorld;

typedef enum action_core_status {
    ACTION_CORE_OK = 0,
    ACTION_CORE_ERR_ARGUMENT = 1,
    ACTION_CORE_ERR_BODY = 2,
    ACTION_CORE_ERR_EVENT_FLAG_BOUNDS = 3,
    ACTION_CORE_ERR_UNSUPPORTED = 4
} ActionCoreStatus;

/* Initialize the original 30 short-value slots and 10 float-value slots to
 * 9999/9999.0f, as VA 0x44aff2 does. Difficulty and event-flag state are
 * deliberately untouched. */
int action_core_initialize_values(ActionCoreWorld *world);

/* Inputs are in scene action-table order. `eligible` is supplied by the
 * runtime after its dependency/timing checks; this is a helper interface, not
 * a recovered scene scheduler. A runtime should evaluate each action against
 * current state immediately before applying it, so earlier edits can affect
 * later dependencies. `completed_before` and
 * `phase_before` let subtype completion be returned without owning runtime
 * state. Body bytes are the original little-endian typed body. */
typedef struct action_core_action {
    uint8_t type;
    uint8_t subtype;
    uint8_t eligible;
    uint8_t completed_before;
    uint32_t phase_before;
    const uint8_t *body;
    size_t body_length;
} ActionCoreAction;

typedef struct action_core_action_result {
    uint8_t recognized;
    uint8_t applied;
    uint8_t completed;
    uint8_t reset_dependencies;
    uint32_t phase;
} ActionCoreActionResult;

/* Atomic handlers for the verified original body layouts. Invalid event-flag
 * indices are reported before any pair in that action is written. */
int action_core_apply_set_value(ActionCoreWorld *world,
                                const uint8_t *body,
                                size_t body_length);
int action_core_apply_event_flags(ActionCoreWorld *world,
                                  const uint8_t *body,
                                  size_t body_length,
                                  size_t pair_count);
int action_core_apply_difficulty(ActionCoreWorld *world,
                                 const uint8_t *body,
                                 size_t body_length);

/* Models the shared 0x42ba3a post-handler completion fields used by 0x4d,
 * 0x61, and 0x6b. Subtype 2 requests a dependency reset from the owning
 * runtime; phase is zero after this helper. Type 0x71 is distinct: its
 * dispatcher branch directly sets completed=1 and preserves phase. */
int action_core_finish_action(uint8_t subtype,
                              uint8_t completed_before,
                              ActionCoreActionResult *result);

/* Applies only the recovered state-editing families (0x4d, 0x61, 0x6b, 0x71)
 * in input order. An eligible unsupported type is an explicit error for the
 * owning runtime to handle. The full input is validated before any state
 * mutation, so malformed native input cannot leave a partial dispatch applied.
 * This helper does not establish that a whole scene dispatched successfully. */
int action_core_dispatch(ActionCoreWorld *world,
                         const ActionCoreAction *actions,
                         size_t action_count,
                         ActionCoreActionResult *results);

const char *action_core_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
