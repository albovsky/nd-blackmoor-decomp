#ifndef BLACKMOOR_ACTION_FAMILY_F6_H
#define BLACKMOOR_ACTION_FAMILY_F6_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_F6_RAW_TYPE UINT8_C(0xf6)
#define ACTION_FAMILY_F6_RUNTIME_TYPE UINT8_C(0xf6)
#define ACTION_FAMILY_F6_BODY_BYTES 4934u
#define ACTION_FAMILY_F6_OBJECT_BYTES 4934u
#define ACTION_FAMILY_F6_DEPENDENCY_BYTES 16u

typedef enum {
    ACTION_FAMILY_F6_OK = 0,
    ACTION_FAMILY_F6_ERR_ARGUMENT = 1,
    ACTION_FAMILY_F6_ERR_BODY = 2,
    ACTION_FAMILY_F6_ERR_TAIL = 3,
    ACTION_FAMILY_F6_ERR_BOUNDS = 4,
    ACTION_FAMILY_F6_ERR_OVERLAP = 5
} ActionFamilyF6Status;

/* The original loader arm 0x4109f8 calls 0x45ddd0, which malloc(0x1346)s
 * and copies 0x4d1 DWORDs plus one WORD (4,934 bytes) from the ACT cursor
 * without examining any body byte: there is no count, no sign or width
 * narrowing and no NUL scan. body[N] is therefore the verbatim raw-body byte
 * at offset N; no multi-byte field is interpreted, so no endian conversion
 * is performed and no field is named. Dependencies are borrowed,
 * unevaluated 16-byte rows. */
typedef struct {
    uint8_t body[ACTION_FAMILY_F6_BODY_BYTES];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes;
    size_t available_body_bytes;
} ActionFamilyF6Decoded;

/* Successful loader model: the whole 4,934-byte allocation is the verbatim
 * body, the result pointer is stored in action+0x32, and the payload offset
 * then the cursor advance by 4,934 (DWORD arithmetic wraps modulo 2^32).
 * result_slot_handle is an opaque nonzero x86 pointer value, never a host
 * address. Raw and runtime type both remain 0xf6 (no alias is written);
 * subtype is preserved by the enclosing loader and is not an input here. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_F6_OBJECT_BYTES];
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
} ActionFamilyF6Constructed;

/* Native safety statuses, not original return values. Caller supplies
 * readable raw_body[raw_body_length] and writable output. All failures leave
 * input and output unchanged. Null, wrapped or overlapping spans, a body
 * shorter than 4,934 bytes and a dependency tail that is not a multiple of
 * 16 bytes are rejected before any input byte is read. Borrowed
 * dependency_records points to raw_body+4934 even for an empty tail; input
 * storage must outlive the view. No host effects, dependency construction or
 * evaluation, lifecycle or runtime are performed. */
ActionFamilyF6Status action_family_f6_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamilyF6Decoded *out);

/* Same validation as decode, including complete tail rows. Success sets
 * *body_bytes to 4934; failure leaves it unchanged. No input byte is read. */
ActionFamilyF6Status action_family_f6_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes);

/* output_handle must be nonzero; no allocation or input writes occur. */
ActionFamilyF6Status action_family_f6_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamilyF6Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
