/* RT-28 native side of the raw 0x6e oracle (tests/action_family_6e_runtime_original_oracle.py).
 *
 * One handle owns the saved-scene slot, the running scene's words and the real session binding. a6eo_visit() performs
 * what the executor does for a true gate: it calls the binding handler and derives the row's completion byte, the
 * dependency reset request and the phase from the returned disposition with the executor's own helper
 * (action_core_finish_action, scene_executor.c apply_external_handler). The slot crosses the boundary as the 22 bytes
 * at 0x5c3a05..0x5c3a1a in the original's memory order. */
#include <stdlib.h>
#include <string.h>

#include "action_core.h"
#include "session_bindings_a6e.h"

typedef struct {
    SceneStackSlot slot;
    SceneStackCurrent current;
    int host_fail;
    SessionA6EBinding *binding;
} Handle;

static int load_current(void *context, SceneStackCurrent *out)
{
    Handle *h = (Handle *)context;
    if (h->host_fail) return 1;
    *out = h->current;
    return 0;
}

Handle *a6eo_new(void)
{
    SessionA6EHost host;
    Handle *h = calloc(1u, sizeof(*h));
    if (h == NULL) return NULL;
    memset(&host, 0, sizeof host);
    host.context = h;
    host.load_current = load_current;
    h->binding = session_a6e_create(&host, &h->slot);
    if (h->binding == NULL) {
        free(h);
        return NULL;
    }
    return h;
}

void a6eo_free(Handle *h)
{
    if (h != NULL) {
        session_a6e_destroy(h->binding);
        free(h);
    }
}

void a6eo_set_current(Handle *h, int32_t s57b, int32_t s57f, int w50b, int w593, int32_t d5a7, int32_t d5ab, int32_t d5af)
{
    h->current.scene_5bb57b = s57b;
    h->current.scene_5bb57f = s57f;
    h->current.word_5bb50b = (int16_t)w50b;
    h->current.word_5bb593 = (int16_t)w593;
    h->current.dword_5bb5a7 = d5a7;
    h->current.dword_5bb5ab = d5ab;
    h->current.dword_5bb5af = d5af;
}

void a6eo_set_host_fail(Handle *h, int fail) { h->host_fail = fail; }

/* The slot as the 22 bytes of the original: five words, then three dwords. */
void a6eo_get_slot(const Handle *h, uint8_t out[22])
{
    const SceneStackSlot *s = &h->slot;
    memcpy(out + 0, &s->scene_5c3a05, 2);
    memcpy(out + 2, &s->scene_5c3a07, 2);
    memcpy(out + 4, &s->word_5c3a09, 2);
    memcpy(out + 6, &s->word_5c3a0b, 2);
    memcpy(out + 8, &s->word_5c3a0d, 2);
    memcpy(out + 10, &s->dword_5c3a0f, 4);
    memcpy(out + 14, &s->dword_5c3a13, 4);
    memcpy(out + 18, &s->dword_5c3a17, 4);
}

void a6eo_set_slot(Handle *h, const uint8_t in[22])
{
    SceneStackSlot *s = &h->slot;
    memcpy(&s->scene_5c3a05, in + 0, 2);
    memcpy(&s->scene_5c3a07, in + 2, 2);
    memcpy(&s->word_5c3a09, in + 4, 2);
    memcpy(&s->word_5c3a0b, in + 6, 2);
    memcpy(&s->word_5c3a0d, in + 8, 2);
    memcpy(&s->dword_5c3a0f, in + 10, 4);
    memcpy(&s->dword_5c3a13, in + 14, 4);
    memcpy(&s->dword_5c3a17, in + 18, 4);
}

void a6eo_push_direct(Handle *h, int32_t argument) { scene_stack_push(&h->slot, &h->current, argument); }
void a6eo_init_words(Handle *h) { scene_stack_slot_init_words(&h->slot); }
unsigned long a6eo_pushes(const Handle *h) { return session_a6e_pushes(h->binding); }

/* Returns the handler status (SCENE_ACTION_HANDLER_*) or 100 + the executor-side failure. */
int a6eo_visit(Handle *h, int subtype, int completed_before, uint32_t phase_before, int *completed_after, int *reset,
               uint32_t *phase_after, int *disposition)
{
    static const uint8_t body[1] = {0u};
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    ActionCoreActionResult finish;
    int status;
    memset(&info, 0, sizeof(info));
    info.type = ACTION_FAMILY_6E_RAW_TYPE;
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
    status = session_a6e_handler(h->binding, 0u, &info, &before, &out);
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
