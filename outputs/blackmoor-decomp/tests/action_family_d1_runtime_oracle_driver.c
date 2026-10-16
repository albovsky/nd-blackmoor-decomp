/* RT-35 oracle driver: exposes the native raw 0xd1 Turning Puzzle kernel (src/action_family_d1_runtime.c) to
 * tests/action_family_d1_runtime_original_oracle.py through ctypes.
 *
 * The driver owns one D1Object, one D1World and a SCRIPTED host. The host applies to a model of the generic Z entry
 * table (0x5d1591, stride 0x4a, 0x58 entries) the stores the original externals make (0x4d39f9 allocator, the inline
 * entry stores of 0x4b64a9, 0x4d3992 releaser, 0x4b5c11), to a model of the scene-change cells (0x5bb57b, 0x5bb599,
 * 0x5bb595, 0x5c39ff, 0x5bb59b, 0x5bb59f, 0x5bb5a3), the engine mode (0x583999) and the event flag table (a window
 * of dwords standing for 0x585801 + 4 * index), and it answers GetTickCount and 0x4f6334 from scripted queues
 * that the Python side also feeds to the original. The kernel's ordered D1_FX_* observer log is exported. The Python
 * side runs the unmodified x86 with hooks that record the same effects and compares both.
 *
 * Test code only: portable C11, no original bytes. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_d1_runtime.h"

#define ENTRY_STRIDE 0x4au
#define ENTRY_COUNT 0x58u
#define MAX_LOG 512
#define MAX_NAMES 16
#define MAX_HANDLES 32
#define MAX_QUEUE 256
#define EVENT_COUNT 4096
#define IMAGE_FIRST 0x1c
#define IMAGE_END 0x278
#define IMAGE_BYTES (IMAGE_END - IMAGE_FIRST)

/* entry field offsets relative to 0x5d1591 */
#define E_TYPE 0x00
#define E_CALLBACK 0x04
#define E_SURFACE 0x08
#define E_F0C 0x0c
#define E_F10 0x10
#define E_DIRTY 0x14
#define E_BUSY 0x18
#define E_WORD 0x1c
#define E_LABEL 0x22

typedef struct D1o {
    D1Object obj;
    D1World world;
    D1Host host;
    int32_t view_x, view_y;
    uint8_t entries[ENTRY_COUNT][ENTRY_STRIDE];
    int32_t log[MAX_LOG][3];
    int nlog;
    char names[MAX_NAMES][64];
    int nnames;
    uint32_t handles[MAX_HANDLES];
    int nhandles, ihandle;
    uint32_t ticks[MAX_QUEUE];
    int nticks, iticks, tick_underflow;
    int32_t busy[MAX_QUEUE];
    int nbusy, ibusy, busy_underflow;
    int32_t cell[8]; /* 5bb57b, 5bb599, 5bb595, 5c39ff, 5bb59b, 5bb59f, 5bb5a3, 583999 */
    int32_t events[EVENT_COUNT];
    int transitions;
    const uint8_t *body;
    const char *why;
    int bad_slot_calls;
    int host_error;
    int alloc_fail;
} D1o;

static void put32(uint8_t *p, uint32_t v) { memcpy(p, &v, 4); }
static void put16(uint8_t *p, uint16_t v) { memcpy(p, &v, 2); }

static uint8_t *entry(D1o *o, int16_t slot)
{
    if (slot < 0 || (unsigned)slot >= ENTRY_COUNT) {
        o->bad_slot_calls++;
        return NULL;
    }
    return o->entries[slot];
}

static void observe(void *c, int effect, int32_t a, int32_t b)
{
    D1o *o = c;
    if (o->nlog < MAX_LOG) {
        o->log[o->nlog][0] = effect;
        o->log[o->nlog][1] = a;
        o->log[o->nlog][2] = b;
        o->nlog++;
    }
}

static int h_alloc_slot(void *c, int16_t *slot)
{
    D1o *o = c;
    for (int i = 0x18; i <= 0x3f; ++i) {
        uint32_t busy;
        memcpy(&busy, o->entries[i] + E_BUSY, 4);
        if (busy == 0u) {
            *slot = (int16_t)i;
            return 0;
        }
    }
    o->alloc_fail++;
    return 1; /* the original reaches the fatal path 0x52139c here */
}

static int h_register_slot(void *c, int16_t slot, const char *label)
{
    D1o *o = c;
    uint8_t *e = entry(o, slot);
    if (e == NULL) return 1;
    put32(e + E_TYPE, 10u);
    put32(e + E_CALLBACK, 0x4b7051u);
    put32(e + E_SURFACE, 0u);
    put32(e + E_F0C, 0u);
    put32(e + E_F10, 0u);
    put32(e + E_DIRTY, 1u);
    put32(e + E_BUSY, 1u);
    put16(e + E_WORD, 0u);
    memcpy(e + E_LABEL, label, strlen(label) + 1u); /* the inline repne scasb / rep movs copy */
    return 0;
}

static int h_load_surface(void *c, const char *name, uint32_t *surface)
{
    D1o *o = c;
    if (o->nnames < MAX_NAMES) {
        strncpy(o->names[o->nnames], name, sizeof o->names[0] - 1u);
        o->names[o->nnames][sizeof o->names[0] - 1u] = '\0';
        o->nnames++;
    }
    *surface = o->ihandle < o->nhandles ? o->handles[o->ihandle] : 0u;
    o->ihandle++;
    return 0;
}

static int h_set_slot_surface(void *c, int16_t slot, uint32_t surface)
{
    uint8_t *e = entry(c, slot);
    if (e == NULL) return 1;
    put32(e + E_SURFACE, surface);
    return 0;
}

static int h_release_surface(void *c, uint32_t surface)
{
    (void)c;
    (void)surface;
    return 0;
}

static int h_release_slot(void *c, int16_t slot)
{
    uint8_t *e = entry(c, slot);
    if (e == NULL) return 1;
    put32(e + E_DIRTY, 0u);
    put32(e + E_BUSY, 0u);
    return 0;
}

static int h_mark_dirty(void *c, int16_t slot)
{
    uint8_t *e = entry(c, slot);
    if (e == NULL) return 1;
    put32(e + E_DIRTY, 1u);
    return 0;
}

static int h_view_origin(void *c, int32_t *x, int32_t *y)
{
    D1o *o = c;
    *x = o->view_x;
    *y = o->view_y;
    return 0;
}

static int h_clear_item(void *c)
{
    (void)c;
    return 0;
}

/* The record pointers must be the body windows the original passes (+0x2d9 record 0, +0x345 record 1). */
static int record_ok(D1o *o, int record, const uint8_t *bytes)
{
    const size_t off = record == 0 ? 0x2d9u : 0x345u;
    if (o->body == NULL || (record != 0 && record != 1) || bytes != o->body + off) {
        o->host_error++;
        return 0;
    }
    return 1;
}

static int h_sound_prepare(void *c, int record, const uint8_t *bytes)
{
    (void)record_ok(c, record, bytes);
    return 0;
}

static int h_sound_stop(void *c, int record, const uint8_t *bytes)
{
    (void)record_ok(c, record, bytes);
    return 0;
}

static int h_sound_play(void *c, int16_t channel)
{
    (void)c;
    (void)channel;
    return 0;
}

static int h_sound_busy(void *c, int16_t channel, int32_t *result)
{
    D1o *o = c;
    (void)channel;
    if (o->ibusy < o->nbusy) {
        *result = o->busy[o->ibusy];
    } else {
        *result = 0;
        o->busy_underflow++;
    }
    o->ibusy++;
    return 0;
}

static uint32_t h_tick(void *c)
{
    D1o *o = c;
    uint32_t v = 0u;
    if (o->iticks < o->nticks)
        v = o->ticks[o->iticks];
    else
        o->tick_underflow++;
    o->iticks++;
    return v;
}

static int h_event_flag_invalid(void *c, int16_t index)
{
    (void)c;
    return index < 0 || index >= EVENT_COUNT;
}

static int h_transition(void *c, const D1Transition *t)
{
    D1o *o = c;
    o->cell[0] = t->scene;
    o->cell[1] = t->word[0];
    o->cell[2] = t->word[1];
    o->cell[3] = t->word[2];
    o->cell[4] = t->dword[0];
    o->cell[5] = t->dword[1];
    o->cell[6] = t->dword[2];
    o->cell[7] = 4;
    o->transitions++;
    return 0;
}

static int h_store_event_flag(void *c, int16_t index, uint32_t value)
{
    D1o *o = c;
    if (index < 0 || index >= EVENT_COUNT) return 1;
    o->events[index] = (int32_t)value;
    return 0;
}

void *d1o_new(void)
{
    D1o *o = calloc(1, sizeof *o);
    if (o == NULL) return NULL;
    d1_object_reset(&o->obj);
    o->host.context = o;
    o->host.alloc_slot = h_alloc_slot;
    o->host.register_slot = h_register_slot;
    o->host.load_surface = h_load_surface;
    o->host.set_slot_surface = h_set_slot_surface;
    o->host.release_surface = h_release_surface;
    o->host.release_slot = h_release_slot;
    o->host.mark_dirty = h_mark_dirty;
    o->host.view_origin = h_view_origin;
    o->host.clear_pending_item = h_clear_item;
    o->host.sound_prepare = h_sound_prepare;
    o->host.sound_stop = h_sound_stop;
    o->host.sound_play = h_sound_play;
    o->host.sound_busy = h_sound_busy;
    o->host.tick = h_tick;
    o->host.event_flag_invalid = h_event_flag_invalid;
    o->host.transition = h_transition;
    o->host.store_event_flag = h_store_event_flag;
    o->host.observe = observe;
    return o;
}

void d1o_free(void *h) { free(h); }

void d1o_set_view(void *h, int32_t x, int32_t y)
{
    D1o *o = h;
    o->view_x = x;
    o->view_y = y;
}

void d1o_set_world_flag(void *h, int32_t v) { ((D1o *)h)->world.start_flag_5bb1ca = v; }
int32_t d1o_get_world_flag(void *h) { return ((D1o *)h)->world.start_flag_5bb1ca; }

void d1o_set_handles(void *h, const uint32_t *hs, int n)
{
    D1o *o = h;
    o->nhandles = n > MAX_HANDLES ? MAX_HANDLES : n;
    memcpy(o->handles, hs, (size_t)o->nhandles * sizeof(uint32_t));
    o->ihandle = 0;
}

void d1o_set_ticks(void *h, const uint32_t *v, int n)
{
    D1o *o = h;
    o->nticks = n > MAX_QUEUE ? MAX_QUEUE : n;
    memcpy(o->ticks, v, (size_t)o->nticks * sizeof(uint32_t));
    o->iticks = 0;
    o->tick_underflow = 0;
}

void d1o_set_busy(void *h, const int32_t *v, int n)
{
    D1o *o = h;
    o->nbusy = n > MAX_QUEUE ? MAX_QUEUE : n;
    memcpy(o->busy, v, (size_t)o->nbusy * sizeof(int32_t));
    o->ibusy = 0;
    o->busy_underflow = 0;
}

/* consumed counts: ticks, busy answers, tick underflows, busy underflows, host contract errors, allocator failures */
void d1o_consumed(void *h, int32_t *out)
{
    D1o *o = h;
    out[0] = o->iticks;
    out[1] = o->ibusy;
    out[2] = o->tick_underflow;
    out[3] = o->busy_underflow;
    out[4] = o->host_error;
    out[5] = o->alloc_fail;
}

void d1o_set_busy_slot(void *h, int slot, int busy)
{
    D1o *o = h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT) put32(o->entries[slot] + E_BUSY, busy ? 1u : 0u);
}

void d1o_set_entry_u32(void *h, int slot, int offset, uint32_t value)
{
    D1o *o = h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT && offset >= 0 && offset + 4 <= (int)ENTRY_STRIDE)
        put32(o->entries[slot] + offset, value);
}

void d1o_set_cells(void *h, const int32_t *v) { memcpy(((D1o *)h)->cell, v, 8u * sizeof(int32_t)); }
void d1o_get_cells(void *h, int32_t *out) { memcpy(out, ((D1o *)h)->cell, 8u * sizeof(int32_t)); }
int d1o_transitions(void *h) { return ((D1o *)h)->transitions; }

/* `bytes` holds EVENT_COUNT dwords copied from the original's table window */
void d1o_set_events(void *h, const int32_t *v) { memcpy(((D1o *)h)->events, v, sizeof(((D1o *)h)->events)); }
void d1o_get_events(void *h, int32_t *out) { memcpy(out, ((D1o *)h)->events, sizeof(((D1o *)h)->events)); }
int d1o_event_count(void) { return EVENT_COUNT; }

void d1o_clear_log(void *h)
{
    D1o *o = h;
    o->nlog = 0;
    o->nnames = 0;
    o->bad_slot_calls = 0;
}

int d1o_step(void *h, const uint8_t *body, int row, uint32_t phase, uint32_t *result)
{
    D1o *o = h;
    D1Result r;
    int status;
    memset(&r, 0, sizeof r);
    o->why = "none";
    o->body = body;
    status = d1_step(&o->obj, body, D1_BODY_BYTES, (int16_t)row, phase, &o->world, &o->host, &r, &o->why);
    o->body = NULL;
    result[0] = r.phase_after;
    result[1] = r.initialized;
    result[2] = r.completed;
    return status;
}

const char *d1o_why(void *h) { return ((D1o *)h)->why; }
int d1o_bad_slot_calls(void *h) { return ((D1o *)h)->bad_slot_calls; }

/* out: hit, candidate, cursor */
int d1o_pointer(void *h, const uint8_t *body, int x, int y, int32_t *out)
{
    D1o *o = h;
    D1PointerResult r;
    int status;
    memset(&r, 0, sizeof r);
    r.candidate = -1;
    status = d1_pointer_move(&o->obj, body, D1_BODY_BYTES, (int16_t)x, (int16_t)y, &r);
    out[0] = r.hit;
    out[1] = r.candidate;
    out[2] = r.cursor;
    return status;
}

int d1o_click(void *h, const uint8_t *body, uint32_t row_phase, int32_t candidate, int32_t start_flag, uint32_t *new_phase)
{
    D1o *o = h;
    int status;
    o->body = body;
    status = d1_click(&o->obj, body, D1_BODY_BYTES, row_phase, candidate, start_flag, &o->host, new_phase);
    o->body = NULL;
    return status;
}

int d1o_invalidate(void *h)
{
    D1o *o = h;
    return d1_invalidate(&o->obj, &o->host);
}

int d1o_cleanup(void *h)
{
    D1o *o = h;
    return d1_cleanup(&o->obj, &o->host);
}

int d1o_log_count(void *h) { return ((D1o *)h)->nlog; }
void d1o_log(void *h, int i, int32_t *out) { memcpy(out, ((D1o *)h)->log[i], 3u * sizeof(int32_t)); }
int d1o_name_count(void *h) { return ((D1o *)h)->nnames; }
const char *d1o_name(void *h, int i) { return ((D1o *)h)->names[i]; }

/* The object image +0x1c..+0x277 laid out byte for byte as the original keeps it (little endian). */
void d1o_image(void *h, uint8_t *out)
{
    const D1Object *b = &((D1o *)h)->obj;
    uint8_t *p = out - IMAGE_FIRST;
    put16(p + 0x1c, (uint16_t)b->slot);
    put16(p + 0x1e, (uint16_t)b->row);
    put32(p + 0x20, b->surface);
    for (int i = 0; i < D1_MAX_TILES; ++i)
        for (int k = 0; k < 4; ++k) {
            put32(p + 0x24 + 16 * i + 4 * k, (uint32_t)b->src[i][k]);
            put32(p + 0x124 + 16 * i + 4 * k, (uint32_t)b->dst[i][k]);
        }
    p[0x224] = b->dirty;
    put32(p + 0x225, (uint32_t)b->active);
    p[0x229] = b->exit_taken;
    p[0x22a] = b->solved;
    p[0x22b] = b->counter;
    put16(p + 0x22c, (uint16_t)b->step);
    put32(p + 0x22e, b->deadline);
    for (int i = 0; i < D1_MAX_TILES; ++i) {
        put16(p + 0x232 + 2 * i, (uint16_t)b->moving[i]);
        put16(p + 0x254 + 2 * i, (uint16_t)b->frame[i]);
    }
    put16(p + 0x252, (uint16_t)b->last_tile);
    put32(p + 0x274, (uint32_t)b->state);
}

static uint16_t get16(const uint8_t *p) { uint16_t v; memcpy(&v, p, 2); return v; }
static uint32_t get32(const uint8_t *p) { uint32_t v; memcpy(&v, p, 4); return v; }

/* The inverse of d1o_image: force the object into an arbitrary (possibly unreachable) state for fuzz scenarios. */
void d1o_set_image(void *h, const uint8_t *in)
{
    D1Object *b = &((D1o *)h)->obj;
    const uint8_t *p = in - IMAGE_FIRST;
    b->slot = (int16_t)get16(p + 0x1c);
    b->row = (int16_t)get16(p + 0x1e);
    b->surface = get32(p + 0x20);
    for (int i = 0; i < D1_MAX_TILES; ++i)
        for (int k = 0; k < 4; ++k) {
            b->src[i][k] = (int32_t)get32(p + 0x24 + 16 * i + 4 * k);
            b->dst[i][k] = (int32_t)get32(p + 0x124 + 16 * i + 4 * k);
        }
    b->dirty = p[0x224];
    b->active = (int32_t)get32(p + 0x225);
    b->exit_taken = p[0x229];
    b->solved = p[0x22a];
    b->counter = p[0x22b];
    b->step = (int16_t)get16(p + 0x22c);
    b->deadline = get32(p + 0x22e);
    for (int i = 0; i < D1_MAX_TILES; ++i) {
        b->moving[i] = (int16_t)get16(p + 0x232 + 2 * i);
        b->frame[i] = (int16_t)get16(p + 0x254 + 2 * i);
    }
    b->last_tile = (int16_t)get16(p + 0x252);
    b->state = (int32_t)get32(p + 0x274);
}

void d1o_entries(void *h, uint8_t *out) { memcpy(out, ((D1o *)h)->entries, sizeof(((D1o *)h)->entries)); }

/* render plan: valid, surface, count, src[16][4], dst[16][4] = 131 values */
int d1o_plan(void *h, const uint8_t *body, int32_t *out)
{
    D1o *o = h;
    D1RenderPlan p;
    int status = d1_render_plan(&o->obj, body, D1_BODY_BYTES, &p);
    int k = 0;
    out[k++] = p.valid;
    out[k++] = (int32_t)p.surface;
    out[k++] = p.count;
    for (int i = 0; i < D1_MAX_TILES; ++i)
        for (int j = 0; j < 4; ++j) out[k++] = p.src[i][j];
    for (int i = 0; i < D1_MAX_TILES; ++i)
        for (int j = 0; j < 4; ++j) out[k++] = p.dst[i][j];
    return status;
}

/* geometry helper (0x4b6355) straight from the kernel */
void d1o_geometry(const uint8_t *body, int tile, int frame, int step, int32_t *out)
{
    d1_geometry(body, (int16_t)tile, (int16_t)frame, (int16_t)step, out);
}

int d1o_validate(const uint8_t *body, size_t length) { return d1_validate_body(body, length, NULL); }
