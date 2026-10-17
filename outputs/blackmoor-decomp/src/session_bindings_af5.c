#include "session_bindings_af5.h"

#include <stdlib.h>
#include <string.h>

typedef struct Af5Row {
    uint8_t present;
    uint8_t body[TQZ_BODY_BYTES];
} Af5Row;

struct SessionAf5Binding {
    SessionAf5Host host;
    TqzObject object;
    TqzWorld world;
    Af5Row *rows;
    size_t count;
    const char *failure;
};

SessionAf5Binding *session_af5_create(const SessionAf5Host *host)
{
    SessionAf5Binding *binding;
    if (host == NULL) return NULL;
    binding = (SessionAf5Binding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        binding->host = *host;
        tqz_object_reset(&binding->object);
        binding->failure = "none";
    }
    return binding;
}

void session_af5_destroy(SessionAf5Binding *binding)
{
    if (binding == NULL) return;
    (void)tqz_cleanup(&binding->object, &binding->world, &binding->host.kernel);
    free(binding->rows);
    free(binding);
}

int session_af5_begin_scene(SessionAf5Binding *binding, const SceneResource *scene)
{
    Af5Row *rows;
    size_t count;
    if (binding == NULL || scene == NULL) return TQZ_ERR_ARGUMENT;
    count = scene_resource_action_count(scene);
    rows = count == 0u ? NULL : (Af5Row *)calloc(count, sizeof(*rows));
    if (count != 0u && rows == NULL) {
        binding->failure = "0xf5-row-allocation";
        return TQZ_ERR_BOUNDS;
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        const char *why = NULL;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(rows);
            binding->failure = "0xf5-scene-row";
            return TQZ_ERR_BODY;
        }
        if (info.type != SESSION_AF5_TYPE) continue;
        if (tqz_validate_body(info.typed_body, info.typed_body_length, &why) != TQZ_OK) {
            free(rows);
            binding->failure = why;
            return TQZ_ERR_BODY;
        }
        memcpy(rows[i].body, info.typed_body, TQZ_BODY_BYTES);
        rows[i].present = 1u;
    }
    /* The previous scene's clear (0x438c75 / 0x43df60 -> 0x4b7ff4 + 0x4b7f3b). The world cells are not touched. */
    if (tqz_cleanup(&binding->object, &binding->world, &binding->host.kernel) != TQZ_OK) {
        free(rows);
        binding->failure = "0xf5-scene-clear";
        return TQZ_ERR_HOST;
    }
    free(binding->rows);
    binding->rows = rows;
    binding->count = count;
    binding->failure = "none";
    return TQZ_OK;
}

int session_af5_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionAf5Binding *binding = (SessionAf5Binding *)context;
    TqzResult result;
    const char *why = NULL;
    int status;
    if (binding == NULL) return SCENE_ACTION_HANDLER_ERROR;
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_AF5_TYPE ||
        index >= binding->count || binding->rows[index].present == 0u) {
        binding->failure = "0xf5-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    status = tqz_step(&binding->object, binding->rows[index].body, TQZ_BODY_BYTES, (int16_t)index, before->phase,
                      &binding->world, &binding->host.kernel, &result, &why);
    binding->failure = why != NULL ? why : "none";
    if (status == TQZ_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != TQZ_OK) return SCENE_ACTION_HANDLER_ERROR;
    if ((result.initialized != 0u || result.completed != 0u) && binding->host.store_world != NULL)
        binding->host.store_world(binding->host.kernel.context, &binding->world);
    out->phase = result.phase_after;
    out->disposition = result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

/* The body of the object's row, NULL when the object has no row of this binding. */
static const uint8_t *active_body(const SessionAf5Binding *binding)
{
    const int16_t row = binding->object.row;
    if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL;
    return binding->rows[row].body;
}

int session_af5_pointer_move(SessionAf5Binding *binding, int32_t x, int32_t y, TqzPointerResult *out)
{
    const uint8_t *body;
    if (binding == NULL || out == NULL) return TQZ_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    if (binding->object.active == 0) return TQZ_OK; /* 0x4b81ff does not run: no row owns the object */
    body = active_body(binding);
    if (body == NULL) return TQZ_ERR_ARGUMENT;
    return tqz_pointer(&binding->object, body, TQZ_BODY_BYTES, x, y, out);
}

int session_af5_click(SessionAf5Binding *binding, uint32_t row_phase, int32_t candidate, uint32_t *new_phase)
{
    if (binding == NULL || new_phase == NULL) return TQZ_ERR_ARGUMENT;
    *new_phase = row_phase;
    return tqz_click(&binding->object, row_phase, candidate, new_phase);
}

int session_af5_key(SessionAf5Binding *binding, uint32_t row_phase, int8_t ch)
{
    if (binding == NULL) return TQZ_ERR_ARGUMENT;
    return tqz_key(&binding->object, row_phase, ch);
}

int session_af5_invalidate(SessionAf5Binding *binding)
{
    if (binding == NULL) return TQZ_ERR_ARGUMENT;
    return tqz_invalidate(&binding->object, &binding->host.kernel);
}

void session_af5_new_game(SessionAf5Binding *binding)
{
    if (binding == NULL) return;
    tqz_world_new_game(&binding->world);
}

int session_af5_render(SessionAf5Binding *binding, TqzRenderResult *out)
{
    const uint8_t *body;
    int status;
    if (binding == NULL || out == NULL) return TQZ_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    if (binding->object.slot == TQZ_NO_SLOT) return TQZ_OK; /* no render entry: 0x4b9a88 is never called */
    body = active_body(binding);
    if (body == NULL) return TQZ_ERR_ARGUMENT;
    status = tqz_render(&binding->object, &binding->world, body, TQZ_BODY_BYTES, &binding->host.kernel, out);
    binding->failure = status == TQZ_OK ? "none" : "0xf5-render";
    return status;
}

int session_af5_render_score(SessionAf5Binding *binding, TqzRenderResult *out)
{
    int status;
    if (binding == NULL || out == NULL) return TQZ_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    if (binding->object.score_block[44] == -1) return TQZ_OK; /* no score entry: 0x446688 is never called */
    status = tqz_render_score(&binding->world, &binding->host.kernel, out);
    binding->failure = status == TQZ_OK ? "none" : "0xf5-render-score";
    return status;
}

int session_af5_render_clock(SessionAf5Binding *binding, TqzRenderResult *out)
{
    int status;
    if (binding == NULL || out == NULL) return TQZ_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    if (binding->object.clock_block[48] == -1) return TQZ_OK; /* no clock entry: 0x4468fe is never called */
    status = tqz_render_clock(&binding->world, &binding->host.kernel, out);
    binding->failure = status == TQZ_OK ? "none" : "0xf5-render-clock";
    return status;
}

unsigned session_af5_registered(const SessionAf5Binding *binding)
{
    return binding != NULL && binding->object.slot != TQZ_NO_SLOT ? 1u : 0u;
}

const TqzObject *session_af5_object(const SessionAf5Binding *binding)
{
    return binding == NULL ? NULL : &binding->object;
}

const TqzWorld *session_af5_world(const SessionAf5Binding *binding)
{
    return binding == NULL ? NULL : &binding->world;
}

const char *session_af5_failure(const SessionAf5Binding *binding)
{
    return binding == NULL ? "0xf5-binding-unbound" : binding->failure;
}
