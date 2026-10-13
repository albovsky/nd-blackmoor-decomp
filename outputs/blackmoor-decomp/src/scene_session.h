#ifndef BLACKMOOR_SCENE_SESSION_H
#define BLACKMOOR_SCENE_SESSION_H

#include "action_ui.h"
#include "scene_executor.h"

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
    SCENE_SESSION_PROVIDER_HOST = 14
} SceneSessionProvider;

typedef enum scene_session_stage {
    SCENE_SESSION_STAGE_NONE = 0,
    SCENE_SESSION_STAGE_PREPARE = 1,
    SCENE_SESSION_STAGE_MEDIA = 2,
    SCENE_SESSION_STAGE_DISPATCH = 3,
    SCENE_SESSION_STAGE_SCENE_REPLACE = 4
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

int scene_session_get_action_state(const SceneSession *session,
                                   size_t action_index,
                                   SceneActionRuntimeState *state);
int scene_session_get_hotspot_state(const SceneSession *session,
                                    size_t action_index,
                                    SceneExecutorHotspotState *state);
const ActionUIWorld *scene_session_get_action_ui(const SceneSession *session);
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
