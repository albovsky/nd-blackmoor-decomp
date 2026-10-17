#include "session_bindings_a4e.h"

#include <stdlib.h>
#include <string.h>

struct SessionA4EBinding {
    ActionCoreWorld *world;
    ActionFamily4ERuntimeOutcome last;
    const char *failure;
    unsigned long visits;
    unsigned long reports;
};

SessionA4EBinding *session_a4e_create(ActionCoreWorld *world)
{
    SessionA4EBinding *b;
    if (world == NULL) {
        return NULL;
    }
    b = (SessionA4EBinding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->world = world;
        b->failure = "none";
    }
    return b;
}

void session_a4e_destroy(SessionA4EBinding *b)
{
    free(b);
}

int session_a4e_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA4EBinding *b = (SessionA4EBinding *)context;
    ActionFamily4EDecoded decoded;

    (void)index;
    if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A4E_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->failure = "none";
    if (action_family_4e_decode(action->raw_body, action->raw_body_length, &decoded) != ACTION_FAMILY_4E_OK) {
        b->failure = "invalid raw-0x4e body";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (action_family_4e_runtime_visit(&decoded, b->world, &b->last) != ACTION_FAMILY_4E_OK) {
        b->failure = "raw-0x4e visit failed";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->visits += b->last.target_valid;
    b->reports += b->last.reports;
    out->phase = 0u; /* 0x42ba3a: [0x5bb632 + row*0x8d] = 0 */
    out->disposition = SCENE_ACTION_HANDLER_COMPLETED;
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a4e_failure(const SessionA4EBinding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

const ActionFamily4ERuntimeOutcome *session_a4e_last_outcome(const SessionA4EBinding *b)
{
    return b == NULL ? NULL : &b->last;
}

unsigned long session_a4e_visits(const SessionA4EBinding *b)
{
    return b == NULL ? 0ul : b->visits;
}

unsigned long session_a4e_reports(const SessionA4EBinding *b)
{
    return b == NULL ? 0ul : b->reports;
}
