#include "session_bindings_ad1.h"

#include <stdlib.h>
#include <string.h>

typedef struct Ad1Row {
    uint8_t present;
    uint8_t body[D1_BODY_BYTES];
} Ad1Row;

struct SessionAd1Binding {
    SessionAd1Host host;
    D1Object object;
    D1World world;
    Ad1Row *rows;
    size_t count;
    const char *failure;
};

SessionAd1Binding *session_ad1_create(const SessionAd1Host *host)
{
    SessionAd1Binding *binding;
    if (host == NULL) return NULL;
    binding = (SessionAd1Binding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        binding->host = *host;
        d1_object_reset(&binding->object);
        binding->failure = "none";
    }
    return binding;
}

void session_ad1_destroy(SessionAd1Binding *binding)
{
    if (binding == NULL) return;
    (void)d1_cleanup(&binding->object, &binding->host.kernel);
    free(binding->rows);
    free(binding);
}

int session_ad1_begin_scene(SessionAd1Binding *binding, const SceneResource *scene)
{
    Ad1Row *rows;
    size_t count;
    if (binding == NULL || scene == NULL) return D1_ERR_ARGUMENT;
    count = scene_resource_action_count(scene);
    rows = count == 0u ? NULL : (Ad1Row *)calloc(count, sizeof(*rows));
    if (count != 0u && rows == NULL) {
        binding->failure = "0xd1-row-allocation";
        return D1_ERR_MEMORY;
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        const char *why = NULL;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(rows);
            binding->failure = "0xd1-scene-row";
            return D1_ERR_BODY;
        }
        if (info.type != SESSION_AD1_TYPE) continue;
        if (d1_validate_body(info.typed_body, info.typed_body_length, &why) != D1_OK) {
            free(rows);
            binding->failure = why;
            return D1_ERR_BODY;
        }
        memcpy(rows[i].body, info.typed_body, D1_BODY_BYTES);
        rows[i].present = 1u;
    }
    /* The previous scene's clear (0x4381f4 -> 0x4b5bc8). */
    if (d1_cleanup(&binding->object, &binding->host.kernel) != D1_OK) {
        free(rows);
        binding->failure = "0xd1-scene-clear";
        return D1_ERR_HOST;
    }
    free(binding->rows);
    binding->rows = rows;
    binding->count = count;
    binding->failure = "none";
    return D1_OK;
}

int session_ad1_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionAd1Binding *binding = (SessionAd1Binding *)context;
    D1Result result;
    const char *why = NULL;
    int status;
    if (binding == NULL) return SCENE_ACTION_HANDLER_ERROR;
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_AD1_TYPE ||
        index >= binding->count || binding->rows[index].present == 0u) {
        binding->failure = "0xd1-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    status = d1_step(&binding->object, binding->rows[index].body, D1_BODY_BYTES, (int16_t)index, before->phase,
                     &binding->world, &binding->host.kernel, &result, &why);
    binding->failure = why != NULL ? why : "none";
    if (status == D1_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != D1_OK) return SCENE_ACTION_HANDLER_ERROR;
    if ((result.initialized != 0u || result.completed != 0u) && binding->host.store_world != NULL)
        binding->host.store_world(binding->host.kernel.context, &binding->world);
    out->phase = result.phase_after;
    out->disposition = result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

static const uint8_t *active_body(const SessionAd1Binding *binding)
{
    const int16_t row = binding->object.row;
    if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL;
    return binding->rows[row].body;
}

int session_ad1_pointer_move(SessionAd1Binding *binding, int16_t x, int16_t y, D1PointerResult *out)
{
    const uint8_t *body;
    if (binding == NULL || out == NULL) return D1_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    if (binding->object.active == 0) return D1_OK; /* 0x4b5d17 returns 0 without touching anything */
    body = active_body(binding);
    if (body == NULL) return D1_ERR_ARGUMENT;
    return d1_pointer_move(&binding->object, body, D1_BODY_BYTES, x, y, out);
}

int session_ad1_click(SessionAd1Binding *binding, uint32_t row_phase, int32_t candidate, int32_t start_flag,
                      uint32_t *new_phase)
{
    const uint8_t *body;
    int status;
    if (binding == NULL || new_phase == NULL) return D1_ERR_ARGUMENT;
    *new_phase = row_phase;
    if (binding->object.active == 0) return D1_OK;
    body = active_body(binding);
    if (body == NULL) return D1_ERR_ARGUMENT;
    status = d1_click(&binding->object, body, D1_BODY_BYTES, row_phase, candidate, start_flag, &binding->host.kernel,
                      new_phase);
    binding->failure = status == D1_OK ? "none" : "0xd1-click";
    return status;
}

int session_ad1_invalidate(SessionAd1Binding *binding)
{
    if (binding == NULL) return D1_ERR_ARGUMENT;
    return d1_invalidate(&binding->object, &binding->host.kernel);
}

int session_ad1_render_plan(SessionAd1Binding *binding, D1RenderPlan *plan)
{
    const uint8_t *body;
    if (binding == NULL || plan == NULL) return D1_ERR_ARGUMENT;
    if (binding->object.slot == D1_NO_SLOT) { /* no render entry: 0x4b7051 is never called */
        memset(plan, 0, sizeof(*plan));
        return D1_OK;
    }
    body = active_body(binding);
    if (body == NULL) {
        memset(plan, 0, sizeof(*plan));
        return D1_ERR_ARGUMENT;
    }
    return d1_render_plan(&binding->object, body, D1_BODY_BYTES, plan);
}

unsigned session_ad1_registered(const SessionAd1Binding *binding)
{
    return binding != NULL && binding->object.slot != D1_NO_SLOT ? 1u : 0u;
}

const D1Object *session_ad1_object(const SessionAd1Binding *binding)
{
    return binding == NULL ? NULL : &binding->object;
}

const char *session_ad1_failure(const SessionAd1Binding *binding)
{
    return binding == NULL ? "0xd1-binding-unbound" : binding->failure;
}
