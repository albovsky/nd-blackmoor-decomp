/* RT-33 native side of the raw 0x2e oracle (tests/action_family_2e_runtime_original_oracle.py).
 *
 * One handle owns the event flag table (the dwords at 0x585801), the random-movie object fields the handler touches, the start
 * flag and scene-change requests as the host stores them, and the real session binding. a2eo_visit() performs what the
 * executor does for a true gate: it calls the binding handler and derives the row's completion byte, the dependency reset
 * request and the phase from the returned disposition with the executor's own helper (action_core_finish_action,
 * scene_executor.c apply_external_handler). Every ordered store the binding reports is logged for the oracle to compare. */
#include <stdlib.h>
#include <string.h>

#include "action_core.h"
#include "session_bindings_a2e.h"

#define FLAG_TABLE 1600u
#define MAX_FX 64u

typedef struct {
    int32_t flags[FLAG_TABLE];
    ActionCoreWorld world;
    int32_t start_flag;
    unsigned long start_sets;
    unsigned long transitions;
    int32_t last_request[7]; /* target, three words, three dwords of the last scene-change request the host received */
    SessionA2EBinding *binding;
    int fx[MAX_FX];
    int32_t fx_value[MAX_FX];
    int32_t fx_row[MAX_FX];
    unsigned nfx;
} Handle;

static void set_start_flag(void *context, int32_t value)
{
    Handle *h = (Handle *)context;
    h->start_flag = value;
    ++h->start_sets;
}

static int transition(void *context, const SceneTransitionRequest *request)
{
    Handle *h = (Handle *)context;
    h->last_request[0] = request->target_scene;
    h->last_request[1] = request->opaque_words[0];
    h->last_request[2] = request->opaque_words[1];
    h->last_request[3] = request->opaque_words[2];
    h->last_request[4] = request->opaque_dwords[0];
    h->last_request[5] = request->opaque_dwords[1];
    h->last_request[6] = request->opaque_dwords[2];
    ++h->transitions;
    return 0;
}

static void observe(void *context, size_t row, int effect, int32_t value)
{
    Handle *h = (Handle *)context;
    if (h->nfx < MAX_FX) {
        h->fx[h->nfx] = effect;
        h->fx_value[h->nfx] = value;
        h->fx_row[h->nfx] = (int32_t)row;
        ++h->nfx;
    }
}

Handle *a2eo_new(void)
{
    SessionA2EHost host;
    Handle *h = calloc(1u, sizeof(*h));
    if (h == NULL) return NULL;
    h->world.event_flags = h->flags;
    h->world.event_flag_count = FLAG_TABLE;
    memset(&host, 0, sizeof host);
    host.context = h;
    host.set_start_flag = set_start_flag;
    host.transition = transition;
    host.observe = observe;
    h->binding = session_a2e_create(&host, &h->world);
    if (h->binding == NULL) {
        free(h);
        return NULL;
    }
    return h;
}

void a2eo_free(Handle *h)
{
    if (h != NULL) {
        session_a2e_destroy(h->binding);
        free(h);
    }
}

void a2eo_set_start_flag(Handle *h, int32_t value) { h->start_flag = value; }
int32_t a2eo_get_start_flag(const Handle *h) { return h->start_flag; }
unsigned long a2eo_start_sets(const Handle *h) { return h->start_sets; }
unsigned long a2eo_transitions(const Handle *h) { return h->transitions; }
void a2eo_last_request(const Handle *h, int32_t *out) { memcpy(out, h->last_request, sizeof h->last_request); }
void a2eo_set_event(Handle *h, int index, int32_t value) { h->flags[index] = value; }
int32_t a2eo_get_event(const Handle *h, int index) { return h->flags[index]; }
void a2eo_clear_events(Handle *h) { memset(h->flags, 0, sizeof h->flags); }

/* movie: active, mode, row, state_1de, flag_206, pending_25a */
void a2eo_set_movie(Handle *h, const int32_t *fields)
{
    SessionA2EMovie m;
    m.active = fields[0];
    m.mode = fields[1];
    m.row = fields[2];
    m.state_1de = fields[3];
    m.flag_206 = fields[4];
    m.pending_25a = fields[5];
    session_a2e_set_movie(h->binding, &m);
}

void a2eo_get_movie(const Handle *h, int32_t *fields)
{
    const SessionA2EMovie *m = session_a2e_movie(h->binding);
    fields[0] = m->active;
    fields[1] = m->mode;
    fields[2] = m->row;
    fields[3] = m->state_1de;
    fields[4] = m->flag_206;
    fields[5] = m->pending_25a;
}

unsigned a2eo_fx_count(const Handle *h) { return h->nfx; }
int a2eo_fx_get(const Handle *h, unsigned i, int32_t *effect, int32_t *value, int32_t *row)
{
    if (i >= h->nfx) return 1;
    *effect = h->fx[i];
    *value = h->fx_value[i];
    *row = h->fx_row[i];
    return 0;
}
void a2eo_fx_clear(Handle *h) { h->nfx = 0u; }

/* Returns the handler status (SCENE_ACTION_HANDLER_*) or 100 + the executor-side failure. */
int a2eo_visit(Handle *h, int row, int subtype, const uint8_t *body, int completed_before, uint32_t phase_before,
               int *completed_after, int *reset, uint32_t *phase_after, int *disposition)
{
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    ActionCoreActionResult finish;
    int status;
    memset(&info, 0, sizeof(info));
    info.type = ACTION_FAMILY_2E_RAW_TYPE;
    info.subtype = (uint8_t)subtype;
    info.typed_body = body;
    info.typed_body_length = ACTION_FAMILY_2E_BODY_BYTES;
    before.completed = (uint8_t)completed_before;
    before.phase = phase_before;
    out.disposition = SCENE_ACTION_HANDLER_PENDING;
    out.phase = phase_before;
    *completed_after = completed_before;
    *reset = 0;
    *phase_after = phase_before;
    status = session_a2e_handler(h->binding, (size_t)row, &info, &before, &out);
    *disposition = (int)out.disposition;
    if (status != SCENE_ACTION_HANDLER_OK) return status;
    /* scene_executor.c apply_external_handler */
    switch (out.disposition) {
    case SCENE_ACTION_HANDLER_PENDING:
        *phase_after = out.phase;
        break;
    case SCENE_ACTION_HANDLER_COMPLETED:
        if (action_core_finish_action((uint8_t)subtype, (uint8_t)completed_before, &finish) != ACTION_CORE_OK) return 101;
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
