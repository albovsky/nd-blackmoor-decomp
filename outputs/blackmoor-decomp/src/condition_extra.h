#ifndef BLACKMOOR_CONDITION_EXTRA_H
#define BLACKMOOR_CONDITION_EXTRA_H

#include "scene_conditions.h"
#include "world_clock.h"

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

#define CONDITION_EXTRA_TIME_RECORD_COUNT WORLD_CLOCK_TIME_RECORD_COUNT
#define CONDITION_EXTRA_TIME_RECORD_SIZE WORLD_CLOCK_TIME_RECORD_SIZE

typedef enum condition_extra_status {
    CONDITION_EXTRA_OK = 0,
    CONDITION_EXTRA_ERR_ARGUMENT = 1,
    CONDITION_EXTRA_ERR_BOUNDS = 2,
    CONDITION_EXTRA_ERR_UNSUPPORTED_OPCODE = 3,
    CONDITION_EXTRA_ERR_HOST_UNAVAILABLE = 4,
    CONDITION_EXTRA_ERR_HOST_FAILURE = 5,
    CONDITION_EXTRA_ERR_DEBUG_FATAL = 6
} ConditionExtraStatus;

typedef enum condition_extra_trigger {
    CONDITION_EXTRA_TRIGGER_NONE = 0,
    CONDITION_EXTRA_TRIGGER_SELECTED_LEAF = 1,
    CONDITION_EXTRA_TRIGGER_OUTSIDE_WINDOW = 2,
    CONDITION_EXTRA_TRIGGER_TIMER_RECORD = 3,
    CONDITION_EXTRA_TRIGGER_CONTEXT_58C94F = 4,
    CONDITION_EXTRA_TRIGGER_SOUND_QUERY = 5,
    CONDITION_EXTRA_TRIGGER_RANDOM = 6,
    CONDITION_EXTRA_TRIGGER_PRIOR_GATE = 7
} ConditionExtraTrigger;

typedef enum condition_extra_host_status {
    CONDITION_EXTRA_HOST_OK = 0,
    /* No source-equivalent host object/provider was available; no effect was
     * committed by the callback. This is distinct from an observed false. */
    CONDITION_EXTRA_HOST_UNAVAILABLE = 1,
    /* The callback committed a source-equivalent prefix but could not finish. */
    CONDITION_EXTRA_HOST_PARTIAL_FAILURE = 2
} ConditionExtraHostStatus;

/* This callback represents the full original 0x4f6334 query boundary, not a
 * synthetic boolean default. On HOST_OK, `available` is the observed source
 * result (including false) after the callback has applied the sound-manager
 * mutations belonging to that helper. HOST_UNAVAILABLE must not commit a
 * prefix; HOST_PARTIAL_FAILURE reports that callback-owned prefix effects may
 * already be visible. The signed channel is the original fields[1] value. */
typedef ConditionExtraHostStatus (*ConditionExtraSoundQueryFn)(
    void *context, int16_t channel, int32_t *available);

/* Return the original CRT rand() value before `% 100`. The original MSVC CRT
 * domain is 0..32767; callers must not substitute a portable/randomized
 * modulo sample. */
typedef ConditionExtraHostStatus (*ConditionExtraNextRandomFn)(
    void *context, uint32_t *raw_rand_value);

typedef struct condition_extra_session {
    void *context;
    const SceneConditionState *condition_state;
    WorldInitState *world;
    WorldClockSession *clock;
    int16_t context_58c94f;
    /* The exact mode assigned to executor+0x614 by 0x423f57. */
    int32_t evaluation_mode_614;
    /* Read-only input: 0x5c3a47 is updated by the owner only after the whole
     * dependency tree returns. This leaf kernel never writes it. */
    int32_t previous_global_5c3a47;
    int32_t debug_enabled_63a4cd;
    /* Borrowed slot in the owning action/tree object corresponding to root
     * +0x24. Its lifetime must not exceed that action's scene-owned tree. */
    const void **selected_dependency_leaf;
    ConditionExtraSoundQueryFn sound_query;
    ConditionExtraNextRandomFn next_random;
} ConditionExtraSession;

/* Caller-owned sidecar for a loaded original leaf node. The runtime threshold
 * is initialized to zero because the original allocator/loader zero it and
 * the traced reset does not alter it; raw record words 4..7 remain distinct.
 * The cached sample is the result of original raw rand()%100, not raw rand(). */
typedef struct condition_extra_node_runtime {
    int32_t runtime_threshold_20;
    uint32_t random_cache_valid_2c;
    int32_t random_sample_30;
} ConditionExtraNodeRuntime;

typedef struct condition_extra_result {
    int32_t status;
    int32_t trigger;
    uint32_t random_raw_value;
    uint32_t random_calls;
    uint32_t host_calls;
    uint8_t partial_state_committed;
    uint8_t reserved[3];
} ConditionExtraResult;

/* Initialize a sidecar exactly like a newly zero-filled original 0x4c node.
 * Call once after construction; do not reuse an old sidecar across action or
 * scene teardown. */
void condition_extra_node_initialize(ConditionExtraNodeRuntime *runtime);

/* Original 0x423da2 clears status and node+0x2c for leaves. The extra sidecar
 * reset therefore clears only the random-valid bit and preserves both the
 * threshold and the previously stored sample. */
void condition_extra_node_reset(ConditionExtraNodeRuntime *runtime);

/* Evaluate exactly observed leaf opcodes 11, 12, 13, 14, 15, 17, 20 and 21.
 * Existing opcodes 0..6/9 and tree markers 0x12/0x13 remain owned by
 * scene_conditions. `leaf_identity` is borrowed only for this call and may be
 * stored in the borrowed owning-action slot for opcode 11; destroy that slot
 * together with the scene/action tree. The executor, not this function,
 * commits the post-tree 0x5c3a47 value.
 *
 * Safe native bounds checks intentionally reject indexes the original x86
 * code would read unchecked. On unsupported, bounds, or unavailable/error
 * outcomes, `status_out` is unchanged. `result` describes any exact prefix
 * effects already committed; no rollback is attempted. */
int condition_extra_evaluate_leaf(
    const SceneDependencyInfo *record,
    const void *leaf_identity,
    ConditionExtraNodeRuntime *runtime,
    ConditionExtraSession *session,
    int32_t *status_out,
    ConditionExtraResult *result);

const char *condition_extra_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
