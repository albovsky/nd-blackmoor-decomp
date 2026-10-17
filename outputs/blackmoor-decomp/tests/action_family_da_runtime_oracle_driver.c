/* RT-59 native side of the raw 0xda Bul puzzle oracle (tests/action_family_da_runtime_original_oracle.py).
 *
 * One handle owns a BulObject (plus the 0x1b9-byte image that stands for the original singleton at 0x624734), a BulWorld (the start
 * flag 0x5bb1ca) and the HOST side of the BulHost contract: scripted queues (GetTickCount values, _rand values, image handles, answers of
 * the sound busy query 0x4f6334, caption texts of 0x423259), a model of the generic Z entry table (0x5d1591, stride 0x4a, 0x58 entries:
 * the allocator 0x4d39f9 takes the first entry in 0x18..0x3f whose +0x18 dword is 0, the inline entry stores of the puzzle, the releaser
 * 0x4d3992 and the invalidate 0x45b477), the event flag window (4096 dwords at 0x585801 + 4 * index), the seven scene-change cells and the
 * engine mode as the transition request stores them, and the view origin 0x583186 / 0x58318a.
 * Two logs are kept for every call:
 *   - the OBSERVER log: what the kernel reports through BulHost.observe (effect, a, b);
 *   - the HOST-CALL log: what the kernel actually asked of the host, encoded as the effect it corresponds to (the host calls that have no
 *     effect id are not logged), so the oracle can check that the observer neither invents nor omits an effect.
 * Three string lists record what the kernel handed to the host (image names, caption-lookup names, shown captions).
 * Everything here is test scaffolding (no kernel logic is repeated): the driver never decides anything the kernel decides.
 * The functions are called through ctypes; every buffer layout is documented at the function. */
#include <stddef.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_da_runtime.h"

#define LOGMAX 16384
#define QMAX 8192
#define CAPMAX 1024
#define EVENTS 4096
#define STRMAX 64
#define STRLEN 256
#define ENTRY_STRIDE 0x4au
#define ENTRY_COUNT 0x58u
#define OBJ_BYTES 0x1b9
#define FX_COUNT 64

enum { Q_TICK, Q_RAND, Q_HANDLE, Q_BUSY, QKINDS };
enum { S_LOADED, S_CAPNAME, S_CAPSHOWN, SKINDS };
enum {
    F_ALLOC = 1, F_REGISTER = 2, F_LOAD = 4, F_SETSURF = 8, F_RELEASE_SURFACE = 16, F_RELEASE_SLOT = 32, F_DIRTY = 64,
    F_VIEW = 128, F_PREPARE = 256, F_STOP = 512, F_PLAY = 1024, F_TRANSITION = 2048, F_FLAG = 4096, F_CLEAR = 8192,
    F_MODE = 16384, F_SHOW = 32768
};
enum { E_TYPE = 0, E_CALLBACK = 4, E_SURFACE = 8, E_F0C = 0xc, E_F10 = 0x10, E_DIRTY = 0x14, E_BUSY = 0x18, E_WORD = 0x1c, E_LABEL = 0x22 };

typedef struct {
    int64_t v[QMAX];
    int n, pos, underflow;
} Queue;

typedef struct {
    int n, pos, underflow;
    int32_t len[CAPMAX]; /* -1: the lookup finds nothing (NULL) */
    char *text[CAPMAX];
} CapQueue;

typedef struct {
    int n;
    char s[STRMAX][STRLEN];
} StrList;

typedef struct {
    BulObject obj;
    BulWorld world;
    uint8_t obj_shadow[OBJ_BYTES]; /* the bytes of the singleton the kernel has no field for */
    Queue q[QKINDS];
    CapQueue cap;
    StrList str[SKINDS];
    uint8_t entries[ENTRY_COUNT][ENTRY_STRIDE];
    uint8_t events[EVENTS * 4];
    int32_t mode;
    int32_t c57b;
    int16_t c599, c595, c39ff;
    int32_t c59b, c59f, c5a3;
    int32_t view_x, view_y;
    int32_t fx[LOGMAX][3];
    int nfx;
    int32_t hc[LOGMAX][3];
    int nhc;
    int transitions;
    int fail;
    int host_error;   /* the host contract was broken (wrong label, record pointer outside the body, wrong callback ...) */
    int alloc_fail;
    int bad_slot_calls;
    const uint8_t *body; /* the body of the current call, to turn record pointers into offsets */
    BulHost host;
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

static void str_add(Drv *d, int kind, const char *s)
{
    StrList *l = &d->str[kind];
    if (l->n < STRMAX) {
        strncpy(l->s[l->n], s, STRLEN - 1);
        l->s[l->n][STRLEN - 1] = 0;
    }
    ++l->n;
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
            hc(d, BUL_FX_SLOT, i, 0);
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
    if (d->fail & F_REGISTER) return 1;
    e = entry(d, slot);
    if (e == NULL) return 1;
    if (callback != BUL_CALLBACK_PUZZLE || type != 10 || surface != 0u) d->host_error++; /* 0x45c423 stores type 10, callback, surface 0 */
    put32(e + E_TYPE, (uint32_t)type);
    put32(e + E_CALLBACK, 0x45d2c6u);
    put32(e + E_SURFACE, surface);
    put32(e + E_F0C, 0u);
    put32(e + E_F10, 0u);
    put32(e + E_DIRTY, 1u);
    put32(e + E_BUSY, 1u);
    put16(e + E_WORD, 0u);
    if (strlen(label) + 1u > ENTRY_STRIDE - E_LABEL) {
        d->host_error++;
        return 1;
    }
    memcpy(e + E_LABEL, label, strlen(label) + 1u); /* the inline repne scasb / rep movs copy */
    hc(d, BUL_FX_SLOT_REGISTER, slot, 0);
    return 0;
}

static int h_load(void *c, const char *name, uint32_t *surface)
{
    Drv *d = (Drv *)c;
    int32_t v = q_pop(d, Q_HANDLE);
    str_add(d, S_LOADED, name);
    if (d->fail & F_LOAD) return 1;
    *surface = (uint32_t)v;
    hc(d, BUL_FX_SURFACE_LOAD, v, 0);
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
    hc(d, BUL_FX_SLOT_SURFACE, slot, (int32_t)surface);
    return 0;
}

static int h_release_surface(void *c, uint32_t surface)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_RELEASE_SURFACE) return 1;
    hc(d, BUL_FX_RELEASE_SURFACE, (int32_t)surface, 0);
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
    hc(d, BUL_FX_RELEASE_SLOT, slot, 0);
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
    hc(d, BUL_FX_MARK_DIRTY, slot, 0);
    return 0;
}

static int h_view(void *c, int32_t *x, int32_t *y)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_VIEW) return 1;
    *x = d->view_x;
    *y = d->view_y;
    return 0;
}

static int h_clear_item(void *c)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_CLEAR) return 1;
    hc(d, BUL_FX_CLEAR_ITEM, 0, 0);
    return 0;
}

/* A sound name is either a record inside the body (reported as its offset) or the caption buffer obj+0x184 (BUL_NO_OFFSET). */
static int32_t sound_offset(Drv *d, const uint8_t *rec)
{
    if (rec == d->obj.sound_name) return BUL_NO_OFFSET;
    if (d->body != NULL && rec >= d->body && rec < d->body + BUL_BODY_BYTES) return (int32_t)(rec - d->body);
    d->host_error++;
    return -2;
}

static int h_prepare(void *c, const uint8_t *rec)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_PREPARE) return 1;
    hc(d, BUL_FX_SOUND_PREPARE, sound_offset(d, rec), 0);
    return 0;
}

static int h_stop(void *c, const uint8_t *rec)
{
    Drv *d = (Drv *)c;
    int32_t off;
    if (d->fail & F_STOP) return 1;
    off = sound_offset(d, rec);
    if (off < 0) d->host_error++; /* a stop is only ever issued on a body record */
    hc(d, BUL_FX_SOUND_STOP, off, 0);
    return 0;
}

static int h_busy(void *c, int16_t channel)
{
    Drv *d = (Drv *)c;
    int32_t v = q_pop(d, Q_BUSY);
    hc(d, BUL_FX_SOUND_BUSY, channel, v != 0);
    return v;
}

static int h_play(void *c, int16_t channel)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_PLAY) return 1;
    hc(d, BUL_FX_SOUND_PLAY, channel, 0);
    return 0;
}

static const char *h_caption_text(void *c, const char *name)
{
    Drv *d = (Drv *)c;
    CapQueue *q = &d->cap;
    str_add(d, S_CAPNAME, name);
    if (q->pos >= q->n) {
        q->underflow = 1;
        q->pos++;
        hc(d, BUL_FX_CAPTION_TEXT, 0, 0);
        return NULL;
    }
    {
        const int i = q->pos++;
        if (q->len[i] < 0) {
            hc(d, BUL_FX_CAPTION_TEXT, 0, 0);
            return NULL;
        }
        hc(d, BUL_FX_CAPTION_TEXT, 1, 0);
        return q->text[i];
    }
}

static int h_caption_show(void *c, const char *text)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_SHOW) return 1;
    str_add(d, S_CAPSHOWN, text);
    hc(d, BUL_FX_CAPTION_SHOW, (int32_t)strlen(text), 0);
    return 0;
}

static uint32_t h_tick(void *c)
{
    Drv *d = (Drv *)c;
    int32_t v = q_pop(d, Q_TICK);
    hc(d, BUL_FX_TICK, v, 0);
    return (uint32_t)v;
}

static int32_t h_random(void *c)
{
    Drv *d = (Drv *)c;
    int32_t v = q_pop(d, Q_RAND);
    hc(d, BUL_FX_RANDOM, v, 0);
    return v;
}

static int h_flag_invalid(void *c, int16_t index)
{
    (void)c;
    return index < 0 || index >= EVENTS;
}

static int h_transition(void *c, const BulTransition *t)
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
    hc(d, BUL_FX_EVENT_FLAG, index, (int32_t)value);
    return 0;
}

static int h_engine_mode(void *c, int32_t mode)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_MODE) return 1;
    d->mode = mode;
    hc(d, BUL_FX_ENGINE_MODE, mode, 0);
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
    d->host.view_origin = h_view;
    d->host.clear_pending_item = h_clear_item;
    d->host.sound_prepare = h_prepare;
    d->host.sound_stop = h_stop;
    d->host.sound_busy = h_busy;
    d->host.sound_play = h_play;
    d->host.caption_text = h_caption_text;
    d->host.caption_show = h_caption_show;
    d->host.tick = h_tick;
    d->host.random = h_random;
    d->host.event_flag_invalid = h_flag_invalid;
    d->host.transition = h_transition;
    d->host.store_event_flag = h_store_flag;
    d->host.engine_mode = h_engine_mode;
    d->host.observe = h_observe;
}

static void cap_free(CapQueue *q)
{
    for (int i = 0; i < q->n; ++i) free(q->text[i]);
    memset(q, 0, sizeof(*q));
}

void *buo_new(void)
{
    Drv *d = (Drv *)calloc(1, sizeof(Drv));
    if (d == NULL) return NULL;
    wire(d);
    bul_object_reset(&d->obj);
    return d;
}

void buo_free(void *h)
{
    Drv *d = (Drv *)h;
    if (d == NULL) return;
    cap_free(&d->cap);
    free(d);
}

void buo_reset(void *h)
{
    Drv *d = (Drv *)h;
    cap_free(&d->cap);
    memset(d, 0, sizeof(*d));
    wire(d);
    bul_object_reset(&d->obj);
}

void buo_clear_logs(void *h)
{
    Drv *d = (Drv *)h;
    d->nfx = d->nhc = 0;
    for (int k = 0; k < SKINDS; ++k) d->str[k].n = 0;
    d->host_error = d->alloc_fail = d->bad_slot_calls = 0;
}

void buo_set_fail(void *h, int mask) { ((Drv *)h)->fail = mask; }

/* The view origin: left [0x583186] and top [0x58318a]. */
void buo_set_view(void *h, int32_t x, int32_t y)
{
    Drv *d = (Drv *)h;
    d->view_x = x;
    d->view_y = y;
}

/* Queues: buo_q_set replaces a queue (0 tick, 1 rand, 2 handle, 3 busy); position and underflow are read back. */
void buo_q_set(void *h, int kind, const int64_t *vals, int n)
{
    Queue *q = &((Drv *)h)->q[kind];
    if (n > QMAX) n = QMAX;
    memset(q, 0, sizeof(*q));
    for (int i = 0; i < n; ++i) q->v[i] = vals[i];
    q->n = n;
}
int buo_q_pos(void *h, int kind) { return ((Drv *)h)->q[kind].pos; }
int buo_q_underflow(void *h, int kind) { return ((Drv *)h)->q[kind].underflow; }

/* The caption texts of 0x423259: n entries, lens[i] = -1 for "not found", else the length; blob = the texts back to back. */
void buo_cap_set(void *h, const uint8_t *blob, const int32_t *lens, int n)
{
    CapQueue *q = &((Drv *)h)->cap;
    size_t at = 0;
    cap_free(q);
    if (n > CAPMAX) n = CAPMAX;
    for (int i = 0; i < n; ++i) {
        q->len[i] = lens[i];
        if (lens[i] >= 0) {
            q->text[i] = (char *)malloc((size_t)lens[i] + 1u);
            if (q->text[i] == NULL) {
                q->n = i;
                return;
            }
            memcpy(q->text[i], blob + at, (size_t)lens[i]);
            q->text[i][lens[i]] = 0;
            at += (size_t)lens[i];
        }
    }
    q->n = n;
}
int buo_cap_pos(void *h) { return ((Drv *)h)->cap.pos; }
int buo_cap_underflow(void *h) { return ((Drv *)h)->cap.underflow; }

#define PK(off, field)  memcpy(b + (off), &(field), sizeof(field))
#define UK(off, field)  memcpy(&(field), b + (off), sizeof(field))

/* The 0x1b9-byte image of the singleton 0x624734: the bytes without a kernel field come from the shadow set by buo_obj_set. */
void buo_obj_get(void *h, uint8_t *b)
{
    const Drv *d = (Drv *)h;
    const BulObject *o = &d->obj;
    memcpy(b, d->obj_shadow, OBJ_BYTES);
    PK(0x1c, o->slot);
    PK(0x1e, o->row);
    PK(0x20, o->surface);
    PK(0x24, o->state);
    PK(0x28, o->anim_active);
    PK(0x2c, o->button_kind);
    PK(0x2e, o->anim_deadline);
    PK(0x32, o->button_down);
    for (int i = 0; i < 4; ++i) {
        PK(0x36 + 16 * i, o->roll_a[i]);
        PK(0x76 + 16 * i, o->roll_b[i]);
        PK(0x11c + 16 * i, o->clear[i]);
    }
    PK(0xb6, o->score_player);
    PK(0xb8, o->score_computer);
    PK(0xba, o->mode);
    PK(0xbc, o->cur_player);
    PK(0xcc, o->cur_computer);
    PK(0xdc, o->moving);
    PK(0xec, o->image_player);
    PK(0xfc, o->image_computer);
    PK(0x10c, o->erase);
    PK(0x15c, o->side);
    PK(0x15e, o->light);
    PK(0x162, o->finish_kind);
    PK(0x166, o->active);
    PK(0x16a, o->won);
    PK(0x16e, o->deadline_16e);
    PK(0x172, o->pending_button);
    PK(0x174, o->moves);
    PK(0x176, o->step);
    PK(0x178, o->pos_player);
    PK(0x17a, o->pos_computer);
    PK(0x17c, o->deadline_17c);
    PK(0x180, o->deadline_180);
    memcpy(b + 0x184, o->sound_name, sizeof o->sound_name);
    PK(0x1a5, o->cap_channel);
    PK(0x1a7, o->cap_1a7);
    PK(0x1a9, o->cap_1a9);
    PK(0x1ab, o->cap_1ab);
    PK(0x1ad, o->cap_1ad);
    PK(0x1b1, o->cap_1b1);
    PK(0x1b3, o->cap_1b3);
    PK(0x1b5, o->next_state);
}

void buo_obj_set(void *h, const uint8_t *b)
{
    Drv *d = (Drv *)h;
    BulObject *o = &d->obj;
    memcpy(d->obj_shadow, b, OBJ_BYTES);
    UK(0x1c, o->slot);
    UK(0x1e, o->row);
    UK(0x20, o->surface);
    UK(0x24, o->state);
    UK(0x28, o->anim_active);
    UK(0x2c, o->button_kind);
    UK(0x2e, o->anim_deadline);
    UK(0x32, o->button_down);
    for (int i = 0; i < 4; ++i) {
        UK(0x36 + 16 * i, o->roll_a[i]);
        UK(0x76 + 16 * i, o->roll_b[i]);
        UK(0x11c + 16 * i, o->clear[i]);
    }
    UK(0xb6, o->score_player);
    UK(0xb8, o->score_computer);
    UK(0xba, o->mode);
    UK(0xbc, o->cur_player);
    UK(0xcc, o->cur_computer);
    UK(0xdc, o->moving);
    UK(0xec, o->image_player);
    UK(0xfc, o->image_computer);
    UK(0x10c, o->erase);
    UK(0x15c, o->side);
    UK(0x15e, o->light);
    UK(0x162, o->finish_kind);
    UK(0x166, o->active);
    UK(0x16a, o->won);
    UK(0x16e, o->deadline_16e);
    UK(0x172, o->pending_button);
    UK(0x174, o->moves);
    UK(0x176, o->step);
    UK(0x178, o->pos_player);
    UK(0x17a, o->pos_computer);
    UK(0x17c, o->deadline_17c);
    UK(0x180, o->deadline_180);
    memcpy(o->sound_name, b + 0x184, sizeof o->sound_name);
    UK(0x1a5, o->cap_channel);
    UK(0x1a7, o->cap_1a7);
    UK(0x1a9, o->cap_1a9);
    UK(0x1ab, o->cap_1ab);
    UK(0x1ad, o->cap_1ad);
    UK(0x1b1, o->cap_1b1);
    UK(0x1b3, o->cap_1b3);
    UK(0x1b5, o->next_state);
}

/* world image: int32 start flag 0x5bb1ca (4 bytes). */
void buo_world_get(void *h, uint8_t *out) { memcpy(out, &((Drv *)h)->world.start_flag_5bb1ca, 4); }
void buo_world_set(void *h, const uint8_t *in) { memcpy(&((Drv *)h)->world.start_flag_5bb1ca, in, 4); }

/* cells: mode, 5bb57b, 5bb599, 5bb595, 5c39ff, 5bb59b, 5bb59f, 5bb5a3, transitions made */
void buo_cells_get(void *h, int32_t *o)
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

void buo_cells_set(void *h, const int32_t *o)
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

void buo_events_get(void *h, uint8_t *out) { memcpy(out, ((Drv *)h)->events, sizeof(((Drv *)h)->events)); }
void buo_events_set(void *h, const uint8_t *in) { memcpy(((Drv *)h)->events, in, sizeof(((Drv *)h)->events)); }
void buo_entries_get(void *h, uint8_t *out) { memcpy(out, ((Drv *)h)->entries, sizeof(((Drv *)h)->entries)); }
void buo_entries_set(void *h, const uint8_t *in) { memcpy(((Drv *)h)->entries, in, sizeof(((Drv *)h)->entries)); }
void buo_entry_set_u32(void *h, int slot, int offset, uint32_t v)
{
    Drv *d = (Drv *)h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT && offset >= 0 && offset + 4 <= (int)ENTRY_STRIDE) put32(d->entries[slot] + offset, v);
}

int buo_log(void *h, int which, int32_t *out, int max)
{
    const Drv *d = (Drv *)h;
    const int n = which == 0 ? d->nfx : d->nhc;
    const int32_t(*src)[3] = which == 0 ? d->fx : d->hc;
    if (n > max) return -1;
    memcpy(out, src, (size_t)n * 12);
    return n;
}

/* The strings the kernel handed to the host: kind 0 image names, 1 caption-lookup names, 2 shown captions (text + suffix). */
const char *buo_str(void *h, int kind, int i)
{
    const Drv *d = (Drv *)h;
    if (kind < 0 || kind >= SKINDS || i < 0 || i >= d->str[kind].n || i >= STRMAX) return NULL;
    return d->str[kind].s[i];
}
int buo_nstr(void *h, int kind) { return kind < 0 || kind >= SKINDS ? 0 : ((Drv *)h)->str[kind].n; }

/* host contract violations, allocator failures, out-of-range slot uses */
void buo_errors(void *h, int32_t *out)
{
    const Drv *d = (Drv *)h;
    out[0] = d->host_error;
    out[1] = d->alloc_fail;
    out[2] = d->bad_slot_calls;
}

/* One true-gate visit of 0x45c18f. out: status, phase_after, initialized, completed. */
void buo_step(void *h, const uint8_t *body, int len, int row, uint32_t phase, int32_t *out)
{
    Drv *d = (Drv *)h;
    BulResult r;
    const char *why = NULL;
    memset(&r, 0, sizeof(r));
    d->body = body;
    out[0] = bul_step(&d->obj, body, (size_t)len, (int16_t)row, phase, &d->world, &d->host, &r, &why);
    out[1] = (int32_t)r.phase_after;
    out[2] = r.initialized;
    out[3] = r.completed;
    d->body = NULL;
}

/* out: status, hit, candidate, cursor_kind, cursor_sub, cursor_cell, cursor_link, button */
void buo_pointer(void *h, const uint8_t *body, int len, int32_t x, int32_t y, int32_t *out)
{
    Drv *d = (Drv *)h;
    BulPointerResult r;
    memset(&r, 0, sizeof(r));
    out[0] = bul_pointer(&d->obj, body, (size_t)len, x, y, &r);
    out[1] = r.hit;
    out[2] = r.candidate;
    out[3] = r.cursor_kind;
    out[4] = r.cursor_sub;
    out[5] = (int32_t)r.cursor_cell;
    out[6] = r.cursor_link;
    out[7] = r.button;
}

/* out: status, handled, new_phase */
void buo_click(void *h, const uint8_t *body, int len, uint32_t row_phase, int32_t candidate, int32_t *out)
{
    Drv *d = (Drv *)h;
    BulClickResult r;
    memset(&r, 0, sizeof(r));
    d->body = body;
    out[0] = bul_click(&d->obj, body, (size_t)len, &d->world, &d->host, row_phase, candidate, &r);
    out[1] = r.handled;
    out[2] = (int32_t)r.new_phase;
    d->body = NULL;
}

int buo_invalidate(void *h) { return bul_invalidate(&((Drv *)h)->obj, &((Drv *)h)->host); }
int buo_cleanup(void *h) { return bul_cleanup(&((Drv *)h)->obj, &((Drv *)h)->host); }
int buo_validate(const uint8_t *body, int len) { return bul_validate_body(body, (size_t)len, NULL); }

#define BLIT_INTS 11
#define MAX_OUT BUL_MAX_BLITS

/* out: status, valid, count, then 11 ints per blit: kind, index, backdrop, src[4], dst[4]. */
void buo_render(void *h, const uint8_t *body, int len, int32_t *out)
{
    Drv *d = (Drv *)h;
    static BulRenderResult r;
    memset(&r, 0, sizeof r);
    d->body = body;
    out[0] = bul_render(&d->obj, body, (size_t)len, &d->host, &r);
    d->body = NULL;
    out[1] = r.valid;
    out[2] = r.count;
    for (unsigned i = 0; i < r.count && i < MAX_OUT; ++i) {
        const BulBlit *b = &r.blit[i];
        int32_t *o = out + 3 + BLIT_INTS * i;
        o[0] = b->kind;
        o[1] = b->index;
        o[2] = b->backdrop;
        memcpy(o + 3, &b->src, 16);
        memcpy(o + 7, &b->dst, 16);
    }
}

#ifdef BUO_FUZZ_MAIN
/* ASan / UBSan harness: random bodies of the exact heap length, random objects the kernel can reach, every entry point.
 * usage: fuzz <inputs> <seed> */
static uint64_t rng_state;
static uint32_t rnd32(void)
{
    rng_state = rng_state * 6364136223846793005ull + 1442695040888963407ull;
    return (uint32_t)(rng_state >> 33);
}

static void put_i16(uint8_t *p, int v) { put16(p, (uint16_t)v); }

int main(int argc, char **argv)
{
    int n = argc > 1 ? atoi(argv[1]) : 100;
    uint64_t seed = argc > 2 ? (uint64_t)atoll(argv[2]) : 1;
    void *h = buo_new();
    int accepted = 0, refused = 0;
    rng_state = seed * 0x9E3779B97F4A7C15ull + 7;
    if (h == NULL) return 2;
    for (int it = 0; it < n; ++it) {
        uint8_t *body = (uint8_t *)malloc(BUL_BODY_BYTES); /* exact heap length: ASan flags any over-read */
        uint8_t img[OBJ_BYTES];
        int64_t q[512];
        int32_t out[3 + BLIT_INTS * MAX_OUT];
        int32_t res[8];
        int32_t lens[64];
        uint8_t blob[64 * 8];
        if (body == NULL) return 2;
        for (size_t i = 0; i < BUL_BODY_BYTES; ++i) body[i] = (uint8_t)rnd32();
        if (rnd32() % 4 != 0) { /* mostly valid: terminated names, small counts */
            body[0x20] = 0;
            for (int i = 0; i < 4; ++i) body[BUL_B_SOUND_STEP + 0x31 * i + 0x20] = 0;
            for (int e = 0; e < 2; ++e) {
                for (int i = 0; i < 22; ++i) body[BUL_B_CAPTION + BUL_B_CAPTION_STRIDE * e + 6 + 0x21 * i + 0x20] = 0;
            }
            put_i16(body + BUL_B_POSITIONS, 1 + (int)(rnd32() % 15));
            put_i16(body + BUL_B_PIECES, 1 + (int)(rnd32() % 6));
            put_i16(body + BUL_B_START_PLAYER, 1 + (int)(rnd32() % 4));
            put_i16(body + BUL_B_START_COMPUTER, 1 + (int)(rnd32() % 4));
            if (rnd32() % 3 == 0) memcpy(body + BUL_B_CAPTION + 6 + 0x21 * 2, "NO SOUND", 9);
        }
        buo_reset(h);
        for (size_t i = 0; i < OBJ_BYTES; ++i) img[i] = (uint8_t)rnd32();
        memset(img + 0x1c, 0xff, 4);
        put32(img + 0x20, 0);
        put32(img + 0x166, 0);
        put_i16(img + 0xb6, (int)(rnd32() % 3));
        put_i16(img + 0xb8, (int)(rnd32() % 3));
        put_i16(img + 0xba, (int)(rnd32() % 4));
        put_i16(img + 0x15c, (int)(rnd32() % 2));
        put_i16(img + 0x2c, (int)(rnd32() % 3));
        put_i16(img + 0x172, (int)(rnd32() % 4));
        put_i16(img + 0x178, 1 + (int)(rnd32() % 4));
        put_i16(img + 0x17a, 1 + (int)(rnd32() % 4));
        buo_obj_set(h, img);
        for (int i = 0; i < 512; ++i) q[i] = (int64_t)(rnd32() % 32768u);
        buo_q_set(h, Q_RAND, q, 512);
        for (int i = 0; i < 512; ++i) q[i] = (int64_t)(5000u + (unsigned)i * (rnd32() % 700u));
        buo_q_set(h, Q_TICK, q, 512);
        for (int i = 0; i < 512; ++i) q[i] = (int64_t)(rnd32() % 2u);
        buo_q_set(h, Q_BUSY, q, 512);
        q[0] = 0x1234;
        buo_q_set(h, Q_HANDLE, q, 1);
        for (int i = 0; i < 64; ++i) {
            lens[i] = (rnd32() % 4 == 0) ? -1 : (int32_t)(rnd32() % 8);
            for (int k = 0; k < 8; ++k) blob[i * 8 + k] = (uint8_t)('a' + rnd32() % 26);
        }
        {
            uint8_t packed[64 * 8];
            size_t at = 0;
            for (int i = 0; i < 64; ++i) {
                if (lens[i] > 0) {
                    memcpy(packed + at, blob + i * 8, (size_t)lens[i]);
                    at += (size_t)lens[i];
                }
            }
            buo_cap_set(h, packed, lens, 64);
        }
        if (buo_validate(body, BUL_BODY_BYTES) == 0) ++accepted; else ++refused;
        buo_step(h, body, BUL_BODY_BYTES, 0, 0u, res);
        for (int s = 0; s < 12; ++s) {
            buo_step(h, body, BUL_BODY_BYTES, 0, 1u, res);
            buo_render(h, body, BUL_BODY_BYTES, out);
            buo_pointer(h, body, BUL_BODY_BYTES, (int32_t)rnd32(), (int32_t)rnd32(), res);
            buo_click(h, body, BUL_BODY_BYTES, 1u, (rnd32() & 1u) ? BUL_CANDIDATE_BUTTON : BUL_CANDIDATE_FINISH, res);
            buo_invalidate(h);
        }
        buo_step(h, body, BUL_BODY_BYTES, 0, 2u, res);
        buo_cleanup(h);
        buo_step(h, body, BUL_BODY_BYTES - 1, 0, 0u, res); /* short body: refused */
        free(body);
    }
    printf("fuzz accepted %d refused %d\n", accepted, refused);
    buo_free(h);
    return 0;
}
#endif
