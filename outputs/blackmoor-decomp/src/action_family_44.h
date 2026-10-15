#ifndef BLACKMOOR_ACTION_FAMILY_44_H
#define BLACKMOOR_ACTION_FAMILY_44_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_44_RAW_TYPE UINT8_C(0x44)
#define ACTION_FAMILY_44_RUNTIME_TYPE UINT8_C(0x44)
#define ACTION_FAMILY_44_HEADER_BYTES 528u
#define ACTION_FAMILY_44_DEPENDENCY_BYTES 16u
#define ACTION_FAMILY_44_MAX_TEXT_BYTES 40000u

/* Native safety results, not original return values. */
typedef enum {
    ACTION_FAMILY_44_OK = 0,
    ACTION_FAMILY_44_ERR_ARGUMENT = 1,
    ACTION_FAMILY_44_ERR_BODY = 2,
    ACTION_FAMILY_44_ERR_TAIL = 3,
    ACTION_FAMILY_44_ERR_BOUNDS = 4,
    ACTION_FAMILY_44_ERR_OVERLAP = 5,
    ACTION_FAMILY_44_ERR_TEXT = 6
} ActionFamily44Status;

/* Neutral recovered fields. header, text and dependencies borrow input storage.
 * option_1ec == 0 selects inline text; any nonzero byte selects a 33-byte key.
 * text_bytes excludes NUL. Uninterpreted header bytes are preserved by construct.
 * Inline word_20e is a nonnegative signed16 extent including the bounded NUL;
 * keyed word_20e is retained data and does not control the body boundary. */
typedef struct {
    const uint8_t *header;
    const uint8_t *text;
    size_t text_bytes;
    uint16_t word_02;
    uint16_t word_20e;
    uint8_t option_1ec;
    uint8_t raw_type;
    uint8_t runtime_type;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t available_body_bytes;
    size_t body_bytes;
    size_t dependency_bytes;
} ActionFamily44Decoded;

/* Value/effect model of 0x41166e, not an original object ABI or live handler.
 * Original inline path copies the object BEFORE rewriting the source word20e.
 * Native input stays immutable; source_word_* describes that original write.
 * Keyed path copies 526 header bytes, writes strlen at object+526, then text+NUL.
 * Caller supplies an opaque nonzero allocation handle; no native allocation. */
typedef struct {
    size_t object_bytes;
    size_t body_bytes_consumed;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t available_body_bytes;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    uint32_t result_slot_handle;
    uint16_t word_20e_after;
    uint16_t source_word_20e_after;
    uint8_t source_word_20e_written;
    uint8_t raw_type;
    uint8_t runtime_type;
} ActionFamily44Constructed;

/* Caller guarantees readable/writable storage. Rejects null/wrapped/overlapping
 * spans and malformed bodies before mutation. The length helper validates the
 * complete body/tail and bounded text/key terminator, just like decode. */
ActionFamily44Status action_family_44_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *out);
ActionFamily44Status action_family_44_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily44Decoded *out);

/* resolved_text is caller-resolved original lookup content for keyed bodies,
 * with a NUL inside resolved_text_bytes; inline bodies ignore these arguments.
 * strlen <=40000 is supported, including signed-looking stored WORD values.
 * object == NULL and capacity == 0 queries layout, otherwise requires capacity
 * >= object_bytes. Outputs must be disjoint from input/text and each other;
 * the two read-only inputs may alias. Failures leave
 * metadata, object and input untouched. Offset addition wraps modulo 2^32.
 * Missing lookup and malformed inline strings are safety errors; original UI
 * error/termination paths and out-of-bounds strlen behavior are not modeled. */
ActionFamily44Status action_family_44_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    const uint8_t *resolved_text, size_t resolved_text_bytes,
    uint32_t payload_offset_before, uint32_t allocation_handle,
    uint8_t *object, size_t capacity, ActionFamily44Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
