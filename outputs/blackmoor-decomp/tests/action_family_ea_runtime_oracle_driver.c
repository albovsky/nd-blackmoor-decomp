/* RT-45 oracle driver: exposes the native raw 0xea Onebuild puzzle kernel (src/action_family_ea_runtime.c) to
 * tests/action_family_ea_runtime_original_oracle.py through ctypes.
 *
 * The driver owns one EaObject, one EaWorld, the row bodies (one mutable copy per row, as the loader's allocations)
 * and a SCRIPTED host. The host applies to a model of the generic Z entry table (0x5d1591, stride 0x4a, 0x58 entries)
 * the stores the original externals make (0x4d39f9 allocator, the inline entry stores of 0x4867bd, 0x4d3992
 * releaser, 0x4840d9), to a model of the scene-change cells (0x5bb57b, 0x5bb599, 0x5bb595, 0x5c39ff, 0x5bb59b,
 * 0x5bb59f, 0x5bb5a3), the engine mode (0x583999) and the event flag table (a window of dwords standing for 0x585801
 * + 4 * index), and it answers GetTickCount, _rand, 0x4f6334 and the AUTOTEXT lookup 0x423259 from scripted queues and
 * tables that the Python side also feeds to the original. Every call the original makes to a replaced function is
 * appended to an ordered log (kinds below, shared with the Python side); surfaces are fake handles
 * 0x24200000 + 0x100 * n whose width and height the driver tracks, as the oracle does in emulated memory.
 *
 * Test code only: portable C11, no original bytes. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_ea_runtime.h"

#define ENTRY_STRIDE 0x4au
#define ENTRY_COUNT 0x58u
#define MAX_LOG 1024
#define MAX_HANDLES 64
#define MAX_QUEUE 256
#define EVENT_COUNT 4096
#define MAX_ROWS 8
#define MAX_TEXTS 16
#define SURFACE_BASE 0x24200000u
#define SURFACE_STRIDE 0x100u
#define MAX_SURFACES 4096

/* log kinds */
enum {
    K_LOAD = 1, K_CREATE, K_BLIT, K_COPY, K_ROTATE, K_RELEASE, K_CLEAR_ITEM, K_SND_PREPARE, K_SND_STOP, K_SND_PLAY,
    K_SND_BUSY, K_TICK, K_RAND, K_AUTOTEXT, K_CAPTION, K_COMPLETE, K_ALLOC, K_RELEASE_SLOT
};

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

typedef struct Rec {
    int32_t kind;
    int32_t v[12];
    char s0[256];
} Rec;

typedef struct Text {
    char key[64];
    char *text;
    int used;
} Text;

typedef struct Eao {
    EaObject obj;
    EaWorld world;
    EaHost host;
    EaView view;
    uint8_t entries[ENTRY_COUNT][ENTRY_STRIDE];
    Rec log[MAX_LOG];
    int nlog;
    uint32_t handles[MAX_HANDLES];
    int nhandles, ihandle;
    uint32_t ticks[MAX_QUEUE];
    int nticks, iticks, tick_underflow;
    int32_t busy[MAX_QUEUE];
    int nbusy, ibusy, busy_underflow;
    int32_t rands[MAX_QUEUE];
    int nrands, irands, rand_underflow;
    int32_t captions;
    Text texts[MAX_TEXTS];
    int ntexts;
    int32_t cell[8]; /* 5bb57b, 5bb599, 5bb595, 5c39ff, 5bb59b, 5bb59f, 5bb5a3, 583999 */
    int32_t events[EVENT_COUNT];
    int transitions;
    uint8_t *bodies[MAX_ROWS];
    const uint8_t *cur_body;
    const char *why;
    int bad_slot_calls;
    int host_error;
    int alloc_fail;
    int nsurf;
    int16_t surf_w[MAX_SURFACES], surf_h[MAX_SURFACES];
    uint8_t surf_live[MAX_SURFACES];
} Eao;

static void put32(uint8_t *p, uint32_t v) { memcpy(p, &v, 4); }
static void put16(uint8_t *p, uint16_t v) { memcpy(p, &v, 2); }

static Rec *add(Eao *o, int kind)
{
    static Rec dummy;
    Rec *r;
    if (o->nlog >= MAX_LOG) return &dummy;
    r = &o->log[o->nlog++];
    memset(r, 0, sizeof *r);
    r->kind = kind;
    return r;
}

static uint8_t *entry(Eao *o, int16_t slot)
{
    if (slot < 0 || (unsigned)slot >= ENTRY_COUNT) {
        o->bad_slot_calls++;
        return NULL;
    }
    return o->entries[slot];
}

static int surf_index(uint32_t handle)
{
    if (handle < SURFACE_BASE || ((handle - SURFACE_BASE) % SURFACE_STRIDE) != 0) return -1;
    if ((handle - SURFACE_BASE) / SURFACE_STRIDE >= MAX_SURFACES) return -1;
    return (int)((handle - SURFACE_BASE) / SURFACE_STRIDE);
}

static int h_view(void *c, EaView *v)
{
    *v = ((Eao *)c)->view;
    return 0;
}

static int h_alloc_slot(void *c, int16_t *slot)
{
    Eao *o = c;
    add(o, K_ALLOC);
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
    Eao *o = c;
    uint8_t *e = entry(o, slot);
    if (e == NULL) return 1;
    put32(e + E_TYPE, 10u);
    put32(e + E_CALLBACK, 0x4876edu);
    put32(e + E_SURFACE, 0u);
    put32(e + E_F0C, 0u);
    put32(e + E_F10, 0u);
    put32(e + E_DIRTY, 1u);
    put32(e + E_BUSY, 1u);
    put16(e + E_WORD, 0u);
    memcpy(e + E_LABEL, label, strlen(label) + 1u); /* the inline repne scasb / rep movs copy */
    for (uint8_t *q = e + E_LABEL; *q != 0; ++q)
        if (*q == '_') *q = ' '; /* the kernel's identifier-like label is spelled with spaces by the real adapter (E8) */
    return 0;
}

static int h_release_slot(void *c, int16_t slot)
{
    Eao *o = c;
    uint8_t *e = entry(o, slot);
    Rec *r = add(o, K_RELEASE_SLOT);
    r->v[0] = slot;
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

static int h_load_surface(void *c, const char *name, const char *tag, uint32_t *surface)
{
    Eao *o = c;
    Rec *r = add(o, K_LOAD);
    snprintf(r->s0, sizeof r->s0, "%s|%s", name, tag);
    *surface = o->ihandle < o->nhandles ? o->handles[o->ihandle] : 0u;
    o->ihandle++;
    r->v[0] = (int32_t)*surface;
    return 0;
}

static int h_create_surface(void *c, int16_t w, int16_t h, const char *tag, uint32_t *surface)
{
    Eao *o = c;
    Rec *r = add(o, K_CREATE);
    snprintf(r->s0, sizeof r->s0, "%s", tag);
    if (o->nsurf >= MAX_SURFACES) {
        o->host_error++;
        return 1;
    }
    o->surf_w[o->nsurf] = w;
    o->surf_h[o->nsurf] = h;
    o->surf_live[o->nsurf] = 1;
    *surface = SURFACE_BASE + SURFACE_STRIDE * (uint32_t)o->nsurf;
    o->nsurf++;
    r->v[0] = w;
    r->v[1] = h;
    r->v[2] = (int32_t)*surface;
    return 0;
}

static int h_blit(void *c, uint32_t src, uint32_t dst, const int32_t sr[4], const int32_t dr[4])
{
    Eao *o = c;
    Rec *r = add(o, K_BLIT);
    r->v[0] = (int32_t)src;
    r->v[1] = (int32_t)dst;
    for (int k = 0; k < 4; ++k) {
        r->v[2 + k] = sr[k];
        r->v[6 + k] = dr[k];
    }
    return 0;
}

static int h_copy_surface(void *c, uint32_t dst, uint32_t src)
{
    Eao *o = c;
    Rec *r = add(o, K_COPY);
    r->v[0] = (int32_t)dst;
    r->v[1] = (int32_t)src;
    return 0;
}

static int h_rotate_surface(void *c, uint32_t surface, int16_t *w, int16_t *h)
{
    Eao *o = c;
    Rec *r = add(o, K_ROTATE);
    int i = surf_index(surface);
    r->v[0] = (int32_t)surface;
    if (i < 0 || i >= o->nsurf) {
        o->host_error++;
        return 1;
    }
    {
        const int16_t t = o->surf_w[i];
        o->surf_w[i] = o->surf_h[i];
        o->surf_h[i] = t;
    }
    *w = o->surf_w[i];
    *h = o->surf_h[i];
    return 0;
}

static int h_release_surface(void *c, uint32_t surface)
{
    Eao *o = c;
    Rec *r = add(o, K_RELEASE);
    r->v[0] = (int32_t)surface;
    return 0;
}

static int h_clear_item(void *c)
{
    add(c, K_CLEAR_ITEM);
    return 0;
}

/* The record pointers must be the windows the original passes (object buffers or a body offset). */
static void hexrec(Rec *r, const uint8_t *p)
{
    static const char dig[] = "0123456789abcdef";
    for (unsigned k = 0; k < EA_SOUND_RECORD_BYTES; ++k) {
        r->s0[2 * k] = dig[p[k] >> 4];
        r->s0[2 * k + 1] = dig[p[k] & 15];
    }
    r->s0[2 * EA_SOUND_RECORD_BYTES] = 0;
}

static void record_check(Eao *o, uint32_t id, const uint8_t *record)
{
    const uint8_t *want = id >= EA_SOUND_OBJECT_ID ? o->obj.b + (id - EA_SOUND_OBJECT_ID) : (o->cur_body ? o->cur_body + id : NULL);
    if (want == NULL || record != want) o->host_error++;
}

static int h_sound_prepare(void *c, uint32_t id, const uint8_t *record)
{
    Eao *o = c;
    Rec *r = add(o, K_SND_PREPARE);
    record_check(o, id, record);
    r->v[0] = (int32_t)id;
    hexrec(r, record);
    return 0;
}

static int h_sound_stop(void *c, uint32_t id, const uint8_t *record)
{
    Eao *o = c;
    Rec *r = add(o, K_SND_STOP);
    record_check(o, id, record);
    r->v[0] = (int32_t)id;
    hexrec(r, record);
    return 0;
}

static int h_sound_play(void *c, int16_t channel)
{
    Rec *r = add(c, K_SND_PLAY);
    r->v[0] = channel;
    return 0;
}

static int h_sound_busy(void *c, int16_t channel, int32_t *result)
{
    Eao *o = c;
    Rec *r = add(o, K_SND_BUSY);
    if (o->ibusy < o->nbusy) {
        *result = o->busy[o->ibusy];
    } else {
        *result = 0;
        o->busy_underflow++;
    }
    o->ibusy++;
    r->v[0] = channel;
    r->v[1] = *result;
    return 0;
}

static uint32_t h_tick(void *c)
{
    Eao *o = c;
    uint32_t v = 0u;
    Rec *r = add(o, K_TICK);
    if (o->iticks < o->nticks)
        v = o->ticks[o->iticks];
    else
        o->tick_underflow++;
    o->iticks++;
    r->v[0] = (int32_t)v;
    return v;
}

static int h_rand(void *c, int32_t *value)
{
    Eao *o = c;
    Rec *r = add(o, K_RAND);
    if (o->irands < o->nrands) {
        *value = o->rands[o->irands];
    } else {
        *value = 0;
        o->rand_underflow++;
    }
    o->irands++;
    r->v[0] = *value;
    return 0;
}

static int h_captions(void *c, int32_t *enabled)
{
    *enabled = ((Eao *)c)->captions;
    return 0;
}

static int h_autotext(void *c, const char *key, const char **text)
{
    Eao *o = c;
    Rec *r = add(o, K_AUTOTEXT);
    snprintf(r->s0, sizeof r->s0, "%s", key);
    *text = NULL;
    for (int i = 0; i < o->ntexts; ++i)
        if (strcmp(o->texts[i].key, key) == 0) {
            *text = o->texts[i].text;
            r->v[0] = 1;
            break;
        }
    return 0;
}

static int h_caption(void *c, const char *text)
{
    Rec *r = add(c, K_CAPTION);
    snprintf(r->s0, sizeof r->s0, "%s", text);
    return 0;
}

static int h_event_flag_invalid(void *c, int16_t index)
{
    (void)c;
    return index < 0 || index >= EVENT_COUNT;
}

static int h_transition(void *c, const EaTransition *t)
{
    Eao *o = c;
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
    Eao *o = c;
    if (index < 0 || index >= EVENT_COUNT) return 1;
    o->events[index] = (int32_t)value;
    return 0;
}

static int h_complete(void *c, int16_t row)
{
    Rec *r = add(c, K_COMPLETE);
    r->v[0] = row;
    return 0;
}

void *eao_new(void)
{
    Eao *o = calloc(1, sizeof *o);
    if (o == NULL) return NULL;
    ea_object_reset(&o->obj);
    o->host.context = o;
    o->host.view = h_view;
    o->host.alloc_slot = h_alloc_slot;
    o->host.register_slot = h_register_slot;
    o->host.release_slot = h_release_slot;
    o->host.mark_dirty = h_mark_dirty;
    o->host.load_surface = h_load_surface;
    o->host.create_surface = h_create_surface;
    o->host.blit = h_blit;
    o->host.copy_surface = h_copy_surface;
    o->host.rotate_surface = h_rotate_surface;
    o->host.release_surface = h_release_surface;
    o->host.clear_pending_item = h_clear_item;
    o->host.sound_prepare = h_sound_prepare;
    o->host.sound_stop = h_sound_stop;
    o->host.sound_play = h_sound_play;
    o->host.sound_busy = h_sound_busy;
    o->host.tick = h_tick;
    o->host.rand_value = h_rand;
    o->host.captions_enabled = h_captions;
    o->host.autotext_lookup = h_autotext;
    o->host.caption_show = h_caption;
    o->host.event_flag_invalid = h_event_flag_invalid;
    o->host.transition = h_transition;
    o->host.store_event_flag = h_store_event_flag;
    o->host.complete = h_complete;
    return o;
}

void eao_free(void *h)
{
    Eao *o = h;
    if (o == NULL) return;
    for (int i = 0; i < MAX_ROWS; ++i) free(o->bodies[i]);
    for (int i = 0; i < o->ntexts; ++i) free(o->texts[i].text);
    free(o);
}

void eao_set_view(void *h, const int32_t *v) /* origin x, origin y, clip l, t, r, b */
{
    Eao *o = h;
    o->view.origin_x = v[0];
    o->view.origin_y = v[1];
    for (int k = 0; k < 4; ++k) o->view.clip[k] = v[2 + k];
}

void eao_set_world_flag(void *h, int32_t v) { ((Eao *)h)->world.start_flag_5bb1ca = v; }
int32_t eao_get_world_flag(void *h) { return ((Eao *)h)->world.start_flag_5bb1ca; }
void eao_set_captions(void *h, int32_t v) { ((Eao *)h)->captions = v; }

void eao_set_handles(void *h, const uint32_t *hs, int n)
{
    Eao *o = h;
    o->nhandles = n > MAX_HANDLES ? MAX_HANDLES : n;
    memcpy(o->handles, hs, (size_t)o->nhandles * sizeof(uint32_t));
    o->ihandle = 0;
}

void eao_set_queues(void *h, const uint32_t *ticks, int nt, const int32_t *busy, int nb, const int32_t *rands, int nr)
{
    Eao *o = h;
    o->nticks = nt > MAX_QUEUE ? MAX_QUEUE : nt;
    memcpy(o->ticks, ticks, (size_t)o->nticks * sizeof(uint32_t));
    o->iticks = 0;
    o->tick_underflow = 0;
    o->nbusy = nb > MAX_QUEUE ? MAX_QUEUE : nb;
    memcpy(o->busy, busy, (size_t)o->nbusy * sizeof(int32_t));
    o->ibusy = 0;
    o->busy_underflow = 0;
    o->nrands = nr > MAX_QUEUE ? MAX_QUEUE : nr;
    memcpy(o->rands, rands, (size_t)o->nrands * sizeof(int32_t));
    o->irands = 0;
    o->rand_underflow = 0;
}

/* consumed: ticks, busy, rands, tick underflow, busy underflow, rand underflow, host contract errors, alloc failures */
void eao_consumed(void *h, int32_t *out)
{
    Eao *o = h;
    out[0] = o->iticks;
    out[1] = o->ibusy;
    out[2] = o->irands;
    out[3] = o->tick_underflow;
    out[4] = o->busy_underflow;
    out[5] = o->rand_underflow;
    out[6] = o->host_error;
    out[7] = o->alloc_fail;
}

void eao_clear_texts(void *h)
{
    Eao *o = h;
    for (int i = 0; i < o->ntexts; ++i) free(o->texts[i].text);
    o->ntexts = 0;
}

void eao_add_text(void *h, const char *key, const char *text)
{
    Eao *o = h;
    size_t n = strlen(text) + 1u;
    if (o->ntexts >= MAX_TEXTS) return;
    snprintf(o->texts[o->ntexts].key, sizeof o->texts[0].key, "%s", key);
    o->texts[o->ntexts].text = malloc(n);
    if (o->texts[o->ntexts].text == NULL) return;
    memcpy(o->texts[o->ntexts].text, text, n);
    o->ntexts++;
}

void eao_set_busy_slot(void *h, int slot, int busy)
{
    Eao *o = h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT) put32(o->entries[slot] + E_BUSY, busy ? 1u : 0u);
}

void eao_set_entry_u32(void *h, int slot, int offset, uint32_t value)
{
    Eao *o = h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT && offset >= 0 && offset + 4 <= (int)ENTRY_STRIDE)
        put32(o->entries[slot] + offset, value);
}

void eao_set_cells(void *h, const int32_t *v) { memcpy(((Eao *)h)->cell, v, 8u * sizeof(int32_t)); }
void eao_get_cells(void *h, int32_t *out) { memcpy(out, ((Eao *)h)->cell, 8u * sizeof(int32_t)); }
void eao_set_events(void *h, const int32_t *v) { memcpy(((Eao *)h)->events, v, sizeof(((Eao *)h)->events)); }
void eao_get_events(void *h, int32_t *out) { memcpy(out, ((Eao *)h)->events, sizeof(((Eao *)h)->events)); }
void eao_set_entries(void *h, const uint8_t *in) { memcpy(((Eao *)h)->entries, in, sizeof(((Eao *)h)->entries)); }
void eao_entries(void *h, uint8_t *out) { memcpy(out, ((Eao *)h)->entries, sizeof(((Eao *)h)->entries)); }
void eao_set_surface_counter(void *h, int n) { ((Eao *)h)->nsurf = n; }

void eao_clear_log(void *h)
{
    Eao *o = h;
    o->nlog = 0;
    o->bad_slot_calls = 0;
}

int eao_log_count(void *h) { return ((Eao *)h)->nlog; }
int eao_bad_slot_calls(void *h) { return ((Eao *)h)->bad_slot_calls; }

void eao_log(void *h, int i, int32_t *out)
{
    memcpy(out, &((Eao *)h)->log[i], 13u * sizeof(int32_t));
}

const char *eao_log_text(void *h, int i) { return ((Eao *)h)->log[i].s0; }

/* Bodies: one mutable copy per row, as the loader's allocation. */
int eao_set_body(void *h, int row, const uint8_t *body, size_t length)
{
    Eao *o = h;
    uint8_t *copy;
    if (row < 0 || row >= MAX_ROWS) return 1;
    copy = malloc(length ? length : 1u);
    if (copy == NULL) return 1;
    memcpy(copy, body, length);
    free(o->bodies[row]);
    o->bodies[row] = copy;
    return 0;
}

void eao_get_body(void *h, int row, uint8_t *out, size_t length)
{
    Eao *o = h;
    if (row >= 0 && row < MAX_ROWS && o->bodies[row] != NULL) memcpy(out, o->bodies[row], length);
}

const char *eao_why(void *h) { return ((Eao *)h)->why; }

void eao_object(void *h, uint8_t *out) { memcpy(out, ((Eao *)h)->obj.b, EA_OBJECT_BYTES); }
void eao_set_object(void *h, const uint8_t *in) { memcpy(((Eao *)h)->obj.b, in, EA_OBJECT_BYTES); }

int eao_step(void *h, int row_index, int row, uint32_t phase, uint32_t *result)
{
    Eao *o = h;
    EaResult r;
    int status;
    memset(&r, 0, sizeof r);
    o->why = "none";
    o->cur_body = o->bodies[row_index];
    status = ea_step(&o->obj, o->bodies[row_index], EA_BODY_BYTES, (int16_t)row, phase, &o->world, &o->host, &r, &o->why);
    o->cur_body = NULL;
    result[0] = r.phase_after;
    result[1] = r.initialized;
    result[2] = r.completed;
    return status;
}

/* out: hit, candidate, wrote_cursor, cursor, cursor_flag, cursor_record */
int eao_pointer(void *h, int row_index, int x, int y, const int32_t *rect, int32_t *out)
{
    Eao *o = h;
    EaPointerResult r;
    int status;
    memset(&r, 0, sizeof r);
    r.candidate = -1;
    o->cur_body = o->bodies[row_index];
    status = ea_pointer_move(&o->obj, o->bodies[row_index], EA_BODY_BYTES, (int16_t)x, (int16_t)y, rect, &o->host, &r);
    o->cur_body = NULL;
    out[0] = r.hit;
    out[1] = r.candidate;
    out[2] = r.wrote_cursor;
    out[3] = r.cursor;
    out[4] = r.cursor_flag;
    out[5] = (int32_t)r.cursor_record;
    return status;
}

int eao_click(void *h, int row_index, uint32_t row_phase, int32_t candidate, uint32_t *new_phase)
{
    Eao *o = h;
    int status;
    o->cur_body = o->bodies[row_index];
    status = ea_click(&o->obj, o->bodies[row_index], EA_BODY_BYTES, row_phase, candidate, &o->host, new_phase);
    o->cur_body = NULL;
    return status;
}

int eao_rotkey(void *h, int row_index, uint32_t row_phase)
{
    Eao *o = h;
    int status;
    o->cur_body = o->bodies[row_index];
    status = ea_rotate_key(&o->obj, o->bodies[row_index], EA_BODY_BYTES, row_phase, &o->host);
    o->cur_body = NULL;
    return status;
}

int eao_invalidate(void *h) { return ea_invalidate(&((Eao *)h)->obj, &((Eao *)h)->host); }
int eao_cleanup(void *h) { return ea_cleanup(&((Eao *)h)->obj, &((Eao *)h)->host); }

/* render plan: valid, count, then per blit kind, src_kind, surface, src[4], dst[4] (11 ints) */
int eao_plan(void *h, int row_index, int32_t *out)
{
    Eao *o = h;
    EaRenderPlan p;
    int status = ea_render_plan(&o->obj, o->bodies[row_index], EA_BODY_BYTES, &o->host, &p);
    int k = 0;
    out[k++] = p.valid;
    out[k++] = p.count;
    for (int i = 0; i < EA_MAX_BLITS; ++i) {
        out[k++] = p.blit[i].kind;
        out[k++] = p.blit[i].src_kind;
        out[k++] = (int32_t)p.blit[i].src_surface;
        for (int j = 0; j < 4; ++j) out[k++] = p.blit[i].src[j];
        for (int j = 0; j < 4; ++j) out[k++] = p.blit[i].dst[j];
    }
    return status;
}

int eao_validate(const uint8_t *body, size_t length) { return ea_validate_body(body, length, NULL); }
