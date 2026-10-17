#include "session_bindings_aaa.h"

#include <stdlib.h>
#include <string.h>

typedef struct AaaRow {
    uint8_t present;
    uint8_t body[ALC_BODY_BYTES];
} AaaRow;

struct SessionAaaBinding {
    SessionAaaHost host;
    AlcObject object;
    AlcWorld world;
    AaaRow *rows;
    size_t count;
    const char *failure;
};

SessionAaaBinding *session_aaa_create(const SessionAaaHost *host)
{
    SessionAaaBinding *binding;
    if (host == NULL) return NULL;
    binding = (SessionAaaBinding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        binding->host = *host;
        alc_object_reset(&binding->object);
        binding->failure = "none";
    }
    return binding;
}

void session_aaa_destroy(SessionAaaBinding *binding)
{
    if (binding == NULL) return;
    (void)alc_cleanup(&binding->object, &binding->host.kernel);
    free(binding->rows);
    free(binding);
}

int session_aaa_begin_scene(SessionAaaBinding *binding, const SceneResource *scene)
{
    AaaRow *rows;
    size_t count;
    if (binding == NULL || scene == NULL) return ALC_ERR_ARGUMENT;
    count = scene_resource_action_count(scene);
    rows = count == 0u ? NULL : (AaaRow *)calloc(count, sizeof(*rows));
    if (count != 0u && rows == NULL) {
        binding->failure = "0xaa-row-allocation";
        return ALC_ERR_BOUNDS;
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        const char *why = NULL;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(rows);
            binding->failure = "0xaa-scene-row";
            return ALC_ERR_BODY;
        }
        if (info.type != SESSION_AAA_TYPE) continue;
        if (alc_validate_body(info.typed_body, info.typed_body_length, &why) != ALC_OK) {
            free(rows);
            binding->failure = why;
            return ALC_ERR_BODY;
        }
        memcpy(rows[i].body, info.typed_body, ALC_BODY_BYTES);
        rows[i].present = 1u;
    }
    /* The previous scene's clear (0x438cac / 0x43dfb5 -> 0x44d154). */
    if (alc_cleanup(&binding->object, &binding->host.kernel) != ALC_OK) {
        free(rows);
        binding->failure = "0xaa-scene-clear";
        return ALC_ERR_HOST;
    }
    free(binding->rows);
    binding->rows = rows;
    binding->count = count;
    binding->failure = "none";
    return ALC_OK;
}

static void load_world(SessionAaaBinding *binding)
{
    if (binding->host.load_world != NULL) binding->host.load_world(binding->host.kernel.context, &binding->world);
}

int session_aaa_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionAaaBinding *binding = (SessionAaaBinding *)context;
    AlcResult result;
    const char *why = NULL;
    int status;
    if (binding == NULL) return SCENE_ACTION_HANDLER_ERROR;
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_AAA_TYPE ||
        index >= binding->count || binding->rows[index].present == 0u) {
        binding->failure = "0xaa-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    load_world(binding);
    status = alc_step(&binding->object, binding->rows[index].body, ALC_BODY_BYTES, (int16_t)index, before->phase,
                      &binding->world, &binding->host.kernel, &result, &why);
    binding->failure = why != NULL ? why : "none";
    if (status == ALC_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != ALC_OK) return SCENE_ACTION_HANDLER_ERROR;
    if ((result.initialized != 0u || result.completed != 0u) && binding->host.store_world != NULL)
        binding->host.store_world(binding->host.kernel.context, &binding->world);
    out->phase = result.phase_after;
    out->disposition = result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

/* The live (mutable) body of the object's row, NULL when the object has no row of this binding. */
static uint8_t *active_body(SessionAaaBinding *binding)
{
    const int16_t row = binding->object.row;
    if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL;
    return binding->rows[row].body;
}

int session_aaa_pointer_move(SessionAaaBinding *binding, int32_t x, int32_t y, AlcPointerResult *out)
{
    const uint8_t *body;
    if (binding == NULL || out == NULL) return ALC_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    if (binding->object.active == 0) return ALC_OK; /* 0x44d28c clears the redraw request and returns 0 */
    body = active_body(binding);
    if (body == NULL) return ALC_ERR_ARGUMENT;
    return alc_pointer(&binding->object, body, ALC_BODY_BYTES, x, y, out);
}

int session_aaa_click(SessionAaaBinding *binding, uint32_t row_phase, AlcClickResult *out)
{
    AlcClickResult local;
    const uint8_t *body;
    int status;
    if (binding == NULL) return ALC_ERR_ARGUMENT;
    if (out == NULL) out = &local;
    memset(out, 0, sizeof(*out));
    if (binding->object.active == 0) return ALC_OK;
    body = active_body(binding);
    if (body == NULL) return ALC_ERR_ARGUMENT;
    load_world(binding);
    status = alc_click(&binding->object, body, ALC_BODY_BYTES, row_phase, &binding->world, &binding->host.kernel, out);
    binding->failure = status == ALC_OK ? "none" : "0xaa-click";
    return status;
}

int session_aaa_invalidate(SessionAaaBinding *binding)
{
    if (binding == NULL) return ALC_ERR_ARGUMENT;
    return alc_invalidate(&binding->object, &binding->host.kernel);
}

int session_aaa_render(SessionAaaBinding *binding, AlcRenderResult *out)
{
    const uint8_t *body;
    if (binding == NULL || out == NULL) return ALC_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    if (binding->object.slot == ALC_NO_SLOT) return ALC_OK; /* no render entry: 0x44e035 is never called */
    body = active_body(binding);
    if (body == NULL) return ALC_ERR_ARGUMENT;
    return alc_render(&binding->object, body, ALC_BODY_BYTES, &binding->host.kernel, out);
}

unsigned session_aaa_registered(const SessionAaaBinding *binding)
{
    return binding != NULL && binding->object.slot != ALC_NO_SLOT ? 1u : 0u;
}

const AlcObject *session_aaa_object(const SessionAaaBinding *binding)
{
    return binding == NULL ? NULL : &binding->object;
}

const char *session_aaa_failure(const SessionAaaBinding *binding)
{
    return binding == NULL ? "0xaa-binding-unbound" : binding->failure;
}
