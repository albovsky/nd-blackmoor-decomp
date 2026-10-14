#ifndef BLACKMOOR_ACTION_FAMILY_38_H
#define BLACKMOOR_ACTION_FAMILY_38_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_38_RAW_TYPE UINT8_C(0x38)
#define ACTION_FAMILY_38_RUNTIME_TYPE UINT8_C(0x36)
#define ACTION_FAMILY_38_PREFIX_BYTES 71u
#define ACTION_FAMILY_38_FRAME_BYTES 16u
#define ACTION_FAMILY_38_MAX_FRAMES 100u
#define ACTION_FAMILY_38_DEPENDENCY_BYTES 16u
#define ACTION_FAMILY_38_OBJECT_BYTES 0xabau

typedef enum {
    ACTION_FAMILY_38_OK = 0,
    ACTION_FAMILY_38_ERR_ARGUMENT = 1,
    ACTION_FAMILY_38_ERR_BODY = 2,
    ACTION_FAMILY_38_ERR_NAME = 3,
    ACTION_FAMILY_38_ERR_TAIL = 4,
    ACTION_FAMILY_38_ERR_BOUNDS = 5,
    ACTION_FAMILY_38_ERR_OVERLAP = 6,
    ACTION_FAMILY_38_ERR_COUNT = 7,
    ACTION_FAMILY_38_ERR_ALLOCATION = 8
} ActionFamily38Status;

/* Raw-body offsets name the unproven options. Frame endpoints are signed
 * 16-bit values; end - start + 1 is evaluated in 32 bits without narrowing.
 * Zero frames are permitted. Counts outside 0..100 are native safety errors:
 * the original performs an unchecked copy into its 100-row table.
 * frame_records and dependency_records borrow the caller's input storage. */
typedef struct {
    char name[33];
    uint16_t option_21;
    uint16_t option_23;
    uint16_t option_25;
    uint16_t option_27;
    uint16_t option_29;
    uint16_t option_2b;
    uint16_t option_2d;
    uint16_t option_2f;
    uint16_t option_31;
    int16_t frame_start;
    int16_t frame_end;
    int32_t fixed_rect[4];
    const uint8_t *frame_records;
    size_t frame_count;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t available_body_bytes;
    size_t body_bytes;
    size_t dependency_bytes;
} ActionFamily38Decoded;

typedef struct {
    uint32_t output_handle;
    uint32_t result_slot_handle;
    uint32_t owner_slot_1c_handle;
    uint32_t owner_slot_20_handle;
    uint32_t output_allocation_bytes;
} ActionFamily38OwnerLinks;

/* Value model of FUN_0048905b. The allocation image is distinct from the
 * external ECX owner and *param_1 links. Handles are opaque nonzero 32-bit
 * values, never native pointers. The payload offset advances modulo 2^32. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_38_OBJECT_BYTES];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t available_body_bytes;
    size_t body_bytes_consumed;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    ActionFamily38OwnerLinks owner_links;
} ActionFamily38Constructed;

/* Status values describe native validation, not the original x86 return.
 * Invalid input leaves out unchanged. All input spans must be readable and
 * out writable; integer span wrap and input/output overlap are rejected. */
ActionFamily38Status action_family_38_decode(
    const uint8_t *raw_body, size_t raw_body_length,
    ActionFamily38Decoded *out);

/* The original clears only object[0..0xab], not the entire allocation.
 * allocation_before must supply exactly 0xABA bytes of defined prior storage;
 * untouched bytes are preserved in the resulting image. No allocation occurs
 * here. Both read-only inputs may alias each other, but neither may overlap
 * out. dependency_records remains borrowed from raw_body. */
ActionFamily38Status action_family_38_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    const uint8_t *allocation_before, size_t allocation_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily38Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
