#include "session_bindings_aeb.h"

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

typedef struct AebRow {
    uint8_t present;
    uint8_t body[EB_BODY_BYTES];
} AebRow;

struct SessionAebBinding {
    SessionAebHost host;
    EbObject object;
    EbWorld world;
    AebRow *rows;
    size_t count;
    const char *failure;
};

SessionAebBinding *session_aeb_create(const SessionAebHost *host)
{
    SessionAebBinding *binding;
    if (host == NULL) return NULL;
    binding = (SessionAebBinding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        binding->host = *host;
        eb_object_reset(&binding->object);
        eb_world_reset(&binding->world); /* power-on 0x4384f8 */
        binding->failure = "none";
    }
    return binding;
}

void session_aeb_destroy(SessionAebBinding *binding)
{
    if (binding == NULL) return;
    (void)eb_cleanup(&binding->object, &binding->host.kernel);
    free(binding->rows);
    free(binding);
}

void session_aeb_world_reset(SessionAebBinding *binding)
{
    if (binding != NULL) eb_world_reset(&binding->world);
}

int session_aeb_begin_scene(SessionAebBinding *binding, const SceneResource *scene)
{
    AebRow *rows;
    size_t count;
    if (binding == NULL || scene == NULL) return EB_ERR_ARGUMENT;
    count = scene_resource_action_count(scene);
    rows = count == 0u ? NULL : (AebRow *)calloc(count, sizeof(*rows));
    if (count != 0u && rows == NULL) {
        binding->failure = "0xeb-row-allocation";
        return EB_ERR_MEMORY;
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        const char *why = NULL;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(rows);
            binding->failure = "0xeb-scene-row";
            return EB_ERR_BODY;
        }
        if (info.type != SESSION_AEB_TYPE) continue;
        if (eb_validate_body(info.typed_body, info.typed_body_length, &why) != EB_OK) {
            free(rows);
            binding->failure = why != NULL ? why : "0xeb-body";
            return EB_ERR_BODY;
        }
        memcpy(rows[i].body, info.typed_body, EB_BODY_BYTES);
        rows[i].present = 1u;
    }
    /* The previous scene's clear (0x438c48 -> 0x47e2a5). The saved puzzle state stays. */
    if (eb_cleanup(&binding->object, &binding->host.kernel) != EB_OK) {
        free(rows);
        binding->failure = "0xeb-scene-clear";
        return EB_ERR_HOST;
    }
    free(binding->rows);
    binding->rows = rows;
    binding->count = count;
    binding->failure = "none";
    return EB_OK;
}

/* The running scene 0x5bb57b as the app holds it (the finish block's store reaches the engine through the scene change). */
static void sync_scene(SessionAebBinding *binding)
{
    if (binding->host.scene_cell != NULL) binding->world.scene_5bb57b = binding->host.scene_cell(binding->host.kernel.context);
}

int session_aeb_handler(void *context, size_t index, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out)
{
    SessionAebBinding *binding = (SessionAebBinding *)context;
    EbResult result;
    const char *why = NULL;
    int status;
    if (binding == NULL) return SCENE_ACTION_HANDLER_ERROR;
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_AEB_TYPE || index >= binding->count ||
        binding->rows[index].present == 0u || index > (size_t)INT16_MAX) {
        binding->failure = "0xeb-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    sync_scene(binding);
    status = eb_step(&binding->object, binding->rows[index].body, EB_BODY_BYTES, (int16_t)index, before->phase,
                     &binding->world, &binding->host.kernel, &result, &why);
    binding->failure = why != NULL ? why : "none";
    if (status == EB_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != EB_OK) return SCENE_ACTION_HANDLER_ERROR;
    if ((result.initialized != 0u || result.completed != 0u) && binding->host.store_world != NULL)
        binding->host.store_world(binding->host.kernel.context, &binding->world);
    out->phase = result.phase_after;
    out->disposition = result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

static const uint8_t *active_body(const SessionAebBinding *binding)
{
    const int16_t row = eb_object_row(&binding->object);
    if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL;
    return binding->rows[row].body;
}

int session_aeb_pointer_move(SessionAebBinding *binding, int16_t x, int16_t y, const int32_t rect[4], EbPointerResult *out)
{
    const uint8_t *body;
    int status;
    if (binding == NULL || out == NULL) return EB_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    if (!eb_object_active(&binding->object)) return EB_OK; /* 0x47f421 returns 0 without touching anything */
    body = active_body(binding);
    if (body == NULL) return EB_ERR_ARGUMENT;
    status = eb_pointer_move(&binding->object, body, EB_BODY_BYTES, x, y, rect, &binding->host.kernel, out);
    binding->failure = status == EB_OK ? "none" : "0xeb-pointer";
    return status;
}

int session_aeb_click(SessionAebBinding *binding, uint32_t row_phase, int32_t candidate, uint32_t *new_phase)
{
    const uint8_t *body;
    int status;
    if (binding == NULL || new_phase == NULL) return EB_ERR_ARGUMENT;
    *new_phase = row_phase;
    if (!eb_object_active(&binding->object)) return EB_OK;
    body = active_body(binding);
    if (body == NULL) return EB_ERR_ARGUMENT;
    sync_scene(binding);
    status = eb_click(&binding->object, body, EB_BODY_BYTES, &binding->world, row_phase, candidate, &binding->host.kernel,
                      new_phase);
    binding->failure = status == EB_OK ? "none" : "0xeb-click";
    return status;
}

int session_aeb_rotate_key(SessionAebBinding *binding, uint32_t row_phase)
{
    const uint8_t *body;
    int status;
    if (binding == NULL) return EB_ERR_ARGUMENT;
    if (!eb_object_active(&binding->object)) return EB_OK;
    body = active_body(binding);
    if (body == NULL) return EB_ERR_ARGUMENT;
    status = eb_rotate_key(&binding->object, body, EB_BODY_BYTES, row_phase, &binding->host.kernel);
    binding->failure = status == EB_OK ? "none" : "0xeb-rotate";
    return status;
}

int session_aeb_invalidate(SessionAebBinding *binding)
{
    if (binding == NULL) return EB_ERR_ARGUMENT;
    return eb_invalidate(&binding->object, &binding->host.kernel);
}

int session_aeb_render_plan(SessionAebBinding *binding, EbRenderPlan *plan)
{
    const uint8_t *body;
    int status;
    if (binding == NULL || plan == NULL) return EB_ERR_ARGUMENT;
    if (eb_object_slot(&binding->object) == EB_NO_SLOT) { /* no render entry: 0x481cb9 is never called */
        memset(plan, 0, sizeof(*plan));
        return EB_OK;
    }
    body = active_body(binding);
    if (body == NULL) {
        memset(plan, 0, sizeof(*plan));
        return EB_ERR_ARGUMENT;
    }
    status = eb_render_plan(&binding->object, body, EB_BODY_BYTES, &binding->host.kernel, plan);
    binding->failure = status == EB_OK ? "none" : "0xeb-render";
    return status;
}

unsigned session_aeb_registered(const SessionAebBinding *binding)
{
    return binding != NULL && eb_object_slot(&binding->object) != EB_NO_SLOT ? 1u : 0u;
}

const EbObject *session_aeb_object(const SessionAebBinding *binding)
{
    return binding == NULL ? NULL : &binding->object;
}

const EbWorld *session_aeb_world(const SessionAebBinding *binding)
{
    return binding == NULL ? NULL : &binding->world;
}

const char *session_aeb_failure(const SessionAebBinding *binding)
{
    return binding == NULL ? "0xeb-binding-unbound" : binding->failure;
}
