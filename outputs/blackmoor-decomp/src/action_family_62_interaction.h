#ifndef ACTION_FAMILY_62_INTERACTION_H
#define ACTION_FAMILY_62_INTERACTION_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef enum ActionFamily62InteractionStatus {
    ACTION_FAMILY_62_INTERACTION_OK = 0,
    ACTION_FAMILY_62_INTERACTION_ERR_ARGUMENT = 1,
    ACTION_FAMILY_62_INTERACTION_ERR_COUNT = 2,
    ACTION_FAMILY_62_INTERACTION_UNSUPPORTED = 3
} ActionFamily62InteractionStatus;

/*
 * A per-action request and the four signed response words published by the
 * original action handler. The words stay in their original slot order.
 */
typedef struct ActionFamily62InteractionTarget {
    uint32_t request_pending;
    int16_t response_words[4];
} ActionFamily62InteractionTarget;

/*
 * Coordinates are already transformed into the two values compared by
 * FUN_004f0059: action cursor object offsets +0x5a and +0x5e. These neutral
 * names avoid claiming screen-axis meanings not required by this operation.
 */
typedef struct ActionFamily62InteractionScanInput {
    const ActionFamily62InteractionTarget *targets;
    size_t target_count;
    int32_t coordinate_a;
    int32_t coordinate_b;
    int32_t reserved_index_a;
    int32_t reserved_index_b;
    int32_t cursor_command;
} ActionFamily62InteractionScanInput;

typedef struct ActionFamily62InteractionScanResult {
    int32_t candidate_action_index;
    uint8_t candidate_found;
    uint8_t candidate_route;
} ActionFamily62InteractionScanResult;

typedef enum ActionFamily62InteractionCandidateRoute {
    ACTION_FAMILY_62_INTERACTION_ROUTE_NONE = 0,
    ACTION_FAMILY_62_INTERACTION_ROUTE_ORDINARY = 1,
    ACTION_FAMILY_62_INTERACTION_ROUTE_RESERVED_A = 2,
    ACTION_FAMILY_62_INTERACTION_ROUTE_RESERVED_B = 3
} ActionFamily62InteractionCandidateRoute;

/*
 * Caller supplies the raw values read by the original candidate-consumption
 * block. The action control word is the dword at action-slot +0x30; its
 * higher-level meaning is not established. Dependency values are outputs of
 * the caller's original-derived dependency provider.
 */
typedef struct ActionFamily62InteractionAcceptInput {
    int32_t candidate_action_index;
    int32_t suppression_value;
    int32_t action_control_word_at_plus_0x30;
    int32_t dependency_ready;
    int32_t dependency_child_index;
} ActionFamily62InteractionAcceptInput;

typedef struct ActionFamily62InteractionAcceptResult {
    uint8_t candidate_considered;
    uint8_t dependency_check_required;
    uint8_t phase2_requested;
    uint8_t child_request_required;
    uint8_t dependency_feedback_required;
    int32_t child_index;
} ActionFamily62InteractionAcceptResult;

/*
 * Inputs to the selector arithmetic at FUN_0043a7ca. The caller owns the
 * earlier mode/timing/input eligibility checks. `scene_mode` is the raw
 * DAT_00583204 value used to select the command family; values 2..5 select
 * other, currently unsupported command paths.
 */
typedef struct ActionFamily62InteractionNavigateInput {
    uint32_t navigation_allowed;
    int32_t selector_command;
    int16_t selector;
    int16_t step;
    int16_t selector_min;
    int16_t selector_max;
    int16_t wrap_mode;
    int32_t scene_mode;
} ActionFamily62InteractionNavigateInput;

typedef struct ActionFamily62InteractionNavigateResult {
    int16_t selector_after;
    uint8_t selector_written;
} ActionFamily62InteractionNavigateResult;

/*
 * Return the first requested inclusive rectangle containing both cursor
 * coordinates. Original action order is preserved. The two reserved actions
 * have a dedicated candidate route; they are not dropped from candidate
 * production. A nonzero cursor command disables this rectangle-selection
 * branch. No input or state is mutated.
 */
ActionFamily62InteractionStatus action_family_62_interaction_scan(
    const ActionFamily62InteractionScanInput *input,
    ActionFamily62InteractionScanResult *result);

/*
 * Reduce the original candidate-index/suppression/control/dependency decision
 * to explicit effects. This does not mutate scene phase or execute child/UI
 * callbacks; the caller applies the returned effects in original order.
 */
ActionFamily62InteractionStatus action_family_62_interaction_accept(
    const ActionFamily62InteractionAcceptInput *input,
    ActionFamily62InteractionAcceptResult *result);

/*
 * Apply only the recovered command-1/command-2 selector reducer. Arithmetic
 * uses 16-bit wraparound before signed endpoint comparisons, matching ADDW/
 * SUBW in the original. Commands 3..8 and scene modes 2..5 are explicit
 * unsupported paths. Other commands and disallowed navigation are no-ops.
 */
ActionFamily62InteractionStatus action_family_62_interaction_navigate(
    const ActionFamily62InteractionNavigateInput *input,
    ActionFamily62InteractionNavigateResult *result);

#ifdef __cplusplus
}
#endif

#endif
