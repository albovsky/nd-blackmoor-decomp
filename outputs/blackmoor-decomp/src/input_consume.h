#ifndef BLACKMOOR_INPUT_CONSUME_H
#define BLACKMOOR_INPUT_CONSUME_H

#include <stdint.h>

#include "input_latch.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum InputConsumeStatus {
    INPUT_CONSUME_OK = 0,
    INPUT_CONSUME_INVALID_STATE_VIEW = 1,
    INPUT_CONSUME_STATE_VIEW_TOO_SHORT = 2,
    INPUT_CONSUME_INVALID_RESULT_POINTER = 3,
    INPUT_CONSUME_RESULT_ALIASES_INPUT = 4
} InputConsumeStatus;

/*
 * Native adapter status is independent of the original method's raw EAX value.
 * On success, out_raw_return receives the original 32-bit 0/1 return.
 *
 * `state` borrows the existing input-latch byte view. Its data and the view
 * descriptor may overlap: implementations snapshot bytes/length before any
 * original-layout write. The result pointer must designate four writable
 * bytes and must not overlap either the declared state span or the view
 * descriptor. Such overlaps and address-span overflow are rejected before
 * any original-layout state mutation; the output remains unchanged on error.
 */
InputConsumeStatus input_consume_field0(
    const InputLatchStateView *state,
    uint32_t *out_raw_return);
InputConsumeStatus input_consume_field4(
    const InputLatchStateView *state,
    uint32_t *out_raw_return);

#ifdef __cplusplus
}
#endif

#endif
