#include "session_bindings_a0c.h"

#include <stdlib.h>
#include <string.h>

struct SessionA0cBinding {
    SessionA0cHost host;
    uint8_t **bodies;     /* typed body per action row; NULL for other rows */
    size_t *lengths;
    Action17Slot *slots;
    size_t count;
    size_t current_row;   /* row of the effect stream being reported */
    const char *failure;
};

SessionA0cBinding *session_a0c_create(const SessionA0cHost *host)
{
    SessionA0cBinding *b;
    if (host == NULL) {
        return NULL;
    }
    b = (SessionA0cBinding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->failure = "none";
    }
    return b;
}

static void free_rows(uint8_t **bodies, size_t *lengths, Action17Slot *slots, size_t count)
{
    size_t i;
    if (bodies != NULL) {
        for (i = 0; i < count; ++i) {
            free(bodies[i]);
        }
    }
    free(bodies);
    free(lengths);
    free(slots);
}

static void clear_rows(SessionA0cBinding *b)
{
    free_rows(b->bodies, b->lengths, b->slots, b->count);
    b->bodies = NULL;
    b->lengths = NULL;
    b->slots = NULL;
    b->count = 0u;
}

void session_a0c_destroy(SessionA0cBinding *b)
{
    if (b != NULL) {
        clear_rows(b);
        free(b);
    }
}

static void relay_effect(void *context, int effect, int32_t value)
{
    SessionA0cBinding *b = (SessionA0cBinding *)context;
    if (b != NULL && b->host.observe != NULL) {
        b->host.observe(b->host.context, b->current_row, effect, value);
    }
}

int session_a0c_begin_scene(SessionA0cBinding *b, const SceneResource *scene)
{
    size_t i, count;
    uint8_t **bodies = NULL;
    size_t *lengths = NULL;
    Action17Slot *slots = NULL;
    const char *failure = "none";
    if (b == NULL || scene == NULL) {
        return ACTION17_ERR_ARGUMENT;
    }
    count = scene_resource_action_count(scene);
    bodies = (uint8_t **)calloc(count != 0u ? count : 1u, sizeof(*bodies));
    lengths = (size_t *)calloc(count != 0u ? count : 1u, sizeof(*lengths));
    slots = (Action17Slot *)calloc(count != 0u ? count : 1u, sizeof(*slots));
    if (bodies == NULL || lengths == NULL || slots == NULL) {
        failure = "row allocation failed";
        goto fail;
    }
    for (i = 0; i < count; ++i) {
        SceneActionInfo info;
        if (scene_resource_action_at(scene, i, &info) != SCENE_RESOURCE_OK) {
            failure = "raw-0x0c scene row unreadable";
            goto fail;
        }
        if (info.type != SESSION_A0C_TYPE) {
            continue;
        }
        if (info.typed_body == NULL) {
            failure = "raw-0x0c row has no typed body";
            goto fail;
        }
        if (action0c_validate_body(info.typed_body, info.typed_body_length, &failure) != ACTION17_OK) {
            goto fail;
        }
        bodies[i] = (uint8_t *)malloc(info.typed_body_length);
        if (bodies[i] == NULL) {
            failure = "body allocation failed";
            goto fail;
        }
        memcpy(bodies[i], info.typed_body, info.typed_body_length);
        lengths[i] = info.typed_body_length;
    }
    clear_rows(b);
    b->bodies = bodies;
    b->lengths = lengths;
    b->slots = slots;
    b->count = count;
    b->failure = "none";
    return ACTION17_OK;
fail:
    b->failure = failure;
    free_rows(bodies, lengths, slots, count);
    return ACTION17_ERR_BOUNDS;
}

static int load_world(SessionA0cBinding *b, Action17World *world)
{
    memset(world, 0, sizeof(*world));
    if (b->host.load_world == NULL || b->host.load_world(b->host.context, world) != 0) {
        b->failure = "world provider (selector 0x5bb50b, start flag 0x5bb1ca)";
        return -1;
    }
    return 0;
}

int session_a0c_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA0cBinding *b = (SessionA0cBinding *)context;
    Action17Host kernel_host;
    Action17Slot slot;
    Action17World world;
    Action17Result result;
    if (b == NULL || action == NULL || before == NULL || out == NULL ||
        action->type != SESSION_A0C_TYPE || index >= b->count || b->bodies[index] == NULL) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->failure = "none";
    if (before->phase == 2u && b->host.transition == NULL) {
        b->failure = "scene-change transition provider (raw 0x0c finish)";
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (load_world(b, &world) != 0) {
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    kernel_host.context = b;
    kernel_host.observe = relay_effect;
    b->current_row = index;
    slot = b->slots[index];
    if (action0c_step(b->bodies[index], b->lengths[index], before->phase, &slot, &world,
                      &kernel_host, &result, &b->failure) != ACTION17_OK) {
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

void session_a0c_pre_gate(void *context, size_t index, const SceneActionInfo *action,
                          const SceneActionRuntimeState *state)
{
    SessionA0cBinding *b = (SessionA0cBinding *)context;
    (void)action;
    (void)state;
    if (b != NULL && index < b->count && b->bodies[index] != NULL) {
        b->slots[index].request = 0;
        b->current_row = index;
        relay_effect(b, ACTION17_FX_REQUEST, 0);
    }
}

const char *session_a0c_failure(const SessionA0cBinding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

int session_a0c_pointer_row(const SessionA0cBinding *b, size_t index, SessionInputHotspot *row)
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

int session_a0c_hover_cursor(const SessionA0cBinding *b, size_t index, int16_t held_item,
                             Action17Cursor *out)
{
    if (b == NULL || out == NULL || index >= b->count || b->bodies[index] == NULL) {
        return ACTION17_ERR_ARGUMENT;
    }
    return action0c_hover_cursor(b->bodies[index], b->lengths[index], held_item, out);
}

int session_a0c_slot(const SessionA0cBinding *b, size_t index, Action17Slot *out)
{
    if (b == NULL || out == NULL || index >= b->count) {
        return ACTION17_ERR_ARGUMENT;
    }
    *out = b->slots[index];
    return ACTION17_OK;
}

size_t session_a0c_row_count(const SessionA0cBinding *b)
{
    return b == NULL ? 0u : b->count;
}

static int16_t le_s16(const uint8_t *p)
{
    const uint16_t bits = (uint16_t)((uint16_t)p[0] | ((uint16_t)p[1] << 8));
    return bits <= (uint16_t)INT16_MAX ? (int16_t)bits : (int16_t)(-1 - (int32_t)(UINT16_MAX - bits));
}

int session_a0c_row_info(const SessionA0cBinding *b, size_t index, SessionA0cRowInfo *out)
{
    const uint8_t *body;
    if (b == NULL || out == NULL || index >= b->count || b->bodies[index] == NULL) {
        return ACTION17_ERR_ARGUMENT;
    }
    body = b->bodies[index];
    out->cursor_word = le_s16(body);
    out->target = le_s16(body + 2);
    out->entry_word = le_s16(body + 4);
    out->word_06 = le_s16(body + 6);
    out->count = le_s16(body + 8);
    return ACTION17_OK;
}

const uint8_t *session_a0c_body(const SessionA0cBinding *b, size_t index, size_t *length)
{
    if (b == NULL || index >= b->count || b->bodies[index] == NULL) {
        return NULL;
    }
    if (length != NULL) {
        *length = b->lengths[index];
    }
    return b->bodies[index];
}
