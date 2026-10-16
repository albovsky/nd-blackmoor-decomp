/* RT-36 native side of the raw 0x2d oracle (tests/action_family_2d_runtime_original_oracle.py).
 *
 * One handle owns a D2Object, a D2World, up to eight parsed sets and a scripted host. The host answers every D2Op from
 * queues the oracle fills (the same numbers the original's stand-ins return, in the same order) and logs every call with its
 * arguments and return value so the oracle can compare the ordered op log with the original's. Nothing here decides
 * anything the kernel decides: it only answers and records. A queue that runs dry or a missing file-table entry is a
 * test-generation error and is reported through d2o_script_error(); it makes the op fail with a host error. */
#include <stdlib.h>
#include <string.h>

#include "action_family_2d_runtime.h"

#define MAX_LOG 8192
#define MAX_QUEUE 4096
#define MAX_FILES 2048
#define MAX_SURFACES 128
#define MAX_SETS 8
#define NAME_CAP 40

enum { Q_RAND, Q_TICK, Q_SURFACE, Q_THREAD, Q_BINK_OPEN, Q_BINK_PREPARE, Q_BINK_READY, Q_BINK_FRAME, Q_BINK_MORE, Q_COUNT };

typedef struct {
    int op;
    int32_t a, b, c, d;
    char name[NAME_CAP];
    int32_t ret;
} LogEntry;

typedef struct {
    char name[NAME_CAP];
    int variant;
    int32_t value;
} FileEntry;

typedef struct {
    uint32_t handle;
    int16_t w, h;
} SurfaceDims;

typedef struct {
    D2Object obj;
    D2World world;
    D2Set sets[MAX_SETS];
    int set_used[MAX_SETS];
    int32_t queue[Q_COUNT][MAX_QUEUE];
    unsigned qlen[Q_COUNT], qpos[Q_COUNT];
    FileEntry files[MAX_FILES];
    unsigned nfiles;
    SurfaceDims dims[MAX_SURFACES];
    unsigned ndims;
    LogEntry log[MAX_LOG];
    unsigned nlog;
    char why[160];
    char script_error[160];
    int fail_op; /* op number to fail (host failure injection), 0 = none */
    unsigned fail_after;
    unsigned op_count;
} Handle;

typedef struct {
    const char *name;
    size_t offset;
    size_t size;
    int is_signed;
} Field;

#define FIELD(label, member, type) {label, offsetof(D2Object, member), sizeof(((D2Object *)0)->member), ((type)-1) < 0}
static const Field OBJ_FIELDS[] = {
    FIELD("active", movie.active, int32_t),
    FIELD("mode", movie.mode, int32_t),
    FIELD("row", movie.row, int32_t),
    FIELD("state_1de", movie.state_1de, int32_t),
    FIELD("flag_206", movie.flag_206, int32_t),
    FIELD("pending_25a", movie.pending_25a, int32_t),
    FIELD("stream_state_4", stream_state_4, int32_t),
    FIELD("period_24", period_24, uint32_t),
    FIELD("decoder_172", decoder_172, int32_t),
    FIELD("buffers_182_0", buffers_182[0], uint32_t),
    FIELD("buffers_182_1", buffers_182[1], uint32_t),
    FIELD("buffers_182_2", buffers_182[2], uint32_t),
    FIELD("single_17a", single_17a, int32_t),
    FIELD("kind_17e", kind_17e, int32_t),
    FIELD("bink_id_18e", bink_id_18e, int32_t),
    FIELD("buffer_192", buffer_192, int16_t),
    FIELD("rect_1b2", rect_1b2, int32_t),
    FIELD("rect_1b6", rect_1b6, int32_t),
    FIELD("rect_1ba", rect_1ba, int32_t),
    FIELD("rect_1be", rect_1be, int32_t),
    FIELD("deadline_1c6", deadline_1c6, uint32_t),
    FIELD("frame_1ca", frame_1ca, int16_t),
    FIELD("word_1cc", word_1cc, int16_t),
    FIELD("word_1ce", word_1ce, int16_t),
    FIELD("ready_1d4", ready_1d4, int16_t),
    FIELD("thread_1d6", thread_1d6, uint32_t),
    FIELD("state_1da", state_1da, int32_t),
    FIELD("rects_0", rects[0], int32_t),
    FIELD("rects_1", rects[1], int32_t),
    FIELD("rects_2", rects[2], int32_t),
    FIELD("rects_3", rects[3], int32_t),
    FIELD("rects_4", rects[4], int32_t),
    FIELD("rects_5", rects[5], int32_t),
    FIELD("rects_6", rects[6], int32_t),
    FIELD("rects_7", rects[7], int32_t),
    FIELD("saved_202", saved_202, int32_t),
    FIELD("flag_20a", flag_20a, int32_t),
    FIELD("flag_20e", flag_20e, int32_t),
    FIELD("surface_212", surface_212, uint32_t),
    FIELD("kind_21a", kind_21a, int32_t),
    FIELD("scan_22e", scan_22e, int32_t),
    FIELD("frame_232", frame_232, int32_t),
    FIELD("group_hit_236", group_hit_236, int32_t),
    FIELD("action_23e", action_23e, int32_t),
    FIELD("clip_246", clip_246, int32_t),
    FIELD("group_24a", group_24a, int32_t),
    FIELD("deadline_24e", deadline_24e, uint32_t),
    FIELD("delay_252", delay_252, int32_t),
    FIELD("record_256", record_256, int32_t),
};

#undef FIELD
#define WFIELD(label, member, type) {label, offsetof(D2World, member), sizeof(((D2World *)0)->member), ((type)-1) < 0}
static const Field WORLD_FIELDS[] = {
    WFIELD("start_flag", start_flag, int32_t),
    WFIELD("g_5839a9", g_5839a9, int32_t),
    WFIELD("g_5d16cd", g_5d16cd, int32_t),
    WFIELD("g_5d1683", g_5d1683, int32_t),
    WFIELD("g_5d1639", g_5d1639, int32_t),
    WFIELD("g_5831c8", g_5831c8, int32_t),
    WFIELD("g_5831c6", g_5831c6, int16_t),
    WFIELD("entry_surface", entry_surface, uint32_t),
    WFIELD("entry_flag", entry_flag, int32_t),
    WFIELD("entry_type", entry_type, int32_t),
    WFIELD("entry_flag_49", entry_flag_49, int32_t),
    WFIELD("entry_word_4d", entry_word_4d, int16_t),
    WFIELD("scene_key", scene_key, int16_t),
    WFIELD("view_x", view_x, int32_t),
    WFIELD("view_y", view_y, int32_t),
    WFIELD("thread_arg", thread_arg, int16_t),
    WFIELD("back_buffer", back_buffer, uint32_t),
};
#undef WFIELD

static void script_error(Handle *h, const char *text)
{
    if (h->script_error[0] == '\0') {
        strncpy(h->script_error, text, sizeof(h->script_error) - 1u);
    }
}

static int pop(Handle *h, int queue, int32_t *out)
{
    if (h->qpos[queue] >= h->qlen[queue]) {
        script_error(h, "scripted queue exhausted");
        return 1;
    }
    *out = h->queue[queue][h->qpos[queue]++];
    return 0;
}

static void log_op(Handle *h, int op, const D2OpArgs *args, int32_t ret)
{
    LogEntry *e;
    if (h->nlog >= MAX_LOG) {
        script_error(h, "op log full");
        return;
    }
    e = &h->log[h->nlog++];
    memset(e, 0, sizeof(*e));
    e->op = op;
    e->a = args->a;
    e->b = args->b;
    e->c = args->c;
    e->d = args->d;
    if (args->name != NULL) {
        strncpy(e->name, args->name, NAME_CAP - 1u);
    }
    e->ret = ret;
}

static void note_dims(Handle *h, uint32_t handle, int16_t w, int16_t hh)
{
    for (unsigned i = 0; i < h->ndims; ++i) {
        if (h->dims[i].handle == handle) {
            h->dims[i].w = w;
            h->dims[i].h = hh;
            return;
        }
    }
    if (h->ndims < MAX_SURFACES) {
        h->dims[h->ndims].handle = handle;
        h->dims[h->ndims].w = w;
        h->dims[h->ndims].h = hh;
        ++h->ndims;
    }
}

static int host_op(void *context, int op, const D2OpArgs *args, int32_t *ret)
{
    Handle *h = (Handle *)context;
    int32_t value = 0;
    int q = -1;
    ++h->op_count;
    if (h->fail_op != 0 && h->fail_op == op && h->op_count > h->fail_after) {
        return 1;
    }
    switch (op) {
    case D2_OP_RAND: q = Q_RAND; break;
    case D2_OP_TICK: q = Q_TICK; break;
    case D2_OP_SURFACE_CREATE: q = Q_SURFACE; break;
    case D2_OP_THREAD_CREATE: q = Q_THREAD; break;
    case D2_OP_BINK_OPEN: q = Q_BINK_OPEN; break;
    case D2_OP_BINK_PREPARE: q = Q_BINK_PREPARE; break;
    case D2_OP_BINK_READY: q = Q_BINK_READY; break;
    case D2_OP_BINK_FRAME: q = Q_BINK_FRAME; break;
    case D2_OP_BINK_MORE: q = Q_BINK_MORE; break;
    case D2_OP_FILE_EXISTS: {
        unsigned i;
        int found = 0;
        for (i = 0; i < h->nfiles; ++i) {
            if (h->files[i].variant == args->a && strncmp(h->files[i].name, args->name, NAME_CAP - 1u) == 0) {
                value = h->files[i].value;
                found = 1;
                break;
            }
        }
        if (!found) {
            script_error(h, "file table entry missing");
            return 1;
        }
        break;
    }
    default:
        break;
    }
    if (q >= 0 && pop(h, q, &value) != 0) {
        return 1;
    }
    if (op == D2_OP_SURFACE_CREATE) {
        note_dims(h, (uint32_t)value, (int16_t)args->a, (int16_t)args->b);
    }
    *ret = value;
    log_op(h, op, args, value);
    return 0;
}

static int host_dims(void *context, uint32_t surface, int16_t *w, int16_t *hh)
{
    Handle *h = (Handle *)context;
    for (unsigned i = 0; i < h->ndims; ++i) {
        if (h->dims[i].handle == surface) {
            *w = h->dims[i].w;
            *hh = h->dims[i].h;
            return 0;
        }
    }
    script_error(h, "surface dims missing");
    return 1;
}

static D2Host make_host(Handle *h)
{
    D2Host host;
    host.context = h;
    host.op = host_op;
    host.surface_dims = host_dims;
    return host;
}

Handle *d2o_new(void)
{
    Handle *h = (Handle *)calloc(1u, sizeof(*h));
    return h;
}

static void free_sets(Handle *h)
{
    for (int i = 0; i < MAX_SETS; ++i) {
        if (h->set_used[i]) {
            d2_set_free(&h->sets[i]);
            h->set_used[i] = 0;
        }
    }
}

void d2o_free(Handle *h)
{
    if (h != NULL) {
        free_sets(h);
        free(h);
    }
}

/* Power-on state: 0x4ccd70 over zeroed storage. */
void d2o_reset_all(Handle *h)
{
    free_sets(h);
    memset(&h->obj, 0, sizeof(h->obj));
    d2_object_reset(&h->obj);
    d2_world_init(&h->world);
    memset(h->qlen, 0, sizeof(h->qlen));
    memset(h->qpos, 0, sizeof(h->qpos));
    h->nfiles = 0;
    h->ndims = 0;
    h->nlog = 0;
    h->why[0] = '\0';
    h->script_error[0] = '\0';
    h->fail_op = 0;
    h->fail_after = 0;
    h->op_count = 0;
}

int d2o_set_parse(Handle *h, int slot, const uint8_t *body, size_t length)
{
    const char *why = "none";
    int status;
    if (slot < 0 || slot >= MAX_SETS) {
        return D2_ERR_ARGUMENT;
    }
    if (h->set_used[slot]) {
        d2_set_free(&h->sets[slot]);
        h->set_used[slot] = 0;
    }
    status = d2_set_parse(body, length, &h->sets[slot], &why);
    if (status == D2_OK) {
        h->set_used[slot] = 1;
    }
    strncpy(h->why, why, sizeof(h->why) - 1u);
    return status;
}

/* What the loader leaves behind: the tables and the loader's row. */
void d2o_bind(Handle *h, int slot, int row)
{
    h->obj.set = &h->sets[slot];
    h->obj.action_23e = row;
}

void d2o_queue_set(Handle *h, int queue, const int32_t *values, unsigned count)
{
    if (count > MAX_QUEUE) {
        count = MAX_QUEUE;
    }
    memcpy(h->queue[queue], values, count * sizeof(int32_t));
    h->qlen[queue] = count;
    h->qpos[queue] = 0;
}

unsigned d2o_queue_left(const Handle *h, int queue) { return h->qlen[queue] - h->qpos[queue]; }

void d2o_file_set(Handle *h, const char *name, int variant, int value)
{
    if (h->nfiles < MAX_FILES) {
        FileEntry *e = &h->files[h->nfiles++];
        memset(e, 0, sizeof(*e));
        strncpy(e->name, name, NAME_CAP - 1u);
        e->variant = variant;
        e->value = value;
    }
}

void d2o_surface_dims(Handle *h, uint32_t handle, int w, int hh) { note_dims(h, handle, (int16_t)w, (int16_t)hh); }

void d2o_fail_op(Handle *h, int op, unsigned after)
{
    h->fail_op = op;
    h->fail_after = after;
}

const char *d2o_script_error(const Handle *h) { return h->script_error; }
const char *d2o_why(const Handle *h) { return h->why; }

unsigned d2o_nfields(void) { return (unsigned)(sizeof(OBJ_FIELDS) / sizeof(OBJ_FIELDS[0])); }
const char *d2o_field_name(unsigned i) { return OBJ_FIELDS[i].name; }
unsigned d2o_nworld(void) { return (unsigned)(sizeof(WORLD_FIELDS) / sizeof(WORLD_FIELDS[0])); }
const char *d2o_world_name(unsigned i) { return WORLD_FIELDS[i].name; }

static int64_t field_get(const void *base, const Field *f)
{
    const uint8_t *p = (const uint8_t *)base + f->offset;
    switch (f->size) {
    case 1: return f->is_signed ? (int64_t)*(const int8_t *)p : (int64_t)*(const uint8_t *)p;
    case 2: {
        int16_t s;
        uint16_t u;
        if (f->is_signed) { memcpy(&s, p, 2); return s; }
        memcpy(&u, p, 2); return u;
    }
    default: {
        int32_t s;
        uint32_t u;
        if (f->is_signed) { memcpy(&s, p, 4); return s; }
        memcpy(&u, p, 4); return u;
    }
    }
}

static void field_set(void *base, const Field *f, int64_t v)
{
    uint8_t *p = (uint8_t *)base + f->offset;
    if (f->size == 2) {
        int16_t s = (int16_t)v;
        memcpy(p, &s, 2);
    } else {
        int32_t s = (int32_t)v;
        memcpy(p, &s, 4);
    }
}

int64_t d2o_get(const Handle *h, unsigned i) { return field_get(&h->obj, &OBJ_FIELDS[i]); }
void d2o_set(Handle *h, unsigned i, int64_t v) { field_set(&h->obj, &OBJ_FIELDS[i], v); }
int64_t d2o_world_get(const Handle *h, unsigned i) { return field_get(&h->world, &WORLD_FIELDS[i]); }
void d2o_world_set(Handle *h, unsigned i, int64_t v) { field_set(&h->world, &WORLD_FIELDS[i], v); }

int d2o_has_set(const Handle *h) { return h->obj.set != NULL; }
void d2o_get_name(const Handle *h, char *out) { memcpy(out, h->obj.name_159, D2_NAME_BYTES); }
void d2o_set_name(Handle *h, const char *name) { memset(h->obj.name_159, 0, D2_NAME_BYTES); strncpy(h->obj.name_159, name, D2_NAME_BYTES - 1u); }
void d2o_get_label(const Handle *h, char *out) { memcpy(out, h->world.entry_label, sizeof(h->world.entry_label)); }
void d2o_set_label(Handle *h, const char *text)
{
    memset(h->world.entry_label, 0, sizeof(h->world.entry_label));
    strncpy(h->world.entry_label, text, sizeof(h->world.entry_label) - 1u);
}

void d2o_log_clear(Handle *h)
{
    h->nlog = 0;
    h->script_error[0] = '\0';
}
unsigned d2o_log_count(const Handle *h) { return h->nlog; }
int d2o_log_get(const Handle *h, unsigned i, int32_t *out, char *name)
{
    if (i >= h->nlog) {
        return 1;
    }
    out[0] = h->log[i].op;
    out[1] = h->log[i].a;
    out[2] = h->log[i].b;
    out[3] = h->log[i].c;
    out[4] = h->log[i].d;
    out[5] = h->log[i].ret;
    memcpy(name, h->log[i].name, NAME_CAP);
    return 0;
}

/* out: status, phase_after, retire_row, initialized, stopped */
int d2o_step(Handle *h, int row, uint32_t phase, int slot, int32_t *out)
{
    D2Host host = make_host(h);
    D2StepResult r;
    const char *failure = "none";
    int status;
    memset(&r, 0, sizeof(r));
    status = d2_step(&h->obj, &h->sets[slot], (int16_t)row, phase, &h->world, &host, &r, &failure);
    strncpy(h->why, failure != NULL ? failure : "none", sizeof(h->why) - 1u);
    out[0] = (int32_t)r.phase_after;
    out[1] = r.retire_row;
    out[2] = r.initialized;
    out[3] = r.stopped;
    return status;
}

int d2o_stop(Handle *h, int32_t *retire_row)
{
    D2Host host = make_host(h);
    *retire_row = D2_NO_ROW;
    return d2_stop(&h->obj, &h->world, &host, retire_row);
}

int d2o_destruct(Handle *h, int32_t *erased)
{
    D2Host host = make_host(h);
    *erased = D2_NO_ROW;
    return d2_destruct(&h->obj, &host, erased);
}

void d2o_register(Handle *h) { d2_register_entry(&h->obj, &h->world); }

/* out: valid, surface, target, src[4], dst[4] */
int d2o_render(const Handle *h, int32_t *out)
{
    D2RenderPlan p;
    int status = d2_render_plan(&h->obj, &h->world, &p);
    out[0] = p.valid;
    out[1] = (int32_t)p.surface;
    out[2] = (int32_t)p.target;
    for (int k = 0; k < 4; ++k) {
        out[3 + k] = p.src[k];
        out[7 + k] = p.dst[k];
    }
    return status;
}

/* Parsed-set accessors: the oracle compares them with the tables the original loader built. */
int d2o_set_info(const Handle *h, int slot, int32_t *out)
{
    const D2Set *s = &h->sets[slot];
    if (!h->set_used[slot]) {
        return 1;
    }
    out[0] = s->mode_word;
    out[1] = s->entry_count;
    out[2] = s->group_count;
    return 0;
}

const char *d2o_set_name_of(const Handle *h, int slot) { return h->sets[slot].name; }

/* entry fields: word_21, word_23, delay_min, delay_max, weight, record_count */
int d2o_entry_info(const Handle *h, int slot, int i, int32_t *out, char *name)
{
    const D2Entry *e = &h->sets[slot].entries[i];
    out[0] = e->word_21;
    out[1] = e->word_23;
    out[2] = e->delay_min;
    out[3] = e->delay_max;
    out[4] = e->weight;
    out[5] = e->record_count;
    memcpy(name, e->name, D2_NAME_BYTES);
    return 0;
}

int d2o_record_info(const Handle *h, int slot, int i, int j, int32_t *out, char *name)
{
    const D2Record *r = &h->sets[slot].entries[i].records[j];
    out[0] = r->weight;
    memcpy(name, r->name, D2_NAME_BYTES);
    return 0;
}

/* group: key, src[4], dst[4] */
int d2o_group_info(const Handle *h, int slot, int i, int32_t *out)
{
    const D2Group *g = &h->sets[slot].groups[i];
    out[0] = g->key;
    for (int k = 0; k < 4; ++k) {
        out[1 + k] = g->src[k];
        out[5 + k] = g->dst[k];
    }
    return 0;
}
