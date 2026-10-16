/* RT-23 oracle driver: exposes the native raw 0x3f kernel (src/action_family_3f_runtime.c) to
 * tests/action_family_3f_runtime_original_oracle.py through ctypes.
 *
 * The driver owns one conversation manager, one world, one object image and a SCRIPTED host: every
 * Convo3fHost callback appends an event line and a state snapshot to a log and then applies the
 * scripted effect the original external would have had on the modelled globals (key bytes, layout
 * sound names, surface slots, scene stack words). The Python side runs the unmodified x86 with hooks
 * that record and apply the SAME scripted effects, then compares the two logs.
 *
 * State exchange: a3f_store()/a3f_load() move manager + world fields to and from a flat byte blob.
 * The field list (name, byte size, full-only flag) is exported by a3f_layout(); the Python module
 * builds the identical blob from x86 memory and refuses to run when the two lists differ.
 * Test code only: portable C11, no original bytes. */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_3f_runtime.h"

#define EVENT_SLOTS 3000
#define PRESENCE_SLOTS 1803
#define MAX_LOG 512
#define LOG_TEXT 160
#define SCRIPT_LEN 64

typedef struct {
    int32_t playing_c[SCRIPT_LEN], playing_d[SCRIPT_LEN];
    int32_t n_c, n_d;
    uint8_t key_skip[SCRIPT_LEN], key_other[SCRIPT_LEN];
    int32_t n_keys;
    uint8_t names[CONVO3F_MAX_RESPONSES][CONVO3F_UI_SOUND_STRIDE];
    int32_t hotspot_after_layout;
    int16_t slots[8];
    int32_t n_slots;
    int16_t stack_marker, stack_scene, stack_w09, stack_w0b, stack_w0d, stack_pad;
    int32_t stack_d0f, stack_d13, stack_d17;
    int32_t fail_pop;
} A3fScript;

typedef struct {
    const char *name;
    void *ptr;
    size_t size;
    int full;
    int ext; /* per-field extractor for gathered bytes */
} FieldRef;

typedef struct A3fCase {
    Convo3fManager m;
    Convo3fWorld w;
    int32_t events[EVENT_SLOTS], presence[PRESENCE_SLOTS];
    uint8_t *arena;
    size_t arena_bytes;
    Convo3fObject obj;
    Convo3fHost host;
    ActionSoundBackend snd;
    A3fScript sc;
    int idx_c, idx_d, idx_key, idx_slot;
    FieldRef *refs;
    size_t nrefs;
    size_t light_bytes, full_bytes;
    char (*log)[LOG_TEXT];
    uint8_t *logsnap;
    int nlog;
    Convo3fStepResult r;
    const char *why;
    int status;
} A3fCase;

size_t a3f_script_size(void) { return sizeof(A3fScript); }

static void add_ref(A3fCase *c, size_t *cap, const char *name, void *ptr, size_t size, int full, int ext)
{
    if (c->nrefs == *cap) {
        *cap = *cap ? *cap * 2u : 512u;
        c->refs = realloc(c->refs, *cap * sizeof(FieldRef));
    }
    {
        char *copy = malloc(strlen(name) + 1u);
        memcpy(copy, name, strlen(name) + 1u);
        c->refs[c->nrefs].name = copy;
    }
    c->refs[c->nrefs].ptr = ptr;
    c->refs[c->nrefs].size = size;
    c->refs[c->nrefs].full = full;
    c->refs[c->nrefs].ext = ext;
    ++c->nrefs;
}

static void build_refs(A3fCase *c)
{
    size_t cap = 0;
    int i;
    char nm[48];
    Convo3fManager *m = &c->m;
    Convo3fWorld *w = &c->w;
#define R(n, p, s) add_ref(c, &cap, n, p, s, 0, 0)
    R("m.row", &m->row, 2);
    R("m.type", &m->type, 1);
    R("m.sub", &m->sub_state, 4);
    R("m.count", &m->response_count, 2);
    R("m.slot0", &m->textbox_slot[0], 2);
    R("m.slot1", &m->textbox_slot[1], 2);
    R("m.cel", &m->cel_thread, 4);
    R("m.dispname", m->display_name, 33);
    for (i = 0; i < CONVO3F_MAX_RESPONSES; ++i) {
        Convo3fResponse *r = &m->responses[i];
#define RN(suffix, p, s)                                      \
    do {                                                      \
        snprintf(nm, sizeof nm, "r%02d.%s", i, suffix);       \
        add_ref(c, &cap, nm, p, s, 0, 0);                     \
    } while (0)
        RN("name", r->name, 33);
        RN("scene", &r->scene, 2);
        RN("w23", &r->word_23, 2);
        RN("w25", &r->word_25, 2);
        RN("w27", &r->word_27, 2);
        RN("d29", &r->dword_29, 4);
        RN("d2d", &r->dword_2d, 4);
        RN("d31", &r->dword_31, 4);
        RN("evi", &r->event_index, 2);
        RN("evv", &r->event_value, 1);
        RN("w38", &r->word_38, 2);
    }
    R("w.held", &w->held_item, 2);
    R("w.mode", &w->mode_583999, 4);
    R("w.f9", &w->flag_5c39e9, 4);
    R("w.fd", &w->flag_5c39ed, 4);
    R("w.e204", &w->engine_583204, 4);
    R("w.c106", &w->cursor_583106, 4);
    R("w.l788", &w->limit_5b3788, 4);
    R("w.hx", &w->hotspot_x_5b378c, 2);
    R("w.hy", &w->hotspot_y_5b378e, 2);
    R("w.capt", &w->captions_5bb202, 4);
    R("w.fast", &w->fast_convo_58322a, 1);
    R("w.skip", &w->skip_key_58321d, 1);
    R("w.key", &w->key_58321e, 1);
    R("w.exit", &w->exit_58322b, 1);
    R("w.sel", &w->selected_570374, 2);
    R("w.chosen", w->chosen_5839b1, 4 * CONVO3F_MAX_RESPONSES);
    R("w.start", &w->start_5bb1ca, 4);
    R("w.x57b", &w->xfer_5bb57b, 4);
    R("w.x599", &w->xfer_5bb599, 2);
    R("w.x595", &w->xfer_5bb595, 2);
    R("w.x9ff", &w->xfer_5c39ff, 2);
    R("w.x59b", &w->xfer_5bb59b, 4);
    R("w.x59f", &w->xfer_5bb59f, 4);
    R("w.x5a3", &w->xfer_5bb5a3, 4);
    R("w.f1c4", &w->flag_5bb1c4, 2); /* the original stores a WORD */
    R("w.r1c8", &w->redraw_5831c8, 4);
    R("w.r1c6", &w->redraw_5831c6, 2);
    R("w.u191d", &w->ui_5d191d, 4);
    R("w.u15da", &w->ui_5b15da, 4);
    R("w.u15c8", &w->ui_5b15c8, 4);
    R("w.u15d6", &w->ui_5b15d6, 4);
    R("w.u8e", &w->ui_5b0a8e, 2);
    R("w.u90", &w->ui_5b0a90, 2);
    R("w.u7c", &w->ui_5b0a7c, 2);
    R("w.u74", &w->ui_5b0a74, 2);
    R("w.u76", &w->ui_5b0a76, 2);
    R("w.u1e", &w->ui_5b0a1e, 4);
    R("w.u16", &w->ui_5b0a16, 4);
    R("w.u1436", w->ui_5b1436, 10);
    c->light_bytes = 0;
    for (i = 0; i < (int)c->nrefs; ++i) {
        c->light_bytes += c->refs[i].size;
    }
    for (i = 0; i < CONVO3F_MAX_RESPONSES; ++i) {
        snprintf(nm, sizeof nm, "r%02d.text", i);
        add_ref(c, &cap, nm, m->responses[i].text, CONVO3F_TEXT_BYTES, 1, 0);
    }
    add_ref(c, &cap, "w.uinames", w->ui_sound_names, sizeof w->ui_sound_names, 1, 0);
    add_ref(c, &cap, "w.events", c->events, sizeof c->events, 1, 0);
    add_ref(c, &cap, "w.presence", c->presence, sizeof c->presence, 1, 0);
    c->full_bytes = 0;
    for (i = 0; i < (int)c->nrefs; ++i) {
        c->full_bytes += c->refs[i].size;
    }
#undef R
#undef RN
}

size_t a3f_layout(char *buf, size_t n)
{
    A3fCase *c = calloc(1, sizeof *c);
    size_t used = 0, i;
    build_refs(c);
    for (i = 0; i < c->nrefs; ++i) {
        int k = snprintf(buf + used, used < n ? n - used : 0, "%s %zu %d\n", c->refs[i].name,
                         c->refs[i].size, c->refs[i].full);
        used += (size_t)k;
    }
    for (i = 0; i < c->nrefs; ++i) {
        free((void *)c->refs[i].name);
    }
    free(c->refs);
    free(c);
    return used;
}

size_t a3f_snapshot_size(A3fCase *c, int full) { return full ? c->full_bytes : c->light_bytes; }

void a3f_store(A3fCase *c, uint8_t *out, int full)
{
    size_t i, pos = 0;
    for (i = 0; i < c->nrefs; ++i) {
        if (c->refs[i].full && !full) {
            continue;
        }
        memcpy(out + pos, c->refs[i].ptr, c->refs[i].size);
        pos += c->refs[i].size;
    }
}

void a3f_load(A3fCase *c, const uint8_t *in)
{
    size_t i, pos = 0;
    for (i = 0; i < c->nrefs; ++i) {
        if (c->refs[i].size == 2 && c->refs[i].ptr == &c->w.flag_5bb1c4) {
            c->w.flag_5bb1c4 = 0; /* a word store: the upper half is not modelled */
        }
        memcpy(c->refs[i].ptr, in + pos, c->refs[i].size);
        pos += c->refs[i].size;
    }
}

/* ---- scripted host ---- */
static void record(A3fCase *c, const char *fmt, ...)
{
    va_list ap;
    if (c->nlog >= MAX_LOG) {
        return;
    }
    va_start(ap, fmt);
    vsnprintf(c->log[c->nlog], LOG_TEXT, fmt, ap);
    va_end(ap);
    a3f_store(c, c->logsnap + (size_t)c->nlog * c->light_bytes, 0);
    ++c->nlog;
}

static ActionSoundBackendStatus b_load(void *x, const ActionSoundAudioCommand *m)
{
    record(x, "snd_load %s ch=%u ctl=%u p1=%d p2=%d mode=%u", m->asset_stem, m->channel,
           (unsigned)m->control_word, m->first_percent, m->second_percent, m->mode);
    return ACTION_SOUND_BACKEND_OK;
}
static ActionSoundBackendStatus b_play(void *x, uint16_t ch)
{
    record(x, "snd_play %u", ch);
    return ACTION_SOUND_BACKEND_OK;
}
static ActionSoundBackendStatus b_playing(void *x, uint16_t ch, int *playing)
{
    A3fCase *c = x;
    int v = 0;
    if (ch == 0x0c) {
        v = c->idx_c < c->sc.n_c ? c->sc.playing_c[c->idx_c] : 0;
        ++c->idx_c;
    } else if (ch == 0x0d) {
        v = c->idx_d < c->sc.n_d ? c->sc.playing_d[c->idx_d] : 0;
        ++c->idx_d;
    }
    record(x, "snd_playing %u -> %d", ch, v);
    *playing = v;
    return ACTION_SOUND_BACKEND_OK;
}
static ActionSoundBackendStatus b_unload(void *x, uint16_t ch)
{
    record(x, "snd_unload %u", ch);
    return ACTION_SOUND_BACKEND_OK;
}
static int h_view(void *x, int which) { record(x, "view %d", which); return 0; }
static int h_mode(void *x, int32_t v) { record(x, "engine_mode %d", (int)v); return 0; }
static int h_aux(void *x, int32_t v) { record(x, "engine_aux %d", (int)v); return 0; }
static int h_cursor(void *x, int32_t a, int32_t b) { record(x, "cursor %d %d", (int)a, (int)b); return 0; }
static int h_add(void *x, int16_t i, int f) { record(x, "inv_add %d %d", i, f); return 0; }
static int h_rm(void *x, int16_t i) { record(x, "inv_remove %d", i); return 0; }
static int h_acquire(void *x, const char *name, int16_t a, int16_t b, int16_t *slot)
{
    A3fCase *c = x;
    const int16_t s = c->idx_slot < c->sc.n_slots ? c->sc.slots[c->idx_slot] : 0;
    ++c->idx_slot;
    *slot = s; /* the original's 0x4c948f result is stored before 0x4c2898 runs */
    record(x, "surface %s %d %d -> %d", name, a, b, s);
    return 0;
}
static int h_release(void *x, int16_t s) { record(x, "surf_release %d", s); return 0; }
static int h_layout(void *x, const Convo3fLayoutRequest *q, Convo3fWorld *w)
{
    A3fCase *c = x;
    int i;
    record(x, "layout row=%d count=%d slots=%d,%d", (int)q->row, q->response_count, q->slot_normal,
           q->slot_hilite);
    for (i = 0; i < CONVO3F_MAX_RESPONSES; ++i) {
        memcpy(w->ui_sound_names[i], c->sc.names[i], CONVO3F_UI_SOUND_STRIDE);
    }
    w->ui_5b15da = c->sc.hotspot_after_layout;
    return 0;
}
static int h_refresh(void *x, int16_t s) { record(x, "refresh %d", s); return 0; }
static int h_keys(void *x, uint8_t *skip, uint8_t *other)
{
    A3fCase *c = x;
    record(x, "keys");
    *skip = c->idx_key < c->sc.n_keys ? c->sc.key_skip[c->idx_key] : 0;
    *other = c->idx_key < c->sc.n_keys ? c->sc.key_other[c->idx_key] : 0;
    ++c->idx_key;
    return 0;
}
static int h_pop(void *x, Convo3fWorld *w)
{
    A3fCase *c = x;
    record(x, "scene_stack_pop");
    if (c->sc.fail_pop || c->sc.stack_marker == 0x270f) {
        return 1;
    }
    /* 0x42e493 exactly as read from the original (see action_family_3f_runtime.h) */
    w->xfer_5bb57b = c->sc.stack_scene;
    w->xfer_5bb599 = c->sc.stack_w09;
    w->xfer_5bb595 = c->sc.stack_w0b;
    w->xfer_5bb59b = c->sc.stack_d0f;
    w->xfer_5bb59f = c->sc.stack_d13;
    w->xfer_5bb5a3 = c->sc.stack_d17;
    w->xfer_5c39ff = 1;
    w->start_5bb1ca = c->sc.stack_w0d != 1;
    w->mode_583999 = 4;
    return 0;
}
static int h_uihook(void *x, int32_t v) { record(x, "ui_hook %d", (int)v); return 0; }
static int h_restore(void *x) { record(x, "engine_restore"); return 0; }

A3fCase *a3f_new(const uint8_t *image, size_t bytes, uint32_t handle_base, const A3fScript *script)
{
    A3fCase *c = calloc(1, sizeof *c);
    c->arena = malloc(bytes);
    memcpy(c->arena, image, bytes);
    c->arena_bytes = bytes;
    c->obj.arena = c->arena;
    c->obj.arena_bytes = bytes;
    c->obj.handle_base = handle_base;
    c->sc = *script;
    convo3f_manager_reset(&c->m);
    c->w.events = c->events;
    c->w.event_count = EVENT_SLOTS;
    c->w.presence = c->presence;
    c->w.presence_count = PRESENCE_SLOTS;
    build_refs(c);
    c->log = calloc(MAX_LOG, LOG_TEXT);
    c->logsnap = calloc(MAX_LOG, c->light_bytes);
    c->snd.context = c;
    c->snd.load_sound = b_load;
    c->snd.play_sound = b_play;
    c->snd.is_playing = b_playing;
    c->snd.unload_sound = b_unload;
    c->host.context = c;
    c->host.sound = &c->snd;
    c->host.release_engine_view = h_view;
    c->host.engine_mode = h_mode;
    c->host.engine_aux = h_aux;
    c->host.cursor_hotspot = h_cursor;
    c->host.inventory_add = h_add;
    c->host.inventory_remove = h_rm;
    c->host.acquire_surface = h_acquire;
    c->host.release_surface = h_release;
    c->host.layout_text_box = h_layout;
    c->host.refresh_hotspot_surface = h_refresh;
    c->host.poll_keys = h_keys;
    c->host.scene_stack_pop = h_pop;
    c->host.release_ui_hook = h_uihook;
    c->host.engine_restore = h_restore;
    return c;
}

void a3f_free(A3fCase *c)
{
    size_t i;
    for (i = 0; i < c->nrefs; ++i) {
        free((void *)c->refs[i].name);
    }
    free(c->refs);
    free(c->log);
    free(c->logsnap);
    free(c->arena);
    free(c);
}

void a3f_clear_log(A3fCase *c) { c->nlog = 0; }

int a3f_visit(A3fCase *c, int32_t row, uint32_t phase)
{
    c->why = "none";
    c->status = convo3f_step(&c->m, &c->obj, row, phase, &c->w, &c->host, &c->r, &c->why);
    return c->status;
}

const char *a3f_why(A3fCase *c) { return c->why; }
int a3f_log_count(A3fCase *c) { return c->nlog; }
const char *a3f_log_text(A3fCase *c, int i) { return c->log[i]; }
void a3f_log_snapshot(A3fCase *c, int i, uint8_t *out)
{
    memcpy(out, c->logsnap + (size_t)i * c->light_bytes, c->light_bytes);
}
void a3f_result(A3fCase *c, uint32_t *out)
{
    out[0] = c->r.phase_after;
    out[1] = c->r.ran;
    out[2] = c->r.started;
    out[3] = c->r.finished;
    out[4] = c->r.scene_change;
    out[5] = c->r.object_released;
    out[6] = c->r.skipped_optional;
}
void a3f_arena(A3fCase *c, uint8_t *out) { memcpy(out, c->arena, c->arena_bytes); }
void a3f_set_chosen(A3fCase *c, int i, int32_t v) { c->w.chosen_5839b1[i] = v; }
void a3f_set_event(A3fCase *c, int i, int32_t v) { c->events[i] = v; }
void a3f_set_presence(A3fCase *c, int i, int32_t v) { c->presence[i] = v; }
