#include "session_bindings_a62.h"

#include "action_family_62.h"

#include <stdlib.h>
#include <string.h>

struct SessionA62Binding {
    ActionCoreWorld *world;
    SessionA62Host host;
    size_t row_count;
    ActionFamily62InteractionTarget targets[SCENE_EXECUTOR_MAX_ACTIONS];
    int32_t start_flag_5bb1ca;
    SessionA62Failure last_failure;
};

SessionA62Binding *session_a62_create(ActionCoreWorld *world,
                                      const SessionA62Host *host)
{
    SessionA62Binding *binding;
    if (world == NULL || host == NULL || host->current_selector == NULL ||
        (world->event_flag_count != 0u && world->event_flags == NULL)) {
        return NULL;
    }
    binding = (SessionA62Binding *)calloc(1u, sizeof(*binding));
    if (binding == NULL) {
        return NULL;
    }
    binding->world = world;
    binding->host = *host;
    return binding;
}

void session_a62_destroy(SessionA62Binding *binding)
{
    free(binding);
}

int session_a62_begin_scene(SessionA62Binding *binding, size_t action_count)
{
    if (binding == NULL || action_count > SCENE_EXECUTOR_MAX_ACTIONS) {
        return SESSION_A62_ERR_ARGUMENT;
    }
    memset(binding->targets, 0, sizeof(binding->targets));
    binding->row_count = action_count;
    binding->last_failure = SESSION_A62_FAIL_NONE;
    return SESSION_A62_OK;
}

static int refuse(SessionA62Binding *binding, SessionA62Failure failure,
                  int handler_status)
{
    binding->last_failure = failure;
    return handler_status;
}

void session_a62_pre_gate(void *context,
                          size_t action_index,
                          const SceneActionInfo *action,
                          const SceneActionRuntimeState *state)
{
    SessionA62Binding *binding = (SessionA62Binding *)context;
    (void)state;
    if (binding == NULL || action == NULL || action->type != SESSION_A62_TYPE ||
        action_index >= binding->row_count) {
        return;
    }
    /* 0x427a50: `mov [row*0x8d + 0x5bb626], 0` before the dependency gate.
     * Response words (slots +0x47..+0x4d) are not touched. */
    binding->targets[action_index].request_pending = 0u;
}

int session_a62_handler(void *context,
                        size_t action_index,
                        const SceneActionInfo *action,
                        const SceneActionRuntimeState *state_before,
                        SceneActionHandlerResult *result)
{
    SessionA62Binding *binding = (SessionA62Binding *)context;
    ActionFamily62Decoded decoded;
    ActionFamily62Input input;
    ActionFamily62Result step;
    ActionFamily62InteractionTarget target;
    ActionCoreActionResult finish;
    int16_t selector = 0;
    size_t pair;

    if (binding == NULL || action == NULL || state_before == NULL ||
        result == NULL) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    binding->last_failure = SESSION_A62_FAIL_NONE;
    if (action->type != SESSION_A62_TYPE) {
        return refuse(binding, SESSION_A62_FAIL_ARGUMENT,
                      SCENE_ACTION_HANDLER_ERROR);
    }
    if (action_index >= binding->row_count) {
        return refuse(binding, SESSION_A62_FAIL_ROW_RANGE,
                      SCENE_ACTION_HANDLER_ERROR);
    }
    if (action_family_62_decode(action->type, action->typed_body,
                                action->typed_body_length, &decoded) !=
        ACTION_FAMILY_62_OK) {
        return refuse(binding, SESSION_A62_FAIL_BODY,
                      SCENE_ACTION_HANDLER_ERROR);
    }

    /* The selector is compared only in phases 0 and 1 (0x42ebb0 lies on the
     * scan path); phase 2 never reads it, so it is not requested there. */
    if (state_before->phase <= 1u) {
        if (binding->host.current_selector(binding->host.context, &selector) !=
            0) {
            return refuse(binding, SESSION_A62_FAIL_SELECTOR_UNAVAILABLE,
                          SCENE_ACTION_HANDLER_UNSUPPORTED);
        }
    }

    memset(&input, 0, sizeof(input));
    input.subtype = action->subtype;
    input.eligible = 1u;
    input.completed_before = state_before->completed;
    input.phase_before = (int32_t)state_before->phase;
    input.selector = selector;
    if (action_family_62_step(&decoded, &input, NULL, &step) !=
        ACTION_FAMILY_62_OK) {
        return refuse(binding, SESSION_A62_FAIL_BODY,
                      SCENE_ACTION_HANDLER_ERROR);
    }

    /* Validate everything that can fail before the first state write, so a
     * rejected visit leaves the world exactly as it was. */
    for (pair = 0u; pair < step.event_write_count; ++pair) {
        const int32_t id = step.event_writes[pair].event_id;
        if (id < 0 || (size_t)id >= binding->world->event_flag_count) {
            return refuse(binding, SESSION_A62_FAIL_EVENT_ID_RANGE,
                          SCENE_ACTION_HANDLER_ERROR);
        }
    }
    memset(&finish, 0, sizeof(finish));
    if (step.completion_written != 0u && (action->subtype == 1u ||
                                          action->subtype == 2u)) {
        /* The executor re-derives completion and the dependency reset from the
         * subtype (0x42ba3a). It must agree with the reducer. */
        if (action_core_finish_action(action->subtype,
                                      state_before->completed, &finish) !=
                ACTION_CORE_OK ||
            finish.completed != step.completed_after ||
            (finish.reset_dependencies != 0u) !=
                (step.dependency_reset_requested != 0u)) {
            return refuse(binding, SESSION_A62_FAIL_DISPOSITION_MISMATCH,
                          SCENE_ACTION_HANDLER_ERROR);
        }
    }

    /* Commit in the original's store order. */
    if (step.start_global_written != 0u) {
        binding->start_flag_5bb1ca = (int32_t)step.start_global_value;
        if (binding->host.set_start_flag != NULL) {
            binding->host.set_start_flag(binding->host.context,
                                         binding->start_flag_5bb1ca);
        }
    }
    target = binding->targets[action_index];
    if (step.request_written != 0u) {
        target.request_pending = step.request_value;
    }
    if (step.response_written != 0u) {
        memcpy(target.response_words, step.response_words,
               sizeof(target.response_words));
    }
    binding->targets[action_index] = target;
    for (pair = 0u; pair < step.event_write_count; ++pair) {
        binding->world->event_flags[step.event_writes[pair].event_id] =
            (int32_t)step.event_writes[pair].value;
    }

    result->phase = step.phase_written != 0u ? (uint32_t)step.phase_after
                                             : state_before->phase;
    if (step.completion_written == 0u) {
        result->disposition = SCENE_ACTION_HANDLER_PENDING;
    } else if (action->subtype == 1u || action->subtype == 2u) {
        result->disposition = SCENE_ACTION_HANDLER_COMPLETED;
    } else {
        result->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;
    }
    return SCENE_ACTION_HANDLER_OK;
}

int session_a62_get_target(const SessionA62Binding *binding,
                           size_t action_index,
                           ActionFamily62InteractionTarget *target)
{
    if (binding == NULL || target == NULL) {
        return SESSION_A62_ERR_ARGUMENT;
    }
    if (action_index >= binding->row_count) {
        return SESSION_A62_ERR_ROW;
    }
    *target = binding->targets[action_index];
    return SESSION_A62_OK;
}

int32_t session_a62_start_flag(const SessionA62Binding *binding)
{
    return binding == NULL ? 0 : binding->start_flag_5bb1ca;
}

SessionA62Failure session_a62_last_failure(const SessionA62Binding *binding)
{
    return binding == NULL ? SESSION_A62_FAIL_ARGUMENT : binding->last_failure;
}

const char *session_a62_failure_string(SessionA62Failure failure)
{
    switch (failure) {
    case SESSION_A62_FAIL_NONE: return "none";
    case SESSION_A62_FAIL_SELECTOR_UNAVAILABLE:
        return "selector DAT_005bb50b not provable for this scene";
    case SESSION_A62_FAIL_BODY: return "invalid 0x62 body";
    case SESSION_A62_FAIL_EVENT_ID_RANGE:
        return "event id outside the host event-flag view";
    case SESSION_A62_FAIL_ROW_RANGE: return "action row outside the scene";
    case SESSION_A62_FAIL_DISPOSITION_MISMATCH:
        return "executor completion disagrees with the 0x62 reducer";
    case SESSION_A62_FAIL_ARGUMENT: return "invalid argument";
    default: return "unknown failure";
    }
}

int session_a62_scan_candidate(const SessionA62Binding *binding,
                               const SessionA62ScanRequest *request,
                               ActionFamily62InteractionScanResult *result)
{
    ActionFamily62InteractionScanInput input;
    if (binding == NULL || request == NULL || result == NULL) {
        return SESSION_A62_ERR_ARGUMENT;
    }
    memset(&input, 0, sizeof(input));
    input.targets = binding->targets;
    input.target_count = binding->row_count;
    input.coordinate_a = request->coordinate_a;
    input.coordinate_b = request->coordinate_b;
    input.reserved_index_a = request->reserved_index_a;
    input.reserved_index_b = request->reserved_index_b;
    input.cursor_command = request->cursor_command;
    return action_family_62_interaction_scan(&input, result) ==
                   ACTION_FAMILY_62_INTERACTION_OK
               ? SESSION_A62_OK : SESSION_A62_ERR_ARGUMENT;
}
