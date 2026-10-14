#ifndef BLACKMOOR_ACTION_FAMILY_6E_H
#define BLACKMOOR_ACTION_FAMILY_6E_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_6E_RAW_TYPE UINT8_C(0x6e)
#define ACTION_FAMILY_6E_RUNTIME_TYPE UINT8_C(0x6e)
#define ACTION_FAMILY_6E_BODY_BYTES 1u
#define ACTION_FAMILY_6E_OBJECT_BYTES 1u
#define ACTION_FAMILY_6E_DEPENDENCY_BYTES 16u

typedef enum {
    ACTION_FAMILY_6E_OK = 0,
    ACTION_FAMILY_6E_ERR_ARGUMENT = 1,
    ACTION_FAMILY_6E_ERR_BODY = 2,
    ACTION_FAMILY_6E_ERR_TAIL = 3,
    ACTION_FAMILY_6E_ERR_BOUNDS = 4,
    ACTION_FAMILY_6E_ERR_OVERLAP = 5
} ActionFamily6eStatus;

/* Raw 0x6e consumes one opaque byte, without count or signedness conversion.
 * The remaining bytes are borrowed, unevaluated 16-byte dependency records.
 * No semantics are assigned to option_00. */
typedef struct {
    uint8_t option_00;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes;
    size_t available_body_bytes;
} ActionFamily6eDecoded;

/* Successful allocation/copy model of the inline loader arm 0x40e250.
 * The sole allocated byte is completely written; no prior allocation image
 * is needed. The original stores its allocation pointer in the action's
 * pData slot (+0x32), with no separate ECX owner links. result_slot_handle
 * models that pointer as an opaque nonzero x86 value, never a native pointer.
 * Raw and runtime type both remain 0x6e. Payload offset wraps modulo 2^32.
 * This model does not invoke dependencies, dispatch, scene-stack or host code. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_6E_OBJECT_BYTES];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes_consumed;
    size_t available_body_bytes;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    uint32_t result_slot_handle;
    uint32_t allocation_bytes;
    uint8_t raw_type;
    uint8_t runtime_type;
} ActionFamily6eConstructed;

/* Status values describe native validation, not an original return value.
 * Caller supplies readable raw_body[raw_body_length] and writable *out.
 * Null pointers, integer span wrap, overlapping input/output, missing body
 * and partial dependency rows fail before any output mutation. The input
 * storage must remain alive while its borrowed dependency view is used.
 * dependency_records is raw_body+1 even when the tail is empty. */
ActionFamily6eStatus action_family_6e_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily6eDecoded *out);

/* output_handle must be nonzero. No host allocation or input writes occur. */
ActionFamily6eStatus action_family_6e_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily6eConstructed *out);

#ifdef __cplusplus
}
#endif
#endif
