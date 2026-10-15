#include "session_bindings_a97.h"

#include <stdlib.h>
#include <string.h>

typedef struct Row97 {
    uint8_t *payload;
    size_t length;
    int selected;
    const char *deferred;
} Row97;
struct SessionA97Binding {
    SessionA97Host host;
    Row97 *rows;
    size_t count;
    const char *failure;
};

SessionA97Binding *session_a97_create(const SessionA97Host *host)
{
    SessionA97Binding *b;
    if (host == NULL) return NULL;
    b = (SessionA97Binding *)calloc(1u, sizeof(*b));
    if (b != NULL) { b->host = *host; b->failure = "none"; }
    return b;
}
static void clear(SessionA97Binding *b)
{
    size_t i;
    for (i = 0; i < b->count; ++i) free(b->rows[i].payload);
    free(b->rows); b->rows = NULL; b->count = 0;
}
void session_a97_destroy(SessionA97Binding *b)
{ if (b != NULL) { clear(b); free(b); } }

int session_a97_begin_scene(SessionA97Binding *b, const SceneResource *scene)
{
    size_t i;
    uint8_t *scratch;
    if (b == NULL || scene == NULL) return ACTION_SOUND_ERR_ARGUMENT;
    clear(b);
    b->count = scene_resource_action_count(scene);
    b->rows = (Row97 *)calloc(b->count != 0u ? b->count : 1u, sizeof(*b->rows));
    if (b->rows == NULL) { b->count = 0; return ACTION_SOUND_ERR_BACKEND; }
    scratch = (uint8_t *)malloc(ACTION_FAMILY_97_MAX_ALLOCATION);
    if (scratch == NULL) { clear(b); return ACTION_SOUND_ERR_BACKEND; }
    for (i = 0; i < b->count; ++i) {
        SceneActionInfo a;
        ActionFamily97Decoded d;
        ActionFamily97Constructed c;
        int status, marked = 0;
        size_t j;
        Row97 *row = &b->rows[i];
        row->selected = -1;
        if (scene_resource_action_at(scene, i, &a) != SCENE_RESOURCE_OK) goto bad_scene;
        if (a.type != SESSION_A97_TYPE) continue;
        if (action_family_97_decode(a.typed_body, a.typed_body_length, &d) != ACTION_FAMILY_97_OK)
            goto bad_scene;
        for (j = 0; j < (size_t)d.count; ++j) if (d.names[j][0] == '*') marked = 1;
        if (!marked && b->host.random_state == NULL) {
            row->deferred = "loader CRT random state unavailable"; continue;
        }
        status = action_family_97_construct(a.typed_body, a.typed_body_length,
            b->host.random_state != NULL ? *b->host.random_state : 0u, 50u,
            b->host.lookup, b->host.lookup_context, scratch,
            ACTION_FAMILY_97_MAX_ALLOCATION, &c);
        /* rand precedes AUTOTEXT in the original. Consume it even when the
         * selected lookup cannot be provided; no alternate text is invented. */
        if (!marked) *b->host.random_state = *b->host.random_state * UINT32_C(214013) + UINT32_C(2531011);
        if (status == ACTION_FAMILY_97_ERR_LOOKUP) {
            row->deferred = "loader AUTOTEXT provider unavailable"; continue;
        }
        if (status != ACTION_FAMILY_97_OK) goto bad_scene;
        row->payload = (uint8_t *)malloc(c.allocation_bytes);
        if (row->payload == NULL) {
            free(scratch); clear(b); b->failure = "row allocation failed";
            return ACTION_SOUND_ERR_BACKEND;
        }
        memcpy(row->payload, scratch, c.allocation_bytes);
        row->length = c.allocation_bytes;
        row->selected = c.selected_index;
    }
    free(scratch); b->failure = "none"; return ACTION_SOUND_OK;
bad_scene:
    free(scratch); clear(b); b->failure = "invalid raw-97 scene construction";
    return ACTION_SOUND_ERR_BODY;
}

int session_a97_handler(void *context, size_t index, const SceneActionInfo *a,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA97Binding *b = (SessionA97Binding *)context;
    Row97 *row;
    A97Input in;
    A97Result result;
    int status;
    if (b == NULL || a == NULL || before == NULL || out == NULL ||
        a->type != SESSION_A97_TYPE || index >= b->count) return SCENE_ACTION_HANDLER_ERROR;
    row = &b->rows[index]; b->failure = "none";
    if (row->deferred != NULL) { b->failure = row->deferred; return SCENE_ACTION_HANDLER_UNSUPPORTED; }
    if (row->payload == NULL) return SCENE_ACTION_HANDLER_ERROR;
    memset(&in, 0, sizeof(in));
    in.phase = before->phase; in.subtype = a->subtype; in.completed = before->completed;
    /* Only phase 0 reads the caption config. Do not fabricate it when absent. */
    if (in.phase == 0u && (b->host.captions_enabled == NULL ||
        b->host.captions_enabled(b->host.sound.context, &in.captions) != 0)) {
        b->failure = "caption configuration unavailable"; return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (in.phase == 2u && (row->payload[0x91] != 0x0f || row->payload[0x92] != 0x27) &&
        b->host.transition == NULL) {
        b->failure = "sound scene transition provider"; return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    status = action97_runtime_step(row->payload, row->length, &in, &b->host.sound,
                                   &result, &b->failure);
    if (status == ACTION_SOUND_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != ACTION_SOUND_OK) return SCENE_ACTION_HANDLER_ERROR;
    if (result.transition && b->host.transition(b->host.sound.context, &result.request) != 0) {
        b->failure = "sound scene transition rejected"; return SCENE_ACTION_HANDLER_ERROR;
    }
    out->phase = result.phase;
    out->disposition = result.direct ? SCENE_ACTION_HANDLER_DIRECT_COMPLETED :
                       result.finish ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}
const char *session_a97_failure(const SessionA97Binding *b)
{ return b == NULL ? "invalid binding" : b->failure; }
int session_a97_selected(const SessionA97Binding *b, size_t row)
{ return b == NULL || row >= b->count ? -1 : b->rows[row].selected; }
