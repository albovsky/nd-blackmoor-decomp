#ifndef BLACKMOOR_ACTION_FAMILY_EA_H
#define BLACKMOOR_ACTION_FAMILY_EA_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_EA_RAW_TYPE UINT8_C(0xea)
#define ACTION_FAMILY_EA_RUNTIME_TYPE UINT8_C(0xea)
#define ACTION_FAMILY_EA_BODY_BYTES 3847u
#define ACTION_FAMILY_EA_OBJECT_BYTES 3847u
#define ACTION_FAMILY_EA_DEPENDENCY_BYTES 16u

typedef enum {
    ACTION_FAMILY_EA_OK = 0,
    ACTION_FAMILY_EA_ERR_ARGUMENT = 1,
    ACTION_FAMILY_EA_ERR_BODY = 2,
    ACTION_FAMILY_EA_ERR_TAIL = 3,
    ACTION_FAMILY_EA_ERR_BOUNDS = 4,
    ACTION_FAMILY_EA_ERR_OVERLAP = 5
} ActionFamilyEaStatus;

/* byte[N] is neutral byte_N: raw-body byte N, N = 0..3846. The original
 * loader (arm 0x410893 -> method 0x484110) copies a fixed 3,847-byte prefix
 * (0x3c1 DWORDs, one WORD, one BYTE) without examining any field, count,
 * signedness or NUL termination, so no field names or widths are claimed
 * here. Dependencies are borrowed, unevaluated 16-byte rows. */
typedef struct {
    uint8_t byte[ACTION_FAMILY_EA_BODY_BYTES];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes;
    size_t available_body_bytes;
} ActionFamilyEaDecoded;

/* Successful loader model: malloc(0xf07), copy the 3,847 raw-body bytes over
 * the whole allocation, store its pointer in action+0x32, add 0xf07 to the
 * payload offset then to the cursor. No defaults or owner links are added.
 * result_slot_handle is an opaque nonzero x86 pointer value, never a host
 * address. Payload offset arithmetic wraps modulo 2^32. Raw and runtime type
 * remain 0xea; the subtype is preserved by the enclosing loader and is not
 * an input to this isolated raw-body API. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_EA_OBJECT_BYTES];
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
} ActionFamilyEaConstructed;

/* Native safety statuses, not original return values. Caller supplies
 * readable raw_body[raw_body_length] and writable output. All failures leave
 * input and output unchanged. Null, wrapped or overlapping spans, a body
 * shorter than 3,847 bytes and a dependency tail that is not a multiple of 16
 * bytes are rejected before input reads. Borrowed dependency_records points
 * to raw_body+3847 even for an empty tail; input storage must remain alive
 * while the view is used. No host effects, dependency construction or
 * evaluation, lifecycle or runtime are performed. */
ActionFamilyEaStatus action_family_ea_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamilyEaDecoded *out);

/* Same validation as decode, including complete tail rows. Success sets
 * *body_bytes to 3847; failure leaves it unchanged. No input bytes are read. */
ActionFamilyEaStatus action_family_ea_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes);

/* output_handle must be nonzero; no allocation or input writes occur. */
ActionFamilyEaStatus action_family_ea_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamilyEaConstructed *out);

#ifdef __cplusplus
}
#endif
#endif
