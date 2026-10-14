#ifndef BLACKMOOR_ACTION_FAMILY_36_H
#define BLACKMOOR_ACTION_FAMILY_36_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_36_RAW_TYPE UINT8_C(0x36)
#define ACTION_FAMILY_36_RUNTIME_TYPE UINT8_C(0x36)
#define ACTION_FAMILY_36_PREFIX_BYTES 0xacu
#define ACTION_FAMILY_36_PRIMARY_BYTES 16u
#define ACTION_FAMILY_36_MAX_PRIMARY 100u
#define ACTION_FAMILY_36_SECONDARY_BYTES 38u
#define ACTION_FAMILY_36_MAX_SECONDARY 25u
#define ACTION_FAMILY_36_SECONDARY_OFFSET 0x6ecu
#define ACTION_FAMILY_36_OBJECT_BYTES 0xabau
#define ACTION_FAMILY_36_DEPENDENCY_BYTES 16u

/* Native safety results, not original x86 return values. */
typedef enum {
    ACTION_FAMILY_36_OK = 0,
    ACTION_FAMILY_36_ERR_ARGUMENT = 1,
    ACTION_FAMILY_36_ERR_BODY = 2,
    ACTION_FAMILY_36_ERR_TAIL = 3,
    ACTION_FAMILY_36_ERR_BOUNDS = 4,
    ACTION_FAMILY_36_ERR_OVERLAP = 5,
    ACTION_FAMILY_36_ERR_COUNT = 6,
    ACTION_FAMILY_36_ERR_ALLOCATION = 7
} ActionFamily36Status;

/* FUN_00488e9c copies the binary prefix verbatim, without name/NUL checks.
 * Neutral word names refer to raw offsets; other fields remain prefix bytes.
 * If option_29 == 2, the primary count is signed word_35 - word_33 + 1,
 * narrowed modulo 65536 and then interpreted as signed 16-bit. Otherwise it
 * is signed word_2b. Secondary count is signed word_aa. Native bounds 0..100
 * and 0..25 keep the copies within their tables; the original is unchecked.
 * All record views borrow raw_body and share its lifetime. */
typedef struct {
    uint8_t prefix_bytes[ACTION_FAMILY_36_PREFIX_BYTES];
    uint16_t option_29;
    int16_t word_2b;
    int16_t word_33;
    int16_t word_35;
    int16_t word_aa;
    const uint8_t *primary_records;
    size_t primary_count;
    const uint8_t *secondary_records;
    size_t secondary_count;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t available_body_bytes;
    size_t body_bytes;
    size_t dependency_bytes;
} ActionFamily36Decoded;

/* Opaque caller-supplied handles model external ECX owner slots, not bytes
 * inside the allocation. The constructor writes all three links identically. */
typedef struct {
    uint32_t output_handle;
    uint32_t result_slot_handle;
    uint32_t owner_slot_1c_handle;
    uint32_t owner_slot_20_handle;
    uint32_t output_allocation_bytes;
} ActionFamily36OwnerLinks;

typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_36_OBJECT_BYTES];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t available_body_bytes;
    size_t body_bytes_consumed;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    ActionFamily36OwnerLinks owner_links;
} ActionFamily36Constructed;

/* Input readable/output writable are caller contracts. Null, span wrap,
 * input/output overlap, unsafe counts, truncation and fractional dependency
 * rows fail before output mutation. No allocation, runtime or dependency
 * evaluation occurs. Empty views point at their original cursor positions. */
ActionFamily36Status action_family_36_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily36Decoded *out);
ActionFamily36Status action_family_36_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_length);

/* The original leaves all bytes outside the three copies untouched. Supply
 * exactly 0xABA defined prior allocation bytes; the model preserves them.
 * The two readable inputs may alias each other, but neither may overlap out.
 * output_handle must be nonzero; payload offset addition wraps modulo 2^32. */
ActionFamily36Status action_family_36_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    const uint8_t *allocation_before, size_t allocation_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily36Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
