#include "action_family_3f_runtime.h"

#include <string.h>

/* RT-23: raw 0x3f conversation runtime. Every offset, width, comparison and
 * effect order below was read from the disassembly of 0x420c17 (dispatcher arm
 * 0x427a50), 0x4205c1, 0x420737, 0x4209e8, 0x41fa11, 0x41fd08, 0x42028e,
 * 0x41f986 and 0x42e493; see action_family_3f_runtime.h for the contract. */

#define MAX_COND_BYTES 127u
#define PRIMARY_STRIDE 0x1d1u
#define INTER_STRIDE 0x1cu
#define SECONDARY_STRIDE 10u
#define SCRATCH_PRIMARY 75   /* 0x78e..0x7d9 is condition scratch, then record 0 */
#define SCRATCH_INTER 50     /* 0x7a7..0x7d9 */
#define SCRATCH_SECONDARY 25 /* 0x7c0..0x7d9 */

static const char *const NO_SOUND = "NO SOUND"; /* 0x544054, compared over 9 bytes */

static uint16_t rd_u16(const uint8_t *p)
{
    return (uint16_t)((uint16_t)p[0] | (uint16_t)((uint16_t)p[1] << 8));
}
static int16_t rd_s16(const uint8_t *p)
{
    const uint16_t bits = rd_u16(p);
    return bits <= (uint16_t)INT16_MAX ? (int16_t)bits : (int16_t)(-1 - (int32_t)(UINT16_MAX - bits));
}
static uint32_t rd_u32(const uint8_t *p)
{
    return (uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24);
}
static int32_t rd_s32(const uint8_t *p)
{
    const uint32_t bits = rd_u32(p);
    return bits <= (uint32_t)INT32_MAX ? (int32_t)bits : (int32_t)(-1 - (int32_t)(UINT32_MAX - bits));
}

static int fail(const char **why, const char *reason)
{
    if (why != NULL) {
        *why = reason;
    }
    return 0;
}

/* Bounds-checked view of `n` bytes at a logical handle inside the object arena. */
static const uint8_t *arena_at(const Convo3fObject *o, uint32_t handle, size_t n)
{
    size_t offset;
    if (handle < o->handle_base) {
        return NULL;
    }
    offset = (size_t)(handle - o->handle_base);
    if (offset > o->arena_bytes || n > o->arena_bytes - offset) {
        return NULL;
    }
    return o->arena + offset;
}

int convo3f_text_equal(const uint8_t *a, const uint8_t *b)
{
    size_t i;
    for (i = 0; i < CONVO3F_TEXT_BYTES; ++i) {
        uint8_t x = a[i];
        uint8_t y = b[i];
        if (x == 0u || y == 0u) {
            return x == y;
        }
        if (x > 0x40u && x < 0x5bu) {
            x = (uint8_t)(x + 0x20u);
        }
        if (y > 0x40u && y < 0x5bu) {
            y = (uint8_t)(y + 0x20u);
        }
        if (x != y) {
            return 0;
        }
    }
    return 1;
}

int convo3f_condition_tree(const uint8_t *c, int16_t count, const Convo3fWorld *world,
                           uint8_t *f, int *result, const char **why)
{
    int i, changed;
    if (c == NULL || f == NULL || world == NULL || result == NULL) {
        return fail(why, "null argument"), CONVO3F_ERR_ARGUMENT;
    }
    if (count <= 0) {
        *result = 1; /* 0x420737: count 0 (and any non-positive count) is true */
        return CONVO3F_OK;
    }
    for (i = 0; i < count; ++i) {
        f[i] = 0u;
    }
    for (i = 0; i < count; ++i) {
        const uint8_t kind = c[i * 5];
        const int16_t index = rd_s16(c + i * 5 + 1);
        const uint32_t value = c[i * 5 + 3];
        if (kind == 1u) {
            if (world->events == NULL || index < 0 || (size_t)index >= world->event_count) {
                return fail(why, "condition event index outside the modelled array 0x585801"),
                       CONVO3F_ERR_BOUNDS;
            }
            if ((uint32_t)world->events[index] == value) {
                f[i] = 1u;
            }
        } else if (kind == 2u) {
            if (world->presence == NULL || index < 0 || (size_t)index >= world->presence_count) {
                return fail(why, "condition presence index outside the modelled array 0x583bd5"),
                       CONVO3F_ERR_BOUNDS;
            }
            if ((uint32_t)world->presence[index] == value) {
                f[i] = 1u;
            }
        }
    }
    do {
        changed = 0;
        for (i = 0; i < count; ++i) {
            if (c[i * 5 + 4] == 1u) {
                if (f[i] != 0u && i + 1 < count && f[i + 1] == 0u) {
                    f[i + 1] = 1u;
                    changed = 1;
                }
                if (i - 1 >= 0 && f[i] != 0u && c[(i - 1) * 5 + 4] == 1u && f[i - 1] == 0u) {
                    f[i - 1] = 1u;
                    changed = 1;
                }
            } else if (i - 1 >= 0 && c[(i - 1) * 5 + 4] == 1u) {
                if (f[i] == 0u || f[i - 1] != 0u) {
                    if (f[i - 1] != 0u && f[i] == 0u) {
                        f[i] = 1u;
                        changed = 1;
                    }
                } else {
                    f[i - 1] = 1u;
                    changed = 1;
                }
            }
        }
    } while (changed);
    *result = 1;
    for (i = 0; i < count; ++i) {
        if (f[i] == 0u) {
            *result = 0;
            break;
        }
    }
    return CONVO3F_OK;
}

void convo3f_manager_reset(Convo3fManager *m)
{
    if (m == NULL) {
        return;
    }
    memset(m, 0, sizeof(*m));
    m->row = -1;
    m->textbox_slot[0] = -1;
    m->textbox_slot[1] = -1;
}

/* Evaluates the condition handle/count pair of one table entry. `limit` is the
 * count the original scratch area holds before it would overwrite other
 * manager fields (native rejection above it). */
static int entry_condition(const Convo3fObject *o, const uint8_t *entry, const Convo3fWorld *w,
                           int limit, int *result, const char **why)
{
    uint8_t flags[MAX_COND_BYTES];
    const int16_t count = rd_s16(entry);
    const uint8_t *conds = NULL;
    if (count > 0) {
        if (count > limit) {
            return fail(why, "condition count exceeds the original scratch area"), CONVO3F_ERR_BOUNDS;
        }
        conds = arena_at(o, rd_u32(entry + 2), (size_t)count * 5u);
        if (conds == NULL) {
            return fail(why, "condition table handle outside the object arena"), CONVO3F_ERR_BOUNDS;
        }
    } else {
        conds = entry; /* never read for count <= 0 */
    }
    return convo3f_condition_tree(conds, count, w, flags, result, why);
}

/* ---- response list (0x41fa11 / 0x41fd08 / 0x42028e) ---- */

static void copy_name_cstr(uint8_t *to, const uint8_t *from)
{
    const uint8_t *nul = memchr(from, 0, CONVO3F_NAME_BYTES);
    const size_t n = nul != NULL ? (size_t)(nul - from) + 1u : CONVO3F_NAME_BYTES;
    memcpy(to, from, n); /* strlen+1 bytes: the stale tail stays, as in the original */
}

static void store_entry(Convo3fResponse *r, const uint8_t *entry)
{
    r->word_27 = rd_s16(entry + C3F_PE_W3);
    r->word_25 = rd_s16(entry + C3F_PE_W2);
    r->scene = rd_s16(entry + C3F_PE_SCENE);
    r->word_23 = rd_s16(entry + C3F_PE_W1);
    r->dword_29 = rd_s32(entry + C3F_PE_D1);
    r->dword_2d = rd_s32(entry + C3F_PE_D2);
    r->dword_31 = rd_s32(entry + C3F_PE_D3);
    copy_name_cstr(r->name, entry + C3F_PE_SOUND_NAME);
    r->event_index = rd_s16(entry + C3F_PE_EVENT_INDEX);
    r->event_value = entry[C3F_PE_EVENT_VALUE];
    r->word_38 = rd_u16(entry + C3F_PE_WORD_1CF);
    memcpy(r->text, entry + C3F_PE_TEXT, CONVO3F_TEXT_BYTES);
}

static void add_response(Convo3fManager *m, const uint8_t *entry)
{
    if (m->response_count < 0 || m->response_count + 1 >= 0x1f) {
        return; /* 0x41fa11: the add is skipped at 30 entries (debug log only) */
    }
    store_entry(&m->responses[m->response_count], entry);
    ++m->response_count;
}

/* Index of the first entry whose text equals the entry's text, or -1. */
static int find_response(const Convo3fManager *m, const uint8_t *entry)
{
    int i;
    for (i = 0; i < m->response_count; ++i) {
        if (convo3f_text_equal(m->responses[i].text, entry + C3F_PE_TEXT)) {
            return i;
        }
    }
    return -1;
}

static void compact_from(Convo3fManager *m, int found)
{
    int dst = found;
    int src;
    for (src = found + 1; src < m->response_count; ++src, ++dst) {
        Convo3fResponse *d = &m->responses[dst];
        const Convo3fResponse *s = &m->responses[src];
        memcpy(d->text, s->text, CONVO3F_TEXT_BYTES);
        d->word_27 = s->word_27;
        d->word_25 = s->word_25;
        d->scene = s->scene;
        d->word_23 = s->word_23;
        d->dword_29 = s->dword_29;
        d->dword_2d = s->dword_2d;
        d->dword_31 = s->dword_31;
        copy_name_cstr(d->name, s->name);
        d->event_index = s->event_index;
        d->event_value = s->event_value;
        d->word_38 = s->word_38;
    }
    --m->response_count;
    if (m->response_count < 0) {
        m->response_count = 0;
    }
}

static int build_list(Convo3fManager *m, const Convo3fObject *o, const Convo3fWorld *w,
                      const char **why)
{
    const uint8_t *img = o->arena;
    const int16_t n = rd_s16(img + C3F_PRIMARY_COUNT);
    const uint32_t table = rd_u32(img + C3F_PRIMARY_TABLE);
    int16_t i;
    if (img[C3F_FLAG_778] == 0u) {
        /* 0x41f986: the thirty pool strings become empty, the count 0. */
        int k;
        for (k = 0; k < CONVO3F_MAX_RESPONSES; ++k) {
            memset(m->responses[k].text, 0, CONVO3F_TEXT_BYTES);
        }
        m->response_count = 0;
    }
    for (i = 0; i < n; ++i) {
        const uint8_t *entry = arena_at(o, table + (uint32_t)i * PRIMARY_STRIDE, PRIMARY_STRIDE);
        int ok = 0;
        int status;
        if (entry == NULL) {
            return fail(why, "primary entry outside the object arena"), CONVO3F_ERR_BOUNDS;
        }
        status = entry_condition(o, entry, w, SCRATCH_PRIMARY, &ok, why);
        if (status != CONVO3F_OK) {
            return status;
        }
        if (ok == 0) {
            continue;
        }
        switch (entry[C3F_PE_KIND]) {
        case 0u:
            if (find_response(m, entry) < 0) {
                add_response(m, entry);
            }
            break;
        case 1u: {
            const int found = find_response(m, entry);
            if (found >= 0) {
                compact_from(m, found);
            }
            add_response(m, entry);
            break;
        }
        case 2u: {
            const int found = find_response(m, entry);
            if (found >= 0) {
                compact_from(m, found);
            }
            break;
        }
        default:
            break;
        }
    }
    return CONVO3F_OK;
}

/* ---- sound descriptors ---- */

static uint8_t volume_category(uint16_t channel)
{
    static const uint8_t zero[] = {12u, 13u, 30u};
    static const uint8_t one[] = {0u, 1u, 2u, 26u, 27u, 29u, 19u};
    static const uint8_t two[] = {3u, 4u, 5u, 6u, 7u, 8u, 9u, 10u, 11u, 20u,
                                  24u, 25u, 23u, 22u, 21u, 31u, 18u, 17u};
    size_t i;
    for (i = 0; i < sizeof(zero); ++i) {
        if (zero[i] == channel) {
            return 0u;
        }
    }
    for (i = 0; i < sizeof(one); ++i) {
        if (one[i] == channel) {
            return 1u;
        }
    }
    for (i = 0; i < sizeof(two); ++i) {
        if (two[i] == channel) {
            return 2u;
        }
    }
    return 3u;
}

static float gain_of(int16_t percent)
{
    const float g = (float)percent / 100.0f;
    return g >= 1.0f ? 1.0f : (g <= 0.0f ? 0.0f : g);
}

/* 0x4fb77a(descriptor) as an ActionSoundAudioCommand. The raw s16 at +0x23
 * (passed to 0x4fc62d) and the s16 at +0x25 (== 2 loops) have no field of their
 * own: control_word carries the +0x29 dword (channel state +0x134), mode the
 * low byte of +0x25. Raw 0x3f objects hold the constants 2 and 1 there. */
static int sound_command(const uint8_t *d, ActionSoundAudioCommand *cmd, const char **why)
{
    const uint8_t *nul = memchr(d, 0, CONVO3F_NAME_BYTES);
    if (nul == NULL) {
        return fail(why, "sound name is not NUL terminated"), CONVO3F_ERR_BOUNDS;
    }
    if (rd_u16(d + C3F_SND_CHANNEL) >= ACTION_SOUND_CHANNEL_COUNT) {
        return fail(why, "sound channel outside the 32 channel states"), CONVO3F_ERR_BOUNDS;
    }
    memset(cmd, 0, sizeof(*cmd));
    memcpy(cmd->asset_stem, d, (size_t)(nul - d));
    cmd->channel = rd_u16(d + C3F_SND_CHANNEL);
    cmd->volume_category = volume_category(cmd->channel);
    cmd->control_word = rd_u32(d + C3F_SND_DWORD);
    cmd->first_percent = rd_s16(d + C3F_SND_GAIN1);
    cmd->second_percent = rd_s16(d + C3F_SND_GAIN2);
    cmd->first_gain = gain_of(cmd->first_percent);
    cmd->second_gain = gain_of(cmd->second_percent);
    cmd->mode = (uint8_t)rd_u16(d + C3F_SND_MODE);
    cmd->transition_scene = CONVO3F_NO_SCENE;
    return CONVO3F_OK;
}

static int sound_ready(const Convo3fHost *h, int need_play, int need_playing, int need_unload)
{
    if (h->sound == NULL || h->sound->load_sound == NULL) {
        return 0;
    }
    return !(need_play && h->sound->play_sound == NULL) &&
           !(need_playing && h->sound->is_playing == NULL) &&
           !(need_unload && h->sound->unload_sound == NULL);
}

/* 0x4fb77a(descriptor) then 0x4fb2e3(constant channel 0xc / 0xd, independent of the
 * descriptor's own channel word). A load that finds no resource leaves the original
 * playing nothing (it still advances); every other failure is a host failure. */
static int sound_start(const Convo3fHost *h, const ActionSoundAudioCommand *cmd,
                       uint16_t play_channel, const char **why)
{
    ActionSoundBackendStatus s = h->sound->load_sound(h->sound->context, cmd);
    if (s == ACTION_SOUND_BACKEND_NO_RESOURCE) {
        return CONVO3F_OK;
    }
    if (s != ACTION_SOUND_BACKEND_OK) {
        return fail(why, "sound backend load failed"), CONVO3F_ERR_HOST;
    }
    if (h->sound->play_sound(h->sound->context, play_channel) != ACTION_SOUND_BACKEND_OK) {
        return fail(why, "sound backend play failed"), CONVO3F_ERR_HOST;
    }
    return CONVO3F_OK;
}

static int sound_stop(const Convo3fHost *h, uint16_t channel, const char **why)
{
    if (h->sound->unload_sound(h->sound->context, channel) != ACTION_SOUND_BACKEND_OK) {
        return fail(why, "sound backend unload failed"), CONVO3F_ERR_HOST;
    }
    return CONVO3F_OK;
}

static int sound_playing(const Convo3fHost *h, uint16_t channel, int *playing, const char **why)
{
    int still = 0;
    if (h->sound->is_playing(h->sound->context, channel, &still) != ACTION_SOUND_BACKEND_OK) {
        return fail(why, "sound backend is_playing failed"), CONVO3F_ERR_HOST;
    }
    *playing = still != 0;
    return CONVO3F_OK;
}

#define HOST_CALL(expr, reason)                       \
    do {                                              \
        if ((expr) != 0) {                            \
            return fail(why, reason), CONVO3F_ERR_HOST; \
        }                                             \
    } while (0)

/* 0x43dbd5 and 0x4d36ed: plain global stores. */
static void redraw_words(Convo3fWorld *w)
{
    w->redraw_5831c8 = 1;
    w->redraw_5831c6 = 0;
}

static int16_t low16_layout(const Convo3fWorld *w)
{
    /* 0x421252: movsx word 5b0a76, minus (dword 5b0a1e - dword 5b0a16 + 1), stored as a word. */
    const uint32_t extent = (uint32_t)w->ui_5b0a1e - (uint32_t)w->ui_5b0a16 + 1u;
    const uint32_t low = (((uint32_t)(int32_t)w->ui_5b0a76 - extent) & 0xffffu);
    return (int16_t)(low <= 0x7fffu ? (int32_t)low : (int32_t)low - 0x10000);
}

/* ---- phase 0 ---- */

static int phase0(Convo3fManager *m, const Convo3fObject *o, int32_t row, Convo3fWorld *w,
                  const Convo3fHost *h, Convo3fStepResult *r, const char **why)
{
    uint8_t *img = o->arena;
    ActionSoundAudioCommand cmd;
    Convo3fManager built;
    int status, need_ui, i;
    if (w->flag_5c39e9 != 0 || w->flag_5c39ed != 0) {
        return CONVO3F_OK; /* both guards refuse with no effect at all */
    }
    if (w->mode_583999 != 3) {
        /* The original has already stored its row/object/type fields. */
        m->row = (int16_t)row;
        m->type = CONVO3F_RUNTIME_TYPE;
        r->ran = 1u;
        return CONVO3F_OK;
    }
    /* ---- validation: no effect before this block is complete ---- */
    if (img[C3F_HOOK_A] != CONVO3F_NO_HOOK || img[C3F_HOOK_B] != CONVO3F_NO_HOOK) {
        return fail(why, "hook builder (tier C): response builders 0x43f31a..0x44499c are not "
                         "recovered"),
               CONVO3F_ERR_UNSUPPORTED;
    }
    if (m->cel_thread != 0) {
        return fail(why, "cel reader thread active (raw 0x39/0x3b/0x3e state)"), CONVO3F_ERR_UNSUPPORTED;
    }
    if (!sound_ready(h, 1, 0, 0)) {
        return fail(why, "sound backend (load_sound/play_sound)"), CONVO3F_ERR_UNSUPPORTED;
    }
    status = sound_command(img + C3F_SOUND, &cmd, why);
    if (status != CONVO3F_OK) {
        return status;
    }
    memcpy(&built, m, sizeof(built));
    status = build_list(&built, o, w, why);
    if (status != CONVO3F_OK) {
        return status;
    }
    need_ui = w->captions_5bb202 != 0 || built.response_count != 0;
    if (need_ui && (h->layout_text_box == NULL || h->acquire_surface == NULL ||
                    h->release_surface == NULL)) {
        return fail(why, built.response_count != 0
                             ? "responses (tier B) need layout_text_box/acquire_surface/release_surface"
                             : "captions enabled without layout_text_box/acquire_surface/release_surface"),
               CONVO3F_ERR_UNSUPPORTED;
    }
    if (h->acquire_surface != NULL && h->release_surface == NULL) {
        return fail(why, "acquire_surface without release_surface"), CONVO3F_ERR_UNSUPPORTED;
    }
    if (w->held_item != -1 && h->inventory_add == NULL) {
        return fail(why, "held item put-back needs inventory_add"), CONVO3F_ERR_UNSUPPORTED;
    }
    /* ---- effects, in the order of 0x420c17 ---- */
    r->ran = 1u;
    r->started = 1u;
    m->row = (int16_t)row;
    m->type = CONVO3F_RUNTIME_TYPE;
    w->flag_5c39e9 = 1;
    w->flag_5c39ed = 1;
    if (w->engine_583204 == 4 || w->engine_583204 == 3) {
        if (h->release_engine_view != NULL) {
            HOST_CALL(h->release_engine_view(h->context, w->engine_583204), "release_engine_view failed");
        } else {
            r->skipped_optional |= CONVO3F_SKIP_ENGINE_VIEW;
        }
    }
    w->engine_583204 = 2;
    /* 0x4e7728(2): 0x43dbd5, 0x4d36ed, then the engine word. */
    w->flag_5bb1c4 = 1;
    redraw_words(w);
    if (h->engine_mode != NULL) {
        HOST_CALL(h->engine_mode(h->context, 2), "engine_mode failed");
    } else {
        r->skipped_optional |= CONVO3F_SKIP_ENGINE_MODE;
    }
    if (h->engine_aux != NULL) {
        HOST_CALL(h->engine_aux(h->context, 0), "engine_aux failed");
    } else {
        r->skipped_optional |= CONVO3F_SKIP_ENGINE_AUX;
    }
    if (w->cursor_583106 < w->limit_5b3788) {
        if (h->cursor_hotspot != NULL) {
            HOST_CALL(h->cursor_hotspot(h->context, w->hotspot_x_5b378c, w->hotspot_y_5b378e),
                      "cursor_hotspot failed");
        } else {
            r->skipped_optional |= CONVO3F_SKIP_CURSOR;
        }
    }
    w->selected_570374 = CONVO3F_NO_SELECTION;
    for (i = 0; i < CONVO3F_MAX_RESPONSES; ++i) {
        w->chosen_5839b1[i] = 0;
    }
    /* 0x41f986 + count := 0 happen inside build_list when +0x778 == 0; the
     * manager is committed below with the finished list. */
    memset(m->display_name, 0, sizeof(m->display_name));
    if (img[C3F_FLAG_778] == 0u) {
        m->response_count = 0; /* 0x420e4c: reset BEFORE the put-back and the surface effects (oracle D3) */
    }
    if (w->held_item != -1) { /* 0x4e8d96 */
        HOST_CALL(h->inventory_add(h->context, w->held_item, 0), "inventory_add (put-back) failed");
        w->held_item = -1;
    }
    w->ui_5d191d = 0;
    if (h->acquire_surface != NULL) {
        HOST_CALL(h->acquire_surface(h->context, CONVO3F_SURFACE_NORMAL_NAME, w->ui_5b0a74,
                                     w->ui_5b0a76, &m->textbox_slot[0]),
                  "acquire_surface (normal) failed");
        HOST_CALL(h->acquire_surface(h->context, CONVO3F_SURFACE_HILITE_NAME, w->ui_5b0a74,
                                     w->ui_5b0a76, &m->textbox_slot[1]),
                  "acquire_surface (hilite) failed");
    } else {
        r->skipped_optional |= CONVO3F_SKIP_SURFACES;
    }
    w->ui_5b15da = 0;
    m->sub_state = 0u;
    /* 0x4205c1: commit the list built during validation. */
    {
        int16_t slot0 = m->textbox_slot[0], slot1 = m->textbox_slot[1];
        memcpy(m, &built, sizeof(*m));
        m->row = (int16_t)row;
        m->type = CONVO3F_RUNTIME_TYPE;
        m->textbox_slot[0] = slot0;
        m->textbox_slot[1] = slot1;
        memset(m->display_name, 0, sizeof(m->display_name));
    }
    w->ui_5b0a8e = 0;
    /* 0x4211ec clears 33 bytes of each 41-byte cell (8 dwords and a byte), not the whole cell. */
    for (i = 0; i < CONVO3F_UI_SOUND_ROWS; ++i) {
        memset(w->ui_sound_names[i], 0, CONVO3F_NAME_BYTES);
    }
    w->ui_5b0a90 = 0;
    memset(w->ui_5b1436, 0, sizeof(w->ui_5b1436));
    if (w->captions_5bb202 == 0 && m->response_count == 0) {
        w->ui_5b0a7c = low16_layout(w);
        w->ui_5b15c8 = 1;
        w->ui_5b15d6 = 0;
    } else {
        Convo3fLayoutRequest req;
        const uint8_t *nul = memchr(img + C3F_CAPTION, 0, o->arena_bytes > C3F_CAPTION ? 1500u : 0u);
        memset(&req, 0, sizeof(req));
        req.row = row;
        req.caption = img + C3F_CAPTION;
        req.caption_length = nul != NULL ? (size_t)(nul - (img + C3F_CAPTION)) : 1500u;
        req.response_count = m->response_count;
        req.responses = m->responses;
        req.slot_normal = m->textbox_slot[0];
        req.slot_hilite = m->textbox_slot[1];
        HOST_CALL(h->layout_text_box(h->context, &req, w), "layout_text_box failed");
    }
    status = sound_start(h, &cmd, CONVO3F_SOUND_CHANNEL, why);
    if (status != CONVO3F_OK) {
        return status;
    }
    for (i = 0; i < (int)CONVO3F_NAME_BYTES; ++i) {
        m->display_name[i] = img[i] == (uint8_t)'_' ? (uint8_t)' ' : img[i];
    }
    m->sub_state = 4u;
    r->phase_after = 1u;
    return CONVO3F_OK;
}

/* ---- phase 1 ---- */

static int phase1(Convo3fManager *m, const Convo3fObject *o, Convo3fWorld *w, const Convo3fHost *h,
                  Convo3fStepResult *r, const char **why)
{
    uint8_t *img = o->arena;
    int status, playing = 0;
    r->ran = 1u;
    r->phase_after = 1u;
    /* ---- validation ---- */
    if (w->ui_5b15da != 0 && h->refresh_hotspot_surface == NULL) {
        return fail(why, "hotspot surface refresh (0x420b9e) needs refresh_hotspot_surface"),
               CONVO3F_ERR_UNSUPPORTED;
    }
    switch (m->sub_state) {
    case 1u:
        return fail(why, "cel start sub-state (raw 0x39/0x3b/0x3e)"), CONVO3F_ERR_UNSUPPORTED;
    case 4u:
        if (!sound_ready(h, 0, 1, 0)) {
            return fail(why, "sound backend is_playing"), CONVO3F_ERR_UNSUPPORTED;
        }
        break;
    case 5u:
        if (!sound_ready(h, 1, 0, 1)) {
            return fail(why, "sound backend unload/play"), CONVO3F_ERR_UNSUPPORTED;
        }
        if (w->selected_570374 < 0 || w->selected_570374 >= CONVO3F_UI_SOUND_ROWS) {
            return fail(why, "selected response index outside table 0x5b0a9a"), CONVO3F_ERR_BOUNDS;
        }
        if (rd_u16(img + C3F_SOUND + C3F_SND_CHANNEL) >= ACTION_SOUND_CHANNEL_COUNT) {
            return fail(why, "sound channel outside the 32 channel states"), CONVO3F_ERR_BOUNDS;
        }
        if (rd_u16(img + C3F_SOUND2 + C3F_SND_CHANNEL) >= ACTION_SOUND_CHANNEL_COUNT) {
            return fail(why, "response sound channel outside the 32 channel states"),
                   CONVO3F_ERR_BOUNDS;
        }
        {
            const uint8_t *name = w->ui_sound_names[w->selected_570374];
            if (memcmp(name, NO_SOUND, 9u) != 0) { /* 0x422012: repe cmpsb over 9 bytes */
                const uint8_t *nul = memchr(name, 0, CONVO3F_UI_SOUND_STRIDE);
                if (nul == NULL) {
                    return fail(why, "response sound name is not NUL terminated"), CONVO3F_ERR_BOUNDS;
                }
                if (nul != name && (size_t)(nul - name) + 1u > CONVO3F_NAME_BYTES) {
                    return fail(why, "response sound name overruns the 33-byte descriptor name"),
                           CONVO3F_ERR_BOUNDS;
                }
            }
        }
        break;
    case 6u:
        if (!sound_ready(h, 0, 1, 1)) {
            return fail(why, "sound backend is_playing/unload"), CONVO3F_ERR_UNSUPPORTED;
        }
        if (rd_u16(img + C3F_SOUND2 + C3F_SND_CHANNEL) >= ACTION_SOUND_CHANNEL_COUNT) {
            return fail(why, "response sound channel outside the 32 channel states"),
                   CONVO3F_ERR_BOUNDS;
        }
        break;
    default:
        break;
    }
    /* ---- effects ---- */
    if (w->ui_5b15da != 0) {
        w->ui_5b15da = 0;
        HOST_CALL(h->refresh_hotspot_surface(h->context, m->textbox_slot[0]),
                  "refresh_hotspot_surface failed");
    }
    if (h->poll_keys != NULL) { /* 0x4dadff */
        HOST_CALL(h->poll_keys(h->context, &w->skip_key_58321d, &w->key_58321e), "poll_keys failed");
    } else {
        r->skipped_optional |= CONVO3F_SKIP_KEYS;
    }
    switch (m->sub_state) {
    case 4u:
        w->start_5bb1ca = 1;
        status = sound_playing(h, CONVO3F_SOUND_CHANNEL, &playing, why);
        if (status != CONVO3F_OK) {
            return status;
        }
        if (playing == 0 || w->fast_convo_58322a != 0) {
            const int16_t count = m->response_count;
            if (count == 0 && w->fast_convo_58322a == 0) {
                w->selected_570374 = CONVO3F_NO_SELECTION;
                m->sub_state = 5u;
                return CONVO3F_OK;
            }
            if (count == 0 && w->fast_convo_58322a != 0 && w->skip_key_58321d == 1u) {
                w->selected_570374 = CONVO3F_NO_SELECTION;
                m->sub_state = 5u;
                return CONVO3F_OK;
            }
            if (count > 0) {
                int i;
                for (i = 0; i < CONVO3F_MAX_RESPONSES; ++i) {
                    if (w->chosen_5839b1[i] == 1) {
                        w->selected_570374 = (int16_t)i;
                        m->sub_state = 5u;
                        break;
                    }
                }
            }
        }
        break;
    case 5u: {
        const uint8_t *name = w->ui_sound_names[w->selected_570374];
        status = sound_stop(h, rd_u16(img + C3F_SOUND + C3F_SND_CHANNEL), why);
        if (status != CONVO3F_OK) {
            return status;
        }
        if (memcmp(name, NO_SOUND, 9u) != 0 && name[0] != 0u) {
            ActionSoundAudioCommand cmd;
            const size_t n = strlen((const char *)name) + 1u;
            memcpy(img + C3F_SOUND2, name, n);
            status = sound_command(img + C3F_SOUND2, &cmd, why);
            if (status != CONVO3F_OK) {
                return status;
            }
            status = sound_start(h, &cmd, CONVO3F_RESPONSE_CHANNEL, why);
            if (status != CONVO3F_OK) {
                return status;
            }
            m->sub_state = 6u;
            return CONVO3F_OK;
        }
        r->phase_after = 2u;
        break;
    }
    case 6u:
        status = sound_playing(h, CONVO3F_RESPONSE_CHANNEL, &playing, why);
        if (status != CONVO3F_OK) {
            return status;
        }
        if (playing == 0) {
            status = sound_stop(h, rd_u16(img + C3F_SOUND2 + C3F_SND_CHANNEL), why);
            if (status != CONVO3F_OK) {
                return status;
            }
            r->phase_after = 2u;
        }
        break;
    default:
        break;
    }
    return CONVO3F_OK;
}

/* ---- phase 2 ---- */

typedef struct {
    uint8_t kind;
    int16_t id;
    uint8_t value;
} SecondaryAction;

typedef enum { NEXT_NONE, NEXT_POP_EXIT, NEXT_RESPONSE, NEXT_INTER, NEXT_DEFAULT, NEXT_POP_FLAG } NextKind;

static void load_xfer(Convo3fWorld *w, int32_t scene, int16_t a, int16_t b, int16_t c, int32_t d1,
                      int32_t d2, int32_t d3)
{
    w->xfer_5bb57b = scene;
    w->xfer_5bb599 = a;
    w->xfer_5bb595 = b;
    w->xfer_5c39ff = c;
    w->xfer_5bb59b = d1;
    w->xfer_5bb59f = d2;
    w->xfer_5bb5a3 = d3;
}

static int phase2(Convo3fManager *m, const Convo3fObject *o, Convo3fWorld *w, const Convo3fHost *h,
                  Convo3fStepResult *r, const char **why)
{
    uint8_t *img = o->arena;
    SecondaryAction plan[CONVO3F_SECONDARY_PLAN];
    size_t plan_count = 0, k;
    int16_t plan_index[CONVO3F_SECONDARY_PLAN];
    const int16_t count = m->response_count;
    const int16_t sel = w->selected_570374;
    const int use_response = count != 0 && sel != CONVO3F_NO_SELECTION;
    NextKind next = NEXT_NONE;
    const uint8_t *inter_entry = NULL;
    int16_t secondary_count, inter_count, i;
    int status, ok;
    r->ran = 1u;
    r->phase_after = 2u;
    /* ---- validation ---- */
    if (m->cel_thread != 0) {
        return fail(why, "cel reader thread active (raw 0x39/0x3b/0x3e state)"), CONVO3F_ERR_UNSUPPORTED;
    }
    if (use_response && (sel < 0 || sel >= CONVO3F_MAX_RESPONSES)) {
        return fail(why, "selected response index outside the 30 list records"), CONVO3F_ERR_BOUNDS;
    }
    if ((m->textbox_slot[0] != -1 || m->textbox_slot[1] != -1) && h->release_surface == NULL) {
        return fail(why, "text box surfaces held but release_surface missing"), CONVO3F_ERR_UNSUPPORTED;
    }
    secondary_count = rd_s16(img + C3F_SECONDARY_COUNT);
    for (i = 0; i < secondary_count; ++i) {
        const uint8_t *entry = arena_at(o, rd_u32(img + C3F_SECONDARY_TABLE) + (uint32_t)i * SECONDARY_STRIDE,
                                        SECONDARY_STRIDE);
        if (entry == NULL) {
            return fail(why, "secondary entry outside the object arena"), CONVO3F_ERR_BOUNDS;
        }
        ok = 0;
        status = entry_condition(o, entry, w, SCRATCH_SECONDARY, &ok, why);
        if (status != CONVO3F_OK) {
            return status;
        }
        /* 0x4209e8 evaluates each entry AFTER the earlier entries' effects, so every kind 1/2
         * entry is validated and planned here and its condition is re-evaluated at effect
         * time (oracle D1); the evaluation above only proves the tables are in bounds. */
        if (entry[C3F_SE_KIND] == 1u || entry[C3F_SE_KIND] == 2u) {
            if (plan_count >= CONVO3F_SECONDARY_PLAN) {
                return fail(why, "secondary plan overflow"), CONVO3F_ERR_BOUNDS;
            }
            plan_index[plan_count] = i;
            plan[plan_count].kind = entry[C3F_SE_KIND];
            plan[plan_count].id = rd_s16(entry + C3F_SE_ID);
            plan[plan_count].value = entry[C3F_SE_VALUE];
            if (plan[plan_count].kind == 1u) {
                if (w->events == NULL || plan[plan_count].id < 0 ||
                    (size_t)plan[plan_count].id >= w->event_count) {
                    return fail(why, "secondary event index outside the modelled array 0x585801"),
                           CONVO3F_ERR_BOUNDS;
                }
            } else if (plan[plan_count].value == 1u ? h->inventory_add == NULL
                                                    : h->inventory_remove == NULL) {
                return fail(why, "secondary kind 2 needs inventory_add/inventory_remove"),
                       CONVO3F_ERR_UNSUPPORTED;
            }
            ++plan_count;
        }
    }
    if (use_response && m->responses[sel].event_index != -1 &&
        (w->events == NULL || m->responses[sel].event_index < 0 ||
         (size_t)m->responses[sel].event_index >= w->event_count)) {
        return fail(why, "chosen response event index outside the modelled array 0x585801"),
               CONVO3F_ERR_BOUNDS;
    }
    if (w->exit_58322b != 0) {
        next = NEXT_POP_EXIT;
    } else if (use_response && m->responses[sel].scene != CONVO3F_NO_SCENE) {
        next = NEXT_RESPONSE;
    } else {
        inter_count = rd_s16(img + C3F_INTER_COUNT);
        for (i = 0; i < inter_count && next == NEXT_NONE; ++i) {
            const uint8_t *entry = arena_at(o, rd_u32(img + C3F_INTER_TABLE) + (uint32_t)i * INTER_STRIDE,
                                            INTER_STRIDE);
            if (entry == NULL) {
                return fail(why, "intermediate entry outside the object arena"), CONVO3F_ERR_BOUNDS;
            }
            ok = 0;
            status = entry_condition(o, entry, w, SCRATCH_INTER, &ok, why);
            if (status != CONVO3F_OK) {
                return status;
            }
            if (ok != 0) {
                next = NEXT_INTER;
                inter_entry = entry;
            }
        }
        if (next == NEXT_NONE && img[C3F_DEFAULT_ENABLE] == 1u) {
            next = NEXT_DEFAULT;
        }
        if (next == NEXT_NONE && img[C3F_POP_FLAG] == 1u) {
            next = NEXT_POP_FLAG;
        }
    }
    if ((next == NEXT_POP_EXIT || next == NEXT_POP_FLAG) && h->scene_stack_pop == NULL) {
        return fail(why, "scene stack pop (0x42e493) needs scene_stack_pop"), CONVO3F_ERR_UNSUPPORTED;
    }
    /* ---- effects, in the order of 0x420c17 ---- */
    if (m->textbox_slot[0] != -1) {
        HOST_CALL(h->release_surface(h->context, m->textbox_slot[0]), "release_surface failed");
        m->textbox_slot[0] = -1;
    }
    if (m->textbox_slot[1] != -1) {
        HOST_CALL(h->release_surface(h->context, m->textbox_slot[1]), "release_surface failed");
        m->textbox_slot[1] = -1;
    }
    w->ui_5b15da = 0;
    for (k = 0; k < plan_count; ++k) { /* 0x4209e8 */
        {
            const uint8_t *entry = arena_at(o, rd_u32(img + C3F_SECONDARY_TABLE) +
                                                   (uint32_t)plan_index[k] * SECONDARY_STRIDE,
                                            SECONDARY_STRIDE);
            int now = 0;
            if (entry == NULL ||
                entry_condition(o, entry, w, SCRATCH_SECONDARY, &now, why) != CONVO3F_OK) {
                return fail(why, "secondary condition failed at effect time"), CONVO3F_ERR_BOUNDS;
            }
            if (now == 0) {
                continue;
            }
        }
        if (plan[k].kind == 1u) {
            w->events[plan[k].id] = (int32_t)plan[k].value;
        } else if (plan[k].value == 1u) {
            HOST_CALL(h->inventory_add(h->context, plan[k].id, 1), "inventory_add failed");
        } else {
            HOST_CALL(h->inventory_remove(h->context, plan[k].id), "inventory_remove failed");
        }
    }
    if (use_response && m->responses[sel].event_index != -1) {
        w->events[m->responses[sel].event_index] = (int32_t)m->responses[sel].event_value;
    }
    switch (next) {
    case NEXT_POP_EXIT:
    case NEXT_POP_FLAG:
        HOST_CALL(h->scene_stack_pop(h->context, w), "scene stack is empty (0x42e493 aborts)");
        r->scene_change = 1u;
        break;
    case NEXT_RESPONSE: {
        const Convo3fResponse *e = &m->responses[sel];
        load_xfer(w, e->scene, e->word_23, e->word_25, e->word_27, e->dword_29, e->dword_2d,
                  e->dword_31);
        w->mode_583999 = 4;
        r->scene_change = 1u;
        break;
    }
    case NEXT_INTER:
        load_xfer(w, rd_s16(inter_entry + 6), rd_s16(inter_entry + 8), rd_s16(inter_entry + 10),
                  rd_s16(inter_entry + 12), rd_s32(inter_entry + 14), rd_s32(inter_entry + 18),
                  rd_s32(inter_entry + 22));
        w->mode_583999 = 4;
        r->scene_change = 1u;
        break;
    case NEXT_DEFAULT:
        load_xfer(w, rd_s16(img + C3F_DEFAULT_SCENE), rd_s16(img + C3F_DEFAULT_W1),
                  rd_s16(img + C3F_DEFAULT_W2), rd_s16(img + C3F_DEFAULT_W3),
                  rd_s32(img + C3F_DEFAULT_D1), rd_s32(img + C3F_DEFAULT_D2),
                  rd_s32(img + C3F_DEFAULT_D3));
        w->mode_583999 = 4;
        r->scene_change = 1u;
        break;
    case NEXT_NONE:
    default:
        break;
    }
    w->ui_5b0a7c = low16_layout(w);
    if (h->release_ui_hook != NULL) { /* 0x4ee673(0) */
        HOST_CALL(h->release_ui_hook(h->context, 0), "release_ui_hook failed");
    } else {
        r->skipped_optional |= CONVO3F_SKIP_UI_HOOK;
    }
    w->engine_583204 = 0;
    /* 0x4e7757: engine word, 0x4e76ed, 0x4d36ed, [0x583204] := 0. */
    if (h->engine_restore != NULL) {
        HOST_CALL(h->engine_restore(h->context), "engine_restore failed");
    } else {
        r->skipped_optional |= CONVO3F_SKIP_ENGINE_RESTORE;
    }
    redraw_words(w);
    w->engine_583204 = 0;
    w->ui_5b15d6 = 0;
    redraw_words(w); /* 0x4d36ed */
    w->start_5bb1ca = 0;
    w->flag_5c39e9 = 0;
    w->flag_5c39ed = 0;
    w->flag_5bb1c4 = 1; /* 0x43dbd5 */
    r->object_released = 1u; /* 0x41db40 */
    r->finished = 1u;
    r->phase_after = 0u;
    m->row = -1;
    return CONVO3F_OK;
}

int convo3f_step(Convo3fManager *m, const Convo3fObject *o, int32_t row, uint32_t phase,
                 Convo3fWorld *w, const Convo3fHost *h, Convo3fStepResult *r, const char **why)
{
    if (r != NULL) {
        memset(r, 0, sizeof(*r));
        r->phase_after = phase;
    }
    if (why != NULL) {
        *why = "none";
    }
    if (m == NULL || o == NULL || w == NULL || h == NULL || r == NULL || o->arena == NULL ||
        o->handle_base == 0u || row < 0 || row > INT16_MAX) {
        return fail(why, "null or invalid argument"), CONVO3F_ERR_ARGUMENT;
    }
    if (o->arena_bytes < CONVO3F_IMAGE_BYTES) {
        return fail(why, "object arena smaller than the 0x7a5-byte image"), CONVO3F_ERR_BOUNDS;
    }
    if (phase == 0u) {
        return phase0(m, o, row, w, h, r, why);
    }
    if (phase != 1u && phase != 2u) {
        return CONVO3F_OK; /* the original's switch has no arm: no effect */
    }
    if (m->row != (int16_t)row || m->type != CONVO3F_RUNTIME_TYPE) {
        return fail(why, "visit of a row that does not own the conversation manager"),
               CONVO3F_ERR_BOUNDS;
    }
    return phase == 1u ? phase1(m, o, w, h, r, why) : phase2(m, o, w, h, r, why);
}
