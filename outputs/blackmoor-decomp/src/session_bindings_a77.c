#include "session_bindings_a77.h"

#include <stdlib.h>
#include <string.h>

typedef struct A77Row {
    uint8_t present;
    uint8_t body[A77_BODY_BYTES];
} A77Row;

struct SessionA77Binding {
    SessionA77Host host;
    A77State state;
    A77World world;
    A77Row *rows;
    size_t count;
    const char *failure;
};

SessionA77Binding *session_a77_create(const SessionA77Host *host)
{
    SessionA77Binding *binding;
    if (host == NULL) return NULL;
    binding = (SessionA77Binding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        binding->host = *host;
        a77_state_reset(&binding->state);
        binding->failure = "none";
    }
    return binding;
}

void session_a77_destroy(SessionA77Binding *binding)
{
    if (binding == NULL) return;
    (void)a77_clear(&binding->state, &binding->host.kernel);
    free(binding->rows);
    free(binding);
}

int session_a77_begin_scene(SessionA77Binding *binding, const SceneResource *scene)
{
    A77Row *rows;
    size_t count;
    if (binding == NULL || scene == NULL) return A77_ERR_ARGUMENT;
    count = scene_resource_action_count(scene);
    rows = count == 0u ? NULL : (A77Row *)calloc(count, sizeof(*rows));
    if (count != 0u && rows == NULL) {
        binding->failure = "0x77-row-allocation";
        return A77_ERR_UNSUPPORTED;
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        const char *why = NULL;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(rows);
            binding->failure = "0x77-scene-row";
            return A77_ERR_BODY;
        }
        if (info.type != SESSION_A77_TYPE) continue;
        if (a77_validate_body(info.typed_body, info.typed_body_length, &why) != A77_OK) {
            free(rows);
            binding->failure = why;
            return A77_ERR_BODY;
        }
        memcpy(rows[i].body, info.typed_body, A77_BODY_BYTES);
        rows[i].present = 1u;
    }
    /* The previous scene's clear. */
    if (a77_clear(&binding->state, &binding->host.kernel) != A77_OK) {
        free(rows);
        binding->failure = "0x77-scene-clear";
        return A77_ERR_HOST;
    }
    free(binding->rows);
    binding->rows = rows;
    binding->count = count;
    binding->failure = "none";
    return A77_OK;
}

int session_a77_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA77Binding *binding = (SessionA77Binding *)context;
    A77Result result;
    const char *why = NULL;
    int status;
    if (binding == NULL) return SCENE_ACTION_HANDLER_ERROR;
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_A77_TYPE ||
        index >= binding->count || binding->rows[index].present == 0u || index > (size_t)INT16_MAX) {
        binding->failure = "0x77-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    status = a77_step(&binding->state, binding->rows[index].body, A77_BODY_BYTES, (int16_t)index, before->phase,
                      &binding->world, &binding->host.kernel, &result, &why);
    binding->failure = why != NULL ? why : "none";
    if (status == A77_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != A77_OK) return SCENE_ACTION_HANDLER_ERROR;
    if ((result.initialized != 0u || result.completed != 0u) && binding->host.store_world != NULL)
        binding->host.store_world(binding->host.kernel.context, &binding->world);
    out->phase = result.phase_after;
    out->disposition = result.completed != 0u ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

static const uint8_t *active_body(const SessionA77Binding *binding)
{
    const int16_t row = binding->state.row;
    if (row < 0 || (size_t)row >= binding->count || binding->rows[row].present == 0u) return NULL;
    return binding->rows[row].body;
}

int session_a77_pointer_move(SessionA77Binding *binding, int32_t x, int32_t y, A77PointerResult *out)
{
    const uint8_t *body;
    if (binding == NULL || out == NULL) return A77_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    out->hover = -1;
    if (binding->state.active == 0u) return A77_OK; /* 0x4f0290 jumps to 0x4f04b6 */
    body = active_body(binding);
    if (body == NULL) return A77_ERR_ARGUMENT;
    return a77_pointer(&binding->state, body, A77_BODY_BYTES, x, y, out);
}

int session_a77_click(SessionA77Binding *binding, uint32_t row_phase, int32_t candidate, int32_t start_flag,
                      uint32_t *new_phase)
{
    const uint8_t *body;
    A77ClickResult result;
    int status;
    if (binding == NULL || new_phase == NULL) return A77_ERR_ARGUMENT;
    *new_phase = row_phase;
    if (binding->state.active == 0u) return A77_OK;
    body = active_body(binding);
    if (body == NULL) return A77_ERR_ARGUMENT;
    status = a77_click(&binding->state, body, A77_BODY_BYTES, row_phase, candidate, start_flag, &binding->host.kernel,
                       &result);
    binding->failure = status == A77_OK ? "none" : "0x77-click";
    if (status == A77_OK) *new_phase = result.new_phase;
    return status;
}

int session_a77_render_plan(SessionA77Binding *binding, A77RenderPlan *plan)
{
    const uint8_t *body;
    if (binding == NULL || plan == NULL) return A77_ERR_ARGUMENT;
    if (binding->state.overlay_active == 0u) { /* the generic entry is not drawn */
        memset(plan, 0, sizeof(*plan));
        return A77_OK;
    }
    body = active_body(binding);
    if (body == NULL) {
        memset(plan, 0, sizeof(*plan));
        return A77_ERR_ARGUMENT;
    }
    return a77_render_plan(&binding->state, body, A77_BODY_BYTES, &binding->host.kernel, plan);
}

unsigned session_a77_registered(const SessionA77Binding *binding)
{
    return binding != NULL && binding->state.overlay_active != 0u ? 1u : 0u;
}

const A77State *session_a77_state(const SessionA77Binding *binding)
{
    return binding == NULL ? NULL : &binding->state;
}

const char *session_a77_failure(const SessionA77Binding *binding)
{
    return binding == NULL ? "0x77-binding-unbound" : binding->failure;
}
