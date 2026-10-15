#ifndef BLACKMOOR_ACTION_FAMILY_16_H
#define BLACKMOOR_ACTION_FAMILY_16_H

#include "action_family_17.h"

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_16_RAW_TYPE 0x16u
#define ACTION_FAMILY_16_RUNTIME_TYPE 0x16u
#define ACTION_FAMILY_16_PREFIX_BYTES ACTION_FAMILY_17_PREFIX_BYTES
#define ACTION_FAMILY_16_RECORD_BYTES ACTION_FAMILY_17_RECORD_BYTES
#define ACTION_FAMILY_16_DEPENDENCY_BYTES ACTION_FAMILY_17_DEPENDENCY_BYTES
#define ACTION_FAMILY_16_MAX_COUNT ACTION_FAMILY_17_MAX_COUNT
#define ACTION_FAMILY_16_MAX_BODY_BYTES ACTION_FAMILY_17_MAX_BODY_BYTES

/* Raw 0x16 and 0x17 share original loader arm 0x40b98f. Reuse its bounded
 * little-endian decoder and whole-body allocation/copy model; only the type
 * identities differ. The binary prefix has ten neutral word_N fields, count
 * at +20 and opaque 18-byte records at +22. There are no name/key strings.
 * All status values, borrowing, overlap and failure-atomicity contracts from
 * action_family_17.h apply. These are native safety results, not x86 returns.
 * In particular, n=0..1819 avoids the original signed WORD size narrowing;
 * negative/overflowing counts are deliberate safety rejections. */
typedef ActionFamily17Status ActionFamily16Status;
typedef ActionFamily17Decoded ActionFamily16Decoded;
typedef ActionFamily17Constructed ActionFamily16Constructed;

#define ACTION_FAMILY_16_OK ACTION_FAMILY_17_OK
#define ACTION_FAMILY_16_ERR_ARGUMENT ACTION_FAMILY_17_ERR_ARGUMENT
#define ACTION_FAMILY_16_ERR_BODY ACTION_FAMILY_17_ERR_BODY
#define ACTION_FAMILY_16_ERR_COUNT ACTION_FAMILY_17_ERR_COUNT
#define ACTION_FAMILY_16_ERR_TAIL ACTION_FAMILY_17_ERR_TAIL
#define ACTION_FAMILY_16_ERR_BOUNDS ACTION_FAMILY_17_ERR_BOUNDS
#define ACTION_FAMILY_16_ERR_OVERLAP ACTION_FAMILY_17_ERR_OVERLAP
#define ACTION_FAMILY_16_ERR_CAPACITY ACTION_FAMILY_17_ERR_CAPACITY

ActionFamily16Status action_family_16_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily16Decoded *out);
ActionFamily16Status action_family_16_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out);
ActionFamily16Status action_family_16_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    uint8_t *object_bytes, size_t object_capacity, ActionFamily16Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
