#include "session_bindings_a17.h"

#include <stdlib.h>
#include <string.h>

struct SessionA17Binding {
    SessionA17Host host;
    uint8_t **bodies;     /* typed body per action row; NULL for other rows */
    size_t *lengths;
    uint8_t *types;
    Action17Slot *slots;
    size_t count;
    size_t current_row;   /* row of the effect stream being reported */
    const char *failure;
};

SessionA17Binding *session_a17_create(const SessionA17Host *host)
{
    SessionA17Binding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA17Binding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
    }
    return b;
}

static void clear_rows(SessionA17Binding *b)
{
    size_t i;
    for (i = 0; i < b->count; ++i) {
        free(b->bodies[i]);
    }
    free(b->bodies);
    free(b->lengths);
    free(b->types);
    free(b->slots);
    b->bodies = NULL;
    b->lengths = NULL;
    b->types = NULL;
    b->slots = NULL;
    b->count = 0u;
}

void session_a17_destroy(SessionA17Binding *b)
{
    if (b != NULL) {
        clear_rows(b);
        free(b);
    }
}

static void relay_effect(void *context, int effect, int32_t value)
{
    SessionA17Binding *b = (SessionA17Binding *)context;
    if (b != NULL && b->host.observe != NULL) {
        b->host.observe(b->host.context, b->current_row, effect, value);
    }
}

static int owns_type(uint8_t type)
{
    return type == SESSION_A17_TYPE || type == SESSION_A16_TYPE;
}

int session_a17_begin_scene(SessionA17Binding *b, const SceneResource *scene)
{
    size_t i, count;
    uint8_t **bodies = NULL;
    size_t *lengths = NULL;
    uint8_t *types = NULL;
    Action17Slot *slots = NULL;
    if (b == NULL || scene == NULL) {
        return ACTION17_ERR_ARGUMENT;
    }
    count = scene_resource_action_count(scene);
    bodies = (uint8_t **)calloc(count != 0u ? count : 1u, sizeof(*bodies));
    lengths = (size_t *)calloc(count != 0u ? count : 1u, sizeof(*lengths));
    types = (uint8_t *)calloc(count != 0u ? count : 1u, sizeof(*types));
    slots = (Action17Slot *)calloc(count != 0u ? count : 1u, sizeof(*slots));
    if (bodies == NULL || lengths == NULL || types == NULL || slots == NULL) {
        b->failure = "row allocation failed";
        goto fail;
    }
    for (i = 0; i < count; ++i) {
        SceneActionInfo info;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            b->failure = "raw-0x17 scene row unreadable";
            goto fail;
        }
        if (!owns_type(info.type)) {
            continue;
        }
        if (info.typed_body == NULL ||
            action17_validate_body(info.typed_body, info.typed_body_length, &b->failure) !=
                ACTION17_OK) {
            if (info.typed_body == NULL) {
                b->failure = "raw-0x16/0x17 row has no typed body";
            }
            goto fail;
        }
        bodies[i] = (uint8_t *)malloc(info.typed_body_length);
        if (bodies[i] == NULL) {
            b->failure = "body allocation failed";
            goto fail;
        }
        memcpy(bodies[i], info.typed_body, info.typed_body_length);
        lengths[i] = info.typed_body_length;
        types[i] = info.type;
    }
    clear_rows(b);
    b->bodies = bodies;
    b->lengths = lengths;
    b->types = types;
    b->slots = slots;
    b->count = count;
    b->failure = "none";
    return ACTION17_OK;
fail:
    if (bodies != NULL) {
        for (i = 0; i < count; ++i) {
            free(bodies[i]);
        }
    }
    free(bodies);
    free(lengths);
    free(types);
    free(slots);
    return ACTION17_ERR_BOUNDS;
}

static int load_world(SessionA17Binding *b, Action17World *world)
{
    memset(world, 0, sizeof(*world));
    if (b->host.load_world == NULL || b->host.load_world(b->host.context, world) != 0) {
        b->failure = "world provider (selector 0x5bb50b, start flag 0x5bb1ca)";
        return -1;
    }
    return 0;
}

int session_a17_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA17Binding *b = (SessionA17Binding *)context;
    Action17Host kernel_host;
    Action17Slot slot;
    Action17World world;
    Action17Result result;
    int status;
    if (b == NULL || action == NULL || before == NULL || out == NULL || !owns_type(action->type) ||
        index >= b->count || b->bodies[index] == NULL || b->types[index] != action->type) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->failure = "none";
    if (before->phase == 2u && b->host.transition == NULL) {
        b->failure = "scene-change transition provider (raw 0x17 finish)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (load_world(b, &world) != 0) {
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    kernel_host.context = b;
    kernel_host.observe = relay_effect;
    b->current_row = index;
    slot = b->slots[index];
    status = action17_step(b->bodies[index], b->lengths[index], before->phase, &slot, &world,
                           &kernel_host, &result, &b->failure);
    if (status != ACTION17_OK) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (result.finished) {
        /* The 0x0a arm's shape: target word, three words, three dwords
         * (0x5bb57b, 0x5bb599/0x5bb595/0x5c39ff, 0x5bb59b/9f/a3). */
        SceneTransitionRequest request;
        memset(&request, 0, sizeof(request));
        request.target_scene = (int16_t)world.xfer_5bb57b;
        request.opaque_words[0] = world.xfer_5bb599;
        request.opaque_words[1] = world.xfer_5bb595;
        request.opaque_words[2] = world.xfer_5c39ff;
        request.opaque_dwords[0] = world.xfer_5bb59b;
        request.opaque_dwords[1] = world.xfer_5bb59f;
        request.opaque_dwords[2] = world.xfer_5bb5a3;
        if (b->host.transition(b->host.context, &request) != 0) {
            b->failure = "scene-change request was refused";
            return SCENE_ACTION_HANDLER_ERROR;
        }
    }
    b->slots[index] = slot;
    if (b->host.store_world != NULL) {
        b->host.store_world(b->host.context, &world);
    }
    out->disposition = result.finished ? SCENE_ACTION_HANDLER_DIRECT_COMPLETED
                                       : SCENE_ACTION_HANDLER_PENDING;
    out->phase = result.phase_after;
    return SCENE_ACTION_HANDLER_OK;
}

void session_a17_pre_gate(void *context, size_t index, const SceneActionInfo *action,
                          const SceneActionRuntimeState *state)
{
    SessionA17Binding *b = (SessionA17Binding *)context;
    (void)action;
    (void)state;
    if (b != NULL && index < b->count && b->bodies[index] != NULL) {
        b->slots[index].request = 0;
        b->current_row = index;
        relay_effect(b, ACTION17_FX_REQUEST, 0);
    }
}

const char *session_a17_failure(const SessionA17Binding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

int session_a17_pointer_row(const SessionA17Binding *b, size_t index, SessionInputHotspot *row)
{
    const Action17Slot *slot;
    if (b == NULL || row == NULL || index >= b->count || b->bodies[index] == NULL) {
        return 0;
    }
    slot = &b->slots[index];
    if (slot->request == 0) {
        return 0;
    }
    memset(row, 0, sizeof(*row));
    row->index = (int32_t)index;
    row->rectangle.left = slot->left;
    row->rectangle.top = slot->top;
    row->rectangle.right = slot->right;
    row->rectangle.bottom = slot->bottom;
    row->active = 1u;
    return 1;
}

int session_a17_hover_cursor(const SessionA17Binding *b, size_t index, int16_t held_item,
                             Action17Cursor *out)
{
    if (b == NULL || out == NULL || index >= b->count || b->bodies[index] == NULL) {
        return ACTION17_ERR_ARGUMENT;
    }
    return action17_hover_cursor(b->types[index], held_item, out);
}

int session_a17_slot(const SessionA17Binding *b, size_t index, Action17Slot *out)
{
    if (b == NULL || out == NULL || index >= b->count) {
        return ACTION17_ERR_ARGUMENT;
    }
    *out = b->slots[index];
    return ACTION17_OK;
}

size_t session_a17_row_count(const SessionA17Binding *b)
{
    return b == NULL ? 0u : b->count;
}
