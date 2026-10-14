#ifndef BLACKMOOR_ACTION_FAMILY_94_H
#define BLACKMOOR_ACTION_FAMILY_94_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_94_RAW_TYPE UINT8_C(0x94)
#define ACTION_FAMILY_94_RUNTIME_TYPE UINT8_C(0x94)
#define ACTION_FAMILY_94_BODY_BYTES 50u
#define ACTION_FAMILY_94_OBJECT_BYTES 50u
#define ACTION_FAMILY_94_DEPENDENCY_BYTES 16u

/* Native safety results, not inferred return values of the original loader. */
typedef enum {
    ACTION_FAMILY_94_OK = 0,
    ACTION_FAMILY_94_ERR_ARGUMENT = 1,
    ACTION_FAMILY_94_ERR_BODY = 2,
    ACTION_FAMILY_94_ERR_TAIL = 3,
    ACTION_FAMILY_94_ERR_BOUNDS = 4,
    ACTION_FAMILY_94_ERR_OVERLAP = 5
} ActionFamily94Status;

/* Original arm 0x40ea5e copies all 50 bytes without interpreting them.
 * Neutral offsets are hexadecimal. word_N retains all 32-bit LE patterns;
 * runtime signed comparisons/semantics are outside this decoder. There is
 * no body count, NUL requirement, or restriction on option values here.
 * dependency_records is borrowed and shares the input's lifetime; an empty
 * tail points one past the fixed body. This native struct is not x86 layout. */
typedef struct {
    uint8_t option_00[33];
    uint32_t word_21;
    uint32_t word_25;
    uint32_t word_29;
    uint32_t word_2d;
    uint8_t option_31;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes;
    size_t available_body_bytes;
} ActionFamily94Decoded;

/* Value model of the inline malloc/copy/slot/cursor effects, not an original
 * C++ class. No separate constructor, owner links or state defaults occur
 * in this arm. output_handle is an opaque caller token, never dereferenced.
 * No allocation, dependency evaluation or runtime behavior occurs here. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_94_OBJECT_BYTES];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes_consumed;
    size_t available_body_bytes;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    uint32_t result_slot_handle;
    uint32_t allocation_bytes;
    uint8_t raw_type;
    uint8_t runtime_type;
} ActionFamily94Constructed;

/* Caller supplies readable input and writable output spans. Null/wrapped/
 * overlapping spans, short bodies and fractional tails fail before any
 * input read or output mutation. Arbitrary pointer mappedness is a caller
 * contract. Decode and construction leave input unchanged. */
ActionFamily94Status action_family_94_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily94Decoded *out);

/* output_handle must be nonzero. The consumed offset wraps modulo 2^32,
 * matching the original x86 DWORD add. Invalid inputs leave out unchanged. */
ActionFamily94Status action_family_94_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily94Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
