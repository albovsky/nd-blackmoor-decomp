#include "session_bindings_ad0.h"

#include <stdlib.h>
#include <string.h>

typedef struct Ad0Row {
    uint8_t present;
    uint8_t body[D0_BODY_BYTES];
} Ad0Row;

struct SessionAd0Binding {
    SessionAd0Host host;
    D0Object object;
    D0World world;
    Ad0Row *rows;
    size_t count;
    const char *failure;
};

SessionAd0Binding *session_ad0_create(const SessionAd0Host *host)
{
    SessionAd0Binding *binding;
    if (host == NULL) return NULL;
    binding = (SessionAd0Binding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        binding->host = *host;
        d0_object_reset(&binding->object);
        binding->failure = "none";
    }
    return binding;
}

void session_ad0_destroy(SessionAd0Binding *binding)
{
    if (binding == NULL) return;
    (void)d0_cleanup(&binding->object, &binding->host.kernel);
    free(binding->rows);
    free(binding);
}

int session_ad0_begin_scene(SessionAd0Binding *binding, const SceneResource *scene)
{
    Ad0Row *rows;
    size_t count;
    if (binding == NULL || scene == NULL) return D0_ERR_ARGUMENT;
    count = scene_resource_action_count(scene);
    rows = count == 0u ? NULL : (Ad0Row *)calloc(count, sizeof(*rows));
    if (count != 0u && rows == NULL) {
        binding->failure = "0xd0-row-allocation";
        return D0_ERR_BOUNDS;
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        const char *why = NULL;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(rows);
            binding->failure = "0xd0-scene-row";
            return D0_ERR_BODY;
        }
        if (info.type != SESSION_AD0_TYPE) continue;
        if (d0_validate_body(info.typed_body, info.typed_body_length, &why) != D0_OK) {
            free(rows);
            binding->failure = why;
            return D0_ERR_BODY;
        }
        memcpy(rows[i].body, info.typed_body, D0_BODY_BYTES);
        rows[i].present = 1u;
    }
    /* The previous scene's clear (0x438b5d / 0x43de52 -> 0x48d09c). */
    if (d0_cleanup(&binding->object, &binding->host.kernel) != D0_OK) {
        free(rows);
        binding->failure = "0xd0-scene-clear";
        return D0_ERR_HOST;
    }
    free(binding->rows);
    binding->rows = rows;
    binding->count = count;
    binding->failure = "none";
    return D0_OK;
}

int session_ad0_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionAd0Binding *binding = (SessionAd0Binding *)context;
    D0Result result;
    const char *why = NULL;
    int status;
    if (binding == NULL) return SCENE_ACTION_HANDLER_ERROR;
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_AD0_TYPE ||
        index >= binding->count || binding->rows[index].present == 0u) {
        binding->failure = "0xd0-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    status = d0_step(&binding->object, binding->rows[index].body, D0_BODY_BYTES, (int16_t)index, before->phase,
                     &binding->world, &binding->host.kernel, &result, &why);
    binding->failure = why != NULL ? why : "none";
    if (status == D0_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != D0_OK) return SCENE_ACTION_HANDLER_ERROR;
    if ((result.initialized != 0u || result.completed != 0u) && binding->host.store_world != NULL)
        binding->host.store_world(binding->host.kernel.context, &binding->world);
    out->phase = result.phase_after;
    out->disposition = result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

/* The live (mutable) body of the object's row, NULL when the object has no row of this binding. */
static uint8_t *active_body(SessionAd0Binding *binding)
{
    const int16_t row = binding->object.row;
    if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL;
    return binding->rows[row].body;
}

int session_ad0_pointer_move(SessionAd0Binding *binding, int32_t x, int32_t y, D0PointerResult *out)
{
    const uint8_t *body;
    if (binding == NULL || out == NULL) return D0_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    if (binding->object.active == 0) return D0_OK; /* 0x48d1e8 returns 0 without touching anything */
    body = active_body(binding);
    if (body == NULL) return D0_ERR_ARGUMENT;
    return d0_pointer(&binding->object, body, D0_BODY_BYTES, x, y, out);
}

int session_ad0_click(SessionAd0Binding *binding, uint32_t row_phase, int32_t candidate, int32_t start_flag,
                      D0ClickResult *out)
{
    uint8_t *body;
    int status;
    if (binding == NULL || out == NULL) return D0_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->new_phase = row_phase;
    if (binding->object.active == 0) return D0_OK;
    body = active_body(binding);
    if (body == NULL) return D0_ERR_ARGUMENT;
    status = d0_click(&binding->object, body, D0_BODY_BYTES, row_phase, candidate, start_flag, &binding->host.kernel,
                      out);
    binding->failure = status == D0_OK ? "none" : "0xd0-click";
    return status;
}

int session_ad0_invalidate(SessionAd0Binding *binding)
{
    if (binding == NULL) return D0_ERR_ARGUMENT;
    return d0_invalidate(&binding->object, &binding->host.kernel);
}

int session_ad0_render(SessionAd0Binding *binding, D0RenderResult *out)
{
    const uint8_t *body;
    if (binding == NULL || out == NULL) return D0_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    if (binding->object.slot == D0_NO_SLOT) return D0_OK; /* no render entry: 0x48ded7 is never called */
    body = active_body(binding);
    if (body == NULL) return D0_ERR_ARGUMENT;
    return d0_render(&binding->object, body, D0_BODY_BYTES, &binding->host.kernel, out);
}

unsigned session_ad0_registered(const SessionAd0Binding *binding)
{
    return binding != NULL && binding->object.slot != D0_NO_SLOT ? 1u : 0u;
}

const D0Object *session_ad0_object(const SessionAd0Binding *binding)
{
    return binding == NULL ? NULL : &binding->object;
}

const char *session_ad0_failure(const SessionAd0Binding *binding)
{
    return binding == NULL ? "0xd0-binding-unbound" : binding->failure;
}
