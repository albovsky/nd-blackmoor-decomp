/* RT-25 oracle driver: exposes the native raw 0x3e cel-video arm (src/action_family_3f_runtime.c,
 * convo3f_step_type / convo3f_cel_reader_iteration / convo3f_cel_render) to
 * tests/action_family_3e_runtime_original_oracle.py through ctypes.
 *
 * Same design as tests/action_family_3f_runtime_oracle_driver.c: one conversation manager, one world,
 * one object image and a SCRIPTED host. Every Convo3fHost callback appends an event line plus a state
 * snapshot to a log and then applies the scripted effect the original external would have had. The
 * Python side runs the unmodified x86 with hooks that record and apply the SAME scripted effects and
 * compares both logs.
 *
 * Scripted cel host (the stand-ins' contract, shared by both sides, never an original decision):
 *   header block   the CIFTREE file image handed to cel_load_header (a3e_set_block), or NULL
 *   tree index     directory index per layer name (script.tree_name/tree_idx), -1 otherwise
 *   tree info      kind/transparency bytes per directory index
 *   layer decode   a deterministic function of (tree index, frame, layer) fills the header object;
 *                  frame/layer are derived from the name pointer's offset inside the block
 *   sound sync     is-playing and raw position scripts of channel 0x0c, bytes per frame (+0x176); the
 *                  adapter reproduces 0x4f6ef4's checks and ftol((float)raw / (float)bpf) in 53-bit
 *                  precision (x87 control word 0x27f), the kernel applies the monotonic clamp
 *
 * State exchange: a3e_store()/a3e_load() move manager + world + cel fields to and from a flat byte blob.
 * The field list (name, byte size, full-only flag) is exported by a3e_layout(); the Python module builds
 * the identical blob from x86 memory and refuses to run when the two lists differ.
 * Test code only: portable C11, no original bytes. */
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "action_family_3f_runtime.h"

#define EVENT_SLOTS 3000
#define PRESENCE_SLOTS 1803
#define MAX_LOG 512
#define LOG_TEXT 192
#define SCRIPT_LEN 512
#define TREES 64

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
    /* cel host */
    int32_t raw[SCRIPT_LEN];
    int32_t n_raw;
    int32_t load_status;    /* 0: sound resource found, else NO_RESOURCE */
    int32_t bytes_per_frame;/* channel state +0x176 */
    int32_t fail_sync_init; /* 0x4f6cdc returns 0 */
    int32_t fail_header;    /* 0x418e52 returns NULL */
    uint8_t kind[TREES], transp[TREES];
    uint8_t tree_name[2][33];
    int16_t tree_idx[2];
    int16_t n_tree;
} A3eScript;

typedef struct {
    const char *name;
    void *ptr;
    size_t size;
    int full;
    int ext; /* 0 plain memcpy, else a gathered/derived field */
} FieldRef;

typedef struct A3eCase {
    Convo3fManager m;
    Convo3fWorld w;
    int32_t events[EVENT_SLOTS], presence[PRESENCE_SLOTS];
    uint8_t *arena;
    size_t arena_bytes;
    Convo3fObject obj;
    Convo3fHost host;
    ActionSoundBackend snd;
    A3eScript sc;
    int idx_c, idx_d, idx_key, idx_slot, idx_raw;
    FieldRef *refs;
    size_t nrefs;
    size_t light_bytes, full_bytes;
    char (*log)[LOG_TEXT];
    uint8_t *logsnap;
    int nlog;
    Convo3fStepResult r;
    const char *why;
    int status;
    uint8_t *blk;
    size_t blk_bytes;
    int ran;
    Convo3fRenderPlan plan;
} A3eCase;

enum { EXT_BLK = 1, EXT_FRAMES, EXT_SURF, EXT_HDR, EXT_BLKSZ };
#define HDR_REC 34u /* key(2) + src(16) + dst(16) */

size_t a3e_script_size(void) { return sizeof(A3eScript); }

static void add_ref(A3eCase *c, size_t *cap, const char *name, void *ptr, size_t size, int full, int ext)
{
    char *copy;
    if (c->nrefs == *cap) {
        *cap = *cap ? *cap * 2u : 512u;
        c->refs = realloc(c->refs, *cap * sizeof(FieldRef));
    }
    copy = malloc(strlen(name) + 1u);
    memcpy(copy, name, strlen(name) + 1u);
    c->refs[c->nrefs].name = copy;
    c->refs[c->nrefs].ptr = ptr;
    c->refs[c->nrefs].size = size;
    c->refs[c->nrefs].full = full;
    c->refs[c->nrefs].ext = ext;
    ++c->nrefs;
}

static void build_refs(A3eCase *c)
{
    size_t cap = 0;
    int i;
    char nm[48];
    Convo3fManager *m = &c->m;
    Convo3fWorld *w = &c->w;
    Convo3fCel *cl = &m->cel;
#define R(n, p, s) add_ref(c, &cap, n, p, s, 0, 0)
#define RE(n, s, e) add_ref(c, &cap, n, NULL, s, 0, e)
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
    /* cel arm world inputs */
    R("w.stall", &w->stall_limit_5b028e, 2);
    R("w.vx", &w->view_x_583186, 4);
    R("w.vy", &w->view_y_58318a, 4);
    /* cel manager fields (offsets of the original manager in the Python mapping) */
    R("c.loaded", &cl->loaded, 2);
    R("c.slot", &cl->slot, 2);
    R("c.next", &cl->next, 2);
    R("c.forced", &cl->forced, 2);
    R("c.cap", &cl->capacity, 2);
    R("c.frame", &cl->frame, 2);
    R("c.syncp", &cl->sync_param, 4);
    R("c.first", &cl->first, 2);
    R("c.last", &cl->last, 2);
    R("c.steptab", cl->step_table, 4);
    R("c.sndoff", &cl->sound_offset, 4);
    R("c.drawn", &cl->drawn, 2);
    R("c.target", &cl->target, 2);
    R("c.final", &cl->final_seen, 2);
    R("c.i786", &cl->index_786, 2);
    R("c.stall", &cl->stall, 2);
    R("c.relax", &cl->relax, 2);
    R("c.boost", &cl->boost, 2);
    R("c.layers", &cl->layer_count, 2);
    R("c.tree", cl->layer_tree, 4);
    R("c.header", cl->header, CONVO3F_CEL_HEADER_BYTES);
    RE("c.blk", 4, EXT_BLK);
    RE("c.blksz", 4, EXT_BLKSZ);
    R("c.syncn", &cl->sync_count, 4);
    R("c.synclast", &cl->sync_last, 4);
    R("c.saved_src", cl->saved_src, sizeof cl->saved_src);
    R("c.saved_dst", cl->saved_dst, sizeof cl->saved_dst);
    RE("c.sf", 2 * CONVO3F_CEL_SLOTS, EXT_FRAMES);
    RE("c.surf", 4 * CONVO3F_CEL_SLOTS * CONVO3F_CEL_SLOT_LAYERS, EXT_SURF);
    c->light_bytes = 0;
    for (i = 0; i < (int)c->nrefs; ++i) {
        c->light_bytes += c->refs[i].size;
    }
    /* full-only fields: compared at the end of every step */
    add_ref(c, &cap, "c.lock", &cl->lock, 4, 1, 0);
    add_ref(c, &cap, "c.hdrdata", NULL, HDR_REC * CONVO3F_CEL_SLOTS * CONVO3F_CEL_SLOT_LAYERS, 1, EXT_HDR);
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
#undef RE
#undef RN
}

size_t a3e_layout(char *buf, size_t n)
{
    A3eCase *c = calloc(1, sizeof *c);
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

size_t a3e_snapshot_size(A3eCase *c, int full) { return full ? c->full_bytes : c->light_bytes; }

static void ext_store(A3eCase *c, int ext, uint8_t *out)
{
    int s, l;
    Convo3fCel *cl = &c->m.cel;
    switch (ext) {
    case EXT_BLK: {
        uint32_t v = cl->block != NULL ? 1u : 0u;
        memcpy(out, &v, 4);
        break;
    }
    case EXT_BLKSZ: {
        uint32_t v = (uint32_t)cl->block_bytes;
        memcpy(out, &v, 4);
        break;
    }
    case EXT_FRAMES:
        for (s = 0; s < CONVO3F_CEL_SLOTS; ++s) {
            memcpy(out + 2 * s, &cl->slots[s].frame, 2);
        }
        break;
    case EXT_SURF:
        for (s = 0; s < CONVO3F_CEL_SLOTS; ++s) {
            for (l = 0; l < CONVO3F_CEL_SLOT_LAYERS; ++l) {
                memcpy(out + 4 * (s * CONVO3F_CEL_SLOT_LAYERS + l), &cl->slots[s].layer[l].surface, 4);
            }
        }
        break;
    case EXT_HDR:
        for (s = 0; s < CONVO3F_CEL_SLOTS; ++s) {
            for (l = 0; l < CONVO3F_CEL_SLOT_LAYERS; ++l) {
                const Convo3fCelLayer *L = &cl->slots[s].layer[l];
                uint8_t *p = out + HDR_REC * (size_t)(s * CONVO3F_CEL_SLOT_LAYERS + l);
                memcpy(p, &L->key_2f, 2);
                memcpy(p + 2, L->src, 16);
                memcpy(p + 18, L->dst, 16);
            }
        }
        break;
    default:
        break;
    }
}

static void ext_load(A3eCase *c, int ext, const uint8_t *in)
{
    int s, l;
    Convo3fCel *cl = &c->m.cel;
    switch (ext) {
    case EXT_BLK: {
        uint32_t v;
        memcpy(&v, in, 4);
        cl->block = v != 0u ? c->blk : NULL;
        break;
    }
    case EXT_BLKSZ: {
        uint32_t v;
        memcpy(&v, in, 4);
        cl->block_bytes = v;
        break;
    }
    case EXT_FRAMES:
        for (s = 0; s < CONVO3F_CEL_SLOTS; ++s) {
            memcpy(&cl->slots[s].frame, in + 2 * s, 2);
        }
        break;
    case EXT_SURF:
        for (s = 0; s < CONVO3F_CEL_SLOTS; ++s) {
            for (l = 0; l < CONVO3F_CEL_SLOT_LAYERS; ++l) {
                uint32_t v;
                memcpy(&v, in + 4 * (s * CONVO3F_CEL_SLOT_LAYERS + l), 4);
                cl->slots[s].layer[l].surface = v;
                cl->slots[s].layer[l].loaded = v != 0u ? 1u : 0u;
            }
        }
        break;
    case EXT_HDR:
        for (s = 0; s < CONVO3F_CEL_SLOTS; ++s) {
            for (l = 0; l < CONVO3F_CEL_SLOT_LAYERS; ++l) {
                Convo3fCelLayer *L = &cl->slots[s].layer[l];
                const uint8_t *p = in + HDR_REC * (size_t)(s * CONVO3F_CEL_SLOT_LAYERS + l);
                memcpy(&L->key_2f, p, 2);
                memcpy(L->src, p + 2, 16);
                memcpy(L->dst, p + 18, 16);
            }
        }
        break;
    default:
        break;
    }
}

void a3e_store(A3eCase *c, uint8_t *out, int full)
{
    size_t i, pos = 0;
    for (i = 0; i < c->nrefs; ++i) {
        if (c->refs[i].full && !full) {
            continue;
        }
        if (c->refs[i].ext != 0) {
            ext_store(c, c->refs[i].ext, out + pos);
        } else {
            memcpy(out + pos, c->refs[i].ptr, c->refs[i].size);
        }
        pos += c->refs[i].size;
    }
}

void a3e_load(A3eCase *c, const uint8_t *in)
{
    size_t i, pos = 0;
    for (i = 0; i < c->nrefs; ++i) {
        if (c->refs[i].ext != 0) {
            ext_load(c, c->refs[i].ext, in + pos);
        } else {
            if (c->refs[i].size == 2 && c->refs[i].ptr == &c->w.flag_5bb1c4) {
                c->w.flag_5bb1c4 = 0; /* a word store: the upper half is not modelled */
            }
            memcpy(c->refs[i].ptr, in + pos, c->refs[i].size);
        }
        pos += c->refs[i].size;
    }
}

/* ---- scripted host ---- */
static void record(A3eCase *c, const char *fmt, ...)
{
    va_list ap;
    if (c->nlog >= MAX_LOG) {
        return;
    }
    va_start(ap, fmt);
    vsnprintf(c->log[c->nlog], LOG_TEXT, fmt, ap);
    va_end(ap);
    a3e_store(c, c->logsnap + (size_t)c->nlog * c->light_bytes, 0);
    ++c->nlog;
}

static ActionSoundBackendStatus b_load(void *x, const ActionSoundAudioCommand *m)
{
    A3eCase *c = x;
    record(x, "snd_load %s ch=%u ctl=%u p1=%d p2=%d mode=%u", m->asset_stem, m->channel,
           (unsigned)m->control_word, m->first_percent, m->second_percent, m->mode);
    return c->sc.load_status != 0 ? ACTION_SOUND_BACKEND_NO_RESOURCE : ACTION_SOUND_BACKEND_OK;
}
static ActionSoundBackendStatus b_play(void *x, uint16_t ch)
{
    record(x, "snd_play %u", ch);
    return ACTION_SOUND_BACKEND_OK;
}
static ActionSoundBackendStatus b_playing(void *x, uint16_t ch, int *playing)
{
    A3eCase *c = x;
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
    A3eCase *c = x;
    const int16_t s = c->idx_slot < c->sc.n_slots ? c->sc.slots[c->idx_slot] : 0;
    ++c->idx_slot;
    *slot = s; /* the original's 0x4c948f result is stored before 0x4c2898 runs */
    record(x, "surface %s %d %d -> %d", name, a, b, s);
    return 0;
}
static int h_release(void *x, int16_t s) { record(x, "surf_release %d", s); return 0; }
static int h_layout(void *x, const Convo3fLayoutRequest *q, Convo3fWorld *w)
{
    A3eCase *c = x;
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
    A3eCase *c = x;
    record(x, "keys");
    *skip = c->idx_key < c->sc.n_keys ? c->sc.key_skip[c->idx_key] : 0;
    *other = c->idx_key < c->sc.n_keys ? c->sc.key_other[c->idx_key] : 0;
    ++c->idx_key;
    return 0;
}
static int h_pop(void *x, Convo3fWorld *w)
{
    A3eCase *c = x;
    record(x, "scene_stack_pop");
    if (c->sc.fail_pop || c->sc.stack_marker == 0x270f) {
        return 1;
    }
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

/* ---- cel host ---- */
static int h_cel_header(void *x, const uint8_t *name, const uint8_t **block, size_t *size)
{
    A3eCase *c = x;
    record(x, "cel_header %s", (const char *)name);
    if (c->sc.fail_header || c->blk == NULL) {
        *block = NULL;
        *size = 0;
        return 0;
    }
    *block = c->blk;
    *size = c->blk_bytes;
    return 0;
}
static int h_cel_tree(void *x, const uint8_t *name, int16_t *index)
{
    A3eCase *c = x;
    int i;
    int16_t found = -1;
    for (i = 0; i < c->sc.n_tree && i < 2; ++i) {
        if (strcmp((const char *)name, (const char *)c->sc.tree_name[i]) == 0) {
            found = c->sc.tree_idx[i];
            break;
        }
    }
    record(x, "cel_tree %s -> %d", (const char *)name, (int)found);
    *index = found; /* the original stores the result after the call returns */
    return 0;
}
static int h_cel_info(void *x, int16_t index, uint8_t *kind, uint8_t *transp)
{
    A3eCase *c = x;
    if (index < 0 || index >= TREES) {
        return 1;
    }
    *kind = c->sc.kind[index];
    *transp = c->sc.transp[index];
    return 0;
}
static int h_cel_load(void *x, int16_t tree, const uint8_t *name, Convo3fCelLayer *L)
{
    A3eCase *c = x;
    size_t off = (size_t)(name - c->blk) - CONVO3F_CEL_HEADER_BYTES;
    int frame = (int)(off / CONVO3F_CEL_FRAME_STRIDE);
    int layer = (int)((off % CONVO3F_CEL_FRAME_STRIDE) / 0x21u);
    record(x, "cel_load tree=%d name=%s", (int)tree, (const char *)name);
    /* decode function shared with the Python side (decode_layer) */
    L->loaded = 1u;
    L->surface = 0x10000u + (uint32_t)tree * 0x400u + (uint32_t)frame * 4u + (uint32_t)layer + 1u;
    L->key_2f = (int16_t)(uint16_t)(frame * 517 + layer * 91 + tree * 13 - 4000);
    L->src[0] = frame;
    L->src[1] = layer * 2;
    L->src[2] = frame + 16 + layer;
    L->src[3] = 8 + layer + tree % 5;
    L->dst[0] = frame * 3 + layer - 20;
    L->dst[1] = 2 * layer + tree;
    L->dst[2] = frame * 3 + layer + 40;
    L->dst[3] = 2 * layer + tree + 30;
    return 0;
}
static int h_cel_free(void *x, int16_t slot, int layer, uint32_t surface)
{
    record(x, "cel_free %d %d %u", (int)slot, layer, (unsigned)surface);
    return 0;
}
static int h_cel_release(void *x) { record(x, "cel_release_header"); return 0; }
static int h_rd_create(void *x) { record(x, "reader_create"); return 0; }
static int h_rd_resume(void *x) { record(x, "reader_resume"); return 0; }
static int h_rd_destroy(void *x) { record(x, "reader_destroy"); return 0; }
static int h_sync_init(void *x, uint16_t ch, uint16_t frames, uint32_t param)
{
    A3eCase *c = x;
    record(x, "sync_init ch=%u frames=%u param=%u", ch, frames, (unsigned)param);
    return c->sc.fail_sync_init != 0 || c->sc.load_status != 0 ? 1 : 0;
}
static int h_sync_frame(void *x, uint16_t ch, int *playing, int32_t *raw_frame)
{
    A3eCase *c = x;
    int v;
    int32_t raw;
    *playing = 0;
    *raw_frame = -1;
    if (ch != 0x0c || c->sc.load_status != 0) {
        return 0; /* 0x4f6ef4: channel not ready -> -1 before the is-playing query */
    }
    v = c->idx_c < c->sc.n_c ? c->sc.playing_c[c->idx_c] : 0;
    ++c->idx_c;
    record(x, "snd_playing %u -> %d", ch, v);
    if (v == 0) {
        return 0;
    }
    *playing = 1;
    raw = c->idx_raw < c->sc.n_raw ? c->sc.raw[c->idx_raw] : -1;
    ++c->idx_raw;
    record(x, "snd_pos %u -> %d", ch, (int)raw);
    if (raw == -1) {
        *raw_frame = -1;
    } else if (raw > 0) {
        const float fr = (float)raw;
        const float fb = (float)c->sc.bytes_per_frame;
        *raw_frame = (int32_t)((double)fr / (double)fb); /* fdiv at 53-bit precision, then _ftol */
    } else {
        *raw_frame = 0;
    }
    return 0;
}

A3eCase *a3e_new(const uint8_t *image, size_t bytes, uint32_t handle_base, const A3eScript *script)
{
    A3eCase *c = calloc(1, sizeof *c);
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
    c->host.cel_load_header = h_cel_header;
    c->host.cel_tree_index = h_cel_tree;
    c->host.cel_tree_info = h_cel_info;
    c->host.cel_load_layer = h_cel_load;
    c->host.cel_free_layer = h_cel_free;
    c->host.cel_release_header = h_cel_release;
    c->host.cel_reader_create = h_rd_create;
    c->host.cel_reader_resume = h_rd_resume;
    c->host.cel_reader_destroy = h_rd_destroy;
    c->host.sound_sync_init = h_sync_init;
    c->host.sound_sync_frame = h_sync_frame;
    return c;
}

void a3e_set_block(A3eCase *c, const uint8_t *data, size_t n)
{
    free(c->blk);
    c->blk = malloc(n != 0u ? n : 1u);
    memcpy(c->blk, data, n);
    c->blk_bytes = n;
}

void a3e_free(A3eCase *c)
{
    size_t i;
    for (i = 0; i < c->nrefs; ++i) {
        free((void *)c->refs[i].name);
    }
    free(c->refs);
    free(c->log);
    free(c->logsnap);
    free(c->arena);
    free(c->blk);
    free(c);
}

void a3e_clear_log(A3eCase *c) { c->nlog = 0; }

int a3e_visit(A3eCase *c, int32_t row, uint32_t phase)
{
    c->why = "none";
    memset(&c->r, 0, sizeof c->r);
    c->status = convo3f_step_type(&c->m, &c->obj, CONVO3E_RUNTIME_TYPE, row, phase, &c->w, &c->host,
                                  &c->r, &c->why);
    return c->status;
}

/* One reader pass 0x422e4a (without Sleep); *ran: the load/advance branch was taken. */
int a3e_pass(A3eCase *c, int *ran)
{
    c->why = "none";
    c->ran = 0;
    c->status = convo3f_cel_reader_iteration(&c->m, &c->host, &c->ran, &c->why);
    *ran = c->ran;
    return c->status;
}

/* Render callback 0x422a0a: one event line per blit. */
int a3e_render(A3eCase *c)
{
    size_t i;
    c->why = "none";
    c->status = convo3f_cel_render(&c->m, &c->obj, &c->w, &c->host, &c->plan, &c->why);
    if (c->status == CONVO3F_OK) {
        for (i = 0; i < c->plan.count; ++i) {
            const Convo3fBlit *b = &c->plan.blits[i];
            record(c, "blit %d s=%u k=%d src=%d,%d,%d,%d dst=%d,%d,%d,%d", b->kind, (unsigned)b->surface,
                   (int)b->key, (int)b->src[0], (int)b->src[1], (int)b->src[2], (int)b->src[3],
                   (int)b->dst[0], (int)b->dst[1], (int)b->dst[2], (int)b->dst[3]);
        }
    }
    return c->status;
}

const char *a3e_why(A3eCase *c) { return c->why; }
int a3e_log_count(A3eCase *c) { return c->nlog; }
const char *a3e_log_text(A3eCase *c, int i) { return c->log[i]; }
void a3e_log_snapshot(A3eCase *c, int i, uint8_t *out)
{
    memcpy(out, c->logsnap + (size_t)i * c->light_bytes, c->light_bytes);
}
void a3e_result(A3eCase *c, uint32_t *out)
{
    out[0] = c->r.phase_after;
    out[1] = c->r.ran;
    out[2] = c->r.started;
    out[3] = c->r.finished;
    out[4] = c->r.scene_change;
    out[5] = c->r.object_released;
    out[6] = c->r.skipped_optional;
}
void a3e_arena(A3eCase *c, uint8_t *out) { memcpy(out, c->arena, c->arena_bytes); }
void a3e_set_chosen(A3eCase *c, int i, int32_t v) { c->w.chosen_5839b1[i] = v; }
void a3e_set_event(A3eCase *c, int i, int32_t v) { c->events[i] = v; }
void a3e_set_presence(A3eCase *c, int i, int32_t v) { c->presence[i] = v; }
