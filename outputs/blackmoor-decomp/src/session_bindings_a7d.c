#include "session_bindings_a7d.h"

#include <stdlib.h>
#include <string.h>

struct SessionA7DBinding {
    SessionA7DHost host;
    SceneRestoreSlot *slot;
    int16_t *held_selector;
    const Action78Model *inventory;   /* borrowed: the view mode and flag are read at every visit */
    const uint8_t *view_close_flag;
    const char *failure;
    Action7dResult last;
    unsigned long visits;
};

static int a7d_scene_change(void *context, const SceneStackPop *pop)
{
    SessionA7DBinding *b = (SessionA7DBinding *)context;
    SceneTransitionRequest request;
    memset(&request, 0, sizeof(request));
    request.target_scene = (int16_t)pop->scene_5bb57b;
    request.opaque_words[0] = pop->word_5bb599;
    request.opaque_words[1] = pop->word_5bb595;
    request.opaque_words[2] = pop->word_5c39ff;
    request.opaque_dwords[0] = pop->dword_5bb59b;
    request.opaque_dwords[1] = pop->dword_5bb59f;
    request.opaque_dwords[2] = pop->dword_5bb5a3;
    return b->host.apply(b->host.context, pop, &request);
}

static int a7d_open_inventory(void *context)
{
    SessionA7DBinding *b = (SessionA7DBinding *)context;
    return b->host.open_inventory(b->host.context);
}

static int a7d_rebuild_view(void *context, int16_t item)
{
    SessionA7DBinding *b = (SessionA7DBinding *)context;
    return b->host.rebuild_view(b->host.context, item);
}

static int a7d_request_ui(void *context, int16_t index, int32_t enable, int16_t sub)
{
    SessionA7DBinding *b = (SessionA7DBinding *)context;
    return b->host.request_ui_animation(b->host.context, index, enable, sub);
}

SessionA7DBinding *session_a7d_create(const SessionA7DHost *host, SceneRestoreSlot *slot, int16_t *held_selector,
                                      const Action78Model *inventory, const uint8_t *view_close_flag)
{
    SessionA7DBinding *b;
    if (host == NULL || slot == NULL || held_selector == NULL || inventory == NULL || view_close_flag == NULL) {
        return NULL;
    }
    b = (SessionA7DBinding *)calloc(1u, sizeof(*b));
    if (b != NULL) {
        b->host = *host;
        b->slot = slot;
        b->held_selector = held_selector;
        b->inventory = inventory;
        b->view_close_flag = view_close_flag;
        b->failure = "none";
    }
    return b;
}

void session_a7d_destroy(SessionA7DBinding *b)
{
    free(b);
}

int session_a7d_handler(void *context, size_t index, const SceneActionInfo *action,
                        const SceneActionRuntimeState *before, SceneActionHandlerResult *out)
{
    SessionA7DBinding *b = (SessionA7DBinding *)context;
    Action7dHost kernel_host;
    Action7dModel model;
    Action7dResult result;
    int status;

    (void)index;
    if (b == NULL || action == NULL || before == NULL || out == NULL || action->type != SESSION_A7D_TYPE) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    if (action->typed_body_length != ACTION_FAMILY_7D_BODY_BYTES) {
        b->failure = "invalid raw-0x7d body";
        return SCENE_ACTION_HANDLER_ERROR;
    }
    model.slot = b->slot;
    model.held_selector = b->held_selector;
    model.inventory = *b->inventory;
    model.view_close_flag = b->view_close_flag;
    memset(&kernel_host, 0, sizeof(kernel_host));
    kernel_host.context = b;
    kernel_host.scene_change = b->host.apply != NULL ? a7d_scene_change : NULL;
    kernel_host.open_inventory = b->host.open_inventory != NULL ? a7d_open_inventory : NULL;
    kernel_host.inventory.inventory.context = b;
    kernel_host.inventory.inventory.rebuild_view = b->host.rebuild_view != NULL ? a7d_rebuild_view : NULL;
    kernel_host.inventory.context = b;
    kernel_host.inventory.request_ui_animation = b->host.request_ui_animation != NULL ? a7d_request_ui : NULL;
    memset(&result, 0, sizeof(result));
    b->failure = "none";
    status = action7d_visit(&model, &kernel_host, &result, &b->failure);
    if (status == ACTION7D_ERR_UNSUPPORTED) {
        return SCENE_ACTION_HANDLER_UNSUPPORTED;
    }
    if (status != ACTION7D_OK) {
        return SCENE_ACTION_HANDLER_ERROR;
    }
    b->last = result;
    ++b->visits;
    out->phase = before->phase;                                /* the phase word is not written */
    out->disposition = SCENE_ACTION_HANDLER_DIRECT_COMPLETED;  /* 0x42954f: completion byte := 1 */
    return SCENE_ACTION_HANDLER_OK;
}

const char *session_a7d_failure(const SessionA7DBinding *b)
{
    return b == NULL ? "invalid binding" : b->failure;
}

Action7dResult session_a7d_last_result(const SessionA7DBinding *b)
{
    Action7dResult zero;
    memset(&zero, 0, sizeof(zero));
    return b == NULL ? zero : b->last;
}

unsigned long session_a7d_visits(const SessionA7DBinding *b)
{
    return b == NULL ? 0ul : b->visits;
}
