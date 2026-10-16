#include "session_bindings_ad9.h"

#include <stdlib.h>
#include <string.h>

typedef struct Ad9Row {
    uint8_t present;
    uint8_t body[D9_BODY_BYTES];
} Ad9Row;

struct SessionAd9Binding {
    SessionAd9Host host;
    D9Object object;
    D9World world;
    Ad9Row *rows;
    size_t count;
    const char *failure;
};

SessionAd9Binding *session_ad9_create(const SessionAd9Host *host)
{
    SessionAd9Binding *binding;
    if (host == NULL) return NULL;
    binding = (SessionAd9Binding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        binding->host = *host;
        d9_object_reset(&binding->object);
        binding->failure = "none";
    }
    return binding;
}

void session_ad9_destroy(SessionAd9Binding *binding)
{
    if (binding == NULL) return;
    (void)d9_cleanup(&binding->object, &binding->host.kernel);
    free(binding->rows);
    free(binding);
}

int session_ad9_begin_scene(SessionAd9Binding *binding, const SceneResource *scene)
{
    Ad9Row *rows;
    size_t count;
    if (binding == NULL || scene == NULL) return D9_ERR_ARGUMENT;
    count = scene_resource_action_count(scene);
    rows = count == 0u ? NULL : (Ad9Row *)calloc(count, sizeof(*rows));
    if (count != 0u && rows == NULL) {
        binding->failure = "0xd9-row-allocation";
        return D9_ERR_MEMORY;
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        const char *why = NULL;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(rows);
            binding->failure = "0xd9-scene-row";
            return D9_ERR_BODY;
        }
        if (info.type != SESSION_AD9_TYPE) continue;
        if (d9_validate_body(info.typed_body, info.typed_body_length, &why) != D9_OK) {
            free(rows);
            binding->failure = why;
            return D9_ERR_BODY;
        }
        memcpy(rows[i].body, info.typed_body, D9_BODY_BYTES);
        rows[i].present = 1u;
    }
    /* The previous scene's clear (0x4381f4 -> 0x47d59b). */
    if (d9_cleanup(&binding->object, &binding->host.kernel) != D9_OK) {
        free(rows);
        binding->failure = "0xd9-scene-clear";
        return D9_ERR_HOST;
    }
    free(binding->rows);
    binding->rows = rows;
    binding->count = count;
    binding->failure = "none";
    return D9_OK;
}

int session_ad9_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionAd9Binding *binding = (SessionAd9Binding *)context;
    D9Result result;
    const char *why = NULL;
    int status;
    if (binding == NULL) return SCENE_ACTION_HANDLER_ERROR;
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_AD9_TYPE ||
        index >= binding->count || binding->rows[index].present == 0u) {
        binding->failure = "0xd9-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    status = d9_step(&binding->object, binding->rows[index].body, D9_BODY_BYTES, (int16_t)index,
                     before->phase, &binding->world, &binding->host.kernel, &result, &why);
    binding->failure = why != NULL ? why : "none";
    if (status == D9_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != D9_OK) return SCENE_ACTION_HANDLER_ERROR;
    if (result.initialized != 0u && binding->host.store_world != NULL)
        binding->host.store_world(binding->host.kernel.context, &binding->world);
    out->phase = result.phase_after;
    out->disposition = SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

int session_ad9_pointer_move(SessionAd9Binding *binding, int16_t x, int16_t y)
{
    if (binding == NULL) return D9_ERR_ARGUMENT;
    return d9_pointer_move(&binding->object, x, y);
}

int session_ad9_invalidate(SessionAd9Binding *binding)
{
    if (binding == NULL) return D9_ERR_ARGUMENT;
    return d9_invalidate(&binding->object, &binding->host.kernel);
}

int session_ad9_render_plan(SessionAd9Binding *binding, D9RenderPlan *plan)
{
    D9View view;
    if (binding == NULL || plan == NULL) return D9_ERR_ARGUMENT;
    if (binding->object.slot == D9_NO_SLOT) { /* no render entry: 0x47df57 is never called */
        memset(plan, 0, sizeof(*plan));
        return D9_OK;
    }
    if (binding->object.active == 0u || binding->object.row < 0 ||
        (size_t)binding->object.row >= binding->count ||
        binding->rows[binding->object.row].present == 0u || binding->host.kernel.view == NULL ||
        binding->host.kernel.view(binding->host.kernel.context, &view) != 0) {
        memset(plan, 0, sizeof(*plan));
        return binding->object.active == 0u ? D9_OK : D9_ERR_ARGUMENT;
    }
    return d9_render_plan(&binding->object, binding->rows[binding->object.row].body, D9_BODY_BYTES,
                          &view, plan);
}

unsigned session_ad9_registered(const SessionAd9Binding *binding)
{
    return binding != NULL && binding->object.slot != D9_NO_SLOT ? 1u : 0u;
}

const D9Object *session_ad9_object(const SessionAd9Binding *binding)
{
    return binding == NULL ? NULL : &binding->object;
}

const char *session_ad9_failure(const SessionAd9Binding *binding)
{
    return binding == NULL ? "0xd9-binding-unbound" : binding->failure;
}
