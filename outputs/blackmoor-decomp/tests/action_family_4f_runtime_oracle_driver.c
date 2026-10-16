/* RT-27 native side of the raw 0x4f oracle (tests/action_family_4f_runtime_original_oracle.py).
 *
 * One handle owns an ActionCoreWorld (30 int16 + 10 float32 action values and an event flag table of
 * A4FO_FLAGS entries) and the real session binding. a4fo_visit() performs what the executor does for a true gate:
 * it calls the binding handler and derives the row's completion byte, the dependency reset request and the phase
 * from the returned disposition with the executor's own helper (action_core_finish_action, scene_executor.c
 * apply_external_handler). a4fo_probe() asks the kernel what a visit would do on a copy of the world. */
#include <stdlib.h>
#include <string.h>

#include "action_core.h"
#include "action_family_4f.h"
#include "session_bindings_a4f.h"

#define A4FO_FLAGS 1600u

typedef struct {
    ActionCoreWorld world;
    int32_t flags[A4FO_FLAGS];
    SessionA4FBinding *binding;
} Handle;

Handle *a4fo_new(void)
{
    Handle *h = calloc(1u, sizeof(*h));
    if (h == NULL) return NULL;
    h->world.event_flags = h->flags;
    h->world.event_flag_count = A4FO_FLAGS;
    h->binding = session_a4f_create(&h->world);
    if (h->binding == NULL) {
        free(h);
        return NULL;
    }
    return h;
}

void a4fo_free(Handle *h)
{
    if (h != NULL) {
        session_a4f_destroy(h->binding);
        free(h);
    }
}

void a4fo_reset(Handle *h)
{
    memset(h->flags, 0, sizeof h->flags);
    action_core_initialize_values(&h->world);
    h->world.event_flag_count = A4FO_FLAGS;
}

void a4fo_set_flag_count(Handle *h, unsigned count) { h->world.event_flag_count = count; }
void a4fo_set_short(Handle *h, int i, int v) { h->world.short_values[i] = (int16_t)v; }
void a4fo_set_float_bits(Handle *h, int i, uint32_t bits) { memcpy(&h->world.float_values[i], &bits, sizeof(float)); }
void a4fo_set_flag(Handle *h, int i, int32_t v) { h->flags[i] = v; }
int32_t a4fo_flag(Handle *h, int i) { return h->flags[i]; }
int a4fo_short(Handle *h, int i) { return h->world.short_values[i]; }
uint32_t a4fo_float_bits(Handle *h, int i)
{
    uint32_t bits;
    memcpy(&bits, &h->world.float_values[i], sizeof bits);
    return bits;
}

/* Kernel status of a visit on a copy of the world (nothing in the handle changes). */
int a4fo_probe(Handle *h, const uint8_t *body, int body_length)
{
    ActionCoreWorld copy = h->world;
    int32_t flags[A4FO_FLAGS];
    ActionFamily4FDecoded decoded;
    ActionFamily4FResult result;
    int status;
    memcpy(flags, h->flags, sizeof flags);
    copy.event_flags = flags;
    status = action_family_4f_decode(body, (size_t)body_length, &decoded);
    if (status != ACTION_FAMILY_4F_OK) return status;
    return action_family_4f_visit(&decoded, &copy, &result);
}

/* Returns the handler status (SCENE_ACTION_HANDLER_*) or 100 + the executor-side failure. */
int a4fo_visit(Handle *h, const uint8_t *body, int body_length, int subtype, int completed_before,
               uint32_t phase_before, int *completed_after, int *reset, uint32_t *phase_after, int *disposition)
{
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    ActionCoreActionResult finish;
    int status;
    memset(&info, 0, sizeof(info));
    info.type = ACTION_FAMILY_4F_RAW_TYPE;
    info.subtype = (uint8_t)subtype;
    info.typed_body = body;
    info.typed_body_length = (size_t)body_length;
    before.completed = (uint8_t)completed_before;
    before.phase = phase_before;
    out.disposition = SCENE_ACTION_HANDLER_PENDING;
    out.phase = phase_before;
    *completed_after = completed_before;
    *reset = 0;
    *phase_after = phase_before;
    status = session_a4f_handler(h->binding, 0u, &info, &before, &out);
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
