#ifndef BLACKMOOR_ACTION_FAMILY_9A_H
#define BLACKMOOR_ACTION_FAMILY_9A_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_9A_RAW_TYPE UINT8_C(0x9a)
#define ACTION_FAMILY_9A_RUNTIME_TYPE UINT8_C(0x9a)
#define ACTION_FAMILY_9A_BODY_BYTES 27u
#define ACTION_FAMILY_9A_OBJECT_BYTES 27u
#define ACTION_FAMILY_9A_WORD_COUNT 13u
#define ACTION_FAMILY_9A_DEPENDENCY_BYTES 16u

typedef enum {
    ACTION_FAMILY_9A_OK = 0,
    ACTION_FAMILY_9A_ERR_ARGUMENT = 1,
    ACTION_FAMILY_9A_ERR_BODY = 2,
    ACTION_FAMILY_9A_ERR_TAIL = 3,
    ACTION_FAMILY_9A_ERR_BOUNDS = 4,
    ACTION_FAMILY_9A_ERR_OVERLAP = 5
} ActionFamily9AStatus;

/* word[N] is neutral word_N: unsigned little-endian bits at raw-body+2*N for
 * N in 0..12; byte_26 is the 27th and last body byte. This representation
 * does not claim that any field is semantically a word, count or string.
 * The loader copies a fixed 27-byte (0x1b) prefix, without examining any
 * body field, count, signedness or NUL termination. Dependencies are
 * borrowed, unevaluated 16-byte rows. */
typedef struct {
    uint16_t word[ACTION_FAMILY_9A_WORD_COUNT];
    uint8_t byte_26;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes;
    size_t available_body_bytes;
} ActionFamily9ADecoded;

/* Successful loader arm [0x40fee2,0x40ffd4), inline in loader 0x40b34a and
 * shared with raw 0x9b: malloc(0x1b), store the pointer in action+0x32
 * (before its NULL check), copy 6 DWORDs, one WORD and one BYTE (27 bytes)
 * to the whole allocation, then advance the consumed offset and afterwards
 * the cursor by 0x1b. No defaults or owner links are added by the arm.
 * result_slot_handle is an opaque nonzero x86 pointer value, never a host
 * address. Payload offset arithmetic wraps modulo 2^32. Raw and normalized
 * runtime type remain 0x9a (the arm never rewrites the type byte). Subtype
 * is preserved by the enclosing loader; it is not an input to this isolated
 * raw-body API. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_9A_OBJECT_BYTES];
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
} ActionFamily9AConstructed;

/* Native safety statuses, not original return values. Caller supplies
 * readable raw_body[raw_body_length] and writable output. All failures
 * leave input and output unchanged. Null, wrapped or overlapping spans,
 * short body and ragged dependency tail are rejected before input reads.
 * Borrowed dependency_records points to raw_body+27 even for an empty tail;
 * input storage must remain alive while the view is used. No host effects,
 * dependency construction/evaluation, lifecycle or runtime are performed. */
ActionFamily9AStatus action_family_9a_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily9ADecoded *out);

/* Same validation as decode, including complete tail rows. Success sets
 * *body_bytes to 27; failure leaves it unchanged. No input bytes are read. */
ActionFamily9AStatus action_family_9a_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes);

/* output_handle must be nonzero; no allocation or input writes occur. */
ActionFamily9AStatus action_family_9a_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily9AConstructed *out);

#ifdef __cplusplus
}
#endif
#endif
