#include "session_bindings_a78.h"

#include <stdlib.h>
#include <string.h>

#define DEPENDENCY_BYTES 16u

typedef struct {
    int owned;
    Action78Object object;
} Row;

struct SessionA78Binding {
    SessionA78Host host;
    Row *rows;
    size_t count;
    Action78Result last;
    const char *failure;
};

SessionA78Binding *session_a78_create(const SessionA78Host *host)
{
    SessionA78Binding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA78Binding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
    }
    return b;
}

static void clear_rows(SessionA78Binding *b)
{
    free(b->rows);
    b->rows = NULL;
    b->count = 0u;
}

void session_a78_destroy(SessionA78Binding *b)
{
    if (b != NULL) {
        clear_rows(b);
        free(b);
    }
}

int session_a78_begin_scene(SessionA78Binding *b, const SceneResource *scene)
{
    size_t i, count;
    Row *rows;
    if (b == NULL || scene == NULL) {
        return ACTION78_ERR_ARGUMENT;
    }
    count = scene_resource_action_count(scene);
    rows = (Row *)calloc(count != 0u ? count : 1u, sizeof(*rows));
    if (rows == NULL) {
        b->failure = "row allocation failed";
        return ACTION78_ERR_ARGUMENT;
    }
    for (i = 0; i < count; ++i) {
        SceneActionInfo info;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(rows);
            b->failure = "raw-0x78 scene row unreadable";
            return ACTION78_ERR_BOUNDS;
        }
        if (info.type != SESSION_A78_TYPE) {
            continue;
        }
        /* 0x4e9c2f copies six bytes; whole 16-byte dependency records follow. */
        if (info.raw_body == NULL || info.raw_body_length < ACTION78_BODY_BYTES ||
            (info.raw_body_length - ACTION78_BODY_BYTES) % DEPENDENCY_BYTES != 0u ||
            action78_object_from_body(info.raw_body, info.raw_body_length, &rows[i].object) !=
                ACTION78_OK) {
            free(rows);
            b->failure = "invalid raw-0x78 scene row";
            return ACTION78_ERR_BOUNDS;
        }
        rows[i].owned = 1;
    }
    clear_rows(b);
    b->rows = rows;
    b->count = count;
    b->failure = "none";
    return ACTION78_OK;
}

int session_a78_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA78Binding *b = (SessionA78Binding *)context;
    Action78Result result;
    int status;
    if (b == NULL || action == NULL || before == NULL || out == NULL ||
        action->type != SESSION_A78_TYPE || index >= b->count || !b->rows[index].owned) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->failure = "none";
    status = action78_visit(&b->rows[index].object, &b->host.model, &b->host.view, &result,
                            &b->failure);
    if (status == ACTION78_ERR_UNSUPPORTED) {
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (status != ACTION78_OK) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->last = result;
    /* 0x4eac3f stores the completion byte itself: no 0x42ba3a, no reset, and
     * the phase word is never touched. */
    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;
    out->phase = before->phase;
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a78_failure(const SessionA78Binding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

int session_a78_object(const SessionA78Binding *b, size_t row, Action78Object *out)
{
    if (b == NULL || out == NULL || row >= b->count || !b->rows[row].owned) {
        return 0;
    }
    *out = b->rows[row].object;
    return 1;
}

Action78Result session_a78_last_result(const SessionA78Binding *b)
{
    Action78Result zero;
    memset(&zero, 0, sizeof(zero));
    return b == NULL ? zero : b->last;
}
