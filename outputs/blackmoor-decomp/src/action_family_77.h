#ifndef BLACKMOOR_ACTION_FAMILY_77_H
#define BLACKMOOR_ACTION_FAMILY_77_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_77_RAW_TYPE UINT8_C(0x77)
#define ACTION_FAMILY_77_RUNTIME_TYPE UINT8_C(0x77)
#define ACTION_FAMILY_77_BODY_BYTES 731u
#define ACTION_FAMILY_77_OBJECT_BYTES 731u
#define ACTION_FAMILY_77_WORD_COUNT 365u
#define ACTION_FAMILY_77_DEPENDENCY_BYTES 16u

typedef enum {
    ACTION_FAMILY_77_OK = 0,
    ACTION_FAMILY_77_ERR_ARGUMENT = 1,
    ACTION_FAMILY_77_ERR_BODY = 2,
    ACTION_FAMILY_77_ERR_TAIL = 3,
    ACTION_FAMILY_77_ERR_BOUNDS = 4,
    ACTION_FAMILY_77_ERR_OVERLAP = 5
} ActionFamily77Status;

/* word[N] is neutral word_N: unsigned little-endian bits at raw-body+2*N for
 * N in 0..364; byte_730 is the 731st and last body byte. This representation
 * does not claim that string spans or runtime fields are semantically words.
 * The loader copies a fixed 731-byte (0x2db) prefix, without examining any
 * body field, count, signedness or NUL termination. Dependencies are
 * borrowed, unevaluated 16-byte rows. */
typedef struct {
    uint16_t word[ACTION_FAMILY_77_WORD_COUNT];
    uint8_t byte_730;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes;
    size_t available_body_bytes;
} ActionFamily77Decoded;

/* Successful loader arm [0x40db66,0x40dc38), inline in loader 0x40b34a (no
 * constructor call): malloc(0x2db), store the pointer in action+0x32 (before its NULL check),
 * copy 0xb6 DWORDs, one WORD and one BYTE (731 bytes) to the whole allocation,
 * then advance the consumed offset and afterwards the cursor by 0x2db. No
 * defaults or owner links are added by the loader arm.
 * result_slot_handle is an opaque nonzero x86 pointer value, never a host
 * address. Payload offset arithmetic wraps modulo 2^32. Raw and normalized
 * runtime type remain 0x77 (the arm never rewrites the type byte). Subtype
 * is preserved by the enclosing loader; it is not an input to this isolated
 * raw-body API. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_77_OBJECT_BYTES];
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
} ActionFamily77Constructed;

/* Native safety statuses, not original return values. Caller supplies
 * readable raw_body[raw_body_length] and writable output. All failures
 * leave input and output unchanged. Null, wrapped or overlapping spans,
 * short body and ragged dependency tail are rejected before input reads.
 * Borrowed dependency_records points to raw_body+731 even for an empty tail;
 * input storage must remain alive while the view is used. No host effects,
 * dependency construction/evaluation, lifecycle or runtime are performed. */
ActionFamily77Status action_family_77_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily77Decoded *out);

/* Same validation as decode, including complete tail rows. Success sets
 * *body_bytes to 731; failure leaves it unchanged. No input bytes are read. */
ActionFamily77Status action_family_77_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes);

/* output_handle must be nonzero; no allocation or input writes occur. */
ActionFamily77Status action_family_77_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily77Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
