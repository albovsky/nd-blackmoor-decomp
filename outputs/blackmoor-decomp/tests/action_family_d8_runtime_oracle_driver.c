/* RT-34 oracle driver: exposes the native runtime-type-0xd8 kernel (src/action_family_d8_runtime.c) to
 * tests/action_family_d8_runtime_original_oracle.py through ctypes.
 *
 * The driver owns one D8Object and a SCRIPTED host. Every D8Host callback applies to a model of the generic Z
 * entry table (0x5d1591, stride 0x4a, 0x58 entries) the exact stores the original makes (0x4d39f9 / 0x4d3992 /
 * the inline entry stores of 0x48c1c0 / 0x48bc38) and to a model of the process cells the handler writes
 * (0x5bb1ca, the scene-change cells 0x5bb57b 0x5bb599 0x5bb595 0x5c39ff 0x5bb59b 0x5bb59f 0x5bb5a3, the engine
 * mode 0x583999, 0x5d1a8f, the event flag array at 0x585801). It exports the kernel's ordered D8_FX_* observer
 * log plus the host calls that have no observer effect (GetTickCount calls, the scene-change cell stores), so the
 * Python side can compare one ordered list with the list derived from Unicorn write/call hooks.
 *
 * Test code only: portable C11, no original bytes. */
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_d8_runtime.h"

#define ENTRY_STRIDE 0x4au
#define ENTRY_COUNT 0x58u
#define SLOT_FIRST 0x18
#define SLOT_LAST 0x3f
#define MAX_LOG 1024
#define MAX_NAMES 16
#define MAX_HANDLES 64
#define MAX_TICKS 64
#define EVENT_COUNT 128
#define OBJ_VALUES 32

/* effect kinds that are not D8Effect values (the Python side uses the same numbers) */
#define FX_TICKCALL 20
#define FX_CELL 21

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

typedef struct D8o {
    D8Object obj;
    D8Host host;
    uint8_t entries[ENTRY_COUNT][ENTRY_STRIDE];
    int32_t log[MAX_LOG][3];
    int nlog;
    char names[MAX_NAMES][64];
    char labels[MAX_NAMES][64];
    int nnames;
    uint32_t handles[MAX_HANDLES];
    int nhandles, ihandle;
    uint32_t text_surface[D8_TEXT_SURFACES];
    int32_t text_height[D8_TEXT_SURFACES];
    uint32_t ticks[MAX_TICKS];
    int nticks, iticks, tick_underrun;
    int32_t start_flag;
    int32_t cell0;  /* 0x5bb57b dword */
    int16_t cell1;  /* 0x5bb599 word */
    int16_t cell2;  /* 0x5bb595 word */
    int16_t cell3;  /* 0x5c39ff word */
    int32_t cell4;  /* 0x5bb59b dword */
    int32_t cell5;  /* 0x5bb59f dword */
    int32_t cell6;  /* 0x5bb5a3 dword */
    int32_t engine_mode;
    int32_t events[EVENT_COUNT];
    const char *why;
    int bad_slot_calls;
    int bad_event_calls;
} D8o;

static void put32(uint8_t *p, uint32_t v) { memcpy(p, &v, 4); }
static uint32_t get32(const uint8_t *p) { uint32_t v; memcpy(&v, p, 4); return v; }

static void logfx(D8o *o, int kind, int32_t a, int32_t b)
{
    if (o->nlog < MAX_LOG) {
        o->log[o->nlog][0] = kind;
        o->log[o->nlog][1] = a;
        o->log[o->nlog][2] = b;
        o->nlog++;
    }
}

static uint8_t *entry(D8o *o, int16_t slot)
{
    if (slot < 0 || (unsigned)slot >= ENTRY_COUNT) {
        o->bad_slot_calls++;
        return NULL;
    }
    return o->entries[slot];
}

static void observe(void *c, int effect, int32_t a, int32_t b)
{
    D8o *o = c;
    logfx(o, effect, a, b);
    /* 0x5d1a8f is the dirty word (+0x14) of generic Z entry 0x11: the entry table model owns it */
    if (effect == D8_FX_CLEAR_5D1A8F) put32(o->entries[0x11] + E_DIRTY, 0u);
}

static int h_alloc_slot(void *c, int16_t *slot)
{
    D8o *o = c;
    for (int i = SLOT_FIRST; i <= SLOT_LAST; ++i)
        if (get32(o->entries[i] + E_BUSY) == 0u) {
            *slot = (int16_t)i;
            return 0;
        }
    return 1; /* the original reaches the fatal path 0x52139c here */
}

static int h_register_slot(void *c, int16_t slot, uint32_t surface, const char *label)
{
    D8o *o = c;
    uint8_t *e = entry(o, slot);
    if (e == NULL) return 1;
    put32(e + E_TYPE, 10u);
    put32(e + E_CALLBACK, 0x48cc70u);
    put32(e + E_SURFACE, surface);
    put32(e + E_F0C, 0u);
    put32(e + E_F10, 0u);
    put32(e + E_DIRTY, 1u);
    put32(e + E_BUSY, 1u);
    e[E_WORD] = 0;
    e[E_WORD + 1] = 0;
    memcpy(e + E_LABEL, label, strlen(label) + 1u); /* the inline repnz scasb / rep movs copy */
    return 0;
}

static int h_load_surface(void *c, const char *name, const char *label, uint32_t *surface)
{
    D8o *o = c;
    if (o->nnames < MAX_NAMES) {
        strncpy(o->names[o->nnames], name, sizeof o->names[0] - 1u);
        o->names[o->nnames][sizeof o->names[0] - 1u] = '\0';
        strncpy(o->labels[o->nnames], label, sizeof o->labels[0] - 1u);
        o->labels[o->nnames][sizeof o->labels[0] - 1u] = '\0';
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

static int h_text_surface(void *c, int index, uint32_t *surface, int32_t *height)
{
    D8o *o = c;
    if (index < 0 || (unsigned)index >= D8_TEXT_SURFACES) return 1;
    *surface = o->text_surface[index];
    *height = o->text_height[index];
    return 0;
}

static uint32_t h_tick(void *c)
{
    D8o *o = c;
    uint32_t v;
    if (o->iticks < o->nticks) {
        v = o->ticks[o->iticks++];
    } else {
        o->tick_underrun++;
        v = o->nticks > 0 ? o->ticks[o->nticks - 1] : 0u;
    }
    logfx(o, FX_TICKCALL, (int32_t)v, 0);
    return v;
}

static int h_set_start_flag(void *c, int32_t value)
{
    ((D8o *)c)->start_flag = value;
    return 0;
}

static int h_scene_change(void *c, const D8SceneChange *change)
{
    D8o *o = c;
    o->cell0 = change->scene;
    logfx(o, FX_CELL, 0, o->cell0);
    o->cell1 = change->word[0];
    logfx(o, FX_CELL, 1, o->cell1);
    o->cell2 = change->word[1];
    logfx(o, FX_CELL, 2, o->cell2);
    o->cell3 = change->word[2];
    logfx(o, FX_CELL, 3, o->cell3);
    o->cell4 = change->dword[0];
    logfx(o, FX_CELL, 4, o->cell4);
    o->cell5 = change->dword[1];
    logfx(o, FX_CELL, 5, o->cell5);
    o->cell6 = change->dword[2];
    logfx(o, FX_CELL, 6, o->cell6);
    o->engine_mode = 4;
    return 0;
}

static int h_set_event_flag(void *c, int16_t index, int32_t value)
{
    D8o *o = c;
    if (index < 0 || index >= EVENT_COUNT) {
        o->bad_event_calls++;
        return 1;
    }
    o->events[index] = value;
    return 0;
}

void *d8o_new(void)
{
    D8o *o = calloc(1, sizeof *o);
    if (o == NULL) return NULL;
    d8_object_reset(&o->obj);
    o->host.context = o;
    o->host.alloc_slot = h_alloc_slot;
    o->host.register_slot = h_register_slot;
    o->host.load_surface = h_load_surface;
    o->host.set_slot_surface = h_set_slot_surface;
    o->host.release_surface = h_release_surface;
    o->host.release_slot = h_release_slot;
    o->host.mark_dirty = h_mark_dirty;
    o->host.text_surface = h_text_surface;
    o->host.tick = h_tick;
    o->host.set_start_flag = h_set_start_flag;
    o->host.scene_change = h_scene_change;
    o->host.set_event_flag = h_set_event_flag;
    o->host.observe = observe;
    o->engine_mode = 3;
    return o;
}

void d8o_free(void *h) { free(h); }

void d8o_set_handles(void *h, const uint32_t *hs, int n)
{
    D8o *o = h;
    o->nhandles = n > MAX_HANDLES ? MAX_HANDLES : n;
    memcpy(o->handles, hs, (size_t)o->nhandles * sizeof(uint32_t));
    o->ihandle = 0;
}

void d8o_set_text(void *h, int index, uint32_t surface, int32_t height)
{
    D8o *o = h;
    if (index >= 0 && (unsigned)index < D8_TEXT_SURFACES) {
        o->text_surface[index] = surface;
        o->text_height[index] = height;
    }
}

void d8o_set_ticks(void *h, const uint32_t *ts, int n)
{
    D8o *o = h;
    o->nticks = n > MAX_TICKS ? MAX_TICKS : n;
    memcpy(o->ticks, ts, (size_t)o->nticks * sizeof(uint32_t));
    o->iticks = 0;
    o->tick_underrun = 0;
}

int d8o_tick_underrun(void *h) { return ((D8o *)h)->tick_underrun; }
int d8o_ticks_used(void *h) { return ((D8o *)h)->iticks; }

void d8o_set_busy(void *h, int slot, int busy)
{
    D8o *o = h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT) put32(o->entries[slot] + E_BUSY, busy ? 1u : 0u);
}

void d8o_set_entry_u32(void *h, int slot, int offset, uint32_t value)
{
    D8o *o = h;
    if (slot >= 0 && (unsigned)slot < ENTRY_COUNT && offset >= 0 && offset + 4 <= (int)ENTRY_STRIDE)
        put32(o->entries[slot] + offset, value);
}

void d8o_set_cells(void *h, const int32_t *v)
{
    D8o *o = h;
    o->start_flag = v[0];
    o->cell0 = v[1];
    o->cell1 = (int16_t)v[2];
    o->cell2 = (int16_t)v[3];
    o->cell3 = (int16_t)v[4];
    o->cell4 = v[5];
    o->cell5 = v[6];
    o->cell6 = v[7];
    o->engine_mode = v[8];
    put32(o->entries[0x11] + E_DIRTY, (uint32_t)v[9]);
}

void d8o_get_cells(void *h, int32_t *v)
{
    D8o *o = h;
    v[0] = o->start_flag;
    v[1] = o->cell0;
    v[2] = o->cell1;
    v[3] = o->cell2;
    v[4] = o->cell3;
    v[5] = o->cell4;
    v[6] = o->cell5;
    v[7] = o->cell6;
    v[8] = o->engine_mode;
    v[9] = (int32_t)get32(o->entries[0x11] + E_DIRTY);
}

void d8o_set_event(void *h, int index, int32_t value)
{
    D8o *o = h;
    if (index >= 0 && index < EVENT_COUNT) o->events[index] = value;
}

void d8o_get_events(void *h, int32_t *out) { memcpy(out, ((D8o *)h)->events, sizeof(((D8o *)h)->events)); }

void d8o_clear_log(void *h)
{
    D8o *o = h;
    o->nlog = 0;
    o->nnames = 0;
    o->bad_slot_calls = 0;
    o->bad_event_calls = 0;
}

int d8o_log_count(void *h) { return ((D8o *)h)->nlog; }
void d8o_log(void *h, int i, int32_t *out) { memcpy(out, ((D8o *)h)->log[i], 3u * sizeof(int32_t)); }
int d8o_name_count(void *h) { return ((D8o *)h)->nnames; }
const char *d8o_name(void *h, int i) { return ((D8o *)h)->names[i]; }
const char *d8o_label(void *h, int i) { return ((D8o *)h)->labels[i]; }
int d8o_bad_slot_calls(void *h) { return ((D8o *)h)->bad_slot_calls; }
int d8o_bad_event_calls(void *h) { return ((D8o *)h)->bad_event_calls; }
const char *d8o_why(void *h) { return ((D8o *)h)->why != NULL ? ((D8o *)h)->why : "none"; }

/* object image: OBJ_VALUES values in the order the Python side reads the original */
void d8o_get_object(void *h, int32_t *out)
{
    const D8Object *b = &((D8o *)h)->obj;
    int k = 0;
    out[k++] = b->dir;
    out[k++] = b->visible;
    out[k++] = (int32_t)b->surface1;
    out[k++] = (int32_t)b->surface2;
    out[k++] = b->row;
    out[k++] = b->hot;
    out[k++] = b->slot_a;
    out[k++] = b->slot_b;
    for (int i = 0; i < 4; ++i) out[k++] = b->can_move[i];
    for (int i = 0; i < 4; ++i) out[k++] = b->inactive_rect[i];
    for (int i = 0; i < 4; ++i) out[k++] = b->down_rect[i];
    out[k++] = b->pressed;
    out[k++] = b->pos_41;
    out[k++] = b->pos_43;
    out[k++] = b->borrowed;
    out[k++] = b->active;
    out[k++] = b->exit_clicked;
    out[k++] = b->limit_48;
    out[k++] = b->limit_4a;
    out[k++] = b->limit_4c;
    out[k++] = b->limit_4e;
    out[k++] = (int32_t)b->tick;
    out[k++] = b->target_scene;
}

void d8o_set_object(void *h, const int32_t *in)
{
    D8Object *b = &((D8o *)h)->obj;
    int k = 0;
    b->dir = (uint8_t)in[k++];
    b->visible = (uint8_t)in[k++];
    b->surface1 = (uint32_t)in[k++];
    b->surface2 = (uint32_t)in[k++];
    b->row = (int16_t)in[k++];
    b->hot = (int16_t)in[k++];
    b->slot_a = (int16_t)in[k++];
    b->slot_b = (int16_t)in[k++];
    for (int i = 0; i < 4; ++i) b->can_move[i] = (uint8_t)in[k++];
    for (int i = 0; i < 4; ++i) b->inactive_rect[i] = (uint8_t)in[k++];
    for (int i = 0; i < 4; ++i) b->down_rect[i] = (uint8_t)in[k++];
    b->pressed = (uint8_t)in[k++];
    b->pos_41 = (int16_t)in[k++];
    b->pos_43 = (int16_t)in[k++];
    b->borrowed = (uint8_t)in[k++];
    b->active = (uint8_t)in[k++];
    b->exit_clicked = (uint8_t)in[k++];
    b->limit_48 = (int16_t)in[k++];
    b->limit_4a = (int16_t)in[k++];
    b->limit_4c = (int16_t)in[k++];
    b->limit_4e = (int16_t)in[k++];
    b->tick = (uint32_t)in[k++];
    b->target_scene = (int16_t)in[k++];
}

void d8o_entries(void *h, uint8_t *out) { memcpy(out, ((D8o *)h)->entries, sizeof(((D8o *)h)->entries)); }

/* One true-gate visit. result: phase_after, initialized, finished. */
int d8o_step(void *h, const uint8_t *record, size_t length, int row, uint32_t phase, size_t event_flag_count,
             uint32_t *result)
{
    D8o *o = h;
    D8Result r;
    int status;
    memset(&r, 0, sizeof r);
    o->why = "none";
    status = d8_step(&o->obj, record, length, (int16_t)row, phase, event_flag_count, &o->host, &r, &o->why);
    result[0] = r.phase_after;
    result[1] = r.initialized;
    result[2] = r.finished;
    return status;
}

int d8o_cleanup(void *h) { D8o *o = h; return d8_cleanup(&o->obj, &o->host); }
int d8o_dirty(void *h) { D8o *o = h; return d8_mark_dirty(&o->obj, &o->host); }

/* hit test: in = {item_583a29, flag_5b44f8, value_5d0377, value_571ad3, cursor_5b44f0}
 * out = {hit, cursor_written, cursor, flag_5b44f4, candidate, has_5d162d, value_5d162d, table_5d1631, flag_5d1639} */
int d8o_hit(void *h, const uint8_t *record, size_t length, int x, int y, const int32_t *in, int32_t *out)
{
    D8o *o = h;
    D8HitInput hi;
    D8HitOutput ho;
    int status;
    hi.item_583a29 = (int16_t)in[0];
    hi.flag_5b44f8 = in[1];
    hi.value_5d0377 = in[2];
    hi.value_571ad3 = in[3];
    hi.cursor_5b44f0 = in[4];
    status = d8_hit_test(&o->obj, record, length, (int16_t)x, (int16_t)y, &hi, &ho);
    out[0] = ho.hit;
    out[1] = ho.cursor_written;
    out[2] = ho.cursor_5b44f0;
    out[3] = ho.flag_5b44f4;
    out[4] = ho.candidate_5c39e5;
    out[5] = ho.has_5d162d;
    out[6] = ho.value_5d162d;
    out[7] = (int32_t)ho.table_5d1631;
    out[8] = ho.flag_5d1639;
    return status;
}

/* click: out = {phase_written, phase} */
int d8o_click(void *h, const uint8_t *record, size_t length, int32_t candidate, int32_t *out)
{
    D8o *o = h;
    D8ClickOutput co;
    int status = d8_click(&o->obj, record, length, candidate, &co);
    out[0] = co.phase_written;
    out[1] = (int32_t)co.phase;
    return status;
}

int d8o_press(void *h, uint32_t row_phase, int32_t candidate)
{
    D8o *o = h;
    return d8_press(&o->obj, row_phase, candidate, &o->host);
}

/* render plan: valid, count, then per blit (up to 6): kind, source, src[4], dst[4] = 10 values; labels via
 * d8o_plan_label */
static D8RenderPlan g_plan;

int d8o_plan(void *h, const uint8_t *record, size_t length, int32_t ox, int32_t oy, int32_t *out)
{
    D8o *o = h;
    D8View view;
    int status;
    view.origin_x = ox;
    view.origin_y = oy;
    status = d8_render_plan(&o->obj, record, length, &view, &g_plan);
    out[0] = g_plan.valid;
    out[1] = (int32_t)g_plan.count;
    for (size_t i = 0; i < D8_RENDER_MAX_BLITS; ++i) {
        const D8Blit *b = &g_plan.blit[i];
        int32_t *p = out + 2 + 10 * i;
        p[0] = (int32_t)b->kind;
        p[1] = (int32_t)b->source;
        for (int k = 0; k < 4; ++k) {
            p[2 + k] = b->src[k];
            p[6 + k] = b->dst[k];
        }
    }
    return status;
}

const char *d8o_plan_label(int i)
{
    if (i < 0 || (size_t)i >= g_plan.count || g_plan.blit[i].label == NULL) return "";
    return g_plan.blit[i].label;
}

/* kernel utilities that need no object */
int d8o_record_bytes(int count) { return (int)d8_record_bytes(count); }
int d8o_validate(const uint8_t *record, size_t length) { return d8_validate_record(record, length, NULL); }
