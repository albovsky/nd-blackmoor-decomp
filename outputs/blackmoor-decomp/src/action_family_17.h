#ifndef BLACKMOOR_ACTION_FAMILY_17_H
#define BLACKMOOR_ACTION_FAMILY_17_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_17_RAW_TYPE 0x17u
#define ACTION_FAMILY_17_RUNTIME_TYPE 0x17u
#define ACTION_FAMILY_17_PREFIX_BYTES 22u
#define ACTION_FAMILY_17_RECORD_BYTES 18u
#define ACTION_FAMILY_17_DEPENDENCY_BYTES 16u
#define ACTION_FAMILY_17_MAX_COUNT 1819u
#define ACTION_FAMILY_17_MAX_BODY_BYTES 32764u

/* Native safety results, not original x86 return values. */
typedef enum {
    ACTION_FAMILY_17_OK = 0,
    ACTION_FAMILY_17_ERR_ARGUMENT = 1,
    ACTION_FAMILY_17_ERR_BODY = 2,
    ACTION_FAMILY_17_ERR_COUNT = 3,
    ACTION_FAMILY_17_ERR_TAIL = 4,
    ACTION_FAMILY_17_ERR_BOUNDS = 5,
    ACTION_FAMILY_17_ERR_OVERLAP = 6,
    ACTION_FAMILY_17_ERR_CAPACITY = 7
} ActionFamily17Status;

typedef struct {
    /* Neutral word_N at body + 2*N; semantics/signedness unproven. */
    uint16_t words[10];
    int16_t count;
    const uint8_t *records;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t available_body_bytes;
    size_t body_bytes;
    uint8_t raw_type;
    uint8_t runtime_type;
} ActionFamily17Decoded;

typedef struct {
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t available_body_bytes;
    size_t body_bytes_consumed;
    size_t allocation_bytes;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    /* Opaque original x86 allocation identity, never a native pointer. */
    uint32_t result_slot_handle;
    uint8_t raw_type;
    uint8_t runtime_type;
} ActionFamily17Constructed;

/* raw_body starts after the ACT's 50-byte header and includes the tail.
 * Views borrow readable caller storage. All output spans must be writable and
 * disjoint from input and from each other. Address checks detect integer wrap,
 * not arbitrary-pointer mappedness. Every failure leaves all outputs unchanged.
 * The original narrows 22+18*LE_i16(body+20) to signed int16 before malloc/copy.
 * This API deliberately rejects negative counts and any size narrowing: only
 * 0..1819 is accepted. Wrapped positive sizes do not describe complete records.
 * No string/name check applies to this binary prefix. */
ActionFamily17Status action_family_17_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily17Decoded *out);
ActionFamily17Status action_family_17_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out);

/* Value model of the inline allocation/copy at 0x40b98f..0x40baf8.
 * Writes exactly body_bytes; excess capacity is preserved. The original copies
 * the entire typed body without zeroing or field changes. No allocator, runtime
 * lifecycle or host effect is implemented. Offset advance wraps as a DWORD. */
ActionFamily17Status action_family_17_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    uint8_t *object_bytes, size_t object_capacity, ActionFamily17Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
