/* RT-52 native side of the raw 0xaa Alarm Clock oracle (tests/action_family_aa_runtime_original_oracle.py).
 *
 * One handle owns an AlcObject (plus the 0x53-byte image that stands for the original singleton at 0x624cbf), an AlcWorld and the HOST
 * side of the AlcHost contract: scripted queues (tick values, sound-busy answers, image handles), a model of the generic Z entry table
 * (0x5d1591, stride 0x4a, 0x58 entries: the allocator 0x4d39f9 takes the first entry in 0x18..0x3f whose +0x18 dword is 0, the inline
 * entry stores of the handler, the releaser 0x4d3992 and the invalidate 0x44d19d), the event flag window (4096 dwords at 0x585801 +
 * 4 * index; the game hour word 0x585d51 and the minute word 0x585d4f live INSIDE it, so the window is the single store of the
 * clock and the world copy the kernel works on is synchronised with it around every call and after every flag store), the seven
 * scene-change cells and the engine mode as the transition request stores them, the view origin and the object at 0x61c387 that the
 * reset 0x44d107 touches (touch_idle_timer: when its dword +0x1c is nonzero the next GetTickCount value minus 5 is stored at +0x456).
 * Two logs are kept for every call:
 *   - the OBSERVER log: what the kernel reports through AlcHost.observe (effect, a, b);
 *   - the HOST-CALL log: what the kernel actually asked of the host, encoded as the effect it corresponds to (plus the two host
 *     calls that have no effect id: mark_dirty = 100, view_origin = 101), so the oracle can check that the observer neither invents
 *     nor omits an effect.
 * Also kept: the names the image loader was asked for.
 * Everything here is test scaffolding (no kernel logic is repeated): the driver never decides anything the kernel decides.
 * The functions are called through ctypes; every buffer layout is documented at the function. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_aa_runtime.h"

#define LOGMAX 1024
#define QMAX 64
#define EVENTS 4096
#define NAMES 8
#define ENTRY_STRIDE 0x4au
#define ENTRY_COUNT 0x58u
#define OBJ_BYTES 0x53
#define IDLE_BYTES 0x460
#define HOUR_BYTE 0x550 /* 0x585d51 - 0x585801 */
#define MINUTE_BYTE 0x54e /* 0x585d4f - 0x585801 */
#define HC_MARK_DIRTY 100
#define HC_ORIGIN 101

enum { Q_TICK, Q_BUSY, Q_HANDLE, QKINDS };
enum {
    F_ALLOC = 1, F_REGISTER = 2, F_LOAD = 4, F_SETSURF = 8, F_RELEASE_SURFACE = 16, F_RELEASE_SLOT = 32, F_DIRTY = 64,
    F_ORIGIN = 128, F_PREPARE = 256, F_STOP = 512, F_PLAY = 1024, F_BUSY = 2048, F_TRANSITION = 4096, F_FLAG = 8192, F_IDLE = 16384
};
enum { E_TYPE = 0, E_CALLBACK = 4, E_SURFACE = 8, E_F0C = 0xc, E_F10 = 0x10, E_DIRTY = 0x14, E_BUSY = 0x18, E_WORD = 0x1c, E_LABEL = 0x22 };

typedef struct {
    int64_t v[QMAX];
    int n, pos, underflow;
} Queue;

typedef struct {
    AlcObject obj;
    AlcWorld world;
    uint8_t shadow[OBJ_BYTES]; /* the bytes of the singleton the kernel has no field for */
    Queue q[QKINDS];
    uint8_t entries[ENTRY_COUNT][ENTRY_STRIDE];
    uint8_t events[EVENTS * 4];
    uint8_t idle[IDLE_BYTES]; /* the object at 0x61c387 */
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
    int transitions;
    int fail;
    int host_error;   /* the host contract was broken (wrong label, record pointer outside the body, ...) */
    int alloc_fail;
    int bad_slot_calls;
    int idle_touches;
    const uint8_t *body; /* the body of the current call, to turn record pointers into offsets */
    AlcHost host;
} Drv;

static void put32(uint8_t *p, uint32_t v) { memcpy(p, &v, 4); }
static void put16(uint8_t *p, uint16_t v) { memcpy(p, &v, 2); }

/* The clock words live inside the event flag window: events are the truth between calls. */
static void sync_in(Drv *d)
{
    uint16_t h, m;
    memcpy(&h, d->events + HOUR_BYTE, 2);
    memcpy(&m, d->events + MINUTE_BYTE, 2);
    d->world.hour_585d51 = (int16_t)h;
    d->world.minute_585d4f = (int16_t)m;
}

static void sync_out(Drv *d)
{
    put16(d->events + HOUR_BYTE, (uint16_t)d->world.hour_585d51);
    put16(d->events + MINUTE_BYTE, (uint16_t)d->world.minute_585d4f);
}

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
            hc(d, ALC_FX_SLOT, i, 0);
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
    if (strcmp(label, "ALARM CLOCK OVERLAYS") != 0) d->host_error++;
    put32(e + E_TYPE, 10u);
    put32(e + E_CALLBACK, 0x44e035u);
    put32(e + E_SURFACE, 0u);
    put32(e + E_F0C, 0u);
    put32(e + E_F10, 0u);
    put32(e + E_DIRTY, 1u);
    put32(e + E_BUSY, 1u);
    put16(e + E_WORD, 0u);
    memcpy(e + E_LABEL, label, strlen(label) + 1u); /* the inline repne scasb / rep movs copy */
    hc(d, ALC_FX_SLOT_REGISTER, slot, 0);
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
    hc(d, ALC_FX_SURFACE_LOAD, v, 0);
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
    hc(d, ALC_FX_SLOT_SURFACE, slot, (int32_t)surface);
    return 0;
}

static int h_release_surface(void *c, uint32_t surface)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_RELEASE_SURFACE) return 1;
    hc(d, ALC_FX_RELEASE_SURFACE, (int32_t)surface, 0);
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
    hc(d, ALC_FX_RELEASE_SLOT, slot, 0);
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

static int h_prepare(void *c, const uint8_t *rec)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_PREPARE) return 1;
    hc(d, ALC_FX_SOUND_PREPARE, (int32_t)(rec - d->body), 0);
    return 0;
}

static int h_stop(void *c, const uint8_t *rec)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_STOP) return 1;
    hc(d, ALC_FX_SOUND_STOP, (int32_t)(rec - d->body), 0);
    return 0;
}

static int h_play(void *c, int16_t channel)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_PLAY) return 1;
    hc(d, ALC_FX_SOUND_PLAY, channel, 0);
    return 0;
}

static int h_busy(void *c, int16_t channel, int32_t *result)
{
    Drv *d = (Drv *)c;
    int32_t v = q_pop(d, Q_BUSY);
    if (d->fail & F_BUSY) return 1;
    *result = v;
    hc(d, ALC_FX_SOUND_BUSY, channel, v);
    return 0;
}

static uint32_t h_tick(void *c)
{
    Drv *d = (Drv *)c;
    int32_t v = q_pop(d, Q_TICK);
    hc(d, ALC_FX_TICK, v, 0);
    return (uint32_t)v;
}

/* 0x4d3c31 reads the dword +0x1c of the object at 0x61c387; when nonzero 0x4d3d20 stores GetTickCount() - 5 at +0x456. */
static int h_touch_idle(void *c)
{
    Drv *d = (Drv *)c;
    uint32_t flag, stamp;
    if (d->fail & F_IDLE) return 1;
    memcpy(&flag, d->idle + 0x1c, 4);
    if (flag != 0u) {
        stamp = (uint32_t)q_pop(d, Q_TICK) - 5u;
        memcpy(d->idle + 0x456, &stamp, 4);
    }
    ++d->idle_touches;
    hc(d, ALC_FX_IDLE_TIMER, 0, 0);
    return 0;
}

static int h_flag_invalid(void *c, int16_t index)
{
    (void)c;
    return index < 0 || index >= EVENTS;
}

static int h_transition(void *c, const AlcTransition *t)
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
    sync_out(d); /* the kernel may have written the clock words already */
    put32(d->events + 4 * (size_t)index, value);
    sync_in(d);  /* the flag may overlap the clock words */
    hc(d, ALC_FX_EVENT_FLAG, index, (int32_t)value);
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
    d->host.sound_prepare = h_prepare;
    d->host.sound_stop = h_stop;
    d->host.sound_play = h_play;
    d->host.sound_busy = h_busy;
    d->host.tick = h_tick;
    d->host.touch_idle_timer = h_touch_idle;
    d->host.event_flag_invalid = h_flag_invalid;
    d->host.transition = h_transition;
    d->host.store_event_flag = h_store_flag;
    d->host.observe = h_observe;
}

void *aao_new(void)
{
    Drv *d = (Drv *)calloc(1, sizeof(Drv));
    if (d == NULL) return NULL;
    wire(d);
    alc_object_reset(&d->obj);
    return d;
}

void aao_free(void *h) { free(h); }

void aao_reset(void *h)
{
    Drv *d = (Drv *)h;
    memset(d, 0, sizeof(*d));
    wire(d);
    alc_object_reset(&d->obj);
}

void aao_clear_logs(void *h)
{
    Drv *d = (Drv *)h;
    d->nfx = d->nhc = 0;
    d->nnames = 0;
    d->host_error = d->alloc_fail = d->bad_slot_calls = 0;
}

void aao_set_fail(void *h, int mask) { ((Drv *)h)->fail = mask; }
void aao_set_origin(void *h, int32_t x, int32_t y) { ((Drv *)h)->org_x = x, ((Drv *)h)->org_y = y; }

/* Queues: aao_q_set replaces a queue (0 tick, 1 busy, 2 handle); position and underflow are read back. */
void aao_q_set(void *h, int kind, const int64_t *vals, int n)
{
    Queue *q = &((Drv *)h)->q[kind];
    if (n > QMAX) n = QMAX;
    memset(q, 0, sizeof(*q));
    for (int i = 0; i < n; ++i) q->v[i] = vals[i];
    q->n = n;
}
int aao_q_pos(void *h, int kind) { return ((Drv *)h)->q[kind].pos; }
int aao_q_underflow(void *h, int kind) { return ((Drv *)h)->q[kind].underflow; }

/* The 0x53-byte image of the singleton 0x624cbf: the bytes without a kernel field come from the shadow set by aao_obj_set. */
void aao_obj_get(void *h, uint8_t *b)
{
    const Drv *d = (Drv *)h;
    const AlcObject *o = &d->obj;
    memcpy(b, d->shadow, OBJ_BYTES);
    memcpy(b + 0x1c, &o->slot, 2);
    memcpy(b + 0x1e, &o->row, 2);
    memcpy(b + 0x20, &o->surface, 4);
    b[0x24] = o->dirty;
    memcpy(b + 0x25, &o->active, 4);
    memcpy(b + 0x29, &o->over, 4);
    memcpy(b + 0x2d, &o->state, 4);
    memcpy(b + 0x31, &o->button, 4);
    memcpy(b + 0x35, &o->time_hour, 2);
    memcpy(b + 0x37, &o->time_quarter, 2);
    memcpy(b + 0x39, &o->time_am, 4);
    memcpy(b + 0x3d, &o->alarm_hour, 2);
    memcpy(b + 0x3f, &o->alarm_quarter, 2);
    memcpy(b + 0x41, &o->alarm_am, 4);
    memcpy(b + 0x45, &o->restore, 4);
    b[0x49] = o->canceled;
    b[0x4a] = o->set;
    memcpy(b + 0x4b, &o->press_deadline, 4);
    memcpy(b + 0x4f, &o->final_deadline, 4);
}

void aao_obj_set(void *h, const uint8_t *b)
{
    Drv *d = (Drv *)h;
    AlcObject *o = &d->obj;
    memcpy(d->shadow, b, OBJ_BYTES);
    memcpy(&o->slot, b + 0x1c, 2);
    memcpy(&o->row, b + 0x1e, 2);
    memcpy(&o->surface, b + 0x20, 4);
    o->dirty = b[0x24];
    memcpy(&o->active, b + 0x25, 4);
    memcpy(&o->over, b + 0x29, 4);
    memcpy(&o->state, b + 0x2d, 4);
    memcpy(&o->button, b + 0x31, 4);
    memcpy(&o->time_hour, b + 0x35, 2);
    memcpy(&o->time_quarter, b + 0x37, 2);
    memcpy(&o->time_am, b + 0x39, 4);
    memcpy(&o->alarm_hour, b + 0x3d, 2);
    memcpy(&o->alarm_quarter, b + 0x3f, 2);
    memcpy(&o->alarm_am, b + 0x41, 4);
    memcpy(&o->restore, b + 0x45, 4);
    o->canceled = b[0x49];
    o->set = b[0x4a];
    memcpy(&o->press_deadline, b + 0x4b, 4);
    memcpy(&o->final_deadline, b + 0x4f, 4);
}

/* extra: the start flag 0x5bb1ca, the hour word 0x585d51 and the minute word 0x585d4f (the last two live in the event window). */
void aao_extra_get(void *h, uint32_t *o)
{
    Drv *d = (Drv *)h;
    sync_in(d);
    o[0] = (uint32_t)d->world.start_flag_5bb1ca;
    o[1] = (uint16_t)d->world.hour_585d51;
    o[2] = (uint16_t)d->world.minute_585d4f;
}

void aao_extra_set(void *h, const uint32_t *o)
{
    Drv *d = (Drv *)h;
    d->world.start_flag_5bb1ca = (int32_t)o[0];
    d->world.hour_585d51 = (int16_t)o[1];
    d->world.minute_585d4f = (int16_t)o[2];
    sync_out(d);
}

/* cells: mode, 5bb57b, 5bb599, 5bb595, 5c39ff, 5bb59b, 5bb59f, 5bb5a3, transitions made */
void aao_cells_get(void *h, int32_t *o)
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

void aao_cells_set(void *h, const int32_t *o)
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

void aao_events_get(void *h, uint8_t *out)
{
    Drv *d = (Drv *)h;
    sync_out(d);
    memcpy(out, d->events, sizeof(d->events));
}
void aao_events_set(void *h, const uint8_t *in)
{
    Drv *d = (Drv *)h;
    memcpy(d->events, in, sizeof(d->events));
    sync_in(d);
}
void aao_entries_get(void *h, uint8_t *out) { memcpy(out, ((Drv *)h)->entries, sizeof(((Drv *)h)->entries)); }
void aao_entries_set(void *h, const uint8_t *in) { memcpy(((Drv *)h)->entries, in, sizeof(((Drv *)h)->entries)); }
void aao_entry_set_u32(void *h, int slot, int offset, uint32_t v)
{
    Drv *d = (Drv *)h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT && offset >= 0 && offset + 4 <= (int)ENTRY_STRIDE) put32(d->entries[slot] + offset, v);
}
void aao_idle_get(void *h, uint8_t *out) { memcpy(out, ((Drv *)h)->idle, IDLE_BYTES); }
void aao_idle_set(void *h, const uint8_t *in) { memcpy(((Drv *)h)->idle, in, IDLE_BYTES); }

int aao_log(void *h, int which, int32_t *out, int max)
{
    const Drv *d = (Drv *)h;
    const int n = which == 0 ? d->nfx : d->nhc;
    const int32_t(*src)[3] = which == 0 ? d->fx : d->hc;
    if (n > max) return -1;
    memcpy(out, src, (size_t)n * 12);
    return n;
}

/* The names the image loader got. */
const char *aao_str(void *h, int i)
{
    const Drv *d = (Drv *)h;
    if (i < 0 || i >= d->nnames || i >= NAMES) return NULL;
    return d->names[i];
}
int aao_nstr(void *h) { return ((Drv *)h)->nnames; }

/* host contract violations, allocator failures, out-of-range slot uses */
void aao_errors(void *h, int32_t *out)
{
    const Drv *d = (Drv *)h;
    out[0] = d->host_error;
    out[1] = d->alloc_fail;
    out[2] = d->bad_slot_calls;
}

/* One true-gate visit of 0x44da08. out: status, phase_after, initialized, completed. The clock words are read from and written
 * back to the event window. */
void aao_step(void *h, const uint8_t *body, int len, int row, uint32_t phase, int32_t *out)
{
    Drv *d = (Drv *)h;
    AlcResult r;
    const char *why = NULL;
    memset(&r, 0, sizeof(r));
    d->body = body;
    sync_in(d);
    out[0] = alc_step(&d->obj, body, (size_t)len, (int16_t)row, phase, &d->world, &d->host, &r, &why);
    sync_out(d);
    out[1] = (int32_t)r.phase_after;
    out[2] = r.initialized;
    out[3] = r.completed;
    d->body = NULL;
}

/* out: status, hit, candidate, cursor_written, cursor_kind, cursor_sub */
void aao_pointer(void *h, const uint8_t *body, int len, int32_t x, int32_t y, int32_t *out)
{
    Drv *d = (Drv *)h;
    AlcPointerResult r;
    memset(&r, 0, sizeof(r));
    out[0] = alc_pointer(&d->obj, body, (size_t)len, x, y, &r);
    out[1] = r.hit;
    out[2] = r.candidate;
    out[3] = r.cursor_written;
    out[4] = r.cursor_kind;
    out[5] = r.cursor_sub;
}

/* out: status, fired, sound_played */
void aao_click(void *h, const uint8_t *body, int len, uint32_t row_phase, int32_t *out)
{
    Drv *d = (Drv *)h;
    AlcClickResult r;
    memset(&r, 0, sizeof(r));
    d->body = body;
    sync_in(d);
    out[0] = alc_click(&d->obj, body, (size_t)len, row_phase, &d->world, &d->host, &r);
    out[1] = r.fired;
    out[2] = r.sound_played;
    d->body = NULL;
}

int aao_invalidate(void *h) { return alc_invalidate(&((Drv *)h)->obj, &((Drv *)h)->host); }
int aao_cleanup(void *h) { return alc_cleanup(&((Drv *)h)->obj, &((Drv *)h)->host); }

int aao_validate(const uint8_t *body, int len) { return alc_validate_body(body, (size_t)len, NULL); }

/* out: status, valid, count, then ALC_MAX_BLITS x (kind, src_surface, src[4], dst[4]) */
void aao_render(void *h, const uint8_t *body, int len, int32_t *out)
{
    Drv *d = (Drv *)h;
    AlcRenderResult r;
    memset(&r, 0xA5, sizeof(r));
    d->body = body;
    out[0] = alc_render(&d->obj, body, (size_t)len, &d->host, &r);
    out[1] = r.valid;
    out[2] = r.count;
    for (int i = 0; i < ALC_MAX_BLITS; ++i) {
        int32_t *o = out + 3 + 10 * i;
        o[0] = r.blit[i].kind;
        o[1] = (int32_t)r.blit[i].src_surface;
        for (int k = 0; k < 4; ++k) o[2 + k] = r.blit[i].src[k];
        for (int k = 0; k < 4; ++k) o[6 + k] = r.blit[i].dst[k];
    }
    d->body = NULL;
}
