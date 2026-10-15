#ifndef BLACKMOOR_ACTION_FAMILY_DA_H
#define BLACKMOOR_ACTION_FAMILY_DA_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_DA_RAW_TYPE UINT8_C(0xda)
#define ACTION_FAMILY_DA_RUNTIME_TYPE UINT8_C(0xda)
#define ACTION_FAMILY_DA_BODY_BYTES 2958u
#define ACTION_FAMILY_DA_OBJECT_BYTES 2958u
#define ACTION_FAMILY_DA_WORD_COUNT 1479u
#define ACTION_FAMILY_DA_DEPENDENCY_BYTES 16u

typedef enum {
    ACTION_FAMILY_DA_OK = 0,
    ACTION_FAMILY_DA_ERR_ARGUMENT = 1,
    ACTION_FAMILY_DA_ERR_BODY = 2,
    ACTION_FAMILY_DA_ERR_TAIL = 3,
    ACTION_FAMILY_DA_ERR_BOUNDS = 4,
    ACTION_FAMILY_DA_ERR_OVERLAP = 5
} ActionFamilyDAStatus;

/* word[N] is neutral word_N: unsigned little-endian bits at raw-body+2*N for
 * N in 0..1478. The body length (2958) is even, so there is no trailing odd
 * byte. This representation does not claim that string spans or runtime
 * fields are semantically words. The loader copies a fixed 2958-byte (0xb8e)
 * prefix, without examining any body field, count, signedness or NUL
 * termination. Dependencies are borrowed, unevaluated 16-byte rows. */
typedef struct {
    uint16_t word[ACTION_FAMILY_DA_WORD_COUNT];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes;
    size_t available_body_bytes;
} ActionFamilyDADecoded;

/* Successful loader arm 0x41061d -> FUN_0045b4ae (thiscall, this=0x624734):
 * malloc(0xb8e), store the pointer in action+0x32 (before its NULL check),
 * copy 0x2e3 DWORDs and one WORD (2958 bytes) to the whole allocation, then
 * advance the consumed offset and afterwards the cursor by 0xb8e. No
 * defaults or owner links are added by the loader arm.
 * result_slot_handle is an opaque nonzero x86 pointer value, never a host
 * address. Payload offset arithmetic wraps modulo 2^32. Raw and normalized
 * runtime type remain 0xda (the arm never rewrites the type byte). Subtype
 * is preserved by the enclosing loader; it is not an input to this isolated
 * raw-body API. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_DA_OBJECT_BYTES];
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
} ActionFamilyDAConstructed;

/* Native safety statuses, not original return values. Caller supplies
 * readable raw_body[raw_body_length] and writable output. All failures
 * leave input and output unchanged. Null, wrapped or overlapping spans,
 * short body and ragged dependency tail are rejected before input reads.
 * Borrowed dependency_records points to raw_body+2958 even for an empty
 * tail; input storage must remain alive while the view is used. No host
 * effects, dependency construction/evaluation, lifecycle or runtime are
 * performed. */
ActionFamilyDAStatus action_family_da_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamilyDADecoded *out);

/* Same validation as decode, including complete tail rows. Success sets
 * *body_bytes to 2958; failure leaves it unchanged. No input bytes are read. */
ActionFamilyDAStatus action_family_da_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes);

/* output_handle must be nonzero; no allocation or input writes occur. */
ActionFamilyDAStatus action_family_da_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamilyDAConstructed *out);

#ifdef __cplusplus
}
#endif
#endif
