#include "session_bindings_a83.h"

#include <stdlib.h>
#include <string.h>

typedef struct A83Row {
    uint8_t present;
    uint8_t body[74];
} A83Row;
struct SessionA83Binding {
    SessionA83Host host;
    A83Row *rows;
    size_t count;
    const char *failure;
    A83Result last;
    int has_last;
};

SessionA83Binding *session_a83_create(const SessionA83Host *host)
{
    SessionA83Binding *binding;
    if (host == NULL) return NULL;
    binding = (SessionA83Binding *)calloc(1u, sizeof(*binding));
    if (binding != NULL) {
        binding->host = *host;
        binding->failure = "none";
    }
    return binding;
}

void session_a83_destroy(SessionA83Binding *binding)
{
    if (binding == NULL) return;
    free(binding->rows);
    free(binding);
}

int session_a83_begin_scene(SessionA83Binding *binding, const SceneResource *scene)
{
    A83Row *rows;
    size_t count;
    if (binding == NULL || scene == NULL) return A83_ERR_ARGUMENT;
    count = scene_resource_action_count(scene);
    rows = count == 0u ? NULL : (A83Row *)calloc(count, sizeof(*rows));
    if (count != 0u && rows == NULL) {
        binding->failure = "0x83-row-allocation";
        return A83_ERR_HOST;
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            free(rows);
            binding->failure = "0x83-scene-row";
            return A83_ERR_BODY;
        }
        if (info.type != SESSION_A83_TYPE) continue;
        if (info.typed_body == NULL || info.typed_body_length != 74u) {
            free(rows);
            binding->failure = "0x83-loader-body";
            return A83_ERR_BODY;
        }
        /* 0x40ea25/27: once per scene, not reconstructed from a per-tick
         * action argument. No field interpretation occurs at load time. */
        memcpy(rows[i].body, info.typed_body, 74u);
        rows[i].present = 1u;
    }
    free(binding->rows);
    binding->rows = rows;
    binding->count = count;
    binding->failure = "none";
    return A83_OK;
}

int session_a83_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out)
{
    SessionA83Binding *binding = (SessionA83Binding *)context;
    A83Input input;
    A83Result result;
    const char *why = NULL;
    int status;
    if (binding == NULL) return SCENE_ACTION_HANDLER_ERROR;
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_A83_TYPE ||
        index >= binding->count || binding->rows[index].present == 0u) {
        binding->failure = "0x83-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    input.phase = before->phase;
    input.subtype = action->subtype;
    input.completed = before->completed;
    input.eligible = 1u; /* original 0x423f57(deps,0), evaluated by executor. */
    status = action83_runtime_step(binding->rows[index].body, 74u, &input,
        binding->host.world, &binding->host.backend, &result, &why);
    binding->failure = why != NULL ? why : "none";
    if (status == A83_ERR_UNSUPPORTED) return SCENE_ACTION_HANDLER_UNSUPPORTED;
    if (status != A83_OK) return SCENE_ACTION_HANDLER_ERROR;
    if (result.applied != 0u) {
        binding->last = result;
        binding->has_last = 1;
    }
    out->phase = result.phase;
    out->disposition = result.applied != 0u ? SCENE_ACTION_HANDLER_DIRECT_COMPLETED
                                          : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a83_failure(const SessionA83Binding *binding)
{
    return binding == NULL ? "0x83-binding-unbound" : binding->failure;
}

const A83Result *session_a83_last_result(const SessionA83Binding *binding)
{
    return binding == NULL || binding->has_last == 0 ? NULL : &binding->last;
}
