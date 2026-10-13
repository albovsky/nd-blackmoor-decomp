#ifndef BLACKMOOR_ACTION_FAMILY_64_H
#define BLACKMOOR_ACTION_FAMILY_64_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define ACTION_FAMILY_64_TYPE UINT8_C(0x64)
#define ACTION_FAMILY_64_BODY_BYTES 5u

typedef enum action_family64_status {
    ACTION_FAMILY64_OK = 0,
    ACTION_FAMILY64_ERR_ARGUMENT = 1,
    ACTION_FAMILY64_ERR_BODY = 2,
    ACTION_FAMILY64_ERR_UNSUPPORTED = 3,
    ACTION_FAMILY64_ERR_BACKEND = 4
} ActionFamily64Status;

typedef enum action_family64_backend_status {
    ACTION_FAMILY64_BACKEND_OK = 0,
    ACTION_FAMILY64_BACKEND_UNSUPPORTED = 1,
    ACTION_FAMILY64_BACKEND_ERROR = 2
} ActionFamily64BackendStatus;

typedef struct action_family64_decoded {
    uint8_t operation;
    int16_t value_1;
    int16_t value_2;
} ActionFamily64Decoded;

/* Neutral snapshots of the original globals and fixed controller fields.
 * The numeric suffixes are original addresses/offsets, not claims about the
 * host application's semantic naming. The one-byte field at +0x326 aliases
 * absolute global DAT_0061c6ad in the original executable. */
typedef struct action_family64_world {
    int16_t clock_value_585d51;
    int16_t clock_value_585d4f;
    int32_t clock_total_585d4b;
    uint32_t clock_deadline_585d55;
    int16_t deadline_offset_5b0280;
    uint32_t timer_controller_active_001c;
    uint32_t timer_controller_tick_0456;
    uint8_t timer_controller_flag_0326_0061c6ad;
} ActionFamily64World;

typedef struct action_family64_input {
    uint8_t type;
    uint8_t subtype;
    /* The caller supplies the result of running-state, loaded/completion, and
     * dependency gates before dispatching this one action. */
    uint8_t eligible;
    uint8_t completed_before;
    uint32_t phase_before;
    /* Original typed action body only; never include dependency records. */
    const uint8_t *body;
    size_t body_length;
} ActionFamily64Input;

typedef ActionFamily64BackendStatus (*ActionFamily64GetTickCountFn)(
    void *context, uint32_t *tick_count);

typedef struct action_family64_backend {
    void *context;
    /* Original GetTickCount import at IAT slot VA 0x52a23c. The original
     * mode-3 active-controller branch reads it before the common deadline
     * update, so this callback may be called twice for one action. */
    ActionFamily64GetTickCountFn get_tick_count;
} ActionFamily64Backend;

typedef struct action_family64_result {
    uint8_t recognized;
    uint8_t applied;
    uint8_t completion_valid;
    uint8_t completed;
    uint8_t reset_dependencies;
    uint32_t phase;
    ActionFamily64World world;
} ActionFamily64Result;

/* Decode the exact five-byte source-loader body: u8 operation, then two
 * possibly unaligned signed little-endian i16 values. On error, outputs stay
 * unchanged. `consumed` reports the proven typed boundary (5), excluding
 * trailing dependency records. */
int action_family64_decode(const uint8_t *body, size_t body_length,
                           ActionFamily64Decoded *decoded, size_t *consumed);

/* Apply one already-scheduled type-0x64 action to a caller-owned world
 * snapshot. False eligibility makes no writes or host calls. Successful
 * handler calls always reset phase to zero; subtype 1 completes, subtype 2
 * clears completion and requests the owning executor to reset dependencies,
 * other subtype values preserve completion. World/result commit only after
 * required GetTickCount calls succeed. */
int action_family64_step(const ActionFamily64Input *action,
                         const ActionFamily64World *world,
                         ActionFamily64Backend *backend,
                         ActionFamily64Result *result);

const char *action_family64_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
