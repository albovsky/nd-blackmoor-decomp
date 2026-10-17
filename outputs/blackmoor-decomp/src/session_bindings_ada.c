#include "session_bindings_ada.h"

#include <stdlib.h>
#include <string.h>

typedef struct AdaRow {
    uint8_t present;
    uint8_t body[BUL_BODY_BYTES];
} AdaRow;

struct SessionAdaBinding {
    SessionAdaHost host;
    BulObject object;
    BulWorld world;
    AdaRow *rows;
    size_t count;
    const char *failure;
};

SessionAdaBinding *session_ada_create(const SessionAdaHost *host)
{
    SessionAdaBinding *binding;
    if (host == NULL) return NULL;
    binding = (SessionAdaBinding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        binding->host = *host;
        bul_object_reset(&binding->object);
        binding->failure = "none";
    }
    return binding;
}

void session_ada_destroy(SessionAdaBinding *binding)
{
    if (binding == NULL) return;
    (void)bul_cleanup(&binding->object, &binding->host.kernel);
    free(binding->rows);
    free(binding);
}

int session_ada_begin_scene(SessionAdaBinding *binding, const SceneResource *scene)
{
    AdaRow *rows;
    size_t count;
    if (binding == NULL || scene == NULL) return BUL_ERR_ARGUMENT;
    count = scene_resource_action_count(scene);
    rows = count == 0u ? NULL : (AdaRow *)calloc(count, sizeof(*rows));
    if (count != 0u && rows == NULL) {
        binding->failure = "0xda-row-allocation";
        return BUL_ERR_BOUNDS;
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        const char *why = NULL;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(rows);
            binding->failure = "0xda-scene-row";
            return BUL_ERR_BODY;
        }
        if (info.type != SESSION_ADA_TYPE) continue;
        if (i > (size_t)INT16_MAX) {
            free(rows);
            binding->failure = "0xda-row-index";
            return BUL_ERR_BOUNDS;
        }
        if (bul_validate_body(info.typed_body, info.typed_body_length, &why) != BUL_OK) {
            free(rows);
            binding->failure = why;
            return BUL_ERR_BODY;
        }
        memcpy(rows[i].body, info.typed_body, BUL_BODY_BYTES);
        rows[i].present = 1u;
    }
    /* The previous scene's clear (0x438bfd / 0x43ded9 -> 0x45b42e + 0x45b3ea). The world cell is not touched. */
    if (bul_cleanup(&binding->object, &binding->host.kernel) != BUL_OK) {
        free(rows);
        binding->failure = "0xda-scene-clear";
        return BUL_ERR_HOST;
    }
    free(binding->rows);
    binding->rows = rows;
    binding->count = count;
    binding->failure = "none";
    return BUL_OK;
}

int session_ada_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionAdaBinding *binding = (SessionAdaBinding *)context;
    BulResult result;
    const char *why = NULL;
    int status;
    if (binding == NULL) return SCENE_ACTION_HANDLER_ERROR;
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_ADA_TYPE || index >= binding->count ||
        binding->rows[index].present == 0u) {
        binding->failure = "0xda-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    status = bul_step(&binding->object, binding->rows[index].body, BUL_BODY_BYTES, (int16_t)index, before->phase,
                      &binding->world, &binding->host.kernel, &result, &why);
    binding->failure = why != NULL ? why : "none";
    if (status == BUL_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != BUL_OK) return SCENE_ACTION_HANDLER_ERROR;
    if ((result.initialized != 0u || result.completed != 0u) && binding->host.store_world != NULL)
        binding->host.store_world(binding->host.kernel.context, &binding->world);
    out->phase = result.phase_after;
    out->disposition = result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

/* The body of the object's row, NULL when the object has no row of this binding. */
static const uint8_t *active_body(const SessionAdaBinding *binding)
{
    const int16_t row = binding->object.row;
    if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL;
    return binding->rows[row].body;
}

int session_ada_pointer_move(SessionAdaBinding *binding, int32_t x, int32_t y, BulPointerResult *out)
{
    const uint8_t *body;
    if (binding == NULL || out == NULL) return BUL_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    out->button = -1;
    if (binding->object.active == 0) return BUL_OK; /* 0x45b5bb returns 0 at once: no row owns the object */
    body = active_body(binding);
    if (body == NULL) return BUL_ERR_ARGUMENT;
    return bul_pointer(&binding->object, body, BUL_BODY_BYTES, x, y, out);
}

int session_ada_click(SessionAdaBinding *binding, uint32_t row_phase, int32_t candidate, BulClickResult *out)
{
    const uint8_t *body;
    int status;
    if (binding == NULL || out == NULL) return BUL_ERR_ARGUMENT;
    out->handled = 0;
    out->new_phase = row_phase;
    if (binding->object.active == 0) return BUL_OK; /* 0x45b872 does nothing while inactive */
    body = active_body(binding);
    if (body == NULL) return BUL_ERR_ARGUMENT;
    status = bul_click(&binding->object, body, BUL_BODY_BYTES, &binding->world, &binding->host.kernel, row_phase, candidate,
                       out);
    binding->failure = status == BUL_OK ? "none" : "0xda-click";
    return status;
}

int session_ada_invalidate(SessionAdaBinding *binding)
{
    if (binding == NULL) return BUL_ERR_ARGUMENT;
    return bul_invalidate(&binding->object, &binding->host.kernel);
}

int session_ada_render(SessionAdaBinding *binding, BulRenderResult *out)
{
    const uint8_t *body;
    int status;
    if (binding == NULL || out == NULL) return BUL_ERR_ARGUMENT;
    memset(out, 0, offsetof(BulRenderResult, blit));
    if (binding->object.slot == BUL_NO_SLOT) return BUL_OK; /* no render entry: 0x45d2c6 is never called */
    body = active_body(binding);
    if (body == NULL) return BUL_ERR_ARGUMENT;
    status = bul_render(&binding->object, body, BUL_BODY_BYTES, &binding->host.kernel, out);
    binding->failure = status == BUL_OK ? "none" : "0xda-render";
    return status;
}

unsigned session_ada_registered(const SessionAdaBinding *binding)
{
    return binding != NULL && binding->object.slot != BUL_NO_SLOT ? 1u : 0u;
}

const BulObject *session_ada_object(const SessionAdaBinding *binding)
{
    return binding == NULL ? NULL : &binding->object;
}

const BulWorld *session_ada_world(const SessionAdaBinding *binding)
{
    return binding == NULL ? NULL : &binding->world;
}

const char *session_ada_failure(const SessionAdaBinding *binding)
{
    return binding == NULL ? "0xda-binding-unbound" : binding->failure;
}
