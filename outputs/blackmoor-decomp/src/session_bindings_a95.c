#include "session_bindings_a95.h"

#include <stdlib.h>

struct SessionA95Binding {
    ActionFamily95Host host;
    const char *failure;
    unsigned long visits;
};

SessionA95Binding *session_a95_create(const ActionFamily95Host *host)
{
    SessionA95Binding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA95Binding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
    }
    return b;
}

void session_a95_destroy(SessionA95Binding *b)
{
    free(b);
}

int session_a95_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out)
{
    SessionA95Binding *b = (SessionA95Binding *)context;
    ActionFamily95Decoded decoded;
    int status;

    (void)index;
    if (b == NULL || action == NULL || before == NULL || out == NULL ||
        action->type != SESSION_A95_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->failure = "none";
    status = action_family_95_decode(action->typed_body, action->typed_body_length, &decoded);
    if (status != ACTION_FAMILY_95_OK) {
        b->failure = "invalid raw-0x95 body";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    status = action_family_95_visit(&decoded, &b->host);
    if (status == ACTION_FAMILY_95_ERR_UNSUPPORTED) {
        b->failure = "no volume provider";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (status == ACTION_FAMILY_95_ERR_BOUNDS) {
        b->failure = "channel outside the 32 recovered sound slots";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (status != ACTION_FAMILY_95_OK) {
        b->failure = "volume provider failed";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    ++b->visits;
    out->phase = 0u; /* 0x42ba3a: [0x5bb632 + row*0x8d] = 0 */
    /* The executor's COMPLETED path is 0x42ba3a for every subtype: 1 completes, 2 clears the
     * completion and resets the dependencies, any other subtype leaves the completion byte. */
    out->disposition = SCENE_ACTION_HANDLER_COMPLETED;
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a95_failure(const SessionA95Binding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

unsigned long session_a95_visits(const SessionA95Binding *b)
{
    return b == NULL ? 0ul : b->visits;
}
