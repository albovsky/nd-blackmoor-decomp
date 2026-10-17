/* RT-51 oracle driver: exposes the native raw 0xd6 / 0xe0 keypad puzzle kernel (src/action_family_e0_runtime.c) to
 * tests/action_family_e0_runtime_original_oracle.py through ctypes.
 *
 * The driver owns one E0Object, one E0World, the typed bodies of up to eight rows and a SCRIPTED host. The host applies
 * to a model of the generic Z entry table (0x5d1591, stride 0x4a, 0x58 entries) the stores the original externals make
 * (0x4d39f9 allocator, the inline entry stores of 0x471722, 0x4d3992 releaser, 0x470e31), to a model of the scene-change
 * cells (0x5bb57b, 0x5bb599, 0x5bb595, 0x5c39ff, 0x5bb59b, 0x5bb59f, 0x5bb5a3), the engine mode (0x583999) and the event
 * flag table (a window of dwords standing for 0x585801 + 4 * index). It answers GetTickCount and 0x4f6334 from scripted
 * queues that the Python side also feeds to the original. Two ordered logs are exported: the kernel's own E0_FX_* observer
 * log and an independent host-call trace (what the kernel actually asked of the host: tick values, busy answers, crc32 of
 * the 9 byte sound records, crc32 of the image name and the handle, slots, surfaces, crc32 of the entry label). The Python
 * side runs the unmodified x86 with hooks that record the same things and compares both logs.
 *
 * Host-call trace vocabulary (kind, a, b), the same numbers as H in the Python file:
 *   1 TICK(value)  2 BUSY(channel, answer)  3 PLAY(channel)  4 PREPARE(crc32 of the 9 byte record)  5 STOP(crc32 of the record)
 *   6 LOAD(crc32 of the image name, handle)  7 RELEASE_SURFACE(handle)  8 ALLOC(slot)  9 REGISTER(slot, surface)
 *   10 SET_SURFACE(slot, surface)  11 RELEASE_SLOT(slot)  12 MARK_DIRTY(slot)  13 LABEL(crc32 of the entry label)
 *
 * Test code only: portable C11, no original bytes. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_e0_runtime.h"

#define ENTRY_STRIDE 0x4au
#define ENTRY_COUNT 0x58u
#define MAX_LOG 8192
#define MAX_NAMES 16
#define MAX_HANDLES 32
#define MAX_QUEUE 8192
#define EVENT_COUNT 4096
#define MAX_ROWS 8
#define MAX_PLAN_BLITS 112
#define RECORD_BYTES 9u

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

enum { H_TICK = 1, H_BUSY, H_PLAY, H_PREPARE, H_STOP, H_LOAD, H_RELEASE_SURFACE, H_ALLOC, H_REGISTER, H_SET_SURFACE, H_RELEASE_SLOT,
       H_MARK_DIRTY, H_LABEL };

typedef struct E0o {
    E0Object obj;
    E0World world;
    E0Host host;
    int32_t view_x, view_y;
    uint8_t entries[ENTRY_COUNT][ENTRY_STRIDE];
    int32_t log[MAX_LOG][3];
    int nlog;
    int32_t calls[MAX_LOG][3];
    int ncalls;
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
    uint8_t body[MAX_ROWS][E0_BODY_CAPACITY];
    int body_len[MAX_ROWS];
    int body_flag[MAX_ROWS];
    int body_loaded[MAX_ROWS];
    const char *why;
    int bad_slot_calls;
    int host_error;
    int alloc_fail;
} E0o;

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

static uint8_t *entry(E0o *o, int16_t slot)
{
    if (slot < 0 || (unsigned)slot >= ENTRY_COUNT) {
        o->bad_slot_calls++;
        return NULL;
    }
    return o->entries[slot];
}

static void observe(void *c, int effect, int32_t a, int32_t b)
{
    E0o *o = c;
    if (o->nlog < MAX_LOG) {
        o->log[o->nlog][0] = effect;
        o->log[o->nlog][1] = a;
        o->log[o->nlog][2] = b;
        o->nlog++;
    }
}

static void trace(E0o *o, int kind, int32_t a, int32_t b)
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
    E0o *o = c;
    for (int i = 0x18; i <= 0x3f; ++i) {
        if (get32(o->entries[i] + E_BUSY) == 0u) {
            *slot = (int16_t)i;
            trace(o, H_ALLOC, i, 0);
            return 0;
        }
    }
    o->alloc_fail++;
    return 1; /* the original reaches the fatal path 0x52139c here */
}

static int h_register_slot(void *c, int16_t slot, const char *label, uint32_t surface)
{
    E0o *o = c;
    uint8_t *e = entry(o, slot);
    if (e == NULL) return 1;
    put32(e + E_TYPE, 10u);
    put32(e + E_CALLBACK, 0x472a5cu);
    put32(e + E_SURFACE, surface);
    put32(e + E_F0C, 0u);
    put32(e + E_F10, 0u);
    put32(e + E_DIRTY, 1u);
    put32(e + E_BUSY, 1u);
    put16(e + E_WORD, 0u);
    memcpy(e + E_LABEL, label, strlen(label) + 1u); /* the inline repne scasb / rep movs copy */
    trace(o, H_REGISTER, slot, (int32_t)surface);
    trace(o, H_LABEL, (int32_t)crc32_bytes((const uint8_t *)label, strlen(label)), 0);
    return 0;
}

static int h_load_surface(void *c, const char *name, uint32_t *surface)
{
    E0o *o = c;
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
    E0o *o = c;
    uint8_t *e = entry(o, slot);
    if (e == NULL) return 1;
    put32(e + E_SURFACE, surface);
    trace(o, H_SET_SURFACE, slot, (int32_t)surface);
    return 0;
}

static int h_release_surface(void *c, uint32_t surface)
{
    trace(c, H_RELEASE_SURFACE, (int32_t)surface, 0);
    return 0;
}

static int h_release_slot(void *c, int16_t slot)
{
    E0o *o = c;
    uint8_t *e = entry(o, slot);
    if (e == NULL) return 1;
    put32(e + E_DIRTY, 0u);
    put32(e + E_BUSY, 0u);
    trace(o, H_RELEASE_SLOT, slot, 0);
    return 0;
}

static int h_mark_dirty(void *c, int16_t slot)
{
    E0o *o = c;
    uint8_t *e = entry(o, slot);
    if (e == NULL) return 1;
    put32(e + E_DIRTY, 1u);
    trace(o, H_MARK_DIRTY, slot, 0);
    return 0;
}

static int h_view_origin(void *c, int32_t *x, int32_t *y)
{
    E0o *o = c;
    *x = o->view_x;
    *y = o->view_y;
    return 0;
}

static int h_sound_prepare(void *c, const uint8_t *record)
{
    E0o *o = c;
    if (record == NULL) {
        o->host_error++;
        return 1;
    }
    trace(o, H_PREPARE, (int32_t)crc32_bytes(record, RECORD_BYTES), 0);
    return 0;
}

static int h_sound_stop(void *c, const uint8_t *record)
{
    E0o *o = c;
    if (record == NULL) {
        o->host_error++;
        return 1;
    }
    trace(o, H_STOP, (int32_t)crc32_bytes(record, RECORD_BYTES), 0);
    return 0;
}

static int h_sound_play(void *c, int16_t channel)
{
    trace(c, H_PLAY, channel, 0);
    return 0;
}

static int h_sound_busy(void *c, int16_t channel, int32_t *result)
{
    E0o *o = c;
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
    E0o *o = c;
    uint32_t v = 0u;
    if (o->iticks < o->nticks)
        v = o->ticks[o->iticks];
    else
        o->tick_underflow++;
    o->iticks++;
    trace(o, H_TICK, (int32_t)v, 0);
    return v;
}

static int h_event_flag_invalid(void *c, int16_t index)
{
    (void)c;
    return index < 0 || index >= EVENT_COUNT;
}

static int h_transition(void *c, const E0Transition *t)
{
    E0o *o = c;
    o->cell[0] = t->scene;
    o->cell[1] = t->word[0];
    o->cell[2] = t->word[1];
    o->cell[3] = t->word[2];
    o->cell[4] = t->dword[0];
    o->cell[5] = t->dword[1];
    o->cell[6] = t->dword[2];
    o->cell[7] = 4;
    return 0;
}

static int h_store_event_flag(void *c, int16_t index, uint32_t value)
{
    E0o *o = c;
    if (index < 0 || index >= EVENT_COUNT) return 1;
    o->events[index] = (int32_t)value;
    return 0;
}

void *e0o_new(void)
{
    E0o *o = calloc(1, sizeof *o);
    if (o == NULL) return NULL;
    e0_object_reset(&o->obj);
    o->host.context = o;
    o->host.alloc_slot = h_alloc_slot;
    o->host.register_slot = h_register_slot;
    o->host.load_surface = h_load_surface;
    o->host.set_slot_surface = h_set_slot_surface;
    o->host.release_surface = h_release_surface;
    o->host.release_slot = h_release_slot;
    o->host.mark_dirty = h_mark_dirty;
    o->host.view_origin = h_view_origin;
    o->host.sound_prepare = h_sound_prepare;
    o->host.sound_stop = h_sound_stop;
    o->host.sound_play = h_sound_play;
    o->host.sound_busy = h_sound_busy;
    o->host.tick = h_tick;
    o->host.transition = h_transition;
    o->host.store_event_flag = h_store_event_flag;
    o->host.event_flag_invalid = h_event_flag_invalid;
    o->host.observe = observe;
    return o;
}

void e0o_free(void *h) { free(h); }

void e0o_set_view(void *h, int32_t x, int32_t y)
{
    E0o *o = h;
    o->view_x = x;
    o->view_y = y;
}

void e0o_set_world(void *h, int32_t start, int32_t scene, int32_t e17)
{
    E0o *o = h;
    o->world.start_flag_5bb1ca = start;
    o->world.scene_cell_5bb57b = scene;
    o->world.entry17_active_5d1a8f = e17;
}

void e0o_get_world(void *h, int32_t *out)
{
    E0o *o = h;
    out[0] = o->world.start_flag_5bb1ca;
    out[1] = o->world.scene_cell_5bb57b;
    out[2] = o->world.entry17_active_5d1a8f;
}

void e0o_set_handles(void *h, const uint32_t *hs, int n)
{
    E0o *o = h;
    o->nhandles = n > MAX_HANDLES ? MAX_HANDLES : n;
    memcpy(o->handles, hs, (size_t)o->nhandles * sizeof(uint32_t));
    o->ihandle = 0;
}

void e0o_set_queues(void *h, const uint32_t *ticks, int nt, const int32_t *busy, int nb)
{
    E0o *o = h;
    o->nticks = nt > MAX_QUEUE ? MAX_QUEUE : nt;
    memcpy(o->ticks, ticks, (size_t)o->nticks * sizeof(uint32_t));
    o->iticks = 0;
    o->tick_underflow = 0;
    o->nbusy = nb > MAX_QUEUE ? MAX_QUEUE : nb;
    memcpy(o->busy, busy, (size_t)o->nbusy * sizeof(int32_t));
    o->ibusy = 0;
    o->busy_underflow = 0;
}

/* consumed counts: ticks, busy answers, tick / busy underflows, host contract errors, allocator failures, bad slots */
void e0o_consumed(void *h, int32_t *out)
{
    E0o *o = h;
    out[0] = o->iticks;
    out[1] = o->ibusy;
    out[2] = o->tick_underflow;
    out[3] = o->busy_underflow;
    out[4] = o->host_error;
    out[5] = o->alloc_fail;
    out[6] = o->bad_slot_calls;
    out[7] = 0;
}

void e0o_set_busy_slot(void *h, int slot, int busy)
{
    E0o *o = h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT) put32(o->entries[slot] + E_BUSY, busy ? 1u : 0u);
}

void e0o_set_entry_u32(void *h, int slot, int offset, uint32_t value)
{
    E0o *o = h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT && offset >= 0 && offset + 4 <= (int)ENTRY_STRIDE)
        put32(o->entries[slot] + offset, value);
}

void e0o_set_cells(void *h, const int32_t *v) { memcpy(((E0o *)h)->cell, v, 8u * sizeof(int32_t)); }
void e0o_get_cells(void *h, int32_t *out) { memcpy(out, ((E0o *)h)->cell, 8u * sizeof(int32_t)); }
void e0o_set_events(void *h, const int32_t *v) { memcpy(((E0o *)h)->events, v, sizeof(((E0o *)h)->events)); }
void e0o_get_events(void *h, int32_t *out) { memcpy(out, ((E0o *)h)->events, sizeof(((E0o *)h)->events)); }

/* The typed body of `row`: the loaded bytes, ZERO beyond (the stated native choice for the bytes the original reads past the
 * 294 byte allocation). */
int e0o_load_body(void *h, int row, int flag, const uint8_t *data, int len)
{
    E0o *o = h;
    if (row < 0 || row >= MAX_ROWS || len < 0 || len > (int)E0_BODY_CAPACITY) return 1;
    memset(o->body[row], 0, E0_BODY_CAPACITY);
    memcpy(o->body[row], data, (size_t)len);
    o->body_len[row] = len;
    o->body_flag[row] = flag;
    o->body_loaded[row] = 1;
    return 0;
}

void e0o_get_body(void *h, int row, uint8_t *out)
{
    E0o *o = h;
    memset(out, 0, E0_BODY_CAPACITY);
    if (row >= 0 && row < MAX_ROWS) memcpy(out, o->body[row], E0_BODY_CAPACITY);
}

void e0o_clear_log(void *h)
{
    E0o *o = h;
    o->nlog = 0;
    o->ncalls = 0;
    o->nnames = 0;
    o->bad_slot_calls = 0;
}

static int row_ok(E0o *o, int row)
{
    return row >= 0 && row < MAX_ROWS && o->body_loaded[row];
}

/* result: phase_after, initialized, completed */
int e0o_step(void *h, int row, uint32_t phase, uint32_t *result)
{
    E0o *o = h;
    E0Result r;
    int status;
    memset(&r, 0, sizeof r);
    o->why = "none";
    if (!row_ok(o, row)) {
        o->why = "no-body";
        return E0_ERR_ARGUMENT;
    }
    status = e0_step(&o->obj, o->body[row], (size_t)o->body_len[row], o->body_flag[row], (int16_t)row, phase, &o->world, &o->host, &r,
                     &o->why);
    result[0] = r.phase_after;
    result[1] = r.initialized;
    result[2] = r.completed;
    return status;
}

const char *e0o_why(void *h) { return ((E0o *)h)->why; }

/* out: hit, candidate, cursor */
int e0o_pointer(void *h, int row, int x, int y, int32_t *out)
{
    E0o *o = h;
    E0PointerResult r;
    int status;
    memset(&r, 0, sizeof r);
    r.candidate = -1;
    if (!row_ok(o, row)) return E0_ERR_ARGUMENT;
    status = e0_pointer_move(&o->obj, o->body[row], (size_t)o->body_len[row], x, y, &r);
    out[0] = r.hit;
    out[1] = r.candidate;
    out[2] = r.cursor;
    return status;
}

int e0o_click(void *h, int row, uint32_t row_phase, int32_t candidate, int32_t start_flag, uint32_t *new_phase)
{
    E0o *o = h;
    *new_phase = row_phase;
    if (!row_ok(o, row)) return E0_ERR_ARGUMENT;
    return e0_click(&o->obj, o->body[row], (size_t)o->body_len[row], row_phase, candidate, start_flag, &o->host, new_phase);
}

int e0o_invalidate(void *h) { E0o *o = h; return e0_invalidate(&o->obj, &o->host); }
int e0o_cleanup(void *h) { E0o *o = h; return e0_cleanup(&o->obj, &o->host); }
void e0o_scene_reset(void *h) { E0o *o = h; e0_scene_reset(&o->obj); }

int e0o_log_count(void *h) { return ((E0o *)h)->nlog; }
void e0o_log(void *h, int i, int32_t *out) { memcpy(out, ((E0o *)h)->log[i], 3u * sizeof(int32_t)); }
int e0o_call_count(void *h) { return ((E0o *)h)->ncalls; }
void e0o_call(void *h, int i, int32_t *out) { memcpy(out, ((E0o *)h)->calls[i], 3u * sizeof(int32_t)); }
int e0o_name_count(void *h) { return ((E0o *)h)->nnames; }
const char *e0o_name(void *h, int i) { return ((E0o *)h)->names[i]; }

/* The object image (E0_IMAGE_BYTES, original offsets) and the modelled-byte mask, straight from the kernel. */
void e0o_image(void *h, uint8_t *image, uint8_t *mask)
{
    memset(image, 0, E0_IMAGE_BYTES);
    memset(mask, 0, E0_IMAGE_BYTES);
    e0_object_pack(&((E0o *)h)->obj, image, mask);
}

/* process words and native-only state: round (0x5957b7), 0x5957b5, initialized */
void e0o_words(void *h, int32_t *out)
{
    E0o *o = h;
    out[0] = o->obj.round;
    out[1] = o->obj.word_5957b5;
    out[2] = o->obj.initialized;
    out[3] = 0;
}

void e0o_set_words(void *h, int32_t round, int32_t w5)
{
    E0o *o = h;
    o->obj.round = (int16_t)round;
    o->obj.word_5957b5 = (int16_t)w5;
}

/* The inverse of e0_object_pack for the fields E0Object models: forces the object into an arbitrary (possibly unreachable)
 * state for the fuzz scenarios. Only bytes the kernel's pack declares modelled are applied. Offsets follow the E0Object
 * comments of src/action_family_e0_runtime.h. */
void e0o_set_image(void *h, const uint8_t *p)
{
    E0Object *b = &((E0o *)h)->obj;
    uint8_t img[E0_IMAGE_BYTES], mask[E0_IMAGE_BYTES];
    memset(img, 0, sizeof img);
    memset(mask, 0, sizeof mask);
    e0_object_pack(b, img, mask);
#define M(off) (mask[(off)] != 0u)
#define U8(field, off) do { if (M(off)) (field) = p[off]; } while (0)
#define S16(field, off) do { if (M(off)) (field) = (int16_t)get16(p + (off)); } while (0)
#define S32(field, off) do { if (M(off)) (field) = (int32_t)get32(p + (off)); } while (0)
#define U32(field, off) do { if (M(off)) (field) = get32(p + (off)); } while (0)
    for (int i = 0; i < E0_MAX_KEYS; ++i) {
        for (int k = 0; k < 4; ++k) {
            S32(b->rect_a[i][k], 0x1c + 16 * i + 4 * k);
            S32(b->rect_b[i][k], 0x65c + 16 * i + 4 * k);
        }
        U8(b->lit[i], 0xc9c + i);
    }
    U8(b->tiles_visible, 0xd00);
    S16(b->code_len, 0xd01);
    U8(b->code_ordered, 0xd03);
    for (int i = 0; i < E0_MAX_CODE; ++i) {
        U8(b->code[i], 0xd04 + i);
        S16(b->player[i], 0xd4a + 2 * i);
        S16(b->scratch[i], 0xd86 + 2 * i);
        S16(b->record[i], 0xdc2 + 2 * i);
    }
    S16(b->rounds, 0xd22);
    U32(b->surface, 0xd24);
    S16(b->row, 0xd28);
    S16(b->hover, 0xd2a);
    S32(b->state, 0xd2c);
    S16(b->recorded, 0xd30);
    S16(b->typed, 0xd32);
    S16(b->slot, 0xd38);
    U8(b->exit_pending, 0xd3a);
    U8(b->waiting, 0xd3b);
    U8(b->blink, 0xd3c);
    U8(b->flag, 0xd3d);
    U8(b->active, 0xd3e);
    U8(b->exit_asked, 0xd3f);
    U32(b->blink_deadline, 0xd40);
    U32(b->show_deadline, 0xd44);
    S16(b->pad_d48, 0xd48);
    U8(b->solved, 0xdfe);
    U8(b->solved_sets, 0xdff);
    U32(b->wait_deadline, 0xe00);
    S16(b->set_count, 0xe06);
    S16(b->scene, 0xe08);
#undef M
#undef U8
#undef S16
#undef S32
#undef U32
}

/* The table image. Entry 17 +0x14 IS the cell 0x5d1a8f (0x5d1591 + 17 * 0x4a + 0x14); the world models that dword. */
void e0o_entries(void *h, uint8_t *out)
{
    E0o *o = h;
    memcpy(out, o->entries, sizeof(o->entries));
    put32(out + 17u * ENTRY_STRIDE + E_DIRTY, (uint32_t)o->world.entry17_active_5d1a8f);
}

/* render plan: valid, surface, count, then per blit kind, role, src[4], dst[4] (10 values), up to MAX_PLAN_BLITS blits */
int e0o_plan(void *h, int row, int32_t *out)
{
    E0o *o = h;
    static E0RenderPlan p;
    int status;
    int k = 0;
    memset(&p, 0, sizeof p);
    if (!row_ok(o, row)) return E0_ERR_ARGUMENT;
    status = e0_render_plan(&o->obj, o->body[row], (size_t)o->body_len[row], &o->host, &p);
    out[k++] = p.valid;
    out[k++] = (int32_t)p.surface;
    out[k++] = p.count;
    for (int i = 0; i < p.count && i < MAX_PLAN_BLITS && i < E0_MAX_BLITS; ++i) {
        out[k++] = p.blit[i].kind;
        out[k++] = p.blit[i].role;
        for (int j = 0; j < 4; ++j) out[k++] = p.blit[i].src[j];
        for (int j = 0; j < 4; ++j) out[k++] = p.blit[i].dst[j];
    }
    return status;
}

/* body validation of `len` bytes (zero padded to the capacity as the kernel expects) */
int e0o_validate(int flag, const uint8_t *body, int len)
{
    uint8_t buf[E0_BODY_CAPACITY];
    if (len < 0 || len > (int)E0_BODY_CAPACITY) return E0_ERR_BODY;
    memset(buf, 0, sizeof buf);
    memcpy(buf, body, (size_t)len);
    return e0_validate_body(flag, buf, (size_t)len, NULL);
}
