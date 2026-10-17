/* RT-47 oracle driver: exposes the native raw 0xf6 card puzzle kernel (src/action_family_f6_runtime.c) to
 * tests/action_family_f6_runtime_original_oracle.py through ctypes.
 *
 * The driver owns one F6Object, one F6World and a SCRIPTED host. The host applies to a model of the generic Z entry
 * table (0x5d1591, stride 0x4a, 0x58 entries) the stores the original externals make (0x4d39f9 allocator, the inline
 * entry stores of 0x45f0e6, 0x4d3992 releaser, 0x45dd96), to a model of the scene-change cells (0x5bb57b, 0x5bb599,
 * 0x5bb595, 0x5c39ff, 0x5bb59b, 0x5bb59f, 0x5bb5a3), the engine mode (0x583999) and the event flag table (a window of
 * dwords standing for 0x585801 + 4 * index). It answers GetTickCount, _rand and 0x4f6334 from scripted queues that the
 * Python side also feeds to the original, and 0x423259 from a scripted table (sound name -> text or absent). Two
 * ordered logs are exported: the kernel's own F6_FX_* observer log and an independent host-call trace (what the kernel
 * actually asked of the host: tick / rand values, busy answers, play channels, hashes of the sound record, the autotext
 * key, the caption text, the image name, the surface released). The Python side runs the unmodified x86 with hooks that
 * record the same things and compares both logs.
 *
 * Host-call trace vocabulary (kind, a, b), the same numbers as H in the Python file:
 *   1 TICK(value)  2 RAND(value)  3 BUSY(channel, answer)  4 PLAY(channel)  5 PREPARE(crc32 of the 0x31 byte record)
 *   6 AUTOTEXT(crc32 of the key, found)  7 CAPTION(strlen of the text with its suffix, crc32 of it)  8 LOAD(crc32 of the
 *   image name, handle)  9 RELEASE_SURFACE(handle)  10 CLEAR
 *
 * Test code only: portable C11, no original bytes. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_f6_runtime.h"

#define ENTRY_STRIDE 0x4au
#define ENTRY_COUNT 0x58u
#define MAX_LOG 4096
#define MAX_NAMES 16
#define MAX_CAPS 1024
#define CAP_BYTES 320
#define MAX_HANDLES 32
#define MAX_QUEUE 8192
#define MAX_TEXTS 192
#define KEY_BYTES 48
#define TEXT_BYTES 320
#define EVENT_COUNT 4096
#define MAX_PLAN_BLITS 160

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

enum { H_TICK = 1, H_RAND, H_BUSY, H_PLAY, H_PREPARE, H_AUTOTEXT, H_CAPTION, H_LOAD, H_RELEASE_SURFACE, H_CLEAR };

typedef struct TextEntry {
    char key[KEY_BYTES];
    char text[TEXT_BYTES];
    int present;
} TextEntry;

typedef struct F6o {
    F6Object obj;
    F6World world;
    F6Host host;
    int32_t view_x, view_y;
    uint8_t entries[ENTRY_COUNT][ENTRY_STRIDE];
    int32_t log[MAX_LOG][3];
    int nlog;
    int32_t calls[MAX_LOG][3];
    int ncalls;
    char names[MAX_NAMES][64];
    int nnames;
    char captions[MAX_CAPS][CAP_BYTES];
    int ncaps;
    uint32_t handles[MAX_HANDLES];
    int nhandles, ihandle;
    uint32_t ticks[MAX_QUEUE];
    int nticks, iticks, tick_underflow;
    int32_t busy[MAX_QUEUE];
    int nbusy, ibusy, busy_underflow;
    int32_t rnd[MAX_QUEUE];
    int nrand, irand, rand_underflow;
    TextEntry texts[MAX_TEXTS];
    int ntexts;
    int32_t cell[8]; /* 5bb57b, 5bb599, 5bb595, 5c39ff, 5bb59b, 5bb59f, 5bb5a3, 583999 */
    int32_t events[EVENT_COUNT];
    int transitions;
    const char *why;
    int bad_slot_calls;
    int host_error;
    int alloc_fail;
} F6o;

static void put32(uint8_t *p, uint32_t v) { memcpy(p, &v, 4); }
static void put16(uint8_t *p, uint16_t v) { memcpy(p, &v, 2); }
static uint16_t get16(const uint8_t *p) { uint16_t v; memcpy(&v, p, 2); return v; }
static uint32_t get32(const uint8_t *p) { uint32_t v; memcpy(&v, p, 4); return v; }

static uint32_t crc32_bytes(const uint8_t *p, size_t n)
{
    uint32_t c = 0xffffffffu;
    for (size_t i = 0; i < n; ++i) {
        c ^= p[i];
        for (int k = 0; k < 8; ++k) c = (c >> 1) ^ (0xedb88320u & (0u - (c & 1u)));
    }
    return ~c;
}

static uint8_t *entry(F6o *o, int16_t slot)
{
    if (slot < 0 || (unsigned)slot >= ENTRY_COUNT) {
        o->bad_slot_calls++;
        return NULL;
    }
    return o->entries[slot];
}

static void observe(void *c, int effect, int32_t a, int32_t b)
{
    F6o *o = c;
    if (o->nlog < MAX_LOG) {
        o->log[o->nlog][0] = effect;
        o->log[o->nlog][1] = a;
        o->log[o->nlog][2] = b;
        o->nlog++;
    }
}

static void trace(F6o *o, int kind, int32_t a, int32_t b)
{
    if (o->ncalls < MAX_LOG) {
        o->calls[o->ncalls][0] = kind;
        o->calls[o->ncalls][1] = a;
        o->calls[o->ncalls][2] = b;
        o->ncalls++;
    }
}

static int h_alloc_slot(void *c, int16_t *slot)
{
    F6o *o = c;
    for (int i = 0x18; i <= 0x3f; ++i) {
        if (get32(o->entries[i] + E_BUSY) == 0u) {
            *slot = (int16_t)i;
            return 0;
        }
    }
    o->alloc_fail++;
    return 1; /* the original reaches the fatal path 0x52139c here */
}

static int h_register_slot(void *c, int16_t slot, const char *label)
{
    F6o *o = c;
    uint8_t *e = entry(o, slot);
    if (e == NULL) return 1;
    put32(e + E_TYPE, 10u);
    put32(e + E_CALLBACK, 0x460f26u);
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
    F6o *o = c;
    if (o->nnames < MAX_NAMES) {
        strncpy(o->names[o->nnames], name, sizeof o->names[0] - 1u);
        o->names[o->nnames][sizeof o->names[0] - 1u] = '\0';
        o->nnames++;
    }
    *surface = o->ihandle < o->nhandles ? o->handles[o->ihandle] : 0u;
    o->ihandle++;
    trace(o, H_LOAD, (int32_t)crc32_bytes((const uint8_t *)name, strlen(name)), (int32_t)*surface);
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
    trace(c, H_RELEASE_SURFACE, (int32_t)surface, 0);
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
    F6o *o = c;
    *x = o->view_x;
    *y = o->view_y;
    return 0;
}

static int h_clear_item(void *c)
{
    trace(c, H_CLEAR, 0, 0);
    return 0;
}

static int h_sound_prepare(void *c, const uint8_t *record)
{
    F6o *o = c;
    if (record == NULL) {
        o->host_error++;
        return 1;
    }
    trace(o, H_PREPARE, (int32_t)crc32_bytes(record, F6_RECORD_BYTES), 0);
    return 0;
}

static int h_sound_play(void *c, int16_t channel)
{
    trace(c, H_PLAY, channel, 0);
    return 0;
}

static int h_sound_busy(void *c, int16_t channel, int32_t *result)
{
    F6o *o = c;
    if (o->ibusy < o->nbusy) {
        *result = o->busy[o->ibusy];
    } else {
        *result = 0;
        o->busy_underflow++;
    }
    o->ibusy++;
    trace(o, H_BUSY, channel, *result);
    return 0;
}

static uint32_t h_tick(void *c)
{
    F6o *o = c;
    uint32_t v = 0u;
    if (o->iticks < o->nticks)
        v = o->ticks[o->iticks];
    else
        o->tick_underflow++;
    o->iticks++;
    trace(o, H_TICK, (int32_t)v, 0);
    return v;
}

static int32_t h_random(void *c)
{
    F6o *o = c;
    int32_t v = 0;
    if (o->irand < o->nrand)
        v = o->rnd[o->irand];
    else
        o->rand_underflow++;
    o->irand++;
    trace(o, H_RAND, v, 0);
    return v;
}

static int h_autotext(void *c, const char *key, const char **text)
{
    F6o *o = c;
    *text = NULL;
    for (int i = 0; i < o->ntexts; ++i) {
        if (strcmp(o->texts[i].key, key) == 0) {
            if (o->texts[i].present) *text = o->texts[i].text;
            break;
        }
    }
    trace(o, H_AUTOTEXT, (int32_t)crc32_bytes((const uint8_t *)key, strlen(key)), *text != NULL);
    return 0;
}

static int h_caption(void *c, const char *text, size_t length)
{
    F6o *o = c;
    if (o->ncaps < MAX_CAPS) {
        strncpy(o->captions[o->ncaps], text, CAP_BYTES - 1u);
        o->captions[o->ncaps][CAP_BYTES - 1u] = '\0';
        o->ncaps++;
    }
    trace(o, H_CAPTION, (int32_t)length, (int32_t)crc32_bytes((const uint8_t *)text, strlen(text)));
    return 0;
}

static int h_event_flag_invalid(void *c, int16_t index)
{
    (void)c;
    return index < 0 || index >= EVENT_COUNT;
}

static int h_transition(void *c, const F6Transition *t)
{
    F6o *o = c;
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
    F6o *o = c;
    if (index < 0 || index >= EVENT_COUNT) return 1;
    o->events[index] = (int32_t)value;
    return 0;
}

void *f6o_new(void)
{
    F6o *o = calloc(1, sizeof *o);
    if (o == NULL) return NULL;
    f6_object_reset(&o->obj);
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
    o->host.sound_play = h_sound_play;
    o->host.sound_busy = h_sound_busy;
    o->host.tick = h_tick;
    o->host.random = h_random;
    o->host.autotext = h_autotext;
    o->host.caption = h_caption;
    o->host.event_flag_invalid = h_event_flag_invalid;
    o->host.transition = h_transition;
    o->host.store_event_flag = h_store_event_flag;
    o->host.observe = observe;
    return o;
}

void f6o_free(void *h) { free(h); }

void f6o_set_view(void *h, int32_t x, int32_t y)
{
    F6o *o = h;
    o->view_x = x;
    o->view_y = y;
}

void f6o_set_world_flag(void *h, int32_t v) { ((F6o *)h)->world.start_flag_5bb1ca = v; }
int32_t f6o_get_world_flag(void *h) { return ((F6o *)h)->world.start_flag_5bb1ca; }

void f6o_set_handles(void *h, const uint32_t *hs, int n)
{
    F6o *o = h;
    o->nhandles = n > MAX_HANDLES ? MAX_HANDLES : n;
    memcpy(o->handles, hs, (size_t)o->nhandles * sizeof(uint32_t));
    o->ihandle = 0;
}

void f6o_set_queues(void *h, const uint32_t *ticks, int nt, const int32_t *busy, int nb, const int32_t *rnd, int nr)
{
    F6o *o = h;
    o->nticks = nt > MAX_QUEUE ? MAX_QUEUE : nt;
    memcpy(o->ticks, ticks, (size_t)o->nticks * sizeof(uint32_t));
    o->iticks = 0;
    o->tick_underflow = 0;
    o->nbusy = nb > MAX_QUEUE ? MAX_QUEUE : nb;
    memcpy(o->busy, busy, (size_t)o->nbusy * sizeof(int32_t));
    o->ibusy = 0;
    o->busy_underflow = 0;
    o->nrand = nr > MAX_QUEUE ? MAX_QUEUE : nr;
    memcpy(o->rnd, rnd, (size_t)o->nrand * sizeof(int32_t));
    o->irand = 0;
    o->rand_underflow = 0;
}

void f6o_clear_texts(void *h) { ((F6o *)h)->ntexts = 0; }

/* text == NULL: the key is scripted as absent (0x423259 returns 0) */
void f6o_add_text(void *h, const char *key, const char *text)
{
    F6o *o = h;
    TextEntry *t;
    if (o->ntexts >= MAX_TEXTS) return;
    t = &o->texts[o->ntexts++];
    memset(t, 0, sizeof *t);
    strncpy(t->key, key, KEY_BYTES - 1u);
    if (text != NULL) {
        strncpy(t->text, text, TEXT_BYTES - 1u);
        t->present = 1;
    }
}

/* consumed counts: ticks, busy answers, rand values, tick / busy / rand underflows, host contract errors, allocator failures */
void f6o_consumed(void *h, int32_t *out)
{
    F6o *o = h;
    out[0] = o->iticks;
    out[1] = o->ibusy;
    out[2] = o->irand;
    out[3] = o->tick_underflow;
    out[4] = o->busy_underflow;
    out[5] = o->rand_underflow;
    out[6] = o->host_error;
    out[7] = o->alloc_fail;
}

void f6o_set_busy_slot(void *h, int slot, int busy)
{
    F6o *o = h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT) put32(o->entries[slot] + E_BUSY, busy ? 1u : 0u);
}

void f6o_set_entry_u32(void *h, int slot, int offset, uint32_t value)
{
    F6o *o = h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT && offset >= 0 && offset + 4 <= (int)ENTRY_STRIDE)
        put32(o->entries[slot] + offset, value);
}

void f6o_set_cells(void *h, const int32_t *v) { memcpy(((F6o *)h)->cell, v, 8u * sizeof(int32_t)); }
void f6o_get_cells(void *h, int32_t *out) { memcpy(out, ((F6o *)h)->cell, 8u * sizeof(int32_t)); }
void f6o_set_events(void *h, const int32_t *v) { memcpy(((F6o *)h)->events, v, sizeof(((F6o *)h)->events)); }
void f6o_get_events(void *h, int32_t *out) { memcpy(out, ((F6o *)h)->events, sizeof(((F6o *)h)->events)); }

void f6o_clear_log(void *h)
{
    F6o *o = h;
    o->nlog = 0;
    o->ncalls = 0;
    o->nnames = 0;
    o->ncaps = 0;
    o->bad_slot_calls = 0;
}

/* result: phase_after, initialized, completed */
int f6o_step(void *h, const uint8_t *body, int row, uint32_t phase, uint32_t *result)
{
    F6o *o = h;
    F6Result r;
    int status;
    memset(&r, 0, sizeof r);
    o->why = "none";
    status = f6_step(&o->obj, body, F6_BODY_BYTES, (int16_t)row, phase, &o->world, &o->host, &r, &o->why);
    result[0] = r.phase_after;
    result[1] = r.initialized;
    result[2] = r.completed;
    return status;
}

const char *f6o_why(void *h) { return ((F6o *)h)->why; }

/* out: hit, candidate, cursor, sprite */
int f6o_pointer(void *h, const uint8_t *body, int x, int y, int32_t *out)
{
    F6o *o = h;
    F6PointerResult r;
    int status;
    memset(&r, 0, sizeof r);
    r.candidate = -1;
    status = f6_pointer_move(&o->obj, body, F6_BODY_BYTES, (int16_t)x, (int16_t)y, &r);
    out[0] = r.hit;
    out[1] = r.candidate;
    out[2] = r.cursor;
    out[3] = r.sprite;
    return status;
}

int f6o_click(void *h, const uint8_t *body, uint32_t row_phase, int32_t candidate, int32_t start_flag, uint32_t *new_phase)
{
    F6o *o = h;
    (void)start_flag; /* f6_click has no world argument; the parameter keeps the d1 call shape */
    *new_phase = row_phase;
    return f6_click(&o->obj, body, F6_BODY_BYTES, row_phase, candidate, &o->host, new_phase);
}

int f6o_invalidate(void *h)
{
    F6o *o = h;
    return f6_invalidate(&o->obj, &o->host);
}

int f6o_cleanup(void *h)
{
    F6o *o = h;
    return f6_cleanup(&o->obj, &o->host);
}

int f6o_log_count(void *h) { return ((F6o *)h)->nlog; }
void f6o_log(void *h, int i, int32_t *out) { memcpy(out, ((F6o *)h)->log[i], 3u * sizeof(int32_t)); }
int f6o_call_count(void *h) { return ((F6o *)h)->ncalls; }
void f6o_call(void *h, int i, int32_t *out) { memcpy(out, ((F6o *)h)->calls[i], 3u * sizeof(int32_t)); }
int f6o_name_count(void *h) { return ((F6o *)h)->nnames; }
const char *f6o_name(void *h, int i) { return ((F6o *)h)->names[i]; }
int f6o_caption_count(void *h) { return ((F6o *)h)->ncaps; }
const char *f6o_caption(void *h, int i) { return ((F6o *)h)->captions[i]; }

/* The object image (F6_IMAGE_BYTES, original offsets) and the modelled-byte mask, straight from the kernel. */
void f6o_image(void *h, uint8_t *image, uint8_t *mask)
{
    memset(image, 0, F6_IMAGE_BYTES);
    memset(mask, 0, F6_IMAGE_BYTES);
    f6_object_pack(&((F6o *)h)->obj, image, mask);
}

/* The inverse of f6_object_pack for the fields F6Object models: forces the object into an arbitrary (possibly
 * unreachable) state for the fuzz scenarios. Offsets follow the F6Object comments of src/action_family_f6_runtime.h. */
void f6o_set_image(void *h, const uint8_t *p)
{
    F6Object *b = &((F6o *)h)->obj;
    b->slot = (int16_t)get16(p + 0x1c);
    b->row = (int16_t)get16(p + 0x1e);
    b->surface = get32(p + 0x20);
    for (int pl = 0; pl < 2; ++pl) {
        for (int r = 0; r < F6_CARD_ROWS; ++r)
            for (int c = 0; c < F6_MAX_COLUMNS; ++c) b->card[pl][r][c] = (int32_t)get32(p + 0x24 + 0x120 * pl + 0x34 * r + 4 * c);
        for (int c = 0; c < F6_MAX_COLUMNS; ++c) {
            b->count[pl][c] = (int16_t)get16(p + 0xf4 + 0x120 * pl + 2 * c);
            b->mark[pl][c] = (int32_t)get32(p + 0x10e + 0x120 * pl + 4 * c);
        }
        b->score[pl] = (int16_t)get16(p + 0x142 + 0x120 * pl);
    }
    for (int r = 0; r < F6_CARD_ROWS; ++r)
        for (int c = 0; c < F6_MAX_COLUMNS; ++c) b->deck[r][c] = p[0x264 + 13 * r + c];
    b->redraw_298 = p[0x298];
    b->button_down = p[0x299];
    b->selected = (int16_t)get16(p + 0x29a);
    b->deliver_29c = p[0x29c];
    b->no_card_29d = p[0x29d];
    b->clear_29e = p[0x29e];
    b->anim_frame = (int16_t)get16(p + 0x29f);
    b->has_scores = p[0x2a1];
    b->has_display = p[0x2a2];
    b->has_turn = p[0x2a3];
    b->player = (int16_t)get16(p + 0x2a4);
    b->deck_left = (int16_t)get16(p + 0x2a6);
    b->outcome_2a8 = p[0x2a8];
    b->outcome_2a9 = p[0x2a9];
    b->finished = p[0x2aa];
    b->flip_2ab = p[0x2ab];
    b->flip_2ac = p[0x2ac];
    for (int i = 0; i < 2; ++i)
        for (int k = 0; k < 4; ++k) {
            b->display[i][k] = (int32_t)get32(p + 0x2ad + 16 * i + 4 * k);
            b->slide_screen[i][k] = (int32_t)get32(p + 0x2dd + 16 * i + 4 * k);
            b->slide_sheet[i][k] = (int32_t)get32(p + 0x2fd + 16 * i + 4 * k);
        }
    b->display_count = (int16_t)get16(p + 0x2cd);
    b->delivery_step = (int16_t)get16(p + 0x2cf);
    b->blink = (int16_t)get16(p + 0x2d1);
    b->slide_forward = p[0x2d3];
    b->slide_2d4 = p[0x2d4];
    b->slide_step = (int16_t)get16(p + 0x2d5);
    b->slide_index = (int16_t)get16(p + 0x2d7);
    b->after_slide = (int32_t)get32(p + 0x2d9);
    b->active = p[0x321];
    b->has_sound_a = p[0x322];
    b->has_sound_b = p[0x323];
    b->has_delivery = p[0x324];
    b->has_no_card = p[0x325];
    memcpy(b->record, p + 0x326, F6_RECORD_BYTES);
    b->card_row = (int16_t)get16(p + 0x371);
    b->channel = (int16_t)get16(p + 0x373);
    b->deadline_state = get32(p + 0x375);
    b->deadline_anim = get32(p + 0x379);
    b->interval = (int32_t)get32(p + 0x37d);
    b->order_count = (int16_t)get16(p + 0x381);
    for (int i = 0; i < F6_MAX_COLUMNS; ++i) b->order[i] = (int16_t)get16(p + 0x383 + 2 * i);
    b->exit_taken = p[0x39d];
    b->state = (int32_t)get32(p + 0x39e);
    b->next_state = (int32_t)get32(p + 0x3a2);
    b->wait_state = (int32_t)get32(p + 0x3a6);
    b->caption_shown = p[0x3aa];
    b->warned_3ab = p[0x3ab];
    b->picked_3ac = p[0x3ac];
    b->picked_3ad = p[0x3ad];
    b->has_exit = p[0x3ae];
}

void f6o_entries(void *h, uint8_t *out) { memcpy(out, ((F6o *)h)->entries, sizeof(((F6o *)h)->entries)); }

/* render plan: valid, surface, count, then per blit kind, src[4], dst[4] (9 values), up to MAX_PLAN_BLITS blits */
int f6o_plan(void *h, const uint8_t *body, int32_t *out)
{
    F6o *o = h;
    static F6RenderPlan p;
    int status;
    int k = 0;
    memset(&p, 0, sizeof p);
    status = f6_render_plan(&o->obj, body, F6_BODY_BYTES, &o->host, &p);
    out[k++] = p.valid;
    out[k++] = (int32_t)p.surface;
    out[k++] = p.count;
    for (int i = 0; i < p.count && i < MAX_PLAN_BLITS && i < F6_MAX_BLITS; ++i) {
        out[k++] = p.blit[i].kind;
        for (int j = 0; j < 4; ++j) out[k++] = p.blit[i].src[j];
        for (int j = 0; j < 4; ++j) out[k++] = p.blit[i].dst[j];
    }
    return status;
}

int f6o_validate(const uint8_t *body, size_t length) { return f6_validate_body(body, length, NULL); }
