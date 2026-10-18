#include "action_family_aa_runtime.h"

#include <string.h>

/* Body offsets (see the header). */
enum {
    B_MINUTE_DST = 0x21,
    B_HOUR_DST = 0x31,
    B_AMPM_DST = 0x41,
    B_TIME_BTN = 0x51,
    B_ALARM_BTN = 0x61,
    B_SET_BTN = 0x71,
    B_CANCEL_BTN = 0x81,
    B_INCREASE_BTN = 0x91,
    B_DECREASE_BTN = 0xa1,
    B_LIGHT_DST = 0xb1,
    B_MINUTE_SRC = 0xc1,
    B_HOUR_SRC = 0x101,
    B_AM_SRC = 0x1c1,
    B_PM_SRC = 0x1d1,
    B_TIME_DOWN = 0x1e1,
    B_ALARM_DOWN = 0x1f1,
    B_SET_DOWN = 0x201,
    B_CANCEL_DOWN = 0x211,
    B_INCREASE_DOWN = 0x221,
    B_DECREASE_DOWN = 0x231,
    B_TIME_LIGHT = 0x241,
    B_ALARM_LIGHT = 0x251,
    B_PRESS_DELAY = 0x261,
    B_CURSOR_KIND = 0x263,
    B_BUTTON_SOUND = ALC_OFFSET_BUTTON_SOUND,
    B_BUTTON_CHANNEL = 0x286,
    B_SET_BLOCK = 0x296,
    B_FINAL_DELAY = 0x2af,
    B_FINAL_SOUND = ALC_OFFSET_FINAL_SOUND,
    B_FINAL_CHANNEL = 0x2d2,
    B_CANCEL_BLOCK = 0x2e2
};

/* Offsets inside a scene block (set block at 0x296, cancel block at 0x2e2). */
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

static void fx(const AlcHost *host, int effect, int32_t a, int32_t b)
{
    if (host->observe != NULL) host->observe(host->context, effect, a, b);
}

/* The 9-byte comparison against "NO SOUND\0" (repe cmpsb with ecx = 9). */
static int no_sound(const uint8_t *name)
{
    static const uint8_t k[9] = {'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0};
    return memcmp(name, k, sizeof k) == 0;
}

#define HOST(call) do { if ((call) != 0) { return ALC_ERR_HOST; } } while (0)

void alc_object_reset(AlcObject *object)
{
    memset(object, 0, sizeof(*object));
    object->slot = ALC_NO_SLOT;
    object->row = -1;
}

int alc_validate_body(const uint8_t *body, size_t length, const char **failure)
{
    const char *why = NULL;
    if (body == NULL || length != ALC_BODY_BYTES)
        why = "0xaa-body-length";
    else if (memchr(body, 0, ALC_NAME_BYTES) == NULL)
        why = "0xaa-name-unterminated";
    else if (memchr(body + B_BUTTON_SOUND, 0, ALC_NAME_BYTES) == NULL)
        why = "0xaa-button-sound-unterminated";
    else if (memchr(body + B_FINAL_SOUND, 0, ALC_NAME_BYTES) == NULL)
        why = "0xaa-final-sound-unterminated";
    if (failure != NULL) *failure = why;
    return why == NULL ? ALC_OK : ALC_ERR_BODY;
}

/* 0x44d711: the displayed time from the game clock words. */
static void read_time(AlcObject *o, const AlcWorld *world)
{
    const int32_t hour = world->hour_585d51;
    const int32_t minute = world->minute_585d4f;
    o->time_am = 1;
    if (hour == 0 || hour == 0x18) {
        o->time_hour = 0xb;
    } else if (hour == 0xc) {
        o->time_hour = 0xb;
        o->time_am = 0;
    } else if (hour < 0xc) {
        o->time_hour = (int16_t)(hour - 1);
    } else {
        o->time_hour = (int16_t)(hour - 0xd);
        o->time_am = 0;
    }
    if (minute >= 0 && minute <= 0xf)
        o->time_quarter = 0;
    else if (minute >= 0x10 && minute <= 0x1e)
        o->time_quarter = 1;
    else if (minute >= 0x1f && minute <= 0x2d)
        o->time_quarter = 2;
    else if (minute >= 0x2e && minute <= 0x3b)
        o->time_quarter = 3;
    o->alarm_am = o->time_am;
    if (o->time_quarter > 0) {
        o->alarm_quarter = 0;
        o->alarm_hour = (int16_t)(((int32_t)o->time_hour + 1) % 12);
        if (o->alarm_hour == 0xb) o->alarm_am = o->time_am == 0;
    } else {
        o->alarm_quarter = o->time_quarter;
        o->alarm_hour = o->time_hour;
    }
}

/* 0x44d8ad: step the alarm hour. */
static void step_hour(AlcObject *o, int increase)
{
    if (increase != 0) {
        o->alarm_hour = (int16_t)(((int32_t)o->alarm_hour + 1) % 12);
        if (o->alarm_hour == 0xb) o->alarm_am = o->alarm_am == 0;
    } else {
        if (o->alarm_hour == 0)
            o->alarm_hour = 0xb;
        else
            o->alarm_hour = (int16_t)(((int32_t)o->alarm_hour - 1) % 12);
        if (o->alarm_hour == 0xa) o->alarm_am = o->alarm_am == 0;
    }
}

/* 0x44d946: the alarm hour back into the game clock; the minute becomes 0. */
static void write_alarm(const AlcObject *o, AlcWorld *world, const AlcHost *host)
{
    int16_t hour;
    if (o->alarm_am == 0)
        hour = o->alarm_hour == 0xb ? 0xc : (int16_t)(o->alarm_hour + 0xd);
    else
        hour = o->alarm_hour == 0xb ? 0 : (int16_t)(o->alarm_hour + 1);
    world->hour_585d51 = hour;
    fx(host, ALC_FX_HOUR_STORE, hour, 0);
    world->minute_585d4f = 0;
    fx(host, ALC_FX_MINUTE_STORE, 0, 0);
}

/* The scene block shared by the set and cancel paths of phase 2. */
static int apply_block(const uint8_t *blk, AlcWorld *world, const AlcHost *host)
{
    if (rd_s16(blk, SB_SCENE) != ALC_NO_SCENE) {
        AlcTransition t;
        t.scene = rd_s16(blk, SB_SCENE);
        t.word[0] = rd_s16(blk, SB_W1);
        t.word[1] = rd_s16(blk, SB_W2);
        t.word[2] = rd_s16(blk, SB_W3);
        t.dword[0] = rd_s32(blk, SB_D1);
        t.dword[1] = rd_s32(blk, SB_D2);
        t.dword[2] = rd_s32(blk, SB_D3);
        HOST(host->transition(host->context, &t));
        fx(host, ALC_FX_XFER_5BB57B, t.scene, 0);
        fx(host, ALC_FX_XFER_5BB599, t.word[0], 0);
        fx(host, ALC_FX_XFER_5BB595, t.word[1], 0);
        fx(host, ALC_FX_XFER_5C39FF, t.word[2], 0);
        fx(host, ALC_FX_XFER_5BB59B, t.dword[0], 0);
        fx(host, ALC_FX_XFER_5BB59F, t.dword[1], 0);
        fx(host, ALC_FX_XFER_5BB5A3, t.dword[2], 0);
        world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;
        fx(host, ALC_FX_START_FLAG, world->start_flag_5bb1ca, 0);
        fx(host, ALC_FX_ENGINE_MODE, 4, 0);
    }
    {
        const int16_t flag = rd_s16(blk, SB_FLAG);
        if (flag != ALC_NO_FLAG) {
            HOST(host->store_event_flag(host->context, flag, blk[SB_VALUE]));
            fx(host, ALC_FX_EVENT_FLAG, flag, blk[SB_VALUE]);
        }
    }
    return ALC_OK;
}

/* 0x44da58: phase 0. */
static int phase0(AlcObject *o, const uint8_t *body, int16_t row, AlcWorld *world, const AlcHost *host)
{
    int16_t slot = ALC_NO_SLOT;
    o->row = row;
    o->active = 1;
    read_time(o, world);
    o->dirty = 1;
    world->start_flag_5bb1ca = 1;
    fx(host, ALC_FX_START_FLAG, 1, 0);
    o->restore = 0;
    o->state = ALC_STATE_TIME;
    o->over = 0;
    HOST(host->alloc_slot(host->context, &slot));
    o->slot = slot;
    fx(host, ALC_FX_SLOT, slot, 0);
    HOST(host->register_slot(host->context, slot, "ALARM CLOCK OVERLAYS"));
    fx(host, ALC_FX_SLOT_REGISTER, slot, 0);
    if (o->surface == 0u) {
        uint32_t surface = 0;
        HOST(host->load_surface(host->context, (const char *)body, &surface));
        o->surface = surface;
        fx(host, ALC_FX_SURFACE_LOAD, (int32_t)surface, 0);
    }
    HOST(host->set_slot_surface(host->context, slot, o->surface));
    fx(host, ALC_FX_SLOT_SURFACE, slot, (int32_t)o->surface);
    if (!no_sound(body + B_BUTTON_SOUND)) {
        HOST(host->sound_prepare(host->context, body + B_BUTTON_SOUND));
        fx(host, ALC_FX_SOUND_PREPARE, B_BUTTON_SOUND, 0);
    }
    o->set = 0;
    o->canceled = 0;
    return ALC_OK;
}

/* 0x44dc17: phase 1. */
static int phase1(AlcObject *o, const uint8_t *body, uint32_t *row_phase, const AlcHost *host)
{
    switch (o->state) {
    case ALC_STATE_CANCEL:
        o->canceled = 1;
        *row_phase = 2u;
        fx(host, ALC_FX_PHASE, 2, 0);
        break;
    case ALC_STATE_PRESSED: {
        const uint32_t now = host->tick(host->context);
        fx(host, ALC_FX_TICK, (int32_t)now, 0);
        if (now >= o->press_deadline) {
            o->state = o->button;
            o->restore = 1;
        }
        break;
    }
    case ALC_STATE_TIME:
    case ALC_STATE_ALARM:
        o->dirty = 1;
        break;
    case ALC_STATE_INCREASE:
    case ALC_STATE_DECREASE:
        step_hour(o, o->state == ALC_STATE_INCREASE);
        o->dirty = 1;
        o->state = ALC_STATE_ALARM;
        break;
    case ALC_STATE_SET: {
        const uint32_t now = host->tick(host->context);
        fx(host, ALC_FX_TICK, (int32_t)now, 0);
        o->final_deadline = now + (uint32_t)((int32_t)rd_s16(body, B_FINAL_DELAY) * 1000);
        o->set = 1;
        o->state = ALC_STATE_WAIT_SET;
        break;
    }
    case ALC_STATE_WAIT_SET: {
        const uint32_t now = host->tick(host->context);
        fx(host, ALC_FX_TICK, (int32_t)now, 0);
        if (now >= o->final_deadline) {
            if (!no_sound(body + B_FINAL_SOUND)) {
                const int16_t ch = rd_s16(body, B_FINAL_CHANNEL);
                HOST(host->sound_prepare(host->context, body + B_FINAL_SOUND));
                fx(host, ALC_FX_SOUND_PREPARE, B_FINAL_SOUND, 0);
                HOST(host->sound_play(host->context, ch));
                fx(host, ALC_FX_SOUND_PLAY, ch, 0);
                o->state = ALC_STATE_FINAL_SOUND;
            } else {
                *row_phase = 2u;
                fx(host, ALC_FX_PHASE, 2, 0);
            }
        }
        break;
    }
    case ALC_STATE_FINAL_SOUND: {
        const int16_t ch = rd_s16(body, B_FINAL_CHANNEL);
        int32_t busy = 0;
        HOST(host->sound_busy(host->context, ch, &busy));
        fx(host, ALC_FX_SOUND_BUSY, ch, busy);
        if (busy == 0) {
            HOST(host->sound_stop(host->context, body + B_FINAL_SOUND));
            fx(host, ALC_FX_SOUND_STOP, B_FINAL_SOUND, 0);
            *row_phase = 2u;
            fx(host, ALC_FX_PHASE, 2, 0);
        }
        break;
    }
    default:
        break;
    }
    return ALC_OK;
}

/* 0x44ddc4: phase 2. */
static int phase2(AlcObject *o, const uint8_t *body, AlcWorld *world, const AlcHost *host)
{
    world->start_flag_5bb1ca = 1;
    fx(host, ALC_FX_START_FLAG, 1, 0);
    if (!no_sound(body + B_BUTTON_SOUND)) {
        HOST(host->sound_stop(host->context, body + B_BUTTON_SOUND));
        fx(host, ALC_FX_SOUND_STOP, B_BUTTON_SOUND, 0);
    }
    if (o->canceled != 0) return apply_block(body + B_CANCEL_BLOCK, world, host);
    if (o->set != 0) {
        write_alarm(o, world, host);
        return apply_block(body + B_SET_BLOCK, world, host);
    }
    return ALC_OK;
}

static int host_complete(const AlcHost *host)
{
    return host != NULL && host->alloc_slot != NULL && host->register_slot != NULL && host->load_surface != NULL &&
           host->set_slot_surface != NULL && host->release_surface != NULL && host->release_slot != NULL &&
           host->mark_dirty != NULL && host->view_origin != NULL && host->sound_prepare != NULL &&
           host->sound_stop != NULL && host->sound_play != NULL && host->sound_busy != NULL && host->tick != NULL &&
           host->touch_idle_timer != NULL && host->event_flag_invalid != NULL && host->transition != NULL &&
           host->store_event_flag != NULL;
}

int alc_step(AlcObject *object, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, AlcWorld *world,
             const AlcHost *host, AlcResult *result, const char **failure)
{
    const char *why = NULL;
    uint32_t row_phase = phase;
    int rc;
    if (failure != NULL) *failure = NULL;
    if (object == NULL || body == NULL || world == NULL || result == NULL || !host_complete(host)) {
        if (failure != NULL) *failure = "0xaa-argument";
        return ALC_ERR_ARGUMENT;
    }
    memset(result, 0, sizeof(*result));
    result->phase_after = phase;
    if (alc_validate_body(body, body_length, &why) != ALC_OK) {
        if (failure != NULL) *failure = why;
        return ALC_ERR_BODY;
    }
    if (phase == 0u) {
        if (row < 0) {
            if (failure != NULL) *failure = "0xaa-row";
            return ALC_ERR_ARGUMENT;
        }
        rc = phase0(object, body, row, world, host);
        if (rc == ALC_OK) {
            row_phase = 1u;
            fx(host, ALC_FX_PHASE, 1, 0);
            result->initialized = 1u;
        }
    } else if (phase == 1u) {
        if (object->active == 0 || object->row != row) {
            if (failure != NULL) *failure = "0xaa-phase-1-without-init";
            return ALC_ERR_UNSUPPORTED;
        }
        rc = phase1(object, body, &row_phase, host);
    } else if (phase == 2u) {
        if (object->active == 0 || object->row != row) {
            if (failure != NULL) *failure = "0xaa-phase-2-without-init";
            return ALC_ERR_UNSUPPORTED;
        }
        /* Refuse before any effect when the finish block names a flag the host cannot store. */
        {
            const uint8_t *blk = object->canceled != 0 ? body + B_CANCEL_BLOCK : (object->set != 0 ? body + B_SET_BLOCK : NULL);
            if (blk != NULL) {
                const int16_t flag = rd_s16(blk, SB_FLAG);
                if (flag != ALC_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {
                    if (failure != NULL) *failure = "0xaa-event-flag-index";
                    return ALC_ERR_BOUNDS;
                }
            }
        }
        rc = phase2(object, body, world, host);
        if (rc == ALC_OK) {
            fx(host, ALC_FX_COMPLETE, object->row, 0);
            result->completed = 1u;
            row_phase = 0u; /* 0x42ba3a stores phase 0 */
            rc = alc_cleanup(object, host);
        }
    } else {
        rc = ALC_OK; /* 0x44da53: any other phase falls out of the switch */
    }
    if (rc != ALC_OK && failure != NULL && *failure == NULL) *failure = "0xaa-host";
    result->phase_after = row_phase;
    return rc;
}

static int in_rect(const uint8_t *body, size_t rect, int32_t x, int32_t y)
{
    return rd_s32(body, rect + 4) <= y && y <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= x &&
           x <= rd_s32(body, rect + 8);
}

/* 0x44d597: the button press writer. */
static void press(AlcObject *o, const uint8_t *body, int32_t button, AlcPointerResult *out)
{
    out->cursor_written = 1u;
    out->cursor_kind = rd_s16(body, B_CURSOR_KIND);
    out->cursor_sub = 1;
    out->candidate = ALC_CANDIDATE_BUTTON;
    o->dirty = 1;
    o->button = button;
}

/* FL-12: original FUN_0044d28c is this function (function ledger acceptance). */
int alc_pointer(AlcObject *object, const uint8_t *body, size_t body_length, int32_t x, int32_t y, AlcPointerResult *out)
{
    if (object == NULL || body == NULL || out == NULL || alc_validate_body(body, body_length, NULL) != ALC_OK)
        return ALC_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    if (object->active == 0) {
        object->dirty = 0;
        return ALC_OK;
    }
    x = (int16_t)x; /* movsx word */
    y = (int16_t)y;
    object->dirty = 1;
    if (x > rd_s32(body, B_INCREASE_BTN + 8) || y > rd_s32(body, B_CANCEL_BTN + 12) || x < rd_s32(body, B_TIME_BTN)) {
        object->over = 0;
        return ALC_OK;
    }
    object->over = 1;
    if (object->state == ALC_STATE_TIME && in_rect(body, B_ALARM_BTN, x, y)) {
        press(object, body, 1, out);
        out->hit = 1u;
        return ALC_OK;
    }
    if (object->state == ALC_STATE_ALARM) {
        static const struct { size_t rect; int32_t button; } order[] = {
            {B_TIME_BTN, 0}, {B_INCREASE_BTN, 3}, {B_DECREASE_BTN, 4}, {B_SET_BTN, 6}};
        for (size_t i = 0; i < sizeof(order) / sizeof(order[0]); ++i) {
            if (in_rect(body, order[i].rect, x, y)) {
                press(object, body, order[i].button, out);
                out->hit = 1u;
                return ALC_OK;
            }
        }
    }
    if (in_rect(body, B_CANCEL_BTN, x, y)) {
        press(object, body, 8, out);
        out->hit = 1u;
        return ALC_OK;
    }
    if (in_rect(body, B_MINUTE_DST, x, y) || in_rect(body, B_HOUR_DST, x, y) || in_rect(body, B_LIGHT_DST, x, y)) {
        object->dirty = 1;
        return ALC_OK;
    }
    object->dirty = 0;
    return ALC_OK;
}

int alc_click(AlcObject *object, const uint8_t *body, size_t body_length, uint32_t row_phase, const AlcWorld *world,
              const AlcHost *host, AlcClickResult *out)
{
    if (object == NULL || body == NULL || world == NULL || out == NULL || !host_complete(host) ||
        alc_validate_body(body, body_length, NULL) != ALC_OK)
        return ALC_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    if (!(object->active != 0 && object->canceled == 0 && object->over != 0 && row_phase == 1u)) return ALC_OK;
    if (world->start_flag_5bb1ca != 0 && !no_sound(body + B_BUTTON_SOUND)) {
        const int16_t ch = rd_s16(body, B_BUTTON_CHANNEL);
        int32_t busy = 0;
        HOST(host->sound_busy(host->context, ch, &busy));
        fx(host, ALC_FX_SOUND_BUSY, ch, busy);
        if (busy == 0) {
            HOST(host->sound_play(host->context, ch));
            fx(host, ALC_FX_SOUND_PLAY, ch, 0);
            out->sound_played = 1u;
        }
    }
    object->state = ALC_STATE_PRESSED;
    {
        const uint32_t now = host->tick(host->context);
        fx(host, ALC_FX_TICK, (int32_t)now, 0);
        object->press_deadline = now + (uint32_t)((int32_t)rd_s16(body, B_PRESS_DELAY) * 100);
    }
    object->dirty = 1;
    out->fired = 1u;
    return ALC_OK;
}

/* FL-12: original FUN_0044d19d is this function (function ledger acceptance). */
int alc_invalidate(AlcObject *object, const AlcHost *host)
{
    if (object == NULL || host == NULL || host->mark_dirty == NULL) return ALC_ERR_ARGUMENT;
    if (object->active != 0 && object->slot != ALC_NO_SLOT) HOST(host->mark_dirty(host->context, object->slot));
    return ALC_OK;
}

/* FL-12: original FUN_0044d154 is this function (function ledger acceptance). */
int alc_cleanup(AlcObject *object, const AlcHost *host)
{
    if (object == NULL || host == NULL || host->release_surface == NULL || host->release_slot == NULL ||
        host->touch_idle_timer == NULL)
        return ALC_ERR_ARGUMENT;
    if (object->surface != 0u) {
        const uint32_t surface = object->surface;
        HOST(host->release_surface(host->context, surface));
        object->surface = 0u;
        fx(host, ALC_FX_RELEASE_SURFACE, (int32_t)surface, 0);
    }
    if (object->slot != ALC_NO_SLOT) {
        const int16_t slot = object->slot;
        HOST(host->release_slot(host->context, slot));
        fx(host, ALC_FX_RELEASE_SLOT, slot, 0);
    }
    object->row = -1; /* 0x44d107 */
    object->slot = ALC_NO_SLOT;
    object->active = 0;
    object->canceled = 0;
    object->set = 0;
    HOST(host->touch_idle_timer(host->context));
    fx(host, ALC_FX_IDLE_TIMER, 0, 0);
    return ALC_OK;
}

/* FL-12: original FUN_0044d9b5 is inlined in this function (function ledger acceptance). */
static void add_blit(AlcRenderResult *out, int kind, uint32_t surface, const uint8_t *body, size_t src, size_t dst,
                     int32_t vx, int32_t vy)
{
    AlcBlit *b = &out->blit[out->count++];
    b->kind = kind;
    b->src_surface = surface;
    for (int k = 0; k < 4; ++k) b->src[k] = rd_s32(body, src + (size_t)k * 4u);
    b->dst[0] = (int32_t)((uint32_t)rd_s32(body, dst) + (uint32_t)vx);
    b->dst[1] = (int32_t)((uint32_t)rd_s32(body, dst + 4) + (uint32_t)vy);
    b->dst[2] = (int32_t)((uint32_t)rd_s32(body, dst + 8) + (uint32_t)vx);
    b->dst[3] = (int32_t)((uint32_t)rd_s32(body, dst + 12) + (uint32_t)vy);
}

/* FL-12: original FUN_0044e035 is this function (function ledger acceptance). */
int alc_render(AlcObject *object, const uint8_t *body, size_t body_length, const AlcHost *host, AlcRenderResult *out)
{
    int32_t vx = 0, vy = 0;
    int showing_time;
    int16_t hour, quarter;
    int32_t am;
    if (object == NULL || body == NULL || out == NULL || !host_complete(host) ||
        alc_validate_body(body, body_length, NULL) != ALC_OK)
        return ALC_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    if (object->slot == ALC_NO_SLOT) return ALC_OK;
    out->valid = 1u;
    showing_time = object->state == ALC_STATE_TIME || object->state == ALC_STATE_CANCEL ||
                   (object->state == ALC_STATE_PRESSED && object->button == ALC_STATE_CANCEL);
    hour = showing_time ? object->time_hour : object->alarm_hour;
    quarter = showing_time ? object->time_quarter : object->alarm_quarter;
    am = showing_time ? object->time_am : object->alarm_am;
    if (hour < 0 || hour > 11 || quarter < 0 || quarter > 3) return ALC_ERR_BOUNDS;
    HOST(host->view_origin(host->context, &vx, &vy));
    add_blit(out, am != 0 ? ALC_BLIT_AM : ALC_BLIT_PM, object->surface, body, am != 0 ? B_AM_SRC : B_PM_SRC, B_AMPM_DST,
             vx, vy);
    add_blit(out, showing_time ? ALC_BLIT_LIGHT_TIME : ALC_BLIT_LIGHT_ALARM, object->surface, body,
             showing_time ? B_TIME_LIGHT : B_ALARM_LIGHT, B_LIGHT_DST, vx, vy);
    add_blit(out, ALC_BLIT_HOUR, object->surface, body, B_HOUR_SRC + (size_t)hour * 16u, B_HOUR_DST, vx, vy);
    add_blit(out, ALC_BLIT_MINUTE, object->surface, body, B_MINUTE_SRC + (size_t)quarter * 16u, B_MINUTE_DST, vx, vy);
    if (object->state == ALC_STATE_PRESSED) {
        switch (object->button) {
        case 0: add_blit(out, ALC_BLIT_DOWN_TIME, object->surface, body, B_TIME_DOWN, B_TIME_BTN, vx, vy); break;
        case 1: add_blit(out, ALC_BLIT_DOWN_ALARM, object->surface, body, B_ALARM_DOWN, B_ALARM_BTN, vx, vy); break;
        case 3: add_blit(out, ALC_BLIT_DOWN_INCREASE, object->surface, body, B_INCREASE_DOWN, B_INCREASE_BTN, vx, vy); break;
        case 4: add_blit(out, ALC_BLIT_DOWN_DECREASE, object->surface, body, B_DECREASE_DOWN, B_DECREASE_BTN, vx, vy); break;
        case 6: add_blit(out, ALC_BLIT_DOWN_SET, object->surface, body, B_SET_DOWN, B_SET_BTN, vx, vy); break;
        case 8: add_blit(out, ALC_BLIT_DOWN_CANCEL, object->surface, body, B_CANCEL_DOWN, B_CANCEL_BTN, vx, vy); break;
        default: break;
        }
    } else if (object->restore != 0) {
        static const struct { int kind; size_t rect; } up[] = {
            {ALC_BLIT_UP_CANCEL, B_CANCEL_BTN}, {ALC_BLIT_UP_ALARM, B_ALARM_BTN}, {ALC_BLIT_UP_TIME, B_TIME_BTN},
            {ALC_BLIT_UP_SET, B_SET_BTN}, {ALC_BLIT_UP_INCREASE, B_INCREASE_BTN}, {ALC_BLIT_UP_DECREASE, B_DECREASE_BTN}};
        for (size_t i = 0; i < sizeof(up) / sizeof(up[0]); ++i) add_blit(out, up[i].kind, 0u, body, up[i].rect, up[i].rect, vx, vy);
        object->restore = 0;
    }
    for (uint8_t i = 0; i < out->count; ++i) fx(host, ALC_FX_BLIT, out->blit[i].kind, 0);
    object->dirty = 0;
    return ALC_OK;
}
