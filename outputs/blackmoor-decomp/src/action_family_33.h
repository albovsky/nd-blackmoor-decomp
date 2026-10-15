#ifndef BLACKMOOR_ACTION_FAMILY_33_H
#define BLACKMOOR_ACTION_FAMILY_33_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_33_RAW_TYPE UINT8_C(0x33)
#define ACTION_FAMILY_33_RUNTIME_TYPE UINT8_C(0x33)
#define ACTION_FAMILY_33_PREFIX_BYTES 113u
#define ACTION_FAMILY_33_MAX_BODY_BYTES 32767u
#define ACTION_FAMILY_33_DEPENDENCY_BYTES 16u

/* Native safety results, not original return values. */
typedef enum {
    ACTION_FAMILY_33_OK = 0,
    ACTION_FAMILY_33_ERR_ARGUMENT = 1,
    ACTION_FAMILY_33_ERR_BODY = 2,
    ACTION_FAMILY_33_ERR_TAIL = 3,
    ACTION_FAMILY_33_ERR_BOUNDS = 4,
    ACTION_FAMILY_33_ERR_OVERLAP = 5,
    ACTION_FAMILY_33_ERR_COUNT = 6,
    ACTION_FAMILY_33_ERR_CAPACITY = 7
} ActionFamily33Status;

/* Loader 0x40c186 reads two signed LE words at 0x6d/0x6f and copies
 * 113 + 6*count_6d + 66*count_6f bytes. This bounded API accepts nonnegative
 * counts only, without signed-16 size narrowing. All remaining bytes are
 * uninterpreted: no name/string checks or runtime semantics are inferred.
 * Both views are borrowed; an empty tail points just past the typed body. */
typedef struct {
    uint8_t raw_type;
    uint8_t runtime_type;
    uint16_t count_6d;
    uint16_t count_6f;
    const uint8_t *typed_body;
    size_t body_bytes;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t available_body_bytes;
} ActionFamily33Decoded;

/* Value model of the loader's complete variable allocation, copy, result
 * slot and DWORD cursor-offset update. object_bytes is caller-owned storage;
 * output_handle is an opaque nonzero model address, never a native pointer.
 * No lifecycle, dependency construction, video or host effect is implemented. */
typedef struct {
    uint8_t *object_bytes;
    size_t body_bytes_consumed;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t available_body_bytes;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    uint32_t output_handle;
    uint32_t result_slot_handle;
    uint32_t output_allocation_bytes;
} ActionFamily33Constructed;

/* Readable input and writable output storage are caller contracts. All
 * errors preserve every output byte. Reject wrapped or overlapping spans
 * before reading counts; validate the complete body/tail before publishing. */
ActionFamily33Status action_family_33_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily33Decoded *out);

/* Uses the same body AND tail validation as decode; no output on failure. */
ActionFamily33Status action_family_33_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out_body_length);

/* object_capacity must cover the typed body; its full span must not overlap
 * input or out. Only the typed extent is written. Offset addition wraps
 * modulo 2^32, matching the original DWORD add. */
ActionFamily33Status action_family_33_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    uint8_t *object_bytes, size_t object_capacity, ActionFamily33Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
