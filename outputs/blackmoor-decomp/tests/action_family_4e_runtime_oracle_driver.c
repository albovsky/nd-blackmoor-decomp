/* RT-44 native side of the raw 0x4e oracle (tests/action_family_4e_runtime_original_oracle.py).
 *
 * One handle owns an ActionCoreWorld, the real session binding over it and the executor's disposition mapping.
 * a4eo_load() / a4eo_dump() move the 30 short and 10 float value slots in and out in the original's cell layout (words at
 * 0x58c959, float32 at 0x58c995, as raw bit patterns so NaN payloads survive); a4eo_visit() performs what the executor does for
 * a true gate (scene_executor.c apply_external_handler). */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_core.h"
#include "session_bindings_a4e.h"

typedef struct {
    ActionCoreWorld world;
    SessionA4EBinding *binding;
} Handle;

Handle *a4eo_new(void)
{
    Handle *h = (Handle *)calloc(1u, sizeof(*h));
    if (h == NULL) return NULL;
    h->binding = session_a4e_create(&h->world);
    return h->binding != NULL ? h : NULL;
}

void a4eo_free(Handle *h)
{
    if (h == NULL) return;
    session_a4e_destroy(h->binding);
    free(h);
}

void a4eo_load(Handle *h, const int16_t *shorts, const uint32_t *float_bits)
{
    memcpy(h->world.short_values, shorts, sizeof h->world.short_values);
    memcpy(h->world.float_values, float_bits, sizeof h->world.float_values);
}

void a4eo_dump(const Handle *h, int16_t *shorts, uint32_t *float_bits)
{
    memcpy(shorts, h->world.short_values, sizeof h->world.short_values);
    memcpy(float_bits, h->world.float_values, sizeof h->world.float_values);
}

/* out[0..3] = target_valid, terms_added, unset_terms, reports; out[4..13] = the reported selectors. */
void a4eo_outcome(const Handle *h, int *out)
{
    const ActionFamily4ERuntimeOutcome *o = session_a4e_last_outcome(h->binding);
    unsigned i;
    out[0] = o->target_valid;
    out[1] = o->terms_added;
    out[2] = o->unset_terms;
    out[3] = o->reports;
    for (i = 0; i < ACTION_FAMILY_4E_ENTRY_COUNT; ++i) out[4 + i] = o->report_selector[i];
}

int a4eo_visit(Handle *h, int index, unsigned subtype, const uint8_t *raw, unsigned raw_length, int completed_before,
               uint32_t phase_before, int *completed_after, int *reset, uint32_t *phase_after, int *disposition)
{
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    ActionCoreActionResult finish;
    int status;
    memset(&info, 0, sizeof info);
    info.type = SESSION_A4E_TYPE;
    info.subtype = (uint8_t)subtype;
    info.raw_body = raw;
    info.raw_body_length = raw_length;
    info.typed_body = raw;
    info.typed_body_length = raw_length < ACTION_FAMILY_4E_BODY_BYTES ? raw_length : ACTION_FAMILY_4E_BODY_BYTES;
    before.completed = (uint8_t)completed_before;
    before.phase = phase_before;
    out.disposition = SCENE_ACTION_HANDLER_PENDING;
    out.phase = phase_before;
    *completed_after = completed_before;
    *reset = 0;
    *phase_after = phase_before;
    status = session_a4e_handler(h->binding, (size_t)index, &info, &before, &out);
    *disposition = (int)out.disposition;
    if (status != SCENE_ACTION_HANDLER_OK) return status;
    switch (out.disposition) {
    case SCENE_ACTION_HANDLER_PENDING:
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_COMPLETED:
        if (action_core_finish_action(subtype, (uint8_t)completed_before, &finish) != ACTION_CORE_OK) return 101;
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
