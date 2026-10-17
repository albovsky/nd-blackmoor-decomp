/* RT-55 native side of the raw 0xf5 Typing Quiz oracle (tests/action_family_f5_runtime_original_oracle.py).
 *
 * One handle owns a TqzObject (plus the 0x643-byte image that stands for the original singleton at 0x61ee6e), a TqzWorld (the start flag
 * 0x5bb1ca, the played flag 0x5a4c0a, the best score word 0x5a4c0e and the score / time display widget at 0x638603, 0x288 bytes) and the
 * HOST side of the TqzHost contract: scripted queues (GetTickCount values, _rand values, image handles), a model of the generic Z entry
 * table (0x5d1591, stride 0x4a, 0x58 entries: the allocator 0x4d39f9 takes the first entry in 0x18..0x3f whose +0x18 dword is 0, the inline
 * entry stores of the quiz and of the two display inits, the releaser 0x4d3992 and the invalidate 0x4b80a5), the event flag window (4096
 * dwords at 0x585801 + 4 * index), the seven scene-change cells and the engine mode as the transition request stores them, and the view
 * rectangles 0x583186 / 0x583196.
 * Two logs are kept for every call:
 *   - the OBSERVER log: what the kernel reports through TqzHost.observe (effect, a, b);
 *   - the HOST-CALL log: what the kernel actually asked of the host, encoded as the effect it corresponds to (plus the host call that has
 *     no effect id: mark_dirty = 100), so the oracle can check that the observer neither invents nor omits an effect.
 * Everything here is test scaffolding (no kernel logic is repeated): the driver never decides anything the kernel decides.
 * The functions are called through ctypes; every buffer layout is documented at the function. */
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_f5_runtime.h"

#define LOGMAX 16384
#define QMAX 8192
#define EVENTS 4096
#define NAMES 8
#define ENTRY_STRIDE 0x4au
#define ENTRY_COUNT 0x58u
#define OBJ_BYTES 0x643
#define WIDGET_BYTES 0x288
#define HC_MARK_DIRTY 100
#define HC_ENGINE_MODE 101

_Static_assert(sizeof(StdDisplay) == 0x284, "the widget image is 4 + sizeof(StdDisplay) = 0x288 bytes");
_Static_assert(sizeof(TqzBalloon) >= 0x37, "balloon fields");

enum { Q_TICK, Q_RAND, Q_HANDLE, QKINDS };
enum {
    F_ALLOC = 1, F_REGISTER = 2, F_LOAD = 4, F_SETSURF = 8, F_RELEASE_SURFACE = 16, F_RELEASE_SLOT = 32, F_DIRTY = 64,
    F_VIEW = 128, F_PREPARE = 256, F_STOP = 512, F_PLAY = 1024, F_TRANSITION = 2048, F_FLAG = 4096, F_CLEAR = 8192,
    F_FONT_ACQUIRE = 16384, F_FONT_RELEASE = 32768, F_MODE = 65536, F_REGISTER_DISPLAY = 131072, F_REGISTER_CLOCK = 262144
};
enum { E_TYPE = 0, E_CALLBACK = 4, E_SURFACE = 8, E_F0C = 0xc, E_F10 = 0x10, E_DIRTY = 0x14, E_BUSY = 0x18, E_WORD = 0x1c, E_LABEL = 0x22 };

typedef struct {
    int64_t v[QMAX];
    int n, pos, underflow;
} Queue;

typedef struct {
    TqzObject obj;
    TqzWorld world;
    uint8_t obj_shadow[OBJ_BYTES]; /* the bytes of the singleton the kernel has no field for */
    uint8_t wid_shadow[4];
    Queue q[QKINDS];
    uint8_t entries[ENTRY_COUNT][ENTRY_STRIDE];
    uint8_t events[EVENTS * 4];
    int32_t mode;
    int32_t c57b;
    int16_t c599, c595, c39ff;
    int32_t c59b, c59f, c5a3;
    int32_t view[4], local[4];
    int32_t fx[LOGMAX][3];
    int nfx;
    int32_t hc[LOGMAX][3];
    int nhc;
    char names[NAMES][40];
    int nnames;
    int transitions;
    int fail;
    int host_error;   /* the host contract was broken (wrong label, record pointer outside the body, wrong font argument ...) */
    int alloc_fail;
    int bad_slot_calls;
    const uint8_t *body; /* the body of the current call, to turn record pointers into offsets */
    TqzHost host;
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
            hc(d, TQZ_FX_SLOT, i, 0);
            return 0;
        }
    }
    d->alloc_fail++; /* the original reaches the fatal path here */
    return 1;
}

static int h_register(void *c, int16_t slot, int32_t type, int callback, uint32_t surface, const char *label)
{
    Drv *d = (Drv *)c;
    uint8_t *e;
    uint32_t cb = 0;
    int effect = 0;
    if (d->fail & F_REGISTER) return 1;
    if ((d->fail & F_REGISTER_DISPLAY) && callback == STD_CALLBACK_SCORE) return 1;
    if ((d->fail & F_REGISTER_CLOCK) && callback == STD_CALLBACK_CLOCK) return 1;
    e = entry(d, slot);
    if (e == NULL) return 1;
    if (callback == TQZ_CALLBACK_QUIZ) {
        if (strcmp(label, "TYPING QUIZ PUZZLE OVERLAYS") != 0) d->host_error++;
        cb = 0x4b9a88u;
        effect = TQZ_FX_SLOT_REGISTER;
    } else if (callback == STD_CALLBACK_SCORE) {
        if (strcmp(label, "SCORE DISPLAY") != 0) d->host_error++;
        cb = 0x446688u;
        effect = STD_FX_INIT_SCORE;
    } else if (callback == STD_CALLBACK_CLOCK) {
        if (strcmp(label, "TIME DISPLAY") != 0) d->host_error++;
        cb = 0x4468feu;
        effect = STD_FX_INIT_CLOCK;
    } else {
        d->host_error++;
    }
    put32(e + E_TYPE, (uint32_t)type);
    put32(e + E_CALLBACK, cb);
    put32(e + E_SURFACE, surface);
    put32(e + E_F0C, 0u);
    put32(e + E_F10, 0u);
    put32(e + E_DIRTY, 1u);
    put32(e + E_BUSY, 1u);
    put16(e + E_WORD, 0u);
    memcpy(e + E_LABEL, label, strlen(label) + 1u); /* the inline repne scasb / rep movs copy */
    if (effect == TQZ_FX_SLOT_REGISTER) hc(d, effect, slot, 0);
    else hc(d, effect, slot, (int32_t)surface);
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
    hc(d, TQZ_FX_SURFACE_LOAD, v, 0);
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
    hc(d, TQZ_FX_SLOT_SURFACE, slot, (int32_t)surface);
    return 0;
}

static int h_release_surface(void *c, uint32_t surface)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_RELEASE_SURFACE) return 1;
    hc(d, TQZ_FX_RELEASE_SURFACE, (int32_t)surface, 0);
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
    hc(d, TQZ_FX_RELEASE_SLOT, slot, 0);
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

static int h_view(void *c, int32_t absolute[4], int32_t local[4])
{
    Drv *d = (Drv *)c;
    if (d->fail & F_VIEW) return 1;
    memcpy(absolute, d->view, sizeof d->view);
    memcpy(local, d->local, sizeof d->local);
    return 0;
}

static int h_clear_item(void *c)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_CLEAR) return 1;
    hc(d, TQZ_FX_CLEAR_ITEM, 0, 0);
    return 0;
}

static int h_font_acquire(void *c)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_FONT_ACQUIRE) return 1;
    hc(d, TQZ_FX_FONT_ACQUIRE, TQZ_FONT_SURFACE, 0);
    return 0;
}

static int h_font_release(void *c)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_FONT_RELEASE) return 1;
    hc(d, TQZ_FX_FONT_RELEASE, TQZ_FONT_SURFACE, 0);
    return 0;
}

static int h_prepare(void *c, const uint8_t *rec)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_PREPARE) return 1;
    hc(d, TQZ_FX_SOUND_PREPARE, (int32_t)(rec - d->body), 0);
    return 0;
}

static int h_stop(void *c, const uint8_t *rec)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_STOP) return 1;
    hc(d, TQZ_FX_SOUND_STOP, (int32_t)(rec - d->body), 0);
    return 0;
}

static int h_play(void *c, int16_t channel)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_PLAY) return 1;
    hc(d, TQZ_FX_SOUND_PLAY, channel, 0);
    return 0;
}

static uint32_t h_tick(void *c)
{
    Drv *d = (Drv *)c;
    int32_t v = q_pop(d, Q_TICK);
    hc(d, TQZ_FX_TICK, v, 0);
    return (uint32_t)v;
}

static int32_t h_random(void *c)
{
    Drv *d = (Drv *)c;
    int32_t v = q_pop(d, Q_RAND);
    hc(d, TQZ_FX_RANDOM, v, 0);
    return v;
}

static int h_flag_invalid(void *c, int16_t index)
{
    (void)c;
    return index < 0 || index >= EVENTS;
}

static int h_transition(void *c, const TqzTransition *t)
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
    ++d->transitions;
    return 0;
}

static int h_store_flag(void *c, int16_t index, uint32_t value)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_FLAG) return 1;
    if (index < 0 || index >= EVENTS) return 1;
    put32(d->events + 4 * (size_t)index, value);
    hc(d, TQZ_FX_EVENT_FLAG, index, (int32_t)value);
    return 0;
}

static int h_engine_mode(void *c, int32_t mode)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_MODE) return 1;
    d->mode = mode;
    hc(d, HC_ENGINE_MODE, mode, 0);
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
    d->host.view_rects = h_view;
    d->host.clear_pending_item = h_clear_item;
    d->host.font_acquire = h_font_acquire;
    d->host.font_release = h_font_release;
    d->host.sound_prepare = h_prepare;
    d->host.sound_stop = h_stop;
    d->host.sound_play = h_play;
    d->host.tick = h_tick;
    d->host.random = h_random;
    d->host.event_flag_invalid = h_flag_invalid;
    d->host.transition = h_transition;
    d->host.store_event_flag = h_store_flag;
    d->host.engine_mode = h_engine_mode;
    d->host.observe = h_observe;
}

void *f5o_new(void)
{
    Drv *d = (Drv *)calloc(1, sizeof(Drv));
    if (d == NULL) return NULL;
    wire(d);
    tqz_object_reset(&d->obj);
    return d;
}

void f5o_free(void *h) { free(h); }

void f5o_reset(void *h)
{
    Drv *d = (Drv *)h;
    memset(d, 0, sizeof(*d));
    wire(d);
    tqz_object_reset(&d->obj);
}

void f5o_clear_logs(void *h)
{
    Drv *d = (Drv *)h;
    d->nfx = d->nhc = 0;
    d->nnames = 0;
    d->host_error = d->alloc_fail = d->bad_slot_calls = 0;
}

void f5o_set_fail(void *h, int mask) { ((Drv *)h)->fail = mask; }

/* View rectangles: absolute (0x583186: left top right bottom) and local (0x583196). */
void f5o_set_view(void *h, const int32_t *abs4, const int32_t *local4)
{
    Drv *d = (Drv *)h;
    memcpy(d->view, abs4, sizeof d->view);
    memcpy(d->local, local4, sizeof d->local);
}

/* Queues: f5o_q_set replaces a queue (0 tick, 1 rand, 2 handle); position and underflow are read back. */
void f5o_q_set(void *h, int kind, const int64_t *vals, int n)
{
    Queue *q = &((Drv *)h)->q[kind];
    if (n > QMAX) n = QMAX;
    memset(q, 0, sizeof(*q));
    for (int i = 0; i < n; ++i) q->v[i] = vals[i];
    q->n = n;
}
int f5o_q_pos(void *h, int kind) { return ((Drv *)h)->q[kind].pos; }
int f5o_q_underflow(void *h, int kind) { return ((Drv *)h)->q[kind].underflow; }

#define PK(off, field)  memcpy(b + (off), &(field), sizeof(field))
#define UK(off, field)  memcpy(&(field), b + (off), sizeof(field))

/* The 0x643-byte image of the singleton 0x61ee6e: the bytes without a kernel field come from the shadow set by f5o_obj_set. */
void f5o_obj_get(void *h, uint8_t *b)
{
    const Drv *d = (Drv *)h;
    const TqzObject *o = &d->obj;
    memcpy(b, d->obj_shadow, OBJ_BYTES);
    PK(0x04, o->slot);
    PK(0x06, o->row);
    PK(0x0c, o->surface);
    PK(0x10, o->state);
    PK(0x14, o->active);
    PK(0x18, o->passed);
    PK(0x1c, o->reached);
    PK(0x20, o->finishing);
    PK(0x34, o->flag34);
    PK(0x48, o->count);
    for (int k = 0; k < TQZ_BALLOONS; ++k) {
        const TqzBalloon *e = &o->balloon[k];
        uint8_t *p = b + 0x4a + 0x37 * k;
        memcpy(p + 0x00, e->src, 16);
        memcpy(p + 0x10, e->dst, 16);
        p[0x20] = e->ch;
        memcpy(p + 0x21, &e->text_x, 4);
        memcpy(p + 0x25, &e->text_y, 4);
        memcpy(p + 0x29, &e->deadline, 4);
        memcpy(p + 0x2d, &e->spawn, 4);
        memcpy(p + 0x31, &e->lifetime, 2);
        memcpy(p + 0x33, &e->state, 4);
    }
    memcpy(b + 0x496, o->score_block, sizeof o->score_block);
    PK(0x54e, o->hits);
    PK(0x552, o->score);
    PK(0x556, o->prev_score);
    PK(0x55a, o->dword55a);
    memcpy(b + 0x55e, o->clock_block, sizeof o->clock_block);
    PK(0x626, o->minutes);
    PK(0x62a, o->seconds);
    PK(0x62e, o->start_tick);
    PK(0x632, o->elapsed);
    PK(0x636, o->key_char);
    PK(0x637, o->key_pending);
    PK(0x63b, o->max_char);
    PK(0x63d, o->end_deadline);
    PK(0x641, o->target);
}

void f5o_obj_set(void *h, const uint8_t *b)
{
    Drv *d = (Drv *)h;
    TqzObject *o = &d->obj;
    memcpy(d->obj_shadow, b, OBJ_BYTES);
    UK(0x04, o->slot);
    UK(0x06, o->row);
    UK(0x0c, o->surface);
    UK(0x10, o->state);
    UK(0x14, o->active);
    UK(0x18, o->passed);
    UK(0x1c, o->reached);
    UK(0x20, o->finishing);
    UK(0x34, o->flag34);
    UK(0x48, o->count);
    for (int k = 0; k < TQZ_BALLOONS; ++k) {
        TqzBalloon *e = &o->balloon[k];
        const uint8_t *p = b + 0x4a + 0x37 * k;
        memcpy(e->src, p + 0x00, 16);
        memcpy(e->dst, p + 0x10, 16);
        e->ch = p[0x20];
        memcpy(&e->text_x, p + 0x21, 4);
        memcpy(&e->text_y, p + 0x25, 4);
        memcpy(&e->deadline, p + 0x29, 4);
        memcpy(&e->spawn, p + 0x2d, 4);
        memcpy(&e->lifetime, p + 0x31, 2);
        memcpy(&e->state, p + 0x33, 4);
    }
    memcpy(o->score_block, b + 0x496, sizeof o->score_block);
    UK(0x54e, o->hits);
    UK(0x552, o->score);
    UK(0x556, o->prev_score);
    UK(0x55a, o->dword55a);
    memcpy(o->clock_block, b + 0x55e, sizeof o->clock_block);
    UK(0x626, o->minutes);
    UK(0x62a, o->seconds);
    UK(0x62e, o->start_tick);
    UK(0x632, o->elapsed);
    UK(0x636, o->key_char);
    UK(0x637, o->key_pending);
    UK(0x63b, o->max_char);
    UK(0x63d, o->end_deadline);
    UK(0x641, o->target);
}

/* world image: int32 start flag 0x5bb1ca, int32 played flag 0x5a4c0a, int16 best score 0x5a4c0e (10 bytes). */
void f5o_world_get(void *h, uint8_t *out)
{
    const Drv *d = (Drv *)h;
    memcpy(out, &d->world.start_flag_5bb1ca, 4);
    memcpy(out + 4, &d->world.played_5a4c0a, 4);
    memcpy(out + 8, &d->world.best_5a4c0e, 2);
}

void f5o_world_set(void *h, const uint8_t *in)
{
    Drv *d = (Drv *)h;
    memcpy(&d->world.start_flag_5bb1ca, in, 4);
    memcpy(&d->world.played_5a4c0a, in + 4, 4);
    memcpy(&d->world.best_5a4c0e, in + 8, 2);
}

/* widget image 0x638603..+0x288: four bytes the kernel has no field for, then StdDisplay (starting at +4). */
void f5o_widget_get(void *h, uint8_t *out)
{
    const Drv *d = (Drv *)h;
    memcpy(out, d->wid_shadow, 4);
    memcpy(out + 4, &d->world.display, sizeof d->world.display);
}

void f5o_widget_set(void *h, const uint8_t *in)
{
    Drv *d = (Drv *)h;
    memcpy(d->wid_shadow, in, 4);
    memcpy(&d->world.display, in + 4, sizeof d->world.display);
}

/* cells: mode, 5bb57b, 5bb599, 5bb595, 5c39ff, 5bb59b, 5bb59f, 5bb5a3, transitions made */
void f5o_cells_get(void *h, int32_t *o)
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

void f5o_cells_set(void *h, const int32_t *o)
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

void f5o_events_get(void *h, uint8_t *out) { memcpy(out, ((Drv *)h)->events, sizeof(((Drv *)h)->events)); }
void f5o_events_set(void *h, const uint8_t *in) { memcpy(((Drv *)h)->events, in, sizeof(((Drv *)h)->events)); }
void f5o_entries_get(void *h, uint8_t *out) { memcpy(out, ((Drv *)h)->entries, sizeof(((Drv *)h)->entries)); }
void f5o_entries_set(void *h, const uint8_t *in) { memcpy(((Drv *)h)->entries, in, sizeof(((Drv *)h)->entries)); }
void f5o_entry_set_u32(void *h, int slot, int offset, uint32_t v)
{
    Drv *d = (Drv *)h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT && offset >= 0 && offset + 4 <= (int)ENTRY_STRIDE) put32(d->entries[slot] + offset, v);
}

int f5o_log(void *h, int which, int32_t *out, int max)
{
    const Drv *d = (Drv *)h;
    const int n = which == 0 ? d->nfx : d->nhc;
    const int32_t(*src)[3] = which == 0 ? d->fx : d->hc;
    if (n > max) return -1;
    memcpy(out, src, (size_t)n * 12);
    return n;
}

/* The names the image loader got. */
const char *f5o_str(void *h, int i)
{
    const Drv *d = (Drv *)h;
    if (i < 0 || i >= d->nnames || i >= NAMES) return NULL;
    return d->names[i];
}
int f5o_nstr(void *h) { return ((Drv *)h)->nnames; }

/* host contract violations, allocator failures, out-of-range slot uses */
void f5o_errors(void *h, int32_t *out)
{
    const Drv *d = (Drv *)h;
    out[0] = d->host_error;
    out[1] = d->alloc_fail;
    out[2] = d->bad_slot_calls;
}

/* One true-gate visit of 0x4b8e92. out: status, phase_after, initialized, completed. */
void f5o_step(void *h, const uint8_t *body, int len, int row, uint32_t phase, int32_t *out)
{
    Drv *d = (Drv *)h;
    TqzResult r;
    const char *why = NULL;
    memset(&r, 0, sizeof(r));
    d->body = body;
    out[0] = tqz_step(&d->obj, body, (size_t)len, (int16_t)row, phase, &d->world, &d->host, &r, &why);
    out[1] = (int32_t)r.phase_after;
    out[2] = r.initialized;
    out[3] = r.completed;
    d->body = NULL;
}

/* 0x4b8193: returns 1 when the character was stored. */
int f5o_key(void *h, uint32_t row_phase, int ch) { return tqz_key(&((Drv *)h)->obj, row_phase, (int8_t)ch); }
int f5o_key_filter(int ch) { return tqz_key_filter((int8_t)ch); }

/* out: status, hit, candidate, cursor_kind, cursor_sub */
void f5o_pointer(void *h, const uint8_t *body, int len, int32_t x, int32_t y, int32_t *out)
{
    Drv *d = (Drv *)h;
    TqzPointerResult r;
    memset(&r, 0, sizeof(r));
    out[0] = tqz_pointer(&d->obj, body, (size_t)len, x, y, &r);
    out[1] = r.hit;
    out[2] = r.candidate;
    out[3] = r.cursor_kind;
    out[4] = r.cursor_sub;
}

/* out: clicked (1 when the row phase became 2), new_phase */
void f5o_click(void *h, uint32_t row_phase, int32_t candidate, int32_t *out)
{
    Drv *d = (Drv *)h;
    uint32_t np = row_phase;
    out[0] = tqz_click(&d->obj, row_phase, candidate, &np);
    out[1] = (int32_t)np;
}

int f5o_invalidate(void *h) { return tqz_invalidate(&((Drv *)h)->obj, &((Drv *)h)->host); }
int f5o_cleanup(void *h) { return tqz_cleanup(&((Drv *)h)->obj, &((Drv *)h)->world, &((Drv *)h)->host); }
void f5o_new_game(void *h) { tqz_world_new_game(&((Drv *)h)->world); }
int f5o_validate(const uint8_t *body, int len) { return tqz_validate_body(body, (size_t)len, NULL); }

#define BLIT_INTS 13
#define MAX_OUT TQZ_MAX_BLITS

static void flatten(const TqzRenderResult *r, int status, int32_t *out)
{
    out[0] = status;
    out[1] = r->valid;
    out[2] = r->count;
    for (unsigned i = 0; i < r->count && i < MAX_OUT; ++i) {
        const StdBlit *b = &r->blit[i];
        int32_t *o = out + 3 + BLIT_INTS * i;
        o[0] = b->kind;
        o[1] = (int32_t)b->surface;
        memcpy(o + 2, b->src, 16);
        memcpy(o + 6, b->dst, 16);
        o[10] = b->a;
        o[11] = b->b;
        o[12] = b->c;
    }
}

/* out: status, valid, count, then 13 ints per blit: kind, surface, src[4], dst[4], a, b, c. */
void f5o_render(void *h, const uint8_t *body, int len, int32_t *out)
{
    Drv *d = (Drv *)h;
    static TqzRenderResult r;
    int st;
    memset(&r, 0, sizeof r);
    d->body = body;
    st = tqz_render(&d->obj, &d->world, body, (size_t)len, &d->host, &r);
    d->body = NULL;
    flatten(&r, st, out);
}

void f5o_render_score(void *h, int32_t *out)
{
    Drv *d = (Drv *)h;
    static TqzRenderResult r;
    int st;
    memset(&r, 0, sizeof r);
    st = tqz_render_score(&d->world, &d->host, &r);
    flatten(&r, st, out);
}

void f5o_render_clock(void *h, int32_t *out)
{
    Drv *d = (Drv *)h;
    static TqzRenderResult r;
    int st;
    memset(&r, 0, sizeof r);
    st = tqz_render_clock(&d->world, &d->host, &r);
    flatten(&r, st, out);
}

#ifdef F5O_FUZZ_MAIN
/* ASan / UBSan harness: random bodies of the exact heap length, random objects and worlds the kernel can reach, every entry point.
 * usage: fuzz <inputs> <seed> */
static uint64_t rng_state;
static uint32_t rnd32(void)
{
    rng_state = rng_state * 6364136223846793005ull + 1442695040888963407ull;
    return (uint32_t)(rng_state >> 33);
}

int main(int argc, char **argv)
{
    int n = argc > 1 ? atoi(argv[1]) : 100;
    uint64_t seed = argc > 2 ? (uint64_t)atoll(argv[2]) : 1;
    void *h = f5o_new();
    int accepted = 0, refused = 0;
    rng_state = seed * 0x9E3779B97F4A7C15ull + 7;
    if (h == NULL) return 2;
    for (int it = 0; it < n; ++it) {
        uint8_t *body = (uint8_t *)malloc(TQZ_BODY_BYTES); /* exact heap length: ASan flags any over-read */
        uint8_t img[OBJ_BYTES];
        uint8_t wid[WIDGET_BYTES];
        int64_t q[512];
        int32_t out[3 + BLIT_INTS * MAX_OUT];
        int32_t res[8];
        if (body == NULL) return 2;
        for (size_t i = 0; i < TQZ_BODY_BYTES; ++i) body[i] = (uint8_t)rnd32();
        if (rnd32() % 4 != 0) { /* mostly valid: terminated names, small counts */
            body[0x20] = 0;
            body[0x466 + 0x20] = body[0x497 + 0x20] = body[0x4c8 + 0x20] = body[0x511 + 0x20] = 0;
            body[0x21] = (uint8_t)(1 + rnd32() % 20); body[0x22] = 0;
            body[0x173] = (uint8_t)(1 + rnd32() % 20); body[0x174] = 0;
            body[0x456] = (uint8_t)(rnd32() % 8); body[0x457] = 0;
            body[0x458] = (uint8_t)(8 + rnd32() % 12); body[0x459] = 0;
            body[0x452] = (uint8_t)(rnd32() % 4); body[0x453] = 0;
            body[0x454] = (uint8_t)(4 + rnd32() % 6); body[0x455] = 0;
            body[0x45a] = (uint8_t)(1 + rnd32() % 6); body[0x45b] = 0;
        }
        f5o_reset(h);
        for (size_t i = 0; i < OBJ_BYTES; ++i) img[i] = (uint8_t)rnd32();
        memset(img + 0x4, 0xff, 4);
        img[0x14] = img[0x15] = img[0x16] = img[0x17] = 0;
        for (size_t i = 0; i < WIDGET_BYTES; ++i) wid[i] = (uint8_t)rnd32();
        f5o_obj_set(h, img);
        f5o_widget_set(h, wid);
        for (int i = 0; i < 512; ++i) q[i] = (int64_t)(rnd32() % 32768u);
        f5o_q_set(h, Q_RAND, q, 512);
        for (int i = 0; i < 512; ++i) q[i] = (int64_t)(5000u + (unsigned)i * (rnd32() % 700u));
        f5o_q_set(h, Q_TICK, q, 512);
        q[0] = 0x1234;
        f5o_q_set(h, Q_HANDLE, q, 1);
        if (f5o_validate(body, TQZ_BODY_BYTES) == 0) ++accepted; else ++refused;
        f5o_step(h, body, TQZ_BODY_BYTES, 0, 0u, res);
        for (int s = 0; s < 12; ++s) {
            f5o_key(h, 1u, (int)(rnd32() % 256u));
            f5o_step(h, body, TQZ_BODY_BYTES, 0, 1u, res);
            f5o_render(h, body, TQZ_BODY_BYTES, out);
            f5o_render_score(h, out);
            f5o_render_clock(h, out);
            f5o_pointer(h, body, TQZ_BODY_BYTES, (int32_t)rnd32(), (int32_t)rnd32(), res);
            f5o_click(h, 1u, TQZ_CANDIDATE, res);
            f5o_invalidate(h);
        }
        f5o_step(h, body, TQZ_BODY_BYTES, 0, 2u, res);
        f5o_cleanup(h);
        f5o_step(h, body, TQZ_BODY_BYTES - 1, 0, 0u, res); /* short body: refused */
        free(body);
    }
    printf("fuzz accepted %d refused %d\n", accepted, refused);
    f5o_free(h);
    return 0;
}
#endif
