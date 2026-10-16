#ifndef BLACKMOOR_SCENE_SESSION_H
#define BLACKMOOR_SCENE_SESSION_H

#include "action_ui.h"
#include "scene_executor.h"
#include "session_input.h"

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct SceneSession SceneSession;

typedef enum scene_session_status {
    SCENE_SESSION_OK = 0,
    SCENE_SESSION_TRANSITION_PENDING = 1,
    SCENE_SESSION_BLOCKED = 2,
    SCENE_SESSION_ERR_ARGUMENT = 3,
    SCENE_SESSION_ERR_MEMORY = 4,
    SCENE_SESSION_ERR_EXECUTOR = 5,
    SCENE_SESSION_ERR_STATE = 6
} SceneSessionStatus;

typedef enum scene_session_provider {
    SCENE_SESSION_PROVIDER_NONE = 0,
    SCENE_SESSION_PROVIDER_WORLD_CLOCK = 1,
    SCENE_SESSION_PROVIDER_TIMER_EFFECTS = 2,
    SCENE_SESSION_PROVIDER_POST_CLOCK = 3,
    SCENE_SESSION_PROVIDER_MEDIA = 4,
    SCENE_SESSION_PROVIDER_POINTER_INPUT = 5,
    SCENE_SESSION_PROVIDER_ACTION_UI = 6,
    SCENE_SESSION_PROVIDER_ACTION_SOUND = 7,
    SCENE_SESSION_PROVIDER_CAPTION = 8,
    SCENE_SESSION_PROVIDER_A28 = 9,
    SCENE_SESSION_PROVIDER_A62 = 10,
    SCENE_SESSION_PROVIDER_ACTION_KERNEL = 11,
    SCENE_SESSION_PROVIDER_DEPENDENCY = 12,
    SCENE_SESSION_PROVIDER_SCENE_RESOURCE = 13,
    SCENE_SESSION_PROVIDER_HOST = 14,
    SCENE_SESSION_PROVIDER_A35 = 15,
    SCENE_SESSION_PROVIDER_A83 = 16
} SceneSessionProvider;

typedef enum scene_session_stage {
    SCENE_SESSION_STAGE_NONE = 0,
    SCENE_SESSION_STAGE_PREPARE = 1,
    SCENE_SESSION_STAGE_MEDIA = 2,
    SCENE_SESSION_STAGE_DISPATCH = 3,
    SCENE_SESSION_STAGE_SCENE_REPLACE = 4,
    /* RT-6: the pointer host reported an invalid-argument status. */
    SCENE_SESSION_STAGE_POINTER = 5
} SceneSessionStage;

typedef enum scene_session_callback_status {
    SCENE_SESSION_CALLBACK_OK = 0,
    SCENE_SESSION_CALLBACK_BLOCKED = 1,
    SCENE_SESSION_CALLBACK_ERROR = 2
} SceneSessionCallbackStatus;

typedef struct scene_session_failure {
    SceneSessionStage stage;
    SceneSessionProvider provider;
    size_t action_index;
    uint8_t action_type;
    int detail_status;
} SceneSessionFailure;

/* A preparation provider refreshes the borrowed condition view and supplies
 * already-accepted input for this tick. Pointer coordinates must be in the
 * exact comparison space used by the action rectangle provider; this API does
 * not infer viewport, scroll, cursor-hot-point, modal or release semantics. */
typedef SceneSessionCallbackStatus (*SceneSessionPrepareFn)(
    void *context,
    SceneConditionState *conditions,
    SceneExecutorFrameInput *frame_input,
    SceneSessionFailure *failure);

/* Advances media at most once per scene tick and may update current_frame.
 * It must not recurse into scene dispatch or drain all due frames. */
typedef SceneSessionCallbackStatus (*SceneSessionMediaStepFn)(
    void *context,
    SceneExecutorFrameInput *frame_input,
    SceneSessionFailure *failure);

typedef struct scene_session_action_binding {
    uint8_t type;
    SceneSessionProvider provider;
    SceneActionExternalHandler callback;
    void *context;
} SceneSessionActionBinding;

typedef struct scene_session_config {
    const SceneResource *scene;
    int32_t scene_id;
    ActionCoreWorld *action_core_world;
    SceneConditionState *conditions;
    ActionFamily64World *action64_world;
    ActionFamily64Backend *action64_backend;
    const uint8_t (*initial_phone_rows)[ACTION_UI_PHONE_RECORD_SIZE];
    size_t initial_phone_count;
    const SceneSessionActionBinding *action_bindings;
    size_t action_binding_count;
    SceneSessionPrepareFn prepare_tick;
    SceneSessionMediaStepFn advance_media_one;
    void *provider_context;
    SceneAction64WorldCommitFn action64_world_commit_observer;
    void *action64_world_commit_context;
} SceneSessionConfig;

typedef struct scene_session_tick_result {
    SceneSessionStatus status;
    SceneSessionFailure failure;
    SceneExecutorStepInfo executor;
    uint64_t tick_index;
    uint64_t scene_generation;
    uint8_t prepare_attempted;
    uint8_t prepare_succeeded;
    uint8_t media_attempted;
    uint8_t media_succeeded;
    uint8_t dispatch_attempted;
    uint8_t dispatch_succeeded;
} SceneSessionTickResult;

/* The session owns its executor and copied/sorted phone table. It borrows the
 * scene, world, condition spans, clock/backend, callback contexts and action
 * bindings; all borrows outlive destroy or a successful replace_scene call.
 * Controls and phone rows persist across scene replacement. Missing providers
 * are not success: the first missing/unresolved boundary freezes the session
 * with a sticky, inspectable blocker. */
int scene_session_create(const SceneSessionConfig *config,
                         SceneSession **out_session,
                         SceneSessionFailure *failure);
void scene_session_destroy(SceneSession *session);

/* One persistent tick: prepare -> one media step -> ordered ACT dispatch.
 * Callback failures and unsupported eligible rows freeze without rollback;
 * prior ACT/world/provider effects remain visible in their source order. */
int scene_session_tick(SceneSession *session,
                       SceneSessionTickResult *result);

/* Replaces the scene executor only after the candidate executor is valid.
 * The old executor is destroyed before this returns, so its old borrowed scene
 * may then be closed. UI/world/providers remain the same session objects. */
int scene_session_replace_scene(SceneSession *session,
                                const SceneResource *scene,
                                int32_t scene_id,
                                SceneSessionFailure *failure);

/* Register a per-type dispatcher pre-gate (see SceneActionPreGateFn). The
 * registration is kept by the session and re-applied to every replacement
 * executor, so it survives scene changes. The hook is borrowed; register it
 * before the first tick. Duplicate types and NULL callbacks are rejected. */
int scene_session_set_pre_gate(SceneSession *session,
                               uint8_t type,
                               SceneActionPreGateFn callback,
                               void *context);

/* RT-4: register the dependency-leaf extension (see
 * SceneConditionExtension). The pointer is borrowed, must outlive the session,
 * is re-applied to every replacement executor and is registered before the
 * first tick. NULL clears it. Without it extension opcodes are an explicit
 * dependency-provider blocker. */
int scene_session_set_condition_extension(
    SceneSession *session, const SceneConditionExtension *extension);

/* Detail of the dependency evaluation that froze the session (zeroed if the
 * freeze had another cause). */
int scene_session_get_condition_failure(const SceneSession *session,
                                        SceneConditionFailure *failure);

/* RT-6: the pointer boundary. The session owns the SEQUENCING of the recovered
 * input module (session_input) and the single retained candidate (0x5c39e5)
 * lives inside that module's state, held by the host; the session holds no
 * candidate and the executor holds none either.
 *
 *   prepare -> media -> consume -> dispatch -> [candidate = -1; scan]
 *
 * consume (43a7ca -> 43b194, 4daf3f): runs once per tick after prepare and the
 * media step succeeded and before the dispatcher. It must fill the pointer and
 * activation members of the frame (session_input_tick) and report the raw
 * retained candidate. Whatever prepare/media put in those members is
 * discarded while a host is bound. A tick that fails earlier never reaches it,
 * so a release edge is not lost to a preparation/media failure.
 * scan (4d3073 -> 4f0059): runs after a dispatch that did not end in a scene
 * transition (that ends the scene; the next one rescans). The session offers
 * every hit-testable row in ascending index order: the executor's built-in
 * hotspot rectangles that are active, and rows the host exports through
 * external_row (the 0x62 request/response table). The host resets the
 * candidate to -1 and scans (session_input_scan); the first hit in index
 * order is the candidate, so a row cannot be selected twice.
 * reset (latch constructor 0x4dad60 + candidate = -1, session_input_init): runs
 * at bind time and on every successful scene replacement.
 *
 * The callbacks take typed session_input structures but call nothing in this
 * library, so scene_session.c stays free of a link dependency on the module.
 * Status values are SessionInputStatus: OK, or the named LIMIT_* (recorded,
 * not fatal: the tick continues without an activation and the candidate stays
 * -1), or INVALID_ARGUMENT (a host bug: the session freezes at
 * SCENE_SESSION_STAGE_POINTER). */
typedef struct scene_session_pointer_host {
    void *context;
    int (*consume)(void *context, SceneExecutorFrameInput *frame, int32_t *candidate);
    int (*scan)(void *context, const SessionInputHotspot *rows, size_t count,
                int32_t *candidate);
    int (*reset)(void *context);
    /* Optional. Return 1 and fill *row (index == action_index) when the
     * executor-opaque row currently owns a request rectangle; else 0. */
    int (*external_row)(void *context, size_t action_index, SessionInputHotspot *row);
} SceneSessionPointerHost;

typedef struct scene_session_pointer_result {
    uint64_t tick_index;
    /* SessionInputStatus of the consume / scan callbacks; -1 when that boundary
     * was not reached this tick. */
    int32_t consume_status;
    int32_t scan_status;
    int32_t candidate_at_consume; /* raw retained value, -1 none */
    int32_t candidate_after_scan; /* -1 none */
    uint32_t scan_rows;
    uint8_t activation_event;     /* handed to the executor */
    uint8_t activation_candidate_valid;
} SceneSessionPointerResult;

/* Bind the pointer host (before the first tick). The host is copied; its
 * context must outlive the session. consume, scan and reset are required.
 * Runs reset once. Re-binding replaces the host. */
int scene_session_bind_pointer(SceneSession *session,
                               const SceneSessionPointerHost *host);
int scene_session_get_pointer_result(const SceneSession *session,
                                     SceneSessionPointerResult *result);

/* Candidate-accept store of 0x43c054 (see
 * scene_executor_accept_action_candidate). */
int scene_session_accept_action_candidate(SceneSession *session,
                                          size_t action_index);

/* For an external action handler running inside scene_session_tick: asks the
 * executor to end the scene with this request once the handler returns OK.
 * Any call outside a handler, or a second request, is ERR_STATE. */
int scene_session_request_transition(SceneSession *session,
                                     const SceneTransitionRequest *request);
int scene_session_get_action_state(const SceneSession *session,
                                   size_t action_index,
                                   SceneActionRuntimeState *state);
/* RT-36: retire an action row (completed, phase 0, dependencies reset), as the random-movie stop does to the raw 0x2d row
 * (scene_executor_retire_action). Legal from inside a handler. */
int scene_session_retire_action(SceneSession *session, size_t action_index);
int scene_session_get_hotspot_state(const SceneSession *session,
                                    size_t action_index,
                                    SceneExecutorHotspotState *state);
const ActionUIWorld *scene_session_get_action_ui(const SceneSession *session);
/* 0x4e0559's active branch: set availability then the selected dirty flag.
 * Used by 0x83 after its list writes. No rendering is performed here. */
int scene_session_mark_ui_dirty(SceneSession *session, int16_t group, int16_t child);
int scene_session_get_pending_transition(const SceneSession *session,
                                        SceneTransitionRequest *transition);
int scene_session_get_last_result(const SceneSession *session,
                                  SceneSessionTickResult *result);
uint64_t scene_session_tick_count(const SceneSession *session);
uint64_t scene_session_scene_generation(const SceneSession *session);
int32_t scene_session_scene_id(const SceneSession *session);
const char *scene_session_status_string(int status);
const char *scene_session_provider_string(SceneSessionProvider provider);

#ifdef __cplusplus
}
#endif

#endif
