#ifndef BLACKMOOR_ACTION_FAMILY_1B_H
#define BLACKMOOR_ACTION_FAMILY_1B_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_1B_RAW_TYPE UINT8_C(0x1b)
#define ACTION_FAMILY_1B_RUNTIME_TYPE UINT8_C(0x1b)
#define ACTION_FAMILY_1B_OBJECT_BYTES 34u
#define ACTION_FAMILY_1B_PRIMARY_BYTES 22u
#define ACTION_FAMILY_1B_SECONDARY_BYTES 18u
#define ACTION_FAMILY_1B_DEPENDENCY_BYTES 16u

/* Native safety results, not the original constructor's return value. */
typedef enum {
    ACTION_FAMILY_1B_OK = 0,
    ACTION_FAMILY_1B_ERR_ARGUMENT = 1,
    ACTION_FAMILY_1B_ERR_BODY = 2,
    ACTION_FAMILY_1B_ERR_COUNT = 3,
    ACTION_FAMILY_1B_ERR_TAIL = 4,
    ACTION_FAMILY_1B_ERR_BOUNDS = 5,
    ACTION_FAMILY_1B_ERR_OVERLAP = 6
} ActionFamily1bStatus;

/* Two signed LE16 counts, each 0..32767 on the safe native path.
 * Layout: count, count*22 bytes, fixed 22 bytes, count, count*18 bytes.
 * Typed size = 26 + primary_count*22 + secondary_count*18. All remaining
 * bytes must form complete 16-byte dependency records. Array views retain
 * uninterpreted data; fixed fields have neutral names and unsigned bit values.
 * Every view borrows raw_body, including one-past pointers for empty spans. */
typedef struct {
    uint8_t raw_type;
    uint8_t runtime_type;
    int16_t primary_count;
    int16_t secondary_count;
    uint16_t fixed_words[5];
    uint32_t fixed_dwords[3];
    const uint8_t *primary_records;
    size_t primary_bytes;
    const uint8_t *secondary_records;
    size_t secondary_bytes;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t body_bytes;
    size_t dependency_bytes;
    size_t available_body_bytes;
} ActionFamily1bDecoded;

/* Successful-allocation value model of 0x414692. object_bytes is the whole
 * 34-byte x86 main allocation, entirely overwritten by the original. The two
 * copied array values are represented by borrowed source views, not native
 * allocated storage. No runtime allocation or owner mutation occurs here.
 * The three supplied nonzero handles are opaque x86 values, never host
 * pointers. They model the original's THREE malloc returns in order, even
 * when an array has zero bytes; actual malloc(0) behavior is host-dependent.
 * owner_field_1c/20/24 represent the only owner writes, at offsets 0x1c/20/24.
 * No semantics for the fields or gameplay/lifecycle behavior are claimed. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_1B_OBJECT_BYTES];
    const uint8_t *primary_records;
    size_t primary_bytes;
    const uint8_t *secondary_records;
    size_t secondary_bytes;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes_consumed;
    size_t available_body_bytes;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    uint32_t result_slot_handle;
    uint32_t owner_field_1c;
    uint32_t owner_field_20;
    uint32_t owner_field_24;
    uint32_t output_allocation_bytes;
    uint32_t primary_allocation_bytes;
    uint32_t secondary_allocation_bytes;
    uint32_t allocation_count;
} ActionFamily1bConstructed;

/* Readable input and writable disjoint output storage are caller contracts.
 * Null, wrapped spans, overlap, short bodies, negative counts and ragged tails
 * fail before output mutation. body_length validates the entire tail too. */
ActionFamily1bStatus action_family_1b_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily1bDecoded *out);
ActionFamily1bStatus action_family_1b_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_length);

/* All three model handles must be nonzero and their allocation extents must
 * not wrap 32 bits. Payload offset addition wraps modulo 2^32 as on x86.
 * On any failure out remains unchanged. */
ActionFamily1bStatus action_family_1b_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    uint32_t primary_handle, uint32_t secondary_handle,
    ActionFamily1bConstructed *out);

#ifdef __cplusplus
}
#endif
#endif
