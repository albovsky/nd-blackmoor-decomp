#include "action_family_62_interaction.h"

#include <limits.h>
#include <string.h>

ActionFamily62InteractionStatus action_family_62_interaction_scan(
    const ActionFamily62InteractionScanInput *input,
    ActionFamily62InteractionScanResult *result)
{
    size_t index;

    if (input == NULL || result == NULL) {
        return ACTION_FAMILY_62_INTERACTION_ERR_ARGUMENT;
    }
    if (input->target_count != 0 && input->targets == NULL) {
        return ACTION_FAMILY_62_INTERACTION_ERR_ARGUMENT;
    }
    if (input->target_count > (size_t)INT32_MAX + 1u) {
        return ACTION_FAMILY_62_INTERACTION_ERR_COUNT;
    }

    memset(result, 0, sizeof(*result));
    result->candidate_action_index = -1;
    if (input->cursor_command != 0) {
        return ACTION_FAMILY_62_INTERACTION_OK;
    }

    for (index = 0; index < input->target_count; ++index) {
        const ActionFamily62InteractionTarget *target = &input->targets[index];
        int32_t action_index = (int32_t)index;

        if (target->request_pending == 0) {
            continue;
        }

        /*
         * Original memory order: response[1]/[3] bound coordinate +0x5a;
         * response[0]/[2] bound coordinate +0x5e. Bounds are inclusive.
         */
        if ((int32_t)target->response_words[1] <= input->coordinate_a &&
            input->coordinate_a <= (int32_t)target->response_words[3] &&
            (int32_t)target->response_words[0] <= input->coordinate_b &&
            input->coordinate_b <= (int32_t)target->response_words[2]) {
            result->candidate_action_index = action_index;
            result->candidate_found = 1;
            if (action_index == input->reserved_index_a) {
                result->candidate_route = ACTION_FAMILY_62_INTERACTION_ROUTE_RESERVED_A;
            } else if (action_index == input->reserved_index_b) {
                result->candidate_route = ACTION_FAMILY_62_INTERACTION_ROUTE_RESERVED_B;
            } else {
                result->candidate_route = ACTION_FAMILY_62_INTERACTION_ROUTE_ORDINARY;
            }
            return ACTION_FAMILY_62_INTERACTION_OK;
        }
    }

    return ACTION_FAMILY_62_INTERACTION_OK;
}

ActionFamily62InteractionStatus action_family_62_interaction_accept(
    const ActionFamily62InteractionAcceptInput *input,
    ActionFamily62InteractionAcceptResult *result)
{
    if (input == NULL || result == NULL) {
        return ACTION_FAMILY_62_INTERACTION_ERR_ARGUMENT;
    }

    memset(result, 0, sizeof(*result));
    result->child_index = -1;
    if (input->candidate_action_index < 0 ||
        input->candidate_action_index >= 0xf0 ||
        input->suppression_value != 0) {
        return ACTION_FAMILY_62_INTERACTION_OK;
    }

    result->candidate_considered = 1;
    if (input->action_control_word_at_plus_0x30 == 0) {
        result->phase2_requested = 1;
        return ACTION_FAMILY_62_INTERACTION_OK;
    }

    result->dependency_check_required = 1;
    if (input->dependency_ready != 0 && input->dependency_child_index != -1) {
        result->phase2_requested = 1;
        if (input->dependency_child_index >= 0) {
            result->child_request_required = 1;
            result->child_index = input->dependency_child_index;
        }
    } else {
        result->dependency_feedback_required = 1;
    }

    return ACTION_FAMILY_62_INTERACTION_OK;
}

static int16_t signed_word(uint16_t bits)
{
    int32_t value = (int32_t)bits;
    if (value > INT16_MAX) {
        value -= (int32_t)UINT16_MAX + 1;
    }
    return (int16_t)value;
}

ActionFamily62InteractionStatus action_family_62_interaction_navigate(
    const ActionFamily62InteractionNavigateInput *input,
    ActionFamily62InteractionNavigateResult *result)
{
    uint16_t selector_bits;
    int16_t next_selector;

    if (input == NULL || result == NULL) {
        return ACTION_FAMILY_62_INTERACTION_ERR_ARGUMENT;
    }

    memset(result, 0, sizeof(*result));
    result->selector_after = input->selector;
    if (input->navigation_allowed == 0 ||
        (input->selector_command != 1 && input->selector_command != 2)) {
        if (input->navigation_allowed != 0 &&
            input->selector_command >= 3 && input->selector_command <= 8) {
            return ACTION_FAMILY_62_INTERACTION_UNSUPPORTED;
        }
        return ACTION_FAMILY_62_INTERACTION_OK;
    }

    if (input->scene_mode >= 2 && input->scene_mode <= 5) {
        return ACTION_FAMILY_62_INTERACTION_UNSUPPORTED;
    }

    selector_bits = (uint16_t)input->selector;
    if (input->selector_command == 1) {
        selector_bits = (uint16_t)(selector_bits + (uint16_t)input->step);
        next_selector = signed_word(selector_bits);
        if (next_selector > input->selector_max) {
            if (input->wrap_mode == 1) {
                next_selector = input->selector_min;
            } else if (input->wrap_mode == 2 || input->wrap_mode == 0) {
                next_selector = input->selector_max;
            }
        }
    } else {
        selector_bits = (uint16_t)(selector_bits - (uint16_t)input->step);
        next_selector = signed_word(selector_bits);
        if (next_selector < input->selector_min) {
            if (input->wrap_mode == 1) {
                next_selector = input->selector_max;
            } else if (input->wrap_mode == 2 || input->wrap_mode == 0) {
                next_selector = input->selector_min;
            }
        }
    }

    result->selector_after = next_selector;
    result->selector_written = 1;
    return ACTION_FAMILY_62_INTERACTION_OK;
}
