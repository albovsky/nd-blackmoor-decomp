#include "action_family_64.h"

#include <string.h>

static int16_t read_i16le(const uint8_t *bytes)
{
    uint16_t bits = (uint16_t)bytes[0] | (uint16_t)((uint16_t)bytes[1] << 8);
    if (bits <= (uint16_t)INT16_MAX) {
        return (int16_t)bits;
    }
    return (int16_t)((int32_t)bits - INT32_C(65536));
}

static int16_t add_i16_wrapping(int16_t left, int16_t right)
{
    uint16_t bits = (uint16_t)((uint32_t)(int32_t)left +
                               (uint32_t)(int32_t)right);
    if (bits <= (uint16_t)INT16_MAX) {
        return (int16_t)bits;
    }
    return (int16_t)((int32_t)bits - INT32_C(65536));
}

static int read_tick(ActionFamily64Backend *backend, uint32_t *tick)
{
    if (backend == NULL || backend->get_tick_count == NULL || tick == NULL) {
        return ACTION_FAMILY64_ERR_ARGUMENT;
    }
    if (backend->get_tick_count(backend->context, tick) !=
        ACTION_FAMILY64_BACKEND_OK) {
        return ACTION_FAMILY64_ERR_BACKEND;
    }
    return ACTION_FAMILY64_OK;
}

int action_family64_decode(const uint8_t *body, size_t body_length,
                           ActionFamily64Decoded *decoded, size_t *consumed)
{
    ActionFamily64Decoded next;

    if (body == NULL || decoded == NULL || consumed == NULL) {
        return ACTION_FAMILY64_ERR_ARGUMENT;
    }
    if (body_length != ACTION_FAMILY_64_BODY_BYTES) {
        return ACTION_FAMILY64_ERR_BODY;
    }

    next.operation = body[0];
    next.value_1 = read_i16le(body + 1u);
    next.value_2 = read_i16le(body + 3u);
    *decoded = next;
    *consumed = ACTION_FAMILY_64_BODY_BYTES;
    return ACTION_FAMILY64_OK;
}

int action_family64_step(const ActionFamily64Input *action,
                         const ActionFamily64World *world,
                         ActionFamily64Backend *backend,
                         ActionFamily64Result *result)
{
    ActionFamily64Decoded decoded;
    ActionFamily64World next_world;
    ActionFamily64Result next_result;
    uint32_t tick;
    size_t consumed;
    int status;

    if (action == NULL || world == NULL || result == NULL) {
        return ACTION_FAMILY64_ERR_ARGUMENT;
    }
    if (action->type != ACTION_FAMILY_64_TYPE) {
        return ACTION_FAMILY64_ERR_UNSUPPORTED;
    }
    status = action_family64_decode(action->body, action->body_length,
                                    &decoded, &consumed);
    if (status != ACTION_FAMILY64_OK) {
        return status;
    }

    memset(&next_result, 0, sizeof(next_result));
    next_result.recognized = 1u;
    next_result.completion_valid = 1u;
    next_result.completed = action->completed_before;
    next_result.phase = action->phase_before;
    memcpy(&next_world, world, sizeof(next_world));
    if (action->eligible == 0u) {
        memcpy(&next_result.world, &next_world, sizeof(next_world));
        memcpy(result, &next_result, sizeof(next_result));
        return ACTION_FAMILY64_OK;
    }

    switch (decoded.operation) {
    case 1u:
        next_world.clock_value_585d51 = decoded.value_1;
        next_world.clock_value_585d4f = decoded.value_2;
        break;
    case 2u:
        next_world.clock_value_585d51 = add_i16_wrapping(
            next_world.clock_value_585d51, decoded.value_1);
        next_world.clock_value_585d4f = add_i16_wrapping(
            next_world.clock_value_585d4f, decoded.value_2);
        break;
    case 3u:
        if (next_world.timer_controller_active_001c != 0u) {
            status = read_tick(backend, &tick);
            if (status != ACTION_FAMILY64_OK) {
                return status;
            }
            next_world.timer_controller_tick_0456 = tick - UINT32_C(5);
        }
        next_world.timer_controller_flag_0326_0061c6ad = 1u;
        break;
    case 4u:
        next_world.timer_controller_flag_0326_0061c6ad = 0u;
        break;
    case 5u:
        next_world.timer_controller_flag_0326_0061c6ad = 0u;
        next_world.clock_value_585d51 = decoded.value_1;
        next_world.clock_value_585d4f = decoded.value_2;
        break;
    case 6u:
        next_world.timer_controller_flag_0326_0061c6ad = 0u;
        next_world.clock_value_585d51 = add_i16_wrapping(
            next_world.clock_value_585d51, decoded.value_1);
        next_world.clock_value_585d4f = add_i16_wrapping(
            next_world.clock_value_585d4f, decoded.value_2);
        break;
    default:
        /* The original switch has no default state edit, but continues below. */
        break;
    }

    next_world.clock_total_585d4b =
        (int32_t)next_world.clock_value_585d51 * INT32_C(60) +
        (int32_t)next_world.clock_value_585d4f;
    status = read_tick(backend, &tick);
    if (status != ACTION_FAMILY64_OK) {
        return status;
    }
    next_world.clock_deadline_585d55 =
        tick + (uint32_t)(int32_t)next_world.deadline_offset_5b0280;

    if (action->subtype == 1u) {
        next_result.completed = 1u;
    } else if (action->subtype == 2u) {
        next_result.completed = 0u;
        next_result.reset_dependencies = 1u;
    }
    next_result.applied = 1u;
    next_result.phase = 0u;
    memcpy(&next_result.world, &next_world, sizeof(next_world));
    memcpy(result, &next_result, sizeof(next_result));
    return ACTION_FAMILY64_OK;
}

const char *action_family64_status_string(int status)
{
    switch (status) {
    case ACTION_FAMILY64_OK:
        return "ok";
    case ACTION_FAMILY64_ERR_ARGUMENT:
        return "invalid argument";
    case ACTION_FAMILY64_ERR_BODY:
        return "invalid 0x64 body";
    case ACTION_FAMILY64_ERR_UNSUPPORTED:
        return "unsupported action type";
    case ACTION_FAMILY64_ERR_BACKEND:
        return "tick-count backend failed";
    default:
        return "unknown action-family 0x64 status";
    }
}
