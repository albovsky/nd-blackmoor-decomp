#include "input_latch.h"

#include <string.h>

enum {
    INPUT_LATCH_MOVE_STATE_BYTES = 0x20,
    INPUT_LATCH_EVENT_STATE_BYTES = 0x14,
    INPUT_LATCH_POINT_BYTES = 8,
    INPUT_LATCH_FIELD_00 = 0x00,
    INPUT_LATCH_FIELD_08 = 0x08,
    INPUT_LATCH_FIELD_0C = 0x0c,
    INPUT_LATCH_FIELD_10 = 0x10,
    INPUT_LATCH_MOVE_X = 0x18,
    INPUT_LATCH_MOVE_Y = 0x1c
};

static InputLatchStatus check_state_view(
    const InputLatchStateView *state,
    size_t required_bytes)
{
    if (state == NULL || state->bytes == NULL) {
        return INPUT_LATCH_INVALID_STATE_VIEW;
    }
    if (state->length < required_bytes) {
        return INPUT_LATCH_STATE_VIEW_TOO_SHORT;
    }
    return INPUT_LATCH_OK;
}

static uint32_t read_word(const uint8_t *address)
{
    uint32_t value;
    memcpy(&value, address, sizeof(value));
    return value;
}

static void write_word(uint8_t *address, uint32_t value)
{
    memcpy(address, &value, sizeof(value));
}

InputLatchStatus input_latch_move(
    const InputLatchStateView *state,
    uint32_t ignored_callback_argument,
    const InputLatchPointView *point)
{
    InputLatchStatus status = check_state_view(state, INPUT_LATCH_MOVE_STATE_BYTES);
    uint32_t x;

    (void)ignored_callback_argument;
    if (status != INPUT_LATCH_OK) {
        return status;
    }
    if (point == NULL || point->bytes == NULL) {
        return INPUT_LATCH_INVALID_POINT_VIEW;
    }
    if (point->length < INPUT_LATCH_POINT_BYTES) {
        return INPUT_LATCH_POINT_VIEW_TOO_SHORT;
    }

    /* Keep the original order: the second point word is read after the first store. */
    x = read_word(point->bytes);
    write_word(state->bytes + INPUT_LATCH_MOVE_X, x);
    write_word(state->bytes + INPUT_LATCH_MOVE_Y, read_word(point->bytes + sizeof(uint32_t)));
    return INPUT_LATCH_OK;
}

InputLatchStatus input_latch_down(
    const InputLatchStateView *state,
    uint32_t ignored_callback_argument_0,
    uint32_t ignored_callback_argument_1)
{
    InputLatchStatus status = check_state_view(state, INPUT_LATCH_EVENT_STATE_BYTES);

    (void)ignored_callback_argument_0;
    (void)ignored_callback_argument_1;
    if (status != INPUT_LATCH_OK) {
        return status;
    }

    write_word(state->bytes + INPUT_LATCH_FIELD_00, 0);
    write_word(state->bytes + INPUT_LATCH_FIELD_08, 0);
    if (read_word(state->bytes + INPUT_LATCH_FIELD_0C) == 0) {
        write_word(state->bytes + INPUT_LATCH_FIELD_0C, 1);
    }
    write_word(state->bytes + INPUT_LATCH_FIELD_10, 0);
    return INPUT_LATCH_OK;
}

InputLatchStatus input_latch_up(
    const InputLatchStateView *state,
    uint32_t ignored_callback_argument_0,
    uint32_t ignored_callback_argument_1,
    uint32_t raw_global_5c39e5)
{
    InputLatchStatus status = check_state_view(state, INPUT_LATCH_EVENT_STATE_BYTES);

    (void)ignored_callback_argument_0;
    (void)ignored_callback_argument_1;
    if (status != INPUT_LATCH_OK) {
        return status;
    }

    if (read_word(state->bytes + INPUT_LATCH_FIELD_08) != 0) {
        return INPUT_LATCH_OK;
    }
    if (raw_global_5c39e5 != UINT32_MAX &&
        read_word(state->bytes + INPUT_LATCH_FIELD_00) == 0) {
        write_word(state->bytes + INPUT_LATCH_FIELD_00, 1);
    }
    if (read_word(state->bytes + INPUT_LATCH_FIELD_0C) == 1) {
        write_word(state->bytes + INPUT_LATCH_FIELD_0C, 2);
    }
    write_word(state->bytes + INPUT_LATCH_FIELD_10, 0);
    return INPUT_LATCH_OK;
}
