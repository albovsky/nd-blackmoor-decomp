#ifndef BLACKMOOR_ACTION_FAMILY_43_H
#define BLACKMOOR_ACTION_FAMILY_43_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_43_RAW_TYPE UINT8_C(0x43)
#define ACTION_FAMILY_43_RUNTIME_TYPE UINT8_C(0x43)
#define ACTION_FAMILY_43_PREFIX_BYTES 301u
#define ACTION_FAMILY_43_DEPENDENCY_BYTES 16u
#define ACTION_FAMILY_43_MAX_INLINE_BYTES 32767u
#define ACTION_FAMILY_43_MAX_RESOLVED_VISIBLE_BYTES 40000u

/* Native safety results, not original constructor return values. */
typedef enum {
    ACTION_FAMILY_43_OK = 0,
    ACTION_FAMILY_43_ERR_ARGUMENT = 1,
    ACTION_FAMILY_43_ERR_BODY = 2,
    ACTION_FAMILY_43_ERR_TAIL = 3,
    ACTION_FAMILY_43_ERR_BOUNDS = 4,
    ACTION_FAMILY_43_ERR_OVERLAP = 5,
    ACTION_FAMILY_43_ERR_COUNT = 6,
    ACTION_FAMILY_43_ERR_STRING = 7,
    ACTION_FAMILY_43_ERR_CAPACITY = 8
} ActionFamily43Status;

/* Selector +0x109 == 0: 301 + signed LE word at +0x12b. Nonzero:
 * exactly 301 bytes, with a 33-byte lookup key at +0x10a. The native inline
 * domain requires nonnegative count and a NUL inside its declared extent;
 * zero count cannot satisfy that bound. Only inline option_02 is compared
 * (signed <= 2). Other prefix data remain neutral and borrowed via prefix.
 * All borrowed spans live as long as raw_body. No dependencies are evaluated. */
typedef struct {
    uint16_t word_00;
    int16_t option_02;
    uint8_t option_109;
    char key[33];
    uint16_t word_12b;
    const uint8_t *prefix;
    const uint8_t *inline_text;
    size_t inline_visible_length;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes;
    size_t available_body_bytes;
} ActionFamily43Decoded;

/* Successful allocation value model for 0x41137f. Every allocated byte is
 * written, so no prior allocation image is needed. Handles are opaque x86
 * values, never native pointers. Original inline constructor copies first,
 * then rewrites raw+0x12b with strlen(raw+301); its object retains the original
 * count. This API preserves raw_body and reports that write as a value effect.
 * The keyed branch writes strlen(resolved_text) to object+0x12b instead. */
typedef struct {
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t body_bytes_consumed;
    size_t available_body_bytes;
    size_t allocation_bytes;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    uint32_t result_slot_handle;
    uint16_t source_word_12b_after;
    uint8_t source_word_written;
    uint8_t raw_type;
    uint8_t runtime_type;
} ActionFamily43Constructed;

/* Caller supplies readable inputs/writable outputs. Null, wrapped or
 * overlapping spans, truncated prefixes/counts and fractional dependency
 * tails fail before output mutation. Arbitrary-address mappedness is a caller
 * contract. The empty dependency view points one past the typed body. */
ActionFamily43Status action_family_43_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily43Decoded *out);

/* Keyed callers supply an already resolved string, including its sole final
 * NUL, with visible length <=40000. No lookup/host allocation happens here.
 * Inline callers pass NULL/0 for resolved_text. object=NULL,capacity=0 queries
 * the required size and metadata. Otherwise object_capacity must cover the
 * allocation; excess bytes remain untouched. Inputs may alias each other but
 * cannot overlap either output, and the two outputs cannot overlap. All
 * validation precedes writes to both outputs. output_handle must be nonzero;
 * payload offset wraps modulo 2^32 as in the original DWORD addition. */
ActionFamily43Status action_family_43_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    const uint8_t *resolved_text, size_t resolved_text_bytes,
    uint32_t payload_offset_before, uint32_t output_handle,
    uint8_t *object, size_t object_capacity, ActionFamily43Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
