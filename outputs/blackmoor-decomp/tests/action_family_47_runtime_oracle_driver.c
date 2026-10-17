/* RT-42 native side of the raw 0x47 oracle (tests/action_family_47_runtime_original_oracle.py).
 *
 * One handle owns the real session binding, a lookup that answers from a set of present keys (the oracle replaces 0x423259 with
 * the same set on the x86 side) and the log of lookup calls (row index and key, in call order). a47o_visit() performs what the
 * executor does for a true gate: it calls the binding handler for the row and derives the completion byte, the dependency reset
 * request and the phase from the returned disposition with the executor's own helper (action_core_finish_action,
 * scene_executor.c apply_external_handler). a47o_load() / a47o_dump() move the journal tables in and out in the original's cell
 * layout. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_core.h"
#include "session_bindings_a47.h"

#define PRESENT_MAX 64

typedef struct {
    uint8_t key[40];
    size_t key_length;
} Key;

typedef struct {
    int row;
    size_t length;
    uint8_t bytes[40];
} Call;

typedef struct {
    SessionA47Binding *binding;
    Key present[PRESENT_MAX];
    unsigned present_count;
    Call *calls;
    unsigned call_count, call_cap;
    int current_row;
    int lookup_error;
} Handle;

static ActionFamily51LookupStatus lookup(void *context, const uint8_t *key, size_t key_length, const uint8_t **text, size_t *length)
{
    Handle *h = (Handle *)context;
    unsigned i;
    Call *c;
    if (h->call_count == h->call_cap) {
        h->call_cap = h->call_cap ? h->call_cap * 2u : 64u;
        h->calls = (Call *)realloc(h->calls, h->call_cap * sizeof(Call));
    }
    c = &h->calls[h->call_count++];
    c->row = h->current_row;
    c->length = key_length < sizeof c->bytes ? key_length : sizeof c->bytes;
    memcpy(c->bytes, key, c->length);
    *text = (const uint8_t *)"";
    *length = 0u;
    if (h->lookup_error) return ACTION_FAMILY_51_LOOKUP_ERROR;
    for (i = 0; i < h->present_count; ++i) {
        if (h->present[i].key_length == key_length && memcmp(h->present[i].key, key, key_length) == 0) {
            return ACTION_FAMILY_51_LOOKUP_FOUND;
        }
    }
    return ACTION_FAMILY_51_LOOKUP_NOT_FOUND;
}

Handle *a47o_new(void)
{
    Handle *h = (Handle *)calloc(1u, sizeof(*h));
    SessionA47Host host;
    if (h == NULL) return NULL;
    memset(&host, 0, sizeof host);
    host.lookup = lookup;
    host.lookup_context = h;
    h->binding = session_a47_create(&host);
    return h->binding != NULL ? h : NULL;
}

void a47o_free(Handle *h)
{
    if (h == NULL) return;
    session_a47_destroy(h->binding);
    free(h->calls);
    free(h);
}

void a47o_present_clear(Handle *h) { h->present_count = 0u; }

int a47o_present_add(Handle *h, const uint8_t *key, unsigned length)
{
    if (h->present_count == PRESENT_MAX || length >= sizeof h->present[0].key) return 0;
    memcpy(h->present[h->present_count].key, key, length);
    h->present[h->present_count].key_length = length;
    ++h->present_count;
    return 1;
}

void a47o_set_lookup_error(Handle *h, int on) { h->lookup_error = on; }

/* names: 3 * 400 * 33 bytes, code and link: 3 * 400 words, count: 3 words, flags: 4 dwords (any, slot 0..2). */
void a47o_load(Handle *h, const uint8_t *names, const int16_t *code, const int16_t *count, const int16_t *link, const uint32_t *flags)
{
    A47Tables *t = (A47Tables *)session_a47_tables(h->binding);
    memcpy(t->name, names, sizeof t->name);
    memcpy(t->code, code, sizeof t->code);
    memcpy(t->count, count, sizeof t->count);
    memcpy(t->link_value, link, sizeof t->link_value);
    t->page2_any = flags[0];
    memcpy(t->page2_slot, flags + 1, sizeof t->page2_slot);
}

void a47o_dump(const Handle *h, uint8_t *names, int16_t *code, int16_t *count, int16_t *link, uint32_t *flags)
{
    const A47Tables *t = session_a47_tables(h->binding);
    memcpy(names, t->name, sizeof t->name);
    memcpy(code, t->code, sizeof t->code);
    memcpy(count, t->count, sizeof t->count);
    memcpy(link, t->link_value, sizeof t->link_value);
    flags[0] = t->page2_any;
    memcpy(flags + 1, t->page2_slot, sizeof t->page2_slot);
}

unsigned a47o_call_count(const Handle *h) { return h->call_count; }
int a47o_call_row(const Handle *h, unsigned i) { return h->calls[i].row; }
unsigned a47o_call_length(const Handle *h, unsigned i) { return (unsigned)h->calls[i].length; }
void a47o_call_copy(const Handle *h, unsigned i, uint8_t *out) { memcpy(out, h->calls[i].bytes, h->calls[i].length); }
void a47o_calls_clear(Handle *h) { h->call_count = 0u; }

/* The last kernel outcome: table, index, appended, duplicate, miss, flag slot (-1 none), lookups. */
void a47o_outcome(const Handle *h, int *out7)
{
    const A47Outcome *o = session_a47_last_outcome(h->binding);
    out7[0] = o->table;
    out7[1] = o->index;
    out7[2] = o->appended;
    out7[3] = o->duplicate;
    out7[4] = o->lookup_miss;
    out7[5] = o->flag_slot;
    out7[6] = o->lookups;
}

/* Returns the handler status (SCENE_ACTION_HANDLER_*) or 100 + the executor-side failure. */
int a47o_visit(Handle *h, int index, unsigned subtype, const uint8_t *raw, unsigned raw_length, int completed_before,
               uint32_t phase_before, int *completed_after, int *reset, uint32_t *phase_after, int *disposition)
{
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    ActionCoreActionResult finish;
    int status;
    memset(&info, 0, sizeof info);
    info.type = SESSION_A47_TYPE;
    info.subtype = (uint8_t)subtype;
    info.raw_body = raw;
    info.raw_body_length = raw_length;
    info.typed_body = raw;
    info.typed_body_length = raw_length < A47_BODY_BYTES ? raw_length : A47_BODY_BYTES;
    before.completed = (uint8_t)completed_before;
    before.phase = phase_before;
    out.disposition = SCENE_ACTION_HANDLER_PENDING;
    out.phase = phase_before;
    *completed_after = completed_before;
    *reset = 0;
    *phase_after = phase_before;
    h->current_row = index;
    status = session_a47_handler(h->binding, (size_t)index, &info, &before, &out);
    *disposition = (int)out.disposition;
    if (status != SCENE_ACTION_HANDLER_OK) return status;
    /* scene_executor.c apply_external_handler */
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
