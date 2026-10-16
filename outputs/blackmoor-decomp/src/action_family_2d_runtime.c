#include "action_family_2d_runtime.h"

#include <stdlib.h>
#include <string.h>

#define HEADER_BYTES 39u
#define ENTRY_BYTES 49u
#define RECORD_BYTES 35u
#define GROUP_BYTES 34u

#define RANDOM_SET_NAME "RandomMovie"
#define ENTRY_LABEL "RAMDOM MOVIE"

static uint16_t rd16(const uint8_t *p) { return (uint16_t)(p[0] | (p[1] << 8)); }
static uint32_t rd32(const uint8_t *p) { return (uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24); }

static int name_ok(const uint8_t *p)
{
    return memchr(p, 0, D2_NAME_BYTES) != NULL;
}

void d2_set_free(D2Set *set)
{
    if (set == NULL) {
        return;
    }
    if (set->entries != NULL) {
        for (int i = 0; i < set->entry_count; ++i) {
            free(set->entries[i].records);
        }
    }
    free(set->entries);
    free(set->groups);
    memset(set, 0, sizeof(*set));
}

int d2_set_parse(const uint8_t *body, size_t length, D2Set *out, const char **why)
{
    const char *reason = "none";
    size_t pos = HEADER_BYTES;
    int16_t entries;
    int16_t groups;
    D2Set set;
    memset(&set, 0, sizeof(set));
    if (body == NULL || out == NULL) {
        if (why != NULL) *why = "0x2d parse: null argument";
        return D2_ERR_ARGUMENT;
    }
    if (length < HEADER_BYTES) { reason = "0x2d body shorter than the 39-byte header"; goto bad; }
    if (!name_ok(body)) { reason = "0x2d header name has no NUL inside its 33 bytes"; goto bad; }
    memcpy(set.name, body, D2_NAME_BYTES);
    set.mode_word = (int16_t)rd16(body + 0x21);
    entries = (int16_t)rd16(body + 0x23);
    groups = (int16_t)rd16(body + 0x25);
    if (entries < 0 || groups < 0) { reason = "0x2d negative entry or group count"; goto bad; }
    set.entry_count = entries;
    set.group_count = groups;
    if (entries > 0) {
        set.entries = (D2Entry *)calloc((size_t)entries, sizeof(D2Entry));
        if (set.entries == NULL) { reason = "0x2d entry allocation"; goto bad; }
    }
    for (int i = 0; i < entries; ++i) {
        const uint8_t *e;
        D2Entry *entry = &set.entries[i];
        int16_t records;
        if (length - pos < ENTRY_BYTES) { reason = "0x2d body ends inside an entry"; goto bad; }
        e = body + pos;
        if (!name_ok(e)) { reason = "0x2d entry name has no NUL inside its 33 bytes"; goto bad; }
        memcpy(entry->name, e, D2_NAME_BYTES);
        entry->word_21 = (int16_t)rd16(e + 0x21);
        entry->word_23 = (int16_t)rd16(e + 0x23);
        entry->delay_min = (int32_t)rd32(e + 0x25);
        entry->delay_max = (int32_t)rd32(e + 0x29);
        entry->weight = (int16_t)rd16(e + 0x2d);
        records = (int16_t)rd16(e + 0x2f);
        if (records < 0) { reason = "0x2d negative record count"; goto bad; }
        entry->record_count = records;
        pos += ENTRY_BYTES;
        if ((length - pos) / RECORD_BYTES < (size_t)records) { reason = "0x2d body ends inside the records of an entry"; goto bad; }
        if (records > 0) {
            entry->records = (D2Record *)calloc((size_t)records, sizeof(D2Record));
            if (entry->records == NULL) { reason = "0x2d record allocation"; goto bad; }
        }
        for (int j = 0; j < records; ++j) {
            const uint8_t *r = body + pos + (size_t)j * RECORD_BYTES;
            if (!name_ok(r)) { reason = "0x2d record name has no NUL inside its 33 bytes"; goto bad; }
            memcpy(entry->records[j].name, r, D2_NAME_BYTES);
            entry->records[j].weight = (int16_t)rd16(r + 0x21);
        }
        pos += (size_t)records * RECORD_BYTES;
    }
    if ((length - pos) / GROUP_BYTES < (size_t)groups) { reason = "0x2d body ends inside the groups"; goto bad; }
    if (groups > 0) {
        set.groups = (D2Group *)calloc((size_t)groups, sizeof(D2Group));
        if (set.groups == NULL) { reason = "0x2d group allocation"; goto bad; }
    }
    for (int i = 0; i < groups; ++i) {
        const uint8_t *g = body + pos + (size_t)i * GROUP_BYTES;
        set.groups[i].key = (int16_t)rd16(g);
        for (int k = 0; k < 4; ++k) {
            set.groups[i].src[k] = (int32_t)rd32(g + 2 + 4 * k);
            set.groups[i].dst[k] = (int32_t)rd32(g + 0x12 + 4 * k);
        }
    }
    *out = set;
    if (why != NULL) *why = "none";
    return D2_OK;
bad:
    d2_set_free(&set);
    if (why != NULL) *why = reason;
    return D2_ERR_BODY;
}

void d2_world_init(D2World *world)
{
    memset(world, 0, sizeof(*world));
}

/* 0x4ccdab. */
void d2_object_reset(D2Object *o)
{
    /* memset of +8..+0x1d6 and the individual stores. The host-owned stream fields in that span are zeroed too. */
    o->period_24 = 0;
    o->decoder_172 = 0;
    memset(o->buffers_182, 0, sizeof(o->buffers_182));
    memset(o->name_159, 0, sizeof(o->name_159));
    o->bink_id_18e = 0;
    o->buffer_192 = 0;
    o->rect_1b2 = o->rect_1b6 = o->rect_1ba = o->rect_1be = 0;
    o->deadline_1c6 = 0;
    o->frame_1ca = 0;
    o->word_1cc = 0;
    o->word_1ce = 0;
    o->ready_1d4 = 0;
    o->movie.active = 0;
    o->group_hit_236 = 0;
    o->movie.flag_206 = 0;
    o->flag_20a = 0;
    o->flag_20e = 0;
    o->surface_212 = 0;
    o->thread_1d6 = 0;
    o->set = NULL;
    o->ring_17a = 1;
    o->kind_17e = 0;
    o->movie.state_1de = 0;
    o->frame_232 = -1;
    o->movie.mode = 2;
    o->action_23e = -1;
    o->movie.row = -1;
    o->clip_246 = -1;
    o->group_24a = -1;
    o->deadline_24e = 0;
    o->record_256 = -1;
    /* Not written by the original reset (outside the +8..+0x1d6 span and its stores): +0x4, +0x1da, the rectangles
     * +0x1e2..+0x1fe, +0x202, +0x21a, +0x22e, +0x252 and +0x25a. */
}

static int op_call(const D2Host *h, int op, const D2OpArgs *args, int32_t *ret, const char **why)
{
    int32_t scratch = 0;
    D2OpArgs none;
    if (h == NULL || h->op == NULL) {
        *why = "0x2d host op missing";
        return D2_ERR_HOST;
    }
    if (args == NULL) {
        memset(&none, 0, sizeof(none));
        args = &none;
    }
    if (h->op(h->context, op, args, ret != NULL ? ret : &scratch) != 0) {
        *why = "0x2d host op failed";
        return D2_ERR_HOST;
    }
    return D2_OK;
}

#define TRY(expr)                                                                                                      \
    do {                                                                                                               \
        int try_status_ = (expr);                                                                                      \
        if (try_status_ != D2_OK) {                                                                                    \
            return try_status_;                                                                                        \
        }                                                                                                              \
    } while (0)

static int simple_op(const D2Host *h, int op, int32_t a, const char **why)
{
    D2OpArgs args;
    memset(&args, 0, sizeof(args));
    args.a = a;
    return op_call(h, op, &args, NULL, why);
}

static int value_op(const D2Host *h, int op, int32_t a, int32_t b, int32_t *ret, const char **why)
{
    D2OpArgs args;
    memset(&args, 0, sizeof(args));
    args.a = a;
    args.b = b;
    return op_call(h, op, &args, ret, why);
}

static int32_t wrap_sub1(int32_t hi, int32_t lo)
{
    return (int32_t)((uint32_t)hi - (uint32_t)lo + 1u);
}

/* 0x4ccef1 */
static int teardown_stream(D2Object *o, const D2Host *h, const char **why)
{
    if (o->thread_1d6 != 0) {
        TRY(simple_op(h, D2_OP_STREAM_POLL, 0, why));
        o->stream_state_4 = 2;
        TRY(simple_op(h, D2_OP_THREAD_STOP, (int32_t)o->thread_1d6, why));
        if (o->thread_1d6 != 0) {
            TRY(simple_op(h, D2_OP_THREAD_DELETE, (int32_t)o->thread_1d6, why));
        }
        o->thread_1d6 = 0;
        TRY(simple_op(h, D2_OP_STREAM_RELEASE, 0, why));
        o->stream_state_4 = 0;
    }
    TRY(simple_op(h, D2_OP_Z_UNREGISTER_A, 0, why));
    TRY(simple_op(h, D2_OP_Z_UNREGISTER_B, 0, why));
    TRY(simple_op(h, D2_OP_BINK_RELEASE, o->bink_id_18e, why));
    return D2_OK;
}

/* 0x4ccfbd */
static int release_surface(D2Object *o, const D2Host *h, const char **why)
{
    if (o->surface_212 != 0) {
        TRY(simple_op(h, D2_OP_SURFACE_RELEASE, (int32_t)o->surface_212, why));
        o->surface_212 = 0;
    }
    return D2_OK;
}

/* 0x4ccff5: the row erase. Reports the erased row (the caller retires it) and drops the tables. */
static void erase_row(D2Object *o, int32_t *erased)
{
    *erased = D2_NO_ROW;
    if (o->action_23e != -1) {
        *erased = o->action_23e;
        o->set = NULL;
        o->action_23e = -1;
    }
}

int d2_destruct(D2Object *o, const D2Host *h, int32_t *erased_row)
{
    const char *why = "none";
    int32_t erased;
    if (o == NULL || h == NULL) {
        return D2_ERR_ARGUMENT;
    }
    TRY(teardown_stream(o, h, &why));
    TRY(release_surface(o, h, &why));
    erase_row(o, &erased);
    d2_object_reset(o);
    if (erased_row != NULL) {
        *erased_row = erased;
    }
    return D2_OK;
}

int d2_stop(D2Object *o, D2World *w, const D2Host *h, int32_t *retire_row)
{
    int32_t erased = D2_NO_ROW;
    int status;
    if (o == NULL || w == NULL || h == NULL) {
        return D2_ERR_ARGUMENT;
    }
    /* 0x4ceb3b */
    o->movie.active = 0;
    w->entry_flag = 0;
    w->g_5839a9 = o->saved_202;
    w->g_5831c8 = 1; /* 0x4d36ed */
    w->g_5831c6 = 0;
    status = d2_destruct(o, h, &erased);
    if (retire_row != NULL) {
        *retire_row = erased;
    }
    return status;
}

/* 0x4cf0a9: rand() % count, or the raw value for -1. Zero is the original's division fault. */
static int rand_mod(const D2Host *h, int32_t count, int32_t *out, const char **why)
{
    int32_t r = 0;
    TRY(value_op(h, D2_OP_RAND, 0, 0, &r, why));
    if (count == -1) {
        *out = r;
        return D2_OK;
    }
    if (count == 0) {
        *why = "0x2d random pick divides by zero";
        return D2_ERR_BODY;
    }
    *out = (int32_t)((int64_t)r % (int64_t)count);
    return D2_OK;
}

/* 0x4cf026: strcmp over the entry names; -1 when none. */
static int32_t lookup_entry(const D2Set *set, const char *name)
{
    for (int i = 0; i < set->entry_count; ++i) {
        if (strcmp(name, set->entries[i].name) == 0) {
            return i;
        }
    }
    return -1;
}

/* 0x4cf0ce: the weighted pick of the next record; -1 = stay on the clip. */
static int pick_record(const D2Object *o, const D2Host *h, int32_t *out, const char **why)
{
    const D2Entry *entry;
    int32_t total;
    int32_t r;
    int32_t lo = 0;
    int32_t hi = 0;
    if (o->set == NULL || o->clip_246 < 0 || o->clip_246 >= o->set->entry_count) {
        *why = "0x2d clip index outside the entry table";
        return D2_ERR_ARGUMENT;
    }
    entry = &o->set->entries[o->clip_246];
    total = entry->weight;
    for (int j = 0; j < entry->record_count; ++j) {
        total = (int32_t)((uint32_t)total + (uint32_t)(int32_t)entry->records[j].weight);
    }
    TRY(rand_mod(h, total, &r, why));
    if (entry->weight > 0) {
        lo = 0;
        hi = entry->weight;
        if (r >= lo && r < hi) {
            *out = -1;
            return D2_OK;
        }
    }
    for (int j = 0; j < entry->record_count; ++j) {
        int32_t w = entry->records[j].weight;
        if (w <= 0) {
            continue;
        }
        lo = hi;
        hi = (int32_t)((uint32_t)hi + (uint32_t)w);
        if (r >= lo && r < hi) {
            *out = j;
            return D2_OK;
        }
    }
    *out = -1;
    return D2_OK;
}

/* 0x4cdfd3: returns D2_OK with *loaded = 0 for the original's "return 0" paths. */
static int load_clip(D2Object *o, const D2World *w, const D2Host *h, int32_t index, int *loaded, const char **why)
{
    const D2Entry *entry;
    int32_t width;
    int32_t height;
    int32_t ret = 0;
    int kind = -1;
    D2OpArgs args;
    *loaded = 0;
    if (o->set == NULL) {
        return D2_OK;
    }
    if (index < 0 || index >= o->set->entry_count) {
        *why = "0x2d clip index outside the entry table";
        return D2_ERR_ARGUMENT;
    }
    entry = &o->set->entries[index];
    o->kind_21a = -1;
    for (int variant = 0; variant < 4 && kind == -1; ++variant) {
        memset(&args, 0, sizeof(args));
        args.a = variant;
        args.name = entry->name;
        TRY(op_call(h, D2_OP_FILE_EXISTS, &args, &ret, why));
        if (ret != 0) {
            kind = variant < 2 ? 1 : 0;
            o->kind_21a = kind;
        }
    }
    if (kind == -1) {
        return D2_OK;
    }
    {
        size_t length = strlen(entry->name) + 1u;
        memcpy(o->name_159, entry->name, length);
    }
    o->word_1cc = 1;
    o->word_1ce = 2;
    o->kind_17e = o->kind_21a;
    TRY(simple_op(h, D2_OP_STREAM_RESET, 0, why));
    width = wrap_sub1(o->rect_1ba, o->rect_1b2);
    height = wrap_sub1(o->rect_1be, o->rect_1b6);
    if (o->surface_212 != 0) {
        int16_t sw = 0;
        int16_t sh = 0;
        if (h->surface_dims == NULL || h->surface_dims(h->context, o->surface_212, &sw, &sh) != 0) {
            *why = "0x2d surface size query failed";
            return D2_ERR_HOST;
        }
        if (sw != width || sh != height) {
            return D2_OK; /* logged, return 0 */
        }
    }
    if (kind == 0) {
        if (o->surface_212 == 0) {
            memset(&args, 0, sizeof(args));
            args.a = width;
            args.b = height;
            args.c = 8;
            args.d = 0;
            TRY(op_call(h, D2_OP_SURFACE_CREATE, &args, &ret, why));
            o->surface_212 = (uint32_t)ret;
        }
        TRY(simple_op(h, D2_OP_Z_REGISTER, 0, why));
        if (o->thread_1d6 == 0) {
            int32_t handle = 0;
            TRY(value_op(h, D2_OP_THREAD_CREATE, w->thread_arg, 0, &handle, why));
            o->thread_1d6 = (uint32_t)handle;
            if (o->thread_1d6 == 0) {
                return D2_OK;
            }
        }
        o->frame_1ca = entry->word_21;
        o->ready_1d4 = 0;
        TRY(simple_op(h, D2_OP_THREAD_RESUME, (int32_t)o->thread_1d6, why));
    } else {
        if (o->surface_212 == 0) {
            memset(&args, 0, sizeof(args));
            args.a = width;
            args.b = height;
            args.c = 8;
            args.d = 1;
            TRY(op_call(h, D2_OP_SURFACE_CREATE, &args, &ret, why));
            o->surface_212 = (uint32_t)ret;
        }
        TRY(value_op(h, D2_OP_BINK_OPEN, o->bink_id_18e, 0, &ret, why));
        if (ret != 0) {
            return D2_OK;
        }
        TRY(value_op(h, D2_OP_BINK_PREPARE, o->bink_id_18e, (int32_t)entry->word_21 + 1, &ret, why));
        if (ret == 0) {
            return D2_OK;
        }
    }
    o->state_1da = 0;
    o->flag_20a = 0;
    o->flag_20e = 0;
    o->frame_232 = -1;
    *loaded = 1;
    return D2_OK;
}

/* 0x4ceb8c */
static void set_rects(D2Object *o, const D2World *w)
{
    const D2Group *g;
    if (o->set == NULL || o->group_24a < 0 || o->group_24a >= o->set->group_count) {
        return;
    }
    g = &o->set->groups[o->group_24a];
    for (int k = 0; k < 4; ++k) {
        o->rects[k] = g->src[k];
    }
    o->rects[4] = (int32_t)((uint32_t)g->dst[0] + (uint32_t)w->view_x);
    o->rects[5] = (int32_t)((uint32_t)g->dst[1] + (uint32_t)w->view_y);
    o->rects[6] = (int32_t)((uint32_t)g->dst[2] + (uint32_t)w->view_x);
    o->rects[7] = (int32_t)((uint32_t)g->dst[3] + (uint32_t)w->view_y);
}

/* 0x4cec6c */
static void advance_frame(D2Object *o)
{
    if (o->set == NULL || o->clip_246 < 0 || o->clip_246 >= o->set->entry_count) {
        return;
    }
    o->frame_1ca = (int16_t)(uint16_t)(o->frame_1ca + 1);
    if (o->frame_1ca > o->set->entries[o->clip_246].word_23) {
        o->frame_1ca = o->set->entries[o->clip_246].word_23;
    }
}

static int tick(const D2Host *h, uint32_t *out, const char **why)
{
    int32_t t = 0;
    TRY(value_op(h, D2_OP_TICK, 0, 0, &t, why));
    *out = (uint32_t)t;
    return D2_OK;
}

static int frame_copy(const D2Object *o, const D2Host *h, const char **why)
{
    return simple_op(h, D2_OP_FRAME_COPY, o->ring_17a == 0 ? -1 : (int32_t)o->buffer_192, why);
}

/* 0x4ce602: one pass of an AVF clip. */
static int step_avf(D2Object *o, const D2World *w, const D2Host *h, const char **why)
{
    const D2Entry *entry;
    uint32_t now;
    if (o->set == NULL || o->clip_246 < 0 || o->clip_246 >= o->set->entry_count) {
        *why = "0x2d clip index outside the entry table";
        return D2_ERR_ARGUMENT;
    }
    entry = &o->set->entries[o->clip_246];
    if (o->state_1da == 0) {
        if (o->ready_1d4 != 0) {
            TRY(frame_copy(o, h, why));
            o->frame_232 = o->frame_1ca;
            o->movie.flag_206 = 1;
            o->flag_20a = 1;
            set_rects(o, w);
            advance_frame(o);
            TRY(tick(h, &now, why));
            o->deadline_1c6 = now + o->period_24;
            if (entry->word_23 == o->frame_232) {
                o->flag_20e = 1;
            }
            if (o->flag_20e == 0) {
                o->ready_1d4 = 0;
            }
            o->state_1da = 4;
        }
    } else if (o->state_1da == 4) {
        TRY(tick(h, &now, why));
        if (now < o->deadline_1c6) {
            return D2_OK;
        }
        if (o->flag_20e != 0) {
            o->movie.state_1de = 3;
            return D2_OK;
        }
        if (o->ready_1d4 != 0 && o->flag_20e == 0) {
            TRY(frame_copy(o, h, why));
            o->frame_232 = o->frame_1ca;
            o->movie.flag_206 = 1;
            set_rects(o, w);
            if (entry->word_23 == o->frame_232) {
                o->flag_20e = 1;
            }
            TRY(tick(h, &now, why));
            o->deadline_1c6 = now + o->period_24;
            if (o->flag_20e == 0) {
                advance_frame(o);
                o->ready_1d4 = 0;
            }
        }
    }
    return D2_OK;
}

/* One Bink frame: the 0x4befc8 / 0x4bf098 / 0x4bee2c triple. */
static int bink_draw(D2Object *o, const D2Host *h, const char **why)
{
    int32_t frame = 0;
    D2OpArgs args;
    TRY(simple_op(h, D2_OP_BINK_NEXT, o->bink_id_18e, why));
    memset(&args, 0, sizeof(args));
    args.a = o->bink_id_18e;
    args.b = (int32_t)o->surface_212;
    TRY(op_call(h, D2_OP_BINK_BLIT, &args, NULL, why));
    TRY(value_op(h, D2_OP_BINK_FRAME, o->bink_id_18e, 0, &frame, why));
    o->frame_232 = (int32_t)((uint32_t)frame - 1u);
    return D2_OK;
}

/* 0x4ce8ea: one pass of a Bink clip. */
static int step_bink(D2Object *o, const D2World *w, const D2Host *h, const char **why)
{
    const D2Entry *entry;
    int32_t ret = 0;
    if (o->set == NULL || o->clip_246 < 0 || o->clip_246 >= o->set->entry_count) {
        *why = "0x2d clip index outside the entry table";
        return D2_ERR_ARGUMENT;
    }
    entry = &o->set->entries[o->clip_246];
    if (o->state_1da == 0) {
        TRY(value_op(h, D2_OP_BINK_READY, o->bink_id_18e, 0, &ret, why));
        if (ret != 0) {
            TRY(bink_draw(o, h, why));
            o->movie.flag_206 = 1;
            o->flag_20a = 1;
            set_rects(o, w);
            TRY(value_op(h, D2_OP_BINK_MORE, o->bink_id_18e, 0, &ret, why));
            if (ret != 0 && o->frame_232 != entry->word_23) {
                o->state_1da = 4;
            } else {
                o->movie.state_1de = 3;
            }
        }
    } else if (o->state_1da == 4) {
        TRY(value_op(h, D2_OP_BINK_READY, o->bink_id_18e, 0, &ret, why));
        if (ret != 0) {
            TRY(bink_draw(o, h, why));
            o->movie.flag_206 = 1;
            set_rects(o, w);
            TRY(value_op(h, D2_OP_BINK_MORE, o->bink_id_18e, 0, &ret, why));
            if (ret == 0 || o->frame_232 == entry->word_23) {
                o->movie.state_1de = 3;
            }
        }
    }
    return D2_OK;
}

/* 0x4cd76d: phase 0. */
static int phase0(D2Object *o, const D2Set *set, D2World *w, const D2Host *h, D2StepResult *res, const char **why)
{
    int loaded = 0;
    int32_t clip;
    if (o->movie.active != 0) {
        *why = "0x2d: the random-movie object is already active (fatal 0x4c97b4)";
        return D2_ERR_FATAL;
    }
    TRY(teardown_stream(o, h, why));
    TRY(release_surface(o, h, why));
    o->movie.active = 1;
    o->buffer_192 = 0;
    w->start_flag = 1;
    w->g_5831c8 = 1; /* 0x4d36ed */
    w->g_5831c6 = 0;
    o->saved_202 = w->g_5839a9;
    if (set->mode_word == 1) {
        w->g_5839a9 = 0;
        o->ring_17a = 1;
    } else {
        w->g_5839a9 = 1;
        o->ring_17a = 0;
        w->g_5d16cd = 0;
        w->g_5d1683 = 0;
        w->g_5d1639 = 0;
    }
    o->clip_246 = -1;
    o->movie.pending_25a = 0;
    if (strcmp(set->name, RANDOM_SET_NAME) == 0) {
        if (set->entry_count <= 0) {
            *why = "0x2d: random set without entries (fatal 0x4c97b4)";
            return D2_ERR_FATAL;
        }
        if (set->entry_count == 1) {
            o->clip_246 = 0;
        } else {
            TRY(rand_mod(h, set->entry_count, &clip, why));
            o->clip_246 = clip;
        }
    } else {
        o->clip_246 = lookup_entry(set, set->name);
        if (o->clip_246 == -1) {
            *why = "0x2d: the set names no entry (fatal 0x4c97b4)";
            return D2_ERR_FATAL;
        }
    }
    TRY(load_clip(o, w, h, o->clip_246, &loaded, why));
    if (!loaded) {
        *why = "0x2d: the first clip did not load (fatal 0x4c97b4)";
        return D2_ERR_FATAL;
    }
    o->group_24a = -1;
    w->entry_surface = o->surface_212;
    o->movie.state_1de = 0;
    res->phase_after = 1;
    res->initialized = 1;
    return D2_OK;
}

/* 0x4cdb26: phase 1, every pass. */
static int phase1(D2Object *o, const D2Set *set, D2World *w, const D2Host *h, const char **why)
{
    if (set->mode_word != 1) {
        w->g_5839a9 = 1;
        w->g_5d1639 = 0;
        w->g_5d16cd = 0;
        w->g_5d1683 = 0;
    }
    w->entry_flag = 0;
    o->group_hit_236 = 0;
    o->group_24a = -1;
    for (o->scan_22e = 0; o->scan_22e < set->group_count; ++o->scan_22e) {
        if (set->groups[o->scan_22e].key == w->scene_key) {
            o->group_hit_236 = 1;
            w->entry_flag = 1;
            o->group_24a = o->scan_22e;
            break;
        }
    }
    switch (o->movie.state_1de) {
    case 0:
        if (o->group_hit_236 != 0) {
            if (o->kind_21a != 1) {
                TRY(step_avf(o, w, h, why));
            } else {
                TRY(step_bink(o, w, h, why));
            }
        }
        break;
    case 1: {
        uint32_t now;
        TRY(tick(h, &now, why));
        if (now >= o->deadline_24e) {
            o->movie.state_1de = 3;
        }
        break;
    }
    case 3: {
        const D2Entry *entry;
        int32_t pick = -1;
        int loaded = 0;
        TRY(teardown_stream(o, h, why));
        TRY(pick_record(o, h, &pick, why));
        o->record_256 = pick;
        entry = &set->entries[o->clip_246];
        if (pick == -1) {
            uint32_t now;
            if (entry->delay_min >= entry->delay_max) {
                o->delay_252 = entry->delay_min;
            } else {
                int32_t r = 0;
                int32_t span = (int32_t)((uint32_t)entry->delay_max - (uint32_t)entry->delay_min);
                TRY(rand_mod(h, span, &r, why));
                o->delay_252 = (int32_t)((uint32_t)entry->delay_min + (uint32_t)r);
            }
            TRY(tick(h, &now, why));
            o->deadline_24e = now + (uint32_t)o->delay_252;
            o->movie.state_1de = 1;
            o->movie.pending_25a = 1;
        } else {
            o->clip_246 = lookup_entry(set, entry->records[pick].name);
            if (o->clip_246 == -1) {
                *why = "0x2d: a record names no entry (fatal 0x4c97b4)";
                return D2_ERR_FATAL;
            }
            TRY(load_clip(o, w, h, o->clip_246, &loaded, why));
            if (!loaded) {
                *why = "0x2d: the next clip did not load (fatal 0x4c97b4)";
                return D2_ERR_FATAL;
            }
            o->movie.state_1de = 0;
        }
        break;
    }
    default:
        break;
    }
    return D2_OK;
}

int d2_step(D2Object *o, const D2Set *set, int16_t row, uint32_t phase, D2World *w, const D2Host *h,
            D2StepResult *res, const char **failure)
{
    const char *why = "none";
    int status = D2_OK;
    D2StepResult local;
    memset(&local, 0, sizeof(local));
    local.phase_after = phase;
    local.retire_row = D2_NO_ROW;
    if (o == NULL || set == NULL || w == NULL || h == NULL) {
        if (failure != NULL) *failure = "0x2d step: null argument";
        return D2_ERR_ARGUMENT;
    }
    o->action_23e = row;   /* 0x4cd712 */
    o->set = set;          /* 0x4cd730 */
    switch (phase) {
    case 0:
        status = phase0(o, set, w, h, &local, &why);
        break;
    case 1:
        status = phase1(o, set, w, h, &why);
        break;
    case 2: {
        int32_t retire = D2_NO_ROW;
        const int32_t arg = o->action_23e;
        status = d2_stop(o, w, h, &retire);
        if (status == D2_OK) {
            /* 0x4ceb75 completes the argument row; 0x4ccff5 erased it and reset its phase to 0. */
            local.retire_row = arg == -1 ? D2_NO_ROW : arg;
            local.phase_after = 0;
            local.stopped = 1;
        }
        break;
    }
    default:
        break;
    }
    if (res != NULL) {
        *res = local;
    }
    if (failure != NULL) {
        *failure = why;
    }
    return status;
}

void d2_register_entry(const D2Object *o, D2World *w)
{
    (void)o;
    w->entry_type = 0xb;
    w->entry_surface = 0;
    w->entry_flag = 0;
    w->entry_flag_49 = 1;
    w->entry_word_4d = 0;
    memset(w->entry_label, 0, sizeof(w->entry_label));
    memcpy(w->entry_label, ENTRY_LABEL, sizeof(ENTRY_LABEL));
}

int d2_render_plan(const D2Object *o, const D2World *w, D2RenderPlan *plan)
{
    if (o == NULL || w == NULL || plan == NULL) {
        return D2_ERR_ARGUMENT;
    }
    memset(plan, 0, sizeof(*plan));
    if (o->movie.active == 0 || o->movie.flag_206 == 0) {
        return D2_OK;
    }
    plan->valid = 1;
    plan->surface = w->entry_surface;
    plan->target = w->back_buffer;
    for (int k = 0; k < 4; ++k) {
        plan->src[k] = o->rects[k];
        plan->dst[k] = o->rects[4 + k];
    }
    return D2_OK;
}
