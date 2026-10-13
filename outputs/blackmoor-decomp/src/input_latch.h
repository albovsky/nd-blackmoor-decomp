#ifndef BLACKMOOR_INPUT_LATCH_H
#define BLACKMOOR_INPUT_LATCH_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct InputLatchStateView {
    uint8_t *bytes;
    size_t length;
} InputLatchStateView;

typedef struct InputLatchPointView {
    const uint8_t *bytes;
    size_t length;
} InputLatchPointView;

typedef enum InputLatchStatus {
    INPUT_LATCH_OK = 0,
    INPUT_LATCH_INVALID_STATE_VIEW = 1,
    INPUT_LATCH_STATE_VIEW_TOO_SHORT = 2,
    INPUT_LATCH_INVALID_POINT_VIEW = 3,
    INPUT_LATCH_POINT_VIEW_TOO_SHORT = 4
} InputLatchStatus;

/* These are native adapter results. The original methods have no status return. */
InputLatchStatus input_latch_move(
    const InputLatchStateView *state,
    uint32_t ignored_callback_argument,
    const InputLatchPointView *point);
InputLatchStatus input_latch_down(
    const InputLatchStateView *state,
    uint32_t ignored_callback_argument_0,
    uint32_t ignored_callback_argument_1);
InputLatchStatus input_latch_up(
    const InputLatchStateView *state,
    uint32_t ignored_callback_argument_0,
    uint32_t ignored_callback_argument_1,
    uint32_t raw_global_5c39e5);

#ifdef __cplusplus
}
#endif

#endif
