#include "scene_executor.h"

#include <limits.h>
#include <stdlib.h>
#include <string.h>

enum {
    SCENE_ACTION_SET_VALUE = 0x4d,
    SCENE_ACTION_EVENT_FLAGS_2 = 0x61,
    SCENE_ACTION_EVENT_FLAGS_10 = 0x6b,
    SCENE_ACTION_FLAG_HOTSPOT = 0x6a,
    SCENE_ACTION_DIFFICULTY = 0x71,
    SCENE_ACTION_CHANGE_SCENE = 0x0a,
    SCENE_ACTION_RAW_SCENE_HOTSPOT = 0x15,
    SCENE_ACTION_SCENE_HOTSPOT_RUNTIME = 0x0d,
    SCENE_ACTION_CLOCK = 0x64,
    SCENE_ACTION_ASYNC_SOUND = 0x9f,
    SCENE_ACTION_RANDOM_SOUND = 0x97,
    SCENE_ACTION_SOUND_A1 = 0xa1
};

typedef struct SceneExecutorPreGate {
    uint8_t type;
    SceneActionPreGateFn callback;
    void *context;
} SceneExecutorPreGate;

struct SceneActionExecutor {
    ActionCoreWorld *world;
    uint64_t slot_revision;
    SceneExecutorSlotInfo slots[SCENE_EXECUTOR_MAX_ACTIONS];
    size_t action_count;
    SceneConditionTree *conditions[SCENE_EXECUTOR_MAX_ACTIONS];
    SceneActionRuntimeState states[SCENE_EXECUTOR_MAX_ACTIONS];
    /* RT-32: rows whose handler turned them into runtime-0x36 overlays (gate mode 1 from then on). */
    uint8_t overlay36[SCENE_EXECUTOR_MAX_ACTIONS];
    SceneExecutorHotspotState hotspots[SCENE_EXECUTOR_MAX_ACTIONS];
    int in_external_callback;
    int callback_transition_requested;
    SceneTransitionRequest callback_transition;
    int transition_requested;
    SceneTransitionRequest transition;
    ActionFamily64World *action64_world;
    ActionFamily64Backend *action64_backend;
    SceneAction64WorldCommitFn action64_world_commit_observer;
    void *action64_world_commit_context;
    SceneExecutorPreGate pre_gates[SCENE_EXECUTOR_MAX_PRE_GATES];
    size_t pre_gate_count;
    const SceneConditionExtension *condition_extension;
    SceneConditionFailure condition_failure;
    SceneExecutorCandidateDecision candidate_decision;
};

static uint16_t read_u16le(const uint8_t *bytes)
{
    return (uint16_t)((uint16_t)bytes[0] | ((uint16_t)bytes[1] << 8));
}

static int16_t read_i16le(const uint8_t *bytes)
{
    uint16_t bits = read_u16le(bytes);
    int32_t value = (bits & UINT16_C(0x8000)) != 0u
                        ? (int32_t)bits - INT32_C(0x10000)
                        : (int32_t)bits;
    return (int16_t)value;
}

static int32_t read_i32le(const uint8_t *bytes)
{
    uint32_t bits = (uint32_t)bytes[0] |
                    ((uint32_t)bytes[1] << 8) |
                    ((uint32_t)bytes[2] << 16) |
                    ((uint32_t)bytes[3] << 24);
    if (bits <= (uint32_t)INT32_MAX) {
        return (int32_t)bits;
    }
    return -1 - (int32_t)(UINT32_MAX - bits);
}

static int is_action_core_type(uint8_t type)
{
    return type == SCENE_ACTION_SET_VALUE ||
           type == SCENE_ACTION_EVENT_FLAGS_2 ||
           type == SCENE_ACTION_EVENT_FLAGS_10 ||
           type == SCENE_ACTION_DIFFICULTY;
}

static int is_static_overlay_raw_type(uint8_t type)
{
    return type == 0x37u || type == 0x38u;
}

static int action_runtime_type(const SceneActionInfo *action)
{
    if (action->type == SCENE_ACTION_RAW_SCENE_HOTSPOT &&
        action->typed_body != NULL && action->typed_body_length == 20u &&
        action->typed_body[0] == SCENE_ACTION_SCENE_HOTSPOT_RUNTIME) {
        return SCENE_ACTION_SCENE_HOTSPOT_RUNTIME;
    }
    /* RT-18: the raw 0x37 (arm 0x40c446 -> 0x4895cc, type store 0x40c47b) and raw 0x38 (arm
     * 0x40c404 -> 0x48905b, store 0x40c43a) loaders store the runtime type 0x36, which the
     * dispatcher gates with 0x423f57 mode 1 (push 1 at 0x428083). */
    if (is_static_overlay_raw_type(action->type)) {
        return 0x36;
    }
    return action->type;
}

static int is_builtin_hotspot(const SceneActionInfo *action)
{
    int runtime_type = action_runtime_type(action);
    return runtime_type == SCENE_ACTION_FLAG_HOTSPOT ||
           runtime_type == SCENE_ACTION_SCENE_HOTSPOT_RUNTIME;
}

static size_t expected_core_body_length(uint8_t type)
{
    switch (type) {
    case SCENE_ACTION_SET_VALUE: return 4u;
    case SCENE_ACTION_EVENT_FLAGS_2: return 8u;
    case SCENE_ACTION_EVENT_FLAGS_10: return 40u;
    case SCENE_ACTION_DIFFICULTY: return 6u;
    default: return 0u;
    }
}

static int set_failed_action(size_t *out_index, size_t action_index)
{
    if (out_index != NULL) {
        *out_index = action_index;
    }
    return 1;
}

int scene_executor_create(const SceneResource *scene,
                          ActionCoreWorld *world,
                          size_t max_actions,
                          SceneActionExecutor **out_executor,
                          size_t *failed_action_index)
{
    SceneActionExecutor *executor;
    size_t action_count;
    size_t index;

    if (out_executor != NULL) {
        *out_executor = NULL;
    }
    if (failed_action_index != NULL) {
        *failed_action_index = SIZE_MAX;
    }
    if (scene == NULL || world == NULL || out_executor == NULL ||
        (world->event_flag_count != 0u && world->event_flags == NULL)) {
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }

    action_count = scene_resource_action_count(scene);
    if (max_actions == 0u) {
        max_actions = SCENE_EXECUTOR_DEFAULT_MAX_ACTIONS;
    }
    if (max_actions > SCENE_EXECUTOR_MAX_ACTIONS || action_count > max_actions) {
        return SCENE_EXECUTOR_ERR_LIMIT;
    }

    executor = (SceneActionExecutor *)calloc(1u, sizeof(*executor));
    if (executor == NULL) {
        return SCENE_EXECUTOR_ERR_MEMORY;
    }
    executor->world = world;
    executor->candidate_decision.action_index = SIZE_MAX;
    executor->candidate_decision.label = -1;
    executor->candidate_decision.first_chain_label = -1;
    executor->action_count = action_count;

    for (index = 0u; index < action_count; ++index) {
        SceneActionInfo action;
        SceneDependencyInfo *records = NULL;
        size_t dependency_index;
        int status;

        if (scene_resource_action_at(scene, index, &action) != SCENE_RESOURCE_OK) {
            set_failed_action(failed_action_index, index);
            scene_executor_destroy(executor);
            return SCENE_EXECUTOR_ERR_FORMAT;
        }
        SceneResourceActionRef origin;
        if (scene_resource_action_origin(scene, index, &origin) != SCENE_RESOURCE_OK) {
            set_failed_action(failed_action_index, index);
            scene_executor_destroy(executor);
            return SCENE_EXECUTOR_ERR_FORMAT;
        }
        executor->slots[index].action = action;
        executor->slots[index].source = origin.source;
        executor->slots[index].source_index = origin.index;
        executor->slots[index].occupied = 1u;
        if (action.payload_kind == SCENE_ACTION_PAYLOAD_OPAQUE ||
            (action.typed_body_length != 0u && action.typed_body == NULL) ||
            (action.dependency_count != 0u && action.dependency_records == NULL)) {
            set_failed_action(failed_action_index, index);
            scene_executor_destroy(executor);
            return SCENE_EXECUTOR_ERR_UNSUPPORTED;
        }
        if (action.type == SCENE_ACTION_CHANGE_SCENE &&
            action.typed_body_length != 20u) {
            set_failed_action(failed_action_index, index);
            scene_executor_destroy(executor);
            return SCENE_EXECUTOR_ERR_FORMAT;
        }
        if (is_action_core_type(action.type) &&
            action.typed_body_length != expected_core_body_length(action.type)) {
            set_failed_action(failed_action_index, index);
            scene_executor_destroy(executor);
            return SCENE_EXECUTOR_ERR_FORMAT;
        }
        if (action.dependency_count > SCENE_CONDITION_MAX_RECORDS ||
            action.dependency_count > SIZE_MAX / sizeof(*records)) {
            set_failed_action(failed_action_index, index);
            scene_executor_destroy(executor);
            return SCENE_EXECUTOR_ERR_LIMIT;
        }
        if (action.dependency_count != 0u) {
            records = (SceneDependencyInfo *)calloc(action.dependency_count,
                                                    sizeof(*records));
            if (records == NULL) {
                scene_executor_destroy(executor);
                return SCENE_EXECUTOR_ERR_MEMORY;
            }
            for (dependency_index = 0u;
                 dependency_index < action.dependency_count;
                 ++dependency_index) {
                if (scene_resource_dependency_at(scene, index,
                                                 dependency_index,
                                                 &records[dependency_index]) !=
                    SCENE_RESOURCE_OK) {
                    free(records);
                    set_failed_action(failed_action_index, index);
                    scene_executor_destroy(executor);
                    return SCENE_EXECUTOR_ERR_FORMAT;
                }
            }
        }
        status = scene_conditions_build(records, action.dependency_count,
                                        &executor->conditions[index]);
        free(records);
        if (status != SCENE_CONDITION_OK) {
            set_failed_action(failed_action_index, index);
            scene_executor_destroy(executor);
            return status == SCENE_CONDITION_ERR_MEMORY
                       ? SCENE_EXECUTOR_ERR_MEMORY
                       : status == SCENE_CONDITION_ERR_LIMIT
                             ? SCENE_EXECUTOR_ERR_LIMIT
                             : SCENE_EXECUTOR_ERR_FORMAT;
        }
    }

    *out_executor = executor;
    return SCENE_EXECUTOR_OK;
}

void scene_executor_destroy(SceneActionExecutor *executor)
{
    size_t index;
    if (executor == NULL) {
        return;
    }
    for (index = 0u; index < executor->action_count; ++index) {
        scene_conditions_destroy(executor->conditions[index]);
    }
    free(executor);
}

int scene_executor_bind_action64_runtime(
    SceneActionExecutor *executor,
    ActionFamily64World *world,
    ActionFamily64Backend *backend)
{
    if (executor == NULL || world == NULL || backend == NULL ||
        backend->get_tick_count == NULL) {
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    executor->action64_world = world;
    executor->action64_backend = backend;
    return SCENE_EXECUTOR_OK;
}

int scene_executor_set_action64_world_commit_observer(
    SceneActionExecutor *executor,
    SceneAction64WorldCommitFn observer,
    void *context)
{
    if (executor == NULL || (observer == NULL && context != NULL)) {
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    executor->action64_world_commit_observer = observer;
    executor->action64_world_commit_context = context;
    return SCENE_EXECUTOR_OK;
}

int scene_executor_set_pre_gate(SceneActionExecutor *executor,
                                uint8_t type,
                                SceneActionPreGateFn callback,
                                void *context)
{
    size_t index;
    if (executor == NULL || callback == NULL ||
        executor->pre_gate_count >= SCENE_EXECUTOR_MAX_PRE_GATES) {
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    for (index = 0u; index < executor->pre_gate_count; ++index) {
        if (executor->pre_gates[index].type == type) {
            return SCENE_EXECUTOR_ERR_ARGUMENT;
        }
    }
    executor->pre_gates[executor->pre_gate_count].type = type;
    executor->pre_gates[executor->pre_gate_count].callback = callback;
    executor->pre_gates[executor->pre_gate_count].context = context;
    ++executor->pre_gate_count;
    return SCENE_EXECUTOR_OK;
}

int scene_executor_accept_action_candidate(SceneActionExecutor *executor,
                                           size_t action_index)
{
    if (executor == NULL || action_index >= executor->action_count) {
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    executor->states[action_index].phase = 2u;
    return SCENE_EXECUTOR_OK;
}

static void run_pre_gate(const SceneActionExecutor *executor,
                         size_t index,
                         const SceneActionInfo *action)
{
    size_t gate;
    for (gate = 0u; gate < executor->pre_gate_count; ++gate) {
        if (executor->pre_gates[gate].type == action->type) {
            executor->pre_gates[gate].callback(executor->pre_gates[gate].context,
                                               index, action,
                                               &executor->states[index]);
            return;
        }
    }
}

static int action64_clock_fields_changed(const ActionFamily64World *before,
                                         const ActionFamily64World *after)
{
    return before->clock_value_585d51 != after->clock_value_585d51 ||
           before->clock_value_585d4f != after->clock_value_585d4f ||
           before->clock_total_585d4b != after->clock_total_585d4b ||
           before->clock_deadline_585d55 != after->clock_deadline_585d55;
}

static int validate_handlers(const SceneActionHandler *handlers,
                             size_t handler_count)
{
    size_t index;
    size_t other;
    if (handler_count != 0u && handlers == NULL) {
        return 0;
    }
    for (index = 0u; index < handler_count; ++index) {
        if (handlers[index].callback == NULL) {
            return 0;
        }
        for (other = 0u; other < index; ++other) {
            if (handlers[index].type == handlers[other].type) {
                return 0;
            }
        }
    }
    return 1;
}

static const SceneActionHandler *find_handler(const SceneActionHandler *handlers,
                                              size_t handler_count,
                                              uint8_t type)
{
    size_t index;
    for (index = 0u; index < handler_count; ++index) {
        if (handlers[index].type == type) {
            return &handlers[index];
        }
    }
    return NULL;
}

static void fill_failure(SceneExecutorStepInfo *info,
                         size_t index,
                         uint8_t type,
                         int detail_status)
{
    info->failed_action_index = index;
    info->failed_action_type = type;
    info->detail_status = detail_status;
}

/* An unsupported opcode or a missing host provider is an explicit blocker;
 * every other condition failure is a hard error. */
static int condition_failure_to_executor_status(int condition_status)
{
    return condition_status == SCENE_CONDITION_ERR_UNSUPPORTED_OPCODE ||
                   condition_status == SCENE_CONDITION_ERR_HOST_UNAVAILABLE
               ? SCENE_EXECUTOR_ERR_UNSUPPORTED
               : SCENE_EXECUTOR_ERR_CONDITION;
}

static void decode_scene_transition(const uint8_t *body,
                                    SceneTransitionRequest *request)
{
    request->target_scene = read_i16le(body);
    request->opaque_words[0] = read_i16le(body + 2u);
    request->opaque_words[1] = read_i16le(body + 4u);
    request->opaque_words[2] = read_i16le(body + 6u);
    request->opaque_dwords[0] = read_i32le(body + 8u);
    request->opaque_dwords[1] = read_i32le(body + 12u);
    request->opaque_dwords[2] = read_i32le(body + 16u);
}

static void decode_raw_scene_hotspot(const SceneActionInfo *action,
                                     SceneExecutorHotspotState *hotspot,
                                     SceneTransitionRequest *request)
{
    const uint8_t *body = action->typed_body;

    /* 0x40b34a's raw-0x15 loader constructs a 0x28-byte payload. It copies
     * body+2 to +2, body+4..+19 to +0x18..+0x24, and fills the words/dwords
     * and frame with loader defaults. The first payload word is the 0x0d
     * mapper result (zero). */
    request->target_scene = read_i16le(body + 2u);
    request->opaque_words[0] = 0;
    request->opaque_words[1] = 0;
    request->opaque_words[2] = 1;
    request->opaque_dwords[0] = 0;
    request->opaque_dwords[1] = 0;
    request->opaque_dwords[2] = 1;

    /* The constructed payload retains dwords, but 0x42ae73 exports each
     * coordinate through a 16-bit slot field. Match the live rectangle after
     * that truncation/sign extension, not the wider raw loader storage. */
    hotspot->left = read_i16le(body + 4u);
    hotspot->top = read_i16le(body + 8u);
    hotspot->right = read_i16le(body + 12u);
    hotspot->bottom = read_i16le(body + 16u);
    hotspot->runtime_type = SCENE_ACTION_SCENE_HOTSPOT_RUNTIME;
    hotspot->rectangle_valid = 1u;
}

static void set_6a_hotspot_rect(const SceneActionInfo *action,
                                size_t record_index,
                                SceneExecutorHotspotState *hotspot)
{
    const uint8_t *record = action->typed_body + 42u + record_index * 18u;
    hotspot->left = read_i16le(record + 2u);
    hotspot->top = read_i16le(record + 6u);
    hotspot->right = read_i16le(record + 10u);
    hotspot->bottom = read_i16le(record + 14u);
    hotspot->runtime_type = SCENE_ACTION_FLAG_HOTSPOT;
    hotspot->rectangle_valid = 1u;
}

static int apply_builtin_hotspot(SceneActionExecutor *executor,
                                 size_t index,
                                 const SceneActionInfo *action,
                                 const SceneExecutorFrameInput *frame_input,
                                 SceneExecutorStepInfo *info)
{
    SceneActionRuntimeState *runtime = &executor->states[index];
    SceneExecutorHotspotState *hotspot = &executor->hotspots[index];
    int runtime_type = action_runtime_type(action);

    if (runtime_type == SCENE_ACTION_FLAG_HOTSPOT) {
        uint16_t record_count;
        size_t record_index;

        hotspot->runtime_type = SCENE_ACTION_FLAG_HOTSPOT;
        hotspot->active = 0u;
        if (runtime->phase == 2u) {
            ActionCoreActionResult completion = {0u, 0u,
                                                  runtime->completed, 0u,
                                                  runtime->phase};
            int status = action_core_apply_event_flags(executor->world,
                                                       action->typed_body,
                                                       40u, 10u);
            if (status != ACTION_CORE_OK) {
                fill_failure(info, index, action->type, status);
                return SCENE_EXECUTOR_ERR_ACTION_CORE;
            }
            status = action_core_finish_action(action->subtype,
                                               runtime->completed,
                                               &completion);
            if (status != ACTION_CORE_OK) {
                fill_failure(info, index, action->type, status);
                return SCENE_EXECUTOR_ERR_ACTION_CORE;
            }
            runtime->completed = completion.completed;
            runtime->phase = completion.phase;
            if (completion.reset_dependencies) {
                scene_conditions_reset(executor->conditions[index]);
            }
        } else if (runtime->phase == 0u || runtime->phase == 1u) {
            if (runtime->phase == 0u) {
                runtime->phase = 1u;
            }
            record_count = read_u16le(action->typed_body + 40u);
            for (record_index = 0u; record_index < record_count;
                 ++record_index) {
                const uint8_t *record = action->typed_body + 42u +
                                        record_index * 18u;
                if (read_i16le(record) == frame_input->current_frame) {
                    set_6a_hotspot_rect(action, record_index, hotspot);
                    hotspot->active = 1u;
                    break;
                }
            }
        } else {
            return SCENE_EXECUTOR_OK;
        }
    } else if (runtime_type == SCENE_ACTION_SCENE_HOTSPOT_RUNTIME) {
        int32_t hotspot_frame = 0;

        decode_raw_scene_hotspot(action, hotspot, &executor->transition);
        hotspot->active = 0u;
        if (runtime->phase == 0u) {
            runtime->phase = 1u;
        } else if (runtime->phase == 2u) {
            runtime->completed = 1u;
            executor->transition_requested = 1;
            ++info->actions_applied;
            info->kind = SCENE_EXECUTOR_STEP_TRANSITION;
            info->transition = executor->transition;
            return SCENE_EXECUTOR_OK;
        } else if (runtime->phase != 1u) {
            return SCENE_EXECUTOR_OK;
        }
        /* The raw-0x15 loader writes zero to payload +0x16. */
        if (hotspot_frame == frame_input->current_frame) {
            hotspot->active = 1u;
        }
    } else {
        fill_failure(info, index, action->type, SCENE_ACTION_HANDLER_UNSUPPORTED);
        return SCENE_EXECUTOR_ERR_UNSUPPORTED;
    }

    ++info->actions_applied;
    info->kind = SCENE_EXECUTOR_STEP_PROCESSED;
    return SCENE_EXECUTOR_OK;
}

static int apply_external_handler(SceneActionExecutor *executor,
                                  size_t index,
                                  const SceneActionInfo *action,
                                  const SceneActionHandler *handler,
                                  SceneExecutorStepInfo *info)
{
    SceneActionRuntimeState before = executor->states[index];
    SceneActionHandlerResult handler_result;
    int handler_status;

    handler_result.disposition = SCENE_ACTION_HANDLER_PENDING;
    handler_result.phase = before.phase;
    executor->callback_transition_requested = 0;
    executor->in_external_callback = 1;
    handler_status = handler->callback(handler->context, index, action,
                                       &before, &handler_result);
    executor->in_external_callback = 0;
    if (handler_status == SCENE_ACTION_HANDLER_UNSUPPORTED) {
        executor->callback_transition_requested = 0;
        fill_failure(info, index, action->type, handler_status);
        return SCENE_EXECUTOR_ERR_UNSUPPORTED;
    }
    if (handler_status != SCENE_ACTION_HANDLER_OK) {
        executor->callback_transition_requested = 0;
        fill_failure(info, index, action->type, handler_status);
        return SCENE_EXECUTOR_ERR_EXTERNAL;
    }

    switch (handler_result.disposition) {
    case SCENE_ACTION_HANDLER_PENDING_BECOME_OVERLAY36:
        executor->overlay36[index] = 1u;
        executor->states[index].phase = handler_result.phase;
        break;
    case SCENE_ACTION_HANDLER_RESET_BECOME_OVERLAY36:
        executor->overlay36[index] = 1u;
        executor->states[index].phase = 0u;
        scene_conditions_reset(executor->conditions[index]);
        break;
    case SCENE_ACTION_HANDLER_PENDING:
        executor->states[index].phase = handler_result.phase;
        break;
    case SCENE_ACTION_HANDLER_COMPLETED: {
        ActionCoreActionResult completion = {0u, 0u, before.completed, 0u,
                                             before.phase};
        int status = action_core_finish_action(action->subtype,
                                               before.completed,
                                               &completion);
        if (status != ACTION_CORE_OK) {
            executor->callback_transition_requested = 0;
            fill_failure(info, index, action->type, status);
            return SCENE_EXECUTOR_ERR_ACTION_CORE;
        }
        executor->states[index].completed = completion.completed;
        /* Generic completion still applies subtype/dependency behavior;
         * handlers supply phase explicitly at the native callback boundary. */
        executor->states[index].phase = handler_result.phase;
        if (completion.reset_dependencies) {
            scene_conditions_reset(executor->conditions[index]);
        }
        break;
    }
    case SCENE_ACTION_HANDLER_DIRECT_COMPLETED:
        executor->states[index].completed = 1u;
        executor->states[index].phase = handler_result.phase;
        break;
    case SCENE_ACTION_HANDLER_RESET_DEPENDENCIES:
        executor->states[index].phase = 0u;
        scene_conditions_reset(executor->conditions[index]);
        break;
    default:
        executor->callback_transition_requested = 0;
        fill_failure(info, index, action->type, handler_result.disposition);
        return SCENE_EXECUTOR_ERR_EXTERNAL;
    }

    if (executor->callback_transition_requested) {
        executor->transition = executor->callback_transition;
        executor->transition_requested = 1;
        executor->callback_transition_requested = 0;
    }

    ++info->actions_applied;
    info->kind = SCENE_EXECUTOR_STEP_PROCESSED;
    return SCENE_EXECUTOR_OK;
}

int scene_executor_step_frame(SceneActionExecutor *executor,
                              const SceneConditionState *state,
                              const SceneActionHandler *handlers,
                              size_t handler_count,
                              const SceneExecutorFrameInput *frame_input,
                              SceneExecutorStepInfo *step_info)
{
    size_t index;
    SceneExecutorStepInfo local_info;
    SceneConditionState dispatch_state;

    if (step_info == NULL) {
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    memset(&local_info, 0, sizeof(local_info));
    local_info.kind = SCENE_EXECUTOR_STEP_IDLE;
    local_info.failed_action_index = SIZE_MAX;
    if (executor == NULL || state == NULL || frame_input == NULL ||
        !validate_handlers(handlers, handler_count)) {
        *step_info = local_info;
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    if (state->event_flags != executor->world->event_flags ||
        state->event_flag_count != executor->world->event_flag_count) {
        *step_info = local_info;
        return SCENE_EXECUTOR_ERR_STATE_MISMATCH;
    }
    if (executor->slot_revision == UINT64_MAX) {
        *step_info = local_info;
        return SCENE_EXECUTOR_ERR_LIMIT;
    }
    ++executor->slot_revision; /* A staged load cannot survive an intervening dispatch. */
    dispatch_state = *state;
    if (executor->transition_requested) {
        local_info.kind = SCENE_EXECUTOR_STEP_STOPPED;
        local_info.transition = executor->transition;
        *step_info = local_info;
        return SCENE_EXECUTOR_OK;
    }

    /* 43a7ca consumes the WM_LBUTTONUP latch (4daf3f) and, in 43bfb6, accepts
     * the global candidate 0x5c39e5 before calling 427a50. RT-6: the executor
     * keeps NO candidate of its own. The host's input module owns the single
     * retained value (scanned after the previous dispatch, first hit in row
     * order) and passes it with the accepted event. The original block does
     * not look at the row's type, only at [0,0xf0) and the modal word, so it
     * covers built-in hotspots and the 0x62 request rows alike. Modal /
     * completion / dependency guards mirror the original caller. */
    if (frame_input->hotspot_activation_event &&
        frame_input->activation_candidate_valid &&
        frame_input->activation_candidate >= 0) {
        size_t candidate = (size_t)frame_input->activation_candidate;
        if (!frame_input->modal_event_active &&
            candidate < executor->action_count &&
            candidate < SCENE_EXECUTOR_MAX_ACTIONS &&
            executor->slots[candidate].occupied &&
            !executor->states[candidate].completed) {
            SceneActionInfo candidate_action;
            int candidate_eligible = 0;
            int candidate_status;
            uint16_t candidate_opcode = 0u;
            candidate_action = executor->slots[candidate].action;
            candidate_status = SCENE_RESOURCE_OK;
            if (candidate_status != SCENE_RESOURCE_OK) {
                fill_failure(&local_info, candidate, 0u,
                             SCENE_RESOURCE_ERR_NOT_FOUND);
                *step_info = local_info;
                return SCENE_EXECUTOR_ERR_FORMAT;
            }
            {
                /* 0x43bff8: 0x42405a(root) returns the opcode-11 chain count.
                 * Empty chain: 0x43c048 accepts with no tree evaluation. Else
                 * 0x43c019 runs the wrapper with mode 0 and acceptance also
                 * needs the 0x424035 label read right afterwards to differ
                 * from -1 (the local starts at -1, 0x43a7e5). */
                SceneConditionTree *tree = executor->conditions[candidate];
                SceneExecutorCandidateDecision *decision = &executor->candidate_decision;
                memset(decision, 0, sizeof(*decision));
                decision->action_index = candidate;
                decision->label = -1;
                decision->first_chain_label = -1;
                decision->chain_count = scene_conditions_item_leaf_count(tree);
                (void)scene_conditions_first_item_label(tree, &decision->first_chain_label);
                if (decision->chain_count == 0u) {
                    decision->accepted = 1u;
                } else {
                    candidate_status = scene_conditions_evaluate_ex(
                        tree, &dispatch_state, executor->condition_extension, 0,
                        &candidate_eligible, &candidate_opcode,
                        &executor->condition_failure);
                    if (candidate_status != SCENE_CONDITION_OK) {
                        fill_failure(&local_info, candidate,
                                     candidate_action.type, candidate_status);
                        *step_info = local_info;
                        return condition_failure_to_executor_status(candidate_status);
                    }
                    decision->tree_evaluated = 1u;
                    decision->tree_satisfied = candidate_eligible ? 1u : 0u;
                    if (candidate_eligible) {
                        (void)scene_conditions_selected_item_label(tree, &decision->label);
                        decision->accepted = decision->label != -1 ? 1u : 0u;
                    }
                }
                if (decision->accepted) {
                    executor->states[candidate].phase = 2u;
                }
            }
        }
    }

    /* The original loader bakes each leaf's threshold, reading the
     * 0x5adb81 table, while the scene loads; the first dispatch is the native
     * equivalent point (idempotent). */
    if (executor->condition_extension != NULL) {
        size_t tree_index;
        for (tree_index = 0u; tree_index < executor->action_count; ++tree_index) {
            scene_conditions_resolve_thresholds(executor->conditions[tree_index],
                                                executor->condition_extension);
        }
    }

    /* 0x43cf25 stores 1 into 0x5c3a47 right before calling 0x427a50. */
    if (executor->condition_extension != NULL &&
        executor->condition_extension->pass_started != NULL) {
        executor->condition_extension->pass_started(
            executor->condition_extension->context);
    }

    for (index = 0u; index < executor->action_count; ++index) {
        SceneActionInfo action;
        SceneActionRuntimeState *runtime_state = &executor->states[index];
        SceneExecutorHotspotState *hotspot = &executor->hotspots[index];
        int eligible = 0;
        uint16_t unsupported_opcode = 0u;
        int status;

        if (!executor->slots[index].occupied || runtime_state->completed) {
            continue;
        }
        action = executor->slots[index].action;
        ++local_info.actions_considered;
        /* 0x427a50 stores the request clear before the type switch and the
         * dependency gate (see SceneActionPreGateFn). */
        run_pre_gate(executor, index, &action);
        if (is_builtin_hotspot(&action)) {
            hotspot->active = 0u;
        }
        status = scene_conditions_evaluate_ex(
            executor->conditions[index], &dispatch_state,
            executor->condition_extension,
            scene_conditions_gate_mode_for_type(
                executor->overlay36[index]
                    ? UINT8_C(0x36)
                    : (uint8_t)action_runtime_type(&action)),
            &eligible, &unsupported_opcode, &executor->condition_failure);
        if (status != SCENE_CONDITION_OK) {
            fill_failure(&local_info, index, action.type, status);
            *step_info = local_info;
            return condition_failure_to_executor_status(status);
        }
        if (!eligible) {
            /* 0x427a50's runtime-0x9f blocked-dependency branch executes this
             * subtype-2 reset of completion and phase only. Subtype 1
             * intentionally leaves both runtime fields alone. The raw-0x97
             * loader normalizes its slot to the same runtime type (0x40fcf3).
             * RT-21: runtime 0xa1 (raw 0xa1 keeps its type) maps to the same arm
             * 0x4297be through byte map 0x42aba4 / jump table 0x42a9b4. */
            if ((action.type == SCENE_ACTION_ASYNC_SOUND ||
                 action.type == SCENE_ACTION_RANDOM_SOUND ||
                 action.type == SCENE_ACTION_SOUND_A1) &&
                action.subtype == 2u) {
                runtime_state->completed = 0u;
                runtime_state->phase = 0u;
            }
            continue;
        }

        if (action.type == SCENE_ACTION_CHANGE_SCENE) {
            if (action.typed_body == NULL || action.typed_body_length != 20u) {
                fill_failure(&local_info, index, action.type,
                             ACTION_CORE_ERR_BODY);
                *step_info = local_info;
                return SCENE_EXECUTOR_ERR_FORMAT;
            }
            decode_scene_transition(action.typed_body, &executor->transition);
            runtime_state->completed = 1u;
            executor->transition_requested = 1;
            ++local_info.actions_applied;
            local_info.kind = SCENE_EXECUTOR_STEP_TRANSITION;
            local_info.transition = executor->transition;
            *step_info = local_info;
            return SCENE_EXECUTOR_OK;
        }

        if (is_builtin_hotspot(&action)) {
            status = apply_builtin_hotspot(executor, index, &action,
                                           frame_input, &local_info);
            if (status != SCENE_EXECUTOR_OK) {
                *step_info = local_info;
                return status;
            }
            if (executor->transition_requested) {
                *step_info = local_info;
                return SCENE_EXECUTOR_OK;
            }
            continue;
        }

        if (action.type == SCENE_ACTION_CLOCK) {
            ActionFamily64Input clock_action;
            ActionFamily64Result clock_result;
            ActionFamily64World clock_before;
            if (executor->action64_world == NULL ||
                executor->action64_backend == NULL) {
                fill_failure(&local_info, index, action.type,
                             ACTION_FAMILY64_ERR_UNSUPPORTED);
                *step_info = local_info;
                return SCENE_EXECUTOR_ERR_UNSUPPORTED;
            }
            clock_action.type = action.type;
            clock_action.subtype = action.subtype;
            clock_action.eligible = 1u;
            clock_action.completed_before = runtime_state->completed;
            clock_action.phase_before = runtime_state->phase;
            clock_action.body = action.typed_body;
            clock_action.body_length = action.typed_body_length;
            clock_before = *executor->action64_world;
            status = action_family64_step(&clock_action,
                                         executor->action64_world,
                                         executor->action64_backend,
                                         &clock_result);
            if (status != ACTION_FAMILY64_OK) {
                fill_failure(&local_info, index, action.type, status);
                *step_info = local_info;
                if (status == ACTION_FAMILY64_ERR_UNSUPPORTED) {
                    return SCENE_EXECUTOR_ERR_UNSUPPORTED;
                }
                return status == ACTION_FAMILY64_ERR_BODY
                           ? SCENE_EXECUTOR_ERR_FORMAT
                           : SCENE_EXECUTOR_ERR_EXTERNAL;
            }
            if (!clock_result.recognized || !clock_result.applied) {
                fill_failure(&local_info, index, action.type,
                             ACTION_FAMILY64_ERR_UNSUPPORTED);
                *step_info = local_info;
                return SCENE_EXECUTOR_ERR_UNSUPPORTED;
            }
            *executor->action64_world = clock_result.world;
            if (clock_result.completion_valid != 0u) {
                runtime_state->completed = clock_result.completed;
            }
            runtime_state->phase = clock_result.phase;
            if (clock_result.reset_dependencies != 0u) {
                scene_conditions_reset(executor->conditions[index]);
            }
            dispatch_state.time_of_day_minutes =
                clock_result.world.clock_total_585d4b;
            if (executor->action64_world_commit_observer != NULL &&
                action64_clock_fields_changed(&clock_before,
                                              &clock_result.world)) {
                executor->action64_world_commit_observer(
                    executor->action64_world_commit_context,
                    executor->action64_world);
            }
            ++local_info.actions_applied;
            local_info.kind = SCENE_EXECUTOR_STEP_PROCESSED;
            continue;
        }

        if (is_action_core_type(action.type)) {
            ActionCoreAction core_action;
            ActionCoreActionResult core_result;
            core_action.type = action.type;
            core_action.subtype = action.subtype;
            core_action.eligible = 1u;
            core_action.completed_before = runtime_state->completed;
            core_action.phase_before = runtime_state->phase;
            core_action.body = action.typed_body;
            core_action.body_length = action.typed_body_length;
            status = action_core_dispatch(executor->world, &core_action, 1u,
                                          &core_result);
            if (status != ACTION_CORE_OK) {
                fill_failure(&local_info, index, action.type, status);
                *step_info = local_info;
                return status == ACTION_CORE_ERR_UNSUPPORTED
                           ? SCENE_EXECUTOR_ERR_UNSUPPORTED
                           : SCENE_EXECUTOR_ERR_ACTION_CORE;
            }
            if (!core_result.recognized || !core_result.applied) {
                fill_failure(&local_info, index, action.type,
                             ACTION_CORE_ERR_UNSUPPORTED);
                *step_info = local_info;
                return SCENE_EXECUTOR_ERR_UNSUPPORTED;
            }
            runtime_state->completed = core_result.completed;
            runtime_state->phase = core_result.phase;
            if (core_result.reset_dependencies) {
                scene_conditions_reset(executor->conditions[index]);
            }
            ++local_info.actions_applied;
            local_info.kind = SCENE_EXECUTOR_STEP_PROCESSED;
            continue;
        }

        {
            const SceneActionHandler *handler = find_handler(
                handlers, handler_count, action.type);
            if (handler == NULL) {
                fill_failure(&local_info, index, action.type,
                             SCENE_ACTION_HANDLER_UNSUPPORTED);
                *step_info = local_info;
                return SCENE_EXECUTOR_ERR_UNSUPPORTED;
            }
            status = apply_external_handler(executor, index, &action,
                                            handler, &local_info);
            if (status != SCENE_EXECUTOR_OK) {
                *step_info = local_info;
                return status;
            }
            if (executor->transition_requested) {
                local_info.kind = SCENE_EXECUTOR_STEP_TRANSITION;
                local_info.transition = executor->transition;
                *step_info = local_info;
                return SCENE_EXECUTOR_OK;
            }
        }
    }

    /* The 4d3073 -> 4f0059 cursor scan that follows the dispatcher is not an
     * executor concern any more (RT-6): the session reads the hotspot
     * snapshot after this step and the input module scans it. */

    *step_info = local_info;
    return SCENE_EXECUTOR_OK;
}

int scene_executor_step(SceneActionExecutor *executor,
                        const SceneConditionState *state,
                        const SceneActionHandler *handlers,
                        size_t handler_count,
                        SceneExecutorStepInfo *step_info)
{
    const SceneExecutorFrameInput frame_input = {0, 0, 0, 0u, 0u, 0u, 0u, 0u, 0};
    return scene_executor_step_frame(executor, state, handlers, handler_count,
                                     &frame_input, step_info);
}

int scene_executor_set_condition_extension(
    SceneActionExecutor *executor,
    const SceneConditionExtension *extension)
{
    if (executor == NULL) {
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    executor->condition_extension = extension;
    return SCENE_EXECUTOR_OK;
}

int scene_executor_get_candidate_decision(const SceneActionExecutor *executor,
                                          SceneExecutorCandidateDecision *decision)
{
    if (executor == NULL || decision == NULL) {
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    *decision = executor->candidate_decision;
    return SCENE_EXECUTOR_OK;
}

int scene_executor_get_condition_failure(const SceneActionExecutor *executor,
                                         SceneConditionFailure *failure)
{
    if (executor == NULL || failure == NULL) {
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    *failure = executor->condition_failure;
    return SCENE_EXECUTOR_OK;
}

int scene_executor_get_selected_item_label(const SceneActionExecutor *executor,
                                           size_t action_index,
                                           int32_t *label)
{
    if (label != NULL) {
        *label = -1;
    }
    if (executor == NULL || label == NULL ||
        action_index >= executor->action_count) {
        return 0;
    }
    return scene_conditions_selected_item_label(
        executor->conditions[action_index], label);
}

int scene_executor_get_action_state(const SceneActionExecutor *executor,
                                    size_t action_index,
                                    SceneActionRuntimeState *state)
{
    if (executor == NULL || state == NULL) {
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    if (action_index >= executor->action_count) {
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    *state = executor->states[action_index];
    return SCENE_EXECUTOR_OK;
}

int scene_executor_get_action_overlay36(const SceneActionExecutor *executor,
                                        size_t action_index, int *is_overlay36)
{
    if (executor == NULL || is_overlay36 == NULL || action_index >= executor->action_count) {
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    *is_overlay36 = executor->overlay36[action_index] != 0u;
    return SCENE_EXECUTOR_OK;
}

int scene_executor_get_hotspot_state(const SceneActionExecutor *executor,
                                     size_t action_index,
                                     SceneExecutorHotspotState *state)
{
    if (executor == NULL || state == NULL) {
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    if (action_index >= executor->action_count) {
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    *state = executor->hotspots[action_index];
    if (!executor->slots[action_index].occupied) state->active = 0u;
    return SCENE_EXECUTOR_OK;
}

int scene_executor_request_transition(SceneActionExecutor *executor,
                                      const SceneTransitionRequest *request)
{
    if (executor == NULL || request == NULL) {
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    if (!executor->in_external_callback ||
        executor->callback_transition_requested || executor->transition_requested) {
        return SCENE_EXECUTOR_ERR_STATE_MISMATCH;
    }
    executor->callback_transition = *request;
    executor->callback_transition_requested = 1;
    return SCENE_EXECUTOR_OK;
}

int scene_executor_retire_action(SceneActionExecutor *executor, size_t action_index)
{
    if (executor == NULL || action_index >= executor->action_count) {
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    if (executor->slot_revision == UINT64_MAX) return SCENE_EXECUTOR_ERR_LIMIT;
    ++executor->slot_revision;
    executor->states[action_index].completed = 1u;
    executor->states[action_index].phase = 0u;
    scene_conditions_reset(executor->conditions[action_index]);
    return SCENE_EXECUTOR_OK;
}

const char *scene_executor_status_string(int status)
{
    switch (status) {
    case SCENE_EXECUTOR_OK: return "ok";
    case SCENE_EXECUTOR_ERR_ARGUMENT: return "invalid scene executor argument";
    case SCENE_EXECUTOR_ERR_MEMORY: return "scene executor allocation failed";
    case SCENE_EXECUTOR_ERR_LIMIT: return "scene action or dependency limit exceeded";
    case SCENE_EXECUTOR_ERR_FORMAT: return "invalid scene action metadata";
    case SCENE_EXECUTOR_ERR_CONDITION: return "scene action condition evaluation failed";
    case SCENE_EXECUTOR_ERR_UNSUPPORTED: return "scene action type or condition is unsupported";
    case SCENE_EXECUTOR_ERR_ACTION_CORE: return "action core rejected scene action";
    case SCENE_EXECUTOR_ERR_EXTERNAL: return "external scene action handler failed";
    case SCENE_EXECUTOR_ERR_STATE_MISMATCH: return "condition event flags do not match action world";
    default: return "unknown scene executor status";
    }
}

#ifdef SCENE_EXECUTOR_TEST_HOOKS
int scene_executor_test_condition_node_status(
    const SceneActionExecutor *executor,
    size_t action_index,
    size_t node_index,
    int32_t *out_status)
{
    if (executor == NULL || out_status == NULL ||
        action_index >= executor->action_count) {
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    }
    return scene_conditions_test_node_status(executor->conditions[action_index],
                                             node_index, out_status) ==
                   SCENE_CONDITION_OK
               ? SCENE_EXECUTOR_OK
               : SCENE_EXECUTOR_ERR_ARGUMENT;
}
#endif


struct SceneExecutorAppend {
    SceneActionExecutor *incoming;
    SceneActionExecutor *owner;
    uint64_t revision;
    SceneActionSlotPlan plan;
};

size_t scene_executor_action_high_water(const SceneActionExecutor *e)
{ return e == NULL ? 0u : e->action_count; }

int scene_executor_get_slot(const SceneActionExecutor *e, size_t i, SceneExecutorSlotInfo *out)
{
    if (e == NULL || out == NULL || i >= e->action_count) return SCENE_EXECUTOR_ERR_ARGUMENT;
    *out = e->slots[i];
    out->condition_tree = out->occupied ? e->conditions[i] : NULL;
    out->runtime_type = !out->occupied ? 0u : e->overlay36[i] ? UINT8_C(0x36) :
        out->action.type == SCENE_ACTION_RANDOM_SOUND ? UINT8_C(0x9f) :
        (uint8_t)action_runtime_type(&out->action);
    return SCENE_EXECUTOR_OK;
}

int scene_executor_erase_action(SceneActionExecutor *e, size_t i, uint8_t completed)
{
    if (e == NULL || i >= e->action_count || e->slot_revision == UINT64_MAX)
        return SCENE_EXECUTOR_ERR_ARGUMENT;
    scene_conditions_destroy(e->conditions[i]);
    e->conditions[i] = NULL;
    memset(&e->slots[i], 0, sizeof(e->slots[i]));
    memset(&e->states[i], 0, sizeof(e->states[i]));
    e->states[i].completed = completed != 0u;
    e->overlay36[i] = 0u;
    memset(&e->hotspots[i], 0, sizeof(e->hotspots[i]));
    ++e->slot_revision;
    return SCENE_EXECUTOR_OK;
}

int scene_executor_prepare_append(SceneActionExecutor *e, const SceneResource *source,
    const SceneActionSlotPlan *plan, SceneExecutorAppend **out, size_t *failed)
{
    SceneExecutorAppend *p;
    uint8_t used[SCENE_EXECUTOR_MAX_ACTIONS] = {0};
    int status;
    if (out != NULL) *out = NULL;
    if (e == NULL || source == NULL || plan == NULL || out == NULL || e->in_external_callback ||
        e->slot_revision == UINT64_MAX || plan->source_high_water != e->action_count ||
        plan->final_high_water > SCENE_EXECUTOR_MAX_ACTIONS ||
        plan->incoming_count != scene_resource_action_count(source) ||
        plan->incoming_count > SCENE_EXECUTOR_MAX_ACTIONS) return SCENE_EXECUTOR_ERR_ARGUMENT;
    for (size_t i = 0; i < plan->incoming_count; ++i) {
        const size_t slot = plan->assigned[i];
        if (slot >= plan->final_high_water || used[slot] ||
            (slot < e->action_count && e->slots[slot].occupied && !plan->retired[slot]))
            return SCENE_EXECUTOR_ERR_ARGUMENT;
        used[slot] = 1u;
    }
    for (size_t i = plan->final_high_water; i < e->action_count; ++i)
        if (e->slots[i].occupied && !plan->retired[i]) return SCENE_EXECUTOR_ERR_ARGUMENT;
    p = calloc(1u, sizeof(*p));
    if (p == NULL) return SCENE_EXECUTOR_ERR_MEMORY;
    status = scene_executor_create(source, e->world, SCENE_EXECUTOR_MAX_ACTIONS, &p->incoming, failed);
    if (status != SCENE_EXECUTOR_OK) { free(p); return status; }
    p->owner = e;
    p->revision = e->slot_revision;
    p->plan = *plan;
    *out = p;
    return SCENE_EXECUTOR_OK;
}

int scene_executor_can_commit_append(const SceneActionExecutor *e, const SceneExecutorAppend *p)
{
    return e != NULL && p != NULL && p->owner == e && p->revision == e->slot_revision &&
        !e->in_external_callback && e->slot_revision != UINT64_MAX;
}

int scene_executor_commit_append(SceneActionExecutor *e, SceneExecutorAppend *p)
{
    if (!scene_executor_can_commit_append(e, p)) return SCENE_EXECUTOR_ERR_ARGUMENT;
    for (size_t i = 0; i < e->action_count; ++i) if (p->plan.retired[i]) {
        scene_conditions_destroy(e->conditions[i]);
        e->conditions[i] = NULL;
        memset(&e->slots[i], 0, sizeof(e->slots[i]));
        memset(&e->states[i], 0, sizeof(e->states[i]));
        e->overlay36[i] = 0u;
        memset(&e->hotspots[i], 0, sizeof(e->hotspots[i]));
    }
    for (size_t i = 0; i < p->plan.incoming_count; ++i) {
        const size_t slot = p->plan.assigned[i];
        e->slots[slot] = p->incoming->slots[i];
        e->states[slot] = p->incoming->states[i];
        e->overlay36[slot] = p->incoming->overlay36[i];
        e->hotspots[slot] = p->incoming->hotspots[i];
        e->conditions[slot] = p->incoming->conditions[i];
        p->incoming->conditions[i] = NULL;
    }
    e->action_count = p->plan.final_high_water;
    e->transition_requested = e->callback_transition_requested = 0;
    memset(&e->transition, 0, sizeof(e->transition));
    memset(&e->callback_transition, 0, sizeof(e->callback_transition));
    ++e->slot_revision;
    p->owner = NULL;
    return SCENE_EXECUTOR_OK;
}

void scene_executor_discard_append(SceneExecutorAppend *p)
{
    if (p != NULL) { scene_executor_destroy(p->incoming); free(p); }
}
