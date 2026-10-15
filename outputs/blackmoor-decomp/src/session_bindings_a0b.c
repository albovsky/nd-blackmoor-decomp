#include "session_bindings_a0b.h"

#include <stdlib.h>
#include <string.h>

struct SessionA0bBinding {
    SessionA0bHost host;
    Action0bPayload *payloads;  /* per action row */
    uint8_t *owned;             /* 1 for a raw 0x0b row */
    Action17Slot *slots;
    size_t count;
    size_t current_row;         /* row of the effect stream being reported */
    const char *failure;
};

SessionA0bBinding *session_a0b_create(const SessionA0bHost *host)
{
    SessionA0bBinding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA0bBinding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
    }
    return b;
}

static void clear_rows(SessionA0bBinding *b)
{
    free(b->payloads);
    free(b->owned);
    free(b->slots);
    b->payloads = NULL;
    b->owned = NULL;
    b->slots = NULL;
    b->count = 0u;
}

void session_a0b_destroy(SessionA0bBinding *b)
{
    if (b != NULL) {
        clear_rows(b);
        free(b);
    }
}

static void relay_effect(void *context, int effect, int32_t value)
{
    SessionA0bBinding *b = (SessionA0bBinding *)context;
    if (b != NULL && b->host.observe != NULL) {
        b->host.observe(b->host.context, b->current_row, effect, value);
    }
}

int session_a0b_begin_scene(SessionA0bBinding *b, const SceneResource *scene)
{
    size_t i, count;
    Action0bPayload *payloads = NULL;
    uint8_t *owned = NULL;
    Action17Slot *slots = NULL;
    const char *failure = "none";
    if (b == NULL || scene == NULL) {
        return ACTION17_ERR_ARGUMENT;
    }
    count = scene_resource_action_count(scene);
    payloads = (Action0bPayload *)calloc(count != 0u ? count : 1u, sizeof(*payloads));
    owned = (uint8_t *)calloc(count != 0u ? count : 1u, sizeof(*owned));
    slots = (Action17Slot *)calloc(count != 0u ? count : 1u, sizeof(*slots));
    if (payloads == NULL || owned == NULL || slots == NULL) {
        failure = "row allocation failed";
        goto fail;
    }
    for (i = 0; i < count; ++i) {
        SceneActionInfo info;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            failure = "raw-0x0b scene row unreadable";
            goto fail;
        }
        if (info.type != SESSION_A0B_TYPE) {
            continue;
        }
        if (info.typed_body == NULL) {
            failure = "raw-0x0b row has no typed body";
            goto fail;
        }
        if (action0b_load(info.typed_body, info.typed_body_length, &payloads[i], &failure) !=
            ACTION17_OK) {
            goto fail;
        }
        owned[i] = 1u;
    }
    clear_rows(b);
    b->payloads = payloads;
    b->owned = owned;
    b->slots = slots;
    b->count = count;
    b->failure = "none";
    return ACTION17_OK;
fail:
    b->failure = failure;
    free(payloads);
    free(owned);
    free(slots);
    return ACTION17_ERR_BOUNDS;
}

static int load_world(SessionA0bBinding *b, Action17World *world)
{
    memset(world, 0, sizeof(*world));
    if (b->host.load_world == NULL || b->host.load_world(b->host.context, world) != 0) {
        b->failure = "world provider (selector 0x5bb50b, start flag 0x5bb1ca)";
        return -1;
    }
    return 0;
}

int session_a0b_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA0bBinding *b = (SessionA0bBinding *)context;
    Action17Host kernel_host;
    Action17Slot slot;
    Action17World world;
    Action17Result result;
    if (b == NULL || action == NULL || before == NULL || out == NULL ||
        action->type != SESSION_A0B_TYPE || index >= b->count || b->owned[index] == 0u) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->failure = "none";
    if (before->phase == 2u && b->host.transition == NULL) {
        b->failure = "scene-change transition provider (raw 0x0b finish)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (load_world(b, &world) != 0) {
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    kernel_host.context = b;
    kernel_host.observe = relay_effect;
    b->current_row = index;
    slot = b->slots[index];
    if (action0b_step(&b->payloads[index], before->phase, &slot, &world, &kernel_host,
                      &result) != ACTION17_OK) {
        b->failure = "raw 0x0b kernel refused the visit";
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

void session_a0b_pre_gate(void *context, size_t index, const SceneActionInfo *action,
                          const SceneActionRuntimeState *state)
{
    SessionA0bBinding *b = (SessionA0bBinding *)context;
    (void)action;
    (void)state;
    if (b != NULL && index < b->count && b->owned[index] != 0u) {
        b->slots[index].request = 0;
        b->current_row = index;
        relay_effect(b, ACTION17_FX_REQUEST, 0);
    }
}

const char *session_a0b_failure(const SessionA0bBinding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

int session_a0b_pointer_row(const SessionA0bBinding *b, size_t index, SessionInputHotspot *row)
{
    const Action17Slot *slot;
    if (b == NULL || row == NULL || index >= b->count || b->owned[index] == 0u) {
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

int session_a0b_hover_cursor(const SessionA0bBinding *b, size_t index, int16_t held_item,
                             Action17Cursor *out)
{
    if (b == NULL || out == NULL || index >= b->count || b->owned[index] == 0u) {
        return ACTION17_ERR_ARGUMENT;
    }
    return action0b_hover_cursor(&b->payloads[index], held_item, out);
}

int session_a0b_slot(const SessionA0bBinding *b, size_t index, Action17Slot *out)
{
    if (b == NULL || out == NULL || index >= b->count) {
        return ACTION17_ERR_ARGUMENT;
    }
    *out = b->slots[index];
    return ACTION17_OK;
}

int session_a0b_payload(const SessionA0bBinding *b, size_t index, Action0bPayload *out)
{
    if (b == NULL || out == NULL || index >= b->count || b->owned[index] == 0u) {
        return ACTION17_ERR_ARGUMENT;
    }
    *out = b->payloads[index];
    return ACTION17_OK;
}

size_t session_a0b_row_count(const SessionA0bBinding *b)
{
    return b == NULL ? 0u : b->count;
}
