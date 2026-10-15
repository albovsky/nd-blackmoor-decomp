#ifndef BLACKMOOR_ACTION_FAMILY_80_H
#define BLACKMOOR_ACTION_FAMILY_80_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_80_RAW_TYPE UINT8_C(0x80)
#define ACTION_FAMILY_80_RUNTIME_TYPE UINT8_C(0x80)
#define ACTION_FAMILY_80_BODY_BYTES 2u
#define ACTION_FAMILY_80_OBJECT_BYTES 2u
#define ACTION_FAMILY_80_DEPENDENCY_BYTES 16u

typedef enum {
    ACTION_FAMILY_80_OK = 0,
    ACTION_FAMILY_80_ERR_ARGUMENT = 1,
    ACTION_FAMILY_80_ERR_BODY = 2,
    ACTION_FAMILY_80_ERR_TAIL = 3,
    ACTION_FAMILY_80_ERR_BOUNDS = 4,
    ACTION_FAMILY_80_ERR_OVERLAP = 5
} ActionFamily80Status;

/* word_0 is the neutral unsigned little-endian 16-bit value at raw-body+0.
 * The loader copies one WORD without examining it: it is not a count and no
 * range, signedness or narrowing is applied to it. Its meaning is not
 * claimed. Dependencies are borrowed, unevaluated 16-byte rows. */
typedef struct {
    uint16_t word_0;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes;
    size_t available_body_bytes;
} ActionFamily80Decoded;

/* Successful loader arm 0x40e73f (inline in 0x40b34a): malloc(2), store the
 * pointer in action+0x32 (before its NULL check), copy one WORD from the
 * cursor to the allocation, then advance the consumed offset and afterwards
 * the cursor by 2. No defaults or owner links are added by the loader arm.
 * result_slot_handle is an opaque nonzero x86 pointer value, never a host
 * address. Payload offset arithmetic wraps modulo 2^32. Raw and normalized
 * runtime type remain 0x80 (the arm never rewrites the type byte). Subtype
 * is preserved by the enclosing loader; it is not an input to this isolated
 * raw-body API. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_80_OBJECT_BYTES];
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
} ActionFamily80Constructed;

/* Native safety statuses, not original return values. Caller supplies
 * readable raw_body[raw_body_length] and writable output. All failures
 * leave input and output unchanged. Null, wrapped or overlapping spans,
 * short body and ragged dependency tail are rejected before input reads.
 * Borrowed dependency_records points to raw_body+2 even for an empty tail;
 * input storage must remain alive while the view is used. No host effects,
 * dependency construction/evaluation, lifecycle or runtime are performed. */
ActionFamily80Status action_family_80_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily80Decoded *out);

/* Same validation as decode, including complete tail rows. Success sets
 * *body_bytes to 2; failure leaves it unchanged. No input bytes are read. */
ActionFamily80Status action_family_80_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes);

/* output_handle must be nonzero; no allocation or input writes occur. */
ActionFamily80Status action_family_80_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily80Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
