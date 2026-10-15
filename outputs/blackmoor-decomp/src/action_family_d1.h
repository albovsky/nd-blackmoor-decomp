#ifndef BLACKMOOR_ACTION_FAMILY_D1_H
#define BLACKMOOR_ACTION_FAMILY_D1_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_D1_RAW_TYPE UINT8_C(0xD1)
#define ACTION_FAMILY_D1_RUNTIME_TYPE UINT8_C(0xD1)
#define ACTION_FAMILY_D1_BODY_BYTES 927u
#define ACTION_FAMILY_D1_OBJECT_BYTES 927u
#define ACTION_FAMILY_D1_WORD_COUNT 463u
#define ACTION_FAMILY_D1_DEPENDENCY_BYTES 16u

/* Native validation results, not the original constructor's return value. */
typedef enum {
    ACTION_FAMILY_D1_OK = 0,
    ACTION_FAMILY_D1_ERR_ARGUMENT = 1,
    ACTION_FAMILY_D1_ERR_BODY = 2,
    ACTION_FAMILY_D1_ERR_TAIL = 3,
    ACTION_FAMILY_D1_ERR_BOUNDS = 4,
    ACTION_FAMILY_D1_ERR_OVERLAP = 5
} ActionFamilyD1Status;

/* Fixed 927-byte copy, without a count, NUL scan or value guard in the
 * original constructor. word_N[N] retains the LE pair at raw+2*N; option_39e
 * retains the last byte. These are neutral storage units, not recovered field
 * types or gameplay semantics. All 16-bit patterns are valid constructor data.
 * dependency_records borrows input storage, including one-past for empty tails. */
typedef struct {
    uint16_t word_N[ACTION_FAMILY_D1_WORD_COUNT];
    uint8_t option_39e;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t available_body_bytes;
    size_t body_bytes;
    size_t dependency_bytes;
    uint8_t raw_type;
    uint8_t runtime_type;
} ActionFamilyD1Decoded;

/* Value model of FUN_004b5c5c's complete 927-byte allocation and cursor
 * effects. The original writes the allocation address only to *param_1;
 * ECX's owner object is untouched. Handles are opaque caller values, not
 * native pointers. No allocation or dependency evaluation occurs here. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_D1_OBJECT_BYTES];
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
    uint8_t raw_type;
    uint8_t runtime_type;
} ActionFamilyD1Constructed;

/* Mapped readable input and writable output storage are caller contracts. Null,
 * wrapped spans, overlapping spans, short bodies and fractional dependency
 * records fail before any input read or output mutation. */
ActionFamilyD1Status action_family_d1_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamilyD1Decoded *out);

/* output_handle must be nonzero. Payload offset addition wraps modulo 2^32
 * as in the original x86 DWORD add. Invalid input leaves out unchanged. */
ActionFamilyD1Status action_family_d1_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamilyD1Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
