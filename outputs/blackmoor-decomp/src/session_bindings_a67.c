#include "session_bindings_a67.h"

#include <stdlib.h>

struct SessionA67Binding {
    SessionA67Host host;
    const char *failure;
    int32_t start_flag;
    unsigned long visits;
};

SessionA67Binding *session_a67_create(const SessionA67Host *host)
{
    SessionA67Binding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA67Binding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
    }
    return b;
}

void session_a67_destroy(SessionA67Binding *b)
{
    free(b);
}

int session_a67_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA67Binding *b = (SessionA67Binding *)context;

    (void)index;
    if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A67_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (action->typed_body_length != ACTION_FAMILY_67_BODY_BYTES) {
        b->failure = "invalid raw-0x67 body";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (b->host.set_start_flag == NULL) {
        b->failure = "start flag sink (0x4286b5 stores 1 in DAT_005bb1ca)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    b->failure = "none";
    b->start_flag = SESSION_A67_START_FLAG_VALUE;                 /* 0x4286b5 */
    b->host.set_start_flag(b->host.context, b->start_flag);
    ++b->visits;
    out->phase = before->phase;                                    /* the phase word is not written */
    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;     /* 0x4286cc: completion byte := 1 */
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a67_failure(const SessionA67Binding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

int32_t session_a67_start_flag(const SessionA67Binding *b)
{
    return b == NULL ? 0 : b->start_flag;
}

unsigned long session_a67_visits(const SessionA67Binding *b)
{
    return b == NULL ? 0ul : b->visits;
}
