#ifndef BLACKMOOR_ACTION_FAMILY_EB_H
#define BLACKMOOR_ACTION_FAMILY_EB_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_EB_RAW_TYPE UINT8_C(0xeb)
#define ACTION_FAMILY_EB_RUNTIME_TYPE UINT8_C(0xeb)
#define ACTION_FAMILY_EB_BODY_BYTES 2612u
#define ACTION_FAMILY_EB_OBJECT_BYTES 2612u
#define ACTION_FAMILY_EB_WORD_COUNT 1306u
#define ACTION_FAMILY_EB_DEPENDENCY_BYTES 16u

typedef enum {
    ACTION_FAMILY_EB_OK = 0,
    ACTION_FAMILY_EB_ERR_ARGUMENT = 1,
    ACTION_FAMILY_EB_ERR_BODY = 2,
    ACTION_FAMILY_EB_ERR_TAIL = 3,
    ACTION_FAMILY_EB_ERR_BOUNDS = 4,
    ACTION_FAMILY_EB_ERR_OVERLAP = 5
} ActionFamilyEBStatus;

/* word[N] is neutral word_N: unsigned little-endian bits at raw-body+2*N for
 * N in 0..1305 (the body is exactly 0x28d DWORDs, 2,612 bytes). This
 * representation does not claim that string spans or runtime fields are
 * semantically words. The loader copies a fixed 2,612-byte (0xa34) prefix,
 * without examining any body field, count, signedness or NUL termination.
 * Dependencies are borrowed, unevaluated 16-byte rows. */
typedef struct {
    uint16_t word[ACTION_FAMILY_EB_WORD_COUNT];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes;
    size_t available_body_bytes;
} ActionFamilyEBDecoded;

/* Successful loader arm 0x4108c0 -> FUN_0047e477 (thiscall, this=0x625ee8):
 * malloc(0xa34), store the pointer in action+0x32 (before its NULL check),
 * copy 0x28d DWORDs (2,612 bytes) to the whole allocation, then advance the
 * consumed offset and afterwards the cursor by 0xa34. No defaults or owner
 * links are added by the loader arm.
 * result_slot_handle is an opaque nonzero x86 pointer value, never a host
 * address. Payload offset arithmetic wraps modulo 2^32. Raw and normalized
 * runtime type remain 0xeb (the arm never rewrites the type byte). Subtype
 * is preserved by the enclosing loader; it is not an input to this isolated
 * raw-body API. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_EB_OBJECT_BYTES];
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
} ActionFamilyEBConstructed;

/* Native safety statuses, not original return values. Caller supplies
 * readable raw_body[raw_body_length] and writable output. All failures
 * leave input and output unchanged. Null, wrapped or overlapping spans,
 * short body and ragged dependency tail are rejected before input reads.
 * Borrowed dependency_records points to raw_body+2612 even for an empty tail;
 * input storage must remain alive while the view is used. No host effects,
 * dependency construction/evaluation, lifecycle or runtime are performed. */
ActionFamilyEBStatus action_family_eb_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamilyEBDecoded *out);

/* Same validation as decode, including complete tail rows. Success sets
 * *body_bytes to 2612; failure leaves it unchanged. No input bytes are read. */
ActionFamilyEBStatus action_family_eb_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes);

/* output_handle must be nonzero; no allocation or input writes occur. */
ActionFamilyEBStatus action_family_eb_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamilyEBConstructed *out);

#ifdef __cplusplus
}
#endif
#endif
