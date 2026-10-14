#ifndef BLACKMOOR_SCENE_EXECUTOR_H
#define BLACKMOOR_SCENE_EXECUTOR_H

#include <stddef.h>
#include <stdint.h>

#include "action_core.h"
#include "action_family_64.h"
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

/* Per-tick input for the recovered frame-matched hotspot path.
 *
 * RT-6: the executor no longer produces, caches or scans pointer candidates.
 * The original keeps ONE global candidate (0x5c39e5), written by the cursor
 * scan 0x4f0059 after each dispatch (first generic hit in row order) and read
 * by the accept block at 0x43bfb6 on the next accepted release. The host's
 * input module (session_input) owns that value; the tick passes it here as
 * activation_candidate together with the accepted-release event, and the
 * executor stores phase 2 on that row (any row type, as in the original).
 *
 *   hotspot_activation_event   the 4daf3f consume reported a release edge and
 *                              the cursor mode is a normal one (session_input
 *                              sets it; hover and button-down never do).
 *   activation_candidate_valid the host supplies a candidate with this tick;
 *                              zero-initialised inputs therefore cannot name
 *                              row 0.
 *   activation_candidate       raw 0x5c39e5, accepted only in [0, 0xf0) and
 *                              below the scene's action count.
 *   modal_event_active         [0x5c39e9] != 0 (43bfd3): rejects the event.
 *
 * pointer_x/pointer_y/pointer_valid/cursor_context_allowed are the producer's
 * projected output (session_input_tick fills them for the host's diagnostics);
 * the executor does not read them. */
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
    uint8_t activation_candidate_valid;
    int32_t activation_candidate;
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

/* Called synchronously after an eligible 0x64 handler commits changed clock
 * fields, before the next ACT row is evaluated. `world` is the same mutable
 * snapshot bound to the executor. No call is made for false gates, unsupported
 * rows, or rows whose four clock fields did not change. */
typedef void (*SceneAction64WorldCommitFn)(
    void *context,
    const ActionFamily64World *world);

/* Dispatcher prologue of 0x427a50 for one ACT row. For every row whose
 * completion byte (slot +0x42) is clear and whose action-active dword
 * (slot +0x55, 0x5bb638) is zero, the original stores zero to the request
 * dword (slot +0x43, 0x5bb626) BEFORE it switches on the type and evaluates
 * the dependency tree. A false dependency gate therefore still leaves the
 * clear behind, and the handler never sees it. This hook runs at exactly that
 * point for a registered type: after the completed-row skip, before the
 * dependency gate, once per visit. The executor has no producer for the
 * action-active dword (0x435015, 0x4381f4, 0x43dbe3, 0x43e484, 0x43e776,
 * 0x43e96c, 0x4ccff5 and 0x4d812e set it), so it is treated as zero. The
 * callback must not re-enter the executor. */
typedef void (*SceneActionPreGateFn)(void *context,
                                     size_t action_index,
                                     const SceneActionInfo *action,
                                     const SceneActionRuntimeState *state);

#define SCENE_EXECUTOR_MAX_PRE_GATES 8u

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

/* Bind the caller-owned type-0x64 clock snapshot and GetTickCount backend.
 * The executor borrows both pointers; they must outlive every step using this
 * binding. Eligible type-0x64 actions without a binding remain unsupported.
 * This extension does not change the legacy public structs. */
int scene_executor_bind_action64_runtime(
    SceneActionExecutor *executor,
    ActionFamily64World *world,
    ActionFamily64Backend *backend);

/* Optional mirror for process/world-owned clock storage. The callback and its
 * context are borrowed and must outlive the executor. */
int scene_executor_set_action64_world_commit_observer(
    SceneActionExecutor *executor,
    SceneAction64WorldCommitFn observer,
    void *context);

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
 * host's accepted-release event with its retained candidate (see
 * SceneExecutorFrameInput). The candidate is checked before the dispatcher;
 * phase-2 effects execute in that same tick. The executor retains nothing
 * between steps. The compatibility step above supplies frame zero and no
 * activation event. */
int scene_executor_step_frame(SceneActionExecutor *executor,
                              const SceneConditionState *state,
                              const SceneActionHandler *handlers,
                              size_t handler_count,
                              const SceneExecutorFrameInput *frame_input,
                              SceneExecutorStepInfo *step_info);

/* Register the pre-gate hook for one action type. A type may be registered
 * once; a NULL callback, a duplicate type or a ninth registration is
 * rejected with SCENE_EXECUTOR_ERR_ARGUMENT. The callback and context are
 * borrowed. Registration affects every later step of this executor. */
int scene_executor_set_pre_gate(SceneActionExecutor *executor,
                                uint8_t type,
                                SceneActionPreGateFn callback,
                                void *context);

/* Candidate-accept store of 0x43c054: `mov [row*0x8d + 0x5bb632], 2`. The
 * caller has already run the accept decision; this only performs the phase
 * store so the row's handler is visited with phase 2 on the next dispatch. The
 * original does not test the completion byte here. Out-of-range rows return
 * SCENE_EXECUTOR_ERR_ARGUMENT and change nothing.
 * RT-6: the live path no longer needs this. scene_executor_step_frame runs the
 * whole 0x43bfb6 decision for the single input-module candidate (0x6a/raw 0x15
 * hotspots and 0x62 rows alike). A host that calls this for the SAME activation
 * the step already handled would store phase 2 twice; it exists for hosts and
 * tests that run the decision themselves. */
int scene_executor_accept_action_candidate(SceneActionExecutor *executor,
                                           size_t action_index);

/* RT-4: register the dependency-leaf extension (opcodes outside 0..6 and 9,
 * the post-tree 0x5c3a47 store and the per-pass reset at 0x43cf25). The
 * pointer is borrowed and must outlive the executor; NULL clears it. Each
 * gate evaluation passes the mode 0x427a50 passes to 0x423f57 for the row's
 * runtime type (scene_conditions_gate_mode_for_type); the hotspot candidate
 * check at 0x43c019 uses mode 0. Without an extension extra opcodes stay
 * unsupported. Register before the first step. */
int scene_executor_set_condition_extension(
    SceneActionExecutor *executor,
    const SceneConditionExtension *extension);

/* Detail of the most recent dependency evaluation: zeroed when it succeeded,
 * else the failing leaf's opcode, source record position and the extension's
 * own `provider_status`. A failure freezes the session, so this stays valid
 * for reporting. */
int scene_executor_get_condition_failure(const SceneActionExecutor *executor,
                                         SceneConditionFailure *failure);

/* What the accepted-click candidate check (0x43bfb6..0x43c09c) decided for
 * the most recent candidate. This is the seam for the pointer integration:
 * the executor owns the gate logic (RT-6: the candidate itself now arrives in
 * SceneExecutorFrameInput from the input module); the item-use feedback calls
 * the original makes
 * (0x4eb107(label) on accept, 0x4eb184(first_chain_label) on reject).
 *   chain_count          0x42405a: opcode-11 leaves in the tree.
 *   tree_evaluated       0 when chain_count == 0 (the original accepts with
 *                        NO tree evaluation, no 0x5c3a47 store, no leaf
 *                        side effects).
 *   tree_satisfied       wrapper result with mode 0.
 *   label                0x424035 read right after the evaluation, -1 if the
 *                        slot is empty (initial value of the original local).
 *   first_chain_label    0x423fbb, -1 if none.
 *   accepted             phase 2 was stored (0x43c054). */
typedef struct scene_executor_candidate_decision {
    size_t action_index;
    size_t chain_count;
    uint8_t tree_evaluated;
    uint8_t tree_satisfied;
    uint8_t accepted;
    uint8_t reserved;
    int32_t label;
    int32_t first_chain_label;
} SceneExecutorCandidateDecision;

/* Zeroed with action_index SIZE_MAX until the first candidate check ran. */
int scene_executor_get_candidate_decision(const SceneActionExecutor *executor,
                                          SceneExecutorCandidateDecision *decision);

/* Opcode-11 slot of the action's tree (accessor 0x424035): returns 1 and the
 * selected item label when a selected-item leaf owns the slot, else 0/-1. */
int scene_executor_get_selected_item_label(const SceneActionExecutor *executor,
                                           size_t action_index,
                                           int32_t *label);

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

#ifdef SCENE_EXECUTOR_TEST_HOOKS
/* Test-only visibility into the dependency reducer's retained node results. */
int scene_executor_test_condition_node_status(
    const SceneActionExecutor *executor,
    size_t action_index,
    size_t node_index,
    int32_t *out_status);
#endif

#ifdef __cplusplus
}
#endif

#endif
