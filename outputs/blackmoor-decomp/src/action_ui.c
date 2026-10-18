#include "action_ui.h"

#include <string.h>

enum {
    ACTION_TYPE_PHONE = 0x82,
    ACTION_TYPE_CONTROL = 0x1d,
    CONTROL_IMMEDIATE_UI_CODE = 1,
    CONTROL_SPECIAL_ENABLE = 9995,
    CONTROL_SPECIAL_DISABLE = 9996,
    CONTROL_SPECIAL_STATE_2 = 9997,
    CONTROL_SPECIAL_STATE_0 = 9998
};

_Static_assert(sizeof(ActionUIControlGroup) == 0x1a4u,
               "original control-group layout must remain 0x1a4 bytes");

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

static int phone_table_is_valid(const ActionUIWorld *world)
{
    size_t row;
    if (world == NULL || world->phone_count > world->phone_capacity ||
        (world->phone_capacity != 0u && world->phone_records == NULL)) {
        return 0;
    }
    for (row = 0u; row < world->phone_count; ++row) {
        if (memchr(world->phone_records[row] + ACTION_UI_PHONE_NAME_OFFSET,
                   '\0', ACTION_UI_PHONE_NAME_SIZE) == NULL) {
            return 0;
        }
    }
    return 1;
}

static uint8_t normalize_ascii(uint8_t value)
{
    if (value >= (uint8_t)'a' && value <= (uint8_t)'z') {
        return (uint8_t)(value - (uint8_t)'a' + (uint8_t)'A');
    }
    return value;
}

/* The original sorter only consults the normalized comparison to decide
 * whether a pair may be ordered. If normalized names differ, it then compares
 * normalized signed characters. Equal normalized names retain their current
 * order. Keep this unusual, stable adjacent-swap behavior instead of qsort. */
static int phone_names_should_swap(const uint8_t *left, const uint8_t *right)
{
    size_t index;
    int normalized_differ = 0;
    uint8_t normalized_left[ACTION_UI_PHONE_NAME_SIZE];
    uint8_t normalized_right[ACTION_UI_PHONE_NAME_SIZE];
    for (index = 0u; index < ACTION_UI_PHONE_NAME_SIZE; ++index) {
        normalized_left[index] = normalize_ascii(left[index]);
        normalized_right[index] = normalize_ascii(right[index]);
        if (normalized_left[index] != normalized_right[index]) {
            normalized_differ = 1;
            break;
        } else if (left[index] == 0u) {
            return 0;
        }
    }
    if (!normalized_differ) {
        return 0;
    }

    for (index = 0u; index < ACTION_UI_PHONE_NAME_SIZE; ++index) {
        int left_char = (normalized_left[index] < 0x80u)
                            ? (int)normalized_left[index]
                            : (int)normalized_left[index] - 0x100;
        int right_char = (normalized_right[index] < 0x80u)
                             ? (int)normalized_right[index]
                             : (int)normalized_right[index] - 0x100;
        if (right_char < left_char) {
            return 1;
        }
        if (left_char < right_char || normalized_left[index] == 0u) {
            return 0;
        }
    }
    return 0;
}

static void sort_phone_records(ActionUIWorld *world)
{
    int swapped;
    do {
        size_t row;
        swapped = 0;
        for (row = 0u; row + 1u < world->phone_count; ++row) {
            if (phone_names_should_swap(
                    world->phone_records[row] + ACTION_UI_PHONE_NAME_OFFSET,
                    world->phone_records[row + 1u] + ACTION_UI_PHONE_NAME_OFFSET)) {
                uint8_t temporary[ACTION_UI_PHONE_RECORD_SIZE];
                memcpy(temporary, world->phone_records[row], sizeof(temporary));
                memcpy(world->phone_records[row], world->phone_records[row + 1u],
                       ACTION_UI_PHONE_RECORD_SIZE);
                memcpy(world->phone_records[row + 1u], temporary,
                       ACTION_UI_PHONE_RECORD_SIZE);
                swapped = 1;
                /* Original 0x4e3ade keeps walking the pass after a swap but
                 * cannot swap again (its flag is set); stopping here and
                 * restarting from row zero gives the same final order. */
                break;
            }
        }
    } while (swapped != 0);
}

/* Original GAME.EXE 0x4e1a7e (control initialiser; function-ledger review FL-8). */
int action_ui_initialize_controls(ActionUIWorld *world)
{
    size_t group;
    if (world == NULL) {
        return ACTION_UI_ERR_ARGUMENT;
    }
    for (group = 0u; group < ACTION_UI_CONTROL_GROUP_COUNT; ++group) {
        size_t entry;
        ActionUIControlGroup *control = &world->controls[group];
        control->state = 0;
        control->availability = 0;
        control->flags[0] = 0;
        control->flags[1] = 0;
        control->flags[2] = 0;
        for (entry = 0u; entry < ACTION_UI_CONTROL_RANGE_COUNT; ++entry) {
            control->starts[entry] = ACTION_UI_CONTROL_EMPTY_SENTINEL;
            control->ends[entry] = ACTION_UI_CONTROL_EMPTY_SENTINEL;
            control->codes[entry] = 13;
        }
    }
    return ACTION_UI_OK;
}

int action_ui_initialize_phone(ActionUIWorld *world,
                                const uint8_t (*records)[ACTION_UI_PHONE_RECORD_SIZE],
                                size_t count)
{
    size_t row;
    if (world == NULL || (count != 0u && records == NULL) ||
        (world->phone_capacity != 0u && world->phone_records == NULL)) {
        return ACTION_UI_ERR_ARGUMENT;
    }
    if (world->nls_mode != 0u) {
        return ACTION_UI_ERR_UNSUPPORTED;
    }
    if (count > world->phone_capacity || count > SIZE_MAX / ACTION_UI_PHONE_RECORD_SIZE) {
        return ACTION_UI_ERR_PHONE_CAPACITY;
    }
    for (row = 0u; row < count; ++row) {
        if (memchr(records[row] + ACTION_UI_PHONE_NAME_OFFSET, '\0',
                   ACTION_UI_PHONE_NAME_SIZE) == NULL) {
            return ACTION_UI_ERR_BODY;
        }
    }
    if (count != 0u) {
        memmove(world->phone_records, records, count * ACTION_UI_PHONE_RECORD_SIZE);
    }
    world->phone_count = count;
    sort_phone_records(world);
    return ACTION_UI_OK;
}

/* FL-12: original FUN_004e7253 is inlined in this function (function ledger acceptance). */
int action_ui_apply_phone(ActionUIWorld *world,
                          const uint8_t *body,
                          size_t body_length)
{
    size_t row;
    size_t target;
    int found = 0;

    if (world == NULL || body == NULL) {
        return ACTION_UI_ERR_ARGUMENT;
    }
    if (body_length != ACTION_UI_PHONE_RECORD_SIZE ||
        memchr(body + ACTION_UI_PHONE_NAME_OFFSET, '\0',
               ACTION_UI_PHONE_NAME_SIZE) == NULL) {
        return ACTION_UI_ERR_BODY;
    }
    if (world->nls_mode != 0u) {
        return ACTION_UI_ERR_UNSUPPORTED;
    }
    if (!phone_table_is_valid(world)) {
        return ACTION_UI_ERR_ARGUMENT;
    }

    target = world->phone_count;
    for (row = 0u; row < world->phone_count; ++row) {
        if (memcmp(world->phone_records[row] + ACTION_UI_PHONE_KEY_OFFSET,
                   body + ACTION_UI_PHONE_KEY_OFFSET,
                   ACTION_UI_PHONE_KEY_SIZE) == 0) {
            target = row;
            found = 1;
            break;
        }
    }
    if (!found && world->phone_count == world->phone_capacity) {
        return ACTION_UI_ERR_PHONE_CAPACITY;
    }

    memcpy(world->phone_records[target], body, ACTION_UI_PHONE_RECORD_SIZE);
    if (!found) {
        ++world->phone_count;
    }
    sort_phone_records(world);
    world->controls[3].availability = 1;
    world->controls[3].flags[0] = 1;
    return ACTION_UI_OK;
}

static int16_t find_first_empty(const ActionUIControlGroup *group)
{
    size_t entry;
    for (entry = 0u; entry < ACTION_UI_CONTROL_RANGE_COUNT; ++entry) {
        if (group->starts[entry] == ACTION_UI_CONTROL_EMPTY_SENTINEL &&
            group->ends[entry] == ACTION_UI_CONTROL_EMPTY_SENTINEL) {
            return (int16_t)entry;
        }
    }
    return -1;
}

static int16_t find_last_pair(const ActionUIControlGroup *group,
                              int16_t start,
                              int16_t end)
{
    size_t entry;
    int16_t found = -1;
    for (entry = 0u; entry < ACTION_UI_CONTROL_RANGE_COUNT; ++entry) {
        if (group->starts[entry] == start && group->ends[entry] == end) {
            found = (int16_t)entry;
        }
    }
    return found;
}

static void shift_ranges_left(ActionUIControlGroup *group, size_t first)
{
    size_t entry;
    /* Original 0x4e13e4 moves only the start array here. The parallel end
     * and code arrays remain at their old positions until the explicit final
     * slot reset/write below. */
    for (entry = first; entry + 1u < ACTION_UI_CONTROL_RANGE_COUNT; ++entry) {
        group->starts[entry] = group->starts[entry + 1u];
    }
}

int action_ui_apply_control(ActionUIWorld *world,
                            const uint8_t *body,
                            size_t body_length)
{
    int16_t group_index;
    uint8_t code;
    uint8_t mode;
    int16_t start;
    int16_t end;
    ActionUIControlGroup *group;
    int16_t empty_index;
    int16_t pair_index;

    if (world == NULL || body == NULL) {
        return ACTION_UI_ERR_ARGUMENT;
    }
    if (body_length != 8u) {
        return ACTION_UI_ERR_BODY;
    }
    group_index = read_i16le(body);
    if (group_index < 0 || (size_t)group_index >= ACTION_UI_CONTROL_GROUP_COUNT) {
        return ACTION_UI_ERR_GROUP_BOUNDS;
    }
    code = body[2];
    mode = body[3];
    start = read_i16le(body + 4u);
    end = read_i16le(body + 6u);
    if (code == CONTROL_IMMEDIATE_UI_CODE) {
        return ACTION_UI_ERR_UNSUPPORTED;
    }

    group = &world->controls[(size_t)group_index];
    if (mode != 0u) {
        if (start == CONTROL_SPECIAL_ENABLE || end == CONTROL_SPECIAL_ENABLE) {
            group->state = 1;
            return ACTION_UI_OK;
        }
        if (group->state == 1 &&
            (start == CONTROL_SPECIAL_DISABLE || end == CONTROL_SPECIAL_DISABLE)) {
            group->state = 0;
            return ACTION_UI_OK;
        }
    } else {
        if (start == CONTROL_SPECIAL_STATE_2 || end == CONTROL_SPECIAL_STATE_2) {
            group->state = 2;
            return ACTION_UI_OK;
        }
        if (group->state == 2 &&
            (start == CONTROL_SPECIAL_STATE_0 || end == CONTROL_SPECIAL_STATE_0)) {
            group->state = 0;
            return ACTION_UI_OK;
        }
    }

    empty_index = find_first_empty(group);
    pair_index = find_last_pair(group, start, end);
    if (mode == 0u) {
        if (pair_index != -1) {
            shift_ranges_left(group, (size_t)pair_index);
            group->starts[ACTION_UI_CONTROL_RANGE_COUNT - 1u] =
                ACTION_UI_CONTROL_EMPTY_SENTINEL;
            group->ends[ACTION_UI_CONTROL_RANGE_COUNT - 1u] =
                ACTION_UI_CONTROL_EMPTY_SENTINEL;
            group->codes[ACTION_UI_CONTROL_RANGE_COUNT - 1u] = 13;
        }
        return ACTION_UI_OK;
    }

    if (pair_index != -1) {
        return ACTION_UI_OK;
    }
    if (empty_index == -1) {
        shift_ranges_left(group, 0u);
        empty_index = (int16_t)(ACTION_UI_CONTROL_RANGE_COUNT - 1u);
    }
    group->starts[(size_t)empty_index] = start;
    group->ends[(size_t)empty_index] = end;
    group->codes[(size_t)empty_index] = (int32_t)code;
    return ACTION_UI_OK;
}

int action_ui_dispatch(ActionUIWorld *world,
                       uint8_t type,
                       uint8_t subtype,
                       const uint8_t *body,
                       size_t body_length,
                       uint32_t phase_before,
                       ActionUIActionResult *result)
{
    int status;
    if (result == NULL) {
        return ACTION_UI_ERR_ARGUMENT;
    }
    memset(result, 0, sizeof(*result));
    result->phase = phase_before;
    (void)subtype;

    if (type == ACTION_TYPE_PHONE) {
        result->recognized = 1u;
        status = action_ui_apply_phone(world, body, body_length);
    } else if (type == ACTION_TYPE_CONTROL) {
        result->recognized = 1u;
        status = action_ui_apply_control(world, body, body_length);
    } else {
        return ACTION_UI_ERR_UNSUPPORTED;
    }
    if (status == ACTION_UI_OK) {
        result->applied = 1u;
        result->completed = 1u;
    }
    return status;
}

const char *action_ui_status_string(int status)
{
    switch (status) {
    case ACTION_UI_OK: return "ok";
    case ACTION_UI_ERR_ARGUMENT: return "invalid action UI state";
    case ACTION_UI_ERR_BODY: return "invalid action UI body";
    case ACTION_UI_ERR_GROUP_BOUNDS: return "control group outside caller state";
    case ACTION_UI_ERR_PHONE_CAPACITY: return "phone table caller capacity exceeded";
    case ACTION_UI_ERR_UNSUPPORTED: return "action UI branch is unsupported";
    default: return "unknown action UI status";
    }
}
