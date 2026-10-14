#ifndef BLACKMOOR_ACTION_FAMILY_79_H
#define BLACKMOOR_ACTION_FAMILY_79_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_79_RAW_TYPE UINT8_C(0x79)
#define ACTION_FAMILY_79_RUNTIME_TYPE UINT8_C(0x79)
#define ACTION_FAMILY_79_BODY_BYTES 2u
#define ACTION_FAMILY_79_OBJECT_BYTES 2u
#define ACTION_FAMILY_79_DEPENDENCY_BYTES 16u

/* Native validation results, not the original constructor's return value. */
typedef enum {
    ACTION_FAMILY_79_OK = 0,
    ACTION_FAMILY_79_ERR_ARGUMENT = 1,
    ACTION_FAMILY_79_ERR_BODY = 2,
    ACTION_FAMILY_79_ERR_TAIL = 3,
    ACTION_FAMILY_79_ERR_BOUNDS = 4,
    ACTION_FAMILY_79_ERR_OVERLAP = 5
} ActionFamily79Status;

/* One uninterpreted LE word, not a count. All 16-bit patterns are retained.
 * dependency_records is borrowed; its lifetime is the input's lifetime.
 * An empty tail points one past the fixed body. */
typedef struct {
    uint16_t word_0;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t available_body_bytes;
    size_t body_bytes;
    size_t dependency_bytes;
} ActionFamily79Decoded;

/* Value model of FUN_004e9add's complete two-byte allocation and cursor
 * effects. Original writes the allocation address only to *param_1; ECX's
 * owner object is untouched. Handles below are opaque caller values, not
 * native pointers. No allocation or dependency evaluation occurs here. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_79_OBJECT_BYTES];
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
} ActionFamily79Constructed;

/* Readable input and writable output storage are caller contracts. Null,
 * wrapped spans, overlapping spans, short bodies and fractional dependency
 * records fail before any input read or output mutation. */
ActionFamily79Status action_family_79_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily79Decoded *out);

/* output_handle must be nonzero. Payload offset addition wraps modulo 2^32
 * as in the original x86 DWORD add. Invalid input leaves out unchanged. */
ActionFamily79Status action_family_79_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily79Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
