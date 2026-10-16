#include "session_bindings_a6e.h"

#include <stdlib.h>

struct SessionA6EBinding {
    SessionA6EHost host;
    SceneStackSlot *slot;
    const char *failure;
    unsigned long pushes;
};

SessionA6EBinding *session_a6e_create(const SessionA6EHost *host, SceneStackSlot *slot)
{
    SessionA6EBinding *b;
    if (host == NULL || slot == NULL) {
        return NULL;
    }
    b = (SessionA6EBinding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->slot = slot;
        b->failure = "none";
    }
    return b;
}

void session_a6e_destroy(SessionA6EBinding *b)
{
    free(b);
}

int session_a6e_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA6EBinding *b = (SessionA6EBinding *)context;
    SceneStackCurrent current;

    (void)index;
    if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A6E_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (action->typed_body_length != ACTION_FAMILY_6E_BODY_BYTES) {
        b->failure = "invalid raw-0x6e body";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (b->host.load_current == NULL) {
        b->failure = "running-scene words provider (0x42e560 reads 0x5bb57b, 0x5bb57f, 0x5bb50b, 0x5bb593, 0x5bb5a7..0x5bb5af)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (b->host.load_current(b->host.context, &current) != 0) {
        b->failure = "running-scene words provider refused";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    b->failure = "none";
    scene_stack_push(b->slot, &current, SESSION_A6E_PUSH_ARGUMENT); /* 0x429193..0x42919a */
    ++b->pushes;
    out->phase = before->phase;                                      /* the phase word is not written */
    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;       /* 0x4291aa: completion byte := 1 */
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a6e_failure(const SessionA6EBinding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

unsigned long session_a6e_pushes(const SessionA6EBinding *b)
{
    return b == NULL ? 0ul : b->pushes;
}
