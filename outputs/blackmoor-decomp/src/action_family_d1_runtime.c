#include "action_family_d1_runtime.h"

#include <string.h>

/* Body offsets (see the header). */
enum {
    B_COUNT = 0x21,
    B_FRAMES = 0x23,
    B_SUBSTEPS = 0x25,
    B_INITIAL = 0x27,
    B_DST = 0x47,
    B_HIT = 0x147,
    B_ROW_FLAG = 0x247,
    B_ORIGIN_X = 0x248,
    B_ORIGIN_Y = 0x24c,
    B_TILE_W = 0x250,
    B_TILE_H = 0x252,
    B_LINKS = 0x254,
    B_PACE_T = 0x2d4,
    B_SOUND_FLAG = 0x2d6,
    B_PACE_M = 0x2d7,
    B_SOUND0 = 0x2d9,
    B_CHANNEL0 = 0x2fa,
    B_TARGET = 0x30a,
    B_WIN = 0x32a,
    B_SOUND1 = 0x345,
    B_CHANNEL1 = 0x366,
    B_EXIT = 0x376,
    B_EXIT_RECT = 0x38f
};

/* Offsets inside a scene block (win block at 0x32a, exit block at 0x376). */
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

static void fx(const D1Host *host, int effect, int32_t a, int32_t b)
{
    if (host->observe != NULL) host->observe(host->context, effect, a, b);
}

/* The 9-byte comparison against "NO SOUND\0" (repe cmpsb with ecx = 9). */
static int no_sound(const uint8_t *name)
{
    static const uint8_t k[9] = {'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0};
    return memcmp(name, k, sizeof k) == 0;
}

void d1_object_reset(D1Object *object)
{
    memset(object, 0, sizeof(*object));
    object->slot = D1_NO_SLOT;
    object->row = -1;
}

int d1_validate_body(const uint8_t *body, size_t length, const char **failure)
{
    int16_t n;
    const char *why = NULL;
    if (body == NULL || length != D1_BODY_BYTES) {
        why = "0xd1-body-length";
    } else if (memchr(body, 0, D1_NAME_BYTES) == NULL) {
        why = "0xd1-name-unterminated";
    } else if ((n = rd_s16(body, B_COUNT)) < 0 || n > D1_MAX_TILES) {
        why = "0xd1-tile-count";
    } else if (rd_s16(body, B_SUBSTEPS) == 0) {
        why = "0xd1-substeps-zero";
    } else {
        for (int16_t i = 0; i < n && why == NULL; ++i)
            for (int k = 0; k < 4; ++k) {
                const int16_t link = rd_s16(body, B_LINKS + (size_t)i * 8u + (size_t)k * 2u);
                if (link < 0 || link > D1_MAX_TILES) why = "0xd1-link-number";
            }
    }
    if (failure != NULL) *failure = why;
    return why == NULL ? D1_OK : D1_ERR_BODY;
}

/* 0x4b6355. All arithmetic is 32 bit, wrapping. */
void d1_geometry(const uint8_t *body, int16_t tile, int16_t frame, int16_t step, int32_t out[4])
{
    const uint32_t w = (uint32_t)(int32_t)rd_s16(body, B_TILE_W);
    const uint32_t h = (uint32_t)(int32_t)rd_s16(body, B_TILE_H);
    const uint32_t s = (uint32_t)(int32_t)rd_s16(body, B_SUBSTEPS);
    uint32_t x = (uint32_t)rd_s32(body, B_ORIGIN_X) + (uint32_t)(int32_t)frame * w * s + (uint32_t)(int32_t)step * w;
    uint32_t y = (uint32_t)rd_s32(body, B_ORIGIN_Y);
    if (body[B_ROW_FLAG] != 0) y += (uint32_t)(int32_t)tile * h;
    out[0] = (int32_t)x;
    out[2] = (int32_t)(x - 2u + w);
    out[1] = (int32_t)y;
    out[3] = (int32_t)(y - 2u + h);
}

static void set_src(D1Object *o, const uint8_t *body, int16_t i, int16_t frame, int16_t step)
{
    d1_geometry(body, i, frame, step, o->src[i]);
}

/* The scene block shared by the win and exit paths of phase 2. Returns the scene change as a request. */
static int block_scene(const uint8_t *blk) { return rd_s16(blk, SB_SCENE) != D1_NO_SCENE; }

static int apply_block(const uint8_t *blk, D1World *world, const D1Host *host)
{
    if (block_scene(blk)) {
        D1Transition t;
        t.scene = rd_s16(blk, SB_SCENE);
        t.word[0] = rd_s16(blk, SB_W1);
        t.word[1] = rd_s16(blk, SB_W2);
        t.word[2] = rd_s16(blk, SB_W3);
        t.dword[0] = rd_s32(blk, SB_D1);
        t.dword[1] = rd_s32(blk, SB_D2);
        t.dword[2] = rd_s32(blk, SB_D3);
        if (host->transition(host->context, &t) != 0) return D1_ERR_HOST;
        fx(host, D1_FX_XFER_5BB57B, t.scene, 0);
        fx(host, D1_FX_XFER_5BB599, t.word[0], 0);
        fx(host, D1_FX_XFER_5BB595, t.word[1], 0);
        fx(host, D1_FX_XFER_5C39FF, t.word[2], 0);
        fx(host, D1_FX_XFER_5BB59B, t.dword[0], 0);
        fx(host, D1_FX_XFER_5BB59F, t.dword[1], 0);
        fx(host, D1_FX_XFER_5BB5A3, t.dword[2], 0);
        world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;
        fx(host, D1_FX_START_FLAG, world->start_flag_5bb1ca, 0);
        fx(host, D1_FX_ENGINE_MODE, 4, 0);
    }
    {
        const int16_t flag = rd_s16(blk, SB_FLAG);
        if (flag != D1_NO_FLAG) {
            if (host->store_event_flag(host->context, flag, blk[SB_VALUE]) != 0) return D1_ERR_HOST;
            fx(host, D1_FX_EVENT_FLAG, flag, blk[SB_VALUE]);
        }
    }
    return D1_OK;
}

#define HOST(call) do { if ((call) != 0) { return D1_ERR_HOST; } } while (0)

static int play_turn_sound(const uint8_t *body, const D1Host *host)
{
    if (!no_sound(body + B_SOUND0)) {
        const int16_t ch = rd_s16(body, B_CHANNEL0);
        HOST(host->sound_play(host->context, ch));
        fx(host, D1_FX_SOUND_PLAY, ch, 0);
    }
    return D1_OK;
}

static int begin_turn(D1Object *o, const uint8_t *body, const D1Host *host, int16_t n)
{
    for (int16_t i = 0; i < n; ++i) o->moving[i] = 1;
    o->state = D1_STATE_ANIMATE;
    fx(host, D1_FX_STATE, o->state, 0);
    o->step = 1;
    o->counter = 0;
    return play_turn_sound(body, host);
}

static int phase0(D1Object *o, const uint8_t *body, int16_t row, D1World *world, const D1Host *host)
{
    const int16_t n = rd_s16(body, B_COUNT);
    int32_t vx = 0, vy = 0;
    int16_t slot = D1_NO_SLOT;
    if (host->view_origin(host->context, &vx, &vy) != 0) return D1_ERR_HOST;
    o->row = row;
    o->active = 1;
    fx(host, D1_FX_ACTIVE, 1, 0);
    world->start_flag_5bb1ca = 1;
    fx(host, D1_FX_START_FLAG, 1, 0);
    HOST(host->clear_pending_item(host->context));
    fx(host, D1_FX_CLEAR_ITEM, 0, 0);
    for (int k = 0; k < 8; ++k) o->frame[k] = 0; /* four dword stores at +0x254..+0x260 */
    for (int16_t i = 0; i < n; ++i) {
        const int16_t frame = rd_s16(body, B_INITIAL + (size_t)i * 2u);
        const size_t d = B_DST + (size_t)i * 16u;
        o->dst[i][1] = (int32_t)((uint32_t)rd_s32(body, d + 4) + (uint32_t)vy);
        o->dst[i][3] = (int32_t)((uint32_t)rd_s32(body, d + 12) + (uint32_t)vy);
        o->dst[i][0] = (int32_t)((uint32_t)rd_s32(body, d) + (uint32_t)vx);
        o->dst[i][2] = (int32_t)((uint32_t)rd_s32(body, d + 8) + (uint32_t)vx);
        o->frame[i] = frame;
        set_src(o, body, i, frame, 0);
    }
    o->dirty = 1;
    HOST(host->alloc_slot(host->context, &slot));
    o->slot = slot;
    fx(host, D1_FX_SLOT, slot, 0);
    HOST(host->register_slot(host->context, slot, "TURNING PUZZLE OVERLAYS"));
    fx(host, D1_FX_SLOT_REGISTER, slot, 0);
    if (o->surface == 0u) {
        uint32_t surface = 0;
        HOST(host->load_surface(host->context, (const char *)body, &surface));
        o->surface = surface;
        fx(host, D1_FX_SURFACE_LOAD, (int32_t)surface, 0);
    }
    HOST(host->set_slot_surface(host->context, slot, o->surface));
    fx(host, D1_FX_SLOT_SURFACE, slot, (int32_t)o->surface);
    if (!no_sound(body + B_SOUND0)) {
        HOST(host->sound_prepare(host->context, 0, body + B_SOUND0));
        fx(host, D1_FX_SOUND_PREPARE, 0, 0);
    }
    if (!no_sound(body + B_SOUND1)) {
        HOST(host->sound_prepare(host->context, 1, body + B_SOUND1));
        fx(host, D1_FX_SOUND_PREPARE, 1, 0);
    }
    o->solved = 0;
    o->exit_taken = 0;
    o->step = 1;
    o->state = D1_STATE_IDLE;
    return D1_OK;
}

/* 0x4b6dee: phase 2. */
static int phase2(D1Object *o, const uint8_t *body, D1World *world, const D1Host *host)
{
    world->start_flag_5bb1ca = 1;
    fx(host, D1_FX_START_FLAG, 1, 0);
    if (!no_sound(body + B_SOUND0)) {
        HOST(host->sound_stop(host->context, 0, body + B_SOUND0));
        fx(host, D1_FX_SOUND_STOP, 0, 0);
    }
    if (o->exit_taken == 0) {
        if (o->solved != 0) {
            const int rc = apply_block(body + B_WIN, world, host);
            if (rc != D1_OK) return rc;
        }
    } else {
        const int rc = apply_block(body + B_EXIT, world, host);
        if (rc != D1_OK) return rc;
    }
    return D1_OK;
}

static void moving_step(D1Object *o, const uint8_t *body, int16_t n, int *any)
{
    const int16_t frames = rd_s16(body, B_FRAMES);
    const int16_t substeps = rd_s16(body, B_SUBSTEPS);
    o->dirty = 1;
    for (int16_t i = 0; i < n; ++i) {
        if (o->moving[i] == 0) continue;
        if (o->step == substeps) {
            *any = 1;
            if ((int32_t)o->frame[i] == (int32_t)frames - 1) {
                set_src(o, body, i, 0, 0);
                o->frame[i] = 0;
            } else {
                set_src(o, body, i, o->frame[i], o->step);
                o->frame[i] = (int16_t)(o->frame[i] + 1);
            }
        } else {
            set_src(o, body, i, o->frame[i], o->step);
        }
    }
}

static int phase1(D1Object *o, const uint8_t *body, uint32_t *row_phase, const D1Host *host)
{
    const int16_t n = rd_s16(body, B_COUNT);
    switch (o->state) {
    case D1_STATE_IDLE:
        if (o->solved == 0) {
            /* 0x4b642d */
            int16_t i = 0;
            while (i < n && o->frame[i] == rd_s16(body, B_TARGET + (size_t)i * 2u)) ++i;
            if (i >= n) {
                o->solved = 1;
                o->state = D1_STATE_START_SOLVED;
                fx(host, D1_FX_STATE, o->state, 0);
            }
        } else {
            o->state = D1_STATE_AUTO;
            fx(host, D1_FX_STATE, o->state, 0);
        }
        break;
    case D1_STATE_START_SOLVED:
        if (no_sound(body + B_SOUND1)) {
            const int16_t ch = rd_s16(body, B_CHANNEL0);
            int32_t busy = 0;
            if (body[B_SOUND_FLAG] != 0) {
                HOST(host->sound_busy(host->context, ch, &busy));
                fx(host, D1_FX_SOUND_BUSY, ch, busy);
            }
            if (body[B_SOUND_FLAG] == 0 || busy != 0) {
                if (body[B_SOUND_FLAG] == 0) {
                    *row_phase = 2u;
                    fx(host, D1_FX_PHASE, 2, 0);
                }
            } else {
                const int rc = begin_turn(o, body, host, n);
                if (rc != D1_OK) return rc;
            }
        } else {
            const int16_t ch = rd_s16(body, B_CHANNEL1);
            HOST(host->sound_play(host->context, ch));
            fx(host, D1_FX_SOUND_PLAY, ch, 0);
            o->state = D1_STATE_WIN_SOUND;
            fx(host, D1_FX_STATE, o->state, 0);
        }
        break;
    case D1_STATE_ANIMATE: {
        int any = 0;
        const int16_t substeps = rd_s16(body, B_SUBSTEPS);
        moving_step(o, body, n, &any);
        if (any == 0) {
            const uint32_t now = host->tick(host->context);
            fx(host, D1_FX_TICK, (int32_t)now, 0);
            o->deadline = now + (uint32_t)(((int32_t)rd_s16(body, B_PACE_T) * 1000) / (int32_t)substeps);
            o->state = D1_STATE_WAIT;
            fx(host, D1_FX_STATE, o->state, 0);
            o->step = (int16_t)(o->step + 1);
        } else {
            o->state = D1_STATE_IDLE;
            fx(host, D1_FX_STATE, o->state, 0);
            o->step = 1;
            if (o->solved == 0)
                for (int16_t i = 0; i < n; ++i) o->moving[i] = 0;
        }
        break;
    }
    case D1_STATE_WAIT: {
        const uint32_t now = host->tick(host->context);
        fx(host, D1_FX_TICK, (int32_t)now, 0);
        if (o->deadline <= now) {
            o->state = D1_STATE_ANIMATE;
            fx(host, D1_FX_STATE, o->state, 0);
            if (o->solved != 0) {
                const int rc = play_turn_sound(body, host);
                if (rc != D1_OK) return rc;
            }
        }
        break;
    }
    case D1_STATE_AUTO: {
        const int32_t frames = rd_s16(body, B_FRAMES);
        if ((int32_t)o->frame[0] < frames - 1 ||
            (int32_t)o->counter < (int32_t)rd_s16(body, B_PACE_M) * (frames - 1) - 1) {
            const uint32_t now = host->tick(host->context);
            fx(host, D1_FX_TICK, (int32_t)now, 0);
            o->deadline = now + (uint32_t)(((int32_t)rd_s16(body, B_PACE_T) * 8000) / (int32_t)rd_s16(body, B_SUBSTEPS));
            o->state = D1_STATE_WAIT;
            fx(host, D1_FX_STATE, o->state, 0);
            o->counter = (uint8_t)(o->counter + 1u);
        } else {
            *row_phase = 2u;
            fx(host, D1_FX_PHASE, 2, 0);
        }
        break;
    }
    case D1_STATE_WIN_SOUND: {
        const int16_t ch = rd_s16(body, B_CHANNEL1);
        int32_t busy = 0;
        HOST(host->sound_busy(host->context, ch, &busy));
        fx(host, D1_FX_SOUND_BUSY, ch, busy);
        if (busy == 0) {
            HOST(host->sound_stop(host->context, 1, body + B_SOUND1));
            fx(host, D1_FX_SOUND_STOP, 1, 0);
            {
                const int16_t ch0 = rd_s16(body, B_CHANNEL0);
                int32_t busy0 = 0;
                if (body[B_SOUND_FLAG] != 0) {
                    HOST(host->sound_busy(host->context, ch0, &busy0));
                    fx(host, D1_FX_SOUND_BUSY, ch0, busy0);
                }
                if (body[B_SOUND_FLAG] == 0 || busy0 != 0) {
                    if (body[B_SOUND_FLAG] == 0) {
                        *row_phase = 2u;
                        fx(host, D1_FX_PHASE, 2, 0);
                    }
                } else {
                    const int rc = begin_turn(o, body, host, n);
                    if (rc != D1_OK) return rc;
                }
            }
        }
        break;
    }
    default:
        break;
    }
    return D1_OK;
}

static int host_complete(const D1Host *host)
{
    return host != NULL && host->alloc_slot != NULL && host->register_slot != NULL && host->load_surface != NULL &&
           host->set_slot_surface != NULL && host->release_surface != NULL && host->release_slot != NULL &&
           host->mark_dirty != NULL && host->view_origin != NULL && host->clear_pending_item != NULL &&
           host->sound_prepare != NULL && host->sound_stop != NULL && host->sound_play != NULL &&
           host->sound_busy != NULL && host->tick != NULL && host->event_flag_invalid != NULL &&
           host->transition != NULL && host->store_event_flag != NULL;
}

int d1_step(D1Object *object, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, D1World *world,
            const D1Host *host, D1Result *result, const char **failure)
{
    const char *why = NULL;
    uint32_t row_phase = phase;
    int rc;
    if (failure != NULL) *failure = NULL;
    if (object == NULL || body == NULL || world == NULL || result == NULL || !host_complete(host)) {
        if (failure != NULL) *failure = "0xd1-argument";
        return D1_ERR_ARGUMENT;
    }
    memset(result, 0, sizeof(*result));
    result->phase_after = phase;
    if (d1_validate_body(body, body_length, &why) != D1_OK) {
        if (failure != NULL) *failure = why;
        return D1_ERR_BODY;
    }
    if (phase == 0u) {
        if (row < 0) {
            if (failure != NULL) *failure = "0xd1-row";
            return D1_ERR_ARGUMENT;
        }
        rc = phase0(object, body, row, world, host);
        if (rc == D1_OK) {
            row_phase = 1u;
            fx(host, D1_FX_PHASE, 1, 0);
            result->initialized = 1u;
        }
    } else if (phase == 1u) {
        if (object->active == 0 || object->row != row) {
            if (failure != NULL) *failure = "0xd1-phase-1-without-init";
            return D1_ERR_UNSUPPORTED;
        }
        rc = phase1(object, body, &row_phase, host);
    } else if (phase == 2u) {
        if (object->active == 0 || object->row != row) {
            if (failure != NULL) *failure = "0xd1-phase-2-without-init";
            return D1_ERR_UNSUPPORTED;
        }
        /* Refuse before any effect when the finish block names a flag the host cannot store. */
        {
            const uint8_t *blk = object->exit_taken == 0 ? (object->solved != 0 ? body + B_WIN : NULL) : body + B_EXIT;
            if (blk != NULL) {
                const int16_t flag = rd_s16(blk, SB_FLAG);
                if (flag != D1_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {
                    if (failure != NULL) *failure = "0xd1-event-flag-index";
                    return D1_ERR_BOUNDS;
                }
            }
        }
        rc = phase2(object, body, world, host);
        if (rc == D1_OK) {
            fx(host, D1_FX_COMPLETE, row, 0);
            result->completed = 1u;
            row_phase = 0u; /* 0x42ba3a stores phase 0 */
            rc = d1_cleanup(object, host);
        }
    } else {
        rc = D1_OK; /* 0x4b64f4: any other phase falls out of the switch */
    }
    if (rc != D1_OK && failure != NULL && *failure == NULL) *failure = "0xd1-host";
    result->phase_after = row_phase;
    return rc;
}

int d1_pointer_move(D1Object *object, const uint8_t *body, size_t body_length, int16_t x, int16_t y,
                    D1PointerResult *out)
{
    int16_t n;
    if (object == NULL || body == NULL || out == NULL || d1_validate_body(body, body_length, NULL) != D1_OK)
        return D1_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    if (object->active == 0) return D1_OK;
    n = rd_s16(body, B_COUNT);
    object->last_tile = -1;
    for (int16_t i = 0; i < n; ++i) {
        if (object->moving[i] == 0)
            set_src(object, body, i, object->frame[i], 0);
        else
            set_src(object, body, i, object->frame[i], (int16_t)(object->step - 1));
        object->dirty = 1;
    }
    for (int16_t i = 0; i < n; ++i) {
        const size_t h = B_HIT + (size_t)i * 16u;
        if (rd_s32(body, h + 4) <= y && y <= rd_s32(body, h + 12) && rd_s32(body, h) <= x && x <= rd_s32(body, h + 8)) {
            /* 0x4b6097(0x276c, tile) */
            object->last_tile = i;
            out->hit = 1u;
            out->candidate = D1_CANDIDATE_TILE;
            out->cursor = D1_CURSOR_TILE;
            return D1_OK;
        }
    }
    if (rd_s32(body, B_EXIT_RECT + 4) <= y && y <= rd_s32(body, B_EXIT_RECT + 12) &&
        rd_s32(body, B_EXIT_RECT) <= x && x <= rd_s32(body, B_EXIT_RECT + 8)) {
        object->last_tile = -1; /* 0x4b6097(0x276d, 0) stores its second word, -1 */
        out->hit = 1u;
        out->candidate = D1_CANDIDATE_EXIT;
        out->cursor = D1_CURSOR_EXIT;
    }
    return D1_OK;
}

int d1_click(D1Object *object, const uint8_t *body, size_t body_length, uint32_t row_phase, int32_t candidate,
             int32_t start_flag, const D1Host *host, uint32_t *new_phase)
{
    int16_t n;
    if (object == NULL || body == NULL || new_phase == NULL || !host_complete(host) ||
        d1_validate_body(body, body_length, NULL) != D1_OK)
        return D1_ERR_ARGUMENT;
    *new_phase = row_phase;
    if (!(object->active != 0 && object->solved == 0 && object->state == D1_STATE_IDLE && row_phase == 1u)) return D1_OK;
    n = rd_s16(body, B_COUNT);
    if (candidate == D1_CANDIDATE_EXIT) {
        object->exit_taken = 1;
        *new_phase = 2u;
        fx(host, D1_FX_PHASE, 2, 0);
    } else if (candidate == D1_CANDIDATE_TILE) {
        const int16_t ch = rd_s16(body, B_CHANNEL0);
        int32_t busy = 0;
        if (object->last_tile < 0 || object->last_tile >= n) return D1_ERR_BOUNDS;
        HOST(host->sound_busy(host->context, ch, &busy));
        fx(host, D1_FX_SOUND_BUSY, ch, busy);
        if (busy == 0) {
            object->state = D1_STATE_ANIMATE;
            fx(host, D1_FX_STATE, object->state, 0);
            for (int16_t i = 0; i < n; ++i) object->moving[i] = (int16_t)(i == object->last_tile ? 1 : 0);
            for (int k = 0; k < 4; ++k) {
                const int16_t link = rd_s16(body, B_LINKS + (size_t)object->last_tile * 8u + (size_t)k * 2u);
                if (link != 0) object->moving[link - 1] = 1;
            }
            object->step = 1;
            if (start_flag != 0) {
                const int rc = play_turn_sound(body, host);
                if (rc != D1_OK) return rc;
            }
        }
    }
    return D1_OK;
}

/* FL-12: original FUN_004b5c11 is this function (function ledger acceptance). */
int d1_invalidate(D1Object *object, const D1Host *host)
{
    if (object == NULL || host == NULL || host->mark_dirty == NULL) return D1_ERR_ARGUMENT;
    if (object->active != 0 && object->slot != D1_NO_SLOT) HOST(host->mark_dirty(host->context, object->slot));
    return D1_OK;
}

/* FL-12: original FUN_004b5bc8 is this function (function ledger acceptance). */
int d1_cleanup(D1Object *object, const D1Host *host)
{
    if (object == NULL || host == NULL || host->release_surface == NULL || host->release_slot == NULL)
        return D1_ERR_ARGUMENT;
    if (object->surface != 0u) {
        const uint32_t surface = object->surface;
        HOST(host->release_surface(host->context, surface));
        object->surface = 0u;
        fx(host, D1_FX_RELEASE_SURFACE, (int32_t)surface, 0);
    }
    if (object->slot != D1_NO_SLOT) {
        const int16_t slot = object->slot;
        HOST(host->release_slot(host->context, slot));
        fx(host, D1_FX_RELEASE_SLOT, slot, 0);
    }
    object->slot = D1_NO_SLOT; /* 0x4b5b8a */
    object->row = -1;
    object->active = 0;
    object->exit_taken = 0;
    object->solved = 0;
    return D1_OK;
}

int d1_render_plan(const D1Object *object, const uint8_t *body, size_t body_length, D1RenderPlan *plan)
{
    int16_t n;
    if (object == NULL || body == NULL || plan == NULL || d1_validate_body(body, body_length, NULL) != D1_OK)
        return D1_ERR_ARGUMENT;
    memset(plan, 0, sizeof(*plan));
    if (object->slot == D1_NO_SLOT) return D1_OK;
    n = rd_s16(body, B_COUNT);
    plan->valid = 1u;
    plan->surface = object->surface;
    plan->count = n;
    for (int16_t i = 0; i < n; ++i) {
        memcpy(plan->src[i], object->src[i], sizeof(plan->src[i]));
        memcpy(plan->dst[i], object->dst[i], sizeof(plan->dst[i]));
    }
    return D1_OK;
}
