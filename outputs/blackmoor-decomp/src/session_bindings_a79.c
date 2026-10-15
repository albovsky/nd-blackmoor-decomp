#include "session_bindings_a79.h"

#include <stdlib.h>
#include <string.h>

#include "action_family_79.h"

struct SessionA79Binding {
    SessionA79Host host;
    int32_t *words; /* -1: not a raw-0x79 row; else the 16-bit item word */
    size_t count;
    const char *failure;
};

SessionA79Binding *session_a79_create(const SessionA79Host *host)
{
    SessionA79Binding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA79Binding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
    }
    return b;
}

static void clear_rows(SessionA79Binding *b)
{
    free(b->words);
    b->words = NULL;
    b->count = 0u;
}

void session_a79_destroy(SessionA79Binding *b)
{
    if (b != NULL) {
        clear_rows(b);
        free(b);
    }
}

int session_a79_begin_scene(SessionA79Binding *b, const SceneResource *scene)
{
    size_t i, count;
    int32_t *words;
    if (b == NULL || scene == NULL) {
        return ACTION79_ERR_ARGUMENT;
    }
    count = scene_resource_action_count(scene);
    words = (int32_t *)malloc((count != 0u ? count : 1u) * sizeof(*words));
    if (words == NULL) {
        b->failure = "row allocation failed";
        return ACTION79_ERR_ARGUMENT;
    }
    for (i = 0; i < count; ++i) {
        SceneActionInfo info;
        ActionFamily79Decoded decoded;
        words[i] = -1;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(words);
            b->failure = "raw-0x79 scene row unreadable";
            return ACTION79_ERR_BOUNDS;
        }
        if (info.type != SESSION_A79_TYPE) {
            continue;
        }
        /* 0x4e9add builds the two-byte object at scene load. */
        if (action_family_79_decode(info.raw_body, info.raw_body_length, &decoded) !=
            ACTION_FAMILY_79_OK) {
            free(words);
            b->failure = "invalid raw-0x79 scene row";
            return ACTION79_ERR_BOUNDS;
        }
        words[i] = (int32_t)decoded.word_0;
    }
    clear_rows(b);
    b->words = words;
    b->count = count;
    b->failure = "none";
    return ACTION79_OK;
}

int session_a79_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out)
{
    SessionA79Binding *b = (SessionA79Binding *)context;
    Action79Result result;
    int status;
    if (b == NULL || action == NULL || before == NULL || out == NULL ||
        action->type != SESSION_A79_TYPE || index >= b->count || b->words[index] < 0) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->failure = "none";
    status = action79_visit((uint16_t)b->words[index], &b->host.model, &b->host.view,
                            &result, &b->failure);
    if (status == ACTION79_ERR_UNSUPPORTED) {
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (status != ACTION79_OK) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    /* 0x4eac9b stores the completion byte itself: no 0x42ba3a, no reset, and
     * the phase word is never touched. */
    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;
    out->phase = before->phase;
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a79_failure(const SessionA79Binding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

int32_t session_a79_item_word(const SessionA79Binding *b, size_t row)
{
    return b == NULL || row >= b->count ? -1 : b->words[row];
}
