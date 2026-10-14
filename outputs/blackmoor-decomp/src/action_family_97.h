#ifndef BLACKMOOR_ACTION_FAMILY_97_H
#define BLACKMOOR_ACTION_FAMILY_97_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_97_RAW_TYPE UINT8_C(0x97)
#define ACTION_FAMILY_97_RUNTIME_TYPE UINT8_C(0x9f)
#define ACTION_FAMILY_97_MAX_COUNT 9u
#define ACTION_FAMILY_97_NAME_BYTES 33u
#define ACTION_FAMILY_97_DEPENDENCY_BYTES 16u
#define ACTION_FAMILY_97_MAX_ALLOCATION 32767u

/* Native safety results, not return values inferred from GAME.EXE. */
typedef enum {
    ACTION_FAMILY_97_OK = 0,
    ACTION_FAMILY_97_ERR_ARGUMENT = 1,
    ACTION_FAMILY_97_ERR_BODY = 2,
    ACTION_FAMILY_97_ERR_COUNT = 3,
    ACTION_FAMILY_97_ERR_NAME = 4,
    ACTION_FAMILY_97_ERR_SELECTOR = 5,
    ACTION_FAMILY_97_ERR_TAIL = 6,
    ACTION_FAMILY_97_ERR_BOUNDS = 7,
    ACTION_FAMILY_97_ERR_OVERLAP = 8,
    ACTION_FAMILY_97_ERR_LOOKUP = 9,
    ACTION_FAMILY_97_ERR_CAPACITY = 10
} ActionFamily97Status;

typedef struct {
    int16_t selector;
    /* Borrowed 33-byte key for -1, or selector inline bytes for >= 0. */
    const uint8_t *bytes;
    size_t length;
    size_t body_offset; /* Offset of the signed selector, before bytes. */
} ActionFamily97Entry;

/* Names are exact fixed fields, including bytes after NUL. Neutral field
 * labels use offsets relative to the final name, the original helper input.
 * All entry/dependency views expire with the input resource. */
typedef struct {
    uint8_t raw_type;
    uint8_t runtime_type;
    int16_t count;
    uint8_t names[ACTION_FAMILY_97_MAX_COUNT][ACTION_FAMILY_97_NAME_BYTES];
    uint16_t word_21;
    uint32_t word_23;
    uint16_t word_27;
    uint16_t word_29;
    uint8_t option_2b;
    uint16_t word_2c;
    ActionFamily97Entry entries[ACTION_FAMILY_97_MAX_COUNT];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t available_body_bytes;
    size_t body_bytes;
    size_t dependency_bytes;
} ActionFamily97Decoded;

typedef enum {
    ACTION_FAMILY_97_LOOKUP_FOUND = 0,
    ACTION_FAMILY_97_LOOKUP_MISSING = 1,
    ACTION_FAMILY_97_LOOKUP_FAILED = 2
} ActionFamily97LookupStatus;

/* A provider for original 0x423259 on table 0x619a6b. It must follow the
 * original case-insensitive lookup and supply a stable bounded span through
 * this call. Text length may include an embedded NUL; the first NUL ends the
 * visible text. A span without NUL is accepted as exactly text_length bytes.
 * Providers must not mutate raw_body, payload, or out. */
typedef ActionFamily97LookupStatus (*ActionFamily97AutoTextLookup)(
    void *context, const uint8_t *key, size_t key_length,
    const uint8_t **text, size_t *text_length);

/* Value model for the allocation built inside loader 0x40b34a's raw-0x97
 * branch 0x40f532..0x40fd17. The allocation is returned separately as payload.
 * names_after models the original in-place removal of every leading '*';
 * the last marked name wins and bypasses rand. No input bytes are modified.
 * Otherwise rand's original 32-bit LCG advances the caller-supplied state
 * once and its 15-bit result selects an alternative. No process RNG is used.
 * Subtype, dependency evaluation and runtime execution are outside this API. */
typedef struct {
    uint8_t names_after[ACTION_FAMILY_97_MAX_COUNT][ACTION_FAMILY_97_NAME_BYTES];
    uint16_t selected_index;
    int16_t selector;
    uint8_t raw_type;
    uint8_t runtime_type;
    uint8_t random_advanced;
    uint32_t random_state_before;
    uint32_t random_state_after;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    size_t allocation_bytes;
    size_t body_bytes_consumed;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
} ActionFamily97Constructed;

/* Signed count 1..9; fixed span 2 + 33*(count-1) + 46; count entries of
 * 35 bytes for selector -1 or 2+selector bytes for nonnegative selectors.
 * The entry-byte sum must fit signed 16 bits, as used by the loader cursor.
 * Other negative selectors and nonpositive counts are deliberate safety
 * rejections of unsafe original paths. Tail must be a multiple of 16.
 * Invalid inputs leave out unchanged. Input and output cannot overlap. */
ActionFamily97Status action_family_97_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily97Decoded *out);

/* Same validation as decode; writes only on success. */
ActionFamily97Status action_family_97_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_length);

/* Build the complete zero-initialized original allocation, including the
 * 0x410f99 defaults, selected fixed name, and text/marker at +0xaa/+0xac.
 * NULL payload with capacity 0 queries its required size. A lookup is needed
 * only if the selected entry is -1; a missing key uses the recovered error
 * message. Allocation/visible text overflow is rejected before writes.
 * On any error payload and out remain unchanged. All supplied output spans
 * must be disjoint from each other, raw_body and the provider text span.
 * This models successful allocation only; it does not perform host effects
 * or claim original C++/compiler provenance. */
ActionFamily97Status action_family_97_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t random_state_before, uint32_t payload_offset_before,
    ActionFamily97AutoTextLookup lookup, void *lookup_context,
    uint8_t *payload, size_t payload_capacity, ActionFamily97Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
