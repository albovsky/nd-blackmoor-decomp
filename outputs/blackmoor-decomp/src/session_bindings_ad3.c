#include "session_bindings_ad3.h"

#include <stdlib.h>
#include <string.h>

typedef struct Ad3Row {
    uint8_t present;
    uint8_t body[CPZ_BODY_BYTES];
} Ad3Row;

struct SessionAd3Binding {
    SessionAd3Host host;
    CpzObject object;
    CpzWorld world;
    Ad3Row *rows;
    size_t count;
    const char *failure;
};

SessionAd3Binding *session_ad3_create(const SessionAd3Host *host)
{
    SessionAd3Binding *binding;
    if (host == NULL) return NULL;
    binding = (SessionAd3Binding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        binding->host = *host;
        cpz_object_reset(&binding->object);
        binding->failure = "none";
    }
    return binding;
}

void session_ad3_destroy(SessionAd3Binding *binding)
{
    if (binding == NULL) return;
    (void)cpz_cleanup(&binding->object, &binding->host.kernel);
    free(binding->rows);
    free(binding);
}

int session_ad3_begin_scene(SessionAd3Binding *binding, const SceneResource *scene)
{
    Ad3Row *rows;
    size_t count;
    if (binding == NULL || scene == NULL) return CPZ_ERR_ARGUMENT;
    count = scene_resource_action_count(scene);
    rows = count == 0u ? NULL : (Ad3Row *)calloc(count, sizeof(*rows));
    if (count != 0u && rows == NULL) {
        binding->failure = "0xd3-row-allocation";
        return CPZ_ERR_BOUNDS;
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        const char *why = NULL;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(rows);
            binding->failure = "0xd3-scene-row";
            return CPZ_ERR_BODY;
        }
        if (info.type != SESSION_AD3_TYPE) continue;
        if (cpz_validate_body(info.typed_body, info.typed_body_length, &why) != CPZ_OK) {
            free(rows);
            binding->failure = why;
            return CPZ_ERR_BODY;
        }
        memcpy(rows[i].body, info.typed_body, CPZ_BODY_BYTES);
        rows[i].present = 1u;
    }
    /* The previous scene's clear (0x438b5d / 0x43de52 -> 0x461862). The grid world is not touched. */
    if (cpz_cleanup(&binding->object, &binding->host.kernel) != CPZ_OK) {
        free(rows);
        binding->failure = "0xd3-scene-clear";
        return CPZ_ERR_HOST;
    }
    free(binding->rows);
    binding->rows = rows;
    binding->count = count;
    binding->failure = "none";
    return CPZ_OK;
}

int session_ad3_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionAd3Binding *binding = (SessionAd3Binding *)context;
    CpzResult result;
    const char *why = NULL;
    int status;
    if (binding == NULL) return SCENE_ACTION_HANDLER_ERROR;
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_AD3_TYPE ||
        index >= binding->count || binding->rows[index].present == 0u) {
        binding->failure = "0xd3-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    status = cpz_step(&binding->object, binding->rows[index].body, CPZ_BODY_BYTES, (int16_t)index, before->phase,
                      &binding->world, &binding->host.kernel, &result, &why);
    binding->failure = why != NULL ? why : "none";
    if (status == CPZ_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != CPZ_OK) return SCENE_ACTION_HANDLER_ERROR;
    if ((result.initialized != 0u || result.completed != 0u) && binding->host.store_world != NULL)
        binding->host.store_world(binding->host.kernel.context, &binding->world);
    out->phase = result.phase_after;
    out->disposition = result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

/* The body of the object's row, NULL when the object has no row of this binding. */
static const uint8_t *active_body(const SessionAd3Binding *binding)
{
    const int16_t row = binding->object.row;
    if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL;
    return binding->rows[row].body;
}

int session_ad3_pointer_move(SessionAd3Binding *binding, int32_t x, int32_t y, CpzPointerResult *out)
{
    const uint8_t *body;
    int32_t view_x = 0, view_y = 0;
    if (binding == NULL || out == NULL) return CPZ_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    if (binding->object.active == 0) return CPZ_OK; /* 0x462c39 returns 0 without touching anything */
    body = active_body(binding);
    if (body == NULL) return CPZ_ERR_ARGUMENT;
    if (binding->host.kernel.view_origin == NULL ||
        binding->host.kernel.view_origin(binding->host.kernel.context, &view_x, &view_y) != 0) {
        binding->failure = "0xd3-pointer-origin";
        return CPZ_ERR_HOST;
    }
    return cpz_pointer(&binding->object, &binding->world, body, CPZ_BODY_BYTES, x, y, view_x, view_y, out);
}

int session_ad3_click(SessionAd3Binding *binding, uint32_t row_phase, int32_t candidate, int32_t start_flag,
                      CpzClickResult *out)
{
    const uint8_t *body;
    int status;
    if (binding == NULL || out == NULL) return CPZ_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->new_phase = row_phase;
    if (binding->object.active == 0) return CPZ_OK;
    body = active_body(binding);
    if (body == NULL) return CPZ_ERR_ARGUMENT;
    status = cpz_click(&binding->object, body, CPZ_BODY_BYTES, row_phase, candidate, start_flag, &binding->host.kernel,
                       out);
    binding->failure = status == CPZ_OK ? "none" : "0xd3-click";
    return status;
}

int session_ad3_invalidate(SessionAd3Binding *binding)
{
    if (binding == NULL) return CPZ_ERR_ARGUMENT;
    return cpz_invalidate(&binding->object, &binding->host.kernel);
}

void session_ad3_grid_reset(SessionAd3Binding *binding)
{
    if (binding == NULL) return;
    cpz_grid_reset(&binding->world);
}

int session_ad3_render(SessionAd3Binding *binding, CpzRenderResult *out)
{
    const uint8_t *body;
    int status;
    if (binding == NULL || out == NULL) return CPZ_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    if (binding->object.slot == CPZ_NO_SLOT) return CPZ_OK; /* no render entry: 0x463b10 is never called */
    body = active_body(binding);
    if (body == NULL) return CPZ_ERR_ARGUMENT;
    status = cpz_render(&binding->object, &binding->world, body, CPZ_BODY_BYTES, &binding->host.kernel, out);
    binding->failure = status == CPZ_OK ? "none" : "0xd3-render";
    return status;
}

unsigned session_ad3_registered(const SessionAd3Binding *binding)
{
    return binding != NULL && binding->object.slot != CPZ_NO_SLOT ? 1u : 0u;
}

const CpzObject *session_ad3_object(const SessionAd3Binding *binding)
{
    return binding == NULL ? NULL : &binding->object;
}

const CpzWorld *session_ad3_world(const SessionAd3Binding *binding)
{
    return binding == NULL ? NULL : &binding->world;
}

const char *session_ad3_failure(const SessionAd3Binding *binding)
{
    return binding == NULL ? "0xd3-binding-unbound" : binding->failure;
}
