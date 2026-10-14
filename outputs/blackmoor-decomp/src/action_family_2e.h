#ifndef BLACKMOOR_ACTION_FAMILY_2E_H
#define BLACKMOOR_ACTION_FAMILY_2E_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_2E_RAW_TYPE UINT8_C(0x2e)
#define ACTION_FAMILY_2E_RUNTIME_TYPE UINT8_C(0x2e)
#define ACTION_FAMILY_2E_BODY_BYTES 15u
#define ACTION_FAMILY_2E_OBJECT_BYTES 15u
#define ACTION_FAMILY_2E_DEPENDENCY_BYTES 16u

/* Native validation results, not the original constructor's return value. */
typedef enum {
    ACTION_FAMILY_2E_OK = 0,
    ACTION_FAMILY_2E_ERR_ARGUMENT = 1,
    ACTION_FAMILY_2E_ERR_BODY = 2,
    ACTION_FAMILY_2E_ERR_TAIL = 3,
    ACTION_FAMILY_2E_ERR_BOUNDS = 4,
    ACTION_FAMILY_2E_ERR_OVERLAP = 5
} ActionFamily2eStatus;

/* The leading byte and seven neutral LE words at offsets 1,3,...,13.
 * No body count exists.
 * The unsigned values retain bits; runtime interpretation is a follow-up.
 * dependency_records is borrowed; its lifetime is the input's lifetime.
 * An empty tail points one past the fixed body. */
typedef struct {
    uint8_t option_00;
    uint16_t word[7];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t available_body_bytes;
    size_t body_bytes;
    size_t dependency_bytes;
} ActionFamily2eDecoded;

/* Value model of FUN_004cd645 / FUN_004cf1e4's complete 15-byte
 * allocation and cursor effects. Original writes its address to *param_1;
 * ECX's owner object is untouched on this successful path. Handles are opaque
 * caller values, not native pointers. No allocation or dependency evaluation
 * occurs here. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_2E_OBJECT_BYTES];
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
} ActionFamily2eConstructed;

/* Readable input and writable output storage are caller contracts. Null,
 * wrapped spans, overlapping spans, short bodies and fractional dependency
 * records fail before any input read or output mutation. */
ActionFamily2eStatus action_family_2e_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily2eDecoded *out);

/* output_handle must be nonzero. Payload offset addition wraps modulo 2^32
 * as in the original x86 DWORD add. Invalid input leaves out unchanged. */
ActionFamily2eStatus action_family_2e_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily2eConstructed *out);

#ifdef __cplusplus
}
#endif
#endif
