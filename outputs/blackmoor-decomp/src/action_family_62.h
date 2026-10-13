#ifndef BLACKMOOR_ACTION_FAMILY_62_H
#define BLACKMOOR_ACTION_FAMILY_62_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_62_RAW_TYPE UINT8_C(0x62)
#define ACTION_FAMILY_62_PREFIX_BYTES 12u
#define ACTION_FAMILY_62_ENTRY_BYTES 18u
#define ACTION_FAMILY_62_ENTRY_WORDS 9u
#define ACTION_FAMILY_62_EVENT_WRITES 2u
#define ACTION_FAMILY_62_CURSOR_WORDS 4u

typedef enum action_family_62_status {
    ACTION_FAMILY_62_OK = 0,
    ACTION_FAMILY_62_ERR_ARGUMENT = 1,
    ACTION_FAMILY_62_ERR_TYPE = 2,
    ACTION_FAMILY_62_ERR_BODY = 3,
    ACTION_FAMILY_62_ERR_COUNT = 4,
    ACTION_FAMILY_62_ERR_BACKEND = 5
} ActionFamily62Status;

typedef struct action_family_62_entry {
    int16_t words[ACTION_FAMILY_62_ENTRY_WORDS];
} ActionFamily62Entry;

/* A view over the original raw body. The count-driven typed body ends at
 * typed_body_length; dependency_bytes/dependency_length retain the separate
 * tail without interpreting it. The view borrows raw_body, which must remain
 * alive until the caller finishes using this decoded value. */
typedef struct action_family_62_decoded {
    uint8_t raw_type;
    uint8_t reserved;
    int16_t event_ids[ACTION_FAMILY_62_EVENT_WRITES];
    int16_t event_values[ACTION_FAMILY_62_EVENT_WRITES];
    int16_t threshold;
    int16_t entry_count;
    size_t typed_body_length;
    const uint8_t *raw_body;
    size_t raw_body_length;
    const uint8_t *dependency_bytes;
    size_t dependency_length;
} ActionFamily62Decoded;

/* The caller owns dependency eligibility and phase scheduling. Selector is
 * the signed 16-bit runtime value compared with entry word 0 (the first stored
 * word). Response words are copied from entry words 1, 3, 5, and 7 without
 * assigning higher-level meanings to those fields. */
typedef struct action_family_62_input {
    uint8_t subtype;
    uint8_t eligible;
    uint8_t completed_before;
    uint8_t reserved;
    int32_t phase_before;
    int16_t selector;
} ActionFamily62Input;

typedef struct action_family_62_event_write {
    int16_t event_id;
    int16_t value;
} ActionFamily62EventWrite;

/* Exact state effects produced by the recovered handler. Event IDs and
 * selector-response words stay signed/raw; a host must bounds-check event IDs
 * against its own event-flag storage before applying this result. */
typedef struct action_family_62_result {
    uint8_t recognized;
    uint8_t applied;
    uint8_t phase_written;
    int32_t phase_after;
    uint8_t start_global_written;
    uint8_t start_global_value;
    uint8_t request_written;
    uint8_t request_value;
    uint8_t response_written;
    int16_t response_words[ACTION_FAMILY_62_CURSOR_WORDS];
    uint8_t completion_written;
    uint8_t completed_after;
    uint8_t dependency_reset_requested;
    uint8_t event_write_count;
    ActionFamily62EventWrite event_writes[ACTION_FAMILY_62_EVENT_WRITES];
} ActionFamily62Result;

/* Optional native commit bridge. If supplied, it receives the complete typed
 * result once and must apply it atomically. Return 0 on success. A nonzero
 * return becomes ACTION_FAMILY_62_ERR_BACKEND; the caller must then leave its
 * phase/completion state uncommitted. With a NULL backend, the caller applies
 * the returned effects itself. */
typedef int (*ActionFamily62ApplyResultFn)(void *context,
                                           const ActionFamily62Result *result);

typedef struct action_family_62_backend {
    void *context;
    ActionFamily62ApplyResultFn apply_result_atomically;
} ActionFamily62Backend;

/* Parse only raw type 0x62. raw_body_length includes any dependency tail.
 * The original constructor stores `12 + count*18` into a signed short, so
 * larger typed bodies are rejected before any pointer arithmetic. */
ActionFamily62Status action_family_62_decode(uint8_t raw_type,
                                            const uint8_t *raw_body,
                                            size_t raw_body_length,
                                            ActionFamily62Decoded *decoded);

/* Copy one entry from the borrowed raw body using bounded little-endian reads. */
ActionFamily62Status action_family_62_entry_at(
    const ActionFamily62Decoded *decoded,
    size_t entry_index,
    ActionFamily62Entry *entry);

/* Reduce one eligible/ineligible handler call. `phase_before` remains the
 * executor's authoritative value; no hidden phase state is maintained here. */
ActionFamily62Status action_family_62_step(
    const ActionFamily62Decoded *decoded,
    const ActionFamily62Input *input,
    const ActionFamily62Backend *backend,
    ActionFamily62Result *result);

const char *action_family_62_status_string(ActionFamily62Status status);

#ifdef __cplusplus
}
#endif

#endif
