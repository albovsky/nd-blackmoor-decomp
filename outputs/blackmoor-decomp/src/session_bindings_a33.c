#include "session_bindings_a33.h"

#include <stdlib.h>
#include <string.h>

struct SessionA33Binding {
    SessionA33Host host;
    A33State state;
    A33Set *sets; /* indexed by scene row; only the raw 0x33 rows have entries */
    A33Row *cells;
    uint8_t *present;
    size_t count;
    const char *failure;
};

SessionA33Binding *session_a33_create(const SessionA33Host *host)
{
    SessionA33Binding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA33Binding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        a33_state_init(&b->state);
        b->failure = "none";
    }
    return b;
}

static void free_rows(SessionA33Binding *b)
{
    for (size_t i = 0u; i < b->count; ++i) {
        if (b->present != NULL && b->present[i] != 0u) {
            a33_set_free(&b->sets[i]);
        }
    }
    free(b->sets);
    free(b->cells);
    free(b->present);
    b->sets = NULL;
    b->cells = NULL;
    b->present = NULL;
    b->count = 0u;
}

void session_a33_destroy(SessionA33Binding *b)
{
    if (b == NULL) {
        return;
    }
    free_rows(b);
    free(b);
}

int session_a33_begin_scene(SessionA33Binding *b, const SceneResource *scene)
{
    A33Set *sets = NULL;
    A33Row *cells = NULL;
    uint8_t *present = NULL;
    size_t count;
    if (b == NULL || scene == NULL) {
        return A33_ERR_ARGUMENT;
    }
    count = scene_resource_action_count(scene);
    if (count != 0u) {
        sets = (A33Set *)calloc(count, sizeof(*sets));
        cells = (A33Row *)calloc(count, sizeof(*cells));
        present = (uint8_t *)calloc(count, 1u);
        if (sets == NULL || cells == NULL || present == NULL) {
            free(sets);
            free(cells);
            free(present);
            b->failure = "0x33-row-allocation";
            return A33_ERR_BODY;
        }
    }
    for (size_t i = 0u; i < count; ++i) {
        SceneActionInfo info;
        const char *why = NULL;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            b->failure = "0x33-scene-row";
            goto bad;
        }
        if (info.type != SESSION_A33_TYPE) {
            continue;
        }
        if (a33_set_parse(info.typed_body, info.typed_body_length, &sets[i], &why) != A33_OK) {
            b->failure = why != NULL ? why : "0x33-body";
            goto bad;
        }
        present[i] = 1u;
    }
    free_rows(b);
    b->sets = sets;
    b->cells = cells;
    b->present = present;
    b->count = count;
    b->state.active_5c39f1 = 0; /* ClearSceneData 0x43e3f2 */
    b->failure = "none";
    return A33_OK;
bad:
    for (size_t i = 0u; i < count; ++i) {
        if (present != NULL && present[i] != 0u) {
            a33_set_free(&sets[i]);
        }
    }
    free(sets);
    free(cells);
    free(present);
    return A33_ERR_BODY;
}

int session_a33_handler(void *context, size_t index, const SceneActionInfo *action, const SceneActionRuntimeState *before,
                        SceneActionHandlerResult *out)
{
    SessionA33Binding *b = (SessionA33Binding *)context;
    A33StepResult result;
    const char *why = NULL;
    int status;
    if (b == NULL) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (action == NULL || before == NULL || out == NULL || action->type != SESSION_A33_TYPE || index >= b->count ||
        b->present[index] == 0u || index > 0x7fffu) {
        b->failure = "0x33-row-not-owned";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (before->phase == 0u && (b->host.media_available == NULL || b->host.media_available(b->host.kernel.context) == 0)) {
        b->failure = "secondary video media backend (reader thread, surfaces, stream) is not available";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (b->host.load_world != NULL) {
        b->host.load_world(b->host.kernel.context, &b->state);
    }
    status = a33_step(&b->state, &b->sets[index], (int16_t)index, &b->cells[index], before->phase, &b->host.kernel, &result,
                      &why);
    if (b->host.store_world != NULL) {
        b->host.store_world(b->host.kernel.context, &b->state);
    }
    b->failure = why != NULL ? why : "none";
    if (status == A33_ERR_UNSUPPORTED) {
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (status != A33_OK) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (result.finished != 0u) {
        SceneTransitionRequest request;
        memset(&request, 0, sizeof(request));
        /* The 0x0a arm's shape: target word, three words, three dwords (0x5bb57b, 0x5bb599 / 0x5bb595 / 0x5c39ff,
         * 0x5bb59b / 0x5bb59f / 0x5bb5a3). */
        request.target_scene = (int16_t)b->state.scene_5bb57b;
        request.opaque_words[0] = b->state.w_5bb599;
        request.opaque_words[1] = b->state.w_5bb595;
        request.opaque_words[2] = b->state.w_5c39ff;
        request.opaque_dwords[0] = b->state.d_5bb59b;
        request.opaque_dwords[1] = b->state.d_5bb59f;
        request.opaque_dwords[2] = b->state.d_5bb5a3;
        if (b->host.transition == NULL || b->host.transition(b->host.kernel.context, &request) != 0) {
            b->failure = "0x33: the scene-change request was refused";
            return SCENE_ACTION_HANDLER_ERROR;
        }
        out->disposition = SCENE_ACTION_HANDLER_COMPLETED; /* 0x42ba3a: completes, subtype 2 resets, phase := 0 */
        out->phase = 0u;
        return SCENE_ACTION_HANDLER_OK;
    }
    out->disposition = SCENE_ACTION_HANDLER_PENDING;
    out->phase = result.phase_after;
    return SCENE_ACTION_HANDLER_OK;
}

void session_a33_pre_gate(void *context, size_t index, const SceneActionInfo *action, const SceneActionRuntimeState *state)
{
    SessionA33Binding *b = (SessionA33Binding *)context;
    (void)action;
    (void)state;
    if (b != NULL && index < b->count && b->present[index] != 0u) {
        b->cells[index].request = 0;
    }
}

int session_a33_pointer_row(const SessionA33Binding *b, size_t index, SessionInputHotspot *out)
{
    const A33Row *cells;
    if (b == NULL || out == NULL || index >= b->count || b->present[index] == 0u) {
        return 0;
    }
    cells = &b->cells[index];
    if (cells->request == 0) {
        return 0;
    }
    memset(out, 0, sizeof(*out));
    out->index = (int32_t)index;
    out->rectangle.left = cells->rect[0];
    out->rectangle.top = cells->rect[1];
    out->rectangle.right = cells->rect[2];
    out->rectangle.bottom = cells->rect[3];
    out->active = 1u;
    return 1;
}

const A33State *session_a33_state(const SessionA33Binding *b)
{
    return b == NULL ? NULL : &b->state;
}

const A33Row *session_a33_row(const SessionA33Binding *b, size_t index)
{
    return (b == NULL || index >= b->count || b->present[index] == 0u) ? NULL : &b->cells[index];
}

size_t session_a33_row_count(const SessionA33Binding *b)
{
    return b == NULL ? 0u : b->count;
}

const char *session_a33_failure(const SessionA33Binding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}
