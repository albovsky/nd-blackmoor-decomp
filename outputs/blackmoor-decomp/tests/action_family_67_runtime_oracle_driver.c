/* RT-30 native side of the raw 0x67 oracle (tests/action_family_67_runtime_original_oracle.py).
 *
 * One handle owns the start flag (DAT_005bb1ca, as the host stores it) and the real session binding. a67o_visit()
 * performs what the executor does for a true gate: it calls the binding handler and derives the row's completion byte,
 * the dependency reset request and the phase from the returned disposition with the executor's own helper
 * (action_core_finish_action, scene_executor.c apply_external_handler). */
#include <stdlib.h>
#include <string.h>

#include "action_core.h"
#include "session_bindings_a67.h"

typedef struct {
    int32_t flag;
    unsigned long sets;
    SessionA67Binding *binding;
} Handle;

static void set_flag(void *context, int32_t value)
{
    Handle *h = (Handle *)context;
    h->flag = value;
    ++h->sets;
}

Handle *a67o_new(void)
{
    SessionA67Host host;
    Handle *h = calloc(1u, sizeof(*h));
    if (h == NULL) return NULL;
    memset(&host, 0, sizeof host);
    host.context = h;
    host.set_start_flag = set_flag;
    h->binding = session_a67_create(&host);
    if (h->binding == NULL) {
        free(h);
        return NULL;
    }
    return h;
}

void a67o_free(Handle *h)
{
    if (h != NULL) {
        session_a67_destroy(h->binding);
        free(h);
    }
}

void a67o_set_flag(Handle *h, int32_t value) { h->flag = value; }
int32_t a67o_get_flag(const Handle *h) { return h->flag; }
unsigned long a67o_sets(const Handle *h) { return h->sets; }
unsigned long a67o_visits(const Handle *h) { return session_a67_visits(h->binding); }

/* Returns the handler status (SCENE_ACTION_HANDLER_*) or 100 + the executor-side failure. */
int a67o_visit(Handle *h, int subtype, int body_byte, int completed_before, uint32_t phase_before, int *completed_after, int *reset,
               uint32_t *phase_after, int *disposition)
{
    uint8_t body[1];
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    ActionCoreActionResult finish;
    int status;
    body[0] = (uint8_t)body_byte;
    memset(&info, 0, sizeof(info));
    info.type = ACTION_FAMILY_67_RAW_TYPE;
    info.subtype = (uint8_t)subtype;
    info.typed_body = body;
    info.typed_body_length = 1u;
    before.completed = (uint8_t)completed_before;
    before.phase = phase_before;
    out.disposition = SCENE_ACTION_HANDLER_PENDING;
    out.phase = phase_before;
    *completed_after = completed_before;
    *reset = 0;
    *phase_after = phase_before;
    status = session_a67_handler(h->binding, 0u, &info, &before, &out);
    *disposition = (int)out.disposition;
    if (status != SCENE_ACTION_HANDLER_OK) return status;
    /* scene_executor.c apply_external_handler */
    switch (out.disposition) {
    case SCENE_ACTION_HANDLER_PENDING:
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_COMPLETED:
        if (action_core_finish_action((uint8_t)subtype, (uint8_t)completed_before, &finish) != ACTION_CORE_OK)
            return 101;
        *completed_after = finish.completed;
        *reset = finish.reset_dependencies;
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_DIRECT_COMPLETED:
        *completed_after = 1;
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_RESET_DEPENDENCIES:
        *phase_after = 0u;
        *reset = 1;
        break;
    default:
        return 102;
    }
    return 0;
}
