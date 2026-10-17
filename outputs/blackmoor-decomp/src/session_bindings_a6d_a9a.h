#ifndef BLACKMOOR_SESSION_BINDINGS_A6D_A9A_H
#define BLACKMOOR_SESSION_BINDINGS_A6D_A9A_H

/* Session bindings for raw actions 0x6d and 0x9a (RT-57): two arms of the dispatcher 0x427a50 (0x4290c0 and 0x429d34, both
 * gate mode 0) that finish with a direct completion-byte store. The kernels are action_family_6d_runtime.c and
 * action_family_9a_runtime.c; the sound, popup and scene-change effects are the hosts'. The executor evaluates the gate; the
 * handlers run only for a true gate. */

#include "action_family_6d_runtime.h"
#include "action_family_9a_runtime.h"
#include "scene_executor.h"

#ifdef __cplusplus
extern "C" {
#endif

#define SESSION_A6D_TYPE ACTION_FAMILY_6D_RAW_TYPE
#define SESSION_A9A_TYPE ACTION_FAMILY_9A_RAW_TYPE

typedef struct SessionA6dBinding SessionA6dBinding;
typedef struct SessionA9aBinding SessionA9aBinding;

/* ---- raw 0x6d ---------------------------------------------------------------------------------------------------------- */
typedef struct SessionA6dHost {
    void *context;
    /* REQUIRED. Fill the cells the arm reads (0x583204, 0x5bb22a) and carries. Nonzero refuses (UNSUPPORTED before any effect). */
    int (*load_world)(void *context, Action6DWorld *world);
    /* Commit the cells the arm wrote. Optional. */
    void (*store_world)(void *context, const Action6DWorld *world);
    /* REQUIRED: 0x4fb018 on the scene sound object 0x5c3a67. */
    int (*unload_scene_sound)(void *context);
    /* The popup teardown for the selected kind. Optional (see the kernel header): without it a visit that selects a kind is
     * UNSUPPORTED before any effect. */
    int (*teardown)(void *context, Action6DTeardown kind);
} SessionA6dHost;

/* DIRECT_COMPLETED with the phase the row was given (0x429163 stores only the completion byte). */
SessionA6dBinding *session_a6d_create(const SessionA6dHost *host);
void session_a6d_destroy(SessionA6dBinding *binding);
int session_a6d_handler(void *context, size_t action_index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *state_before, SceneActionHandlerResult *result);
const char *session_a6d_failure(const SessionA6dBinding *binding);
const Action6DWorld *session_a6d_last_world(const SessionA6dBinding *binding);
unsigned long session_a6d_visits(const SessionA6dBinding *binding);

/* ---- raw 0x9a ---------------------------------------------------------------------------------------------------------- */
typedef struct SessionA9aHost {
    void *context;
    /* Fill the cells the arm carries. Optional (zero cells). Nonzero refuses (UNSUPPORTED before any effect). */
    int (*load_world)(void *context, Action9AWorld *world);
    /* Commit the cells the arm wrote (including the start flag 0x5bb1ca). Optional. */
    void (*store_world)(void *context, const Action9AWorld *world);
    /* REQUIRED: 0x4fc878(channel) on 0x5c3a67. */
    int (*stop_channel)(void *context, uint16_t channel);
    /* REQUIRED. Event flag window (native safety query) and store (dword [0x585801 + 4 * index] := value). */
    int (*event_flag_invalid)(void *context, int16_t index);
    int (*store_event_flag)(void *context, int16_t index, uint32_t value);
    /* REQUIRED when a row has a scene (word 1 != 9999): the scene-change cells as a transition request (target 0x5bb57b, words
     * 0x5bb599, 0x5bb595, 0x5c39ff, dwords 0x5bb59b, 0x5bb59f, 0x5bb5a3; engine mode 0x583999 := 4). Nonzero = refused: the
     * visit is an ERROR after the kernel already ran. */
    int (*transition)(void *context, const SceneTransitionRequest *request);
} SessionA9aHost;

/* Phase 0 -> 2 PENDING; phase 2 DIRECT_COMPLETED with the phase the row was given. */
SessionA9aBinding *session_a9a_create(const SessionA9aHost *host);
void session_a9a_destroy(SessionA9aBinding *binding);
int session_a9a_handler(void *context, size_t action_index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *state_before, SceneActionHandlerResult *result);
const char *session_a9a_failure(const SessionA9aBinding *binding);
const Action9AWorld *session_a9a_last_world(const SessionA9aBinding *binding);
unsigned long session_a9a_visits(const SessionA9aBinding *binding);

#ifdef __cplusplus
}
#endif
#endif
