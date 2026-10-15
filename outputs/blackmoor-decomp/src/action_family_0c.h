#ifndef BLACKMOOR_ACTION_FAMILY_0C_H
#define BLACKMOOR_ACTION_FAMILY_0C_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_0C_RAW_TYPE UINT8_C(0x0c)
#define ACTION_FAMILY_0C_RUNTIME_TYPE UINT8_C(0x0c)
#define ACTION_FAMILY_0C_PREFIX_BYTES 10u
#define ACTION_FAMILY_0C_RECORD18_BYTES 18u
#define ACTION_FAMILY_0C_DEPENDENCY_BYTES 16u
/* (INT16_MAX - 10) / 18. Original size is narrowed back to signed WORD.
 * Native rejects negative counts and all counts causing that size to wrap. */
#define ACTION_FAMILY_0C_MAX_COUNT 1819u

/* Native safety results; not original loader return values. */
typedef enum {
    ACTION_FAMILY_0C_OK = 0,
    ACTION_FAMILY_0C_ERR_ARGUMENT = 1,
    ACTION_FAMILY_0C_ERR_BODY = 2,
    ACTION_FAMILY_0C_ERR_TAIL = 3,
    ACTION_FAMILY_0C_ERR_COUNT = 4,
    ACTION_FAMILY_0C_ERR_BOUNDS = 5,
    ACTION_FAMILY_0C_ERR_OVERLAP = 6,
    ACTION_FAMILY_0C_ERR_CAPACITY = 7,
    ACTION_FAMILY_0C_ERR_INDEX = 8
} ActionFamily0cStatus;

typedef struct {
    /* Uninterpreted LE word_N at body +2*N. Semantics unverified. */
    uint16_t words[4];
    int16_t count_18;
    const uint8_t *records_18;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t available_body_bytes;
    size_t body_bytes;
    uint8_t raw_type;
    uint8_t runtime_type;
} ActionFamily0cDecoded;

typedef struct { uint16_t words[9]; } ActionFamily0cRecord18;

typedef struct {
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t available_body_bytes;
    size_t body_bytes_consumed;
    size_t allocation_bytes;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    /* Opaque x86 identity supplied by caller; never a native pointer. */
    uint32_t result_slot_handle;
    uint8_t raw_type;
    uint8_t runtime_type;
} ActionFamily0cConstructed;

/* Input is ACT body after the 50-byte header, including dependencies. All
 * views borrow storage: keep it alive and unchanged. The caller must provide
 * mapped readable/writable spans of declared sizes. Null, address wrap,
 * overlap, short body, invalid count and fractional tail fail before output
 * mutation; status never claims equivalent original malformed-input behavior.
 * No lifecycle/dispatcher/host effects or dependency evaluation are modeled. */
ActionFamily0cStatus action_family_0c_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out);
ActionFamily0cStatus action_family_0c_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily0cDecoded *out);
ActionFamily0cStatus action_family_0c_record18_at(
    const uint8_t *raw_body, size_t raw_body_length, size_t index,
    ActionFamily0cRecord18 *out);

/* Models loader arm 0x40bafd..0x40bbed: copies every typed byte into caller
 * storage, reports allocation/slot identity and unsigned DWORD cursor wrap.
 * No clearing or field initialization occurs in the original. Capacity beyond
 * allocation_bytes remains untouched. Handle must be nonzero; object/output/
 * input spans must be mutually disjoint. All failures leave all bytes intact. */
ActionFamily0cStatus action_family_0c_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    uint8_t *object_bytes, size_t object_capacity,
    ActionFamily0cConstructed *out);

#ifdef __cplusplus
}
#endif
#endif
