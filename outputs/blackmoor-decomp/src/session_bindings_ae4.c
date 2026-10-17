#include "session_bindings_ae4.h"

#include <stdlib.h>
#include <string.h>

typedef struct Ae4Row {
    uint8_t present;
    uint8_t body[E4R_BODY_BYTES];
} Ae4Row;

struct SessionAe4Binding {
    SessionAe4Host host;
    E4rObject object;
    E4rWorld world;
    Ae4Row *rows;
    size_t count;
    const char *failure;
};

SessionAe4Binding *session_ae4_create(const SessionAe4Host *host)
{
    SessionAe4Binding *binding;
    if (host == NULL) return NULL;
    binding = (SessionAe4Binding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        binding->host = *host;
        e4r_object_reset(&binding->object);
        binding->failure = "none";
    }
    return binding;
}

void session_ae4_destroy(SessionAe4Binding *binding)
{
    if (binding == NULL) return;
    (void)e4r_cleanup(&binding->object, &binding->host.kernel);
    free(binding->rows);
    free(binding);
}

int session_ae4_begin_scene(SessionAe4Binding *binding, const SceneResource *scene)
{
    Ae4Row *rows;
    size_t count;
    if (binding == NULL || scene == NULL) return E4R_ERR_ARGUMENT;
    count = scene_resource_action_count(scene);
    rows = count == 0u ? NULL : (Ae4Row *)calloc(count, sizeof(*rows));
    if (count != 0u && rows == NULL) {
        binding->failure = "0xe4-row-allocation";
        return E4R_ERR_UNSUPPORTED;
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        const char *why = NULL;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(rows);
            binding->failure = "0xe4-scene-row";
            return E4R_ERR_BODY;
        }
        if (info.type != SESSION_AE4_TYPE) continue;
        if (info.typed_body_length != E4R_BODY_BYTES || info.typed_body == NULL) {
            free(rows);
            binding->failure = "0xe4-body-length";
            return E4R_ERR_BODY;
        }
        memcpy(rows[i].body, info.typed_body, E4R_BODY_BYTES);
        if (e4r_validate_body(rows[i].body, E4R_BODY_BYTES, &why) != E4R_OK) {
            free(rows);
            binding->failure = why != NULL ? why : "0xe4-body";
            return E4R_ERR_BODY;
        }
        rows[i].present = 1u;
    }
    /* The previous scene's clear (0x475885) and the scene reset of the high score table (0x47591f). */
    if (e4r_cleanup(&binding->object, &binding->host.kernel) != E4R_OK) {
        free(rows);
        binding->failure = "0xe4-scene-clear";
        return E4R_ERR_HOST;
    }
    e4r_scene_reset(&binding->world);
    free(binding->rows);
    binding->rows = rows;
    binding->count = count;
    binding->failure = "none";
    return E4R_OK;
}

int session_ae4_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionAe4Binding *binding = (SessionAe4Binding *)context;
    E4rResult result;
    const char *why = NULL;
    Ae4Row *row;
    int status;
    if (binding == NULL) return SCENE_ACTION_HANDLER_ERROR;
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_AE4_TYPE || index >= binding->count ||
        binding->rows[index].present == 0u || index > (size_t)INT16_MAX) {
        binding->failure = "0xe4-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    row = &binding->rows[index];
    status = e4r_step(&binding->object, row->body, E4R_BODY_BYTES, (int16_t)index, before->phase, &binding->world,
                      &binding->host.kernel, &result, &why);
    binding->failure = why != NULL ? why : "none";
    if (status == E4R_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != E4R_OK) return SCENE_ACTION_HANDLER_ERROR;
    if ((result.initialized != 0u || result.completed != 0u) && binding->host.store_world != NULL)
        binding->host.store_world(binding->host.kernel.context, &binding->world);
    out->phase = result.phase_after;
    out->disposition = result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

static const Ae4Row *active_row(const SessionAe4Binding *binding)
{
    const int16_t row = e4r_rd16(&binding->object, E4R_O_ROW);
    if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL;
    return &binding->rows[row];
}

static int object_active(const SessionAe4Binding *binding)
{
    return e4r_rd32(&binding->object, E4R_O_ACTIVE) != 0;
}

int session_ae4_pointer_move(SessionAe4Binding *binding, int32_t x, int32_t y, E4rPointerResult *out)
{
    const Ae4Row *row;
    int status;
    if (binding == NULL || out == NULL) return E4R_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    if (!object_active(binding)) return E4R_OK;
    row = active_row(binding);
    if (row == NULL) return E4R_ERR_ARGUMENT;
    status = e4r_pointer(&binding->object, row->body, E4R_BODY_BYTES, x, y, out);
    binding->failure = status == E4R_OK ? "none" : "0xe4-pointer";
    return status;
}

int session_ae4_click(SessionAe4Binding *binding, uint32_t row_phase, int32_t candidate, E4rClickResult *out)
{
    const Ae4Row *row;
    int status;
    if (binding == NULL || out == NULL) return E4R_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    if (!object_active(binding)) return E4R_OK;
    row = active_row(binding);
    if (row == NULL) return E4R_ERR_ARGUMENT;
    status = e4r_click(&binding->object, row->body, E4R_BODY_BYTES, row_phase, candidate, &binding->host.kernel, out);
    binding->failure = status == E4R_OK ? "none" : "0xe4-click";
    return status;
}

int session_ae4_invalidate(SessionAe4Binding *binding)
{
    if (binding == NULL) return E4R_ERR_ARGUMENT;
    return e4r_invalidate(&binding->object, &binding->host.kernel);
}

int session_ae4_render(SessionAe4Binding *binding, E4rRenderResult *out)
{
    const Ae4Row *row;
    int status;
    if (binding == NULL || out == NULL) return E4R_ERR_ARGUMENT;
    out->valid = 0u;
    out->count = 0u;
    if (e4r_rd16(&binding->object, E4R_O_SLOT) == E4R_NO_SLOT) return E4R_OK; /* nothing registered or drawn */
    row = active_row(binding);
    if (row == NULL) return E4R_ERR_ARGUMENT;
    status = e4r_render(&binding->object, row->body, E4R_BODY_BYTES, &binding->world, &binding->host.kernel, out);
    binding->failure = status == E4R_OK ? "none" : "0xe4-render";
    return status;
}

unsigned session_ae4_registered(const SessionAe4Binding *binding)
{
    return binding != NULL && e4r_rd16(&binding->object, E4R_O_SLOT) != E4R_NO_SLOT ? 1u : 0u;
}

const E4rObject *session_ae4_state(const SessionAe4Binding *binding)
{
    return binding == NULL ? NULL : &binding->object;
}

const E4rWorld *session_ae4_world(const SessionAe4Binding *binding)
{
    return binding == NULL ? NULL : &binding->world;
}

const char *session_ae4_failure(const SessionAe4Binding *binding)
{
    return binding == NULL ? "0xe4-binding-unbound" : binding->failure;
}
