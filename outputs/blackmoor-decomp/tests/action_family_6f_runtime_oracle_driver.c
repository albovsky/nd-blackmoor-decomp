/* RT-29 native side of the raw 0x6f oracle (tests/action_family_6f_runtime_original_oracle.py).
 *
 * One handle owns the saved-scene slot, the running scene's words (for 0x6e rows) and the two real session bindings
 * (0x6e push and 0x6f pop). a6fo_visit() performs what the executor does for a true gate: it calls the binding handler of
 * the row's type and derives the row's completion byte, the dependency reset request and the phase from the returned
 * disposition with the executor's own helper (action_core_finish_action, scene_executor.c apply_external_handler). The
 * host callback of the pop records the pop result and the scene-change request it was handed. The slot crosses the
 * boundary as the 22 bytes at 0x5c3a05..0x5c3a1a in the original's memory order. */
#include <stdlib.h>
#include <string.h>

#include "action_core.h"
#include "session_bindings_a6e.h"
#include "session_bindings_a6f.h"

typedef struct {
    SceneStackSlot slot;
    SceneStackCurrent current;
    int host_refuse;
    int applies;
    SceneStackPop last_pop;
    SceneTransitionRequest last_request;
    SessionA6EBinding *push;
    SessionA6FBinding *pop;
} Handle;

static int load_current(void *context, SceneStackCurrent *out)
{
    *out = ((Handle *)context)->current;
    return 0;
}

static int apply(void *context, const SceneStackPop *pop, const SceneTransitionRequest *request)
{
    Handle *h = (Handle *)context;
    ++h->applies;
    h->last_pop = *pop;
    h->last_request = *request;
    return h->host_refuse;
}

Handle *a6fo_new(void)
{
    SessionA6EHost push_host;
    SessionA6FHost pop_host;
    Handle *h = calloc(1u, sizeof(*h));
    if (h == NULL) return NULL;
    memset(&push_host, 0, sizeof push_host);
    push_host.context = h;
    push_host.load_current = load_current;
    memset(&pop_host, 0, sizeof pop_host);
    pop_host.context = h;
    pop_host.apply = apply;
    h->push = session_a6e_create(&push_host, &h->slot);
    h->pop = session_a6f_create(&pop_host, &h->slot);
    if (h->push == NULL || h->pop == NULL) {
        session_a6e_destroy(h->push);
        session_a6f_destroy(h->pop);
        free(h);
        return NULL;
    }
    return h;
}

void a6fo_free(Handle *h)
{
    if (h != NULL) {
        session_a6e_destroy(h->push);
        session_a6f_destroy(h->pop);
        free(h);
    }
}

void a6fo_set_current(Handle *h, int32_t s57b, int32_t s57f, int w50b, int w593, int32_t d5a7, int32_t d5ab, int32_t d5af)
{
    h->current.scene_5bb57b = s57b;
    h->current.scene_5bb57f = s57f;
    h->current.word_5bb50b = (int16_t)w50b;
    h->current.word_5bb593 = (int16_t)w593;
    h->current.dword_5bb5a7 = d5a7;
    h->current.dword_5bb5ab = d5ab;
    h->current.dword_5bb5af = d5af;
}

void a6fo_set_refuse(Handle *h, int refuse) { h->host_refuse = refuse; }
int a6fo_applies(const Handle *h) { return h->applies; }

/* The slot as the 22 bytes of the original: five words, then three dwords. */
void a6fo_get_slot(const Handle *h, uint8_t out[22])
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

void a6fo_set_slot(Handle *h, const uint8_t in[22])
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

static void put_pop(const SceneStackPop *p, int32_t out[10])
{
    out[0] = p->scene_5bb57b;
    out[1] = p->scene_5bb57f;
    out[2] = p->word_5bb599;
    out[3] = p->word_5bb595;
    out[4] = p->word_5c39ff;
    out[5] = p->dword_5bb59b;
    out[6] = p->dword_5bb59f;
    out[7] = p->dword_5bb5a3;
    out[8] = p->start_5bb1ca;
    out[9] = p->mode_583999;
}

/* The values the pop stored into the globals (valid after a visit that returned 0 for a 0x6f row). */
void a6fo_get_pop(const Handle *h, int32_t out[10]) { put_pop(&h->last_pop, out); }

/* The scene-change request the host was handed: target, three words, three dwords. */
void a6fo_get_request(const Handle *h, int32_t out[7])
{
    out[0] = h->last_request.target_scene;
    out[1] = h->last_request.opaque_words[0];
    out[2] = h->last_request.opaque_words[1];
    out[3] = h->last_request.opaque_words[2];
    out[4] = h->last_request.opaque_dwords[0];
    out[5] = h->last_request.opaque_dwords[1];
    out[6] = h->last_request.opaque_dwords[2];
}

/* scene_stack_pop on the handle's slot (direct, no binding): returns SCENE_STACK_POP_*, fills out when OK. */
int a6fo_pop_direct(Handle *h, int32_t out[10])
{
    SceneStackPop p;
    int rc = scene_stack_pop(&h->slot, &p);
    if (rc == SCENE_STACK_POP_OK) put_pop(&p, out);
    return rc;
}

void a6fo_push_direct(Handle *h, int32_t argument) { scene_stack_push(&h->slot, &h->current, argument); }
void a6fo_init_words(Handle *h) { scene_stack_slot_init_words(&h->slot); }

/* Returns the handler status (SCENE_ACTION_HANDLER_*) or 100 + the executor-side failure. */
int a6fo_visit(Handle *h, int type, int subtype, int completed_before, uint32_t phase_before, int *completed_after, int *reset,
               uint32_t *phase_after, int *disposition)
{
    static const uint8_t body[1] = {0u};
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    ActionCoreActionResult finish;
    int status;
    memset(&info, 0, sizeof(info));
    info.type = (uint8_t)type;
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
    if (type == SESSION_A6F_TYPE) {
        status = session_a6f_handler(h->pop, 0u, &info, &before, &out);
    } else {
        status = session_a6e_handler(h->push, 0u, &info, &before, &out);
    }
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
