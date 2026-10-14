#ifndef BLACKMOOR_ACTION_FAMILY_37_H
#define BLACKMOOR_ACTION_FAMILY_37_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_37_RAW_TYPE UINT8_C(0x37)
#define ACTION_FAMILY_37_RUNTIME_TYPE UINT8_C(0x36)
#define ACTION_FAMILY_37_BODY_BYTES 0x45u
#define ACTION_FAMILY_37_DEPENDENCY_BYTES 0x10u
#define ACTION_FAMILY_37_OBJECT_BYTES 0xabau
#define ACTION_FAMILY_37_OWNER_SLOT_1C_OFFSET 0x1cu
#define ACTION_FAMILY_37_OWNER_SLOT_20_OFFSET 0x20u

typedef enum {
    ACTION_FAMILY_37_OK = 0,
    ACTION_FAMILY_37_ERR_ARGUMENT = 1,
    ACTION_FAMILY_37_ERR_BODY = 2,
    ACTION_FAMILY_37_ERR_NAME = 3,
    ACTION_FAMILY_37_ERR_TAIL = 4,
    ACTION_FAMILY_37_ERR_BOUNDS = 5,
    ACTION_FAMILY_37_ERR_OVERLAP = 6
} ActionFamily37Status;

/* Bounded decode of one raw-0x37 ACT body. dependency_records is a borrowed
 * view into raw_body and remains valid only while its SceneResource does.
 * name is copied through its first NUL; bytes after that terminator are not
 * part of the decoded name. The two options remain unsigned raw words. */
typedef struct {
    char name[33];
    uint16_t option_21;
    uint16_t option_23;
    int32_t fixed_rect[4];
    int32_t initial_geometry[4];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t available_body_bytes;
    size_t body_bytes;
    size_t dependency_bytes;
} ActionFamily37Decoded;

/* The original constructor writes the allocated object's 32-bit address to
 * *param_1 and offsets +0x1c/+0x20 of a separate ECX owner object. Those
 * offsets in object_bytes belong to the copied 33-byte name. This portable
 * metadata uses a caller-supplied opaque handle and keeps the output slot and
 * both external owner links separate from the exact 0xABA-byte image. */
typedef struct {
    uint32_t output_handle;
    uint32_t result_slot_handle;
    uint32_t owner_slot_1c_handle;
    uint32_t owner_slot_20_handle;
    uint32_t output_allocation_bytes;
} ActionFamily37OwnerLinks;

/* Value model of FUN_004895cc's allocation and cursor effects. object_bytes
 * is byte-for-byte comparable with the original 0xABA allocation. Owner links
 * are metadata for the separate ECX owner object, never bytes in that image.
 * dependency_records remains borrowed from the input resource. The original
 * method consumes 69 bytes from the input cursor and adds 69 modulo 2^32 to
 * its caller's payload offset. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_37_OBJECT_BYTES];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t available_body_bytes;
    size_t body_bytes_consumed;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    ActionFamily37OwnerLinks owner_links;
} ActionFamily37Constructed;

/* Decode the fixed 69-byte prefix and the remaining 16-byte dependency view.
 * Invalid input leaves out unchanged. Input and output spans may not overlap. */
ActionFamily37Status action_family_37_decode(
    const uint8_t *raw_body,
    size_t raw_body_length,
    ActionFamily37Decoded *out);

/* Build the full portable 0xABA constructor image and external owner-link
 * metadata. output_handle is an opaque nonzero model handle, not a native
 * pointer. Invalid input leaves out unchanged; raw input and output may not
 * overlap. The method's original x86 return value is not modeled as a status. */
ActionFamily37Status action_family_37_construct(
    const uint8_t *raw_body,
    size_t raw_body_length,
    uint32_t payload_offset_before,
    uint32_t output_handle,
    ActionFamily37Constructed *out);

#ifdef __cplusplus
}
#endif

#endif
