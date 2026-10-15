#ifndef BLACKMOOR_ACTION_FAMILY_45_H
#define BLACKMOOR_ACTION_FAMILY_45_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_45_RAW_TYPE UINT8_C(0x45)
#define ACTION_FAMILY_45_RUNTIME_TYPE UINT8_C(0x45)
#define ACTION_FAMILY_45_PREFIX_BYTES 196u
#define ACTION_FAMILY_45_PREFIX_WORDS 97u
#define ACTION_FAMILY_45_MAX_ENTRIES 10u
#define ACTION_FAMILY_45_ENTRY_BYTES 4u
#define ACTION_FAMILY_45_MAX_OBJECT_BYTES 236u
#define ACTION_FAMILY_45_DEPENDENCY_BYTES 16u

/* Native safety results, not an inferred original return value. */
typedef enum {
    ACTION_FAMILY_45_OK = 0,
    ACTION_FAMILY_45_ERR_ARGUMENT = 1,
    ACTION_FAMILY_45_ERR_BODY = 2,
    ACTION_FAMILY_45_ERR_COUNT = 3,
    ACTION_FAMILY_45_ERR_TAIL = 4,
    ACTION_FAMILY_45_ERR_BOUNDS = 5,
    ACTION_FAMILY_45_ERR_OVERLAP = 6
} ActionFamily45Status;

typedef struct {
    uint16_t word_0;
    uint16_t word_1;
} ActionFamily45Entry;

/* Neutral word bits preserve every prefix/entry byte without interpreting
 * runtime semantics or embedded text. The original signed count at +0xc2 is
 * bounded here to 0..10. Unused entries are zero. dependency_records borrows
 * the input's lifetime and points one past the typed body for an empty tail. */
typedef struct {
    uint8_t raw_type;
    uint8_t runtime_type;
    uint16_t words[ACTION_FAMILY_45_PREFIX_WORDS];
    uint16_t entry_count;
    ActionFamily45Entry entries[ACTION_FAMILY_45_MAX_ENTRIES];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t available_body_bytes;
    size_t body_bytes;
    size_t dependency_bytes;
} ActionFamily45Decoded;

/* Value model of the successful inline loader at 0x40d4ed..0x40d6aa.
 * Exactly output_allocation_bytes of object_bytes model the original malloc
 * allocation; remaining capacity is zero and is not part of that allocation.
 * Handles are opaque x86 model values, not native pointers. No allocation,
 * dependency construction, dispatch or host effects occur here. */
typedef struct {
    uint8_t object_bytes[ACTION_FAMILY_45_MAX_OBJECT_BYTES];
    const uint8_t *dependency_records;
    size_t dependency_count;
    size_t dependency_bytes;
    size_t available_body_bytes;
    size_t body_bytes_consumed;
    uint32_t payload_offset_before;
    uint32_t payload_offset_after;
    uint32_t output_handle;
    uint32_t result_slot_handle;
    uint32_t output_allocation_bytes;
} ActionFamily45Constructed;

/* Readable input and writable output are caller contracts. Null/wrapped/
 * overlapping spans, short bodies, negative or >10 counts, and fractional
 * tails fail before output mutation. The original's unsafe negative-count
 * path is deliberately rejected rather than reproduced. */
ActionFamily45Status action_family_45_decode(
    const uint8_t *raw_body, size_t raw_body_length, ActionFamily45Decoded *out);

/* output_handle must be nonzero; DWORD offset addition wraps modulo 2^32. */
ActionFamily45Status action_family_45_construct(
    const uint8_t *raw_body, size_t raw_body_length,
    uint32_t payload_offset_before, uint32_t output_handle,
    ActionFamily45Constructed *out);

#ifdef __cplusplus
}
#endif
#endif
