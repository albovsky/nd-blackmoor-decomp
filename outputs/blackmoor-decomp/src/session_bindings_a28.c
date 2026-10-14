#include "session_bindings_a28.h"

#include "action_core.h"

#include <stdlib.h>

struct SessionA28Binding {
    SessionExit *exit_state;
    SessionA28Failure last_failure;
};

SessionA28Binding *session_a28_create(SessionExit *exit_state)
{
    SessionA28Binding *binding;
    if (exit_state == NULL) {
        return NULL;
    }
    binding = (SessionA28Binding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        binding->exit_state = exit_state;
    }
    return binding;
}

void session_a28_destroy(SessionA28Binding *binding)
{
    free(binding);
}

static int refuse(SessionA28Binding *binding, SessionA28Failure failure)
{
    binding->last_failure = failure;
    return SCENE_ACTION_HANDLER_ERROR;
}

int session_a28_handler(void *context,
                        size_t action_index,
                        const SceneActionInfo *action,
                        const SceneActionRuntimeState *state_before,
                        SceneActionHandlerResult *result)
{
    SessionA28Binding *binding = (SessionA28Binding *)context;
    ActionFamily28Input input;
    ActionFamily28Result step;
    ActionCoreActionResult finish;
    int status;

    (void)action_index;
    if (binding == NULL || action == NULL || state_before == NULL ||
        result == NULL) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    binding->last_failure = SESSION_A28_FAIL_NONE;
    if (action->type != SESSION_A28_TYPE) {
        return refuse(binding, SESSION_A28_FAIL_ARGUMENT);
    }
    input.type = action->type;
    input.subtype = action->subtype;
    input.eligible = 1u;    /* the executor evaluated the dependency gate */
    input.completed_before = state_before->completed;
    input.phase_before = state_before->phase;
    input.body = action->typed_body;
    input.body_length = action->typed_body_length;
    status = action_family28_step(&input, &binding->exit_state->effect, &step);
    if (status != ACTION_FAMILY28_OK) {
        return refuse(binding, SESSION_A28_FAIL_BODY);
    }
    /* The executor re-derives completion and the dependency reset from the
     * subtype (0x42ba3a); it must agree with the kernel. */
    if (step.completion_valid != 0u &&
        (action->subtype == 1u || action->subtype == 2u)) {
        if (action_core_finish_action(action->subtype, state_before->completed,
                                      &finish) != ACTION_CORE_OK ||
            finish.completed != step.completed ||
            (finish.reset_dependencies != 0u) != (step.reset_dependencies != 0u)) {
            return refuse(binding, SESSION_A28_FAIL_DISPOSITION_MISMATCH);
        }
    }
    binding->exit_state->effect = step.world;
    result->phase = step.phase;
    if (step.completion_valid != 0u &&
        (action->subtype == 1u || action->subtype == 2u)) {
        result->disposition = SCENE_ACTION_HANDLER_COMPLETED;
    } else {
        result->disposition = SCENE_ACTION_HANDLER_PENDING;
    }
    return SCENE_ACTION_HANDLER_OK;
}

SessionA28Failure session_a28_last_failure(const SessionA28Binding *binding)
{
    return binding == NULL ? SESSION_A28_FAIL_ARGUMENT : binding->last_failure;
}

const char *session_a28_failure_string(SessionA28Failure failure)
{
    switch (failure) {
    case SESSION_A28_FAIL_NONE: return "none";
    case SESSION_A28_FAIL_ARGUMENT: return "invalid argument";
    case SESSION_A28_FAIL_BODY: return "invalid 0x28 body";
    case SESSION_A28_FAIL_DISPOSITION_MISMATCH:
        return "executor completion disagrees with the 0x28 kernel";
    default: return "unknown failure";
    }
}
