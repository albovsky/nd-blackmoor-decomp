#ifndef BLACKMOOR_SCENE_EXECUTOR_H
#define BLACKMOOR_SCENE_EXECUTOR_H

#include <stddef.h>
#include <stdint.h>

#include "action_core.h"
#include "scene_conditions.h"
#include "scene_resource.h"

#ifdef __cplusplus
extern "C" {
#endif

/* The recovered dispatch loop normally scans 120 ACT rows. Callers may raise
 * the bound (for example, to 240) for analysis without changing scene data. */
#define SCENE_EXECUTOR_DEFAULT_MAX_ACTIONS 120u
#define SCENE_EXECUTOR_MAX_ACTIONS 240u

typedef struct SceneActionExecutor SceneActionExecutor;

typedef enum scene_executor_status {
    SCENE_EXECUTOR_OK = 0,
    SCENE_EXECUTOR_ERR_ARGUMENT = 1,
    SCENE_EXECUTOR_ERR_MEMORY = 2,
    SCENE_EXECUTOR_ERR_LIMIT = 3,
    SCENE_EXECUTOR_ERR_FORMAT = 4,
    SCENE_EXECUTOR_ERR_CONDITION = 5,
    SCENE_EXECUTOR_ERR_UNSUPPORTED = 6,
    SCENE_EXECUTOR_ERR_ACTION_CORE = 7,
    SCENE_EXECUTOR_ERR_EXTERNAL = 8,
    SCENE_EXECUTOR_ERR_STATE_MISMATCH = 9
} SceneExecutorStatus;

typedef enum scene_executor_step_kind {
    SCENE_EXECUTOR_STEP_IDLE = 0,
    SCENE_EXECUTOR_STEP_PROCESSED = 1,
    SCENE_EXECUTOR_STEP_TRANSITION = 2,
    SCENE_EXECUTOR_STEP_STOPPED = 3
} SceneExecutorStepKind;

typedef enum scene_action_handler_status {
    SCENE_ACTION_HANDLER_OK = 0,
    SCENE_ACTION_HANDLER_UNSUPPORTED = 1,
    SCENE_ACTION_HANDLER_ERROR = 2
} SceneActionHandlerStatus;

typedef enum scene_action_handler_disposition {
    SCENE_ACTION_HANDLER_PENDING = 0,
    SCENE_ACTION_HANDLER_COMPLETED = 1,
    SCENE_ACTION_HANDLER_RESET_DEPENDENCIES = 2,
    /* Used by original handlers that set completion directly, independent of
     * subtype, without calling 0x42ba3a or resetting dependencies. */
    SCENE_ACTION_HANDLER_DIRECT_COMPLETED = 3
} SceneActionHandlerDisposition;

typedef struct scene_action_runtime_state {
    uint8_t completed;
    uint32_t phase;
} SceneActionRuntimeState;

typedef struct scene_action_handler_result {
    SceneActionHandlerDisposition disposition;
    /* Used by PENDING, COMPLETED and DIRECT_COMPLETED.
     * RESET_DEPENDENCIES forces phase to zero. */
    uint32_t phase;
} SceneActionHandlerResult;

/* Values in the scene-change body are retained as signed little-endian words
 * and dwords. Their meanings beyond target_scene are intentionally opaque. */
typedef struct scene_transition_request {
    int16_t target_scene;
    int16_t opaque_words[3];
    int32_t opaque_dwords[3];
} SceneTransitionRequest;

/* Per-tick input for the recovered frame-matched hotspot path. Pointer
 * coordinates are the cursor hot point already transformed into scene
 * coordinates: subtract viewport origin, add scene scroll to Y, then add the
 * cursor sprite's hot-point offsets. Rectangles are tested inclusively. The
 * separate context/modal bits model the original cursor-mode and event guards;
 * hotspot_activation_event must represent an accepted WM_LBUTTONUP (primary
 * button release), not a hover or button-down event. */
typedef struct scene_executor_frame_input {
    int32_t current_frame;
    int32_t pointer_x;
    int32_t pointer_y;
    uint8_t pointer_valid;
    uint8_t cursor_context_allowed;
    uint8_t modal_event_active;
    /* True only when the host's accepted WM_LBUTTONUP path reaches the
     * original candidate-consumption gate. */
    uint8_t hotspot_activation_event;
} SceneExecutorFrameInput;

/* Current rectangle exported by a built-in hotspot action. A rectangle can
 * be present while inactive (runtime type 0x0d exports it in phase 0); callers
 * should hit-test only when active is nonzero. */
typedef struct scene_executor_hotspot_state {
    int32_t left;
    int32_t top;
    int32_t right;
    int32_t bottom;
    uint8_t active;
    uint8_t rectangle_valid;
    uint8_t runtime_type;
} SceneExecutorHotspotState;

typedef int (*SceneActionExternalHandler)(
    void *context,
    size_t action_index,
    const SceneActionInfo *action,
    const SceneActionRuntimeState *state_before,
    SceneActionHandlerResult *result);

typedef struct scene_action_handler {
    uint8_t type;
    SceneActionExternalHandler callback;
    void *context;
} SceneActionHandler;

typedef struct scene_executor_step_info {
    SceneExecutorStepKind kind;
    size_t actions_considered;
    size_t actions_applied;
    size_t failed_action_index;
    uint8_t failed_action_type;
    /* Subsystem status: SceneConditionStatus, ActionCoreStatus, or handler
     * status, as selected by the top-level SceneExecutorStatus. */
    int detail_status;
    SceneTransitionRequest transition;
} SceneExecutorStepInfo;

/* Create an executor that borrows `scene` and `world`; both must outlive it.
 * `max_actions == 0` selects the normal 120-row bound. Unsupported opaque
 * action payloads fail creation because their dependency boundaries cannot be
 * inferred safely. On creation failure, failed_action_index is SIZE_MAX when
 * the failure is not associated with an ACT row. */
int scene_executor_create(const SceneResource *scene,
                          ActionCoreWorld *world,
                          size_t max_actions,
                          SceneActionExecutor **executor,
                          size_t *failed_action_index);
void scene_executor_destroy(SceneActionExecutor *executor);

/* Evaluate ACT rows in ascending order. Each row's dependencies are evaluated
 * immediately before its handler. The current event-flag view must be the same
 * storage and count as world->event_flags/count; state is otherwise borrowed
 * for this call. The registry is optional, but an eligible typed action with
 * no registered handler returns SCENE_EXECUTOR_ERR_UNSUPPORTED explicitly. */
int scene_executor_step(SceneActionExecutor *executor,
                        const SceneConditionState *state,
                        const SceneActionHandler *handlers,
                        size_t handler_count,
                        SceneExecutorStepInfo *step_info);

/* Like scene_executor_step, but supplies the current animation frame and the
 * host's cursor/context state. A hit is captured after this tick's dispatcher.
 * On a later accepted input event, that candidate is checked before the
 * dispatcher; phase-2 effects execute in that same tick. The compatibility
 * step above supplies frame zero and no pointer or activation event. */
int scene_executor_step_frame(SceneActionExecutor *executor,
                              const SceneConditionState *state,
                              const SceneActionHandler *handlers,
                              size_t handler_count,
                              const SceneExecutorFrameInput *frame_input,
                              SceneExecutorStepInfo *step_info);

int scene_executor_get_action_state(const SceneActionExecutor *executor,
                                    size_t action_index,
                                    SceneActionRuntimeState *state);

int scene_executor_get_hotspot_state(const SceneActionExecutor *executor,
                                     size_t action_index,
                                     SceneExecutorHotspotState *state);

/* External handlers that recover a delayed transition side effect (for
 * example, an asynchronous sound-completion action) may request it while
 * their callback is running. The executor then reports TRANSITION and stops
 * the current ACT pass after that handler returns. Calls outside a callback
 * are rejected. */
int scene_executor_request_transition(SceneActionExecutor *executor,
                                      const SceneTransitionRequest *request);

const char *scene_executor_status_string(int status);

#ifdef __cplusplus
}
#endif

#endif
