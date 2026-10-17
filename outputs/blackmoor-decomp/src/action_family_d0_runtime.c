#include "action_family_d0_runtime.h"

#include <string.h>

/* Body offsets (see the header). */
enum {
    B_COUNT = 0x21,
    B_PRESSED = 0x23,
    B_KEYRECT = 0x113,
    B_HIT = 0x203,
    B_KIND_A = 0x2f3,
    B_REGION_A = 0x2f5,
    B_KIND_B = 0x305,
    B_REGION_B = 0x307,
    B_SOLUTION_LEN = 0x317,
    B_SOLUTION = 0x319,
    B_KEYS = 0x337,
    B_KEY_SOUND = D0_OFFSET_KEY_SOUND,
    B_KEY_CHANNEL = 0x736,
    B_SOLVED = 0x746,
    B_DELAY = 0x75f,
    B_WIN_SOUND = D0_OFFSET_WIN_SOUND,
    B_WIN_CHANNEL = 0x782,
    B_EXIT = 0x792,
    B_EXIT_RECT = 0x7ab
};

/* One key record: sound name, then text key. */
enum { KEY_STRIDE = 0x42, KEY_TEXT = 0x21 };

/* Offsets inside a scene block (solved block at 0x746, exit block at 0x792). */
enum { SB_SCENE = 0, SB_W1 = 2, SB_W2 = 4, SB_W3 = 6, SB_D1 = 8, SB_D2 = 12, SB_D3 = 16, SB_START = 20, SB_FLAG = 22, SB_VALUE = 24 };

static int16_t rd_s16(const uint8_t *b, size_t off)
{
    return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));
}

static int32_t rd_s32(const uint8_t *b, size_t off)
{
    return (int32_t)((uint32_t)b[off] | ((uint32_t)b[off + 1] << 8) | ((uint32_t)b[off + 2] << 16) |
                     ((uint32_t)b[off + 3] << 24));
}

static void fx(const D0Host *host, int effect, int32_t a, int32_t b)
{
    if (host->observe != NULL) host->observe(host->context, effect, a, b);
}

/* The 9-byte comparison against "NO SOUND\0" (repe cmpsb with ecx = 9). */
static int no_sound(const uint8_t *name)
{
    static const uint8_t k[9] = {'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0};
    return memcmp(name, k, sizeof k) == 0;
}

#define HOST(call) do { if ((call) != 0) { return D0_ERR_HOST; } } while (0)

void d0_object_reset(D0Object *object)
{
    memset(object, 0, sizeof(*object));
    object->slot = D0_NO_SLOT;
    object->row = -1;
}

int d0_validate_body(const uint8_t *body, size_t length, const char **failure)
{
    int16_t n;
    int16_t l;
    const char *why = NULL;
    if (body == NULL || length != D0_BODY_BYTES) {
        why = "0xd0-body-length";
    } else if (memchr(body, 0, D0_NAME_BYTES) == NULL) {
        why = "0xd0-name-unterminated";
    } else if ((n = rd_s16(body, B_COUNT)) < 0 || n > D0_MAX_KEYS) {
        why = "0xd0-key-count";
    } else if ((l = rd_s16(body, B_SOLUTION_LEN)) < 1 || l > D0_MAX_KEYS) {
        why = "0xd0-solution-length";
    } else {
        for (int16_t i = 0; i < n && why == NULL; ++i) {
            const uint8_t *rec = body + B_KEYS + (size_t)i * KEY_STRIDE;
            if (memchr(rec, 0, KEY_TEXT) == NULL)
                why = "0xd0-key-sound-unterminated";
            else if (memchr(rec + KEY_TEXT, 0, KEY_TEXT) == NULL)
                why = "0xd0-key-text-unterminated";
        }
    }
    if (failure != NULL) *failure = why;
    return why == NULL ? D0_OK : D0_ERR_BODY;
}

/* 0x48d89e. */
static void solved_check(D0Object *o, const uint8_t *body, const D0Host *host)
{
    const int16_t l = rd_s16(body, B_SOLUTION_LEN);
    int16_t i = 0;
    fx(host, D0_FX_SOLVED_CHECK, 0, 0);
    while (i < l && o->order[i] == rd_s16(body, B_SOLUTION + (size_t)i * 2u)) ++i;
    if (i >= l) {
        o->state = D0_STATE_START_WIN;
        fx(host, D0_FX_STATE, o->state, 0);
        o->solved = 1;
    }
}

/* The scene block shared by the solved and exit paths of phase 2. */
static int apply_block(const uint8_t *blk, D0World *world, const D0Host *host)
{
    if (rd_s16(blk, SB_SCENE) != D0_NO_SCENE) {
        D0Transition t;
        t.scene = rd_s16(blk, SB_SCENE);
        t.word[0] = rd_s16(blk, SB_W1);
        t.word[1] = rd_s16(blk, SB_W2);
        t.word[2] = rd_s16(blk, SB_W3);
        t.dword[0] = rd_s32(blk, SB_D1);
        t.dword[1] = rd_s32(blk, SB_D2);
        t.dword[2] = rd_s32(blk, SB_D3);
        HOST(host->transition(host->context, &t));
        fx(host, D0_FX_XFER_5BB57B, t.scene, 0);
        fx(host, D0_FX_XFER_5BB599, t.word[0], 0);
        fx(host, D0_FX_XFER_5BB595, t.word[1], 0);
        fx(host, D0_FX_XFER_5C39FF, t.word[2], 0);
        fx(host, D0_FX_XFER_5BB59B, t.dword[0], 0);
        fx(host, D0_FX_XFER_5BB59F, t.dword[1], 0);
        fx(host, D0_FX_XFER_5BB5A3, t.dword[2], 0);
        world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;
        fx(host, D0_FX_START_FLAG, world->start_flag_5bb1ca, 0);
        fx(host, D0_FX_ENGINE_MODE, 4, 0);
    }
    {
        const int16_t flag = rd_s16(blk, SB_FLAG);
        if (flag != D0_NO_FLAG) {
            HOST(host->store_event_flag(host->context, flag, blk[SB_VALUE]));
            fx(host, D0_FX_EVENT_FLAG, flag, blk[SB_VALUE]);
        }
    }
    return D0_OK;
}

/* 0x48d964: phase 0. */
static int phase0(D0Object *o, const uint8_t *body, int16_t row, D0World *world, const D0Host *host)
{
    o->row = row;
    o->active = 1;
    fx(host, D0_FX_ACTIVE, 1, 0);
    o->pressed = 0;
    o->check = 0;
    o->dirty = 0;
    o->surface = 0u;
    world->start_flag_5bb1ca = 1;
    fx(host, D0_FX_START_FLAG, 1, 0);
    HOST(host->clear_pending_item(host->context));
    fx(host, D0_FX_CLEAR_ITEM, 0, 0);
    /* Three dword stores, a word and a byte at +0x3d: the first 15 bytes of the order array. */
    for (int k = 0; k < 7; ++k) o->order[k] = 0;
    o->order[7] = (int16_t)(o->order[7] & (int16_t)0xff00);
    o->exit_taken = 0;
    o->solved = 0;
    if (body[0] == 0) {
        o->has_surface = 0;
    } else {
        int16_t slot = D0_NO_SLOT;
        o->has_surface = 1;
        HOST(host->alloc_slot(host->context, &slot));
        o->slot = slot;
        fx(host, D0_FX_SLOT, slot, 0);
        HOST(host->register_slot(host->context, slot, "PIANO PUZZLE OVERLAYS"));
        fx(host, D0_FX_SLOT_REGISTER, slot, 0);
        if (o->surface == 0u) {
            uint32_t surface = 0;
            HOST(host->load_surface(host->context, (const char *)body, &surface));
            o->surface = surface;
            fx(host, D0_FX_SURFACE_LOAD, (int32_t)surface, 0);
        }
        HOST(host->set_slot_surface(host->context, slot, o->surface));
        fx(host, D0_FX_SLOT_SURFACE, slot, (int32_t)o->surface);
    }
    o->state = D0_STATE_IDLE;
    fx(host, D0_FX_STATE, o->state, 0);
    return D0_OK;
}

/* 0x48db41: phase 1. */
static int phase1(D0Object *o, const uint8_t *body, uint32_t *row_phase, const D0Host *host)
{
    switch (o->state) {
    case D0_STATE_RELEASE: {
        const uint32_t now = host->tick(host->context);
        fx(host, D0_FX_TICK, (int32_t)now, 0);
        if (now >= o->deadline) {
            HOST(host->sound_stop(host->context, body + B_KEY_SOUND));
            fx(host, D0_FX_SOUND_STOP, B_KEY_SOUND, 0);
            o->state = D0_STATE_IDLE;
            fx(host, D0_FX_STATE, o->state, 0);
            o->dirty = 1;
            o->check = 1;
            o->pressed = 0;
        }
        break;
    }
    case D0_STATE_IDLE:
        if (o->has_surface == 0) solved_check(o, body, host);
        break;
    case D0_STATE_START_WIN: {
        const uint32_t now = host->tick(host->context);
        fx(host, D0_FX_TICK, (int32_t)now, 0);
        o->deadline = now + (uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1000);
        o->state = D0_STATE_WAIT_WIN;
        fx(host, D0_FX_STATE, o->state, 0);
        break;
    }
    case D0_STATE_WAIT_WIN: {
        const uint32_t now = host->tick(host->context);
        fx(host, D0_FX_TICK, (int32_t)now, 0);
        if (now >= o->deadline) {
            if (!no_sound(body + B_WIN_SOUND)) {
                const int16_t ch = rd_s16(body, B_WIN_CHANNEL);
                HOST(host->sound_prepare(host->context, body + B_WIN_SOUND));
                fx(host, D0_FX_SOUND_PREPARE, B_WIN_SOUND, 0);
                HOST(host->sound_play(host->context, ch));
                fx(host, D0_FX_SOUND_PLAY, ch, 0);
                o->state = D0_STATE_WIN_SOUND;
                fx(host, D0_FX_STATE, o->state, 0);
            } else {
                *row_phase = 2u;
                fx(host, D0_FX_PHASE, 2, 0);
            }
        }
        break;
    }
    case D0_STATE_WIN_SOUND: {
        const int16_t ch = rd_s16(body, B_WIN_CHANNEL);
        int32_t busy = 0;
        HOST(host->sound_busy(host->context, ch, &busy));
        fx(host, D0_FX_SOUND_BUSY, ch, busy);
        if (busy == 0) {
            HOST(host->sound_stop(host->context, body + B_WIN_SOUND));
            fx(host, D0_FX_SOUND_STOP, B_WIN_SOUND, 0);
            *row_phase = 2u;
            fx(host, D0_FX_PHASE, 2, 0);
        }
        break;
    }
    default:
        break;
    }
    return D0_OK;
}

/* 0x48dca9: phase 2. */
static int phase2(D0Object *o, const uint8_t *body, D0World *world, const D0Host *host)
{
    world->start_flag_5bb1ca = 1;
    fx(host, D0_FX_START_FLAG, 1, 0);
    if (o->exit_taken != 0) return apply_block(body + B_EXIT, world, host);
    if (o->solved != 0) return apply_block(body + B_SOLVED, world, host);
    return D0_OK;
}

static int host_complete(const D0Host *host)
{
    return host != NULL && host->alloc_slot != NULL && host->register_slot != NULL && host->load_surface != NULL &&
           host->set_slot_surface != NULL && host->release_surface != NULL && host->release_slot != NULL &&
           host->mark_dirty != NULL && host->view_origin != NULL && host->clear_pending_item != NULL &&
           host->sound_prepare != NULL && host->sound_stop != NULL && host->sound_play != NULL &&
           host->sound_busy != NULL && host->tick != NULL && host->text_lookup != NULL && host->text_show != NULL &&
           host->event_flag_invalid != NULL && host->transition != NULL && host->store_event_flag != NULL;
}

int d0_step(D0Object *object, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, D0World *world,
            const D0Host *host, D0Result *result, const char **failure)
{
    const char *why = NULL;
    uint32_t row_phase = phase;
    int rc;
    if (failure != NULL) *failure = NULL;
    if (object == NULL || body == NULL || world == NULL || result == NULL || !host_complete(host)) {
        if (failure != NULL) *failure = "0xd0-argument";
        return D0_ERR_ARGUMENT;
    }
    memset(result, 0, sizeof(*result));
    result->phase_after = phase;
    if (d0_validate_body(body, body_length, &why) != D0_OK) {
        if (failure != NULL) *failure = why;
        return D0_ERR_BODY;
    }
    if (phase == 0u) {
        if (row < 0) {
            if (failure != NULL) *failure = "0xd0-row";
            return D0_ERR_ARGUMENT;
        }
        rc = phase0(object, body, row, world, host);
        if (rc == D0_OK) {
            row_phase = 1u;
            fx(host, D0_FX_PHASE, 1, 0);
            result->initialized = 1u;
        }
    } else if (phase == 1u) {
        if (object->active == 0 || object->row != row) {
            if (failure != NULL) *failure = "0xd0-phase-1-without-init";
            return D0_ERR_UNSUPPORTED;
        }
        rc = phase1(object, body, &row_phase, host);
    } else if (phase == 2u) {
        if (object->active == 0 || object->row != row) {
            if (failure != NULL) *failure = "0xd0-phase-2-without-init";
            return D0_ERR_UNSUPPORTED;
        }
        /* Refuse before any effect when the finish block names a flag the host cannot store. */
        {
            const uint8_t *blk = object->exit_taken != 0 ? body + B_EXIT : (object->solved != 0 ? body + B_SOLVED : NULL);
            if (blk != NULL) {
                const int16_t flag = rd_s16(blk, SB_FLAG);
                if (flag != D0_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {
                    if (failure != NULL) *failure = "0xd0-event-flag-index";
                    return D0_ERR_BOUNDS;
                }
            }
        }
        rc = phase2(object, body, world, host);
        if (rc == D0_OK) {
            fx(host, D0_FX_COMPLETE, row, 0);
            result->completed = 1u;
            row_phase = 0u; /* 0x42ba3a stores phase 0 */
            rc = d0_cleanup(object, host);
        }
    } else {
        rc = D0_OK; /* 0x48d95f: any other phase falls out of the switch */
    }
    if (rc != D0_OK && failure != NULL && *failure == NULL) *failure = "0xd0-host";
    result->phase_after = row_phase;
    return rc;
}

static int in_rect(const uint8_t *body, size_t rect, int32_t x, int32_t y)
{
    return rd_s32(body, rect + 4) <= y && y <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= x &&
           x <= rd_s32(body, rect + 8);
}

/* 0x48d3cb: the cursor / candidate writer. */
static void cursor_write(D0Object *o, const uint8_t *body, int candidate, int16_t key, D0PointerResult *out)
{
    out->cursor_written = 1u;
    out->cursor_sub = 1;
    out->candidate = candidate;
    o->dirty = 1;
    if (candidate == D0_CANDIDATE_EXIT) {
        out->cursor_kind = D0_CURSOR_EXIT;
        o->hover = -1;
    } else {
        const size_t h = B_HIT + (size_t)key * 16u;
        const int32_t left = rd_s32(body, h), top = rd_s32(body, h + 4), right = rd_s32(body, h + 8),
                      bottom = rd_s32(body, h + 12);
        if (top >= rd_s32(body, B_REGION_A + 4) && bottom <= rd_s32(body, B_REGION_A + 12) &&
            left >= rd_s32(body, B_REGION_A) && right <= rd_s32(body, B_REGION_A + 8))
            out->cursor_kind = rd_s16(body, B_KIND_A);
        else if (top >= rd_s32(body, B_REGION_B + 4) && bottom <= rd_s32(body, B_REGION_B + 12) &&
                 left >= rd_s32(body, B_REGION_B) && right <= rd_s32(body, B_REGION_B + 8))
            out->cursor_kind = rd_s16(body, B_KIND_B);
        else
            out->cursor_kind = 0;
        if (o->pressed == 0) o->hover = key;
    }
}

int d0_pointer(D0Object *object, const uint8_t *body, size_t body_length, int32_t x, int32_t y, D0PointerResult *out)
{
    int16_t n;
    if (object == NULL || body == NULL || out == NULL || d0_validate_body(body, body_length, NULL) != D0_OK)
        return D0_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    if (object->active == 0) return D0_OK;
    x = (int16_t)x; /* movsx word */
    y = (int16_t)y;
    n = rd_s16(body, B_COUNT);
    if (object->pressed == 0 && in_rect(body, B_EXIT_RECT, x, y)) {
        cursor_write(object, body, D0_CANDIDATE_EXIT, 0, out);
        out->hit = 1u;
        return D0_OK;
    }
    for (int16_t i = 0; i < n; ++i) {
        if (in_rect(body, B_HIT + (size_t)i * 16u, x, y)) {
            cursor_write(object, body, D0_CANDIDATE_KEY, i, out);
            out->hit = 1u;
            return D0_OK;
        }
    }
    if (object->pressed != 0) {
        for (int16_t i = 0; i < n; ++i) {
            if (in_rect(body, B_KEYRECT + (size_t)i * 16u, x, y) && i == object->hover) {
                object->dirty = 1;
                return D0_OK;
            }
        }
    }
    return D0_OK;
}

int d0_click(D0Object *object, uint8_t *body, size_t body_length, uint32_t row_phase, int32_t candidate,
             int32_t start_flag, const D0Host *host, D0ClickResult *out)
{
    int16_t n;
    if (object == NULL || body == NULL || out == NULL || !host_complete(host) ||
        d0_validate_body(body, body_length, NULL) != D0_OK)
        return D0_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->new_phase = row_phase;
    if (!(object->active != 0 && object->state == D0_STATE_IDLE && row_phase == 1u)) return D0_OK;
    n = rd_s16(body, B_COUNT);
    if (candidate == D0_CANDIDATE_EXIT) {
        object->exit_taken = 1;
        out->exit_asked = 1u;
        out->new_phase = 2u;
        fx(host, D0_FX_PHASE, 2, 0);
    } else if (candidate == D0_CANDIDATE_KEY) {
        const int16_t l = rd_s16(body, B_SOLUTION_LEN);
        const int16_t key = object->hover;
        const uint8_t *rec;
        const char *text = NULL;
        if (key < 0 || key >= n) return D0_ERR_BOUNDS;
        out->key_pressed = 1u;
        if (object->has_surface != 0) object->pressed = 1;
        object->last = key;
        for (int16_t i = 0; i < l - 1; ++i) object->order[i] = object->order[i + 1];
        object->order[l - 1] = key;
        rec = body + B_KEYS + (size_t)key * KEY_STRIDE;
        memcpy(body + B_KEY_SOUND, rec, strlen((const char *)rec) + 1u);
        if (start_flag != 0 && !no_sound(body + B_KEY_SOUND)) {
            const int16_t ch = rd_s16(body, B_KEY_CHANNEL);
            int32_t busy = 0;
            HOST(host->sound_busy(host->context, ch, &busy));
            fx(host, D0_FX_SOUND_BUSY, ch, busy);
            if (busy == 0) {
                uint32_t now;
                HOST(host->sound_prepare(host->context, body + B_KEY_SOUND));
                fx(host, D0_FX_SOUND_PREPARE, B_KEY_SOUND, 0);
                HOST(host->sound_play(host->context, ch));
                fx(host, D0_FX_SOUND_PLAY, ch, 0);
                out->sound_played = 1u;
                object->dirty = 1;
                now = host->tick(host->context);
                fx(host, D0_FX_TICK, (int32_t)now, 0);
                object->deadline = now + 500u;
            }
        }
        HOST(host->text_lookup(host->context, (const char *)rec + KEY_TEXT, &text));
        fx(host, D0_FX_TEXT_LOOKUP, key, text != NULL ? 1 : 0);
        if (text != NULL) {
            const size_t len = strlen(text);
            if (len <= D0_TEXT_MAX) {
                char buf[D0_TEXT_LIMIT + 4u + 1u];
                if (len > D0_TEXT_LIMIT) return D0_ERR_BOUNDS;
                memcpy(buf, text, len);
                memcpy(buf + len, "<e>", 4); /* [0x54e898] is the dword "<e>\0", written over the terminator */
                HOST(host->text_show(host->context, buf));
                fx(host, D0_FX_TEXT_SHOW, (int32_t)(len + 3u), 0);
                out->text_shown = 1u;
            }
        }
    }
    return D0_OK;
}

int d0_invalidate(D0Object *object, const D0Host *host)
{
    if (object == NULL || host == NULL || host->mark_dirty == NULL) return D0_ERR_ARGUMENT;
    if (object->active != 0 && object->slot != D0_NO_SLOT) HOST(host->mark_dirty(host->context, object->slot));
    return D0_OK;
}

int d0_cleanup(D0Object *object, const D0Host *host)
{
    if (object == NULL || host == NULL || host->release_surface == NULL || host->release_slot == NULL)
        return D0_ERR_ARGUMENT;
    if (object->surface != 0u) {
        const uint32_t surface = object->surface;
        HOST(host->release_surface(host->context, surface));
        object->surface = 0u;
        fx(host, D0_FX_RELEASE_SURFACE, (int32_t)surface, 0);
    }
    if (object->slot != D0_NO_SLOT) {
        const int16_t slot = object->slot;
        HOST(host->release_slot(host->context, slot));
        fx(host, D0_FX_RELEASE_SLOT, slot, 0);
    }
    object->slot = D0_NO_SLOT; /* 0x48d067 */
    object->row = -1;
    object->active = 0;
    object->exit_taken = 0;
    object->solved = 0;
    return D0_OK;
}

int d0_render(D0Object *object, const uint8_t *body, size_t body_length, const D0Host *host, D0RenderResult *out)
{
    int32_t vx = 0, vy = 0;
    int16_t n;
    if (object == NULL || body == NULL || out == NULL || !host_complete(host) ||
        d0_validate_body(body, body_length, NULL) != D0_OK)
        return D0_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    if (object->slot == D0_NO_SLOT) return D0_OK;
    out->valid = 1u;
    if (object->dirty == 0 || object->has_surface == 0) return D0_OK;
    n = rd_s16(body, B_COUNT);
    if (object->pressed != 0 && object->hover != -1) {
        const int16_t key = object->hover;
        const size_t d = B_KEYRECT + (size_t)key * 16u;
        if (key < 0 || key >= n) return D0_ERR_BOUNDS;
        HOST(host->view_origin(host->context, &vx, &vy));
        out->blit = 1u;
        out->key = key;
        out->src_surface = object->surface;
        for (int k = 0; k < 4; ++k) out->src[k] = rd_s32(body, B_PRESSED + (size_t)key * 16u + (size_t)k * 4u);
        out->dst[0] = (int32_t)((uint32_t)rd_s32(body, d) + (uint32_t)vx);
        out->dst[1] = (int32_t)((uint32_t)rd_s32(body, d + 4) + (uint32_t)vy);
        out->dst[2] = (int32_t)((uint32_t)rd_s32(body, d + 8) + (uint32_t)vx);
        out->dst[3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);
        fx(host, D0_FX_BLIT, key, 1);
        object->state = D0_STATE_RELEASE;
        fx(host, D0_FX_STATE, object->state, 0);
    } else if (object->check != 0 && object->last != -1) {
        const int16_t key = object->last;
        const size_t d = B_KEYRECT + (size_t)key * 16u;
        if (key < 0 || key >= n) return D0_ERR_BOUNDS;
        HOST(host->view_origin(host->context, &vx, &vy));
        out->blit = 2u;
        out->key = key;
        out->src_surface = 0u; /* the host's generic entry 1 surface (0x5d15e3) */
        for (int k = 0; k < 4; ++k) out->src[k] = rd_s32(body, d + (size_t)k * 4u);
        out->dst[0] = (int32_t)((uint32_t)rd_s32(body, d) + (uint32_t)vx);
        out->dst[1] = (int32_t)((uint32_t)rd_s32(body, d + 4) + (uint32_t)vy);
        out->dst[2] = (int32_t)((uint32_t)rd_s32(body, d + 8) + (uint32_t)vx);
        out->dst[3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);
        fx(host, D0_FX_BLIT, key, 2);
        object->check = 0;
        out->solved_check = 1u;
        solved_check(object, body, host);
    }
    object->dirty = 0;
    return D0_OK;
}
