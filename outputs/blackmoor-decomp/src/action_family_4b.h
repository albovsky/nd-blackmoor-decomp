#ifndef BLACKMOOR_ACTION_FAMILY_4B_H
#define BLACKMOOR_ACTION_FAMILY_4B_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_4B_RAW_TYPE UINT8_C(0x4b)
/* The raw loader arm does not rewrite the runtime type. */
#define ACTION_FAMILY_4B_RUNTIME_TYPE UINT8_C(0x4b)
#define ACTION_FAMILY_4B_KEY_BODY_BYTES 35u
#define ACTION_FAMILY_4B_MAX_INLINE_BYTES 9999u
#define ACTION_FAMILY_4B_MAX_RESOLVED_BYTES 32761u
#define ACTION_FAMILY_4B_MAX_OBJECT_BYTES 32767u
#define ACTION_FAMILY_4B_DEPENDENCY_BYTES 16u

/* Native safety results, not original loader return values. */
typedef enum {
    ACTION_FAMILY_4B_OK = 0,
    ACTION_FAMILY_4B_ERR_ARGUMENT = 1,
    ACTION_FAMILY_4B_ERR_BODY = 2,
    ACTION_FAMILY_4B_ERR_COUNT = 3,
    ACTION_FAMILY_4B_ERR_KEY = 4,
    ACTION_FAMILY_4B_ERR_TAIL = 5,
    ACTION_FAMILY_4B_ERR_BOUNDS = 6,
    ACTION_FAMILY_4B_ERR_OVERLAP = 7,
    ACTION_FAMILY_4B_ERR_TEXT = 8
} ActionFamily4BStatus;

/* text_selector is signed LE16: -1 selects a 33-byte AUTOTEXT key;
 * 0..9999 selects that many inline bytes. text_key is zero-filled after NUL.
 * Inline bytes may include NUL and are not treated as a C string. Borrowed
 * input views remain valid only for the caller's raw_body lifetime. */
typedef struct {
    int16_t text_selector;
    uint8_t text_key[33];
    const uint8_t *inline_text;
    size_t inline_text_bytes;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t body_bytes;
    size_t dependency_bytes;
    size_t available_body_bytes;
} ActionFamily4BDecoded;

/* Successful bounded model of inline constructor code 0x40c625..0x40caac.
 * Only allocation_bytes belong to the original object; unused native array
 * capacity is zero-filled. Original initialized every allocated byte.
 * Key form: LE16(length+3), resolved bytes, "<e>\0", allocation length+6.
 * Inline form: LE16(selector+3), inline bytes, "<e>", allocation selector+5
 * (no extra NUL). Opaque x86 result_slot_handle is not a native pointer.
 * No lookup, allocation, text display, dependency evaluation or runtime here. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_4B_MAX_OBJECT_BYTES];
    size_t allocation_bytes;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t available_body_bytes;
    size_t body_bytes_consumed;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    uint32_t result_slot_handle;
} ActionFamily4BConstructed;

/* Readable input and writable output storage are caller contracts. All null,
 * short, malformed, wrapped or overlapping spans fail before output mutation.
 * Each function validates both the typed extent and the 16-byte tail modulus.
 * The registration proposal uses inline arithmetic, with no module dependency. */
ActionFamily4BStatus action_family_4b_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out_length);
ActionFamily4BStatus action_family_4b_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily4BDecoded *out);

/* Key form requires a resolved AUTOTEXT value excluding its terminator and
 * without embedded NUL; NULL+0 represents a resolved empty value. Inline form
 * requires NULL+0. Text may alias raw input, but may not alias out.
 * The original diagnostic accepts length<=40000, but its signed allocation
 * word wraps above 32761: native rejects those unsafe sizes independently.
 * A nonzero output_handle is required. Payload offsets wrap modulo 2^32. */
ActionFamily4BStatus action_family_4b_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    const uint8_t *resolved_text, size_t resolved_text_bytes,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily4BConstructed *out);

#ifdef __cplusplus
}
#endif
#endif
