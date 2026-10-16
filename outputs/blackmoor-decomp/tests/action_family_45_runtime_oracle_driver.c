/* RT-38 native side of the raw 0x45 oracle (tests/action_family_45_runtime_original_oracle.py).
 *
 * One handle owns the ten timer records (DAT_00585d65 as the host stores them), the loader word table at 0x5adb81 (the words
 * for the indexes the oracle uses), the log of host calls and the real session binding. a45o_visit() performs what the executor
 * does for a true gate: it calls the binding handler for the row and derives the row's completion byte, the dependency reset
 * request and the phase from the returned disposition with the executor's own helper (action_core_finish_action,
 * scene_executor.c apply_external_handler). The log holds, in order, the record index of each timer record the binding was handed
 * and 100000 + index for each table word it asked for. */
#include <stdlib.h>
#include <string.h>

#include "action_core.h"
#include "session_bindings_a45.h"

#define LOG_MAX 4096
#define WORD_BASE 5000
#define WORD_LIMIT 17686 /* 2 * index + 0x5adb81 stays below the row array at 0x5bb5b3 */

typedef struct {
    uint8_t records[SESSION_TIMER_RECORD_COUNT][SESSION_TIMER_RECORD_BYTES];
    int16_t words[WORD_LIMIT];
    int32_t log[LOG_MAX];
    unsigned log_count;
    SessionA45Binding *binding;
} Handle;

static void log_add(Handle *h, int32_t v)
{
    if (h->log_count < LOG_MAX) h->log[h->log_count++] = v;
}

static uint8_t *time_record(void *context, unsigned index)
{
    Handle *h = (Handle *)context;
    if (index >= SESSION_TIMER_RECORD_COUNT) return NULL;
    log_add(h, (int32_t)index);
    return h->records[index];
}

static int variable_word(void *context, int16_t index, int16_t *value)
{
    Handle *h = (Handle *)context;
    if (index < WORD_BASE || index >= WORD_LIMIT) return 0;
    log_add(h, 100000 + index);
    *value = h->words[index];
    return 1;
}

Handle *a45o_new(void)
{
    SessionA45Host host;
    Handle *h = calloc(1u, sizeof(*h));
    if (h == NULL) return NULL;
    memset(&host, 0, sizeof host);
    host.context = h;
    host.time_record = time_record;
    host.variable_word = variable_word;
    h->binding = session_a45_create(&host);
    if (h->binding == NULL) {
        free(h);
        return NULL;
    }
    return h;
}

void a45o_free(Handle *h)
{
    if (h != NULL) {
        session_a45_destroy(h->binding);
        free(h);
    }
}

void a45o_set_records(Handle *h, const uint8_t *bytes) { memcpy(h->records, bytes, sizeof h->records); }
void a45o_get_records(const Handle *h, uint8_t *out) { memcpy(out, h->records, sizeof h->records); }
void a45o_set_words(Handle *h, const int16_t *words) { memcpy(h->words, words, sizeof h->words); }
unsigned a45o_word_limit(void) { return WORD_LIMIT; }
unsigned a45o_log_count(const Handle *h) { return h->log_count; }
int32_t a45o_log_at(const Handle *h, unsigned i) { return h->log[i]; }
void a45o_log_clear(Handle *h) { h->log_count = 0u; }
unsigned long a45o_visits(const Handle *h) { return session_a45_completed(h->binding) + session_a45_pending(h->binding); }
void a45o_clear_kernel(uint8_t *out) { session_timer_record_clear(out); }

/* Returns the handler status (SCENE_ACTION_HANDLER_*) or 100 + the executor-side failure. */
int a45o_visit(Handle *h, int subtype, const uint8_t *body, unsigned length, int completed_before, uint32_t phase_before,
               int *completed_after, int *reset, uint32_t *phase_after, int *disposition)
{
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    ActionCoreActionResult finish;
    int status;
    memset(&info, 0, sizeof(info));
    info.type = SESSION_A45_TYPE;
    info.subtype = (uint8_t)subtype;
    info.typed_body = body;
    info.typed_body_length = length;
    before.completed = (uint8_t)completed_before;
    before.phase = phase_before;
    out.disposition = SCENE_ACTION_HANDLER_PENDING;
    out.phase = phase_before;
    *completed_after = completed_before;
    *reset = 0;
    *phase_after = phase_before;
    status = session_a45_handler(h->binding, 0u, &info, &before, &out);
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
