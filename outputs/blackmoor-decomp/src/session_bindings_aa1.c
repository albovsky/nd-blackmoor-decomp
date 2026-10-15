#include "session_bindings_aa1.h"

#include <stdlib.h>
#include <string.h>

typedef struct RowAa1 {
    uint8_t *payload;
    size_t length;
    uint8_t key_missing;
    const char *deferred;
} RowAa1;

struct SessionAa1Binding {
    SessionAa1Host host;
    RowAa1 *rows;
    size_t count;
    const char *failure;
};

static uint16_t u16(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
}

SessionAa1Binding *session_aa1_create(const SessionAa1Host *host)
{
    SessionAa1Binding *b;
    if (host == NULL) return NULL;
    b = (SessionAa1Binding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
    }
    return b;
}

static void clear_rows(SessionAa1Binding *b)
{
    size_t i;
    for (i = 0; i < b->count; ++i) free(b->rows[i].payload);
    free(b->rows);
    b->rows = NULL;
    b->count = 0;
}

void session_aa1_destroy(SessionAa1Binding *b)
{
    if (b != NULL) {
        clear_rows(b);
        free(b);
    }
}

int session_aa1_begin_scene(SessionAa1Binding *b, const SceneResource *scene)
{
    size_t i;
    ActionA1Object *scratch;
    if (b == NULL || scene == NULL) return ACTION_SOUND_ERR_ARGUMENT;
    clear_rows(b);
    b->count = scene_resource_action_count(scene);
    b->rows = (RowAa1 *)calloc(b->count != 0u ? b->count : 1u, sizeof(*b->rows));
    if (b->rows == NULL) {
        b->count = 0;
        b->failure = "row table allocation failed";
        return ACTION_SOUND_ERR_BACKEND;
    }
    scratch = (ActionA1Object *)malloc(sizeof(*scratch));
    if (scratch == NULL) {
        clear_rows(b);
        b->failure = "row allocation failed";
        return ACTION_SOUND_ERR_BACKEND;
    }
    for (i = 0; i < b->count; ++i) {
        SceneActionInfo a;
        RowAa1 *row = &b->rows[i];
        int status;
        if (scene_resource_action_at(scene, i, &a) != SCENE_RESOURCE_OK) goto bad_scene;
        if (a.type != SESSION_AA1_TYPE) continue;
        status = action_a1_runtime_construct(a.typed_body, a.typed_body_length,
                                             b->host.lookup, b->host.lookup_context, scratch);
        if (status == ACTION_A1_RT_ERR_LOOKUP) {
            row->deferred = "loader AUTOTEXT provider unavailable";
            continue;
        }
        if (status != ACTION_A1_RT_OK) goto bad_scene;
        row->payload = (uint8_t *)malloc(scratch->length);
        if (row->payload == NULL) {
            free(scratch);
            clear_rows(b);
            b->failure = "row allocation failed";
            return ACTION_SOUND_ERR_BACKEND;
        }
        memcpy(row->payload, scratch->bytes, scratch->length);
        row->length = scratch->length;
        row->key_missing = scratch->key_missing;
    }
    free(scratch);
    b->failure = "none";
    return ACTION_SOUND_OK;
bad_scene:
    free(scratch);
    clear_rows(b);
    b->failure = "invalid raw-0xa1 scene construction";
    return ACTION_SOUND_ERR_BODY;
}

int session_aa1_row(const SessionAa1Binding *b, size_t index, SessionAa1Row *out)
{
    const RowAa1 *row;
    size_t stem;
    if (b == NULL || out == NULL) return 0;
    memset(out, 0, sizeof(*out));
    if (index >= b->count || b->rows[index].payload == NULL) return 0;
    row = &b->rows[index];
    for (stem = 0; stem < 33u && row->payload[stem] != 0u; ++stem) {
        out->stem[stem] = (char)row->payload[stem];
    }
    out->present = 1u;
    out->channel = u16(row->payload + 0x21);
    out->event_id = (int16_t)u16(row->payload + 0xa5);
    out->event_value = row->payload[0xa7];
    out->transition_scene = (int16_t)u16(row->payload + 0x91);
    out->mode = row->payload[0x90];
    out->key_missing = row->key_missing;
    return 1;
}

int session_aa1_handler(void *context, size_t index, const SceneActionInfo *a,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionAa1Binding *b = (SessionAa1Binding *)context;
    RowAa1 *row;
    A97Input in;
    A97EventTable events;
    A97EventTable *events_view = NULL;
    ActionSoundObjectResult result;
    int status;
    if (b == NULL || a == NULL || before == NULL || out == NULL ||
        a->type != SESSION_AA1_TYPE || index >= b->count) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    row = &b->rows[index];
    b->failure = "none";
    if (row->deferred != NULL) {
        b->failure = row->deferred;
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (row->payload == NULL) return SCENE_ACTION_HANDLER_ERROR;
    memset(&in, 0, sizeof(in));
    in.phase = before->phase;
    in.subtype = a->subtype;
    in.completed = before->completed;
    /* Only phase 0 reads the caption config and the event word. Do not fabricate them. */
    if (in.phase == 0u) {
        if (b->host.captions_enabled == NULL ||
            b->host.captions_enabled(b->host.sound.context, &in.captions) != 0) {
            b->failure = "caption configuration unavailable";
            return SCENE_ACTION_HANDLER_UNSUPPORTED;
        }
        if ((int16_t)u16(row->payload + 0xa5) != -1) {
            memset(&events, 0, sizeof(events));
            if (b->host.load_events == NULL ||
                b->host.load_events(b->host.sound.context, &events) != 0) {
                b->failure = "event table provider unavailable";
                return SCENE_ACTION_HANDLER_UNSUPPORTED;
            }
            events_view = &events;
        }
    }
    if (in.phase == 2u && (row->payload[0x91] != 0x0f || row->payload[0x92] != 0x27) &&
        b->host.transition == NULL) {
        b->failure = "sound scene transition provider";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    status = action_sound_object_step(row->payload, row->length, &in, &b->host.sound,
                                      events_view, &result, &b->failure);
    if (status == ACTION_SOUND_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != ACTION_SOUND_OK) return SCENE_ACTION_HANDLER_ERROR;
    if (result.event_stored != 0u && b->host.event_stored != NULL) {
        b->host.event_stored(b->host.sound.context, index, result.event_id,
                             result.event_value, result.event_previous);
    }
    if (result.visit.transition &&
        b->host.transition(b->host.sound.context, &result.visit.request) != 0) {
        b->failure = "sound scene transition rejected";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    out->phase = result.visit.phase;
    out->disposition = result.visit.direct ? SCENE_ACTION_HANDLER_DIRECT_COMPLETED :
                       result.visit.finish ? SCENE_ACTION_HANDLER_COMPLETED :
                                             SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_aa1_failure(const SessionAa1Binding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}
