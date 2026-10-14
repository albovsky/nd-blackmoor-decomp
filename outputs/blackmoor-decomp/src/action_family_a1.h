#ifndef BLACKMOOR_ACTION_FAMILY_A1_H
#define BLACKMOOR_ACTION_FAMILY_A1_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_A1_RAW_TYPE UINT8_C(0xa1)
/* The loader retains 0xa1; it does not normalize it to 0x9f. */
#define ACTION_FAMILY_A1_RUNTIME_TYPE UINT8_C(0xa1)
#define ACTION_FAMILY_A1_PREFIX_BYTES 51u
#define ACTION_FAMILY_A1_KEY_BODY_BYTES 84u
#define ACTION_FAMILY_A1_MAX_INLINE_BYTES 9999u
#define ACTION_FAMILY_A1_MAX_RESOLVED_BYTES 32591u
#define ACTION_FAMILY_A1_MAX_OBJECT_BYTES 32767u

typedef enum {
    ACTION_FAMILY_A1_OK = 0,
    ACTION_FAMILY_A1_ERR_ARGUMENT,
    ACTION_FAMILY_A1_ERR_BODY,
    ACTION_FAMILY_A1_ERR_COUNT,
    ACTION_FAMILY_A1_ERR_NAME,
    ACTION_FAMILY_A1_ERR_TAIL,
    ACTION_FAMILY_A1_ERR_BOUNDS,
    ACTION_FAMILY_A1_ERR_OVERLAP,
    ACTION_FAMILY_A1_ERR_TEXT
} ActionFamilyA1Status;

/* Reconstructed values, not original C++ source. Options retain their raw
 * unsigned bits; their runtime interpretation is outside this packet.
 * text_selector is a signed LE word: -1 selects a 33-byte AUTOTEXT key;
 * 0..9999 selects that many inline bytes. name/key are zero-filled after NUL.
 * Inline text and dependency_records borrow the caller's raw_body lifetime. */
typedef struct {
    uint8_t name[33];
    uint16_t option_21;
    uint32_t word_23;
    uint16_t option_27;
    uint16_t option_29;
    uint8_t option_2b;
    uint16_t option_2c;
    uint16_t option_2e;
    uint8_t option_30;
    int16_t text_selector;
    uint8_t text_key[33];
    const uint8_t *inline_text;
    size_t inline_text_bytes;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t body_bytes;
    size_t dependency_bytes;
    size_t available_body_bytes;
} ActionFamilyA1Decoded;

/* Exact initialized allocation image for the successful bounded loader branch
 * 0x40f069..0x40f532 and helper 0x410f99. Only allocation_bytes are original
 * object bytes; remaining array storage is native zero-filled capacity.
 * result_slot_handle models the loader's pData slot, not a native pointer.
 * No separate owner links are written by this loader branch. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_A1_MAX_OBJECT_BYTES];
    size_t allocation_bytes;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t body_bytes_consumed;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    uint32_t result_slot_handle;
} ActionFamilyA1Constructed;

/* Native safety statuses are not original return values. Any failure leaves
 * the entire output unchanged. Input/output spans must not overlap and must
 * be valid accessible storage; integer address wrap is rejected. */
ActionFamilyA1Status action_family_a1_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamilyA1Decoded *out);

/* For key form, caller supplies an already resolved AUTOTEXT value, excluding
 * its terminator, with no embedded NUL. NULL+0 represents a resolved empty
 * value. Missing-key fallback/lookup itself is outside this model. Inline
 * form requires NULL+0 for resolved_text. Text may alias raw input, but may
 * not alias out. The signed allocation word in the original wraps for long
 * AUTOTEXT values: this native API rejects lengths above 32591, separately
 * from the original's 40000-character diagnostic bound. Cursor arithmetic
 * wraps modulo 2^32, as the original DWORD does. */
ActionFamilyA1Status action_family_a1_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    const uint8_t *resolved_text, size_t resolved_text_bytes,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamilyA1Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
