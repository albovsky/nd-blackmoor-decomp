#include "session_bindings_a44.h"

#include <stdlib.h>
#include <string.h>

typedef struct A44Row {
    uint8_t is_object; /* a raw 0x44 object waiting for its first visit */
    uint8_t is_record; /* converted to a 0xd8 record */
    uint8_t *bytes;
    size_t length;
} A44Row;

struct SessionA44Binding {
    SessionA44Host host;
    D8Host kernel;
    ActionCoreWorld *world;
    D8Object object;
    A44Row *rows;
    size_t count;
    const char *failure;
};

/* ---- kernel callback trampolines: the user's context is host.context, the kernel's is the binding ---- */
#define USER(b) ((b)->host.context)

static int t_alloc_slot(void *c, int16_t *s) { SessionA44Binding *b = c; return b->host.kernel.alloc_slot(USER(b), s); }
static int t_register_slot(void *c, int16_t s, uint32_t surface, const char *label)
{
    SessionA44Binding *b = c;
    return b->host.kernel.register_slot(USER(b), s, surface, label);
}
static int t_load_surface(void *c, const char *name, const char *label, uint32_t *surface)
{
    SessionA44Binding *b = c;
    return b->host.kernel.load_surface(USER(b), name, label, surface);
}
static int t_set_slot_surface(void *c, int16_t s, uint32_t surface)
{
    SessionA44Binding *b = c;
    return b->host.kernel.set_slot_surface(USER(b), s, surface);
}
static int t_release_surface(void *c, uint32_t surface)
{
    SessionA44Binding *b = c;
    return b->host.kernel.release_surface(USER(b), surface);
}
static int t_release_slot(void *c, int16_t s) { SessionA44Binding *b = c; return b->host.kernel.release_slot(USER(b), s); }
static int t_mark_dirty(void *c, int16_t s) { SessionA44Binding *b = c; return b->host.kernel.mark_dirty(USER(b), s); }
static int t_text_surface(void *c, int index, uint32_t *surface, int32_t *height)
{
    SessionA44Binding *b = c;
    return b->host.kernel.text_surface(USER(b), index, surface, height);
}
static uint32_t t_tick(void *c) { SessionA44Binding *b = c; return b->host.kernel.tick(USER(b)); }
static int t_set_start_flag(void *c, int32_t value)
{
    SessionA44Binding *b = c;
    return b->host.set_start_flag == NULL ? -1 : b->host.set_start_flag(USER(b), value);
}
static int t_scene_change(void *c, const D8SceneChange *change)
{
    SessionA44Binding *b = c;
    SceneTransitionRequest request;
    if (b->host.transition == NULL) return -1;
    memset(&request, 0, sizeof(request));
    request.target_scene = change->scene;
    for (int i = 0; i < 3; ++i) {
        request.opaque_words[i] = change->word[i];
        request.opaque_dwords[i] = change->dword[i];
    }
    return b->host.transition(USER(b), &request);
}
static int t_set_event_flag(void *c, int16_t index, int32_t value)
{
    SessionA44Binding *b = c;
    if (b->world == NULL || b->world->event_flags == NULL || index < 0 || (size_t)index >= b->world->event_flag_count) return -1;
    b->world->event_flags[index] = value;
    return 0;
}
static void t_observe(void *c, int effect, int32_t a, int32_t bb)
{
    SessionA44Binding *b = c;
    if (b->host.kernel.observe != NULL) b->host.kernel.observe(USER(b), effect, a, bb);
}

#define COPY_CB(name) b->kernel.name = b->host.kernel.name != NULL ? t_##name : NULL

SessionA44Binding *session_a44_create(const SessionA44Host *host, ActionCoreWorld *world)
{
    SessionA44Binding *b;
    if (host == NULL || world == NULL) return NULL;
    b = (SessionA44Binding *)calloc(1u, sizeof(*b));
    if (b == NULL) return NULL;
    b->host = *host;
    b->world = world;
    b->failure = "none";
    b->kernel.context = b;
    COPY_CB(alloc_slot);
    COPY_CB(register_slot);
    COPY_CB(load_surface);
    COPY_CB(set_slot_surface);
    COPY_CB(release_surface);
    COPY_CB(release_slot);
    COPY_CB(mark_dirty);
    COPY_CB(text_surface);
    COPY_CB(tick);
    b->kernel.set_start_flag = t_set_start_flag;
    b->kernel.scene_change = t_scene_change;
    b->kernel.set_event_flag = t_set_event_flag;
    b->kernel.observe = host->kernel.observe != NULL ? t_observe : NULL;
    d8_object_reset(&b->object);
    return b;
}

static void free_rows(SessionA44Binding *b)
{
    for (size_t i = 0u; i < b->count; ++i) free(b->rows[i].bytes);
    free(b->rows);
    b->rows = NULL;
    b->count = 0u;
}

void session_a44_destroy(SessionA44Binding *b)
{
    if (b == NULL) return;
    if (b->kernel.release_surface != NULL && b->kernel.release_slot != NULL) (void)d8_cleanup(&b->object, &b->kernel);
    free_rows(b);
    free(b);
}

int session_a44_begin_scene(SessionA44Binding *b, const SceneResource *scene)
{
    A44Row *rows;
    size_t count;
    if (b == NULL || scene == NULL) return D8_ERR_ARGUMENT;
    count = scene_resource_action_count(scene);
    rows = count == 0u ? NULL : (A44Row *)calloc(count, sizeof(*rows));
    if (count != 0u && rows == NULL) {
        b->failure = "0x44-row-allocation";
        return D8_ERR_HOST;
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        ActionFamily44Decoded decoded;
        ActionFamily44Constructed built;
        const uint8_t *text = NULL;
        size_t text_bytes = 0u;
        uint8_t *object;
        const char *why = "0x44-scene-row";
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) goto reject;
        if (info.type != SESSION_A44_TYPE) continue;
        why = "0x44-body";
        if (action_family_44_decode(info.typed_body, info.typed_body_length, &decoded) != ACTION_FAMILY_44_OK) goto reject;
        if (decoded.option_1ec != 0u) {
            why = "0x44-text-key";
            if (b->host.resolve_text == NULL || b->host.resolve_text(USER(b), info.typed_body + 493u, &text, &text_bytes) != 0)
                goto reject;
        }
        why = "0x44-object";
        if (action_family_44_construct(info.typed_body, info.typed_body_length, text, text_bytes, 0u, 1u, NULL, 0u, &built) !=
            ACTION_FAMILY_44_OK)
            goto reject;
        object = (uint8_t *)malloc(built.object_bytes);
        if (object == NULL) goto reject;
        if (action_family_44_construct(info.typed_body, info.typed_body_length, text, text_bytes, 0u, 1u, object,
                                       built.object_bytes, &built) != ACTION_FAMILY_44_OK) {
            free(object);
            goto reject;
        }
        rows[i].bytes = object;
        rows[i].length = built.object_bytes;
        rows[i].is_object = 1u;
        continue;
    reject:
        for (size_t j = 0u; j < count; ++j) free(rows[j].bytes);
        free(rows);
        b->failure = why;
        return D8_ERR_BODY;
    }
    /* The previous scene's clear (0x4381f4 -> 0x48bb86). */
    if (b->kernel.release_surface != NULL && b->kernel.release_slot != NULL &&
        d8_cleanup(&b->object, &b->kernel) != D8_OK) {
        for (size_t j = 0u; j < count; ++j) free(rows[j].bytes);
        free(rows);
        b->failure = "0xd8-scene-clear";
        return D8_ERR_HOST;
    }
    free_rows(b);
    b->rows = rows;
    b->count = count;
    b->failure = "none";
    return D8_OK;
}

int session_a44_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA44Binding *b = (SessionA44Binding *)context;
    A44Row *row;
    if (b == NULL) return SCENE_ACTION_HANDLER_ERROR;
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_A44_TYPE || index >= b->count ||
        (b->rows[index].is_object == 0u && b->rows[index].is_record == 0u)) {
        b->failure = "0x44-row-not-owned";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    row = &b->rows[index];
    if (row->is_object != 0u) {
        A44TextResult *text;
        uint8_t record[D8_RECORD_MAX_BYTES];
        size_t record_bytes = 0u;
        uint8_t *bytes;
        int status;
        if (b->host.write_text == NULL) {
            b->failure = "0x44 text writer is not bound";
            return SCENE_ACTION_HANDLER_UNSUPPORTED;
        }
        text = (A44TextResult *)calloc(1u, sizeof(*text));
        if (text == NULL) {
            b->failure = "0x44-text-result-allocation";
            return SCENE_ACTION_HANDLER_ERROR;
        }
        if (b->host.write_text(USER(b), row->bytes, row->length, text) != 0) {
            free(text);
            b->failure = "0x44 text writer failed";
            return SCENE_ACTION_HANDLER_ERROR;
        }
        status = a44_build_record(row->bytes, row->length, text, record, sizeof(record), &record_bytes);
        free(text);
        if (status != A44_OK) {
            b->failure = "0x44 record build rejected (second name, link count or length)";
            return SCENE_ACTION_HANDLER_ERROR;
        }
        bytes = (uint8_t *)malloc(record_bytes);
        if (bytes == NULL) {
            b->failure = "0x44-record-allocation";
            return SCENE_ACTION_HANDLER_ERROR;
        }
        memcpy(bytes, record, record_bytes);
        free(row->bytes);
        row->bytes = bytes;
        row->length = record_bytes;
        row->is_object = 0u;
        row->is_record = 1u;
        b->failure = "none";
        /* 0x42ba3a with the original subtype, then 0x411b16 stores subtype 1, completion 0 and phase 0. */
        out->phase = 0u;
        out->disposition = action->subtype == 2u ? SCENE_ACTION_HANDLER_RESET_DEPENDENCIES : SCENE_ACTION_HANDLER_PENDING;
        return SCENE_ACTION_HANDLER_OK;
    }
    {
        D8Result result;
        const char *why = "none";
        int status = d8_step(&b->object, row->bytes, row->length, (int16_t)index, before->phase,
                             b->world->event_flag_count, &b->kernel, &result, &why);
        b->failure = why != NULL ? why : "none";
        if (status == D8_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
        if (status != D8_OK) return SCENE_ACTION_HANDLER_ERROR;
        out->phase = result.phase_after;
        /* 0x42ba3a runs with the record's subtype, which 0x411b16 set to 1: completion byte 1, phase 0. */
        out->disposition = result.finished != 0u ? SCENE_ACTION_HANDLER_DIRECT_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
        return SCENE_ACTION_HANDLER_OK;
    }
}

static const A44Row *active_row(const SessionA44Binding *b)
{
    if (b == NULL || b->object.row < 0 || (size_t)b->object.row >= b->count || b->rows[b->object.row].is_record == 0u)
        return NULL;
    return &b->rows[b->object.row];
}

int session_a44_hit_test(SessionA44Binding *b, int16_t x, int16_t y, const D8HitInput *input, D8HitOutput *out)
{
    const A44Row *row;
    if (b == NULL || out == NULL) return D8_ERR_ARGUMENT;
    if (b->object.active == 0u) return d8_hit_test(&b->object, NULL, 0u, x, y, input, out);
    row = active_row(b);
    if (row == NULL) return D8_ERR_ARGUMENT;
    return d8_hit_test(&b->object, row->bytes, row->length, x, y, input, out);
}

int session_a44_click(SessionA44Binding *b, int32_t candidate, D8ClickOutput *out)
{
    const A44Row *row = active_row(b);
    if (b == NULL || out == NULL) return D8_ERR_ARGUMENT;
    return d8_click(&b->object, row == NULL ? NULL : row->bytes, row == NULL ? 0u : row->length, candidate, out);
}

int session_a44_press(SessionA44Binding *b, uint32_t row_phase, int32_t candidate)
{
    if (b == NULL) return D8_ERR_ARGUMENT;
    return d8_press(&b->object, row_phase, candidate, &b->kernel);
}

int session_a44_invalidate(SessionA44Binding *b)
{
    if (b == NULL) return D8_ERR_ARGUMENT;
    return d8_mark_dirty(&b->object, &b->kernel);
}

int session_a44_render_plan(SessionA44Binding *b, const D8View *view, D8RenderPlan *plan)
{
    const A44Row *row;
    if (b == NULL || plan == NULL) return D8_ERR_ARGUMENT;
    if (b->object.visible == 0u) return d8_render_plan(&b->object, NULL, 0u, view, plan);
    row = active_row(b);
    if (row == NULL) return D8_ERR_ARGUMENT;
    return d8_render_plan(&b->object, row->bytes, row->length, view, plan);
}

int session_a44_active_row(const SessionA44Binding *b)
{
    return b == NULL ? -1 : b->object.row;
}

const D8Object *session_a44_object(const SessionA44Binding *b)
{
    return b == NULL ? NULL : &b->object;
}

const char *session_a44_failure(const SessionA44Binding *b)
{
    return b == NULL ? "0x44-binding-unbound" : b->failure;
}
