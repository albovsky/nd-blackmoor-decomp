#include "session_bindings_a6f.h"

#include <stdlib.h>
#include <string.h>

struct SessionA6FBinding {
    SessionA6FHost host;
    SceneStackSlot *slot;
    const char *failure;
    unsigned long pops;
};

SessionA6FBinding *session_a6f_create(const SessionA6FHost *host, SceneStackSlot *slot)
{
    SessionA6FBinding *b;
    if (host == NULL || slot == NULL) {
        return NULL;
    }
    b = (SessionA6FBinding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->slot = slot;
        b->failure = "none";
    }
    return b;
}

void session_a6f_destroy(SessionA6FBinding *b)
{
    free(b);
}

int session_a6f_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA6FBinding *b = (SessionA6FBinding *)context;
    SceneStackSlot popped;
    SceneStackPop pop;
    SceneTransitionRequest request;

    (void)index;
    if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A6F_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (action->typed_body_length != ACTION_FAMILY_6F_BODY_BYTES) {
        b->failure = "invalid raw-0x6f body";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (b->host.apply == NULL) {
        b->failure = "scene-change provider (0x42e493 starts a scene change: mode 4, start flag 0x5bb1ca)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    popped = *b->slot; /* the record changes only once the host accepted the scene change */
    if (scene_stack_pop(&popped, &pop) != SCENE_STACK_POP_OK) {
        b->failure = "scene stack is empty (0x42e493 aborts)";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    memset(&request, 0, sizeof(request));
    request.target_scene = (int16_t)pop.scene_5bb57b;
    request.opaque_words[0] = pop.word_5bb599;
    request.opaque_words[1] = pop.word_5bb595;
    request.opaque_words[2] = pop.word_5c39ff;
    request.opaque_dwords[0] = pop.dword_5bb59b;
    request.opaque_dwords[1] = pop.dword_5bb59f;
    request.opaque_dwords[2] = pop.dword_5bb5a3;
    if (b->host.apply(b->host.context, &pop, &request) != 0) {
        b->failure = "scene-change request was refused";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    *b->slot = popped;
    b->failure = "none";
    ++b->pops;
    out->phase = before->phase; /* the phase word is not written */
    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED; /* 0x4291ec: completion byte := 1 */
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a6f_failure(const SessionA6FBinding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

unsigned long session_a6f_pops(const SessionA6FBinding *b)
{
    return b == NULL ? 0ul : b->pops;
}
