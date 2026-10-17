/* RT-46 native side of the raw 0x33 oracle (tests/action_family_33_runtime_original_oracle.py).
 *
 * One handle owns an A33State, up to A33O_ROWS parsed bodies with their row cells, and a scripted A33Host. The host records
 * every A33Op with its arguments and return in an ordered log and answers the ops that return a value (TICK, OVERLAY_LOAD,
 * SURFACE_CREATE, THREAD_CREATE) from four scripted queues; an exhausted queue repeats its last value. The Python side moves
 * state in and out by field name through a table (address of the original cell, element size, count, signedness) so that
 * the native struct and the original memory are compared field by field at the original's addresses.
 *
 * The driver adds no behaviour: a33o_step() is a33_step() on the visiting row's set and cells with a scripted host. */
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_33_runtime.h"

#define A33O_ROWS 4
#define A33O_LOG_MAX 512
#define A33O_QUEUE_MAX 64

typedef struct {
    int op;
    int32_t a, b, ret;
    A33State snap; /* the state when the op was issued: the host (reader thread, surfaces) can observe it */
} LogEntry;

typedef struct {
    uint32_t values[A33O_QUEUE_MAX];
    int count;
    int next;
    int exhausted;
} Queue;

typedef struct {
    A33State state;
    A33Set sets[A33O_ROWS];
    int have_set[A33O_ROWS];
    A33Row cells[A33O_ROWS];
    Queue queues[4]; /* 0 tick, 1 surface create, 2 overlay load, 3 thread create */
    LogEntry log[A33O_LOG_MAX];
    int log_count;
    int fail_at;
    int ops_seen;
} Handle;

typedef struct {
    const char *name;
    uint32_t address;      /* the original cell; 0 = no original cell */
    uint32_t offset;       /* offsetof in A33State */
    int size;              /* element size in bytes */
    int count;             /* elements */
    int is_signed;
    int pointer_flag;      /* compare only "nonzero" */
} Field;

#define F(member, address, type, is_signed, pointer)                                                         \
    { #member, (address), (uint32_t)offsetof(A33State, member), (int)sizeof(type),                           \
      (int)(sizeof(((A33State *)0)->member) / sizeof(type)), (is_signed), (pointer) }

static const Field FIELDS[] = {
    F(page_5b4dc8, 0x5b4dc8, int16_t, 1, 0),
    F(row_5b4e89, 0x5b4e89, int16_t, 1, 0),
    F(kind_5b4e8b, 0x5b4e8b, int16_t, 1, 0),
    F(mode_5b4ea3, 0x5b4ea3, int16_t, 1, 0),
    F(active_5c39f1, 0x5c39f1, int32_t, 1, 0),
    F(latch_5d1967, 0x5d1967, int32_t, 1, 0),
    F(flag_5b4e8d, 0x5b4e8d, int16_t, 1, 0),
    F(frame_5b4e00, 0x5b4e00, int16_t, 1, 0),
    F(w_5b4e02, 0x5b4e02, int16_t, 1, 0),
    F(present_5b4e04, 0x5b4e04, int16_t, 1, 0),
    F(state_5b4e10, 0x5b4e10, int32_t, 1, 0),
    F(anim_5b4e14, 0x5b4e14, int32_t, 1, 0),
    F(deadline_5b4dfc, 0x5b4dfc, uint32_t, 0, 0),
    F(clip_5b4d8f, 0x5b4d8f, uint8_t, 0, 0),
    F(overlay_5b4e68, 0x5b4e68, uint8_t, 0, 0),
    F(start_5bb1ca, 0x5bb1ca, int32_t, 1, 0),
    F(thread_5b4e0c, 0x5b4e0c, uint32_t, 0, 0),
    F(stream_5b4c3a, 0x5b4c3a, int32_t, 1, 0),
    F(buf_5b4db8, 0x5b4db8, uint32_t, 0, 0),
    F(buf_5b4dbc, 0x5b4dbc, uint32_t, 0, 0),
    F(flags_5b4dc0, 0x5b4dc0, uint16_t, 0, 0),
    F(flags_5b4dc2, 0x5b4dc2, uint16_t, 0, 0),
    F(surface_5d03bf, 0x5d03bf, uint32_t, 0, 0),
    F(surface_5d03c7, 0x5d03c7, uint32_t, 0, 0),
    F(surface_5d195b, 0x5d195b, uint32_t, 0, 0),
    F(src1_5b4e18, 0x5b4e18, int32_t, 1, 0),
    F(dst1_5b4e28, 0x5b4e28, int32_t, 1, 0),
    F(src2_5b4e38, 0x5b4e38, int32_t, 1, 0),
    F(dst2_5b4e48, 0x5b4e48, int32_t, 1, 0),
    F(rel_dst1_5b4e58, 0x5b4e58, int32_t, 1, 0),
    F(rel_dst2_5b4e93, 0x5b4e93, int32_t, 1, 0),
    F(scene_5bb57b, 0x5bb57b, int32_t, 1, 0),
    F(w_5bb599, 0x5bb599, int16_t, 1, 0),
    F(w_5bb595, 0x5bb595, int16_t, 1, 0),
    F(w_5c39ff, 0x5c39ff, int16_t, 1, 0),
    F(d_5bb59b, 0x5bb59b, int32_t, 1, 0),
    F(d_5bb59f, 0x5bb59f, int32_t, 1, 0),
    F(d_5bb5a3, 0x5bb5a3, int32_t, 1, 0),
    F(mode_583999, 0x583999, int32_t, 1, 0),
    F(has_entries_5b4ea5, 0x5b4ea5, int32_t, 1, 1),
    F(has_hotspots_5b4ea9, 0x5b4ea9, int32_t, 1, 1),
    F(selector_5bb50b, 0x5bb50b, int16_t, 1, 0),
    F(view_x_583186, 0x583186, int32_t, 1, 0),
    F(view_y_58318a, 0x58318a, int32_t, 1, 0),
    F(thread_arg_5b016f, 0x5b016f, int16_t, 1, 0),
    F(latch_5c39e5, 0x5c39e5, int32_t, 1, 0),
    F(delay_5b4c5a, 0x5b4c5a, int32_t, 1, 0),
    F(ready_5b4e0a, 0x5b4e0a, int16_t, 1, 0),
    F(vrect_5b4de8, 0x5b4de8, int32_t, 1, 0),
    F(vrect_5b4dec, 0x5b4dec, int32_t, 1, 0),
    F(vrect_5b4df0, 0x5b4df0, int32_t, 1, 0),
    F(vrect_5b4df4, 0x5b4df4, int32_t, 1, 0),
    F(clip_5bb583, 0x5bb583, int32_t, 1, 0),
};

#define FIELD_COUNT ((int)(sizeof(FIELDS) / sizeof(FIELDS[0])))

static int queue_index_for(int op)
{
    switch (op) {
    case A33_OP_TICK: return 0;
    case A33_OP_SURFACE_CREATE: return 1;
    case A33_OP_OVERLAY_LOAD: return 2;
    case A33_OP_THREAD_CREATE: return 3;
    default: return -1;
    }
}

static int host_op(void *context, int op, const A33OpArgs *args, int32_t *ret)
{
    Handle *h = (Handle *)context;
    LogEntry *e;
    int q = queue_index_for(op);
    int32_t value = 0;
    if (h->log_count >= A33O_LOG_MAX) return 1;
    if (q >= 0) {
        Queue *queue = &h->queues[q];
        if (queue->count == 0) {
            queue->exhausted = 1;
        } else if (queue->next < queue->count) {
            value = (int32_t)queue->values[queue->next++];
        } else {
            value = (int32_t)queue->values[queue->count - 1];
            queue->exhausted = 1; /* repeated: the Python side pads, so reaching here is reported */
        }
        *ret = value;
    }
    e = &h->log[h->log_count++];
    e->op = op;
    e->a = args->a;
    e->b = args->b;
    e->ret = value;
    e->snap = h->state;
    if (h->fail_at >= 0 && h->ops_seen++ == h->fail_at) return 1;
    return 0;
}

void *a33o_new(void)
{
    Handle *h = (Handle *)calloc(1u, sizeof(*h));
    if (h == NULL) return NULL;
    a33_state_init(&h->state);
    h->fail_at = -1;
    return h;
}

void a33o_free(void *handle)
{
    Handle *h = (Handle *)handle;
    int i;
    if (h == NULL) return;
    for (i = 0; i < A33O_ROWS; ++i) a33_set_free(&h->sets[i]);
    free(h);
}

int a33o_field_count(void) { return FIELD_COUNT; }

/* name (>= 40 bytes), address, size, count, signed, pointer flag */
int a33o_field_info(int i, char *name, uint32_t *address, int *size, int *count, int *is_signed, int *pointer_flag)
{
    if (i < 0 || i >= FIELD_COUNT) return 1;
    snprintf(name, 40, "%s", FIELDS[i].name);
    *address = FIELDS[i].address;
    *size = FIELDS[i].size;
    *count = FIELDS[i].count;
    *is_signed = FIELDS[i].is_signed;
    *pointer_flag = FIELDS[i].pointer_flag;
    return 0;
}

int a33o_sizeof_state(void) { return (int)sizeof(A33State); }

static int64_t load_value(const void *p, int size, int is_signed)
{
    switch (size) {
    case 1: return is_signed ? (int64_t)*(const int8_t *)p : (int64_t)*(const uint8_t *)p;
    case 2: {
        uint16_t v;
        memcpy(&v, p, 2);
        return is_signed ? (int64_t)(int16_t)v : (int64_t)v;
    }
    default: {
        uint32_t v;
        memcpy(&v, p, 4);
        return is_signed ? (int64_t)(int32_t)v : (int64_t)v;
    }
    }
}

static void store_value(void *p, int size, int64_t value)
{
    uint32_t v = (uint32_t)(uint64_t)value;
    switch (size) {
    case 1: *(uint8_t *)p = (uint8_t)v; break;
    case 2: {
        uint16_t w = (uint16_t)v;
        memcpy(p, &w, 2);
        break;
    }
    default: memcpy(p, &v, 4); break;
    }
}

int64_t a33o_peek(void *handle, int field, int index)
{
    Handle *h = (Handle *)handle;
    const Field *f;
    if (field < 0 || field >= FIELD_COUNT) return 0;
    f = &FIELDS[field];
    if (index < 0 || index >= f->count) return 0;
    return load_value((const uint8_t *)&h->state + f->offset + (uint32_t)index * (uint32_t)f->size, f->size, f->is_signed);
}

void a33o_poke(void *handle, int field, int index, int64_t value)
{
    Handle *h = (Handle *)handle;
    const Field *f;
    if (field < 0 || field >= FIELD_COUNT) return;
    f = &FIELDS[field];
    if (index < 0 || index >= f->count) return;
    store_value((uint8_t *)&h->state + f->offset + (uint32_t)index * (uint32_t)f->size, f->size, value);
}

void a33o_zero_state(void *handle)
{
    a33_state_init(&((Handle *)handle)->state);
}

int a33o_parse(void *handle, int row, const uint8_t *body, size_t length, char *why, int why_len)
{
    Handle *h = (Handle *)handle;
    const char *reason = "";
    int status;
    if (row < 0 || row >= A33O_ROWS) return A33_ERR_ARGUMENT;
    a33_set_free(&h->sets[row]);
    h->have_set[row] = 0;
    status = a33_set_parse(body, length, &h->sets[row], &reason);
    if (why != NULL && why_len > 0) snprintf(why, (size_t)why_len, "%s", reason != NULL ? reason : "");
    if (status == A33_OK) h->have_set[row] = 1;
    return status;
}

void a33o_script(void *handle, int queue, const int64_t *values, int count)
{
    Handle *h = (Handle *)handle;
    Queue *q;
    int i;
    if (queue < 0 || queue > 3) return;
    q = &h->queues[queue];
    memset(q, 0, sizeof(*q));
    if (count > A33O_QUEUE_MAX) count = A33O_QUEUE_MAX;
    for (i = 0; i < count; ++i) q->values[i] = (uint32_t)(uint64_t)values[i];
    q->count = count;
}

int a33o_exhausted(void *handle, int queue)
{
    Handle *h = (Handle *)handle;
    return queue >= 0 && queue <= 3 ? h->queues[queue].exhausted : 0;
}

int a33o_consumed(void *handle, int queue)
{
    Handle *h = (Handle *)handle;
    return queue >= 0 && queue <= 3 ? h->queues[queue].next : 0;
}

void a33o_set_fail(void *handle, int op_index)
{
    Handle *h = (Handle *)handle;
    h->fail_at = op_index;
    h->ops_seen = 0;
}

/* out[0] = request, out[1..4] = the four rect words (sign-extended) */
void a33o_cells_get(void *handle, int row, int32_t *out)
{
    Handle *h = (Handle *)handle;
    int i;
    out[0] = h->cells[row].request;
    for (i = 0; i < 4; ++i) out[1 + i] = h->cells[row].rect[i];
}

void a33o_cells_set(void *handle, int row, const int32_t *in)
{
    Handle *h = (Handle *)handle;
    int i;
    h->cells[row].request = in[0];
    for (i = 0; i < 4; ++i) h->cells[row].rect[i] = (int16_t)in[1 + i];
}

/* One visit of 0x42c221. Clears the log first; the log stays readable until the next step. */
int a33o_step(void *handle, int row, uint32_t phase, uint32_t *phase_after, int *initialized, int *finished, char *failure,
              int failure_len)
{
    Handle *h = (Handle *)handle;
    A33Host host;
    A33StepResult result;
    const char *why = "";
    int status;
    memset(&result, 0, sizeof(result));
    h->log_count = 0;
    h->ops_seen = 0;
    host.context = h;
    host.op = host_op;
    if (row < 0 || row >= A33O_ROWS || !h->have_set[row]) return A33_ERR_ARGUMENT;
    status = a33_step(&h->state, &h->sets[row], (int16_t)row, &h->cells[row], phase, &host, &result, &why);
    *phase_after = result.phase_after;
    *initialized = result.initialized;
    *finished = result.finished;
    if (failure != NULL && failure_len > 0) snprintf(failure, (size_t)failure_len, "%s", why != NULL ? why : "");
    return status;
}

/* a field of the state snapshot taken when log entry i was issued */
int64_t a33o_log_peek(void *handle, int i, int field, int index)
{
    const Handle *h = (const Handle *)handle;
    const Field *f;
    if (field < 0 || field >= FIELD_COUNT || i < 0 || i >= h->log_count) return 0;
    f = &FIELDS[field];
    if (index < 0 || index >= f->count) return 0;
    return load_value((const uint8_t *)&h->log[i].snap + f->offset + (uint32_t)index * (uint32_t)f->size, f->size, f->is_signed);
}

int a33o_log_count(void *handle) { return ((Handle *)handle)->log_count; }

void a33o_log_get(void *handle, int i, int32_t *out)
{
    const Handle *h = (const Handle *)handle;
    out[0] = h->log[i].op;
    out[1] = h->log[i].a;
    out[2] = h->log[i].b;
    out[3] = h->log[i].ret;
}
