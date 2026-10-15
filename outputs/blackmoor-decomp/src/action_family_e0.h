#ifndef BLACKMOOR_ACTION_FAMILY_E0_H
#define BLACKMOOR_ACTION_FAMILY_E0_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_E0_RAW_TYPE UINT8_C(0xe0)
#define ACTION_FAMILY_E0_RUNTIME_TYPE UINT8_C(0xe0)
#define ACTION_FAMILY_E0_BODY_BYTES 294u
#define ACTION_FAMILY_E0_OBJECT_BYTES 294u
#define ACTION_FAMILY_E0_WORD_COUNT 147u
#define ACTION_FAMILY_E0_DEPENDENCY_BYTES 16u

typedef enum {
    ACTION_FAMILY_E0_OK = 0,
    ACTION_FAMILY_E0_ERR_ARGUMENT = 1,
    ACTION_FAMILY_E0_ERR_BODY = 2,
    ACTION_FAMILY_E0_ERR_TAIL = 3,
    ACTION_FAMILY_E0_ERR_BOUNDS = 4,
    ACTION_FAMILY_E0_ERR_OVERLAP = 5
} ActionFamilyE0Status;

/* word[N] is neutral word_N: unsigned little-endian bits at raw-body+2*N.
 * This representation does not claim that string spans or runtime fields
 * are semantically words. The loader copies a fixed 294-byte (0x126) prefix,
 * without examining any body field, count, signedness or NUL termination.
 * Dependencies are borrowed, unevaluated 16-byte rows. */
typedef struct {
    uint16_t word[ACTION_FAMILY_E0_WORD_COUNT];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes;
    size_t available_body_bytes;
} ActionFamilyE0Decoded;

/* Successful loader arm 0x41053a -> FUN_00470e8e (thiscall, this=0x62387c,
 * fourth argument 1 selects the 0x126-byte variant; the flag-0 variant used by
 * raw 0xd6 allocates 0x6c5 bytes and is not part of this API):
 * malloc(0x126), store the pointer in action+0x32 (before its NULL check),
 * copy 0x49 DWORDs and one WORD (294 bytes) to the whole allocation, then
 * advance the consumed offset and afterwards the cursor by 0x126. No defaults
 * or owner links are added by the loader arm.
 * result_slot_handle is an opaque nonzero x86 pointer value, never a host
 * address. Payload offset arithmetic wraps modulo 2^32. Raw and normalized
 * runtime type remain 0xe0 (the arm never rewrites the type byte). Subtype
 * is preserved by the enclosing loader; it is not an input to this isolated
 * raw-body API. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_E0_OBJECT_BYTES];
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
} ActionFamilyE0Constructed;

/* Native safety statuses, not original return values. Caller supplies
 * readable raw_body[raw_body_length] and writable output. All failures
 * leave input and output unchanged. Null, wrapped or overlapping spans,
 * short body and ragged dependency tail are rejected before input reads.
 * Borrowed dependency_records points to raw_body+294 even for an empty tail;
 * input storage must remain alive while the view is used. No host effects,
 * dependency construction/evaluation, lifecycle or runtime are performed.
 * ERR_BODY covers every body shorter than 294 bytes. The corpus has one such
 * record (resource 1737, action 0: 292 bytes); the original loader would copy
 * 294 bytes (two bytes past the ACT), advance beyond the ACT length and abort in
 * the dependency stage (0x424aa8, ragged-tail fatal exit), so rejection here is a
 * deliberate safety result and not an original return value. */
ActionFamilyE0Status action_family_e0_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamilyE0Decoded *out);

/* Same validation as decode, including complete tail rows. Success sets
 * *body_bytes to 294; failure leaves it unchanged. No input bytes are read. */
ActionFamilyE0Status action_family_e0_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes);

/* output_handle must be nonzero; no allocation or input writes occur. */
ActionFamilyE0Status action_family_e0_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamilyE0Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
