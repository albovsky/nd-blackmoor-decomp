#include "input_consume.h"

#include <stddef.h>
#include <stdint.h>
#include <string.h>

#define INPUT_CONSUME_FIELD0_EXTENT ((size_t)0x10)
#define INPUT_CONSUME_FIELD4_EXTENT ((size_t)0x14)
#define INPUT_CONSUME_RESULT_BYTES sizeof(uint32_t)

static int range_overlaps(uintptr_t left_start, uintptr_t left_end,
                          uintptr_t right_start, uintptr_t right_end)
{
    return left_start < right_end && right_start < left_end;
}

static InputConsumeStatus validate_call(
    const InputLatchStateView *state,
    uint32_t *out_raw_return,
    size_t required_bytes,
    uint8_t **out_bytes)
{
    uint8_t *bytes;
    size_t length;
    uintptr_t state_start;
    uintptr_t state_end;
    uintptr_t result_start;
    uintptr_t result_end;
    uintptr_t descriptor_start;
    uintptr_t descriptor_end;

    if (state == NULL) {
        return INPUT_CONSUME_INVALID_STATE_VIEW;
    }

    /* Snapshot both members before the original-layout state can be changed. */
    bytes = state->bytes;
    length = state->length;
    if (bytes == NULL) {
        return INPUT_CONSUME_INVALID_STATE_VIEW;
    }
    if (length < required_bytes) {
        return INPUT_CONSUME_STATE_VIEW_TOO_SHORT;
    }
    if (out_raw_return == NULL) {
        return INPUT_CONSUME_INVALID_RESULT_POINTER;
    }

    state_start = (uintptr_t)bytes;
    if (length > UINTPTR_MAX - state_start) {
        return INPUT_CONSUME_INVALID_STATE_VIEW;
    }
    state_end = state_start + (uintptr_t)length;

    result_start = (uintptr_t)out_raw_return;
    if (INPUT_CONSUME_RESULT_BYTES > UINTPTR_MAX - result_start) {
        return INPUT_CONSUME_INVALID_RESULT_POINTER;
    }
    result_end = result_start + (uintptr_t)INPUT_CONSUME_RESULT_BYTES;

    descriptor_start = (uintptr_t)state;
    if (sizeof(*state) > UINTPTR_MAX - descriptor_start) {
        return INPUT_CONSUME_INVALID_STATE_VIEW;
    }
    descriptor_end = descriptor_start + (uintptr_t)sizeof(*state);

    if (range_overlaps(result_start, result_end, state_start, state_end) ||
        range_overlaps(result_start, result_end, descriptor_start, descriptor_end)) {
        return INPUT_CONSUME_RESULT_ALIASES_INPUT;
    }

    *out_bytes = bytes;
    return INPUT_CONSUME_OK;
}

static uint32_t read_u32_le(const uint8_t *bytes)
{
    return (uint32_t)bytes[0] |
           ((uint32_t)bytes[1] << 8) |
           ((uint32_t)bytes[2] << 16) |
           ((uint32_t)bytes[3] << 24);
}

static void write_u32_le(uint8_t *bytes, uint32_t value)
{
    bytes[0] = (uint8_t)value;
    bytes[1] = (uint8_t)(value >> 8);
    bytes[2] = (uint8_t)(value >> 16);
    bytes[3] = (uint8_t)(value >> 24);
}

InputConsumeStatus input_consume_field0(
    const InputLatchStateView *state,
    uint32_t *out_raw_return)
{
    uint8_t *bytes;
    InputConsumeStatus status = validate_call(
        state, out_raw_return, INPUT_CONSUME_FIELD0_EXTENT, &bytes);
    uint32_t raw_return;

    if (status != INPUT_CONSUME_OK) {
        return status;
    }

    raw_return = read_u32_le(bytes) != 0 ? 1u : 0u;
    if (raw_return != 0) {
        /* Match the original stores in order: +0 first, then +0x0c. */
        write_u32_le(bytes, 0);
        write_u32_le(bytes + 0x0c, 0);
    }
    memcpy(out_raw_return, &raw_return, sizeof(raw_return));
    return INPUT_CONSUME_OK;
}

/* Original GAME.EXE 0x4daf6e (input consume, field 4; function-ledger review FL-8). */
InputConsumeStatus input_consume_field4(
    const InputLatchStateView *state,
    uint32_t *out_raw_return)
{
    uint8_t *bytes;
    InputConsumeStatus status = validate_call(
        state, out_raw_return, INPUT_CONSUME_FIELD4_EXTENT, &bytes);
    uint32_t raw_return;

    if (status != INPUT_CONSUME_OK) {
        return status;
    }

    raw_return = read_u32_le(bytes + 0x04) != 0 ? 1u : 0u;
    if (raw_return != 0) {
        /* Match the original stores in order: +4 first, then +0x10. */
        write_u32_le(bytes + 0x04, 0);
        write_u32_le(bytes + 0x10, 0);
    }
    memcpy(out_raw_return, &raw_return, sizeof(raw_return));
    return INPUT_CONSUME_OK;
}
