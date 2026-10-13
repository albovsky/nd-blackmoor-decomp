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
    SCENE_ACTION_ASYNC_SOUND = 0x9f
};

struct SceneActionExecutor {
    const SceneResource *scene;
    ActionCoreWorld *world;
    size_t action_count;
    SceneConditionTree **conditions;
    SceneActionRuntimeState *states;
    SceneExecutorHotspotState *hotspots;
    size_t pending_hotspot_index;
    int has_pending_hotspot;
    int in_external_callback;
    int callback_transition_requested;
    SceneTransitionRequest callback_transition;
    int transition_requested;
    SceneTransitionRequest transition;
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

static int action_runtime_type(const SceneActionInfo *action)
{
    if (action->type == SCENE_ACTION_RAW_SCENE_HOTSPOT &&
        action->typed_body != NULL && action->typed_body_length == 20u &&
        action->typed_body[0] == SCENE_ACTION_SCENE_HOTSPOT_RUNTIME) {
        return SCENE_ACTION_SCENE_HOTSPOT_RUNTIME;
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
    executor->scene = scene;
    executor->world = world;
    executor->action_count = action_count;
    if (action_count != 0u) {
        executor->conditions = (SceneConditionTree **)calloc(
            action_count, sizeof(*executor->conditions));
        executor->states = (SceneActionRuntimeState *)calloc(
            action_count, sizeof(*executor->states));
        executor->hotspots = (SceneExecutorHotspotState *)calloc(
            action_count, sizeof(*executor->hotspots));
        if (executor->conditions == NULL || executor->states == NULL ||
            executor->hotspots == NULL) {
            scene_executor_destroy(executor);
            return SCENE_EXECUTOR_ERR_MEMORY;
        }
    }

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
        scene_conditions_destroy(executor->conditions == NULL
                                     ? NULL
                                     : executor->conditions[index]);
    }
    free(executor->conditions);
    free(executor->states);
    free(executor->hotspots);
    free(executor);
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
    if (executor->transition_requested) {
        local_info.kind = SCENE_EXECUTOR_STEP_STOPPED;
        local_info.transition = executor->transition;
        *step_info = local_info;
        return SCENE_EXECUTOR_OK;
    }

    /* 43a7ca consumes the WM_LBUTTONUP latch and accepts the candidate cached
     * by the preceding 4d3073/4f0059 cursor scan before calling 427a50. The
     * host supplies this message-map-verified event gate explicitly. Candidate
     * and modal/completion/dependency guards mirror the original caller. */
    if (executor->has_pending_hotspot) {
        size_t candidate = executor->pending_hotspot_index;
        executor->has_pending_hotspot = 0;
        executor->pending_hotspot_index = SIZE_MAX;
        if (frame_input->hotspot_activation_event &&
            !frame_input->modal_event_active &&
            candidate < executor->action_count &&
            candidate < SCENE_EXECUTOR_MAX_ACTIONS &&
            !executor->states[candidate].completed) {
            SceneActionInfo candidate_action;
            int candidate_eligible = 0;
            int candidate_status;
            uint16_t candidate_opcode = 0u;
            candidate_status = scene_resource_action_at(executor->scene,
                                                        candidate,
                                                        &candidate_action);
            if (candidate_status != SCENE_RESOURCE_OK) {
                fill_failure(&local_info, candidate, 0u,
                             SCENE_RESOURCE_ERR_NOT_FOUND);
                *step_info = local_info;
                return SCENE_EXECUTOR_ERR_FORMAT;
            }
            if (is_builtin_hotspot(&candidate_action)) {
                candidate_status = scene_conditions_evaluate(
                    executor->conditions[candidate], state,
                    &candidate_eligible, &candidate_opcode);
                if (candidate_status != SCENE_CONDITION_OK) {
                    fill_failure(&local_info, candidate,
                                 candidate_action.type, candidate_status);
                    *step_info = local_info;
                    return candidate_status ==
                                   SCENE_CONDITION_ERR_UNSUPPORTED_OPCODE
                               ? SCENE_EXECUTOR_ERR_UNSUPPORTED
                               : SCENE_EXECUTOR_ERR_CONDITION;
                }
                if (candidate_eligible) {
                    executor->states[candidate].phase = 2u;
                }
            }
        }
    }

    for (index = 0u; index < executor->action_count; ++index) {
        SceneActionInfo action;
        SceneActionRuntimeState *runtime_state = &executor->states[index];
        SceneExecutorHotspotState *hotspot = &executor->hotspots[index];
        int eligible = 0;
        uint16_t unsupported_opcode = 0u;
        int status;

        if (runtime_state->completed) {
            continue;
        }
        if (scene_resource_action_at(executor->scene, index, &action) !=
            SCENE_RESOURCE_OK) {
            fill_failure(&local_info, index, 0u, SCENE_RESOURCE_ERR_NOT_FOUND);
            *step_info = local_info;
            return SCENE_EXECUTOR_ERR_FORMAT;
        }
        ++local_info.actions_considered;
        if (is_builtin_hotspot(&action)) {
            hotspot->active = 0u;
        }
        status = scene_conditions_evaluate(executor->conditions[index], state,
                                          &eligible, &unsupported_opcode);
        if (status != SCENE_CONDITION_OK) {
            fill_failure(&local_info, index, action.type, status);
            *step_info = local_info;
            return status == SCENE_CONDITION_ERR_UNSUPPORTED_OPCODE
                       ? SCENE_EXECUTOR_ERR_UNSUPPORTED
                       : SCENE_EXECUTOR_ERR_CONDITION;
        }
        if (!eligible) {
            /* 0x427a50's type-0x9f blocked-dependency branch executes this
             * subtype-2 reset on every pass. Subtype 1 intentionally leaves
             * the runtime phase and completion byte alone. */
            if (action.type == SCENE_ACTION_ASYNC_SOUND &&
                action.subtype == 2u) {
                runtime_state->completed = 0u;
                runtime_state->phase = 0u;
                scene_conditions_reset(executor->conditions[index]);
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

    /* 4d3073 clears the global candidate before its 4f0059 cursor scan. Do
     * the same even when the current frame has no usable pointer, otherwise
     * a hover from an older frame would survive an intervening miss. */
    executor->has_pending_hotspot = 0;
    executor->pending_hotspot_index = SIZE_MAX;

    /* 4f0059 scans active action rectangles using inclusive bounds. The host
     * supplies the cursor hot point after viewport-origin, scene-scroll, and
     * cursor-sprite-offset transforms; a primary-button check is not part of
     * this recovered rectangle loop. */
    if (frame_input->pointer_valid &&
        frame_input->cursor_context_allowed) {
        for (index = 0u; index < executor->action_count; ++index) {
            const SceneExecutorHotspotState *hotspot = &executor->hotspots[index];
            if (hotspot->active && hotspot->rectangle_valid &&
                frame_input->pointer_y >= hotspot->top &&
                frame_input->pointer_y <= hotspot->bottom &&
                frame_input->pointer_x >= hotspot->left &&
                frame_input->pointer_x <= hotspot->right) {
                executor->pending_hotspot_index = index;
                executor->has_pending_hotspot = 1;
            }
        }
    }

    *step_info = local_info;
    return SCENE_EXECUTOR_OK;
}

int scene_executor_step(SceneActionExecutor *executor,
                        const SceneConditionState *state,
                        const SceneActionHandler *handlers,
                        size_t handler_count,
                        SceneExecutorStepInfo *step_info)
{
    const SceneExecutorFrameInput frame_input = {0, 0, 0, 0u, 0u, 0u, 0u};
    return scene_executor_step_frame(executor, state, handlers, handler_count,
                                     &frame_input, step_info);
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
