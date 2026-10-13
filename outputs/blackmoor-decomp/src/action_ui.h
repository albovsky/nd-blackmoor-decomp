#ifndef BLACKMOOR_ACTION_UI_H
#define BLACKMOOR_ACTION_UI_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_UI_PHONE_RECORD_SIZE 41u
#define ACTION_UI_PHONE_KEY_OFFSET 2u
#define ACTION_UI_PHONE_KEY_SIZE 11u
#define ACTION_UI_PHONE_NAME_OFFSET 13u
#define ACTION_UI_PHONE_NAME_SIZE 20u
#define ACTION_UI_CONTROL_GROUP_COUNT 5u
#define ACTION_UI_CONTROL_RANGE_COUNT 50u
#define ACTION_UI_CONTROL_EMPTY_SENTINEL INT16_C(9999)

typedef struct action_ui_control_group {
    int32_t state;
    int16_t starts[ACTION_UI_CONTROL_RANGE_COUNT];
    int16_t ends[ACTION_UI_CONTROL_RANGE_COUNT];
    int32_t codes[ACTION_UI_CONTROL_RANGE_COUNT];
    int32_t availability;
    int32_t flags[3];
} ActionUIControlGroup;

/* Caller-owned state for the bounded native model. `phone_count` is the
 * number of initialized 41-byte rows and `phone_capacity` is the supplied
 * buffer capacity; this does not claim the original table was this size.
 * `nls_mode == 0` selects the recovered ASCII normalizer. The original
 * nonzero NLS/locale branch is not implemented and returns UNSUPPORTED. */
typedef struct action_ui_world {
    uint8_t (*phone_records)[ACTION_UI_PHONE_RECORD_SIZE];
    size_t phone_count;
    size_t phone_capacity;
    uint8_t nls_mode;
    ActionUIControlGroup controls[ACTION_UI_CONTROL_GROUP_COUNT];
} ActionUIWorld;

typedef enum action_ui_status {
    ACTION_UI_OK = 0,
    ACTION_UI_ERR_ARGUMENT = 1,
    ACTION_UI_ERR_BODY = 2,
    ACTION_UI_ERR_GROUP_BOUNDS = 3,
    ACTION_UI_ERR_PHONE_CAPACITY = 4,
    ACTION_UI_ERR_UNSUPPORTED = 5
} ActionUIStatus;

typedef struct action_ui_action_result {
    uint8_t recognized;
    uint8_t applied;
    uint8_t completed;
    uint32_t phase;
} ActionUIActionResult;

/* Matches original 0x4e1a7e control-group initialization. It does not touch
 * the caller's phone table or replace/reset the ActionUIWorld itself. */
int action_ui_initialize_controls(ActionUIWorld *world);

/* Copies the BOOT UICL source rows and applies the original 0x4e3ade sort,
 * as the New Game path at 0x4e2e05 does. Source rows remain distinct even
 * when their keys or names are equal. Controls are untouched. The supplied
 * buffer capacity belongs to the caller, not the original game. */
int action_ui_initialize_phone(ActionUIWorld *world,
                                const uint8_t (*records)[ACTION_UI_PHONE_RECORD_SIZE],
                                size_t count);

/* Bounded equivalent of original 0x4e7253 for the ASCII normalization mode.
 * A phone record must contain a NUL within its 20-byte display-name field.
 * Invalid existing table rows are rejected before any row or UI bit is changed. */
int action_ui_apply_phone(ActionUIWorld *world,
                          const uint8_t *body,
                          size_t body_length);

/* Bounded equivalent of the generic (code != 1) path in 0x4e13e4.
 * The immediate code-1 path is explicitly unsupported and never mutates state.
 * Group indices outside the five native groups are rejected before writes.
 * The original shift path moves start entries but leaves parallel end/code
 * entries in place (except that the final slot is reset/rewritten); this
 * observed array behavior is retained. */
int action_ui_apply_control(ActionUIWorld *world,
                            const uint8_t *body,
                            size_t body_length);

/* Applies one already-eligible, not-yet-completed action from a verified
 * direct-completion family (0x82 or 0x1d). Eligibility and completed-action
 * skipping belong to the owning runtime. Subtype is ignored, as in the
 * original dispatcher branches; successful actions set completed=1 and
 * preserve phase_before. Unknown types and unsupported code-1 controls return
 * ACTION_UI_ERR_UNSUPPORTED. */
int action_ui_dispatch(ActionUIWorld *world,
                       uint8_t type,
                       uint8_t subtype,
                       const uint8_t *body,
                       size_t body_length,
                       uint32_t phase_before,
                       ActionUIActionResult *result);

const char *action_ui_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
