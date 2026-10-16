#include "session_bindings_a4f.h"

#include <stdlib.h>

struct SessionA4FBinding {
    ActionCoreWorld *world;
    const char *failure;
    unsigned long visits;
    unsigned long flags_set;
};

SessionA4FBinding *session_a4f_create(ActionCoreWorld *world)
{
    SessionA4FBinding *b;
    if (world == NULL) {
        return NULL;
    }
    b = (SessionA4FBinding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->world = world;
        b->failure = "none";
    }
    return b;
}

void session_a4f_destroy(SessionA4FBinding *b)
{
    free(b);
}

int session_a4f_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA4FBinding *b = (SessionA4FBinding *)context;
    ActionFamily4FDecoded decoded;
    ActionFamily4FResult result;
    int status;

    (void)index;
    if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A4F_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->failure = "none";
    status = action_family_4f_decode(action->typed_body, action->typed_body_length, &decoded);
    if (status != ACTION_FAMILY_4F_OK) {
        b->failure = "invalid raw-0x4f body";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    status = action_family_4f_visit(&decoded, b->world, &result);
    if (status == ACTION_FAMILY_4F_ERR_BOUNDS) {
        b->failure = "event flag index outside the event flag table";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (status == ACTION_FAMILY_4F_ERR_UNSUPPORTED) {
        b->failure = "original reads outside the 10-byte body or the value tables";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (status != ACTION_FAMILY_4F_OK) {
        b->failure = "raw-0x4f visit failed";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->visits += result.evaluated;
    b->flags_set += result.flag_set;
    out->phase = 0u; /* 0x42ba3a: [0x5bb632 + row*0x8d] = 0 */
    out->disposition = SCENE_ACTION_HANDLER_COMPLETED;
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a4f_failure(const SessionA4FBinding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

unsigned long session_a4f_visits(const SessionA4FBinding *b)
{
    return b == NULL ? 0ul : b->visits;
}

unsigned long session_a4f_flags_set(const SessionA4FBinding *b)
{
    return b == NULL ? 0ul : b->flags_set;
}
