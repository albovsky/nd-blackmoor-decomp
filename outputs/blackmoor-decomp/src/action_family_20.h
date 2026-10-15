#ifndef BLACKMOOR_ACTION_FAMILY_20_H
#define BLACKMOOR_ACTION_FAMILY_20_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_20_RAW_TYPE UINT8_C(0x20)
#define ACTION_FAMILY_20_RUNTIME_TYPE UINT8_C(0x20)
#define ACTION_FAMILY_20_BODY_BYTES 8u
#define ACTION_FAMILY_20_OBJECT_BYTES 8u
#define ACTION_FAMILY_20_DEPENDENCY_BYTES 16u

typedef enum {
    ACTION_FAMILY_20_OK = 0,
    ACTION_FAMILY_20_ERR_ARGUMENT = 1,
    ACTION_FAMILY_20_ERR_BODY = 2,
    ACTION_FAMILY_20_ERR_TAIL = 3,
    ACTION_FAMILY_20_ERR_BOUNDS = 4,
    ACTION_FAMILY_20_ERR_OVERLAP = 5
} ActionFamily20Status;

/* dword_0 and dword_4 are the neutral unsigned little-endian 32-bit values at
 * raw-body+0 and raw-body+4. The loader copies two DWORDs without examining
 * them: they are not counts and no range, signedness or narrowing is applied.
 * Their meaning is not claimed. Dependencies are borrowed, unevaluated 16-byte
 * rows. */
typedef struct {
    uint32_t dword_0;
    uint32_t dword_4;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes;
    size_t available_body_bytes;
} ActionFamily20Decoded;

/* Successful loader arm [0x40bd12,0x40bddd) (inline in 0x40b34a): malloc(8),
 * store the pointer in action+0x32 (before its NULL check), copy two DWORDs
 * (offset 0 then offset 4) from the cursor to the allocation, then advance the
 * consumed offset and afterwards the cursor by 8. No defaults or owner links
 * are added by the loader arm.
 * result_slot_handle is an opaque nonzero x86 pointer value, never a host
 * address. Payload offset arithmetic wraps modulo 2^32. Raw and normalized
 * runtime type remain 0x20 (the arm never rewrites the type byte). Subtype
 * is preserved by the enclosing loader; it is not an input to this isolated
 * raw-body API. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_20_OBJECT_BYTES];
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
} ActionFamily20Constructed;

/* Native safety statuses, not original return values. Caller supplies
 * readable raw_body[raw_body_length] and writable output. All failures
 * leave input and output unchanged. Null, wrapped or overlapping spans,
 * short body and ragged dependency tail are rejected before input reads.
 * Borrowed dependency_records points to raw_body+8 even for an empty tail;
 * input storage must remain alive while the view is used. No host effects,
 * dependency construction/evaluation, lifecycle or runtime are performed. */
ActionFamily20Status action_family_20_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily20Decoded *out);

/* Same validation as decode, including complete tail rows. Success sets
 * *body_bytes to 8; failure leaves it unchanged. No input bytes are read. */
ActionFamily20Status action_family_20_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes);

/* output_handle must be nonzero; no allocation or input writes occur. */
ActionFamily20Status action_family_20_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily20Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
