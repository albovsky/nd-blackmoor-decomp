/* RT-34 native side of the raw 0x44 oracle (tests/action_family_44_runtime_original_oracle.py).
 *
 * One handle owns a session binding (src/session_bindings_a44.c) whose rows are raw 0x44 objects installed directly (the
 * scene loader 0x40b34a / constructor 0x41166e are not part of this oracle), a scripted text writer host that hands the
 * binding the A44TextResult the oracle also gave the original 0x413187 stand-in, and the executor's own disposition mapping
 * (scene_executor.c apply_external_handler) so a visit reports the row's final completion byte, phase and dependency-reset
 * request exactly as the executor would store them.
 *
 * WHITE BOX: this file includes src/session_bindings_a44.c so it can read the binding's row table (is_object / is_record, the
 * record bytes and length); the binding source is therefore compiled from this one translation unit and is NOT linked
 * separately. Mutation builds point -I at a mutated copy of src/, so the include picks the mutated binding up.
 *
 * a44_build_record / a44_record_length are also exported directly (a44o_build / a44o_record_length) so the record builder is
 * compared with the original on the same inputs without the binding. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "session_bindings_a44.c"

typedef struct {
    ActionCoreWorld world;
    int32_t flags[16];
    SessionA44Binding *binding;
    A44TextResult text;
    int current_row;
    unsigned writer_calls;
    unsigned writer_same_pointer;
    uint8_t *writer_object;
    size_t writer_object_len;
    int writer_fail;
} Handle;

static int write_text(void *context, const uint8_t *object, size_t bytes, A44TextResult *out)
{
    Handle *h = (Handle *)context;
    ++h->writer_calls;
    if (h->current_row >= 0 && (size_t)h->current_row < h->binding->count &&
        h->binding->rows[h->current_row].bytes == object)
        ++h->writer_same_pointer;
    free(h->writer_object);
    h->writer_object = (uint8_t *)malloc(bytes);
    if (h->writer_object != NULL) memcpy(h->writer_object, object, bytes);
    h->writer_object_len = bytes;
    if (h->writer_fail) return 1;
    *out = h->text;
    return 0;
}

Handle *a44o_new(unsigned rows)
{
    SessionA44Host host;
    Handle *h = (Handle *)calloc(1u, sizeof(*h));
    if (h == NULL) return NULL;
    h->world.event_flags = h->flags;
    h->world.event_flag_count = 16u;
    memset(&host, 0, sizeof host);
    host.context = h;
    host.write_text = write_text;
    h->binding = session_a44_create(&host, &h->world);
    if (h->binding == NULL) {
        free(h);
        return NULL;
    }
    h->binding->rows = rows == 0u ? NULL : (A44Row *)calloc(rows, sizeof(A44Row));
    h->binding->count = h->binding->rows == NULL ? 0u : rows;
    h->current_row = -1;
    return h;
}

void a44o_free(Handle *h)
{
    if (h == NULL) return;
    free(h->writer_object);
    session_a44_destroy(h->binding);
    free(h);
}

int a44o_set_row(Handle *h, unsigned row, const uint8_t *object, size_t length)
{
    A44Row *r;
    if (row >= h->binding->count) return 1;
    r = &h->binding->rows[row];
    free(r->bytes);
    r->bytes = (uint8_t *)malloc(length == 0u ? 1u : length);
    if (r->bytes == NULL) return 2;
    memcpy(r->bytes, object, length);
    r->length = length;
    r->is_object = 1u;
    r->is_record = 0u;
    return 0;
}

static void fill_text(A44TextResult *t, int has_links, int count, const int16_t *values, unsigned nvalues, const uint8_t *rects,
                      unsigned nrects)
{
    memset(t, 0, sizeof(*t));
    t->has_links = (uint8_t)(has_links != 0 ? 1 : 0);
    t->link_count = (int16_t)count;
    for (unsigned i = 0u; i < nvalues && i < A44_LINK_MAX; ++i) t->link_value[i] = values[i];
    for (unsigned i = 0u; i < nrects && i < A44_LINK_MAX; ++i) memcpy(t->link_rect[i], rects + 16u * i, 16u);
}

/* The scripted writer outcome for the next visit. has_links is the host's reading of the dword [0x619a41 + 0x102a]. */
void a44o_set_text(Handle *h, int has_links, int count, const int16_t *values, unsigned nvalues, const uint8_t *rects,
                   unsigned nrects)
{
    fill_text(&h->text, has_links, count, values, nvalues, rects, nrects);
}

void a44o_set_writer_fail(Handle *h, int fail) { h->writer_fail = fail; }
unsigned a44o_writer_calls(const Handle *h) { return h->writer_calls; }
unsigned a44o_writer_same_pointer(const Handle *h) { return h->writer_same_pointer; }
size_t a44o_writer_object(const Handle *h, uint8_t *out, size_t cap)
{
    size_t n = h->writer_object_len < cap ? h->writer_object_len : cap;
    if (out != NULL && h->writer_object != NULL) memcpy(out, h->writer_object, n);
    return h->writer_object_len;
}

/* Handler status (SCENE_ACTION_HANDLER_*) or 100 + an executor-side failure. */
int a44o_visit(Handle *h, int row, int subtype, int completed_before, uint32_t phase_before, int *completed_after, int *reset,
               uint32_t *phase_after, int *disposition)
{
    SceneActionInfo info;
    SceneActionRuntimeState before;
    SceneActionHandlerResult out;
    ActionCoreActionResult finish;
    int status;
    memset(&info, 0, sizeof(info));
    info.type = SESSION_A44_TYPE;
    info.subtype = (uint8_t)subtype;
    before.completed = (uint8_t)completed_before;
    before.phase = phase_before;
    out.disposition = SCENE_ACTION_HANDLER_PENDING;
    out.phase = phase_before;
    *completed_after = completed_before;
    *reset = 0;
    *phase_after = phase_before;
    h->current_row = row;
    h->writer_calls = 0u; /* the writer observations describe this visit only */
    h->writer_same_pointer = 0u;
    status = session_a44_handler(h->binding, (size_t)row, &info, &before, &out);
    *disposition = (int)out.disposition;
    if (status != SCENE_ACTION_HANDLER_OK) return status;
    switch (out.disposition) { /* scene_executor.c apply_external_handler */
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

/* bit 0: still a raw object; bit 1: converted to a 0xd8 record. */
int a44o_row_flags(const Handle *h, unsigned row)
{
    const A44Row *r;
    if (row >= h->binding->count) return -1;
    r = &h->binding->rows[row];
    return (r->is_object != 0u ? 1 : 0) | (r->is_record != 0u ? 2 : 0);
}

size_t a44o_row_bytes(const Handle *h, unsigned row, uint8_t *out, size_t cap)
{
    const A44Row *r;
    size_t n;
    if (row >= h->binding->count) return 0u;
    r = &h->binding->rows[row];
    n = r->length < cap ? r->length : cap;
    if (out != NULL && r->bytes != NULL) memcpy(out, r->bytes, n);
    return r->length;
}

const char *a44o_failure(const Handle *h) { return session_a44_failure(h->binding); }

/* Direct builder: a44_build_record on the same inputs. Returns the A44Status; *out_bytes the length written. */
int a44o_build(const uint8_t *object, size_t object_bytes, int has_links, int count, const int16_t *values, unsigned nvalues,
               const uint8_t *rects, unsigned nrects, uint8_t *out, size_t cap, size_t *out_bytes)
{
    static A44TextResult text;
    fill_text(&text, has_links, count, values, nvalues, rects, nrects);
    *out_bytes = 0u;
    return a44_build_record(object, object_bytes, &text, out, cap, out_bytes);
}

size_t a44o_record_length(const uint8_t *object, size_t object_bytes, int has_links, int count, const int16_t *values,
                          unsigned nvalues, const uint8_t *rects, unsigned nrects)
{
    static A44TextResult text;
    fill_text(&text, has_links, count, values, nvalues, rects, nrects);
    return a44_record_length(object, object_bytes, &text);
}
