/* RT-50 native side of the raw 0xd0 Piano Puzzle oracle (tests/action_family_d0_runtime_original_oracle.py).
 *
 * One handle owns a D0Object (plus the 0x5c-byte image that stands for the original singleton at 0x61d345), a D0World and the HOST
 * side of the D0Host contract: scripted queues (tick values, sound-busy answers, image handles and the texts the lookup 0x423259
 * returns, NULL included), a model of the generic Z entry table (0x5d1591, stride 0x4a, 0x58 entries: the allocator 0x4d39f9 takes
 * the first entry in 0x18..0x3f whose +0x18 dword is 0, the inline entry stores of the handler, the releaser 0x4d3992 and the
 * invalidate 0x48d0e5), the event flag window (4096 dwords at 0x585801 + 4 * index), the seven scene-change cells and the engine
 * mode as the transition request stores them, and the view origin. Two logs are kept for every call:
 *   - the OBSERVER log: what the kernel reports through D0Host.observe (effect, a, b);
 *   - the HOST-CALL log: what the kernel actually asked of the host, encoded as the effect it corresponds to (plus the two host
 *     calls that have no effect id: mark_dirty = 100, view_origin = 101), so the oracle can check that the observer neither invents
 *     nor omits an effect.
 * Also kept: the names the image loader was asked for, the text keys the lookup received and the texts that were shown.
 * Everything here is test scaffolding (no kernel logic is repeated): the driver never decides anything the kernel decides.
 * The functions are called through ctypes; every buffer layout is documented at the function. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_d0_runtime.h"

#define LOGMAX 1024
#define QMAX 64
#define EVENTS 4096
#define NAMES 8
#define NTEXT 6
#define TEXT_CAP 0x9c60
#define ENTRY_STRIDE 0x4au
#define ENTRY_COUNT 0x58u
#define OBJ_BYTES 0x5c
#define HC_MARK_DIRTY 100
#define HC_ORIGIN 101

enum { Q_TICK, Q_BUSY, Q_HANDLE, QKINDS };
enum {
    F_ALLOC = 1, F_REGISTER = 2, F_LOAD = 4, F_SETSURF = 8, F_RELEASE_SURFACE = 16, F_RELEASE_SLOT = 32, F_DIRTY = 64,
    F_ORIGIN = 128, F_CLEAR = 256, F_PREPARE = 512, F_STOP = 1024, F_PLAY = 2048, F_BUSY = 4096, F_TEXT_LOOKUP = 8192,
    F_TEXT_SHOW = 16384, F_TRANSITION = 32768, F_FLAG = 65536
};
enum { E_TYPE = 0, E_CALLBACK = 4, E_SURFACE = 8, E_F0C = 0xc, E_F10 = 0x10, E_DIRTY = 0x14, E_BUSY = 0x18, E_WORD = 0x1c, E_LABEL = 0x22 };

typedef struct {
    int64_t v[QMAX];
    int n, pos, underflow;
} Queue;

typedef struct {
    uint8_t data[TEXT_CAP];
    int len, present;
} TextItem;

typedef struct {
    D0Object obj;
    D0World world;
    uint8_t shadow[OBJ_BYTES]; /* the bytes of the singleton the kernel has no field for */
    Queue q[QKINDS];
    TextItem text[NTEXT];
    int ntext, itext, text_underflow;
    uint8_t entries[ENTRY_COUNT][ENTRY_STRIDE];
    uint32_t events[EVENTS];
    int32_t mode;
    int32_t c57b;
    int16_t c599, c595, c39ff;
    int32_t c59b, c59f, c5a3;
    int32_t org_x, org_y;
    int32_t fx[LOGMAX][3];
    int nfx;
    int32_t hc[LOGMAX][3];
    int nhc;
    char names[NAMES][40];
    int nnames;
    char keys[NAMES][40];
    int nkeys;
    char shown[NAMES][256];
    int nshown;
    int transitions;
    int fail;
    int host_error;   /* the host contract was broken (wrong label, record pointer outside the body, ...) */
    int alloc_fail;
    int bad_slot_calls;
    const uint8_t *body; /* the body of the current call, to turn record pointers into offsets */
    D0Host host;
} Drv;

static void put32(uint8_t *p, uint32_t v) { memcpy(p, &v, 4); }
static void put16(uint8_t *p, uint16_t v) { memcpy(p, &v, 2); }

static uint8_t *entry(Drv *d, int16_t slot)
{
    if (slot < 0 || (unsigned)slot >= ENTRY_COUNT) {
        d->bad_slot_calls++;
        return NULL;
    }
    return d->entries[slot];
}

static int32_t q_pop(Drv *d, int kind)
{
    Queue *q = &d->q[kind];
    if (q->pos >= q->n) {
        q->underflow = 1;
        q->pos++;
        return 0;
    }
    return (int32_t)(uint32_t)(uint64_t)q->v[q->pos++];
}

static void hc(Drv *d, int kind, int32_t a, int32_t b)
{
    if (d->nhc < LOGMAX) {
        d->hc[d->nhc][0] = kind;
        d->hc[d->nhc][1] = a;
        d->hc[d->nhc][2] = b;
        ++d->nhc;
    }
}

static int h_alloc(void *c, int16_t *slot)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_ALLOC) return 1;
    for (int i = 0x18; i <= 0x3f; ++i) {
        uint32_t busy;
        memcpy(&busy, d->entries[i] + E_BUSY, 4);
        if (busy == 0u) {
            *slot = (int16_t)i;
            hc(d, D0_FX_SLOT, i, 0);
            return 0;
        }
    }
    d->alloc_fail++; /* the original reaches the fatal path 0x52139c here */
    return 1;
}

static int h_register(void *c, int16_t slot, const char *label)
{
    Drv *d = (Drv *)c;
    uint8_t *e;
    if (d->fail & F_REGISTER) return 1;
    e = entry(d, slot);
    if (e == NULL) return 1;
    if (strcmp(label, "PIANO PUZZLE OVERLAYS") != 0) d->host_error++;
    put32(e + E_TYPE, 10u);
    put32(e + E_CALLBACK, 0x48ded7u);
    put32(e + E_SURFACE, 0u);
    put32(e + E_F0C, 0u);
    put32(e + E_F10, 0u);
    put32(e + E_DIRTY, 1u);
    put32(e + E_BUSY, 1u);
    put16(e + E_WORD, 0u);
    memcpy(e + E_LABEL, label, strlen(label) + 1u); /* the inline repne scasb / rep movs copy */
    hc(d, D0_FX_SLOT_REGISTER, slot, 0);
    return 0;
}

static int h_load(void *c, const char *name, uint32_t *surface)
{
    Drv *d = (Drv *)c;
    int32_t v = q_pop(d, Q_HANDLE);
    if (d->nnames < NAMES) {
        strncpy(d->names[d->nnames], name, 39);
        d->names[d->nnames][39] = 0;
    }
    ++d->nnames;
    if (d->fail & F_LOAD) return 1;
    *surface = (uint32_t)v;
    hc(d, D0_FX_SURFACE_LOAD, v, 0);
    return 0;
}

static int h_set_slot_surface(void *c, int16_t slot, uint32_t surface)
{
    Drv *d = (Drv *)c;
    uint8_t *e;
    if (d->fail & F_SETSURF) return 1;
    e = entry(d, slot);
    if (e == NULL) return 1;
    put32(e + E_SURFACE, surface);
    hc(d, D0_FX_SLOT_SURFACE, slot, (int32_t)surface);
    return 0;
}

static int h_release_surface(void *c, uint32_t surface)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_RELEASE_SURFACE) return 1;
    hc(d, D0_FX_RELEASE_SURFACE, (int32_t)surface, 0);
    return 0;
}

static int h_release_slot(void *c, int16_t slot)
{
    Drv *d = (Drv *)c;
    uint8_t *e;
    if (d->fail & F_RELEASE_SLOT) return 1;
    e = entry(d, slot);
    if (e == NULL) return 1;
    put32(e + E_DIRTY, 0u);
    put32(e + E_BUSY, 0u);
    hc(d, D0_FX_RELEASE_SLOT, slot, 0);
    return 0;
}

static int h_mark_dirty(void *c, int16_t slot)
{
    Drv *d = (Drv *)c;
    uint8_t *e;
    if (d->fail & F_DIRTY) return 1;
    e = entry(d, slot);
    if (e == NULL) return 1;
    put32(e + E_DIRTY, 1u);
    hc(d, HC_MARK_DIRTY, slot, 0);
    return 0;
}

static int h_origin(void *c, int32_t *x, int32_t *y)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_ORIGIN) return 1;
    *x = d->org_x;
    *y = d->org_y;
    hc(d, HC_ORIGIN, *x, *y);
    return 0;
}

static int h_clear(void *c)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_CLEAR) return 1;
    hc(d, D0_FX_CLEAR_ITEM, 0, 0);
    return 0;
}

static int h_prepare(void *c, const uint8_t *rec)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_PREPARE) return 1;
    hc(d, D0_FX_SOUND_PREPARE, (int32_t)(rec - d->body), 0);
    return 0;
}

static int h_stop(void *c, const uint8_t *rec)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_STOP) return 1;
    hc(d, D0_FX_SOUND_STOP, (int32_t)(rec - d->body), 0);
    return 0;
}

static int h_play(void *c, int16_t channel)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_PLAY) return 1;
    hc(d, D0_FX_SOUND_PLAY, channel, 0);
    return 0;
}

static int h_busy(void *c, int16_t channel, int32_t *result)
{
    Drv *d = (Drv *)c;
    int32_t v = q_pop(d, Q_BUSY);
    if (d->fail & F_BUSY) return 1;
    *result = v;
    hc(d, D0_FX_SOUND_BUSY, channel, v);
    return 0;
}

static uint32_t h_tick(void *c)
{
    Drv *d = (Drv *)c;
    int32_t v = q_pop(d, Q_TICK);
    hc(d, D0_FX_TICK, v, 0);
    return (uint32_t)v;
}

static int h_text_lookup(void *c, const char *key, const char **text)
{
    Drv *d = (Drv *)c;
    int32_t idx = -1000;
    TextItem *t = NULL;
    if (d->nkeys < NAMES) {
        strncpy(d->keys[d->nkeys], key, 39);
        d->keys[d->nkeys][39] = 0;
    }
    ++d->nkeys;
    if (d->body != NULL && (const uint8_t *)key >= d->body + 0x358u) {
        const size_t off = (size_t)((const uint8_t *)key - d->body) - 0x358u;
        if (off % 0x42u == 0u) idx = (int32_t)(off / 0x42u);
    }
    if (d->itext < d->ntext) {
        t = &d->text[d->itext];
    } else {
        d->text_underflow = 1;
    }
    d->itext++;
    if (d->fail & F_TEXT_LOOKUP) return 1;
    *text = (t != NULL && t->present) ? (const char *)t->data : NULL;
    hc(d, D0_FX_TEXT_LOOKUP, idx, *text != NULL ? 1 : 0);
    return 0;
}

static int h_text_show(void *c, const char *text)
{
    Drv *d = (Drv *)c;
    const size_t n = strlen(text);
    if (d->fail & F_TEXT_SHOW) return 1;
    if (d->nshown < NAMES) {
        strncpy(d->shown[d->nshown], text, 255);
        d->shown[d->nshown][255] = 0;
    }
    ++d->nshown;
    hc(d, D0_FX_TEXT_SHOW, (int32_t)n, 0);
    return 0;
}

static int h_flag_invalid(void *c, int16_t index)
{
    (void)c;
    return index < 0 || index >= EVENTS;
}

static int h_transition(void *c, const D0Transition *t)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_TRANSITION) return 1;
    d->c57b = (int32_t)t->scene;
    d->c599 = t->word[0];
    d->c595 = t->word[1];
    d->c39ff = t->word[2];
    d->c59b = t->dword[0];
    d->c59f = t->dword[1];
    d->c5a3 = t->dword[2];
    d->mode = 4;
    ++d->transitions;
    return 0;
}

static int h_store_flag(void *c, int16_t index, uint32_t value)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_FLAG) return 1;
    if (index < 0 || index >= EVENTS) return 1;
    d->events[index] = value;
    hc(d, D0_FX_EVENT_FLAG, index, (int32_t)value);
    return 0;
}

static void h_observe(void *c, int effect, int32_t a, int32_t b)
{
    Drv *d = (Drv *)c;
    if (d->nfx < LOGMAX) {
        d->fx[d->nfx][0] = effect;
        d->fx[d->nfx][1] = a;
        d->fx[d->nfx][2] = b;
        ++d->nfx;
    }
}

static void wire(Drv *d)
{
    d->host.context = d;
    d->host.alloc_slot = h_alloc;
    d->host.register_slot = h_register;
    d->host.load_surface = h_load;
    d->host.set_slot_surface = h_set_slot_surface;
    d->host.release_surface = h_release_surface;
    d->host.release_slot = h_release_slot;
    d->host.mark_dirty = h_mark_dirty;
    d->host.view_origin = h_origin;
    d->host.clear_pending_item = h_clear;
    d->host.sound_prepare = h_prepare;
    d->host.sound_stop = h_stop;
    d->host.sound_play = h_play;
    d->host.sound_busy = h_busy;
    d->host.tick = h_tick;
    d->host.text_lookup = h_text_lookup;
    d->host.text_show = h_text_show;
    d->host.event_flag_invalid = h_flag_invalid;
    d->host.transition = h_transition;
    d->host.store_event_flag = h_store_flag;
    d->host.observe = h_observe;
}

void *d0o_new(void)
{
    Drv *d = (Drv *)calloc(1, sizeof(Drv));
    if (d == NULL) return NULL;
    wire(d);
    d0_object_reset(&d->obj);
    return d;
}

void d0o_free(void *h) { free(h); }

void d0o_reset(void *h)
{
    Drv *d = (Drv *)h;
    memset(d, 0, sizeof(*d));
    wire(d);
    d0_object_reset(&d->obj);
}

void d0o_clear_logs(void *h)
{
    Drv *d = (Drv *)h;
    d->nfx = d->nhc = 0;
    d->nnames = d->nkeys = d->nshown = 0;
    d->host_error = d->alloc_fail = d->bad_slot_calls = 0;
}

void d0o_set_fail(void *h, int mask) { ((Drv *)h)->fail = mask; }
void d0o_set_origin(void *h, int32_t x, int32_t y) { ((Drv *)h)->org_x = x, ((Drv *)h)->org_y = y; }

/* Queues: d0o_q_set replaces a queue (0 tick, 1 busy, 2 handle); position and underflow are read back. */
void d0o_q_set(void *h, int kind, const int64_t *vals, int n)
{
    Queue *q = &((Drv *)h)->q[kind];
    if (n > QMAX) n = QMAX;
    memset(q, 0, sizeof(*q));
    for (int i = 0; i < n; ++i) q->v[i] = vals[i];
    q->n = n;
}
int d0o_q_pos(void *h, int kind) { return ((Drv *)h)->q[kind].pos; }
int d0o_q_underflow(void *h, int kind) { return ((Drv *)h)->q[kind].underflow; }

/* Text queue: d0o_text_clear, then d0o_text_add (present = 0 stands for a NULL answer). */
void d0o_text_clear(void *h)
{
    Drv *d = (Drv *)h;
    d->ntext = d->itext = d->text_underflow = 0;
}
int d0o_text_add(void *h, const uint8_t *s, int len, int present)
{
    Drv *d = (Drv *)h;
    TextItem *t;
    if (d->ntext >= NTEXT || len < 0 || len >= TEXT_CAP) return -1;
    t = &d->text[d->ntext++];
    memset(t->data, 0, 1);
    memcpy(t->data, s, (size_t)len);
    t->data[len] = 0;
    t->len = len;
    t->present = present;
    return 0;
}
int d0o_text_pos(void *h) { return ((Drv *)h)->itext; }
int d0o_text_underflow(void *h) { return ((Drv *)h)->text_underflow; }

/* The 0x5c-byte image of the singleton 0x61d345: the bytes without a kernel field come from the shadow set by d0o_obj_set. */
void d0o_obj_get(void *h, uint8_t *b)
{
    const Drv *d = (Drv *)h;
    const D0Object *o = &d->obj;
    memcpy(b, d->shadow, OBJ_BYTES);
    memcpy(b + 0x1c, &o->slot, 2);
    memcpy(b + 0x1e, &o->row, 2);
    memcpy(b + 0x20, &o->surface, 4);
    b[0x24] = o->dirty;
    b[0x25] = o->check;
    b[0x26] = o->pressed;
    memcpy(b + 0x27, &o->hover, 2);
    memcpy(b + 0x29, &o->last, 2);
    memcpy(b + 0x2b, &o->state, 4);
    memcpy(b + 0x2f, &o->has_surface, 4);
    memcpy(b + 0x33, &o->active, 4);
    b[0x37] = o->exit_taken;
    b[0x38] = o->solved;
    memcpy(b + 0x39, &o->deadline, 4);
    memcpy(b + 0x3d, o->order, sizeof o->order);
}

void d0o_obj_set(void *h, const uint8_t *b)
{
    Drv *d = (Drv *)h;
    D0Object *o = &d->obj;
    memcpy(d->shadow, b, OBJ_BYTES);
    memcpy(&o->slot, b + 0x1c, 2);
    memcpy(&o->row, b + 0x1e, 2);
    memcpy(&o->surface, b + 0x20, 4);
    o->dirty = b[0x24];
    o->check = b[0x25];
    o->pressed = b[0x26];
    memcpy(&o->hover, b + 0x27, 2);
    memcpy(&o->last, b + 0x29, 2);
    memcpy(&o->state, b + 0x2b, 4);
    memcpy(&o->has_surface, b + 0x2f, 4);
    memcpy(&o->active, b + 0x33, 4);
    o->exit_taken = b[0x37];
    o->solved = b[0x38];
    memcpy(&o->deadline, b + 0x39, 4);
    memcpy(o->order, b + 0x3d, sizeof o->order);
}

/* extra: start flag 0x5bb1ca */
void d0o_extra_get(void *h, uint32_t *o) { o[0] = (uint32_t)((Drv *)h)->world.start_flag_5bb1ca; }
void d0o_extra_set(void *h, const uint32_t *o) { ((Drv *)h)->world.start_flag_5bb1ca = (int32_t)o[0]; }

/* cells: mode, 5bb57b, 5bb599, 5bb595, 5c39ff, 5bb59b, 5bb59f, 5bb5a3, transitions made */
void d0o_cells_get(void *h, int32_t *o)
{
    const Drv *d = (Drv *)h;
    o[0] = d->mode;
    o[1] = d->c57b;
    o[2] = d->c599;
    o[3] = d->c595;
    o[4] = d->c39ff;
    o[5] = d->c59b;
    o[6] = d->c59f;
    o[7] = d->c5a3;
    o[8] = d->transitions;
}

void d0o_cells_set(void *h, const int32_t *o)
{
    Drv *d = (Drv *)h;
    d->mode = o[0];
    d->c57b = o[1];
    d->c599 = (int16_t)o[2];
    d->c595 = (int16_t)o[3];
    d->c39ff = (int16_t)o[4];
    d->c59b = o[5];
    d->c59f = o[6];
    d->c5a3 = o[7];
}

void d0o_events_get(void *h, uint8_t *out) { memcpy(out, ((Drv *)h)->events, sizeof(((Drv *)h)->events)); }
void d0o_events_set(void *h, const uint8_t *in) { memcpy(((Drv *)h)->events, in, sizeof(((Drv *)h)->events)); }
void d0o_entries_get(void *h, uint8_t *out) { memcpy(out, ((Drv *)h)->entries, sizeof(((Drv *)h)->entries)); }
void d0o_entries_set(void *h, const uint8_t *in) { memcpy(((Drv *)h)->entries, in, sizeof(((Drv *)h)->entries)); }
void d0o_entry_set_u32(void *h, int slot, int offset, uint32_t v)
{
    Drv *d = (Drv *)h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT && offset >= 0 && offset + 4 <= (int)ENTRY_STRIDE) put32(d->entries[slot] + offset, v);
}

int d0o_log(void *h, int which, int32_t *out, int max)
{
    const Drv *d = (Drv *)h;
    const int n = which == 0 ? d->nfx : d->nhc;
    const int32_t(*src)[3] = which == 0 ? d->fx : d->hc;
    if (n > max) return -1;
    memcpy(out, src, (size_t)n * 12);
    return n;
}

/* Strings: which 0 = names the loader got, 1 = text keys the lookup got, 2 = texts shown. */
const char *d0o_str(void *h, int which, int i)
{
    const Drv *d = (Drv *)h;
    const int n = which == 0 ? d->nnames : which == 1 ? d->nkeys : d->nshown;
    if (i < 0 || i >= n || i >= NAMES) return NULL;
    return which == 0 ? d->names[i] : which == 1 ? d->keys[i] : d->shown[i];
}
int d0o_nstr(void *h, int which)
{
    const Drv *d = (Drv *)h;
    return which == 0 ? d->nnames : which == 1 ? d->nkeys : d->nshown;
}

/* host contract violations, allocator failures, out-of-range slot uses */
void d0o_errors(void *h, int32_t *out)
{
    const Drv *d = (Drv *)h;
    out[0] = d->host_error;
    out[1] = d->alloc_fail;
    out[2] = d->bad_slot_calls;
}

/* One true-gate visit of 0x48d914. out: status, phase_after, initialized, completed. The start flag is in d0o_extra_get[0]. */
void d0o_step(void *h, const uint8_t *body, int len, int row, uint32_t phase, int32_t *out)
{
    Drv *d = (Drv *)h;
    D0Result r;
    const char *why = NULL;
    memset(&r, 0, sizeof(r));
    d->body = body;
    out[0] = d0_step(&d->obj, body, (size_t)len, (int16_t)row, phase, &d->world, &d->host, &r, &why);
    out[1] = (int32_t)r.phase_after;
    out[2] = r.initialized;
    out[3] = r.completed;
    d->body = NULL;
}

/* out: status, hit, candidate, cursor_written, cursor_kind, cursor_sub */
void d0o_pointer(void *h, const uint8_t *body, int len, int32_t x, int32_t y, int32_t *out)
{
    Drv *d = (Drv *)h;
    D0PointerResult r;
    memset(&r, 0, sizeof(r));
    out[0] = d0_pointer(&d->obj, body, (size_t)len, x, y, &r);
    out[1] = r.hit;
    out[2] = r.candidate;
    out[3] = r.cursor_written;
    out[4] = r.cursor_kind;
    out[5] = r.cursor_sub;
}

/* `body` is MUTABLE (the press block rewrites the sound record C). out: status, exit_asked, key_pressed, sound_played,
 * text_shown, new_phase */
void d0o_click(void *h, uint8_t *body, int len, uint32_t row_phase, int32_t candidate, int32_t start_flag, int32_t *out)
{
    Drv *d = (Drv *)h;
    D0ClickResult r;
    memset(&r, 0, sizeof(r));
    d->body = body;
    out[0] = d0_click(&d->obj, body, (size_t)len, row_phase, candidate, start_flag, &d->host, &r);
    out[1] = r.exit_asked;
    out[2] = r.key_pressed;
    out[3] = r.sound_played;
    out[4] = r.text_shown;
    out[5] = (int32_t)r.new_phase;
    d->body = NULL;
}

int d0o_invalidate(void *h) { return d0_invalidate(&((Drv *)h)->obj, &((Drv *)h)->host); }
int d0o_cleanup(void *h) { return d0_cleanup(&((Drv *)h)->obj, &((Drv *)h)->host); }

int d0o_validate(const uint8_t *body, int len) { return d0_validate_body(body, (size_t)len, NULL); }

/* out: status, valid, blit, key, src_surface, src[4], dst[4], solved_check */
void d0o_render(void *h, const uint8_t *body, int len, int32_t *out)
{
    Drv *d = (Drv *)h;
    D0RenderResult r;
    memset(&r, 0xA5, sizeof(r));
    d->body = body;
    out[0] = d0_render(&d->obj, body, (size_t)len, &d->host, &r);
    out[1] = r.valid;
    out[2] = r.blit;
    out[3] = r.key;
    out[4] = (int32_t)r.src_surface;
    for (int k = 0; k < 4; ++k) out[5 + k] = r.src[k];
    for (int k = 0; k < 4; ++k) out[9 + k] = r.dst[k];
    out[13] = r.solved_check;
    d->body = NULL;
}
