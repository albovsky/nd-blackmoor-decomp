#include "session_bindings_a47.h"

#include <stdlib.h>
#include <string.h>

struct SessionA47Binding {
    SessionA47Host host;
    A47Tables tables;
    A47Outcome last;
    unsigned long visits;
    unsigned long adds;
    const char *failure;
};

SessionA47Binding *session_a47_create(const SessionA47Host *host)
{
    SessionA47Binding *binding = (SessionA47Binding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        if (host != NULL) {
            binding->host = *host;
        }
        binding->failure = "none";
        binding->last.flag_slot = -1;
        binding->last.table = -1;
        binding->last.index = -1;
    }
    return binding;
}

void session_a47_destroy(SessionA47Binding *binding)
{
    free(binding);
}

void session_a47_reset(SessionA47Binding *binding)
{
    if (binding != NULL) {
        memset(&binding->tables, 0, sizeof(binding->tables));
    }
}

static int host_lookup(void *context, const uint8_t *key, size_t key_length)
{
    const SessionA47Binding *binding = (const SessionA47Binding *)context;
    const uint8_t *text = NULL;
    size_t text_length = 0u;
    switch (binding->host.lookup(binding->host.lookup_context, key, key_length, &text, &text_length)) {
    case ACTION_FAMILY_51_LOOKUP_FOUND:
        return 1;
    case ACTION_FAMILY_51_LOOKUP_NOT_FOUND:
        return 0;
    default:
        return -1;
    }
}

int session_a47_handler(void *context, size_t action_index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *state_before, SceneActionHandlerResult *result)
{
    SessionA47Binding *binding = (SessionA47Binding *)context;
    A47Body body;
    int status;

    (void)action_index;
    if (binding == NULL || action == NULL || state_before == NULL || result == NULL || action->type != SESSION_A47_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (a47_decode(action->raw_body, action->raw_body_length, &body) != A47_OK) {
        binding->failure = "raw 0x47 body is shorter than 39 bytes or its name is not terminated";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    ++binding->visits;
    status = a47_step(&binding->tables, &body, binding->host.lookup != NULL ? host_lookup : NULL, binding, &binding->last);
    switch (status) {
    case A47_OK:
        break;
    case A47_ERR_UNBOUND:
        binding->failure = "AUTOTEXT lookup 0x423259 is not bound";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    case A47_ERR_KIND:
        binding->failure = "raw 0x47 kind is not 3, 4 or 5";
        return SCENE_ACTION_HANDLER_ERROR;
    case A47_ERR_FULL:
        /* the original reports "AUTOTEXT error - too many list entries on page" and overruns into the next table */
        binding->failure = "journal table is full (400 entries)";
        return SCENE_ACTION_HANDLER_ERROR;
    case A47_ERR_LOOKUP:
        binding->failure = "AUTOTEXT lookup failed";
        return SCENE_ACTION_HANDLER_ERROR;
    default:
        binding->failure = "raw 0x47 visit rejected by the kernel";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    binding->adds += binding->last.appended;
    /* 0x4129c5: 0x42ba3a(row) */
    result->disposition = SCENE_ACTION_HANDLER_COMPLETED;
    result->phase = 0u;
    return SCENE_ACTION_HANDLER_OK;
}

const A47Tables *session_a47_tables(const SessionA47Binding *binding)
{
    return binding == NULL ? NULL : &binding->tables;
}

const A47Outcome *session_a47_last_outcome(const SessionA47Binding *binding)
{
    return binding == NULL ? NULL : &binding->last;
}

unsigned long session_a47_visits(const SessionA47Binding *binding)
{
    return binding == NULL ? 0ul : binding->visits;
}

unsigned long session_a47_adds(const SessionA47Binding *binding)
{
    return binding == NULL ? 0ul : binding->adds;
}

const char *session_a47_failure(const SessionA47Binding *binding)
{
    return binding == NULL ? "no binding" : binding->failure;
}
