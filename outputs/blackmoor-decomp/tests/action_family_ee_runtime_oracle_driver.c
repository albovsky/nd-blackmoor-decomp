/* RT-60 oracle driver: exposes the native raw 0xee Memory puzzle kernel (src/action_family_ee_runtime.c) to
 * tests/action_family_ee_runtime_original_oracle.py through ctypes.
 *
 * The driver owns one MpObject (the 0x2c4-byte singleton image plus the two heap blocks the kernel models), the row bodies (one
 * mutable copy per row, as the loader's allocations) and a SCRIPTED host. The host applies to a model of the generic Z entry table
 * (0x5d1591, stride 0x4a, 0x58 entries) the stores the original externals make (allocator 0x4d39f9, the inline entry stores of
 * 0x47c0f0, the releaser 0x4d3992, the invalidate 0x47b3bc), to a model of the scene-change cells (0x5bb57b, 0x5bb599, 0x5bb595,
 * 0x5c39ff, 0x5bb59b, 0x5bb59f, 0x5bb5a3), the start flag 0x5bb1ca, the engine mode (0x583999) and the event flag table (a window
 * of dwords standing for 0x585801 + 4 * index), and it answers GetTickCount, _rand, 0x4f6334 and the AUTOTEXT lookup 0x423259 from
 * scripted queues and tables that the Python side also feeds to the original. Every call the original makes to a replaced function
 * (and every store the kernel reports as a host call) is appended to an ordered log whose kinds are shared with the Python side.
 *
 * Test code only: portable C11, no original bytes. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_ee_runtime.h"

#define ENTRY_STRIDE 0x4au
#define ENTRY_COUNT 0x58u
#define MAX_LOG 8192
#define MAX_QUEUE 4096
#define MAX_RAND 65536
#define EVENT_COUNT 4096
#define MAX_ROWS 4
#define MAX_TEXTS 16

/* log kinds (the Python LOGKINDS table has the same numbers; ENTER = 18 is Python-only) */
enum {
    K_START = 1, K_CLEAR_ITEM, K_RECENTER, K_ALLOC, K_RELEASE_SLOT, K_LOAD, K_RELEASE, K_RAND, K_TICK, K_SND_PREPARE, K_SND_PLAY,
    K_SND_BUSY, K_AUTOTEXT, K_CAPTION, K_TRANSITION, K_FLAG, K_COMPLETE
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
} Text;

typedef struct Mpo {
    MpObject obj;
    MpHost host;
    MpView view;
    uint8_t entries[ENTRY_COUNT][ENTRY_STRIDE];
    Rec log[MAX_LOG];
    int nlog;
    uint32_t handle;
    uint32_t ticks[MAX_QUEUE];
    int nticks, iticks, tick_underflow;
    int32_t busy[MAX_QUEUE];
    int nbusy, ibusy, busy_underflow;
    int32_t rands[MAX_RAND];
    int nrand, irand, rand_underflow;
    int32_t captions;
    Text texts[MAX_TEXTS];
    int ntexts;
    int32_t cell[8]; /* 5bb57b, 5bb599, 5bb595, 5c39ff, 5bb59b, 5bb59f, 5bb5a3, 583999 */
    int32_t start_flag;
    int32_t events[EVENT_COUNT];
    uint8_t *bodies[MAX_ROWS];
    const uint8_t *cur_body;
    const char *why;
    int bad_slot_calls;
    int host_error;
    int alloc_fail;
    int fail_at, host_calls; /* the n-th failing host call returns 1 (0 = never) */
} Mpo;

static void put32(uint8_t *p, uint32_t v) { memcpy(p, &v, 4); }
static void put16(uint8_t *p, uint16_t v) { memcpy(p, &v, 2); }

static Rec *add(Mpo *o, int kind)
{
    static Rec dummy;
    Rec *r;
    if (o->nlog >= MAX_LOG) {
        o->host_error++;
        return &dummy;
    }
    r = &o->log[o->nlog++];
    memset(r, 0, sizeof *r);
    r->kind = kind;
    return r;
}

static int failing(Mpo *o)
{
    o->host_calls++;
    return o->fail_at != 0 && o->host_calls == o->fail_at;
}

static uint8_t *entry(Mpo *o, int16_t slot)
{
    if (slot < 0 || (unsigned)slot >= ENTRY_COUNT) {
        o->bad_slot_calls++;
        return NULL;
    }
    return o->entries[slot];
}

static int h_view(void *c, MpView *v)
{
    if (failing((Mpo *)c)) return 1;
    *v = ((Mpo *)c)->view;
    return 0;
}

static int h_set_start_flag(void *c, int32_t value)
{
    if (failing((Mpo *)c)) return 1;
    Mpo *o = c;
    Rec *r = add(o, K_START);
    o->start_flag = value;
    r->v[0] = value;
    return 0;
}

static int h_clear_item(void *c)
{
    if (failing((Mpo *)c)) return 1;
    add(c, K_CLEAR_ITEM);
    return 0;
}

static int h_recenter(void *c)
{
    if (failing((Mpo *)c)) return 1;
    add(c, K_RECENTER);
    return 0;
}

static int h_alloc_slot(void *c, int16_t *slot)
{
    if (failing((Mpo *)c)) return 1;
    Mpo *o = c;
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
    if (failing((Mpo *)c)) return 1;
    Mpo *o = c;
    uint8_t *e = entry(o, slot);
    if (e == NULL) return 1;
    put32(e + E_TYPE, 0xbu);
    put32(e + E_CALLBACK, 0x47d24eu);
    put32(e + E_SURFACE, 0u);
    put32(e + E_F0C, 0u);
    put32(e + E_F10, 0u);
    put32(e + E_DIRTY, 1u);
    put32(e + E_BUSY, 1u);
    put16(e + E_WORD, 0u);
    memcpy(e + E_LABEL, label, strlen(label) + 1u); /* the inline repne scasb / rep movs copy */
    return 0;
}

static int h_set_slot_surface(void *c, int16_t slot, uint32_t surface)
{
    if (failing((Mpo *)c)) return 1;
    uint8_t *e = entry(c, slot);
    if (e == NULL) return 1;
    put32(e + E_SURFACE, surface);
    return 0;
}

static int h_release_slot(void *c, int16_t slot)
{
    if (failing((Mpo *)c)) return 1;
    Mpo *o = c;
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
    if (failing((Mpo *)c)) return 1;
    uint8_t *e = entry(c, slot);
    if (e == NULL) return 1;
    put32(e + E_DIRTY, 1u);
    return 0;
}

static int h_load_surface(void *c, const char *name, const char *tag, uint32_t *surface)
{
    if (failing((Mpo *)c)) return 1;
    Mpo *o = c;
    Rec *r = add(o, K_LOAD);
    snprintf(r->s0, sizeof r->s0, "%s|%s", name, tag);
    *surface = o->handle;
    r->v[0] = (int32_t)*surface;
    return 0;
}

static int h_release_surface(void *c, uint32_t surface)
{
    if (failing((Mpo *)c)) return 1;
    Rec *r = add(c, K_RELEASE);
    r->v[0] = (int32_t)surface;
    return 0;
}

static int32_t h_random(void *c)
{
    Mpo *o = c;
    Rec *r = add(o, K_RAND);
    int32_t v = 0;
    if (o->irand < o->nrand)
        v = o->rands[o->irand];
    else
        o->rand_underflow++;
    o->irand++;
    r->v[0] = v;
    return v;
}

static uint32_t h_tick(void *c)
{
    Mpo *o = c;
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

static void hexrec(Rec *r, const uint8_t *p)
{
    static const char dig[] = "0123456789abcdef";
    for (unsigned k = 0; k < MP_SOUND_HOST_BYTES; ++k) {
        r->s0[2 * k] = dig[p[k] >> 4];
        r->s0[2 * k + 1] = dig[p[k] & 15];
    }
    r->s0[2 * MP_SOUND_HOST_BYTES] = 0;
}

static int h_sound_prepare(void *c, uint32_t id, const uint8_t *record)
{
    if (failing((Mpo *)c)) return 1;
    Mpo *o = c;
    Rec *r = add(o, K_SND_PREPARE);
    if (o->cur_body == NULL || record != o->cur_body + id) o->host_error++; /* the pointer the original passes is body + id */
    r->v[0] = (int32_t)id;
    hexrec(r, record);
    return 0;
}

static int h_sound_play(void *c, int16_t channel)
{
    if (failing((Mpo *)c)) return 1;
    Rec *r = add(c, K_SND_PLAY);
    r->v[0] = channel;
    return 0;
}

static int h_sound_busy(void *c, int16_t channel, int32_t *result)
{
    if (failing((Mpo *)c)) return 1;
    Mpo *o = c;
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

static int h_captions(void *c, int32_t *enabled)
{
    if (failing((Mpo *)c)) return 1;
    *enabled = ((Mpo *)c)->captions;
    return 0;
}

static int h_autotext(void *c, const char *key, const char **text)
{
    if (failing((Mpo *)c)) return 1;
    Mpo *o = c;
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
    if (failing((Mpo *)c)) return 1;
    Rec *r = add(c, K_CAPTION);
    snprintf(r->s0, sizeof r->s0, "%s", text);
    return 0;
}

static int h_event_flag_invalid(void *c, int16_t index)
{
    (void)c;
    return index < 0 || index >= EVENT_COUNT;
}

static int h_transition(void *c, const MpTransition *t)
{
    if (failing((Mpo *)c)) return 1;
    Mpo *o = c;
    Rec *r = add(o, K_TRANSITION);
    o->cell[0] = t->scene;
    o->cell[1] = t->word[0];
    o->cell[2] = t->word[1];
    o->cell[3] = t->word[2];
    o->cell[4] = t->dword[0];
    o->cell[5] = t->dword[1];
    o->cell[6] = t->dword[2];
    o->cell[7] = 4;
    o->start_flag = t->start_flag;
    for (int k = 0; k < 8; ++k) r->v[k] = o->cell[k];
    r->v[8] = t->start_flag;
    return 0;
}

static int h_store_event_flag(void *c, int16_t index, int32_t value)
{
    if (failing((Mpo *)c)) return 1;
    Mpo *o = c;
    Rec *r = add(o, K_FLAG);
    r->v[0] = index;
    r->v[1] = value;
    if (index < 0 || index >= EVENT_COUNT) return 1;
    o->events[index] = value;
    return 0;
}

static int h_complete(void *c, int16_t row)
{
    if (failing((Mpo *)c)) return 1;
    Rec *r = add(c, K_COMPLETE);
    r->v[0] = row;
    return 0;
}

void *mpo_new(void)
{
    Mpo *o = calloc(1, sizeof *o);
    if (o == NULL) return NULL;
    mp_object_reset(&o->obj);
    o->handle = 0x7001u;
    o->host.context = o;
    o->host.view = h_view;
    o->host.set_start_flag = h_set_start_flag;
    o->host.clear_pending_item = h_clear_item;
    o->host.recenter_cursor = h_recenter;
    o->host.alloc_slot = h_alloc_slot;
    o->host.register_slot = h_register_slot;
    o->host.set_slot_surface = h_set_slot_surface;
    o->host.release_slot = h_release_slot;
    o->host.mark_dirty = h_mark_dirty;
    o->host.load_surface = h_load_surface;
    o->host.release_surface = h_release_surface;
    o->host.random = h_random;
    o->host.tick = h_tick;
    o->host.sound_prepare = h_sound_prepare;
    o->host.sound_play = h_sound_play;
    o->host.sound_busy = h_sound_busy;
    o->host.captions_enabled = h_captions;
    o->host.autotext_lookup = h_autotext;
    o->host.caption_show = h_caption;
    o->host.event_flag_invalid = h_event_flag_invalid;
    o->host.transition = h_transition;
    o->host.store_event_flag = h_store_event_flag;
    o->host.complete = h_complete;
    return o;
}

void mpo_free(void *h)
{
    Mpo *o = h;
    if (o == NULL) return;
    for (int i = 0; i < MAX_ROWS; ++i) free(o->bodies[i]);
    for (int i = 0; i < o->ntexts; ++i) free(o->texts[i].text);
    free(o);
}

void mpo_set_view(void *h, const int32_t *v) /* view l, t, r, b, clip l, t, r, b */
{
    Mpo *o = h;
    for (int k = 0; k < 4; ++k) {
        o->view.view[k] = v[k];
        o->view.clip[k] = v[4 + k];
    }
}

void mpo_set_fail(void *h, int n)
{
    ((Mpo *)h)->fail_at = n;
    ((Mpo *)h)->host_calls = 0;
}

void mpo_reset_object(void *h) { mp_object_reset(&((Mpo *)h)->obj); }
void mpo_set_handle(void *h, uint32_t v) { ((Mpo *)h)->handle = v; }
void mpo_set_start_flag(void *h, int32_t v) { ((Mpo *)h)->start_flag = v; }
int32_t mpo_get_start_flag(void *h) { return ((Mpo *)h)->start_flag; }
void mpo_set_captions(void *h, int32_t v) { ((Mpo *)h)->captions = v; }

void mpo_set_queues(void *h, const uint32_t *ticks, int nt, const int32_t *busy, int nb, const int32_t *rands, int nr)
{
    Mpo *o = h;
    o->nticks = nt > MAX_QUEUE ? MAX_QUEUE : nt;
    memcpy(o->ticks, ticks, (size_t)o->nticks * sizeof(uint32_t));
    o->iticks = 0;
    o->tick_underflow = 0;
    o->nbusy = nb > MAX_QUEUE ? MAX_QUEUE : nb;
    memcpy(o->busy, busy, (size_t)o->nbusy * sizeof(int32_t));
    o->ibusy = 0;
    o->busy_underflow = 0;
    o->nrand = nr > MAX_RAND ? MAX_RAND : nr;
    memcpy(o->rands, rands, (size_t)o->nrand * sizeof(int32_t));
    o->irand = 0;
    o->rand_underflow = 0;
}

/* consumed: ticks, busy, rand, tick underflow, busy underflow, rand underflow, host contract errors, alloc failures */
void mpo_consumed(void *h, int32_t *out)
{
    Mpo *o = h;
    out[0] = o->iticks;
    out[1] = o->ibusy;
    out[2] = o->irand;
    out[3] = o->tick_underflow;
    out[4] = o->busy_underflow;
    out[5] = o->rand_underflow;
    out[6] = o->host_error;
    out[7] = o->alloc_fail;
}

void mpo_clear_texts(void *h)
{
    Mpo *o = h;
    for (int i = 0; i < o->ntexts; ++i) free(o->texts[i].text);
    o->ntexts = 0;
}

void mpo_add_text(void *h, const char *key, const char *text)
{
    Mpo *o = h;
    size_t n = strlen(text) + 1u;
    if (o->ntexts >= MAX_TEXTS) return;
    snprintf(o->texts[o->ntexts].key, sizeof o->texts[0].key, "%s", key);
    o->texts[o->ntexts].text = malloc(n);
    if (o->texts[o->ntexts].text == NULL) return;
    memcpy(o->texts[o->ntexts].text, text, n);
    o->ntexts++;
}

void mpo_set_entry_u32(void *h, int slot, int offset, uint32_t value)
{
    Mpo *o = h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT && offset >= 0 && offset + 4 <= (int)ENTRY_STRIDE)
        put32(o->entries[slot] + offset, value);
}

void mpo_set_cells(void *h, const int32_t *v) { memcpy(((Mpo *)h)->cell, v, 8u * sizeof(int32_t)); }
void mpo_get_cells(void *h, int32_t *out) { memcpy(out, ((Mpo *)h)->cell, 8u * sizeof(int32_t)); }
void mpo_set_events(void *h, const int32_t *v) { memcpy(((Mpo *)h)->events, v, sizeof(((Mpo *)h)->events)); }
void mpo_get_events(void *h, int32_t *out) { memcpy(out, ((Mpo *)h)->events, sizeof(((Mpo *)h)->events)); }
void mpo_set_entries(void *h, const uint8_t *in) { memcpy(((Mpo *)h)->entries, in, sizeof(((Mpo *)h)->entries)); }
void mpo_entries(void *h, uint8_t *out) { memcpy(out, ((Mpo *)h)->entries, sizeof(((Mpo *)h)->entries)); }

void mpo_clear_log(void *h)
{
    Mpo *o = h;
    o->nlog = 0;
    o->bad_slot_calls = 0;
}

int mpo_log_count(void *h) { return ((Mpo *)h)->nlog; }
int mpo_bad_slot_calls(void *h) { return ((Mpo *)h)->bad_slot_calls; }

void mpo_log(void *h, int i, int32_t *out)
{
    memcpy(out, &((Mpo *)h)->log[i], 13u * sizeof(int32_t));
}

const char *mpo_log_text(void *h, int i) { return ((Mpo *)h)->log[i].s0; }

/* Bodies: one mutable copy per row, as the loader's allocation. */
int mpo_set_body(void *h, int row, const uint8_t *body, size_t length)
{
    Mpo *o = h;
    uint8_t *copy;
    if (row < 0 || row >= MAX_ROWS) return 1;
    copy = malloc(length ? length : 1u);
    if (copy == NULL) return 1;
    memcpy(copy, body, length);
    free(o->bodies[row]);
    o->bodies[row] = copy;
    return 0;
}

void mpo_get_body(void *h, int row, uint8_t *out, size_t length)
{
    Mpo *o = h;
    if (row >= 0 && row < MAX_ROWS && o->bodies[row] != NULL) memcpy(out, o->bodies[row], length);
}

const char *mpo_why(void *h) { return ((Mpo *)h)->why; }

void mpo_object(void *h, uint8_t *out) { memcpy(out, ((Mpo *)h)->obj.b, MP_OBJECT_BYTES); }
void mpo_set_object(void *h, const uint8_t *in) { memcpy(((Mpo *)h)->obj.b, in, MP_OBJECT_BYTES); }
void mpo_heap(void *h, uint8_t *cells, uint8_t *used)
{
    Mpo *o = h;
    memcpy(cells, o->obj.cells, sizeof o->obj.cells);
    memcpy(used, o->obj.used, sizeof o->obj.used);
}

void mpo_set_heap(void *h, const uint8_t *cells, const uint8_t *used)
{
    Mpo *o = h;
    memcpy(o->obj.cells, cells, sizeof o->obj.cells);
    memcpy(o->obj.used, used, sizeof o->obj.used);
}

/* result: phase_after, initialized, completed */
int mpo_step(void *h, int row_index, int row, uint32_t body_handle, uint32_t phase, uint32_t *result)
{
    Mpo *o = h;
    MpResult r;
    int status;
    memset(&r, 0, sizeof r);
    o->why = "none";
    o->cur_body = o->bodies[row_index];
    status = mp_step(&o->obj, o->bodies[row_index], MP_BODY_BYTES, body_handle, (int16_t)row, phase, &o->host, &r, &o->why);
    o->cur_body = NULL;
    result[0] = r.phase_after;
    result[1] = r.initialized;
    result[2] = r.completed;
    return status;
}

/* out: hit, candidate, wrote_cursor, cursor, cursor_flag */
int mpo_pointer(void *h, int row_index, int x, int y, int32_t *out)
{
    Mpo *o = h;
    MpPointerResult r;
    int status;
    memset(&r, 0xA5, sizeof r);
    status = mp_pointer(&o->obj, o->bodies[row_index], MP_BODY_BYTES, (int16_t)x, (int16_t)y, &r);
    out[0] = r.hit;
    out[1] = r.candidate;
    out[2] = r.wrote_cursor;
    out[3] = r.cursor;
    out[4] = r.cursor_flag;
    return status;
}

int mpo_click(void *h, int row_index, uint32_t body_handle, uint32_t row_phase, int32_t candidate)
{
    Mpo *o = h;
    int status;
    o->cur_body = o->bodies[row_index];
    status = mp_click(&o->obj, o->bodies[row_index], MP_BODY_BYTES, body_handle, row_phase, candidate, &o->host);
    o->cur_body = NULL;
    return status;
}

int mpo_invalidate(void *h) { return mp_invalidate(&((Mpo *)h)->obj, &((Mpo *)h)->host); }
int mpo_cleanup(void *h) { return mp_cleanup(&((Mpo *)h)->obj, &((Mpo *)h)->host); }

/* render plan: valid, count, then per blit src_kind, label, src[4], dst[4] (10 ints) */
int mpo_plan(void *h, int row_index, int32_t *out)
{
    Mpo *o = h;
    static MpRenderPlan p;
    int status;
    int k = 0;
    memset(&p, 0, sizeof p);
    status = mp_render_plan(&o->obj, o->bodies[row_index], MP_BODY_BYTES, &o->host, &p);
    out[k++] = p.valid;
    out[k++] = p.count;
    for (int i = 0; i < MP_MAX_BLITS; ++i) {
        out[k++] = p.blit[i].src_kind;
        out[k++] = p.blit[i].label;
        for (int j = 0; j < 4; ++j) out[k++] = p.blit[i].src[j];
        for (int j = 0; j < 4; ++j) out[k++] = p.blit[i].dst[j];
    }
    return status;
}

/* status; buf receives the failure text (up to 63 bytes) */
int mpo_validate(const uint8_t *body, size_t length, char *buf)
{
    const char *why = NULL;
    int rc = mp_validate_body(body, length, &why);
    buf[0] = 0;
    if (why != NULL) {
        strncpy(buf, why, 63);
        buf[63] = 0;
    }
    return rc;
}

/* The argument guards: NULL pointers and missing host callbacks. */
void mpo_null_checks(void *h, int32_t *out)
{
    Mpo *o = h;
    MpResult res;
    MpPointerResult pr;
    MpRenderPlan *plan = malloc(sizeof *plan);
    MpHost part = o->host;
    int n = 0;
    out[n++] = mp_step(NULL, o->bodies[0], MP_BODY_BYTES, 0, 0, 0, &o->host, &res, NULL);
    out[n++] = mp_step(&o->obj, NULL, MP_BODY_BYTES, 0, 0, 0, &o->host, &res, NULL);
    out[n++] = mp_step(&o->obj, o->bodies[0], MP_BODY_BYTES, 0, 0, 0, NULL, &res, NULL);
    out[n++] = mp_step(&o->obj, o->bodies[0], MP_BODY_BYTES, 0, 0, 0, &o->host, NULL, NULL);
    part.random = NULL;
    out[n++] = mp_step(&o->obj, o->bodies[0], MP_BODY_BYTES, 0, 0, 0, &part, &res, NULL);
    part = o->host;
    part.complete = NULL;
    out[n++] = mp_cleanup(&o->obj, &part);
    out[n++] = mp_invalidate(&o->obj, NULL);
    out[n++] = mp_pointer(NULL, o->bodies[0], MP_BODY_BYTES, 0, 0, &pr);
    out[n++] = mp_pointer(&o->obj, o->bodies[0], MP_BODY_BYTES, 0, 0, NULL);
    out[n++] = mp_click(NULL, o->bodies[0], MP_BODY_BYTES, 0, 0, 0, &o->host);
    out[n++] = mp_click(&o->obj, o->bodies[0], MP_BODY_BYTES, 0, 0, 0, NULL);
    if (plan != NULL) {
        out[n++] = mp_render_plan(NULL, o->bodies[0], MP_BODY_BYTES, &o->host, plan);
        out[n++] = mp_render_plan(&o->obj, o->bodies[0], MP_BODY_BYTES, NULL, plan);
        out[n++] = mp_render_plan(&o->obj, o->bodies[0], MP_BODY_BYTES, &o->host, NULL);
        free(plan);
    }
}

/* The contract constants of the header. */
void mpo_constants(int32_t *out)
{
    out[0] = MP_RUNTIME_TYPE;
    out[1] = (int32_t)MP_BODY_BYTES;
    out[2] = (int32_t)MP_OBJECT_BYTES;
    out[3] = MP_MAX_TILES_PER_PAGE;
    out[4] = MP_MAX_CELLS;
    out[5] = MP_MAX_IDS;
    out[6] = (int32_t)MP_CELL_BYTES;
    out[7] = (int32_t)MP_SOUND_RECORD_BYTES;
    out[8] = MP_NO_SCENE;
    out[9] = MP_NO_FLAG;
    out[10] = MP_FLIP_CHANNEL;
    out[11] = MP_CANDIDATE_TAB;
    out[12] = MP_CANDIDATE_TILE;
    out[13] = (int32_t)MP_GUEST_CELLS;
    out[14] = (int32_t)MP_GUEST_USED;
    out[15] = (int32_t)MP_VTABLE;
    out[16] = MP_MAX_BLITS;
    out[17] = (int32_t)sizeof(MpObject);
}
