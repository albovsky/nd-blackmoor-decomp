/* RT-37 native side of the raw 0x65 / 0x68 / 0x69 oracle (tests/action_family_65_68_69_runtime_original_oracle.py).
 *
 * One handle owns the ten timer records (DAT_00585d65 as the host stores them), the log of host calls and the real session
 * binding. a65o_visit() performs what the executor does for a true gate: it calls the binding handler for the row's type and
 * derives the row's completion byte, the dependency reset request and the phase from the returned disposition with the
 * executor's own helper (action_core_finish_action, scene_executor.c apply_external_handler). The effect log holds, in order,
 * -1 for a save call and the record index for each timer record the binding was handed. */
#include <stdlib.h>
#include <string.h>

#include "action_core.h"
#include "session_bindings_a65_a68_a69.h"

#define LOG_MAX 4096

typedef struct {
    uint8_t records[SESSION_TIMER_RECORD_COUNT][SESSION_TIMER_RECORD_BYTES];
    int32_t log[LOG_MAX];
    unsigned log_count;
    unsigned saves;
    int name_ok;
    int arg_ok;
    SessionA65Binding *binding;
} Handle;

static uint8_t *time_record(void *context, unsigned index)
{
    Handle *h = (Handle *)context;
    if (index >= SESSION_TIMER_RECORD_COUNT) return NULL;
    if (h->log_count < LOG_MAX) h->log[h->log_count++] = (int32_t)index;
    return h->records[index];
}

static void save_game(void *context, const char *name, int report_failure)
{
    Handle *h = (Handle *)context;
    ++h->saves;
    h->name_ok = strcmp(name, "SAVE CONTINUE") == 0;
    h->arg_ok = report_failure == 0;
    if (h->log_count < LOG_MAX) h->log[h->log_count++] = -1;
}

Handle *a65o_new(void)
{
    SessionA65Host host;
    Handle *h = calloc(1u, sizeof(*h));
    if (h == NULL) return NULL;
    memset(&host, 0, sizeof host);
    host.context = h;
    host.time_record = time_record;
    host.save_game = save_game;
    h->binding = session_a65_create(&host);
    if (h->binding == NULL) {
        free(h);
        return NULL;
    }
    h->name_ok = h->arg_ok = 1;
    return h;
}

void a65o_free(Handle *h)
{
    if (h != NULL) {
        session_a65_destroy(h->binding);
        free(h);
    }
}

void a65o_set_records(Handle *h, const uint8_t *bytes) { memcpy(h->records, bytes, sizeof h->records); }
void a65o_get_records(const Handle *h, uint8_t *out) { memcpy(out, h->records, sizeof h->records); }
unsigned a65o_log_count(const Handle *h) { return h->log_count; }
int32_t a65o_log_at(const Handle *h, unsigned i) { return h->log[i]; }
void a65o_log_clear(Handle *h) { h->log_count = 0u; }
unsigned a65o_saves(const Handle *h) { return h->saves; }
int a65o_save_args_ok(const Handle *h) { return h->name_ok && h->arg_ok; }
unsigned long a65o_visits(const Handle *h)
{
    return session_a65_visits(h->binding) + session_a68_visits(h->binding) + session_a69_visits(h->binding);
}
void a65o_clear_kernel(uint8_t *out) { session_timer_record_clear(out); }

/* Returns the handler status (SCENE_ACTION_HANDLER_*) or 100 + the executor-side failure. */
int a65o_visit(Handle *h, int type, int subtype, int body_byte, int completed_before, uint32_t phase_before, int *completed_after,
               int *reset, uint32_t *phase_after, int *disposition)
{
    uint8_t body[1];
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    ActionCoreActionResult finish;
    int status;
    body[0] = (uint8_t)body_byte;
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
    status = type == SESSION_A65_TYPE ? session_a65_handler(h->binding, 0u, &info, &before, &out)
           : type == SESSION_A68_TYPE ? session_a68_handler(h->binding, 0u, &info, &before, &out)
                                      : session_a69_handler(h->binding, 0u, &info, &before, &out);
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
