#include "action_family_d8_runtime.h"

#include <string.h>

#define REC_NAME 0x00u
#define REC_NAME2 0x21u
#define REC_MODE 0x42u
#define REC_44 0x44u
#define REC_48 0x48u
#define REC_4C 0x4cu
#define REC_50 0x50u
#define REC_SRC 0x54u   /* view window source rect (four dwords) */
#define REC_DST 0x64u   /* view window destination rect */
#define REC_BUTTON 0x74u
#define REC_DOWN 0xb4u
#define REC_INACTIVE 0xf4u
#define REC_FPS 0x134u
#define REC_EXIT_SCENE 0x135u
#define REC_EXIT_FLAG 0x14bu
#define REC_EXIT_RECT 0x14eu
#define REC_COUNT 0x15eu
#define REC_ENTRY 0x160u
#define MODE_RESTORE 2u

#define LABEL_BITMAP "PEEPHOLE PUZZLE BITMAP"
#define LABEL_OVERLAYS "PEEPHOLE PUZZLE OVERLAYS"
#define LABEL_SURFACE "DF PeepholePuzzle Surface"

static uint16_t rd16(const uint8_t *p) { return (uint16_t)(p[0] | (p[1] << 8)); }
static int16_t rds16(const uint8_t *p) { return (int16_t)rd16(p); }
static int32_t rds32(const uint8_t *p)
{
    return (int32_t)((uint32_t)p[0] | ((uint32_t)p[1] << 8) | ((uint32_t)p[2] << 16) | ((uint32_t)p[3] << 24));
}

static void fx(const D8Host *host, int effect, int32_t a, int32_t b)
{
    if (host != NULL && host->observe != NULL) host->observe(host->context, effect, a, b);
}

size_t d8_record_bytes(int count)
{
    if (count < 0 || (unsigned)count > D8_ENTRY_MAX) return 0u;
    return D8_RECORD_MAX_BYTES - (size_t)(D8_ENTRY_MAX - (unsigned)count) * D8_ENTRY_BYTES;
}

void d8_object_reset(D8Object *object)
{
    if (object == NULL) return;
    memset(object, 0, sizeof(*object));
    object->row = -1;
    object->slot_a = D8_NO_SLOT;
    object->slot_b = D8_NO_SLOT;
    object->dir = 0xffu;
}

/* 0x48bb17: only these fields; the rest of the object is left as it is. */
static void reset_fields(D8Object *o)
{
    o->row = -1;
    o->slot_a = D8_NO_SLOT;
    o->slot_b = D8_NO_SLOT;
    o->dir = 0xffu;
    o->pos_43 = 0;
    o->pos_41 = 0;
    o->pressed = 0u;
    o->active = 0u;
    o->exit_clicked = 0u;
    o->borrowed = 0u;
    o->surface1 = 0u;
    o->surface2 = 0u;
}

int d8_validate_record(const uint8_t *record, size_t length, const char **failure)
{
    const char *why = NULL;
    if (record == NULL || length < D8_RECORD_FIXED_BYTES) {
        why = "0xd8 record shorter than its fixed part";
    } else {
        const int16_t count = rds16(record + REC_COUNT);
        if (count < 0 || (unsigned)count > D8_ENTRY_MAX) why = "0xd8 link count outside 0..100";
        else if (length != d8_record_bytes(count)) why = "0xd8 record length does not match its link count";
        else if (memchr(record + REC_NAME, 0, D8_NAME_BYTES) == NULL) why = "0xd8 name is not terminated";
        else if (memchr(record + REC_NAME2, 0, D8_NAME_BYTES) == NULL) why = "0xd8 second name is not terminated";
    }
    if (failure != NULL) *failure = why != NULL ? why : "none";
    return why == NULL ? D8_OK : D8_ERR_BODY;
}

/* 0x516530 (_stricmp, C locale): 0 when equal ignoring ASCII case. */
static int ascii_equal_nocase(const char *a, const char *b)
{
    for (;; ++a, ++b) {
        unsigned char x = (unsigned char)*a;
        unsigned char y = (unsigned char)*b;
        if (x >= 'A' && x <= 'Z') x = (unsigned char)(x + 0x20);
        if (y >= 'A' && y <= 'Z') y = (unsigned char)(y + 0x20);
        if (x != y) return 0;
        if (x == 0u) return 1;
    }
}

/* 0x50cb1b is the CRT atoi: leading white space, one sign, decimal digits, int32 wrap. */
static int32_t crt_atoi(const char *s)
{
    uint32_t value = 0u;
    int negative = 0;
    while (*s == ' ' || (*s >= '\t' && *s <= '\r')) ++s;
    if (*s == '-' || *s == '+') {
        negative = *s == '-';
        ++s;
    }
    while (*s >= '0' && *s <= '9') {
        value = value * 10u + (uint32_t)(*s - '0');
        ++s;
    }
    return (int32_t)(negative ? 0u - value : value);
}

typedef enum NameKind { NAME_NONE = 0, NAME_AUTOTEXT, NAME_LISTPAGE, NAME_FILE } NameKind;

/* 0x48c442..0x48c5e3: how the first surface is chosen. `index` is the text writer table index for the text kinds. */
static NameKind classify_name(const char *name, int32_t *index)
{
    static const char listpage[] = "USE_LISTPAGE";
    static const char autotext[] = "USE_AUTOTEXT";
    const size_t listpage_len = sizeof(listpage) - 1u;
    char prefix[D8_NAME_BYTES];
    size_t length = strlen(name);
    if (length >= 13u && memcmp(name, autotext, 12u) == 0 && name[12] >= '1' && name[12] <= '3' && name[13] == '\0') {
        *index = name[12] - '1';
        return NAME_AUTOTEXT;
    }
    /* The original copies strlen("USE_LISTPAGE") bytes into a zeroed buffer and compares 13 bytes with the literal. */
    memset(prefix, 0, sizeof(prefix));
    memcpy(prefix, name, length < listpage_len ? length : listpage_len);
    if (strcmp(prefix, listpage) == 0) {
        char rest[D8_NAME_BYTES];
        memset(rest, 0, sizeof(rest));
        memcpy(rest, name + listpage_len, length - listpage_len);
        *index = (int32_t)(2u + (uint32_t)crt_atoi(rest)); /* 32-bit wrap as the original add */
        return NAME_LISTPAGE;
    }
    return NAME_FILE;
}

static int fail(const char **failure, const char *why)
{
    if (failure != NULL) *failure = why;
    return D8_ERR_HOST;
}

static void record_rect(const uint8_t *record, uint32_t offset, int32_t out[4])
{
    for (unsigned i = 0u; i < 4u; ++i) out[i] = rds32(record + offset + 4u * i);
}

static int rect_empty(const int32_t r[4])
{
    return r[2] <= r[0] || r[3] <= r[1]; /* IsRectEmpty */
}

static int init_phase(D8Object *o, const uint8_t *record, int16_t row, const D8Host *host, D8Result *result,
                      const char **failure)
{
    const char *name = (const char *)(record + REC_NAME);
    const char *name2 = (const char *)(record + REC_NAME2);
    int32_t text_index = 0;
    NameKind kind = NAME_NONE;
    uint32_t text_surface = 0u;
    int32_t text_height = 0;
    int16_t slot = D8_NO_SLOT;
    uint32_t surface = 0u;

    if (host->alloc_slot == NULL || host->register_slot == NULL || host->set_slot_surface == NULL ||
        host->set_start_flag == NULL) {
        if (failure != NULL) *failure = "0xd8 slot or start flag callback missing";
        return D8_ERR_UNSUPPORTED;
    }
    if (o->surface1 == 0u) {
        kind = classify_name(name, &text_index);
        if (kind == NAME_FILE && host->load_surface == NULL) {
            if (failure != NULL) *failure = "0xd8 surface loader missing";
            return D8_ERR_UNSUPPORTED;
        }
        if (kind != NAME_FILE) {
            if (text_index < 0 || (unsigned)text_index >= D8_TEXT_SURFACES) {
                if (failure != NULL) *failure = "0xd8 text page outside the writer's six surfaces (native safety rejection)";
                return D8_ERR_BODY;
            }
            if (host->text_surface == NULL) {
                if (failure != NULL) *failure = "0xd8 text surface provider missing";
                return D8_ERR_UNSUPPORTED;
            }
        }
    }
    if (strlen(name2) != 0u && !ascii_equal_nocase(name, name2) && o->surface2 == 0u && host->load_surface == NULL) {
        if (failure != NULL) *failure = "0xd8 surface loader missing";
        return D8_ERR_UNSUPPORTED;
    }

    o->active = 1u;
    fx(host, D8_FX_ACTIVE, 1, 0);
    if (host->set_start_flag(host->context, 1) != 0) return fail(failure, "0xd8 start flag sink failed");
    fx(host, D8_FX_START_FLAG, 1, 0);
    o->row = row;
    fx(host, D8_FX_ROW, row, 0);
    o->exit_clicked = 0u;
    o->target_scene = D8_NO_SCENE;
    o->limit_4c = (int16_t)((uint32_t)rds32(record + REC_50) - (uint32_t)rds32(record + REC_SRC + 12));
    o->limit_4e = (int16_t)((uint32_t)rds32(record + REC_48) - (uint32_t)rds32(record + REC_SRC + 4));
    o->limit_48 = (int16_t)((uint32_t)rds32(record + REC_4C) - (uint32_t)rds32(record + REC_SRC + 8));
    o->limit_4a = (int16_t)((uint32_t)rds32(record + REC_44) - (uint32_t)rds32(record + REC_SRC));
    for (unsigned i = 0u; i < 4u; ++i) {
        int32_t rect[4];
        record_rect(record, REC_INACTIVE + 16u * i, rect);
        o->inactive_rect[i] = rect_empty(rect) ? 0u : 1u;
        record_rect(record, REC_DOWN + 16u * i, rect);
        o->down_rect[i] = rect_empty(rect) ? 0u : 1u;
        o->can_move[i] = 1u;
    }
    o->visible = 1u;

    if (host->alloc_slot(host->context, &slot) != 0) return fail(failure, "0xd8 first render entry allocation failed");
    o->slot_a = slot;
    fx(host, D8_FX_SLOT, slot, 0);
    if (host->register_slot(host->context, slot, o->surface1, LABEL_BITMAP) != 0)
        return fail(failure, "0xd8 first render entry registration failed");
    fx(host, D8_FX_SLOT_REGISTER, slot, (int32_t)o->surface1);

    if (o->surface1 == 0u) {
        if (kind == NAME_FILE) {
            if (host->load_surface(host->context, name, LABEL_SURFACE, &surface) != 0)
                return fail(failure, "0xd8 surface load failed");
            o->surface1 = surface;
            o->borrowed = 0u;
            fx(host, D8_FX_SURFACE_LOAD, (int32_t)surface, 0);
        } else {
            if (host->text_surface(host->context, text_index, &text_surface, &text_height) != 0)
                return fail(failure, "0xd8 text surface provider failed");
            o->surface1 = text_surface;
            o->borrowed = 1u;
            o->limit_4c = (int16_t)((uint32_t)text_height - (uint32_t)rds32(record + REC_SRC + 12));
            fx(host, D8_FX_TEXT_SURFACE, (int32_t)text_surface, text_index);
        }
    }
    if (host->set_slot_surface(host->context, o->slot_a, o->surface1) != 0)
        return fail(failure, "0xd8 first render entry surface store failed");
    fx(host, D8_FX_SLOT_SURFACE, o->slot_a, (int32_t)o->surface1);

    slot = D8_NO_SLOT;
    if (host->alloc_slot(host->context, &slot) != 0) return fail(failure, "0xd8 second render entry allocation failed");
    o->slot_b = slot;
    fx(host, D8_FX_SLOT, slot, 1);
    if (host->register_slot(host->context, slot, o->surface2, LABEL_OVERLAYS) != 0)
        return fail(failure, "0xd8 second render entry registration failed");
    fx(host, D8_FX_SLOT_REGISTER, slot, (int32_t)o->surface2);

    if (strlen(name2) == 0u || ascii_equal_nocase(name, name2)) {
        o->surface2 = o->surface1;
    } else if (o->surface2 == 0u) {
        if (host->load_surface(host->context, name2, LABEL_SURFACE, &surface) != 0)
            return fail(failure, "0xd8 second surface load failed");
        o->surface2 = surface;
        fx(host, D8_FX_SURFACE_LOAD, (int32_t)surface, 1);
    }
    if (host->set_slot_surface(host->context, o->slot_b, o->surface2) != 0)
        return fail(failure, "0xd8 second render entry surface store failed");
    fx(host, D8_FX_SLOT_SURFACE, o->slot_b, (int32_t)o->surface2);

    /* 0x48c757..0x48c7f3: the start position is clamped into the scroll limits (signed 16-bit compares). */
    if (o->pos_43 >= o->limit_4c) {
        o->pos_43 = o->limit_4c;
        o->can_move[1] = 0u;
    }
    if (o->pos_43 <= o->limit_4e) {
        o->pos_43 = o->limit_4e;
        o->can_move[0] = 0u;
    }
    if (o->pos_41 >= o->limit_48) {
        o->pos_41 = o->limit_48;
        o->can_move[3] = 0u;
    }
    if (o->pos_41 <= o->limit_4a) {
        o->pos_41 = o->limit_4a;
        o->can_move[2] = 0u;
    }
    result->phase_after = 1u;
    result->initialized = 1u;
    fx(host, D8_FX_PHASE, 1, 0);
    return D8_OK;
}

static int scroll_phase(D8Object *o, const uint8_t *record, const D8Host *host, D8Result *result,
                        const char **failure)
{
    const uint8_t fps = record[REC_FPS];
    uint32_t now;
    uint32_t period;
    if (fps == 0u) {
        if (failure != NULL) *failure = "0xd8 frame rate byte is zero (native safety rejection; the original divides by it)";
        return D8_ERR_BODY;
    }
    if (host->tick == NULL) {
        if (failure != NULL) *failure = "0xd8 tick provider missing";
        return D8_ERR_UNSUPPORTED;
    }
    now = host->tick(host->context);
    period = (uint32_t)(1000 / (int)fps);
    result->phase_after = 1u;
    if (now - o->tick < period) return D8_OK;
    {
        const uint16_t steps = (uint16_t)((now - o->tick) / period);
        switch (o->dir) {
        case 0u: o->pos_43 = (int16_t)(o->pos_43 - steps); o->can_move[1] = 1u; break;
        case 1u: o->pos_43 = (int16_t)(o->pos_43 + steps); o->can_move[0] = 1u; break;
        case 2u: o->pos_41 = (int16_t)(o->pos_41 - steps); o->can_move[3] = 1u; break;
        case 3u: o->pos_41 = (int16_t)(o->pos_41 + steps); o->can_move[2] = 1u; break;
        default: break;
        }
    }
    o->tick = now;
    fx(host, D8_FX_TICK, (int32_t)now, 0);
    /* 0x48c9d2: the first matching limit stops the scroll (the original's flags are named by their side). */
    if (o->dir == 1u && o->pos_43 >= o->limit_4c) {
        o->pos_43 = o->limit_4c;
        o->can_move[1] = 0u;
        o->dir = 0xffu;
    } else if (o->dir == 0u && o->pos_43 <= o->limit_4e) {
        o->pos_43 = o->limit_4e;
        o->can_move[0] = 0u;
        o->dir = 0xffu;
    } else if (o->dir == 3u && o->pos_41 >= o->limit_48) {
        o->pos_41 = o->limit_48;
        o->can_move[3] = 0u;
        o->dir = 0xffu;
    } else if (o->dir == 2u && o->pos_41 <= o->limit_4a) {
        o->pos_41 = o->limit_4a;
        o->can_move[2] = 0u;
        o->dir = 0xffu;
    }
    (void)failure;
    return D8_OK;
}

static int finish_phase(D8Object *o, const uint8_t *record, int16_t row, size_t event_flag_count,
                        const D8Host *host, D8Result *result, const char **failure)
{
    D8SceneChange change;
    int16_t flag_index = -1;
    int have_change = 0;
    int32_t start_flag = 1;
    if (host->set_start_flag == NULL || host->scene_change == NULL) {
        if (failure != NULL) *failure = "0xd8 start flag or scene change callback missing";
        return D8_ERR_UNSUPPORTED;
    }
    memset(&change, 0, sizeof(change));
    if (o->exit_clicked != 0u) {
        flag_index = rds16(record + REC_EXIT_FLAG);
        if (flag_index != -1 && (flag_index < 0 || (size_t)flag_index >= event_flag_count || host->set_event_flag == NULL)) {
            if (failure != NULL) *failure = "0xd8 exit event flag index outside the event flag table";
            return D8_ERR_BODY;
        }
        if (rds16(record + REC_EXIT_SCENE) != D8_NO_SCENE) {
            have_change = 1;
            change.scene = rds16(record + REC_EXIT_SCENE);
            change.word[0] = rds16(record + REC_EXIT_SCENE + 2);
            change.word[1] = rds16(record + REC_EXIT_SCENE + 4);
            change.word[2] = rds16(record + REC_EXIT_SCENE + 6);
            change.dword[0] = rds32(record + REC_EXIT_SCENE + 8);
            change.dword[1] = rds32(record + REC_EXIT_SCENE + 12);
            change.dword[2] = rds32(record + REC_EXIT_SCENE + 16);
            start_flag = rds16(record + REC_EXIT_SCENE + 20) == 1 ? 0 : 1;
        }
    } else if (o->target_scene != D8_NO_SCENE) {
        have_change = 1;
        change.scene = o->target_scene;
        change.word[2] = 1;
        change.dword[2] = 1;
    }

    if (host->set_start_flag(host->context, 1) != 0) return fail(failure, "0xd8 start flag sink failed");
    fx(host, D8_FX_START_FLAG, 1, 0);
    o->active = 0u;
    fx(host, D8_FX_ACTIVE, 0, 0);
    fx(host, D8_FX_CLEAR_5D1A8F, 0, 0);
    if (have_change) {
        if (host->scene_change(host->context, &change) != 0) return fail(failure, "0xd8 scene change was refused");
        fx(host, D8_FX_SCENE_CELLS, change.scene, 0);
        if (o->exit_clicked != 0u) {
            if (host->set_start_flag(host->context, start_flag) != 0) return fail(failure, "0xd8 start flag sink failed");
            fx(host, D8_FX_START_FLAG, start_flag, 1);
        }
        fx(host, D8_FX_ENGINE_MODE, 4, 0);
    }
    if (o->exit_clicked != 0u && flag_index != -1) {
        const int32_t value = (int32_t)record[REC_EXIT_FLAG + 2];
        if (host->set_event_flag(host->context, flag_index, value) != 0) return fail(failure, "0xd8 event flag store failed");
        fx(host, D8_FX_EVENT_FLAG, flag_index, value);
    }
    fx(host, D8_FX_COMPLETE, o->row, 0);
    result->finished = 1u;
    result->phase_after = 0u;
    (void)row;
    return d8_cleanup(o, host) == D8_OK ? D8_OK : fail(failure, "0xd8 cleanup failed");
}

int d8_step(D8Object *object, const uint8_t *record, size_t length, int16_t row, uint32_t phase,
            size_t event_flag_count, const D8Host *host, D8Result *result, const char **failure)
{
    const char *why = "none";
    int status;
    if (failure != NULL) *failure = "none";
    if (object == NULL || host == NULL || result == NULL) {
        if (failure != NULL) *failure = "0xd8 null argument";
        return D8_ERR_ARGUMENT;
    }
    status = d8_validate_record(record, length, &why);
    if (status != D8_OK) {
        if (failure != NULL) *failure = why;
        return status;
    }
    memset(result, 0, sizeof(*result));
    result->phase_after = phase;
    if (phase == 0u) return init_phase(object, record, row, host, result, failure);
    if (phase == 1u) return scroll_phase(object, record, host, result, failure);
    if (phase == 2u) return finish_phase(object, record, row, event_flag_count, host, result, failure);
    return D8_OK;
}

/* FL-12: original FUN_0048bb86 is this function (function ledger acceptance). */
int d8_cleanup(D8Object *o, const D8Host *host)
{
    if (o == NULL || host == NULL) return D8_ERR_ARGUMENT;
    if (host->release_surface == NULL || host->release_slot == NULL) return D8_ERR_UNSUPPORTED;
    if (o->surface2 != o->surface1) {
        if (host->release_surface(host->context, o->surface2) != 0) return D8_ERR_HOST;
        fx(host, D8_FX_RELEASE_SURFACE, (int32_t)o->surface2, 0);
        o->surface2 = 0u;
    }
    if (o->surface1 == 0u || o->borrowed != 0u) {
        if (o->surface1 != 0u && o->borrowed == 1u) o->surface1 = 0u;
    } else {
        if (host->release_surface(host->context, o->surface1) != 0) return D8_ERR_HOST;
        fx(host, D8_FX_RELEASE_SURFACE, (int32_t)o->surface1, 1);
        o->surface1 = 0u;
    }
    if (o->slot_a != D8_NO_SLOT) {
        if (host->release_slot(host->context, o->slot_a) != 0) return D8_ERR_HOST;
        fx(host, D8_FX_RELEASE_SLOT, o->slot_a, 0);
    }
    if (o->slot_b != D8_NO_SLOT) {
        if (host->release_slot(host->context, o->slot_b) != 0) return D8_ERR_HOST;
        fx(host, D8_FX_RELEASE_SLOT, o->slot_b, 1);
    }
    reset_fields(o);
    fx(host, D8_FX_RESET, 0, 0);
    return D8_OK;
}

/* FL-12: original FUN_0048bc38 is this function (function ledger acceptance). */
int d8_mark_dirty(D8Object *o, const D8Host *host)
{
    if (o == NULL || host == NULL) return D8_ERR_ARGUMENT;
    if (o->active != 0u && o->slot_a != D8_NO_SLOT && host->mark_dirty != NULL &&
        host->mark_dirty(host->context, o->slot_a) != 0)
        return D8_ERR_HOST;
    if (o->active != 0u && o->slot_b != D8_NO_SLOT && host->mark_dirty != NULL &&
        host->mark_dirty(host->context, o->slot_b) != 0)
        return D8_ERR_HOST;
    return D8_OK;
}

static uint32_t cursor_table(int32_t cursor, int32_t flag)
{
    return (uint32_t)(0x5b160c + (int64_t)cursor * 0x20 + (int64_t)flag * 0x10);
}

int d8_hit_test(D8Object *o, const uint8_t *record, size_t length, int16_t x, int16_t y, const D8HitInput *in,
                D8HitOutput *out)
{
    if (o == NULL || out == NULL) return D8_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    if (o->active == 0u) return D8_OK;
    if (record == NULL || in == NULL || d8_validate_record(record, length, NULL) != D8_OK) return D8_ERR_BODY;
    if (y >= rds32(record + REC_EXIT_RECT + 4) && y <= rds32(record + REC_EXIT_RECT + 12) &&
        x >= rds32(record + REC_EXIT_RECT) && x <= rds32(record + REC_EXIT_RECT + 8)) {
        out->hit = 1u;
        out->cursor_written = 1u;
        out->cursor_5b44f0 = 9;
        out->flag_5b44f4 = 1;
        out->has_5d162d = 1u;
        out->value_5d162d = in->value_5d0377;
        out->table_5d1631 = cursor_table(9, 1);
        out->flag_5d1639 = 1;
        out->candidate_5c39e5 = D8_CAND_EXIT;
        return D8_OK;
    }
    for (int16_t i = 0; i < 4; ++i) {
        const uint8_t *r = record + REC_BUTTON + 16u * (unsigned)i;
        o->hot = -1;
        if (y >= rds32(r + 4) && y <= rds32(r + 12) && x >= rds32(r) && x <= rds32(r + 8)) {
            if (in->item_583a29 != -1 && in->flag_5b44f8 == 0) {
                out->cursor_written = 1u;
                out->cursor_5b44f0 = (int32_t)in->item_583a29 + 0x25;
                out->has_5d162d = 1u;
                out->value_5d162d = in->value_571ad3;
            } else if (in->item_583a29 == -1 && in->flag_5b44f8 == 0) {
                out->cursor_written = 1u;
                out->cursor_5b44f0 = 0;
            }
            out->hit = 1u;
            out->flag_5b44f4 = 1;
            /* The table address uses the cursor value in memory: the one just written or the previous one. */
            out->table_5d1631 = cursor_table(out->cursor_written ? out->cursor_5b44f0 : in->cursor_5b44f0, 1);
            out->flag_5d1639 = 1;
            out->candidate_5c39e5 = D8_CAND_BUTTON;
            o->hot = i;
            return D8_OK;
        }
    }
    {
        const int16_t count = rds16(record + REC_COUNT);
        for (int16_t i = 0; i < count; ++i) {
            const uint8_t *e = record + REC_ENTRY + D8_ENTRY_BYTES * (unsigned)i;
            const int32_t oy = rds32(record + REC_DST + 4);
            const int32_t ox = rds32(record + REC_DST);
            o->hot = -1;
            if (y >= (int32_t)((uint32_t)rds32(e + 6) + (uint32_t)oy) && y <= (int32_t)((uint32_t)rds32(e + 14) + (uint32_t)oy) &&
                x >= (int32_t)((uint32_t)rds32(e + 2) + (uint32_t)ox) && x <= (int32_t)((uint32_t)rds32(e + 10) + (uint32_t)ox)) {
                out->hit = 1u;
                out->cursor_written = 1u;
                out->cursor_5b44f0 = 0;
                out->flag_5b44f4 = 1;
                out->table_5d1631 = cursor_table(0, 1);
                out->flag_5d1639 = 1;
                out->candidate_5c39e5 = D8_CAND_LINK;
                o->hot = i;
                return D8_OK;
            }
        }
    }
    return D8_OK;
}

int d8_click(D8Object *o, const uint8_t *record, size_t length, int32_t candidate, D8ClickOutput *out)
{
    if (o == NULL || out == NULL) return D8_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    if (candidate == D8_CAND_EXIT) {
        o->exit_clicked = 1u;
        out->phase_written = 1u;
        out->phase = 2u;
    } else if (candidate == D8_CAND_LINK) {
        if (record == NULL || d8_validate_record(record, length, NULL) != D8_OK || o->hot < 0 ||
            o->hot >= rds16(record + REC_COUNT))
            return D8_ERR_BODY;
        o->target_scene = rds16(record + REC_ENTRY + D8_ENTRY_BYTES * (unsigned)o->hot);
        out->phase_written = 1u;
        out->phase = 2u;
    }
    o->dir = 0xffu;
    o->pressed = 0u;
    return D8_OK;
}

int d8_press(D8Object *o, uint32_t row_phase, int32_t candidate, const D8Host *host)
{
    if (o == NULL) return D8_ERR_ARGUMENT;
    if (o->active != 0u && row_phase == 1u && candidate == D8_CAND_BUTTON && o->hot >= 0 && o->hot < 4 &&
        o->can_move[o->hot] != 0u) {
        if (o->pressed == 0u) {
            if (host == NULL || host->tick == NULL) return D8_ERR_UNSUPPORTED;
            o->tick = host->tick(host->context);
            fx(host, D8_FX_TICK, (int32_t)o->tick, 1);
        }
        o->dir = (uint8_t)o->hot;
        o->pressed = 1u;
    }
    return D8_OK;
}

static void shifted(const uint8_t *record, uint32_t offset, int32_t dx, int32_t dy, int32_t out[4])
{
    out[0] = (int32_t)((uint32_t)rds32(record + offset) + (uint32_t)dx);
    out[1] = (int32_t)((uint32_t)rds32(record + offset + 4) + (uint32_t)dy);
    out[2] = (int32_t)((uint32_t)rds32(record + offset + 8) + (uint32_t)dx);
    out[3] = (int32_t)((uint32_t)rds32(record + offset + 12) + (uint32_t)dy);
}

static void add_blit(D8RenderPlan *plan, D8BlitKind kind, D8Source source, const int32_t src[4], const int32_t dst[4],
                     const char *label)
{
    D8Blit *b = &plan->blit[plan->count++];
    b->kind = kind;
    b->source = source;
    memcpy(b->src, src, sizeof(b->src));
    memcpy(b->dst, dst, sizeof(b->dst));
    b->label = label;
}

int d8_render_plan(const D8Object *o, const uint8_t *record, size_t length, const D8View *view, D8RenderPlan *plan)
{
    int32_t src[4];
    int32_t dst[4];
    int32_t raw[4];
    if (o == NULL || plan == NULL || view == NULL) return D8_ERR_ARGUMENT;
    memset(plan, 0, sizeof(*plan));
    if (o->visible == 0u) return D8_OK;
    if (record == NULL || d8_validate_record(record, length, NULL) != D8_OK) return D8_ERR_BODY;
    plan->valid = 1u;
    src[0] = (int32_t)((uint32_t)rds32(record + REC_SRC) + (uint32_t)(int32_t)o->pos_41);
    src[1] = (int32_t)((uint32_t)rds32(record + REC_SRC + 4) + (uint32_t)(int32_t)o->pos_43);
    src[2] = (int32_t)((uint32_t)rds32(record + REC_SRC + 8) + (uint32_t)(int32_t)o->pos_41);
    src[3] = (int32_t)((uint32_t)rds32(record + REC_SRC + 12) + (uint32_t)(int32_t)o->pos_43);
    shifted(record, REC_DST, view->origin_x, view->origin_y, dst);
    if (record[REC_MODE] == MODE_RESTORE) {
        record_rect(record, REC_DST, raw);
        add_blit(plan, D8_BLIT_COPY, D8_SRC_SAVED_FRAME, raw, dst, "Peephole puzzle refresh");
        add_blit(plan, D8_BLIT_TRANS, D8_SRC_SLOT_A, src, dst, "Peephole puzzle view window");
    } else {
        add_blit(plan, D8_BLIT_COPY, D8_SRC_SLOT_A, src, dst, "Peephole puzzle view window");
    }
    for (unsigned i = 0u; i < 4u; ++i) {
        shifted(record, REC_BUTTON + 16u * i, view->origin_x, view->origin_y, dst);
        if (o->inactive_rect[i] != 0u && o->can_move[i] == 0u) {
            record_rect(record, REC_INACTIVE + 16u * i, raw);
            add_blit(plan, D8_BLIT_TRANS, D8_SRC_SLOT_B, raw, dst, "Peephole button inactive");
        } else if (o->pressed != 0u && o->down_rect[i] != 0u && i == o->dir) {
            record_rect(record, REC_DOWN + 16u * i, raw);
            add_blit(plan, D8_BLIT_TRANS, D8_SRC_SLOT_B, raw, dst, "Peephole button down");
        } else {
            record_rect(record, REC_BUTTON + 16u * i, raw);
            add_blit(plan, D8_BLIT_COPY, D8_SRC_SAVED_FRAME, raw, dst, "Peephole active button refresh");
        }
    }
    return D8_OK;
}
