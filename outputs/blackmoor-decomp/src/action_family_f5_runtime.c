#include "action_family_f5_runtime.h"

#include <string.h>

/* Body offsets (see the header). */
enum {
    B_VARIANTS = 0x21,
    B_VARIANT_RECT = 0x23,
    B_POP_RECT = 0x163,
    B_POSITIONS = 0x173,
    B_POSITION_RECT = 0x175,
    B_SCORE_DIGITS = 0x2b5,
    B_CLOCK_DIGITS = 0x355,
    B_COLON = 0x3f5,
    B_SCORE_X = 0x405,
    B_SCORE_Y = 0x409,
    B_SCORE_GAP = 0x415,
    B_CLOCK_X = 0x40d,
    B_CLOCK_Y = 0x411,
    B_CLOCK_GAP = 0x419,
    B_PASSED_RECT = 0x41d,
    B_END_DELAY = 0x42d,
    B_CASE_SENSITIVE = 0x431,
    B_DIGITS = 0x432,
    B_WIDE = 0x433,
    B_EXTRA = 0x434,
    B_EXTRA_BYTES = 30,
    B_LIFE_MIN = 0x452,
    B_LIFE_MAX = 0x454,
    B_COUNT_MIN = 0x456,
    B_COUNT_MAX = 0x458,
    B_TIME_LIMIT = 0x45a,
    B_FACTOR = 0x45c,
    B_MIN_SCORE = 0x45e,
    B_DEFAULT_TARGET = 0x460,
    B_TARGET_PERCENT = 0x462,
    B_TARGET_LOW = 0x464,
    B_SOUND_A = TQZ_OFFSET_SOUND_A,
    B_CHANNEL_HIT = 0x487,
    B_SOUND_B = TQZ_OFFSET_SOUND_B,
    B_CHANNEL_MISS = 0x4b8,
    B_SOUND_C = TQZ_OFFSET_SOUND_C,
    B_CHANNEL_TIMEOUT = 0x4e9,
    B_PASSED = 0x4f9,
    B_SOUND_D = TQZ_OFFSET_SOUND_D,
    B_CHANNEL_D = 0x532,
    B_NORMAL = 0x542,
    B_CURSOR = 0x55c,
    B_RECT = 0x55e
};

/* Offsets inside a scene block (passed block at 0x4f9, normal block at 0x542). */
enum { SB_SCENE = 0, SB_W1 = 2, SB_W2 = 4, SB_W3 = 6, SB_D1 = 8, SB_D2 = 12, SB_D3 = 16, SB_START = 20, SB_FLAG = 22, SB_FLAG2 = 24 };

static int16_t rd_s16(const uint8_t *b, size_t off)
{
    return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));
}

static int32_t rd_s32(const uint8_t *b, size_t off)
{
    return (int32_t)((uint32_t)b[off] | ((uint32_t)b[off + 1] << 8) | ((uint32_t)b[off + 2] << 16) |
                     ((uint32_t)b[off + 3] << 24));
}

/* Wrapping 32-bit arithmetic: the original adds and multiplies without overflow checks. */
static int32_t add32(int32_t a, int32_t b)
{
    return (int32_t)((uint32_t)a + (uint32_t)b);
}

static int32_t sub32(int32_t a, int32_t b)
{
    return (int32_t)((uint32_t)a - (uint32_t)b);
}

static int32_t mul32(int32_t a, int32_t b)
{
    return (int32_t)((uint32_t)a * (uint32_t)b);
}

static void fx(const TqzHost *host, int effect, int32_t a, int32_t b)
{
    if (host->observe != NULL) host->observe(host->context, effect, a, b);
}

/* The 9-byte comparison against "NO SOUND\0" (repe cmpsb with ecx = 9). */
static int no_sound(const uint8_t *name)
{
    static const uint8_t k[9] = {'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0};
    return memcmp(name, k, sizeof k) == 0;
}

#define HOST(call) do { if ((call) != 0) { return TQZ_ERR_HOST; } } while (0)
#define CHECK(call) do { int rc_ = (call); if (rc_ != TQZ_OK) { return rc_; } } while (0)

static int16_t sound_channel(const uint8_t *body, size_t off)
{
    return rd_s16(body, off);
}

/* Prepare the sound record at `off` unless it is "NO SOUND". */
static int sound_prepare_if(const uint8_t *body, size_t off, const TqzHost *host)
{
    if (!no_sound(body + off)) {
        HOST(host->sound_prepare(host->context, body + off));
        fx(host, TQZ_FX_SOUND_PREPARE, (int32_t)off, 0);
    }
    return TQZ_OK;
}

static int sound_stop_if(const uint8_t *body, size_t off, const TqzHost *host)
{
    if (!no_sound(body + off)) {
        HOST(host->sound_stop(host->context, body + off));
        fx(host, TQZ_FX_SOUND_STOP, (int32_t)off, 0);
    }
    return TQZ_OK;
}

static int play(const TqzHost *host, int16_t channel)
{
    HOST(host->sound_play(host->context, channel));
    fx(host, TQZ_FX_SOUND_PLAY, channel, 0);
    return TQZ_OK;
}

static int tick(const TqzHost *host, uint32_t *out)
{
    *out = host->tick(host->context);
    fx(host, TQZ_FX_TICK, (int32_t)*out, 0);
    return TQZ_OK;
}

/* _rand (0..32767). */
static int rnd(const TqzHost *host, int32_t *out)
{
    const int32_t v = host->random(host->context);
    if (v < 0 || v > 32767) return TQZ_ERR_HOST;
    fx(host, TQZ_FX_RANDOM, v, 0);
    *out = v;
    return TQZ_OK;
}

void tqz_object_reset(TqzObject *object)
{
    memset(object, 0, sizeof(*object));
    object->slot = TQZ_NO_SLOT;
    object->row = -1;
    object->score_block[44] = -1;
    object->clock_block[48] = -1;
}

/* FL-12: original FUN_004b8087 is this function (function ledger acceptance). */
void tqz_world_new_game(TqzWorld *world)
{
    world->played_5a4c0a = 0;
    world->best_5a4c0e = 0;
}

int tqz_key_filter(int8_t ch)
{
    static const uint8_t extra[] = {0xe0, 0xe7, 0xe8, 0xe9, 0xea, 0xeb, 0xf4, 0xc0, 0xe2, 0xee, 0xf9, 0xc4, 0xe4, 0xd6,
                                    0xf6, 0xdc, 0xfc, 0xa1, 0xbf, 0xd1, 0xf1, 0xc9, 0xe1, 0xed, 0xf3, 0xfa, 0xdf};
    static const char punct[] = "\b\r .,?!/$()&:;+%=-";
    const uint8_t u = (uint8_t)ch;
    if ((u >= 'A' && u <= 'Z') || (u >= 'a' && u <= 'z') || (u >= '0' && u <= '9')) return 1;
    for (size_t i = 0; i + 1 < sizeof punct; ++i) {
        if (u == (uint8_t)punct[i]) return 1;
    }
    for (size_t i = 0; i < sizeof extra; ++i) {
        if (u == extra[i]) return 1;
    }
    return 0;
}

int tqz_validate_body(const uint8_t *body, size_t length, const char **failure)
{
    const char *why = NULL;
    if (body == NULL || length != TQZ_BODY_BYTES) {
        why = "0xf5-body-length";
    } else if (memchr(body, 0, TQZ_NAME_BYTES) == NULL) {
        why = "0xf5-name-unterminated";
    } else if (memchr(body + B_SOUND_A, 0, TQZ_SOUND_BYTES) == NULL || memchr(body + B_SOUND_B, 0, TQZ_SOUND_BYTES) == NULL ||
               memchr(body + B_SOUND_C, 0, TQZ_SOUND_BYTES) == NULL || memchr(body + B_SOUND_D, 0, TQZ_SOUND_BYTES) == NULL) {
        why = "0xf5-sound-unterminated";
    } else if (rd_s16(body, B_VARIANTS) < 1 || rd_s16(body, B_VARIANTS) > TQZ_BALLOONS) {
        why = "0xf5-variant-count";
    } else if (rd_s16(body, B_POSITIONS) < 1 || rd_s16(body, B_POSITIONS) > TQZ_BALLOONS) {
        why = "0xf5-position-count";
    } else if (rd_s16(body, B_COUNT_MIN) < 0 || rd_s16(body, B_COUNT_MAX) > TQZ_BALLOONS ||
               rd_s16(body, B_COUNT_MIN) > rd_s16(body, B_COUNT_MAX)) {
        why = "0xf5-balloon-range";
    } else if (rd_s16(body, B_LIFE_MIN) > rd_s16(body, B_LIFE_MAX)) {
        why = "0xf5-lifetime-range";
    }
    if (failure != NULL) *failure = why;
    return why == NULL ? TQZ_OK : TQZ_ERR_BODY;
}

/* 0x4b8520: may this character appear on a balloon? */
static int char_allowed(const uint8_t *body, uint8_t ch)
{
    if ((ch >= 0x41 && ch <= 0x5a) || (ch >= 0x61 && ch <= 0x7a)) return 1;
    if (body[B_DIGITS] != 0 && ch >= 0x30 && ch <= 0x39) return 1;
    if (body[B_EXTRA] != 0) {
        for (int16_t i = 0; i < B_EXTRA_BYTES; ++i) {
            if (ch == body[B_EXTRA + i]) return 1;
        }
    }
    return 0;
}

/* 0x4b85f6: a random allowed character. `max_char` is obj+0x63b, which the original keeps from the previous run (the first
 * wave of phase 0 runs before phase 0 stores it for this run). */
static int pick_char(const TqzObject *o, const uint8_t *body, const TqzHost *host, uint8_t *out)
{
    for (uint32_t n = 0; n < TQZ_PICK_LIMIT; ++n) {
        int32_t r, span;
        uint8_t ch;
        if (body[B_DIGITS] == 0) {
            span = sub32(o->max_char, 0x41);
            if (span == 0) return TQZ_ERR_BOUNDS;
            CHECK(rnd(host, &r));
            ch = (uint8_t)add32(r % span, 0x41);
        } else {
            span = sub32(o->max_char, 0x30);
            if (span == 0) return TQZ_ERR_BOUNDS;
            CHECK(rnd(host, &r));
            ch = (uint8_t)add32(r % span, 0x30);
        }
        if (char_allowed(body, ch)) {
            *out = ch;
            return TQZ_OK;
        }
    }
    return TQZ_ERR_STUCK;
}

/* 0x4b866e: a random position no balloon occupies. */
static int pick_position(const TqzObject *o, const uint8_t *body, const TqzHost *host, int32_t view_x, int32_t view_y,
                         int16_t *out)
{
    const int32_t n = rd_s16(body, B_POSITIONS);
    int32_t r;
    int16_t c;
    CHECK(rnd(host, &r));
    c = (int16_t)(r % n);
    for (uint32_t tries = 0; tries < TQZ_PICK_LIMIT; ++tries) {
        int found = 0;
        for (int16_t k = 0; k < n; ++k) {
            const TqzBalloon *b = &o->balloon[k];
            if (b->state != 0 && sub32(b->dst[1], view_y) == rd_s32(body, B_POSITION_RECT + 4 + (size_t)c * 16u) &&
                sub32(b->dst[0], view_x) == rd_s32(body, B_POSITION_RECT + (size_t)c * 16u)) {
                found = 1;
                break;
            }
        }
        if (!found) {
            *out = c;
            return TQZ_OK;
        }
        CHECK(rnd(host, &r));
        c = (int16_t)(r % n);
    }
    return TQZ_ERR_STUCK;
}

/* The balloon construction shared by 0x4b8783 and 0x4b8a27 (the loop body). */
static int place_balloon(TqzObject *o, const uint8_t *body, const TqzHost *host, int16_t k)
{
    TqzBalloon *b = &o->balloon[k];
    int32_t view[4], local[4], r;
    int16_t pos, variant;
    uint8_t ch = 0;
    uint32_t t;
    HOST(host->view_rects(host->context, view, local));
    CHECK(pick_position(o, body, host, view[0], view[1], &pos));
    for (int i = 0; i < 4; ++i) b->dst[i] = rd_s32(body, B_POSITION_RECT + (size_t)pos * 16u + (size_t)i * 4u);
    b->dst[1] = add32(b->dst[1], view[1]);
    b->dst[3] = add32(b->dst[3], view[1]);
    b->dst[0] = add32(b->dst[0], view[0]);
    b->dst[2] = add32(b->dst[2], view[0]);
    b->text_y = add32(sub32(b->dst[3], sub32(b->dst[3], b->dst[1]) / 2), 6);
    b->text_x = add32(sub32(b->dst[2], sub32(b->dst[2], b->dst[0]) / 2), -8);
    CHECK(rnd(host, &r));
    variant = (int16_t)(r % (int32_t)rd_s16(body, B_VARIANTS));
    for (int i = 0; i < 4; ++i) b->src[i] = rd_s32(body, B_VARIANT_RECT + (size_t)variant * 16u + (size_t)i * 4u);
    b->state = TQZ_BALLOON_FLYING;
    CHECK(pick_char(o, body, host, &ch));
    b->ch = ch;
    CHECK(tick(host, &t));
    b->spawn = t;
    CHECK(rnd(host, &r));
    b->lifetime = (int16_t)(add32(r % add32(sub32(rd_s16(body, B_LIFE_MAX), rd_s16(body, B_LIFE_MIN)), 1), 0) +
                            rd_s16(body, B_LIFE_MIN));
    return TQZ_OK;
}

/* 0x4b8783: the first wave. */
static int first_wave(TqzObject *o, const uint8_t *body, const TqzHost *host)
{
    int32_t r;
    CHECK(rnd(host, &r));
    o->count = (int16_t)(r % add32(sub32(rd_s16(body, B_COUNT_MAX), rd_s16(body, B_COUNT_MIN)), 1) + rd_s16(body, B_COUNT_MIN));
    memset(o->balloon, 0, sizeof o->balloon);
    for (int16_t k = 0; k < o->count; ++k) CHECK(place_balloon(o, body, host, k));
    return TQZ_OK;
}

/* 0x4b8a27: after a balloon went away, put up to `n` new ones on free entries. The original leaves its local `fresh`
 * uninitialised when the count would stay below the minimum; the kernel takes 0 there (no new balloon). */
static int more_balloons(TqzObject *o, const uint8_t *body, const TqzHost *host, int16_t n)
{
    int16_t fresh = 0;
    const int16_t lo = rd_s16(body, B_COUNT_MIN), hi = rd_s16(body, B_COUNT_MAX);
    if (add32(o->count, n) < lo) {
        o->count = lo;
    } else {
        int32_t r;
        uint32_t tries = 0;
        CHECK(rnd(host, &r));
        fresh = (int16_t)(r % (n + 1));
        while (add32(o->count, fresh) < lo || hi < add32(o->count, fresh)) {
            if (++tries >= TQZ_PICK_LIMIT) return TQZ_ERR_STUCK;
            CHECK(rnd(host, &r));
            fresh = (int16_t)(r % (n + 1));
        }
        o->count = (int16_t)(o->count + fresh);
    }
    for (int16_t k = 0; k < rd_s16(body, B_POSITIONS) && fresh > 0; ++k) {
        if (o->balloon[k].state == 0) {
            CHECK(place_balloon(o, body, host, k));
            fresh = (int16_t)(fresh - 1);
        }
    }
    return TQZ_OK;
}

/* 0x4b832c: elapsed time and the clock display. */
static int clock_update(TqzObject *o, const uint8_t *body, TqzWorld *world, const TqzHost *host)
{
    uint32_t t;
    int32_t remaining, minutes, seconds;
    CHECK(tick(host, &t));
    o->elapsed = t - o->start_tick;
    remaining = sub32(rd_s16(body, B_TIME_LIMIT), (int32_t)(o->elapsed / 1000u));
    minutes = remaining / 60;
    if (minutes >= 0x3b) minutes = 0x3b;
    seconds = sub32(remaining, mul32(minutes, 60));
    if (seconds >= 0x3b) seconds = 0x3b;
    if (minutes != o->minutes || seconds != o->seconds) {
        o->minutes = minutes;
        o->seconds = seconds;
        if (o->seconds < 0) o->seconds = 0;
        if (o->minutes < 0) o->minutes = 0;
        if (std_set_clock(&world->display, o->minutes, o->seconds) != STD_OK) return TQZ_ERR_BOUNDS;
        fx(host, TQZ_FX_SET_CLOCK, o->minutes, o->seconds);
    }
    return TQZ_OK;
}

/* __ftol (0x50ce04): truncate toward zero to 64 bits; out of range gives the integer indefinite. */
static int64_t ftol64(double v)
{
    if (!(v >= -9223372036854775808.0 && v < 9223372036854775808.0)) return INT64_MIN;
    return (int64_t)v;
}

/* 0x4b844d: score recompute (hits per minute scaled by the factor), end of the time. */
static int score_update(TqzObject *o, const uint8_t *body, TqzWorld *world, const TqzHost *host)
{
    const uint32_t secs = o->elapsed / 1000u;
    if (secs != 0u && o->hits != 0) {
        /* x87 at 53-bit precision: float operands, double intermediate, a float store, then truncation. */
        const double hits = (double)(float)(double)(uint32_t)o->hits;
        const double factor = (double)(float)(int32_t)rd_s16(body, B_FACTOR);
        const double seconds = (double)(float)(int32_t)secs;
        const double scaled = (hits / (factor * seconds)) * (double)60.0f;
        const float stored = (float)scaled;
        o->score = (int32_t)(int16_t)(uint16_t)(uint64_t)ftol64((double)stored);
    }
    if (o->score != o->prev_score) {
        if (std_set_score(&world->display, o->score) != STD_OK) return TQZ_ERR_BOUNDS;
        fx(host, TQZ_FX_SET_SCORE, o->score, 0);
    }
    if ((int32_t)rd_s16(body, B_TIME_LIMIT) <= (int32_t)secs) {
        o->state = TQZ_STATE_TIME_UP;
        fx(host, TQZ_FX_STATE, o->state, 0);
    }
    return TQZ_OK;
}

/* 0x4b8d5e: balloons whose lifetime ran out. */
static int expire_balloons(TqzObject *o, const uint8_t *body, const TqzHost *host)
{
    uint32_t t;
    int16_t gone = 0;
    CHECK(tick(host, &t));
    for (int16_t k = 0; k < rd_s16(body, B_POSITIONS); ++k) {
        TqzBalloon *b = &o->balloon[k];
        if (b->state == TQZ_BALLOON_FLYING && (uint32_t)(int32_t)b->lifetime < (t - b->spawn) / 1000u) {
            b->state = TQZ_BALLOON_GONE;
            o->count = (int16_t)(o->count - 1);
            gone = (int16_t)(gone + 1);
        }
    }
    if (gone > 0) {
        CHECK(play(host, sound_channel(body, B_CHANNEL_TIMEOUT)));
        CHECK(more_balloons(o, body, host, 2));
    }
    return TQZ_OK;
}

/* The key handling of phase 1 state 0. */
static int process_key(TqzObject *o, const uint8_t *body, const TqzHost *host)
{
    if (o->key_pending == 0) return TQZ_OK;
    for (int16_t k = 0; k < rd_s16(body, B_POSITIONS); ++k) {
        TqzBalloon *b = &o->balloon[k];
        const int32_t sch = (int8_t)o->key_char;
        if (body[B_CASE_SENSITIVE] == 0 && (uint32_t)b->ch != (uint32_t)sch && '@' < sch) {
            if (b->ch < 0x61 || (uint32_t)b->ch != (uint32_t)sch + 0x20u) {
                if ('`' < sch && (uint32_t)b->ch == (uint32_t)sch - 0x20u) o->key_char = (uint8_t)(o->key_char - 0x20);
            } else {
                o->key_char = (uint8_t)(o->key_char + 0x20);
            }
        }
        if (b->state == TQZ_BALLOON_FLYING && (uint32_t)b->ch == (uint32_t)(int32_t)(int8_t)o->key_char) {
            uint32_t t;
            b->state = TQZ_BALLOON_POPPING;
            o->hits = add32(o->hits, 1);
            CHECK(play(host, sound_channel(body, B_CHANNEL_HIT)));
            CHECK(tick(host, &t));
            b->deadline = t + 1000u;
            o->key_pending = 0;
            break;
        }
    }
    if (o->key_pending != 0) {
        o->key_pending = 0;
        CHECK(play(host, sound_channel(body, B_CHANNEL_MISS)));
    }
    return TQZ_OK;
}

static void view_add(int32_t *dst, int32_t value, int32_t view)
{
    *dst = add32(value, view);
}

/* The registered z entry of a display half: the host stores the entry fields. */
static int display_register(void *context, int16_t slot, int32_t type, int callback, uint32_t surface, const char *label)
{
    const TqzHost *host = (const TqzHost *)context;
    return host->register_slot(host->context, slot, type, callback, surface, label);
}

static void display_observe(void *context, int effect, int32_t a, int32_t b)
{
    const TqzHost *host = (const TqzHost *)context;
    fx(host, effect, a, b);
}

static StdHost std_host_of(const TqzHost *host)
{
    StdHost s;
    s.context = (void *)host;
    s.register_slot = display_register;
    s.observe = host->observe != NULL ? display_observe : NULL;
    return s;
}

/* 0x4b8e92 phase 0. */
static int phase0(TqzObject *o, const uint8_t *body, int16_t row, TqzWorld *world, const TqzHost *host)
{
    int32_t view[4], local[4];
    int16_t slot;
    uint32_t t;
    StdHost sh = std_host_of(host);
    o->row = row;
    o->active = 1;
    fx(host, TQZ_FX_ACTIVE, 1, 0);
    world->start_flag_5bb1ca = 1;
    fx(host, TQZ_FX_START_FLAG, 1, 0);
    HOST(host->clear_pending_item(host->context));
    fx(host, TQZ_FX_CLEAR_ITEM, 0, 0);
    HOST(host->alloc_slot(host->context, &slot));
    fx(host, TQZ_FX_SLOT, slot, 0);
    o->slot = slot;
    HOST(host->register_slot(host->context, slot, 10, TQZ_CALLBACK_QUIZ, 0, "TYPING QUIZ PUZZLE OVERLAYS"));
    fx(host, TQZ_FX_SLOT_REGISTER, slot, 0);
    if (o->surface == 0) {
        uint32_t surface = 0;
        HOST(host->load_surface(host->context, (const char *)body, &surface));
        fx(host, TQZ_FX_SURFACE_LOAD, (int32_t)surface, 0);
        o->surface = surface;
    }
    HOST(host->set_slot_surface(host->context, o->slot, o->surface));
    fx(host, TQZ_FX_SLOT_SURFACE, o->slot, (int32_t)o->surface);
    CHECK(sound_prepare_if(body, B_SOUND_A, host));
    CHECK(sound_prepare_if(body, B_SOUND_B, host));
    CHECK(sound_prepare_if(body, B_SOUND_C, host));
    o->score = 0;
    o->hits = 0;
    /* The score display block. */
    for (int i = 0; i < 40; ++i) o->score_block[i] = rd_s32(body, B_SCORE_DIGITS + (size_t)i * 4u);
    o->score_block[40] = rd_s32(body, B_SCORE_X);
    o->score_block[41] = rd_s32(body, B_SCORE_Y);
    o->score_block[42] = rd_s32(body, B_SCORE_GAP);
    o->score_block[43] = (int32_t)o->surface;
    HOST(host->alloc_slot(host->context, &slot));
    fx(host, TQZ_FX_SLOT, slot, 0);
    o->score_block[44] = slot;
    o->score_block[45] = 10;
    HOST(host->view_rects(host->context, view, local));
    view_add(&o->score_block[40], o->score_block[40], view[0]);
    view_add(&o->score_block[41], o->score_block[41], view[1]);
    if (std_init_score(&world->display, o->score_block, &sh) != STD_OK) return TQZ_ERR_HOST;
    if (std_set_score(&world->display, o->score) != STD_OK) return TQZ_ERR_BOUNDS;
    fx(host, TQZ_FX_SET_SCORE, o->score, 0);
    std_enable_score(&world->display, 1);
    fx(host, TQZ_FX_ENABLE_SCORE, 1, 0);
    CHECK(tick(host, &t));
    o->start_tick = t;
    o->elapsed = 0;
    o->minutes = 0;
    o->seconds = 0;
    /* The clock display block. */
    for (int i = 0; i < 40; ++i) o->clock_block[i] = rd_s32(body, B_CLOCK_DIGITS + (size_t)i * 4u);
    for (int i = 0; i < 4; ++i) o->clock_block[40 + i] = rd_s32(body, B_COLON + (size_t)i * 4u);
    o->clock_block[44] = rd_s32(body, B_CLOCK_X);
    o->clock_block[45] = rd_s32(body, B_CLOCK_Y);
    o->clock_block[46] = rd_s32(body, B_CLOCK_GAP);
    o->clock_block[47] = (int32_t)o->surface;
    HOST(host->alloc_slot(host->context, &slot));
    fx(host, TQZ_FX_SLOT, slot, 0);
    o->clock_block[48] = slot;
    o->clock_block[49] = 10;
    HOST(host->view_rects(host->context, view, local));
    view_add(&o->clock_block[44], o->clock_block[44], view[0]);
    view_add(&o->clock_block[45], o->clock_block[45], view[1]);
    if (std_init_clock(&world->display, o->clock_block, &sh) != STD_OK) return TQZ_ERR_HOST;
    if (std_set_clock(&world->display, o->minutes, o->seconds) != STD_OK) return TQZ_ERR_BOUNDS;
    fx(host, TQZ_FX_SET_CLOCK, o->minutes, o->seconds);
    std_enable_clock(&world->display, 1);
    fx(host, TQZ_FX_ENABLE_CLOCK, 1, 0);
    world->played_5a4c0a = 1;
    fx(host, TQZ_FX_PLAYED_FLAG, 1, 0);
    if (rd_s16(body, B_TARGET_PERCENT) < 1 || world->best_5a4c0e < 1) {
        o->target = rd_s16(body, B_DEFAULT_TARGET);
    } else {
        o->target = (int16_t)(mul32(world->best_5a4c0e, rd_s16(body, B_TARGET_PERCENT)) / 100);
        if (o->target <= rd_s16(body, B_TARGET_LOW)) o->target = rd_s16(body, B_TARGET_LOW);
    }
    o->state = TQZ_STATE_PLAY;
    fx(host, TQZ_FX_STATE, o->state, 0);
    fx(host, TQZ_FX_PHASE, 1, 0);
    HOST(host->font_acquire(host->context));
    fx(host, TQZ_FX_FONT_ACQUIRE, TQZ_FONT_SURFACE, 0);
    CHECK(first_wave(o, body, host));
    if (body[B_WIDE] == 0) {
        o->max_char = body[B_EXTRA] == 0 ? 0x7b : 0x7f;
    } else {
        o->max_char = 0x100;
    }
    return TQZ_OK;
}

/* 0x4b8e92 phase 1. */
static int phase1(TqzObject *o, const uint8_t *body, TqzWorld *world, uint32_t *row_phase, const TqzHost *host)
{
    switch (o->state) {
    case TQZ_STATE_PLAY:
        CHECK(clock_update(o, body, world, host));
        CHECK(expire_balloons(o, body, host));
        CHECK(process_key(o, body, host));
        CHECK(score_update(o, body, world, host));
        break;
    case TQZ_STATE_TIME_UP: {
        uint32_t t;
        CHECK(tick(host, &t));
        o->end_deadline = t + (uint32_t)rd_s32(body, B_END_DELAY);
        o->state = TQZ_STATE_WAIT_END;
        fx(host, TQZ_FX_STATE, o->state, 0);
        o->flag34 = 1;
        o->finishing = 1;
        if (o->score < (int32_t)o->target) {
            if ((int32_t)rd_s16(body, B_MIN_SCORE) <= o->score) o->reached = 1;
        } else {
            o->passed = 1;
            if (!no_sound(body + B_SOUND_D)) {
                HOST(host->sound_prepare(host->context, body + B_SOUND_D));
                fx(host, TQZ_FX_SOUND_PREPARE, B_SOUND_D, 0);
                CHECK(play(host, sound_channel(body, B_CHANNEL_D)));
            }
        }
        break;
    }
    case TQZ_STATE_WAIT_END: {
        uint32_t t;
        CHECK(tick(host, &t));
        if (o->end_deadline <= t) {
            world->best_5a4c0e = (int16_t)o->score;
            fx(host, TQZ_FX_BEST_SCORE, world->best_5a4c0e, 0);
            *row_phase = 2u;
            fx(host, TQZ_FX_PHASE, 2, 0);
            std_reset_score(&world->display);
            std_reset_clock(&world->display);
            fx(host, TQZ_FX_RESET_DISPLAY, 0, 0);
            o->active = 0;
            fx(host, TQZ_FX_ACTIVE, 0, 0);
        }
        break;
    }
    default:
        break;
    }
    return TQZ_OK;
}

/* A scene block of phase 2: the seven scene-change cells and the start flag. */
static int apply_block(const uint8_t *blk, int start_is_inverted, TqzWorld *world, const TqzHost *host)
{
    TqzTransition t;
    t.scene = rd_s16(blk, SB_SCENE);
    t.word[0] = rd_s16(blk, SB_W1);
    t.word[1] = rd_s16(blk, SB_W2);
    t.word[2] = rd_s16(blk, SB_W3);
    t.dword[0] = rd_s32(blk, SB_D1);
    t.dword[1] = rd_s32(blk, SB_D2);
    t.dword[2] = rd_s32(blk, SB_D3);
    HOST(host->transition(host->context, &t));
    fx(host, TQZ_FX_XFER_5BB57B, t.scene, 0);
    fx(host, TQZ_FX_XFER_5BB599, t.word[0], 0);
    fx(host, TQZ_FX_XFER_5BB595, t.word[1], 0);
    fx(host, TQZ_FX_XFER_5C39FF, t.word[2], 0);
    fx(host, TQZ_FX_XFER_5BB59B, t.dword[0], 0);
    fx(host, TQZ_FX_XFER_5BB59F, t.dword[1], 0);
    fx(host, TQZ_FX_XFER_5BB5A3, t.dword[2], 0);
    (void)start_is_inverted;
    world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;
    fx(host, TQZ_FX_START_FLAG, world->start_flag_5bb1ca, 0);
    return TQZ_OK;
}

static int store_flag(int16_t index, const TqzHost *host)
{
    HOST(host->store_event_flag(host->context, index, 1u));
    fx(host, TQZ_FX_EVENT_FLAG, index, 1);
    return TQZ_OK;
}

/* 0x4b8e92 phase 2 up to the generic completion. */
static int phase2(TqzObject *o, const uint8_t *body, TqzWorld *world, const TqzHost *host)
{
    CHECK(sound_stop_if(body, B_SOUND_A, host));
    CHECK(sound_stop_if(body, B_SOUND_B, host));
    CHECK(sound_stop_if(body, B_SOUND_C, host));
    if (o->passed == 0) {
        CHECK(apply_block(body + B_NORMAL, 0, world, host));
        if (o->reached == 0 || rd_s16(body, B_NORMAL + SB_FLAG) == TQZ_NO_FLAG) {
            if (rd_s16(body, B_NORMAL + SB_FLAG2) != TQZ_NO_FLAG) CHECK(store_flag(rd_s16(body, B_NORMAL + SB_FLAG2), host));
        } else {
            CHECK(store_flag(rd_s16(body, B_NORMAL + SB_FLAG), host));
        }
    } else {
        CHECK(sound_stop_if(body, B_SOUND_D, host));
        if (rd_s16(body, B_PASSED + SB_SCENE) != TQZ_NO_SCENE) CHECK(apply_block(body + B_PASSED, 1, world, host));
        if (rd_s16(body, B_PASSED + SB_FLAG) != TQZ_NO_FLAG) CHECK(store_flag(rd_s16(body, B_PASSED + SB_FLAG), host));
    }
    HOST(host->engine_mode(host->context, 4));
    fx(host, TQZ_FX_ENGINE_MODE, 4, 0);
    return TQZ_OK;
}

static int host_complete(const TqzHost *host)
{
    return host != NULL && host->alloc_slot != NULL && host->register_slot != NULL && host->load_surface != NULL &&
           host->set_slot_surface != NULL && host->release_surface != NULL && host->release_slot != NULL &&
           host->mark_dirty != NULL && host->view_rects != NULL && host->clear_pending_item != NULL &&
           host->font_acquire != NULL && host->font_release != NULL && host->sound_prepare != NULL &&
           host->sound_stop != NULL && host->sound_play != NULL && host->tick != NULL && host->random != NULL &&
           host->event_flag_invalid != NULL && host->transition != NULL && host->store_event_flag != NULL &&
           host->engine_mode != NULL;
}

int tqz_step(TqzObject *object, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, TqzWorld *world,
             const TqzHost *host, TqzResult *result, const char **failure)
{
    const char *why = NULL;
    uint32_t row_phase = phase;
    int rc;
    if (failure != NULL) *failure = NULL;
    if (object == NULL || body == NULL || world == NULL || result == NULL || !host_complete(host)) {
        if (failure != NULL) *failure = "0xf5-argument";
        return TQZ_ERR_ARGUMENT;
    }
    memset(result, 0, sizeof(*result));
    result->phase_after = phase;
    if (tqz_validate_body(body, body_length, &why) != TQZ_OK) {
        if (failure != NULL) *failure = why;
        return TQZ_ERR_BODY;
    }
    if (phase == 0u) {
        if (row < 0) {
            if (failure != NULL) *failure = "0xf5-row";
            return TQZ_ERR_ARGUMENT;
        }
        rc = phase0(object, body, row, world, host);
        if (rc == TQZ_OK) {
            row_phase = 1u;
            result->initialized = 1u;
        }
    } else if (phase == 1u) {
        if (object->active == 0 || object->row != row) {
            if (failure != NULL) *failure = "0xf5-phase-1-without-init";
            return TQZ_ERR_UNSUPPORTED;
        }
        rc = phase1(object, body, world, &row_phase, host);
    } else if (phase == 2u) {
        if (object->row != row) {
            if (failure != NULL) *failure = "0xf5-phase-2-without-init";
            return TQZ_ERR_UNSUPPORTED;
        }
        /* Refuse before any effect when the finish block names a flag the host cannot store. */
        {
            int16_t flag[2] = {TQZ_NO_FLAG, TQZ_NO_FLAG};
            if (object->passed == 0) {
                flag[0] = object->reached == 0 || rd_s16(body, B_NORMAL + SB_FLAG) == TQZ_NO_FLAG
                              ? rd_s16(body, B_NORMAL + SB_FLAG2)
                              : rd_s16(body, B_NORMAL + SB_FLAG);
            } else {
                flag[0] = rd_s16(body, B_PASSED + SB_FLAG);
            }
            if (flag[0] != TQZ_NO_FLAG && host->event_flag_invalid(host->context, flag[0]) != 0) {
                if (failure != NULL) *failure = "0xf5-event-flag-index";
                return TQZ_ERR_BOUNDS;
            }
        }
        rc = phase2(object, body, world, host);
        if (rc == TQZ_OK) {
            fx(host, TQZ_FX_COMPLETE, row, 0);
            result->completed = 1u;
            rc = tqz_cleanup(object, world, host);
            row_phase = 0u;
        }
    } else {
        return TQZ_OK;
    }
    result->phase_after = row_phase;
    if (rc != TQZ_OK && failure != NULL && *failure == NULL) *failure = "0xf5-host-or-bounds";
    return rc;
}

int tqz_key(TqzObject *object, uint32_t row_phase, int8_t ch)
{
    if (object->active != 0 && object->state == 0 && object->key_pending == 0 && row_phase == 1u && tqz_key_filter(ch)) {
        object->key_char = (uint8_t)ch;
        object->key_pending = 1;
        return 1;
    }
    return 0;
}

int tqz_pointer(const TqzObject *object, const uint8_t *body, size_t body_length, int32_t x, int32_t y,
                TqzPointerResult *out)
{
    int16_t px, py;
    if (object == NULL || body == NULL || out == NULL || body_length != TQZ_BODY_BYTES) return TQZ_ERR_ARGUMENT;
    px = (int16_t)(uint16_t)x;
    py = (int16_t)(uint16_t)y;
    memset(out, 0, sizeof *out);
    out->candidate = -1;
    if (object->active == 0 || py < rd_s32(body, B_RECT + 4) || rd_s32(body, B_RECT + 12) < py ||
        px < rd_s32(body, B_RECT) || rd_s32(body, B_RECT + 8) < px) {
        return TQZ_OK;
    }
    out->hit = 1;
    out->candidate = TQZ_CANDIDATE;
    out->cursor_kind = rd_s16(body, B_CURSOR);
    out->cursor_sub = 1;
    return TQZ_OK;
}

int tqz_click(const TqzObject *object, uint32_t row_phase, int32_t candidate, uint32_t *new_phase)
{
    if (object->active != 0 && object->finishing == 0 && object->state == 0 && row_phase == 1u &&
        candidate == TQZ_CANDIDATE) {
        *new_phase = 2u;
        return 1;
    }
    *new_phase = row_phase;
    return 0;
}

int tqz_invalidate(const TqzObject *object, const TqzHost *host)
{
    if (object->active != 0 && object->slot != TQZ_NO_SLOT) HOST(host->mark_dirty(host->context, object->slot));
    return TQZ_OK;
}

int tqz_cleanup(TqzObject *object, TqzWorld *world, const TqzHost *host)
{
    (void)world;
    if (object->surface != 0) {
        const uint32_t held = object->surface;
        HOST(host->release_surface(host->context, held));
        fx(host, TQZ_FX_RELEASE_SURFACE, (int32_t)held, 0);
        object->surface = 0;
    }
    if (object->slot != TQZ_NO_SLOT) {
        HOST(host->release_slot(host->context, object->slot));
        fx(host, TQZ_FX_RELEASE_SLOT, object->slot, 0);
    }
    if (object->clock_block[48] != -1) {
        HOST(host->release_slot(host->context, (int16_t)object->clock_block[48]));
        fx(host, TQZ_FX_RELEASE_SLOT, (int16_t)object->clock_block[48], 0);
    }
    if (object->score_block[44] != -1) {
        HOST(host->release_slot(host->context, (int16_t)object->score_block[44]));
        fx(host, TQZ_FX_RELEASE_SLOT, (int16_t)object->score_block[44], 0);
    }
    HOST(host->font_release(host->context));
    fx(host, TQZ_FX_FONT_RELEASE, TQZ_FONT_SURFACE, 0);
    /* 0x4b7f3b */
    object->row = -1;
    object->slot = -1;
    object->active = 0;
    object->passed = 0;
    object->finishing = 0;
    object->reached = 0;
    object->flag34 = 0;
    object->surface = 0;
    object->hits = 0;
    object->score = 0;
    object->prev_score = 0;
    object->dword55a = 0;
    memset(object->score_block, 0, sizeof object->score_block);
    memset(object->clock_block, 0, sizeof object->clock_block);
    object->clock_block[48] = -1;
    object->score_block[44] = -1;
    return TQZ_OK;
}

static int emit(TqzRenderResult *out, int32_t kind, uint32_t surface, const int32_t src[4], const int32_t dst[4], int32_t a,
                int32_t b, int32_t c)
{
    StdBlit *e;
    if (out->count >= TQZ_MAX_BLITS) return TQZ_ERR_BOUNDS;
    e = &out->blit[out->count++];
    memset(e, 0, sizeof *e);
    e->kind = kind;
    e->surface = surface;
    if (src != NULL) memcpy(e->src, src, sizeof e->src);
    if (dst != NULL) memcpy(e->dst, dst, sizeof e->dst);
    e->a = a;
    e->b = b;
    e->c = c;
    return TQZ_OK;
}

int tqz_render(TqzObject *object, TqzWorld *world, const uint8_t *body, size_t body_length, const TqzHost *host,
               TqzRenderResult *out)
{
    int32_t view[4], local[4];
    uint32_t t;
    if (object == NULL || body == NULL || world == NULL || out == NULL || !host_complete(host) ||
        body_length != TQZ_BODY_BYTES) {
        return TQZ_ERR_ARGUMENT;
    }
    memset(out, 0, offsetof(TqzRenderResult, blit));
    if (object->active == 0 || object->slot == TQZ_NO_SLOT) return TQZ_OK;
    out->valid = 1;
    if (object->finishing == 0) {
        for (int16_t k = 0; k < rd_s16(body, B_POSITIONS); ++k) {
            TqzBalloon *b = &object->balloon[k];
            if (b->state == TQZ_BALLOON_FLYING) {
                CHECK(emit(out, TQZ_BLIT_BALLOON, object->surface, b->src, b->dst, k, 0, 0));
                CHECK(emit(out, TQZ_BLIT_TEXT, 0, NULL, NULL, b->ch, (int16_t)b->text_x, (int16_t)b->text_y));
            } else if (b->state == TQZ_BALLOON_POPPING) {
                int32_t pop[4];
                for (int i = 0; i < 4; ++i) pop[i] = rd_s32(body, B_POP_RECT + (size_t)i * 4u);
                CHECK(emit(out, TQZ_BLIT_POP, object->surface, pop, b->dst, k, 0, 0));
                CHECK(tick(host, &t));
                if (b->deadline <= t) {
                    b->state = TQZ_BALLOON_GONE;
                    object->count = (int16_t)(object->count - 1);
                    CHECK(more_balloons(object, body, host, 2));
                }
            } else if (b->state == TQZ_BALLOON_GONE) {
                int32_t src[4];
                HOST(host->view_rects(host->context, view, local));
                src[0] = sub32(b->dst[0], view[0]);
                src[1] = sub32(b->dst[1], view[1]);
                src[2] = sub32(b->dst[2], view[0]);
                src[3] = sub32(b->dst[3], view[1]);
                CHECK(emit(out, TQZ_BLIT_BALLOON_ERASE, 0, src, b->dst, k, 0, 0));
                b->state = TQZ_BALLOON_FREE;
            }
        }
    } else {
        int32_t dst[4], src[4];
        HOST(host->view_rects(host->context, view, local));
        if (object->flag34 != 0) {
            CHECK(emit(out, TQZ_BLIT_BACKGROUND_ERASE, 0, local, view, 0, 0, 0));
            object->flag34 = 0;
        }
        for (int i = 0; i < 4; ++i) src[i] = rd_s32(body, B_PASSED_RECT + (size_t)i * 4u);
        dst[0] = sub32(add32(view[0], sub32(view[2], view[0]) / 2), sub32(src[2], src[0]) / 2);
        dst[1] = sub32(add32(view[1], sub32(view[3], view[1]) / 2), sub32(src[3], src[1]) / 2);
        dst[2] = add32(dst[0], sub32(src[2], src[0]));
        dst[3] = add32(dst[1], sub32(src[3], src[1]));
        CHECK(emit(out, TQZ_BLIT_PASSED, object->surface, src, dst, 0, 0, 0));
    }
    return TQZ_OK;
}

static int display_blits(const StdBlit *in, size_t n, TqzRenderResult *out)
{
    memset(out, 0, offsetof(TqzRenderResult, blit));
    out->valid = 1;
    for (size_t i = 0; i < n; ++i) {
        if (out->count >= TQZ_MAX_BLITS) return TQZ_ERR_BOUNDS;
        out->blit[out->count++] = in[i];
    }
    return TQZ_OK;
}

int tqz_render_score(TqzWorld *world, const TqzHost *host, TqzRenderResult *out)
{
    StdBlit blit[STD_MAX_BLITS];
    size_t n = 0;
    int32_t view[4], local[4];
    if (world == NULL || out == NULL || !host_complete(host)) return TQZ_ERR_ARGUMENT;
    HOST(host->view_rects(host->context, view, local));
    if (std_render_score(&world->display, view[0], view[1], blit, STD_MAX_BLITS, &n) != STD_OK) return TQZ_ERR_BOUNDS;
    return display_blits(blit, n, out);
}

int tqz_render_clock(TqzWorld *world, const TqzHost *host, TqzRenderResult *out)
{
    StdBlit blit[STD_MAX_BLITS];
    size_t n = 0;
    int32_t view[4], local[4];
    if (world == NULL || out == NULL || !host_complete(host)) return TQZ_ERR_ARGUMENT;
    HOST(host->view_rects(host->context, view, local));
    if (std_render_clock(&world->display, view[0], view[1], blit, STD_MAX_BLITS, &n) != STD_OK) return TQZ_ERR_BOUNDS;
    return display_blits(blit, n, out);
}
