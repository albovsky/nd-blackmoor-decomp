#ifndef BLACKMOOR_ACTION_FAMILY_1C_H
#define BLACKMOOR_ACTION_FAMILY_1C_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_1C_RAW_TYPE UINT8_C(0x1c)
#define ACTION_FAMILY_1C_RUNTIME_TYPE UINT8_C(0x1c)
#define ACTION_FAMILY_1C_BODY_BYTES 105u
#define ACTION_FAMILY_1C_OBJECT_BYTES 105u
#define ACTION_FAMILY_1C_WORD_COUNT 52u
#define ACTION_FAMILY_1C_DEPENDENCY_BYTES 16u

typedef enum {
    ACTION_FAMILY_1C_OK = 0,
    ACTION_FAMILY_1C_ERR_ARGUMENT = 1,
    ACTION_FAMILY_1C_ERR_BODY = 2,
    ACTION_FAMILY_1C_ERR_TAIL = 3,
    ACTION_FAMILY_1C_ERR_BOUNDS = 4,
    ACTION_FAMILY_1C_ERR_OVERLAP = 5
} ActionFamily1cStatus;

/* word[N] is neutral word_N: unsigned little-endian bits at raw-body+2*N for
 * N in 0..51; byte_104 is the 105th and last body byte. This representation
 * does not claim that any span is semantically a word. The loader copies a
 * fixed 105-byte (0x69) prefix, without examining any body field, count,
 * signedness or NUL termination. Dependencies are borrowed, unevaluated
 * 16-byte rows. */
typedef struct {
    uint16_t word[ACTION_FAMILY_1C_WORD_COUNT];
    uint8_t byte_104;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes;
    size_t available_body_bytes;
} ActionFamily1cDecoded;

/* Successful loader arm 0x40bc1a -> FUN_004caff5 (thiscall, this=0x63847b):
 * FUN_004cc70f(slot, 0x69) mallocs 0x69 bytes, stores the pointer in action+0x32
 * (before its NULL check) and zero-fills the block; then 0x1a DWORDs and one
 * BYTE (105 bytes) are copied from the cursor over the whole allocation, so the
 * zero fill leaves no trace; finally the consumed offset and afterwards the
 * cursor advance by 0x69. No defaults or owner links are added by the arm.
 * result_slot_handle is an opaque nonzero x86 pointer value, never a host
 * address. Payload offset arithmetic wraps modulo 2^32. Raw and normalized
 * runtime type remain 0x1c (the arm never rewrites the type byte). Subtype
 * is preserved by the enclosing loader; it is not an input to this isolated
 * raw-body API. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_1C_OBJECT_BYTES];
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
} ActionFamily1cConstructed;

/* Native safety statuses, not original return values. Caller supplies
 * readable raw_body[raw_body_length] and writable output. All failures
 * leave input and output unchanged. Null, wrapped or overlapping spans,
 * short body and ragged dependency tail are rejected before input reads.
 * Borrowed dependency_records points to raw_body+105 even for an empty tail;
 * input storage must remain alive while the view is used. No host effects,
 * dependency construction/evaluation, lifecycle or runtime are performed. */
ActionFamily1cStatus action_family_1c_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily1cDecoded *out);

/* Same validation as decode, including complete tail rows. Success sets
 * *body_bytes to 105; failure leaves it unchanged. No input bytes are read. */
ActionFamily1cStatus action_family_1c_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes);

/* output_handle must be nonzero; no allocation or input writes occur. */
ActionFamily1cStatus action_family_1c_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily1cConstructed *out);

#ifdef __cplusplus
}
#endif
#endif
