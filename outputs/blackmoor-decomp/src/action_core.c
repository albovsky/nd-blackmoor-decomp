#include "action_core.h"

#include <limits.h>
#include <stdint.h>

enum {
    ACTION_TYPE_SET_VALUE = 0x4d,
    ACTION_TYPE_EVENT_FLAGS_2 = 0x61,
    ACTION_TYPE_EVENT_FLAGS_10 = 0x6b,
    ACTION_TYPE_DIFFICULTY = 0x71
};

static uint16_t read_u16le(const uint8_t *bytes)
{
    return (uint16_t)((uint16_t)bytes[0] | ((uint16_t)bytes[1] << 8));
}

static int16_t read_i16le(const uint8_t *bytes)
{
    uint16_t bits = read_u16le(bytes);
    int32_t value = (bits & UINT16_C(0x8000)) != 0u
                        ? (int32_t)bits - INT32_C(0x10000)
                        : (int32_t)bits;
    return (int16_t)value;
}

static int16_t wrap_i16_add(int16_t left, int16_t right)
{
    uint16_t bits = (uint16_t)((uint16_t)left + (uint16_t)right);
    int32_t value = (bits & UINT16_C(0x8000)) != 0u
                        ? (int32_t)bits - INT32_C(0x10000)
                        : (int32_t)bits;
    return (int16_t)value;
}

/* 0x44aff2 (FUN_0044aff2): sentinel value initializer. */
int action_core_initialize_values(ActionCoreWorld *world)
{
    size_t index;

    if (world == NULL) {
        return ACTION_CORE_ERR_ARGUMENT;
    }
    for (index = 0u; index < ACTION_CORE_SHORT_SLOT_COUNT; ++index) {
        world->short_values[index] = INT16_C(9999);
    }
    for (index = 0u; index < ACTION_CORE_FLOAT_SLOT_COUNT; ++index) {
        world->float_values[index] = 9999.0f;
    }
    return ACTION_CORE_OK;
}

static int event_flag_location_is_valid(const ActionCoreWorld *world,
                                        int16_t index)
{
    if (index == -1) {
        return 1;
    }
    return index >= 0 && (size_t)index < world->event_flag_count &&
           world->event_flags != NULL;
}

static int validate_event_flags(const ActionCoreWorld *world,
                                const uint8_t *body,
                                size_t body_length,
                                size_t pair_count)
{
    size_t pair;
    if (world == NULL || (body == NULL && body_length != 0u) ||
        pair_count > SIZE_MAX / 4u || body_length != pair_count * 4u) {
        return ACTION_CORE_ERR_BODY;
    }
    for (pair = 0u; pair < pair_count; ++pair) {
        int16_t index = read_i16le(body + pair * 4u);
        if (!event_flag_location_is_valid(world, index)) {
            return ACTION_CORE_ERR_EVENT_FLAG_BOUNDS;
        }
    }
    return ACTION_CORE_OK;
}

int action_core_apply_set_value(ActionCoreWorld *world,
                                const uint8_t *body,
                                size_t body_length)
{
    uint8_t index;
    uint8_t mode;
    int16_t value;

    if (world == NULL || body == NULL) {
        return ACTION_CORE_ERR_ARGUMENT;
    }
    if (body_length != 4u) {
        return ACTION_CORE_ERR_BODY;
    }
    index = body[0];
    mode = body[1];
    value = read_i16le(body + 2u);

    /* Original 0x44b26a logs this only when its debug global is enabled. With
     * debug logging disabled (the normal state), indices >= 40 are no-ops. */
    if (index >= ACTION_CORE_SHORT_SLOT_COUNT + ACTION_CORE_FLOAT_SLOT_COUNT) {
        return ACTION_CORE_OK;
    }
    if (index < ACTION_CORE_SHORT_SLOT_COUNT) {
        int16_t *slot = &world->short_values[index];
        if (mode == 0u && *slot != INT16_C(9999)) {
            *slot = wrap_i16_add(*slot, value);
        } else {
            *slot = value;
        }
    } else {
        size_t float_index = (size_t)index - ACTION_CORE_SHORT_SLOT_COUNT;
        float *slot = &world->float_values[float_index];
        if (mode == 0u && *slot != 9999.0f) {
            *slot = *slot + (float)value;
        } else {
            *slot = (float)value;
        }
    }
    return ACTION_CORE_OK;
}

int action_core_apply_event_flags(ActionCoreWorld *world,
                                  const uint8_t *body,
                                  size_t body_length,
                                  size_t pair_count)
{
    size_t pair;
    int status = validate_event_flags(world, body, body_length, pair_count);
    if (status != ACTION_CORE_OK) {
        return status;
    }
    for (pair = 0u; pair < pair_count; ++pair) {
        int16_t index = read_i16le(body + pair * 4u);
        int16_t value = read_i16le(body + pair * 4u + 2u);
        if (index != -1) {
            world->event_flags[index] = (int32_t)value;
        }
    }
    return ACTION_CORE_OK;
}

int action_core_apply_difficulty(ActionCoreWorld *world,
                                 const uint8_t *body,
                                 size_t body_length)
{
    int16_t event_index;
    int16_t event_value;
    if (world == NULL || body == NULL) {
        return ACTION_CORE_ERR_ARGUMENT;
    }
    if (body_length != 6u) {
        return ACTION_CORE_ERR_BODY;
    }
    event_index = read_i16le(body + 2u);
    event_value = read_i16le(body + 4u);
    if (!event_flag_location_is_valid(world, event_index)) {
        return ACTION_CORE_ERR_EVENT_FLAG_BOUNDS;
    }

    world->difficulty = read_i16le(body);
    if (event_index != -1) {
        world->event_flags[event_index] = (int32_t)event_value;
    }
    return ACTION_CORE_OK;
}

/* The common completion routine, original 0x42ba3a: subtype 1 completes the
 * action, subtype 2 clears completion and resets its dependencies (0x423d33,
 * reported as reset_dependencies), then the phase word is zeroed. */
int action_core_finish_action(uint8_t subtype,
                              uint8_t completed_before,
                              ActionCoreActionResult *result)
{
    if (result == NULL) {
        return ACTION_CORE_ERR_ARGUMENT;
    }
    result->recognized = 1u;
    result->applied = 1u;
    result->completed = completed_before != 0u;
    result->reset_dependencies = 0u;
    result->phase = 0u;
    if (subtype == 1u) {
        result->completed = 1u;
    } else if (subtype == 2u) {
        result->completed = 0u;
        result->reset_dependencies = 1u;
    }
    return ACTION_CORE_OK;
}

static size_t flag_pair_count(uint8_t type)
{
    if (type == ACTION_TYPE_EVENT_FLAGS_2) {
        return 2u;
    }
    if (type == ACTION_TYPE_EVENT_FLAGS_10) {
        return 10u;
    }
    return 0u;
}

static int is_supported_type(uint8_t type)
{
    return type == ACTION_TYPE_SET_VALUE ||
           type == ACTION_TYPE_EVENT_FLAGS_2 ||
           type == ACTION_TYPE_EVENT_FLAGS_10 ||
           type == ACTION_TYPE_DIFFICULTY;
}

static int validate_action(const ActionCoreWorld *world,
                           const ActionCoreAction *action)
{
    if (!action->eligible) {
        return ACTION_CORE_OK;
    }
    if (!is_supported_type(action->type)) {
        return ACTION_CORE_ERR_UNSUPPORTED;
    }
    if (action->body == NULL) {
        return ACTION_CORE_ERR_ARGUMENT;
    }
    switch (action->type) {
    case ACTION_TYPE_SET_VALUE:
        return action->body_length == 4u ? ACTION_CORE_OK : ACTION_CORE_ERR_BODY;
    case ACTION_TYPE_EVENT_FLAGS_2:
    case ACTION_TYPE_EVENT_FLAGS_10:
        return validate_event_flags(world, action->body, action->body_length,
                                    flag_pair_count(action->type));
    case ACTION_TYPE_DIFFICULTY: {
        int16_t index;
        if (action->body_length != 6u) {
            return ACTION_CORE_ERR_BODY;
        }
        index = read_i16le(action->body + 2u);
        return event_flag_location_is_valid(world, index)
                   ? ACTION_CORE_OK
                   : ACTION_CORE_ERR_EVENT_FLAG_BOUNDS;
    }
    default:
        return ACTION_CORE_OK;
    }
}

int action_core_dispatch(ActionCoreWorld *world,
                         const ActionCoreAction *actions,
                         size_t action_count,
                         ActionCoreActionResult *results)
{
    size_t index;

    if ((world == NULL) ||
        (action_count != 0u && (actions == NULL || results == NULL)) ||
        (world->event_flag_count != 0u && world->event_flags == NULL)) {
        return ACTION_CORE_ERR_ARGUMENT;
    }

    /* Preflight every eligible supported body before changing caller state. */
    for (index = 0u; index < action_count; ++index) {
        int status = validate_action(world, &actions[index]);
        if (status != ACTION_CORE_OK) {
            return status;
        }
    }

    for (index = 0u; index < action_count; ++index) {
        const ActionCoreAction *action = &actions[index];
        ActionCoreActionResult result = {0u, 0u, action->completed_before,
                                         0u, action->phase_before};
        int status = ACTION_CORE_OK;

        result.recognized = (uint8_t)is_supported_type(action->type);
        if (result.recognized && action->eligible) {
            switch (action->type) {
            case ACTION_TYPE_SET_VALUE:
                status = action_core_apply_set_value(world, action->body,
                                                     action->body_length);
                break;
            case ACTION_TYPE_EVENT_FLAGS_2:
            case ACTION_TYPE_EVENT_FLAGS_10:
                status = action_core_apply_event_flags(
                    world, action->body, action->body_length,
                    flag_pair_count(action->type));
                break;
            case ACTION_TYPE_DIFFICULTY:
                status = action_core_apply_difficulty(world, action->body,
                                                      action->body_length);
                break;
            default:
                break;
            }
            if (status == ACTION_CORE_OK) {
                if (action->type == ACTION_TYPE_DIFFICULTY) {
                    /* Executor case 0x71 writes the completion byte directly;
                     * it does not call 0x42ba3a and leaves the phase intact. */
                    result.applied = 1u;
                    result.completed = 1u;
                    result.phase = action->phase_before;
                } else {
                    status = action_core_finish_action(action->subtype,
                                                       action->completed_before,
                                                       &result);
                }
            }
        }
        if (status != ACTION_CORE_OK) {
            /* Preflight makes this unreachable unless caller state changes
             * concurrently while a dispatch is in progress. */
            return status;
        }
        results[index] = result;
    }
    return ACTION_CORE_OK;
}

const char *action_core_status_string(int status)
{
    switch (status) {
    case ACTION_CORE_OK:
        return "ok";
    case ACTION_CORE_ERR_ARGUMENT:
        return "invalid argument";
    case ACTION_CORE_ERR_BODY:
        return "invalid action body length";
    case ACTION_CORE_ERR_EVENT_FLAG_BOUNDS:
        return "event flag index is outside caller-provided table";
    case ACTION_CORE_ERR_UNSUPPORTED:
        return "eligible action type is not implemented by this core";
    default:
        return "unknown action-core status";
    }
}
