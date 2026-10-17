#include "session_bindings_aea.h"

#include <stdlib.h>
#include <string.h>

typedef struct AeaRow {
    uint8_t present;
    uint8_t body[EA_BODY_BYTES];
} AeaRow;

struct SessionAeaBinding {
    SessionAeaHost host;
    EaObject object;
    EaWorld world;
    AeaRow *rows;
    size_t count;
    const char *failure;
};

SessionAeaBinding *session_aea_create(const SessionAeaHost *host)
{
    SessionAeaBinding *binding;
    if (host == NULL) return NULL;
    binding = (SessionAeaBinding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        binding->host = *host;
        ea_object_reset(&binding->object);
        binding->failure = "none";
    }
    return binding;
}

void session_aea_destroy(SessionAeaBinding *binding)
{
    if (binding == NULL) return;
    (void)ea_cleanup(&binding->object, &binding->host.kernel);
    free(binding->rows);
    free(binding);
}

int session_aea_begin_scene(SessionAeaBinding *binding, const SceneResource *scene)
{
    AeaRow *rows;
    size_t count;
    if (binding == NULL || scene == NULL) return EA_ERR_ARGUMENT;
    count = scene_resource_action_count(scene);
    rows = count == 0u ? NULL : (AeaRow *)calloc(count, sizeof(*rows));
    if (count != 0u && rows == NULL) {
        binding->failure = "0xea-row-allocation";
        return EA_ERR_MEMORY;
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        const char *why = NULL;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(rows);
            binding->failure = "0xea-scene-row";
            return EA_ERR_BODY;
        }
        if (info.type != SESSION_AEA_TYPE) continue;
        if (ea_validate_body(info.typed_body, info.typed_body_length, &why) != EA_OK) {
            free(rows);
            binding->failure = why;
            return EA_ERR_BODY;
        }
        memcpy(rows[i].body, info.typed_body, EA_BODY_BYTES);
        rows[i].present = 1u;
    }
    /* The previous scene's clear (0x4381f4 -> 0x483fb5). */
    if (ea_cleanup(&binding->object, &binding->host.kernel) != EA_OK) {
        free(rows);
        binding->failure = "0xea-scene-clear";
        return EA_ERR_HOST;
    }
    free(binding->rows);
    binding->rows = rows;
    binding->count = count;
    binding->failure = "none";
    return EA_OK;
}

int session_aea_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionAeaBinding *binding = (SessionAeaBinding *)context;
    EaResult result;
    const char *why = NULL;
    int status;
    if (binding == NULL) return SCENE_ACTION_HANDLER_ERROR;
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_AEA_TYPE ||
        index >= binding->count || binding->rows[index].present == 0u) {
        binding->failure = "0xea-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    status = ea_step(&binding->object, binding->rows[index].body, EA_BODY_BYTES, (int16_t)index, before->phase,
                     &binding->world, &binding->host.kernel, &result, &why);
    binding->failure = why != NULL ? why : "none";
    if (status == EA_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != EA_OK) return SCENE_ACTION_HANDLER_ERROR;
    if ((result.initialized != 0u || result.completed != 0u) && binding->host.store_world != NULL)
        binding->host.store_world(binding->host.kernel.context, &binding->world);
    out->phase = result.phase_after;
    out->disposition = result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

static uint8_t *active_body(SessionAeaBinding *binding)
{
    const int16_t row = ea_object_row(&binding->object);
    if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL;
    return binding->rows[row].body;
}

int session_aea_pointer_move(SessionAeaBinding *binding, int16_t x, int16_t y, const int32_t rect[4],
                             EaPointerResult *out)
{
    uint8_t *body;
    if (binding == NULL || out == NULL) return EA_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    if (!ea_object_active(&binding->object)) return EA_OK; /* 0x484f42 returns 0 without touching anything */
    body = active_body(binding);
    if (body == NULL) return EA_ERR_ARGUMENT;
    return ea_pointer_move(&binding->object, body, EA_BODY_BYTES, x, y, rect, &binding->host.kernel, out);
}

int session_aea_click(SessionAeaBinding *binding, uint32_t row_phase, int32_t candidate, uint32_t *new_phase)
{
    uint8_t *body;
    int status;
    if (binding == NULL || new_phase == NULL) return EA_ERR_ARGUMENT;
    *new_phase = row_phase;
    if (!ea_object_active(&binding->object)) return EA_OK;
    body = active_body(binding);
    if (body == NULL) return EA_ERR_ARGUMENT;
    status = ea_click(&binding->object, body, EA_BODY_BYTES, row_phase, candidate, &binding->host.kernel, new_phase);
    binding->failure = status == EA_OK ? "none" : "0xea-click";
    return status;
}

int session_aea_rotate_key(SessionAeaBinding *binding, uint32_t row_phase)
{
    uint8_t *body;
    int status;
    if (binding == NULL) return EA_ERR_ARGUMENT;
    if (!ea_object_active(&binding->object)) return EA_OK;
    body = active_body(binding);
    if (body == NULL) return EA_ERR_ARGUMENT;
    status = ea_rotate_key(&binding->object, body, EA_BODY_BYTES, row_phase, &binding->host.kernel);
    binding->failure = status == EA_OK ? "none" : "0xea-rotate";
    return status;
}

int session_aea_invalidate(SessionAeaBinding *binding)
{
    if (binding == NULL) return EA_ERR_ARGUMENT;
    return ea_invalidate(&binding->object, &binding->host.kernel);
}

int session_aea_render_plan(SessionAeaBinding *binding, EaRenderPlan *plan)
{
    uint8_t *body;
    if (binding == NULL || plan == NULL) return EA_ERR_ARGUMENT;
    if (ea_object_slot(&binding->object) == EA_NO_SLOT) { /* no render entry: 0x4876ed is never called */
        memset(plan, 0, sizeof(*plan));
        return EA_OK;
    }
    body = active_body(binding);
    if (body == NULL) {
        memset(plan, 0, sizeof(*plan));
        return EA_ERR_ARGUMENT;
    }
    return ea_render_plan(&binding->object, body, EA_BODY_BYTES, &binding->host.kernel, plan);
}

unsigned session_aea_registered(const SessionAeaBinding *binding)
{
    return binding != NULL && ea_object_slot(&binding->object) != EA_NO_SLOT ? 1u : 0u;
}

const EaObject *session_aea_object(const SessionAeaBinding *binding)
{
    return binding == NULL ? NULL : &binding->object;
}

const char *session_aea_failure(const SessionAeaBinding *binding)
{
    return binding == NULL ? "0xea-binding-unbound" : binding->failure;
}
