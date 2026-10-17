/* RT-54 native side of the raw 0xe4 Match Puzzle oracle (tests/action_family_e4_runtime_original_oracle.py).
 *
 * One handle owns an E4rObject (the 0x8da-byte image that stands for the original singleton at 0x622fa2, byte for byte), an E4rWorld
 * (start flag 0x5bb1ca, high score marker 0x5a0545, the five dwords at 0x5a0549) and the HOST side of the E4rHost contract with
 * scripted queues (tick values, sound-busy answers, image handles, 15-bit rand values, text extents), a model of the generic Z
 * entry table (0x5d1591, stride 0x4a, 0x58 entries: the allocator 0x4d39f9 takes the first entry in 0x18..0x3f whose +0x18 dword
 * is 0, the inline entry stores of the handler, the releaser 0x4d3992 and the invalidate 0x4758e8), the event flag window (4096
 * dwords at 0x585801 + 4 * index), the seven scene-change cells and the engine mode as the transition request stores them, and the
 * view rectangle 0x583186 with the full rectangle 0x583196.
 * Two logs are kept for every call:
 *   - the OBSERVER log: what the kernel reports through E4rHost.observe (effect, a, b);
 *   - the HOST-CALL log: what the kernel actually asked of the host, encoded as the effect it corresponds to (plus view_rects =
 *     101), so the oracle can check that the observer neither invents nor omits an effect.
 * Everything here is test scaffolding (no kernel logic is repeated): the driver never decides anything the kernel decides.
 * Called through ctypes; every buffer layout is documented at the function. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_e4_runtime.h"

#define LOGMAX 4096
#define QMAX 1024
#define EVENTS 4096
#define NAMES 8
#define ENTRY_STRIDE 0x4au
#define ENTRY_COUNT 0x58u
#define HC_VIEW 101

enum { Q_TICK, Q_BUSY, Q_HANDLE, Q_RAND, Q_EXTENT, QKINDS };
enum {
    F_ALLOC = 1 << 0, F_REGISTER = 1 << 1, F_LOAD = 1 << 2, F_SETSURF = 1 << 3, F_RELEASE_SURFACE = 1 << 4, F_RELEASE_SLOT = 1 << 5,
    F_DIRTY = 1 << 6, F_VIEW = 1 << 7, F_PREPARE = 1 << 8, F_STOP = 1 << 9, F_PLAY = 1 << 10, F_BUSY = 1 << 11, F_RANDOM = 1 << 12,
    F_AMBIENT = 1 << 13, F_FONT = 1 << 14, F_EXTENT = 1 << 15, F_TRANSITION = 1 << 16, F_FLAG = 1 << 17
};
enum { E_TYPE = 0, E_CALLBACK = 4, E_SURFACE = 8, E_F0C = 0xc, E_F10 = 0x10, E_DIRTY = 0x14, E_BUSY = 0x18, E_WORD = 0x1c, E_LABEL = 0x22 };

typedef struct {
    int64_t v[QMAX];
    int n, pos, underflow;
} Queue;

typedef struct {
    E4rObject obj;
    E4rWorld world;
    Queue q[QKINDS];
    uint8_t entries[ENTRY_COUNT][ENTRY_STRIDE];
    uint8_t events[EVENTS * 4];
    int32_t mode;
    int32_t c57b;
    int16_t c599, c595, c39ff;
    int32_t c59b, c59f, c5a3;
    int32_t view[4], full[4];
    int32_t fx[LOGMAX][3];
    int nfx;
    int32_t hc[LOGMAX][3];
    int nhc;
    int log_overflow;
    char names[NAMES][40];
    int name_kinds[NAMES];
    int nnames;
    int transitions;
    int fail;
    int host_error;   /* the host contract was broken (wrong label, record pointer outside the body, ...) */
    int alloc_fail;
    int bad_slot_calls;
    const uint8_t *body; /* the body of the current call, to turn record pointers into offsets */
    E4rRenderResult render;
    E4rHost host;
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
    } else {
        d->log_overflow = 1;
    }
}

static int h_alloc(void *c, int16_t *slot)
{
    Drv *d = (Drv *)c;
    int i;
    if (d->fail & F_ALLOC) return 1;
    for (i = 0x18; i <= 0x3f; ++i) {
        uint32_t busy;
        memcpy(&busy, d->entries[i] + E_BUSY, 4);
        if (busy == 0u) {
            *slot = (int16_t)i;
            hc(d, E4R_FX_SLOT, i, 0);
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
    if (strcmp(label, "MATCH PUZZLE OVERLAYS") != 0) d->host_error++;
    put32(e + E_TYPE, 10u);
    put32(e + E_CALLBACK, 0x4778dfu);
    put32(e + E_SURFACE, 0u);
    put32(e + E_F0C, 0u);
    put32(e + E_F10, 0u);
    put32(e + E_DIRTY, 1u);
    put32(e + E_BUSY, 1u);
    put16(e + E_WORD, 0u);
    memcpy(e + E_LABEL, label, strlen(label) + 1u); /* the inline repne scasb / rep movs copy */
    hc(d, E4R_FX_SLOT_REGISTER, slot, 0);
    return 0;
}

static int h_load(void *c, int kind, const char *name, uint32_t *surface)
{
    Drv *d = (Drv *)c;
    int32_t v = q_pop(d, Q_HANDLE);
    if (d->nnames < NAMES) {
        strncpy(d->names[d->nnames], name, 39);
        d->names[d->nnames][39] = 0;
        d->name_kinds[d->nnames] = kind;
    }
    ++d->nnames;
    if (d->fail & F_LOAD) return 1;
    *surface = (uint32_t)v;
    hc(d, E4R_FX_SURFACE_LOAD, kind, v);
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
    hc(d, E4R_FX_SLOT_SURFACE, slot, (int32_t)surface);
    return 0;
}

static int h_release_surface(void *c, uint32_t surface)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_RELEASE_SURFACE) return 1;
    hc(d, E4R_FX_RELEASE_SURFACE, (int32_t)surface, 0); /* b (which surface) is not part of the host call */
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
    hc(d, E4R_FX_RELEASE_SLOT, slot, 0);
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
    hc(d, E4R_FX_MARK_DIRTY, slot, 0);
    return 0;
}

static int h_view(void *c, int32_t view[4], int32_t full[4])
{
    Drv *d = (Drv *)c;
    if (d->fail & F_VIEW) return 1;
    memcpy(view, d->view, sizeof d->view);
    memcpy(full, d->full, sizeof d->full);
    hc(d, HC_VIEW, d->view[0], d->view[1]);
    return 0;
}

static int h_prepare(void *c, const uint8_t *rec)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_PREPARE) return 1;
    hc(d, E4R_FX_SOUND_PREPARE, (int32_t)(rec - d->body), 0);
    return 0;
}

static int h_stop(void *c, const uint8_t *rec)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_STOP) return 1;
    hc(d, E4R_FX_SOUND_STOP, (int32_t)(rec - d->body), 0);
    return 0;
}

static int h_play(void *c, int16_t channel)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_PLAY) return 1;
    hc(d, E4R_FX_SOUND_PLAY, channel, 0);
    return 0;
}

static int h_busy(void *c, int16_t channel, int32_t *result)
{
    Drv *d = (Drv *)c;
    int32_t v = q_pop(d, Q_BUSY);
    if (d->fail & F_BUSY) return 1;
    *result = v;
    hc(d, E4R_FX_SOUND_BUSY, channel, v);
    return 0;
}

static uint32_t h_tick(void *c)
{
    Drv *d = (Drv *)c;
    int32_t v = q_pop(d, Q_TICK);
    hc(d, E4R_FX_TICK, v, 0);
    return (uint32_t)v;
}

static int h_random(void *c, int32_t *value)
{
    Drv *d = (Drv *)c;
    int32_t v = q_pop(d, Q_RAND);
    if (d->fail & F_RANDOM) return 1;
    *value = v;
    hc(d, E4R_FX_RAND, v, 0);
    return 0;
}

static int h_ambient(void *c)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_AMBIENT) return 1;
    hc(d, E4R_FX_AMBIENT_STOP, 0, 0);
    return 0;
}

static int h_font_release(void *c, int16_t font)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_FONT) return 1;
    hc(d, E4R_FX_FONT_RELEASE, font, 0);
    return 0;
}

static int h_extent(void *c, int16_t font, int16_t *height)
{
    Drv *d = (Drv *)c;
    int32_t v = q_pop(d, Q_EXTENT);
    if (d->fail & F_EXTENT) return 1;
    *height = (int16_t)v;
    hc(d, E4R_FX_TEXT_EXTENT, font, (int16_t)v);
    return 0;
}

static int h_flag_invalid(void *c, int16_t index)
{
    (void)c;
    return index < 0 || index >= EVENTS;
}

static int h_transition(void *c, const E4rTransition *t)
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
    hc(d, E4R_FX_XFER_5BB57B, t->scene, 0);
    hc(d, E4R_FX_XFER_5BB599, t->word[0], 0);
    hc(d, E4R_FX_XFER_5BB595, t->word[1], 0);
    hc(d, E4R_FX_XFER_5C39FF, t->word[2], 0);
    hc(d, E4R_FX_XFER_5BB59B, t->dword[0], 0);
    hc(d, E4R_FX_XFER_5BB59F, t->dword[1], 0);
    hc(d, E4R_FX_XFER_5BB5A3, t->dword[2], 0);
    hc(d, E4R_FX_ENGINE_MODE, 4, 0);
    return 0;
}

static int h_store_flag(void *c, int16_t index, uint32_t value)
{
    Drv *d = (Drv *)c;
    if (d->fail & F_FLAG) return 1;
    if (index < 0 || index >= EVENTS) return 1;
    put32(d->events + 4 * (size_t)index, value);
    hc(d, E4R_FX_EVENT_FLAG, index, (int32_t)value);
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
    } else {
        d->log_overflow = 1;
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
    d->host.sound_prepare = h_prepare;
    d->host.sound_stop = h_stop;
    d->host.sound_play = h_play;
    d->host.sound_busy = h_busy;
    d->host.tick = h_tick;
    d->host.random = h_random;
    d->host.stop_ambient = h_ambient;
    d->host.font_release = h_font_release;
    d->host.text_extent = h_extent;
    d->host.event_flag_invalid = h_flag_invalid;
    d->host.transition = h_transition;
    d->host.store_event_flag = h_store_flag;
    d->host.observe = h_observe;
}

void *e4o_new(void)
{
    Drv *d = (Drv *)calloc(1, sizeof(Drv));
    if (d == NULL) return NULL;
    wire(d);
    e4r_object_reset(&d->obj);
    return d;
}

void e4o_free(void *h) { free(h); }

void e4o_reset(void *h)
{
    Drv *d = (Drv *)h;
    memset(d, 0, sizeof(*d));
    wire(d);
    e4r_object_reset(&d->obj);
}

void e4o_clear_logs(void *h)
{
    Drv *d = (Drv *)h;
    d->nfx = d->nhc = 0;
    d->nnames = 0;
    d->log_overflow = 0;
    d->host_error = d->alloc_fail = d->bad_slot_calls = 0;
}

void e4o_set_fail(void *h, int mask) { ((Drv *)h)->fail = mask; }

/* view[4] then full[4] */
void e4o_set_rects(void *h, const int32_t *r)
{
    Drv *d = (Drv *)h;
    memcpy(d->view, r, sizeof d->view);
    memcpy(d->full, r + 4, sizeof d->full);
}

/* Queues: e4o_q_set replaces a queue (0 tick, 1 busy, 2 handle, 3 rand, 4 extent); position and underflow are read back. */
void e4o_q_set(void *h, int kind, const int64_t *vals, int n)
{
    Queue *q = &((Drv *)h)->q[kind];
    int i;
    if (n > QMAX) n = QMAX;
    memset(q, 0, sizeof(*q));
    for (i = 0; i < n; ++i) q->v[i] = vals[i];
    q->n = n;
}
int e4o_q_pos(void *h, int kind) { return ((Drv *)h)->q[kind].pos; }
int e4o_q_underflow(void *h, int kind) { return ((Drv *)h)->q[kind].underflow; }

/* The 0x8da-byte image of the singleton 0x622fa2: the object itself. */
void e4o_obj_get(void *h, uint8_t *b) { memcpy(b, ((Drv *)h)->obj.b, E4R_OBJECT_BYTES); }
void e4o_obj_set(void *h, const uint8_t *b) { memcpy(((Drv *)h)->obj.b, b, E4R_OBJECT_BYTES); }

/* world: start flag 0x5bb1ca, marker 0x5a0545, five dwords at 0x5a0549 */
void e4o_world_get(void *h, int32_t *o)
{
    const Drv *d = (Drv *)h;
    int i;
    o[0] = d->world.start_flag_5bb1ca;
    o[1] = d->world.high_score_marker_5a0545;
    for (i = 0; i < E4R_HIGH_SCORES; ++i) o[2 + i] = d->world.high_score[i];
}

void e4o_world_set(void *h, const int32_t *o)
{
    Drv *d = (Drv *)h;
    int i;
    d->world.start_flag_5bb1ca = o[0];
    d->world.high_score_marker_5a0545 = o[1];
    for (i = 0; i < E4R_HIGH_SCORES; ++i) d->world.high_score[i] = o[2 + i];
}

/* cells: mode, 5bb57b, 5bb599, 5bb595, 5c39ff, 5bb59b, 5bb59f, 5bb5a3, transitions made */
void e4o_cells_get(void *h, int32_t *o)
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

void e4o_cells_set(void *h, const int32_t *o)
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

void e4o_events_get(void *h, uint8_t *out) { memcpy(out, ((Drv *)h)->events, sizeof(((Drv *)h)->events)); }
void e4o_events_set(void *h, const uint8_t *in) { memcpy(((Drv *)h)->events, in, sizeof(((Drv *)h)->events)); }
void e4o_entries_get(void *h, uint8_t *out) { memcpy(out, ((Drv *)h)->entries, sizeof(((Drv *)h)->entries)); }
void e4o_entries_set(void *h, const uint8_t *in) { memcpy(((Drv *)h)->entries, in, sizeof(((Drv *)h)->entries)); }
void e4o_entry_set_u32(void *h, int slot, int offset, uint32_t v)
{
    Drv *d = (Drv *)h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT && offset >= 0 && offset + 4 <= (int)ENTRY_STRIDE) put32(d->entries[slot] + offset, v);
}

int e4o_log(void *h, int which, int32_t *out, int max)
{
    const Drv *d = (Drv *)h;
    const int n = which == 0 ? d->nfx : d->nhc;
    const int32_t(*src)[3] = which == 0 ? d->fx : d->hc;
    if (n > max || d->log_overflow) return -1;
    memcpy(out, src, (size_t)n * 12);
    return n;
}

/* The names the image loader got (with the kind 0 puzzle / 1 score). */
const char *e4o_str(void *h, int i)
{
    const Drv *d = (Drv *)h;
    if (i < 0 || i >= d->nnames || i >= NAMES) return NULL;
    return d->names[i];
}
int e4o_str_kind(void *h, int i)
{
    const Drv *d = (Drv *)h;
    if (i < 0 || i >= d->nnames || i >= NAMES) return -1;
    return d->name_kinds[i];
}
int e4o_nstr(void *h) { return ((Drv *)h)->nnames; }

/* host contract violations, allocator failures, out-of-range slot uses */
void e4o_errors(void *h, int32_t *out)
{
    const Drv *d = (Drv *)h;
    out[0] = d->host_error;
    out[1] = d->alloc_fail;
    out[2] = d->bad_slot_calls;
}

/* One true-gate visit of 0x476a25. out: status, phase_after, initialized, completed. */
void e4o_step(void *h, const uint8_t *body, int len, int row, uint32_t phase, int32_t *out)
{
    Drv *d = (Drv *)h;
    E4rResult r;
    const char *why = NULL;
    memset(&r, 0, sizeof(r));
    d->body = body;
    out[0] = e4r_step(&d->obj, body, (size_t)len, (int16_t)row, phase, &d->world, &d->host, &r, &why);
    out[1] = (int32_t)r.phase_after;
    out[2] = r.initialized;
    out[3] = r.completed;
    d->body = NULL;
}

/* out: status, hit, candidate, cursor_written, cursor_kind, cursor_sub */
void e4o_pointer(void *h, const uint8_t *body, int len, int32_t x, int32_t y, int32_t *out)
{
    Drv *d = (Drv *)h;
    E4rPointerResult r;
    memset(&r, 0, sizeof(r));
    out[0] = e4r_pointer(&d->obj, body, (size_t)len, x, y, &r);
    out[1] = r.hit;
    out[2] = r.candidate;
    out[3] = r.cursor_written;
    out[4] = r.cursor_kind;
    out[5] = r.cursor_sub;
}

/* out: status, fired, sound_played, phase_changed, phase */
void e4o_click(void *h, const uint8_t *body, int len, uint32_t row_phase, int32_t candidate, int32_t *out)
{
    Drv *d = (Drv *)h;
    E4rClickResult r;
    memset(&r, 0, sizeof(r));
    d->body = body;
    out[0] = e4r_click(&d->obj, body, (size_t)len, row_phase, candidate, &d->host, &r);
    out[1] = r.fired;
    out[2] = r.sound_played;
    out[3] = r.phase_changed;
    out[4] = (int32_t)r.phase;
    d->body = NULL;
}

int e4o_invalidate(void *h) { return e4r_invalidate(&((Drv *)h)->obj, &((Drv *)h)->host); }
int e4o_cleanup(void *h) { return e4r_cleanup(&((Drv *)h)->obj, &((Drv *)h)->host); }
void e4o_scene_reset(void *h) { e4r_scene_reset(&((Drv *)h)->world); }

int e4o_validate(const uint8_t *body, int len) { return e4r_validate_body(body, (size_t)len, NULL); }

/* out: status, valid, count. The ops are read back one by one with e4o_render_op. */
void e4o_render(void *h, const uint8_t *body, int len, int32_t *out)
{
    Drv *d = (Drv *)h;
    memset(&d->render, 0xA5, sizeof(d->render));
    d->body = body;
    out[0] = e4r_render(&d->obj, body, (size_t)len, &d->world, &d->host, &d->render);
    out[1] = d->render.valid;
    out[2] = d->render.count;
    d->body = NULL;
}

/* out: kind, label, surface_role, src[4], dst[4], font, param, x, y (16 ints); text receives the NUL-terminated text */
int e4o_render_op(void *h, int i, int32_t *out, char *text)
{
    const Drv *d = (Drv *)h;
    const E4rOp *op;
    int k;
    if (i < 0 || i >= (int)d->render.count || i >= E4R_MAX_OPS) return -1;
    op = &d->render.op[i];
    out[0] = op->kind;
    out[1] = op->label;
    out[2] = op->surface_role;
    for (k = 0; k < 4; ++k) out[3 + k] = op->src[k];
    for (k = 0; k < 4; ++k) out[7 + k] = op->dst[k];
    out[11] = op->font;
    out[12] = op->param;
    out[13] = op->x;
    out[14] = op->y;
    for (k = 0; k < (int)sizeof op->text && op->text[k]; ++k) {}
    out[15] = k;
    memcpy(text, op->text, sizeof op->text);
    return 0;
}
