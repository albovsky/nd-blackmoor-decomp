#ifndef BLACKMOOR_ACTION_FAMILY_69_H
#define BLACKMOOR_ACTION_FAMILY_69_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_69_RAW_TYPE UINT8_C(0x69)
#define ACTION_FAMILY_69_RUNTIME_TYPE UINT8_C(0x69)
#define ACTION_FAMILY_69_BODY_BYTES 1u
#define ACTION_FAMILY_69_OBJECT_BYTES 1u
#define ACTION_FAMILY_69_DEPENDENCY_BYTES 16u

/* Native validation results, not the original constructor's return value. */
typedef enum {
    ACTION_FAMILY_69_OK = 0,
    ACTION_FAMILY_69_ERR_ARGUMENT = 1,
    ACTION_FAMILY_69_ERR_BODY = 2,
    ACTION_FAMILY_69_ERR_TAIL = 3,
    ACTION_FAMILY_69_ERR_BOUNDS = 4,
    ACTION_FAMILY_69_ERR_OVERLAP = 5
} ActionFamily69Status;

/* One uninterpreted byte, not a count. All 8-bit patterns are retained.
 * dependency_records is borrowed; its lifetime is the input's lifetime.
 * An empty tail points one past the fixed body. */
typedef struct {
    uint8_t option_00;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t available_body_bytes;
    size_t body_bytes;
    size_t dependency_bytes;
} ActionFamily69Decoded;

/* Value model of inline loader arm 0x40d428's complete one-byte allocation
 * and cursor effects. Original writes the allocation address to the action's
 * data slot (+0x32); there is no separate constructor function or owner
 * link. Handles below are opaque caller values, not native pointers. No allocation or dependency evaluation occurs here. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_69_OBJECT_BYTES];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t available_body_bytes;
    size_t body_bytes_consumed;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    uint32_t output_handle;
    uint32_t result_slot_handle;
    uint32_t output_allocation_bytes;
} ActionFamily69Constructed;

/* Readable input and writable output storage are caller contracts. Null,
 * wrapped spans, overlapping spans, short bodies and fractional dependency
 * records fail before any input read or output mutation. */
ActionFamily69Status action_family_69_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily69Decoded *out);

/* Validates the entire span, including the tail; writes one on success. */
ActionFamily69Status action_family_69_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out);

/* output_handle must be nonzero. Payload offset addition wraps modulo 2^32
 * as in the original x86 DWORD add. Invalid input leaves out unchanged. */
ActionFamily69Status action_family_69_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily69Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
