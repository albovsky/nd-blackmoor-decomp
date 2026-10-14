#ifndef BLACKMOOR_ACTION_FAMILY_35_H
#define BLACKMOOR_ACTION_FAMILY_35_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_35_RAW_TYPE 0x35u
#define ACTION_FAMILY_35_RUNTIME_TYPE 0x35u
#define ACTION_FAMILY_35_PREFIX_BYTES 61u
#define ACTION_FAMILY_35_RECORD6_BYTES 6u
#define ACTION_FAMILY_35_RECORD34_BYTES 34u
#define ACTION_FAMILY_35_DEPENDENCY_BYTES 16u
#define ACTION_FAMILY_35_MAX_COUNT 32767u
#define ACTION_FAMILY_35_MAX_BODY_BYTES (63u + 40u * ACTION_FAMILY_35_MAX_COUNT)

/* Native safety results, not original function return values. */
typedef enum ActionFamily35Status {
    ACTION_FAMILY_35_OK = 0,
    ACTION_FAMILY_35_ERR_ARGUMENT = 1,
    ACTION_FAMILY_35_ERR_BODY = 2,
    ACTION_FAMILY_35_ERR_COUNT = 3,
    ACTION_FAMILY_35_ERR_TAIL = 4,
    ACTION_FAMILY_35_ERR_BOUNDS = 5,
    ACTION_FAMILY_35_ERR_OVERLAP = 6,
    ACTION_FAMILY_35_ERR_CAPACITY = 7,
    ACTION_FAMILY_35_ERR_INDEX = 8
} ActionFamily35Status;

typedef struct ActionFamily35Decoded {
    /* Exact bytes, including any bytes after NUL. This is not a C string. */
    uint8_t name[33];
    /* Neutral word_N: raw +0x21 + 2*N. Semantics remain unverified. */
    uint16_t words[13];
    int16_t count_6;
    int16_t count_34;
    const uint8_t *records_6;
    const uint8_t *records_34;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t available_body_bytes;
    size_t body_bytes;
    uint8_t raw_type;
    uint8_t runtime_type;
} ActionFamily35Decoded;

/* Each record is exposed as neutral little-endian word_N fields. */
typedef struct ActionFamily35Record6 { uint16_t words[3]; } ActionFamily35Record6;
typedef struct ActionFamily35Record34 { uint16_t words[17]; } ActionFamily35Record34;

typedef struct ActionFamily35Constructed {
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t available_body_bytes;
    size_t body_bytes_consumed;
    size_t allocation_bytes;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    /* Explicit x86 allocation identity; not an ARM64 pointer. */
    uint32_t result_slot_handle;
    uint8_t raw_type;
    uint8_t runtime_type;
} ActionFamily35Constructed;

/* Source is the ACT body, after the 50-byte header, including dependency tail.
 * All views borrow source storage. Keep that storage alive and unchanged.
 * Callers supply mapped readable/writable spans of the declared sizes; integer
 * address validation cannot establish whether arbitrary addresses are mapped.
 * Every failure leaves all output/source bytes unchanged. Outputs must not
 * overlap source (or, for construct, each other). */
ActionFamily35Status action_family_35_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily35Decoded *out);
ActionFamily35Status action_family_35_record6_at(
    const uint8_t *raw_body, size_t raw_body_length, size_t index,
    ActionFamily35Record6 *out);
ActionFamily35Status action_family_35_record34_at(
    const uint8_t *raw_body, size_t raw_body_length, size_t index,
    ActionFamily35Record34 *out);

/* Models 0x4bf8c2's complete variable allocation, pData identity and cursor
 * advance. Original copies the entire typed body without zeroing or changing
 * fields, including name padding. No playback/owner state is initialized here.
 * object_capacity covers caller-owned storage; bytes beyond allocation_bytes
 * remain untouched. Payload offset uses original unsigned DWORD wrap. */
ActionFamily35Status action_family_35_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    uint8_t *object_bytes, size_t object_capacity,
    ActionFamily35Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
