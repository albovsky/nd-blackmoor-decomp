#include "session_bindings_af6.h"

#include <stdlib.h>
#include <string.h>

typedef struct Af6Row {
    uint8_t present;
    uint8_t body[F6_BODY_BYTES];
} Af6Row;

struct SessionAf6Binding {
    SessionAf6Host host;
    F6Object object;
    F6World world;
    Af6Row *rows;
    size_t count;
    const char *failure;
};

SessionAf6Binding *session_af6_create(const SessionAf6Host *host)
{
    SessionAf6Binding *binding;
    if (host == NULL) return NULL;
    binding = (SessionAf6Binding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        binding->host = *host;
        f6_object_reset(&binding->object);
        binding->failure = "none";
    }
    return binding;
}

void session_af6_destroy(SessionAf6Binding *binding)
{
    if (binding == NULL) return;
    (void)f6_cleanup(&binding->object, &binding->host.kernel);
    free(binding->rows);
    free(binding);
}

int session_af6_begin_scene(SessionAf6Binding *binding, const SceneResource *scene)
{
    Af6Row *rows;
    size_t count;
    if (binding == NULL || scene == NULL) return F6_ERR_ARGUMENT;
    count = scene_resource_action_count(scene);
    rows = count == 0u ? NULL : (Af6Row *)calloc(count, sizeof(*rows));
    if (count != 0u && rows == NULL) {
        binding->failure = "0xf6-row-allocation";
        return F6_ERR_MEMORY;
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        const char *why = NULL;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(rows);
            binding->failure = "0xf6-scene-row";
            return F6_ERR_BODY;
        }
        if (info.type != SESSION_AF6_TYPE) continue;
        if (f6_validate_body(info.typed_body, info.typed_body_length, &why) != F6_OK) {
            free(rows);
            binding->failure = why;
            return F6_ERR_BODY;
        }
        memcpy(rows[i].body, info.typed_body, F6_BODY_BYTES);
        rows[i].present = 1u;
    }
    /* The previous scene's clear (0x4381f4 -> 0x45dd4d). */
    if (f6_cleanup(&binding->object, &binding->host.kernel) != F6_OK) {
        free(rows);
        binding->failure = "0xf6-scene-clear";
        return F6_ERR_HOST;
    }
    free(binding->rows);
    binding->rows = rows;
    binding->count = count;
    binding->failure = "none";
    return F6_OK;
}

int session_af6_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionAf6Binding *binding = (SessionAf6Binding *)context;
    F6Result result;
    const char *why = NULL;
    int status;
    if (binding == NULL) return SCENE_ACTION_HANDLER_ERROR;
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_AF6_TYPE ||
        index >= binding->count || binding->rows[index].present == 0u) {
        binding->failure = "0xf6-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    status = f6_step(&binding->object, binding->rows[index].body, F6_BODY_BYTES, (int16_t)index, before->phase,
                     &binding->world, &binding->host.kernel, &result, &why);
    binding->failure = why != NULL ? why : "none";
    if (status == F6_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != F6_OK) return SCENE_ACTION_HANDLER_ERROR;
    if ((result.initialized != 0u || result.completed != 0u) && binding->host.store_world != NULL)
        binding->host.store_world(binding->host.kernel.context, &binding->world);
    out->phase = result.phase_after;
    out->disposition = result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

static const uint8_t *active_body(const SessionAf6Binding *binding)
{
    const int16_t row = binding->object.row;
    if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL;
    return binding->rows[row].body;
}

int session_af6_pointer_move(SessionAf6Binding *binding, int16_t x, int16_t y, F6PointerResult *out)
{
    const uint8_t *body;
    if (binding == NULL || out == NULL) return F6_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    if (binding->object.active == 0) return F6_OK; /* 0x45e1ca returns 0 without touching anything */
    body = active_body(binding);
    if (body == NULL) return F6_ERR_ARGUMENT;
    return f6_pointer_move(&binding->object, body, F6_BODY_BYTES, x, y, out);
}

int session_af6_click(SessionAf6Binding *binding, uint32_t row_phase, int32_t candidate, uint32_t *new_phase)
{
    const uint8_t *body;
    int status;
    if (binding == NULL || new_phase == NULL) return F6_ERR_ARGUMENT;
    *new_phase = row_phase;
    if (binding->object.active == 0) return F6_OK;
    body = active_body(binding);
    if (body == NULL) return F6_ERR_ARGUMENT;
    status = f6_click(&binding->object, body, F6_BODY_BYTES, row_phase, candidate, &binding->host.kernel, new_phase);
    binding->failure = status == F6_OK ? "none" : "0xf6-click";
    return status;
}

int session_af6_invalidate(SessionAf6Binding *binding)
{
    if (binding == NULL) return F6_ERR_ARGUMENT;
    return f6_invalidate(&binding->object, &binding->host.kernel);
}

int session_af6_render_plan(SessionAf6Binding *binding, F6RenderPlan *plan)
{
    const uint8_t *body;
    if (binding == NULL || plan == NULL) return F6_ERR_ARGUMENT;
    if (binding->object.slot == F6_NO_SLOT) { /* no render entry: 0x460f26 is never called */
        memset(plan, 0, sizeof(*plan));
        return F6_OK;
    }
    body = active_body(binding);
    if (body == NULL) {
        memset(plan, 0, sizeof(*plan));
        return F6_ERR_ARGUMENT;
    }
    return f6_render_plan(&binding->object, body, F6_BODY_BYTES, &binding->host.kernel, plan);
}

unsigned session_af6_registered(const SessionAf6Binding *binding)
{
    return binding != NULL && binding->object.slot != F6_NO_SLOT ? 1u : 0u;
}

const F6Object *session_af6_object(const SessionAf6Binding *binding)
{
    return binding == NULL ? NULL : &binding->object;
}

const char *session_af6_failure(const SessionAf6Binding *binding)
{
    return binding == NULL ? "0xf6-binding-unbound" : binding->failure;
}
