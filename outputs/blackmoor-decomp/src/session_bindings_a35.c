#include "session_bindings_a35.h"

#include <stdlib.h>
#include <string.h>

struct SessionA35Binding {
    A35World *world;
    SessionA35Host host;
    A35Runtime **rows;
    size_t count;
    const char *failure;
};

SessionA35Binding *session_a35_create(A35World *world, const SessionA35Host *host)
{
    SessionA35Binding *b;
    if (world == NULL || host == NULL || host->input == NULL ||
        host->load_world == NULL || host->store_world == NULL) return NULL;
    b = (SessionA35Binding *)calloc(1, sizeof(*b));
    if (b != NULL) { b->world = world; b->host = *host; b->failure = "none"; }
    return b;
}

static void clear_rows(SessionA35Binding *b)
{
    size_t i;
    for (i = 0; i < b->count; ++i) action35_runtime_destroy(b->rows[i]);
    free(b->rows);
    b->rows = NULL;
    b->count = 0;
}

void session_a35_destroy(SessionA35Binding *b)
{
    if (b == NULL) return;
    clear_rows(b);
    free(b);
}

int session_a35_begin_scene(SessionA35Binding *b, const SceneResource *scene)
{
    size_t i, count;
    if (b == NULL || scene == NULL) return A35_RUNTIME_ARGUMENT;
    clear_rows(b);
    count = scene_resource_action_count(scene);
    if (count > SCENE_EXECUTOR_MAX_ACTIONS) return A35_RUNTIME_ARGUMENT;
    b->rows = (A35Runtime **)calloc(count != 0 ? count : 1, sizeof(*b->rows));
    if (b->rows == NULL) return A35_RUNTIME_HOST;
    b->count = count;
    for (i = 0; i < count; ++i) {
        SceneActionInfo a;
        if (scene_resource_action_at(scene, i, &a) != SCENE_RESOURCE_OK) return A35_RUNTIME_ARGUMENT;
        if (a.type == SESSION_A35_TYPE) {
            b->rows[i] = action35_runtime_create(b->world, &b->host.movie);
            if (b->rows[i] == NULL) return A35_RUNTIME_HOST;
        }
    }
    b->failure = "none";
    return A35_RUNTIME_OK;
}

int session_a35_handler(void *context, size_t row, const SceneActionInfo *a,
                         const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA35Binding *b = (SessionA35Binding *)context;
    A35Input input;
    A35Result result;
    int status;
    if (b == NULL || a == NULL || before == NULL || out == NULL ||
        a->type != SESSION_A35_TYPE || row >= b->count || b->rows[row] == NULL)
        return SCENE_ACTION_HANDLER_ERROR;
    b->failure = "none";
    memset(&input, 0, sizeof(input));
    if (before->phase == 1u && b->host.input(b->host.movie.context, &input) != 0) {
        b->failure = "selector/viewport origin unavailable";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    /* A finish with a scene request must have a provider before event stores. */
    if (before->phase == 2u && a->typed_body_length >= 0x27u &&
        a->typed_body[0x25] == 5 && a->typed_body[0x26] == 0 && b->host.transition == NULL) {
        b->failure = "movie scene-transition provider";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    b->host.load_world(b->host.movie.context, b->world);
    status = action35_runtime_step(b->rows[row], a->typed_body, a->typed_body_length,
                                    before->phase, &input, &result);
    if (status != A35_RUNTIME_OK) {
        b->failure = action35_runtime_failure(b->rows[row]);
        /* A terminal host failure can follow committed frame effects. */
        if (status == A35_RUNTIME_HOST) b->host.store_world(b->host.movie.context, b->world);
        return status == A35_RUNTIME_UNSUPPORTED ? SCENE_ACTION_HANDLER_UNSUPPORTED
                                                : SCENE_ACTION_HANDLER_ERROR;
    }
    b->host.store_world(b->host.movie.context, b->world);
    if (result.transition && b->host.transition(b->host.movie.context, &result) != 0) {
        b->failure = "movie scene transition rejected";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    out->phase = result.phase;
    out->disposition = result.finish ? SCENE_ACTION_HANDLER_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a35_failure(const SessionA35Binding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

int session_a35_worker_poll(SessionA35Binding *b, size_t row)
{
    if (b == NULL || row >= b->count || b->rows[row] == NULL) return A35_RUNTIME_ARGUMENT;
    return action35_runtime_worker_poll(b->rows[row]);
}

int session_a35_render_ack(SessionA35Binding *b, size_t row, uint32_t generation, int *blitted)
{
    if (b == NULL || row >= b->count || b->rows[row] == NULL) return A35_RUNTIME_ARGUMENT;
    return action35_runtime_render_ack(b->rows[row], generation, blitted);
}
