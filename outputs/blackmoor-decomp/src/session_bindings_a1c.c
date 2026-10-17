#include "session_bindings_a1c.h"

#include <stdlib.h>
#include <string.h>

struct SessionA1cBinding {
    C1cHost host;
    C1cObject object;
    uint8_t body[ACTION_FAMILY_1C_BODY_BYTES];
    const char *failure;
    unsigned long visits;
};

SessionA1cBinding *session_a1c_create(const C1cHost *host)
{
    SessionA1cBinding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA1cBinding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        c1c_object_reset(&b->object);
        b->failure = "none";
    }
    return b;
}

void session_a1c_destroy(SessionA1cBinding *b)
{
    if (b != NULL) {
        c1c_free_iv(&b->object);
    }
    free(b);
}

static int host_complete(const C1cHost *h)
{
    return h->player_state != NULL && h->player_name != NULL && h->player_hotspot != NULL && h->player_origin != NULL &&
           h->open_iv != NULL && h->read != NULL && h->close != NULL && h->alloc_slot != NULL && h->register_slot != NULL &&
           h->release_slot != NULL && h->cell_583a29 != NULL;
}

int session_a1c_handler(void *context, size_t index, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out)
{
    SessionA1cBinding *b = (SessionA1cBinding *)context;
    ActionFamily1cDecoded decoded;
    C1cOutcome outcome;
    int status;

    (void)index;
    if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A1C_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (action_family_1c_decode(action->raw_body, action->raw_body_length, &decoded) != ACTION_FAMILY_1C_OK) {
        b->failure = "invalid raw-0x1c body";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (!host_complete(&b->host)) {
        b->failure = "movie player, .IV file or z entry provider";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    memcpy(b->body, action->raw_body, sizeof(b->body));
    status = c1c_visit(&b->object, b->body, before->phase, &b->host, &outcome);
    if (status != C1C_OK) {
        b->failure = status == C1C_ERR_FILE ? "the .IV file is missing or malformed (the original shuts the game down)"
                                            : "raw-0x1c host callback failed";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->failure = "none";
    ++b->visits;
    out->phase = outcome.phase;
    out->disposition = outcome.disposition;
    return SCENE_ACTION_HANDLER_OK;
}

int session_a1c_render(SessionA1cBinding *b, int32_t view_x, int32_t view_y, C1cFill *fills, size_t capacity, size_t *count)
{
    return b == NULL ? C1C_ERR_ARGUMENT : c1c_render(&b->object, view_x, view_y, fills, capacity, count);
}

const C1cObject *session_a1c_object(const SessionA1cBinding *b)
{
    return b == NULL ? NULL : &b->object;
}

const char *session_a1c_failure(const SessionA1cBinding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

unsigned long session_a1c_visits(const SessionA1cBinding *b)
{
    return b == NULL ? 0ul : b->visits;
}
