#ifndef BLACKMOOR_ACTION_FAMILY_3F_H
#define BLACKMOOR_ACTION_FAMILY_3F_H
#include <stddef.h>
#include <stdint.h>
#ifdef __cplusplus
extern "C" {
#endif
#define ACTION_FAMILY_3F_RAW_TYPE UINT8_C(0x3f)
#define ACTION_FAMILY_3F_RUNTIME_TYPE UINT8_C(0x3f)
#define ACTION_FAMILY_3F_PREFIX_BYTES 77u
#define ACTION_FAMILY_3F_OBJECT_BYTES 0x7a5u
#define ACTION_FAMILY_3F_PRIMARY_OBJECT_BYTES 0x1d1u
#define ACTION_FAMILY_3F_DEPENDENCY_BYTES 16u

/* Native safety results, not original return values. */
typedef enum {
    ACTION_FAMILY_3F_OK = 0,
    ACTION_FAMILY_3F_ERR_ARGUMENT = 1,
    ACTION_FAMILY_3F_ERR_BODY = 2,
    ACTION_FAMILY_3F_ERR_COUNT = 3,
    ACTION_FAMILY_3F_ERR_NAME = 4,
    ACTION_FAMILY_3F_ERR_TAIL = 5,
    ACTION_FAMILY_3F_ERR_BOUNDS = 6,
    ACTION_FAMILY_3F_ERR_OVERLAP = 7,
    ACTION_FAMILY_3F_ERR_TEXT = 8,
    ACTION_FAMILY_3F_ERR_CAPACITY = 9
} ActionFamily3fStatus;

/* Names/keys are copied through first NUL and padded with zero. All views
 * borrow the input resource. The primary view contains primary_count records:
 * two-byte slot (signed LOW BYTE condition count; high byte ignored), count*5
 * condition bytes, 33-byte text key, 33-byte name, LE word. The secondary view
 * contains secondary_count records: same count slot and conditions, LE DWORD.
 * Primary count at body+75 is a signed 16-bit word. Secondary count is a signed
 * low byte in the two-byte slot between the views. Negative counts are native
 * safety rejections; all nonnegative ranges of the original widths are allowed.
 * The neutral borrowed record views expose fields without assigning behavior.
 */
typedef struct {
    uint8_t raw_type;
    uint8_t runtime_type;
    uint8_t name[33];
    uint16_t option_21;
    uint8_t text_key[33];
    uint8_t option_44;
    uint8_t option_45;
    uint8_t option_46;
    uint16_t word_47;
    uint16_t word_49;
    int16_t primary_count;
    int16_t secondary_count;
    const uint8_t *primary_records;
    size_t primary_bytes;
    const uint8_t *secondary_records;
    size_t secondary_bytes;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t body_bytes;
    size_t dependency_bytes;
    size_t available_body_bytes;
} ActionFamily3fDecoded;

typedef struct {
    const uint8_t *bytes;
    size_t length;
} ActionFamily3fText;

/* Successful-allocation value model for 0x41c7f4 and its 0x3f helpers.
 * Arena allocations follow the original order, each start aligned to 4 bytes:
 * main object, primary table (if nonempty), each primary condition allocation,
 * secondary table (if nonempty), each secondary condition allocation.
 * Logical x86 handles are arena_handle+allocation offset, never host pointers.
 * Bytes untouched by the original remain as supplied in arena; the original
 * DOES NOT zero malloc memory. Alignment padding likewise remains unchanged.
 * A caller can initialize arena to its allocator's desired memory state.
 * No gameplay, lifecycle, dependency evaluation or original C++ provenance is
 * claimed. SIZE_MAX offsets represent absent tables.
 */
typedef struct {
    size_t arena_bytes;
    size_t allocation_count;
    size_t primary_offset;
    size_t secondary_offset;
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t body_bytes_consumed;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    uint32_t result_slot_handle;
} ActionFamily3fConstructed;

/* Full input validation precedes any output mutation. All output/input spans
 * must be disjoint. Typed size is 77 + primary-record bytes + 2 + secondary-
 * record bytes; residual dependency tail must be divisible by 16. */
ActionFamily3fStatus action_family_3f_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily3fDecoded *out);
ActionFamily3fStatus action_family_3f_body_length(
    const uint8_t *raw_body, size_t raw_body_length, size_t *body_length);

/* resolved_text has exactly primary_count+1 entries: main key at index zero,
 * then each primary key, resolved by the CONVO table's original case-insensitive
 * first-match lookup (0x423259, table 0x6187b9). This API does not perform lookup
 * or missing-key fallback. Empty text may have NULL bytes; embedded NUL ends
 * visible text. Max visible lengths 1499/399 keep strings in their object fields.
 * NULL arena with capacity zero queries layout; out is written on success.
 * A nonzero arena_handle must cover the entire layout without 32-bit wrap.
 * Invalid input leaves arena and out unchanged. Texts must remain stable through
 * the call and must not overlap either output; no callbacks or allocation occur.
 * The payload cursor advances modulo 2^32, exactly as the original DWORD.
 */
ActionFamily3fStatus action_family_3f_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    const ActionFamily3fText *resolved_text, size_t resolved_text_count,
    uint32_t payload_offset_before, uint32_t arena_handle,
    uint8_t *arena, size_t arena_capacity, ActionFamily3fConstructed *out);
#ifdef __cplusplus
}
#endif
#endif
