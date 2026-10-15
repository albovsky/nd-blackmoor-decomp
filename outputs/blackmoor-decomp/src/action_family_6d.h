#ifndef BLACKMOOR_ACTION_FAMILY_6D_H
#define BLACKMOOR_ACTION_FAMILY_6D_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_6D_RAW_TYPE UINT8_C(0x6d)
#define ACTION_FAMILY_6D_RUNTIME_TYPE UINT8_C(0x6d)
#define ACTION_FAMILY_6D_BODY_BYTES 1u
#define ACTION_FAMILY_6D_OBJECT_BYTES 1u
#define ACTION_FAMILY_6D_DEPENDENCY_BYTES 16u

typedef enum {
    ACTION_FAMILY_6D_OK = 0,
    ACTION_FAMILY_6D_ERR_ARGUMENT = 1,
    ACTION_FAMILY_6D_ERR_BODY = 2,
    ACTION_FAMILY_6D_ERR_TAIL = 3,
    ACTION_FAMILY_6D_ERR_BOUNDS = 4,
    ACTION_FAMILY_6D_ERR_OVERLAP = 5
} ActionFamily6DStatus;

/* byte_0 is the neutral first (and only) typed body byte at raw-body+0. The
 * loader copies a fixed one-byte prefix without examining it: there is no
 * count, signedness, bound or NUL scan, and no semantic name is claimed.
 * Dependencies are borrowed, unevaluated 16-byte rows. */
typedef struct {
    uint8_t byte_0;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes;
    size_t available_body_bytes;
} ActionFamily6DDecoded;

/* Successful loader arm [0x40e18b,0x40e250), inline in loader 0x40b34a (no
 * constructor call): malloc(1) at 0x40e18d, store the pointer in action+0x32
 * (before its NULL check), copy one byte, then advance the consumed offset and
 * afterwards the cursor by 1. No defaults or owner links are added by the
 * loader arm. result_slot_handle is an opaque nonzero x86 pointer value, never
 * a host address. Payload offset arithmetic wraps modulo 2^32. Raw and
 * normalized runtime type remain 0x6d (the arm never rewrites the type byte).
 * Subtype is preserved by the enclosing loader and is not read by the arm; it
 * is not an input to this isolated raw-body API. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_6D_OBJECT_BYTES];
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
} ActionFamily6DConstructed;

/* Native safety statuses, not original return values. Caller supplies
 * readable raw_body[raw_body_length] and writable output. All failures
 * leave input and output unchanged. Null, wrapped or overlapping spans,
 * an empty body (the original would over-read) and a ragged dependency tail
 * are rejected before input reads. Borrowed dependency_records points to
 * raw_body+1 even for an empty tail; input storage must remain alive while the
 * view is used. No host effects, dependency construction/evaluation,
 * lifecycle or runtime are performed. */
ActionFamily6DStatus action_family_6d_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily6DDecoded *out);

/* Same validation as decode, including complete tail rows. Success sets
 * *body_bytes to 1; failure leaves it unchanged. No input bytes are read. */
ActionFamily6DStatus action_family_6d_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_bytes);

/* output_handle must be nonzero; no allocation or input writes occur. */
ActionFamily6DStatus action_family_6d_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily6DConstructed *out);

#ifdef __cplusplus
}
#endif
#endif
