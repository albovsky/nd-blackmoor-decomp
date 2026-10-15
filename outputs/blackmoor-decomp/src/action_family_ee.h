#ifndef BLACKMOOR_ACTION_FAMILY_EE_H
#define BLACKMOOR_ACTION_FAMILY_EE_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_EE_RAW_TYPE UINT8_C(0xee)
#define ACTION_FAMILY_EE_RUNTIME_TYPE UINT8_C(0xee)
#define ACTION_FAMILY_EE_BODY_BYTES 5826u
#define ACTION_FAMILY_EE_OBJECT_BYTES 5826u
#define ACTION_FAMILY_EE_WORD_COUNT 2913u
#define ACTION_FAMILY_EE_DEPENDENCY_BYTES 16u

typedef enum {
    ACTION_FAMILY_EE_OK = 0,
    ACTION_FAMILY_EE_ERR_ARGUMENT = 1,
    ACTION_FAMILY_EE_ERR_BODY = 2,
    ACTION_FAMILY_EE_ERR_TAIL = 3,
    ACTION_FAMILY_EE_ERR_BOUNDS = 4,
    ACTION_FAMILY_EE_ERR_OVERLAP = 5
} ActionFamilyEEStatus;

/* word[N] is neutral word_N: unsigned little-endian bits at raw-body+2*N.
 * This representation does not claim that string spans or runtime fields
 * are semantically words. The loader copies a fixed 5,826-byte (0x16c2) prefix,
 * without examining any body field, count, signedness or NUL termination.
 * Dependencies are borrowed, unevaluated 16-byte rows. */
typedef struct {
    uint16_t word[ACTION_FAMILY_EE_WORD_COUNT];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes;
    size_t available_body_bytes;
} ActionFamilyEEDecoded;

/* Successful loader arm 0x410785 -> FUN_0047b3f0 (thiscall, this=0x61e398,
 * `ret 0xc`, three arguments: action slot, &cursor, &offset): malloc(0x16c2),
 * store the pointer in action+0x32 (before its NULL check), copy 0x5b0 DWORDs
 * and one WORD (5,826 bytes) to the whole allocation, then advance the
 * consumed offset and afterwards the cursor by 0x16c2. No defaults or owner
 * links are added by the loader arm.
 * result_slot_handle is an opaque nonzero x86 pointer value, never a host
 * address. Payload offset arithmetic wraps modulo 2^32. Raw and normalized
 * runtime type remain 0xee (the arm never rewrites the type byte). Subtype
 * is preserved by the enclosing loader; it is not an input to this isolated
 * raw-body API. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_EE_OBJECT_BYTES];
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
} ActionFamilyEEConstructed;

/* Native safety statuses, not original return values. Caller supplies
 * readable raw_body[raw_body_length] and writable output. All failures
 * leave input and output unchanged. Null, wrapped or overlapping spans,
 * short body and ragged dependency tail are rejected before input reads.
 * Borrowed dependency_records points to raw_body+5826 even for an empty tail;
 * input storage must remain alive while the view is used. No host effects,
 * dependency construction/evaluation, lifecycle or runtime are performed.
 * ERR_BODY covers every body shorter than 5,826 bytes. The corpus has no such
 * record (both are 5,842 bytes); the original loader would copy past the ACT
 * payload, so rejection here is a deliberate native safety result and not an
 * original return value. */
ActionFamilyEEStatus action_family_ee_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamilyEEDecoded *out);

/* Same validation as decode, including complete tail rows. Success sets
 * *body_bytes to 5826; failure leaves it unchanged. No input bytes are read. */
ActionFamilyEEStatus action_family_ee_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes);

/* output_handle must be nonzero; no allocation or input writes occur. */
ActionFamilyEEStatus action_family_ee_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamilyEEConstructed *out);

#ifdef __cplusplus
}
#endif
#endif
