#ifndef BLACKMOOR_ACTION_FAMILY_4E_H
#define BLACKMOOR_ACTION_FAMILY_4E_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_4E_RAW_TYPE UINT8_C(0x4e)
#define ACTION_FAMILY_4E_RUNTIME_TYPE UINT8_C(0x4e)
#define ACTION_FAMILY_4E_BODY_BYTES 31u
#define ACTION_FAMILY_4E_OBJECT_BYTES 31u
#define ACTION_FAMILY_4E_ENTRY_COUNT 10u
#define ACTION_FAMILY_4E_DEPENDENCY_BYTES 16u

/* Native safety results, not original constructor return values. */
typedef enum {
    ACTION_FAMILY_4E_OK = 0,
    ACTION_FAMILY_4E_ERR_ARGUMENT = 1,
    ACTION_FAMILY_4E_ERR_BODY = 2,
    ACTION_FAMILY_4E_ERR_TAIL = 3,
    ACTION_FAMILY_4E_ERR_BOUNDS = 4,
    ACTION_FAMILY_4E_ERR_OVERLAP = 5
} ActionFamily4EStatus;

/* Neutral fields at entry-relative +0 and +1. The runtime reads word_0 as
 * signed; this decoder preserves its unsigned 16-bit representation only. */
typedef struct {
    uint8_t option_00;
    uint16_t word_0;
} ActionFamily4EEntry;

/* Leading byte at body+0; ten fixed triples at body+1+3*i. No body count,
 * string or index validation exists in the original constructor. All byte
 * and word patterns are retained; runtime validity/effects are out of scope.
 * dependency_records is borrowed, including one-past-body for empty tails. */
typedef struct {
    uint8_t option_00;
    ActionFamily4EEntry entries[ACTION_FAMILY_4E_ENTRY_COUNT];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t available_body_bytes;
    size_t body_bytes;
    size_t dependency_bytes;
} ActionFamily4EDecoded;

/* Value model of FUN_0044b102's complete 31-byte allocation, *param_1 slot
 * and cursor effects. ECX's owner is untouched in the successful constructor.
 * Handles are caller-supplied opaque x86 values, never native pointers. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_4E_OBJECT_BYTES];
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
} ActionFamily4EConstructed;

/* Caller provides readable input and writable output. Null, wrapped spans,
 * overlap, short bodies and fractional tails fail before output mutation.
 * No allocation, dependency construction or runtime arithmetic occurs. */
ActionFamily4EStatus action_family_4e_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out_body_length);
ActionFamily4EStatus action_family_4e_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily4EDecoded *out);

/* output_handle must be nonzero. Offset addition wraps modulo 2^32 as in
 * original x86; invalid input leaves out unchanged. */
ActionFamily4EStatus action_family_4e_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily4EConstructed *out);

#ifdef __cplusplus
}
#endif
#endif
