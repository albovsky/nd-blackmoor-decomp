#include "session_bindings_aee.h"

#include <stdint.h>
#include <stdlib.h>
#include <string.h>

typedef struct AeeRow {
    uint8_t present;
    uint8_t body[MP_BODY_BYTES];
} AeeRow;

struct SessionAeeBinding {
    SessionAeeHost host;
    MpObject object;
    AeeRow *rows;
    size_t count;
    const char *failure;
};

/* The opaque guest value of a row's pData pointer that the kernel stores in the object (obj+0xc). */
static uint32_t body_handle(size_t index)
{
    return (uint32_t)index + 1u;
}

static int host_complete(const MpHost *h)
{
    return h->view != NULL && h->set_start_flag != NULL && h->clear_pending_item != NULL && h->recenter_cursor != NULL &&
           h->alloc_slot != NULL && h->register_slot != NULL && h->set_slot_surface != NULL && h->release_slot != NULL &&
           h->mark_dirty != NULL && h->load_surface != NULL && h->release_surface != NULL && h->random != NULL &&
           h->tick != NULL && h->sound_prepare != NULL && h->sound_play != NULL && h->sound_busy != NULL &&
           h->captions_enabled != NULL && h->autotext_lookup != NULL && h->caption_show != NULL &&
           h->event_flag_invalid != NULL && h->transition != NULL && h->store_event_flag != NULL && h->complete != NULL;
}

SessionAeeBinding *session_aee_create(const SessionAeeHost *host)
{
    SessionAeeBinding *binding;
    if (host == NULL || !host_complete(&host->kernel)) return NULL;
    binding = (SessionAeeBinding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        binding->host = *host;
        mp_object_reset(&binding->object);
        binding->failure = "none";
    }
    return binding;
}

int session_aee_cleanup(SessionAeeBinding *binding)
{
    if (binding == NULL) return MP_ERR_ARGUMENT;
    return mp_cleanup(&binding->object, &binding->host.kernel);
}

void session_aee_destroy(SessionAeeBinding *binding)
{
    if (binding == NULL) return;
    (void)session_aee_cleanup(binding);
    free(binding->rows);
    free(binding);
}

int session_aee_begin_scene(SessionAeeBinding *binding, const SceneResource *scene)
{
    AeeRow *rows;
    size_t count;
    if (binding == NULL || scene == NULL) return MP_ERR_ARGUMENT;
    count = scene_resource_action_count(scene);
    rows = count == 0u ? NULL : (AeeRow *)calloc(count, sizeof(*rows));
    if (count != 0u && rows == NULL) {
        binding->failure = "0xee-row-allocation";
        return MP_ERR_HOST;
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        const char *why = NULL;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(rows);
            binding->failure = "0xee-scene-row";
            return MP_ERR_BODY;
        }
        if (info.type != SESSION_AEE_TYPE) continue;
        if (mp_validate_body(info.typed_body, info.typed_body_length, &why) != MP_OK) {
            free(rows);
            binding->failure = why != NULL ? why : "0xee-body";
            return MP_ERR_BODY;
        }
        memcpy(rows[i].body, info.typed_body, MP_BODY_BYTES);
        rows[i].present = 1u;
    }
    /* The previous scene's clear (0x43df8d -> 0x47b321). */
    if (session_aee_cleanup(binding) != MP_OK) {
        free(rows);
        binding->failure = "0xee-scene-clear";
        return MP_ERR_HOST;
    }
    free(binding->rows);
    binding->rows = rows;
    binding->count = count;
    binding->failure = "none";
    return MP_OK;
}

int session_aee_handler(void *context, size_t index, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out)
{
    SessionAeeBinding *binding = (SessionAeeBinding *)context;
    MpResult result;
    const char *why = NULL;
    int status;
    if (binding == NULL) return SCENE_ACTION_HANDLER_ERROR;
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_AEE_TYPE || index >= binding->count ||
        binding->rows[index].present == 0u || index > (size_t)INT16_MAX) {
        binding->failure = "0xee-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    status = mp_step(&binding->object, binding->rows[index].body, MP_BODY_BYTES, body_handle(index), (int16_t)index, before->phase,
                     &binding->host.kernel, &result, &why);
    binding->failure = why != NULL ? why : "none";
    if (status == MP_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != MP_OK) return SCENE_ACTION_HANDLER_ERROR;
    out->phase = result.phase_after;
    out->disposition = result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

/* The body of the object's row, NULL when the object has no row of this binding. */
static const uint8_t *active_body(const SessionAeeBinding *binding)
{
    const int16_t row = mp_object_row(&binding->object);
    if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL;
    return binding->rows[row].body;
}

int session_aee_pointer_move(SessionAeeBinding *binding, int16_t x, int16_t y, MpPointerResult *out)
{
    const uint8_t *body;
    int status;
    if (binding == NULL || out == NULL) return MP_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    if (!mp_object_active(&binding->object)) return MP_OK; /* 0x47b4aa returns 0 without touching anything */
    body = active_body(binding);
    if (body == NULL) return MP_ERR_ARGUMENT;
    status = mp_pointer(&binding->object, body, MP_BODY_BYTES, x, y, out);
    binding->failure = status == MP_OK ? "none" : "0xee-pointer";
    return status;
}

int session_aee_click(SessionAeeBinding *binding, uint32_t row_phase, int32_t candidate)
{
    const uint8_t *body;
    int status;
    if (binding == NULL) return MP_ERR_ARGUMENT;
    if (!mp_object_active(&binding->object)) return MP_OK;
    body = active_body(binding);
    if (body == NULL) return MP_ERR_ARGUMENT;
    status = mp_click(&binding->object, body, MP_BODY_BYTES, body_handle((size_t)mp_object_row(&binding->object)), row_phase,
                      candidate, &binding->host.kernel);
    binding->failure = status == MP_OK ? "none" : "0xee-click";
    return status;
}

int session_aee_invalidate(SessionAeeBinding *binding)
{
    if (binding == NULL) return MP_ERR_ARGUMENT;
    return mp_invalidate(&binding->object, &binding->host.kernel);
}

int session_aee_render_plan(SessionAeeBinding *binding, MpRenderPlan *plan)
{
    const uint8_t *body;
    int status;
    if (binding == NULL || plan == NULL) return MP_ERR_ARGUMENT;
    if (mp_object_slot(&binding->object) == MP_NO_SLOT) { /* no render entry: 0x47d24e is never called */
        memset(plan, 0, sizeof(*plan));
        return MP_OK;
    }
    body = active_body(binding);
    if (body == NULL) {
        memset(plan, 0, sizeof(*plan));
        return MP_ERR_ARGUMENT;
    }
    status = mp_render_plan(&binding->object, body, MP_BODY_BYTES, &binding->host.kernel, plan);
    binding->failure = status == MP_OK ? "none" : "0xee-render";
    return status;
}

unsigned session_aee_registered(const SessionAeeBinding *binding)
{
    return binding != NULL && mp_object_slot(&binding->object) != MP_NO_SLOT ? 1u : 0u;
}

const MpObject *session_aee_object(const SessionAeeBinding *binding)
{
    return binding == NULL ? NULL : &binding->object;
}

const char *session_aee_failure(const SessionAeeBinding *binding)
{
    return binding == NULL ? "0xee-binding-unbound" : binding->failure;
}
