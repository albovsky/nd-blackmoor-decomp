#include "session_bindings_ae0.h"

#include <stdlib.h>
#include <string.h>

typedef struct Ae0Row {
    uint8_t present;
    uint8_t flag;
    size_t length;
    uint8_t body[E0_BODY_CAPACITY];
} Ae0Row;

struct SessionAe0Binding {
    SessionAe0Host host;
    E0Object object;
    E0World world;
    Ae0Row *rows;
    size_t count;
    const char *failure;
};

SessionAe0Binding *session_ae0_create(const SessionAe0Host *host)
{
    SessionAe0Binding *binding;
    if (host == NULL) return NULL;
    binding = (SessionAe0Binding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        binding->host = *host;
        e0_object_reset(&binding->object);
        binding->world.scene_cell_5bb57b = E0_NO_SCENE;
        binding->failure = "none";
    }
    return binding;
}

void session_ae0_destroy(SessionAe0Binding *binding)
{
    if (binding == NULL) return;
    (void)e0_cleanup(&binding->object, &binding->host.kernel);
    free(binding->rows);
    free(binding);
}

int session_ae0_begin_scene(SessionAe0Binding *binding, const SceneResource *scene)
{
    Ae0Row *rows;
    size_t count;
    if (binding == NULL || scene == NULL) return E0_ERR_ARGUMENT;
    count = scene_resource_action_count(scene);
    rows = count == 0u ? NULL : (Ae0Row *)calloc(count, sizeof(*rows));
    if (count != 0u && rows == NULL) {
        binding->failure = "keypad-row-allocation";
        return E0_ERR_UNSUPPORTED;
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        const char *why = NULL;
        int flag;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(rows);
            binding->failure = "keypad-scene-row";
            return E0_ERR_BODY;
        }
        if (info.type != SESSION_AE0_TYPE_D6 && info.type != SESSION_AE0_TYPE_E0) continue;
        flag = info.type == SESSION_AE0_TYPE_E0 ? 1 : 0;
        if (info.typed_body_length > E0_BODY_CAPACITY) {
            free(rows);
            binding->failure = "keypad-body-length";
            return E0_ERR_BODY;
        }
        memcpy(rows[i].body, info.typed_body, info.typed_body_length);
        rows[i].length = info.typed_body_length;
        rows[i].flag = (uint8_t)flag;
        if (e0_validate_body(flag, rows[i].body, rows[i].length, &why) != E0_OK) {
            free(rows);
            binding->failure = why;
            return E0_ERR_BODY;
        }
        rows[i].present = 1u;
    }
    /* The previous scene's clear and the round reset. */
    if (e0_cleanup(&binding->object, &binding->host.kernel) != E0_OK) {
        free(rows);
        binding->failure = "keypad-scene-clear";
        return E0_ERR_HOST;
    }
    e0_scene_reset(&binding->object);
    free(binding->rows);
    binding->rows = rows;
    binding->count = count;
    binding->failure = "none";
    return E0_OK;
}

int session_ae0_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionAe0Binding *binding = (SessionAe0Binding *)context;
    E0Result result;
    const char *why = NULL;
    Ae0Row *row;
    int status;
    if (binding == NULL) return SCENE_ACTION_HANDLER_ERROR;
    if (action == NULL || before == NULL || out == NULL ||
        (action->type != SESSION_AE0_TYPE_D6 && action->type != SESSION_AE0_TYPE_E0) || index >= binding->count ||
        binding->rows[index].present == 0u || index > (size_t)INT16_MAX) {
        binding->failure = "keypad-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    row = &binding->rows[index];
    if (before->phase == 2u && binding->host.scene_cell != NULL)
        binding->world.scene_cell_5bb57b = binding->host.scene_cell(binding->host.kernel.context);
    status = e0_step(&binding->object, row->body, row->length, row->flag, (int16_t)index, before->phase, &binding->world,
                     &binding->host.kernel, &result, &why);
    binding->failure = why != NULL ? why : "none";
    if (status == E0_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != E0_OK) return SCENE_ACTION_HANDLER_ERROR;
    if ((result.initialized != 0u || result.completed != 0u) && binding->host.store_world != NULL)
        binding->host.store_world(binding->host.kernel.context, &binding->world);
    out->phase = result.phase_after;
    out->disposition = result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

static const Ae0Row *active_row(const SessionAe0Binding *binding)
{
    const int16_t row = binding->object.row;
    if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL;
    return &binding->rows[row];
}

int session_ae0_pointer_move(SessionAe0Binding *binding, int32_t x, int32_t y, E0PointerResult *out)
{
    const Ae0Row *row;
    if (binding == NULL || out == NULL) return E0_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    if (binding->object.active == 0u) {
        binding->object.hover = -1; /* 0x470ffe stores hover := -1 and returns 0 */
        return E0_OK;
    }
    row = active_row(binding);
    if (row == NULL) return E0_ERR_ARGUMENT;
    return e0_pointer_move(&binding->object, row->body, row->length, x, y, out);
}

int session_ae0_click(SessionAe0Binding *binding, uint32_t row_phase, int32_t candidate, int32_t start_flag,
                      uint32_t *new_phase)
{
    const Ae0Row *row;
    int status;
    if (binding == NULL || new_phase == NULL) return E0_ERR_ARGUMENT;
    *new_phase = row_phase;
    if (binding->object.active == 0u) return E0_OK;
    row = active_row(binding);
    if (row == NULL) return E0_ERR_ARGUMENT;
    status = e0_click(&binding->object, row->body, row->length, row_phase, candidate, start_flag, &binding->host.kernel,
                      new_phase);
    binding->failure = status == E0_OK ? "none" : "keypad-click";
    return status;
}

int session_ae0_invalidate(SessionAe0Binding *binding)
{
    if (binding == NULL) return E0_ERR_ARGUMENT;
    return e0_invalidate(&binding->object, &binding->host.kernel);
}

int session_ae0_render_plan(SessionAe0Binding *binding, E0RenderPlan *plan)
{
    const Ae0Row *row;
    if (binding == NULL || plan == NULL) return E0_ERR_ARGUMENT;
    if (binding->object.tiles_visible == 0u || binding->object.slot == E0_NO_SLOT) { /* nothing registered or drawn */
        memset(plan, 0, sizeof(*plan));
        return E0_OK;
    }
    row = active_row(binding);
    if (row == NULL) {
        memset(plan, 0, sizeof(*plan));
        return E0_ERR_ARGUMENT;
    }
    return e0_render_plan(&binding->object, row->body, row->length, &binding->host.kernel, plan);
}

unsigned session_ae0_registered(const SessionAe0Binding *binding)
{
    return binding != NULL && binding->object.slot != E0_NO_SLOT ? 1u : 0u;
}

const E0Object *session_ae0_state(const SessionAe0Binding *binding)
{
    return binding == NULL ? NULL : &binding->object;
}

const char *session_ae0_failure(const SessionAe0Binding *binding)
{
    return binding == NULL ? "keypad-binding-unbound" : binding->failure;
}
