#include "session_bindings_a1b.h"

#include <stdlib.h>
#include <string.h>

struct SessionA1bBinding {
    SessionA1bHost host;
    uint8_t **bodies;                 /* per row: a copy of the raw body, NULL for a row this binding does not own */
    ActionFamily1bDecoded *decoded;   /* views into the copies */
    Action17Slot *slots;
    size_t count;
    size_t current_row;               /* row of the effect stream being reported */
    const char *failure;
};

SessionA1bBinding *session_a1b_create(const SessionA1bHost *host)
{
    SessionA1bBinding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA1bBinding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
    }
    return b;
}

static void free_rows(uint8_t **bodies, size_t count)
{
    size_t i;
    if (bodies != NULL) {
        for (i = 0; i < count; ++i) {
            free(bodies[i]);
        }
    }
    free(bodies);
}

static void clear_rows(SessionA1bBinding *b)
{
    free_rows(b->bodies, b->count);
    free(b->decoded);
    free(b->slots);
    b->bodies = NULL;
    b->decoded = NULL;
    b->slots = NULL;
    b->count = 0u;
}

void session_a1b_destroy(SessionA1bBinding *b)
{
    if (b != NULL) {
        clear_rows(b);
        free(b);
    }
}

static void relay_effect(void *context, int effect, int32_t value)
{
    SessionA1bBinding *b = (SessionA1bBinding *)context;
    if (b != NULL && b->host.observe != NULL) {
        b->host.observe(b->host.context, b->current_row, effect, value);
    }
}

int session_a1b_begin_scene(SessionA1bBinding *b, const SceneResource *scene)
{
    size_t i, count;
    uint8_t **bodies = NULL;
    ActionFamily1bDecoded *decoded = NULL;
    Action17Slot *slots = NULL;
    const char *failure = "none";
    if (b == NULL || scene == NULL) {
        return ACTION17_ERR_ARGUMENT;
    }
    count = scene_resource_action_count(scene);
    bodies = (uint8_t **)calloc(count != 0u ? count : 1u, sizeof(*bodies));
    decoded = (ActionFamily1bDecoded *)calloc(count != 0u ? count : 1u, sizeof(*decoded));
    slots = (Action17Slot *)calloc(count != 0u ? count : 1u, sizeof(*slots));
    if (bodies == NULL || decoded == NULL || slots == NULL) {
        failure = "row allocation failed";
        goto fail;
    }
    for (i = 0; i < count; ++i) {
        SceneActionInfo info;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            failure = "raw-0x1b scene row unreadable";
            goto fail;
        }
        if (info.type != SESSION_A1B_TYPE) {
            continue;
        }
        if (info.raw_body == NULL || info.raw_body_length == 0u) {
            failure = "raw-0x1b row has no body";
            goto fail;
        }
        bodies[i] = (uint8_t *)malloc(info.raw_body_length);
        if (bodies[i] == NULL) {
            failure = "body allocation failed";
            goto fail;
        }
        memcpy(bodies[i], info.raw_body, info.raw_body_length);
        if (action_family_1b_decode(bodies[i], info.raw_body_length, &decoded[i]) != ACTION_FAMILY_1B_OK) {
            failure = "raw-0x1b body rejected by the A-1B.1 decoder";
            goto fail;
        }
    }
    clear_rows(b);
    b->bodies = bodies;
    b->decoded = decoded;
    b->slots = slots;
    b->count = count;
    b->failure = "none";
    return ACTION17_OK;
fail:
    b->failure = failure;
    free_rows(bodies, count);
    free(decoded);
    free(slots);
    return ACTION17_ERR_BOUNDS;
}

int session_a1b_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA1bBinding *b = (SessionA1bBinding *)context;
    Action17Host kernel_host;
    Action17Slot slot;
    Action1bWorld world;
    Action17Result result;
    if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A1B_TYPE ||
        index >= b->count || b->bodies[index] == NULL) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->failure = "none";
    if (before->phase == 2u && b->host.transition == NULL) {
        b->failure = "scene-change transition provider (raw 0x1b finish)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    memset(&world, 0, sizeof(world));
    if (b->host.load_world == NULL || b->host.load_world(b->host.context, &world) != 0) {
        b->failure = "world provider (selector 0x5bb50b, held item 0x583a29, start flag 0x5bb1ca)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    kernel_host.context = b;
    kernel_host.observe = relay_effect;
    b->current_row = index;
    slot = b->slots[index];
    if (action1b_step(&b->decoded[index], before->phase, &slot, &world, &kernel_host, &result) != ACTION17_OK) {
        b->failure = "raw 0x1b kernel refused the visit";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (result.finished) {
        /* The 0x0a arm's shape: target word, three words, three dwords (0x5bb57b, 0x5bb599/0x5bb595/0x5c39ff,
         * 0x5bb59b/9f/a3). */
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
    out->disposition = result.finished ? SCENE_ACTION_HANDLER_DIRECT_COMPLETED : SCENE_ACTION_HANDLER_PENDING;
    out->phase = result.phase_after;
    return SCENE_ACTION_HANDLER_OK;
}

void session_a1b_pre_gate(void *context, size_t index, const SceneActionInfo *action, const SceneActionRuntimeState *state)
{
    SessionA1bBinding *b = (SessionA1bBinding *)context;
    (void)action;
    (void)state;
    if (b != NULL && index < b->count && b->bodies[index] != NULL) {
        b->slots[index].request = 0;
        b->current_row = index;
        relay_effect(b, ACTION17_FX_REQUEST, 0);
    }
}

const char *session_a1b_failure(const SessionA1bBinding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

int session_a1b_pointer_row(const SessionA1bBinding *b, size_t index, SessionInputHotspot *row)
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

int session_a1b_hover_cursor(const SessionA1bBinding *b, size_t index, int16_t held_item, Action17Cursor *out)
{
    if (b == NULL || out == NULL || index >= b->count || b->bodies[index] == NULL) {
        return ACTION17_ERR_ARGUMENT;
    }
    return action1b_hover_cursor(&b->decoded[index], held_item, out);
}

int session_a1b_slot(const SessionA1bBinding *b, size_t index, Action17Slot *out)
{
    if (b == NULL || out == NULL || index >= b->count) {
        return ACTION17_ERR_ARGUMENT;
    }
    *out = b->slots[index];
    return ACTION17_OK;
}

size_t session_a1b_row_count(const SessionA1bBinding *b)
{
    return b == NULL ? 0u : b->count;
}
