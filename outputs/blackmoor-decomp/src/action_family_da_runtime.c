#include "action_family_da_runtime.h"

#include <string.h>

/* See the header for the original addresses, the body layout, the host contract, the preserved quirks and the native-only
 * refusals. Names below follow the header; comments give the original address of each piece. */

enum { SB_SCENE = 0, SB_W1 = 2, SB_W2 = 4, SB_W3 = 6, SB_D1 = 8, SB_D2 = 12, SB_D3 = 16, SB_START = 20, SB_FLAG = 22, SB_VALUE = 24,
       SB_FLAG2 = 25, SB_VALUE2 = 27 };
enum {
    B_SURFACE_NAME = 0,
    B_WORK_STRIDE = 0x20,
    B_PLAYER_JAIL_LAST_RIGHT = 0x255,   /* right / bottom of the last player jail slot (0x24d + 8) */
    B_COMPUTER_JAIL_LAST_RIGHT = 0x315, /* right / bottom of the last computer jail slot (0x30d + 8) */
    B_LIGHT_LEFT = 0x34d,
    B_LIGHT_RIGHT = 0x355,
    B_SOUND_BUTTON_CHANNEL = 0x21,      /* word inside a sound record */
    B_NAME_PHASE0 = 0x873,              /* caption entry 1, name 0 */
    B_NAMES_CLICK = 0x7e9,
    B_NAMES_PASS_0 = 0x5b8,
    B_NAMES_PASS_1 = 0x894,
    B_NAMES_ROLL_0 = 0x5d9,
    B_NAMES_ROLL_1 = 0x8b5,
    B_NAMES_END_1 = 0x65d,
    B_NAMES_END_3 = 0x939,
    B_NAMES_STEP = 0x6e1,
    B_NAMES_WIN = 0x765,
    B_NAMES_LOSE = 0xa41,
    B_BUTTON2_CHANNEL = 0x581,
    B_POSITION_SLOTS = BUL_MAX_POSITIONS
};
enum { PIECE_SLOTS = BUL_MAX_PIECES, NAMES_PER_ENTRY = 22, NAME_FIRST = 0x06 };

typedef struct Ctx {
    BulObject *o;
    const uint8_t *body;
    BulWorld *w;
    const BulHost *host;
    const char *why;
} Ctx;

static int16_t rd_s16(const uint8_t *b, size_t off)
{
    return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));
}

static int32_t rd_s32(const uint8_t *b, size_t off)
{
    return (int32_t)((uint32_t)b[off] | ((uint32_t)b[off + 1] << 8) | ((uint32_t)b[off + 2] << 16) |
                     ((uint32_t)b[off + 3] << 24));
}

static void rd_rect(BulRect *r, const uint8_t *b, size_t off)
{
    r->left = rd_s32(b, off);
    r->top = rd_s32(b, off + 4);
    r->right = rd_s32(b, off + 8);
    r->bottom = rd_s32(b, off + 12);
}

/* Wrapping 32-bit arithmetic: the original adds and subtracts without overflow checks. */
static int32_t add32(int32_t a, int32_t b)
{
    return (int32_t)((uint32_t)a + (uint32_t)b);
}

static int32_t sub32(int32_t a, int32_t b)
{
    return (int32_t)((uint32_t)a - (uint32_t)b);
}

/* 16-bit word arithmetic of the original (add ax, 1 / sub cx, 1). */
static int16_t add16(int16_t a, int16_t b)
{
    return (int16_t)(uint16_t)((uint32_t)(uint16_t)a + (uint32_t)(uint16_t)b);
}

static BulRect shifted(const BulRect *r, int32_t vx, int32_t vy)
{
    BulRect s;
    s.left = add32(r->left, vx);
    s.top = add32(r->top, vy);
    s.right = add32(r->right, vx);
    s.bottom = add32(r->bottom, vy);
    return s;
}

static void fx(const Ctx *c, int effect, int32_t a, int32_t b)
{
    if (c->host->observe != NULL) c->host->observe(c->host->context, effect, a, b);
}

#define HOST(c, call)                \
    do {                             \
        if ((call) != 0) {           \
            (c)->why = "0xda-host";  \
            return BUL_ERR_HOST;     \
        }                            \
    } while (0)
#define CHECK(call)                  \
    do {                             \
        const int rc_ = (call);      \
        if (rc_ != BUL_OK) {         \
            return rc_;              \
        }                            \
    } while (0)

/* The 9-byte comparison against "NO SOUND\0" (repe cmpsb with ecx = 9). */
static int no_sound(const uint8_t *name)
{
    static const uint8_t k[9] = {'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0};
    return memcmp(name, k, sizeof k) == 0;
}

/* 0x45be3f: a real sound name is not "NO SOUND" and not empty. */
static int real_name(const uint8_t *name)
{
    return !no_sound(name) && name[0] != 0;
}

/* A rectangle of a body array, index range [lo, hi) (native bound). */
static int body_rect(Ctx *c, size_t base, int32_t index, int32_t lo, int32_t hi, BulRect *out)
{
    if (index < lo || index >= hi) {
        c->why = "0xda-rect-index";
        return BUL_ERR_BOUNDS;
    }
    rd_rect(out, c->body, (size_t)((int64_t)base + (int64_t)index * 16));
    return BUL_OK;
}

static int tick(Ctx *c, uint32_t *out)
{
    *out = c->host->tick(c->host->context);
    fx(c, BUL_FX_TICK, (int32_t)*out, 0);
    return BUL_OK;
}

/* _rand (0..32767). */
static int rnd(Ctx *c, int32_t *out)
{
    const int32_t v = c->host->random(c->host->context);
    if (v < 0 || v > 32767) {
        c->why = "0xda-random";
        return BUL_ERR_HOST;
    }
    fx(c, BUL_FX_RANDOM, v, 0);
    *out = v;
    return BUL_OK;
}

static int play(Ctx *c, int16_t channel)
{
    HOST(c, c->host->sound_play(c->host->context, channel));
    fx(c, BUL_FX_SOUND_PLAY, channel, 0);
    return BUL_OK;
}

static int busy(Ctx *c, int16_t channel, int *out)
{
    *out = c->host->sound_busy(c->host->context, channel) != 0;
    fx(c, BUL_FX_SOUND_BUSY, channel, *out);
    return BUL_OK;
}

/* "if not busy, play" on a channel (the sequence 0x4f6334 / 0x4fb2e3). */
static int play_if_idle(Ctx *c, int16_t channel)
{
    int is_busy;
    CHECK(busy(c, channel, &is_busy));
    if (!is_busy) CHECK(play(c, channel));
    return BUL_OK;
}

static int prepare_record(Ctx *c, size_t off)
{
    if (!no_sound(c->body + off)) {
        HOST(c, c->host->sound_prepare(c->host->context, c->body + off));
        fx(c, BUL_FX_SOUND_PREPARE, (int32_t)off, 0);
    }
    return BUL_OK;
}

static int stop_record(Ctx *c, size_t off)
{
    if (!no_sound(c->body + off)) {
        HOST(c, c->host->sound_stop(c->host->context, c->body + off));
        fx(c, BUL_FX_SOUND_STOP, (int32_t)off, 0);
    }
    return BUL_OK;
}

void bul_object_reset(BulObject *object)
{
    memset(object, 0, sizeof(*object));
    object->slot = BUL_NO_SLOT;
    object->row = -1;
}

int bul_validate_body(const uint8_t *body, size_t length, const char **failure)
{
    const char *why = NULL;
    if (body == NULL || length != BUL_BODY_BYTES) {
        why = "0xda-body-length";
    } else if (memchr(body + B_SURFACE_NAME, 0, BUL_NAME_BYTES) == NULL) {
        why = "0xda-name-unterminated";
    } else {
        int bad = 0;
        for (size_t i = 0; i < 4 && !bad; ++i) {
            if (memchr(body + BUL_B_SOUND_STEP + i * BUL_B_SOUND_RECORD_BYTES, 0, BUL_NAME_BYTES) == NULL) bad = 1;
        }
        for (size_t e = 0; e < 2 && !bad; ++e) {
            for (size_t i = 0; i < NAMES_PER_ENTRY && !bad; ++i) {
                if (memchr(body + BUL_B_CAPTION + e * BUL_B_CAPTION_STRIDE + NAME_FIRST + i * BUL_NAME_BYTES, 0,
                           BUL_NAME_BYTES) == NULL) {
                    bad = 1;
                }
            }
        }
        if (bad) {
            why = "0xda-sound-unterminated";
        } else if (rd_s16(body, BUL_B_POSITIONS) < 1 || rd_s16(body, BUL_B_POSITIONS) > BUL_MAX_POSITIONS) {
            why = "0xda-position-count";
        } else if (rd_s16(body, BUL_B_PIECES) < 1 || rd_s16(body, BUL_B_PIECES) > BUL_MAX_PIECES) {
            why = "0xda-piece-count";
        } else if (rd_s16(body, BUL_B_START_PLAYER) < 1 || rd_s16(body, BUL_B_START_PLAYER) > rd_s16(body, BUL_B_POSITIONS) ||
                   rd_s16(body, BUL_B_START_COMPUTER) < 1 ||
                   rd_s16(body, BUL_B_START_COMPUTER) > rd_s16(body, BUL_B_POSITIONS)) {
            why = "0xda-start-position";
        }
    }
    if (failure != NULL) *failure = why;
    return why == NULL ? BUL_OK : BUL_ERR_BODY;
}

/* Copy a NUL-terminated name with its terminator (strlen + 1 bytes: the dword / byte copy loops of the original). */
static void copy_name(uint8_t *dst, const uint8_t *src)
{
    size_t n = 0;
    while (src[n] != 0) ++n;
    memcpy(dst, src, n + 1u);
}

/* 0x45be7f: caption + sound picker. `names` is the body offset of the name list (count names of 0x21 bytes), `entry` the
 * caption entry. Fills the caption descriptor first (always), picks a real name, prepares and plays the sound, shows the
 * caption text and moves the object to state 10. Returns through *found whether a real name was found. */
static int caption_pick(Ctx *c, size_t names, int16_t count, int16_t entry, int *found)
{
    BulObject *o = c->o;
    const uint8_t *body = c->body;
    const size_t e = BUL_B_CAPTION + (size_t)entry * BUL_B_CAPTION_STRIDE;
    int got = 0;
    *found = 0;
    if (entry < 0 || entry > 1 || count > 10) {
        c->why = "0xda-caption-arguments";
        return BUL_ERR_BOUNDS;
    }
    o->cap_channel = rd_s16(body, e);
    o->cap_1a7 = 2;
    o->cap_1a9 = 1;
    o->cap_1ab = 1;
    o->cap_1ad = 1;
    o->cap_1b1 = rd_s16(body, e + 2);
    o->cap_1b3 = rd_s16(body, e + 4);
    if (count < 2) {
        if (real_name(body + names)) {
            copy_name(o->sound_name, body + names);
            got = 1;
        }
    } else {
        int tracked[10] = {0};
        int done = 0;
        uint32_t draws = 0;
        while (!got && !done) {
            uint8_t buf[36];
            int32_t r;
            int16_t idx;
            if (++draws > BUL_PICK_LIMIT) {
                c->why = "0xda-name-pick-stuck";
                return BUL_ERR_STUCK;
            }
            CHECK(rnd(c, &r));
            idx = (int16_t)(r % count);
            copy_name(buf, body + names + (size_t)idx * BUL_NAME_BYTES);
            if (real_name(buf)) {
                copy_name(o->sound_name, buf);
                got = 1;
            } else {
                tracked[idx] = 1;
                done = 1;
                for (int16_t k = 0; k < count; ++k) {
                    if (tracked[k] == 0) done = 0;
                }
            }
        }
    }
    if (got) {
        const char *text;
        HOST(c, c->host->sound_prepare(c->host->context, o->sound_name));
        fx(c, BUL_FX_SOUND_PREPARE, BUL_NO_OFFSET, 0);
        CHECK(play(c, o->cap_channel));
        text = c->host->caption_text(c->host->context, (const char *)o->sound_name);
        fx(c, BUL_FX_CAPTION_TEXT, text != NULL, 0);
        if (text != NULL) {
            const size_t len = strlen(text);
            if (len <= BUL_CAPTION_LIMIT) {
                char buf[BUL_CAPTION_MAX + 4 + 1];
                if (len > BUL_CAPTION_MAX) {
                    c->why = "0xda-caption-length";
                    return BUL_ERR_BOUNDS;
                }
                memcpy(buf, text, len);
                memcpy(buf + len, "<e>", 4); /* the dword at 0x54ab74: three characters and a NUL */
                buf[len + 4] = '\0';
                HOST(c, c->host->caption_show(c->host->context, buf));
                fx(c, BUL_FX_CAPTION_SHOW, (int32_t)strlen(buf), 0);
            }
        }
        o->state = BUL_STATE_CAPTION_WAIT;
    }
    *found = got;
    return BUL_OK;
}

/* 0x45ba0b: per-game reset of the working rectangles, positions and counters. */
static int reset_work(Ctx *c)
{
    BulObject *o = c->o;
    const uint8_t *body = c->body;
    for (int i = 0; i < 4; ++i) {
        rd_rect(&o->roll_a[i], body, BUL_B_WORK_SRC + (size_t)i * B_WORK_STRIDE);
        rd_rect(&o->roll_b[i], body, BUL_B_WORK_SRC + (size_t)i * B_WORK_STRIDE);
    }
    o->pos_player = rd_s16(body, BUL_B_START_PLAYER);
    o->pos_computer = rd_s16(body, BUL_B_START_COMPUTER);
    o->mode = 0;
    CHECK(body_rect(c, BUL_B_POSITION_RECT, (int32_t)o->pos_player - 1, 0, B_POSITION_SLOTS, &o->cur_player));
    CHECK(body_rect(c, BUL_B_POSITION_RECT, (int32_t)o->pos_computer - 1, 0, B_POSITION_SLOTS, &o->cur_computer));
    rd_rect(&o->image_player, body, BUL_B_MARKER_IMAGE);
    rd_rect(&o->image_computer, body, BUL_B_MARKER_IMAGE + 16u);
    o->anim_active = 0;
    o->button_kind = 0;
    o->anim_deadline = 0;
    o->button_down = 0;
    return BUL_OK;
}

/* 0x45bbd8: four random working rectangles into set `set` (0: +0x36, 1: +0x76); returns the number of moves. */
static int pick_moves(Ctx *c, int16_t set, int16_t *moves)
{
    BulObject *o = c->o;
    BulRect *dst = set == 0 ? o->roll_a : o->roll_b;
    int16_t odd = 0;
    for (int j = 0; j < 4; ++j) {
        int32_t r;
        int16_t bit, row;
        CHECK(rnd(c, &r));
        bit = (int16_t)(r & 1);
        if (bit == 1) odd = (int16_t)(odd + 1);
        CHECK(rnd(c, &r));
        row = (int16_t)(r & 3);
        rd_rect(&dst[j], c->body, BUL_B_WORK_SRC + (size_t)row * B_WORK_STRIDE + (size_t)bit * 16u);
    }
    if (odd == 0) odd = 5;
    *moves = odd;
    return BUL_OK;
}

/* 0x45bda7: win / lose check. */
static void score_check(Ctx *c)
{
    BulObject *o = c->o;
    const int16_t n = rd_s16(c->body, BUL_B_PIECES);
    if (o->score_player == n) {
        o->won = 1;
        o->state = BUL_STATE_WIN;
        o->finish_kind = 1;
    } else if (o->score_computer == n) {
        o->state = BUL_STATE_LOSE;
        o->finish_kind = 1;
    }
}

/* 0x45bcc1: one step check (the two position words equal). */
static int step_check(Ctx *c, int16_t side, int *matched)
{
    BulObject *o = c->o;
    uint32_t t;
    int found;
    *matched = 0;
    if (o->pos_player != o->pos_computer) return BUL_OK;
    CHECK(caption_pick(c, B_NAMES_STEP + (size_t)side * BUL_B_CAPTION_STRIDE, 4, side, &found));
    o->state = BUL_STATE_SCORE;
    CHECK(tick(c, &t));
    o->deadline_17c = t + 0x4b0u;
    rd_rect(side == 0 ? &o->image_player : &o->image_computer, c->body, BUL_B_MARKER_AFTER + (size_t)side * 16u);
    if (side == 0) {
        o->score_player = add16(o->score_player, 1);
    } else {
        o->score_computer = add16(o->score_computer, 1);
    }
    *matched = 1;
    return BUL_OK;
}

/* Native-only object check (hand-made objects; see the header). */
static int check_object(Ctx *c)
{
    const BulObject *o = c->o;
    const int16_t n = rd_s16(c->body, BUL_B_PIECES), m = rd_s16(c->body, BUL_B_POSITIONS);
    if (o->mode < 0 || o->mode > 3 || o->score_player < 0 || o->score_player > n || o->score_computer < 0 ||
        o->score_computer > n || o->pos_player < 1 || o->pos_player > m || o->pos_computer < 1 || o->pos_computer > m ||
        o->side < 0 || o->side > 1 || o->button_kind < 0 || o->button_kind > 2) {
        c->why = "0xda-object-state";
        return BUL_ERR_UNSUPPORTED;
    }
    return BUL_OK;
}

/* 0x45c18f phase 0. */
static int phase0(Ctx *c, int16_t row)
{
    BulObject *o = c->o;
    const uint8_t *body = c->body;
    int16_t slot;
    int found;
    o->row = row;
    o->active = 1;
    c->w->start_flag_5bb1ca = 1;
    fx(c, BUL_FX_START_FLAG, 1, 0);
    HOST(c, c->host->clear_pending_item(c->host->context));
    fx(c, BUL_FX_CLEAR_ITEM, 0, 0);
    CHECK(reset_work(c));
    memset(&o->moving, 0, sizeof o->moving);
    memset(&o->erase, 0, sizeof o->erase);
    o->score_player = 0;
    o->score_computer = 0;
    /* The two "clearing out" rectangles: copied whole, then right / bottom overwritten (the order of the original). */
    rd_rect(&o->clear[0], body, BUL_B_PLAYER_JAIL);
    o->clear[0].right = rd_s32(body, B_PLAYER_JAIL_LAST_RIGHT);
    o->clear[0].bottom = rd_s32(body, B_PLAYER_JAIL_LAST_RIGHT + 4u);
    rd_rect(&o->clear[1], body, BUL_B_COMPUTER_JAIL);
    o->clear[1].right = rd_s32(body, B_COMPUTER_JAIL_LAST_RIGHT);
    o->clear[1].bottom = rd_s32(body, B_COMPUTER_JAIL_LAST_RIGHT + 4u);
    o->light = rd_s32(body, B_LIGHT_RIGHT) != rd_s32(body, B_LIGHT_LEFT);
    o->state = BUL_STATE_IDLE;
    o->next_state = 0;
    fx(c, BUL_FX_ROW_PHASE, 1, 0);
    HOST(c, c->host->alloc_slot(c->host->context, &slot));
    fx(c, BUL_FX_SLOT, slot, 0);
    if (slot < 0) {
        c->why = "0xda-slot";
        return BUL_ERR_HOST;
    }
    o->slot = slot;
    HOST(c, c->host->register_slot(c->host->context, slot, 10, BUL_CALLBACK_PUZZLE, 0, "BUL PUZZLE OVERLAYS"));
    fx(c, BUL_FX_SLOT_REGISTER, slot, 0);
    if (o->surface == 0) {
        uint32_t surface = 0;
        HOST(c, c->host->load_surface(c->host->context, (const char *)body + B_SURFACE_NAME, &surface));
        fx(c, BUL_FX_SURFACE_LOAD, (int32_t)surface, 0);
        o->surface = surface;
    }
    HOST(c, c->host->set_slot_surface(c->host->context, o->slot, o->surface));
    fx(c, BUL_FX_SLOT_SURFACE, o->slot, (int32_t)o->surface);
    CHECK(prepare_record(c, BUL_B_SOUND_STEP));
    CHECK(prepare_record(c, BUL_B_SOUND_BUTTON));
    CHECK(prepare_record(c, BUL_B_SOUND_BUTTON + BUL_B_SOUND_RECORD_BYTES));
    CHECK(prepare_record(c, BUL_B_SOUND_BUTTON + 2u * BUL_B_SOUND_RECORD_BYTES));
    CHECK(caption_pick(c, B_NAME_PHASE0, 1, 1, &found));
    return BUL_OK;
}

static int set_row_phase_2(Ctx *c, uint32_t *row_phase)
{
    *row_phase = 2u;
    fx(c, BUL_FX_ROW_PHASE, 2, 0);
    return BUL_OK;
}

/* State 0: the button animation / the computer's decision. */
static int state_idle(Ctx *c)
{
    BulObject *o = c->o;
    const uint8_t *body = c->body;
    uint32_t t;
    int found;
    if (o->anim_active == 0) {
        if (body[BUL_B_TWO_PLAYERS] == 0 && o->mode >= 2) {
            int32_t decide = 0;
            if (o->mode == 3 && body[BUL_B_SMART] != 0) {
                const int16_t d = (int16_t)(uint16_t)((uint32_t)(uint16_t)o->pos_computer - (uint32_t)(uint16_t)o->pos_player);
                if (d > 5) {
                    decide = 1;
                } else if (d < 0 && (int32_t)d + rd_s16(body, BUL_B_POSITIONS) > 5) {
                    decide = 1;
                }
            } else if (o->mode == 3) {
                int32_t r;
                CHECK(rnd(c, &r));
                decide = r & 1;
            }
            o->anim_active = 1;
            CHECK(tick(c, &t));
            o->anim_deadline = t + 300u;
            o->button_down = 1;
            if (decide == 0) {
                o->button_kind = 0;
                if (c->w->start_flag_5bb1ca != 0 && !no_sound(body + BUL_B_SOUND_BUTTON)) {
                    CHECK(play_if_idle(c, rd_s16(body, BUL_B_SOUND_BUTTON + B_SOUND_BUTTON_CHANNEL)));
                }
            } else {
                o->button_kind = 1;
            }
        }
        return BUL_OK;
    }
    CHECK(tick(c, &t));
    if (t > o->anim_deadline) {
        o->button_down = 0;
        if (o->button_kind == 0) {
            CHECK(tick(c, &t)); /* the deadlines below read the clock again */
            o->state = BUL_STATE_PICK_MOVES;
            if (body[BUL_B_TWO_PLAYERS] == 0 && o->mode >= 2) {
                o->deadline_16e = t + 1000u;
            } else {
                o->deadline_16e = t + 800u;
            }
        } else if (o->button_kind == 1) {
            o->state = BUL_STATE_CAPTION_PICK;
            if (o->mode == 1) {
                o->mode = 2;
                CHECK(caption_pick(c, B_NAMES_PASS_0, 1, 0, &found));
                o->next_state = 1;
            }
            if (o->mode == 3) {
                o->mode = 0;
                CHECK(caption_pick(c, B_NAMES_PASS_1, 1, 1, &found));
                o->next_state = 1;
            }
            o->button_down = 0;
        } else if (o->button_kind == 2) {
            o->clear[2] = o->cur_player;
            o->clear[3] = o->cur_computer;
            o->state = BUL_STATE_RESET_WAIT;
        }
    }
    return BUL_OK;
}

/* State 3: moving step by step. */
static int state_moving(Ctx *c)
{
    BulObject *o = c->o;
    const uint8_t *body = c->body;
    uint32_t t;
    int found;
    CHECK(tick(c, &t));
    if (t < o->deadline_16e) return BUL_OK;
    o->side = (o->mode == 0 || o->mode == 1) ? 0 : 1;
    if (o->step < o->moves) {
        BulRect *cur = o->side == 0 ? &o->cur_player : &o->cur_computer;
        int16_t *pos = o->side == 0 ? &o->pos_player : &o->pos_computer;
        const int16_t m = rd_s16(body, BUL_B_POSITIONS);
        o->moving = *cur;
        rd_rect(o->side == 0 ? &o->image_player : &o->image_computer, body,
                BUL_B_MARKER_IMAGE + (size_t)o->side * 16u);
        if (o->mode == 0 || o->mode == 1) {
            *pos = *pos == m ? (int16_t)1 : add16(*pos, 1);
        } else {
            *pos = *pos == 1 ? m : add16(*pos, -1);
        }
        CHECK(body_rect(c, BUL_B_POSITION_RECT, (int32_t)*pos - 1, 0, B_POSITION_SLOTS, cur));
        o->step = add16(o->step, 1);
        if (!no_sound(body + BUL_B_SOUND_STEP)) {
            CHECK(play_if_idle(c, rd_s16(body, BUL_B_SOUND_STEP + B_SOUND_BUTTON_CHANNEL)));
        }
        CHECK(tick(c, &t));
        if (body[BUL_B_TWO_PLAYERS] == 0 && o->side == 1) {
            o->deadline_180 = t + 400u;
        } else {
            o->deadline_180 = t + 200u;
        }
        o->state = BUL_STATE_WAIT;
    } else {
        int matched;
        CHECK(step_check(c, o->side, &matched));
        if (!matched) {
            o->state = BUL_STATE_IDLE;
            if (o->mode == 3) {
                CHECK(caption_pick(c, B_NAMES_END_3, 4, 1, &found));
                if (found) {
                    o->next_state = 1;
                } else {
                    o->state = BUL_STATE_CAPTION_PICK;
                }
                o->mode = 0;
            } else {
                if (o->mode == 1) {
                    CHECK(caption_pick(c, B_NAMES_END_1, 4, 0, &found));
                    if (found) {
                        o->next_state = 1;
                    } else {
                        o->state = BUL_STATE_CAPTION_PICK;
                    }
                }
                o->mode = add16(o->mode, 1);
            }
        }
    }
    return BUL_OK;
}

/* State 6: the score step is over; the moving piece and the erase rectangle are set up and the game is reset. */
static int state_score(Ctx *c)
{
    BulObject *o = c->o;
    const uint8_t *body = c->body;
    const int32_t n = rd_s16(body, BUL_B_PIECES);
    uint32_t t;
    CHECK(tick(c, &t));
    if (t > o->deadline_17c) {
        if (o->mode == 0 || o->mode == 1) {
            o->moving = o->cur_computer;
            CHECK(body_rect(c, BUL_B_COMPUTER_BARRACK, n - o->score_player - 1, -1, PIECE_SLOTS, &o->erase));
        } else {
            o->moving = o->cur_player;
            CHECK(body_rect(c, BUL_B_PLAYER_BARRACK, n - o->score_computer - 1, -1, PIECE_SLOTS, &o->erase));
        }
        o->state = BUL_STATE_IDLE;
        score_check(c);
        CHECK(reset_work(c));
    }
    return BUL_OK;
}

/* A win / lose caption (states 7 and 8). */
static int state_finish_caption(Ctx *c, size_t names, int16_t entry, uint32_t *row_phase)
{
    BulObject *o = c->o;
    int found;
    CHECK(caption_pick(c, names, 4, entry, &found));
    if (!found) {
        CHECK(set_row_phase_2(c, row_phase));
    } else {
        uint32_t t;
        o->next_state = BUL_STATE_EXIT_DELAY;
        CHECK(tick(c, &t));
        o->deadline_16e = t + 500u;
    }
    return BUL_OK;
}

/* 0x45c18f phase 1. */
static int phase1(Ctx *c, uint32_t *row_phase)
{
    BulObject *o = c->o;
    const uint8_t *body = c->body;
    uint32_t t;
    int found;
    int is_busy;
    switch (o->state) {
    case BUL_STATE_IDLE:
        return state_idle(c);
    case BUL_STATE_CAPTION_PICK:
        o->state = BUL_STATE_IDLE;
        if (o->mode == 0) {
            CHECK(caption_pick(c, B_NAMES_ROLL_0, 4, 0, &found));
            if (found) o->next_state = 0;
        } else if (o->mode == 2) {
            CHECK(caption_pick(c, B_NAMES_ROLL_1, 4, 1, &found));
            if (found) o->next_state = 0;
        }
        return BUL_OK;
    case BUL_STATE_PICK_MOVES:
        o->step = 0;
        CHECK(pick_moves(c, (o->mode == 0 || o->mode == 1) ? 0 : 1, &o->moves));
        o->anim_active = 0;
        o->state = BUL_STATE_MOVING;
        return BUL_OK;
    case BUL_STATE_MOVING:
        return state_moving(c);
    case BUL_STATE_WAIT:
        CHECK(tick(c, &t));
        if (t > o->deadline_180) o->state = BUL_STATE_MOVING;
        return BUL_OK;
    case BUL_STATE_SCORE:
        return state_score(c);
    case BUL_STATE_WIN:
        return state_finish_caption(c, B_NAMES_WIN, 0, row_phase);
    case BUL_STATE_LOSE:
        return state_finish_caption(c, B_NAMES_LOSE, 1, row_phase);
    case BUL_STATE_RESET_WAIT:
        CHECK(busy(c, rd_s16(body, B_BUTTON2_CHANNEL), &is_busy));
        if (!is_busy) {
            o->score_player = 0;
            o->score_computer = 0;
            CHECK(reset_work(c));
            o->state = BUL_STATE_IDLE;
        }
        return BUL_OK;
    case BUL_STATE_CAPTION_WAIT:
        CHECK(busy(c, o->cap_channel, &is_busy));
        if (!is_busy) o->state = o->next_state;
        return BUL_OK;
    case BUL_STATE_EXIT_DELAY:
        CHECK(tick(c, &t));
        if (t >= o->deadline_16e) CHECK(set_row_phase_2(c, row_phase));
        return BUL_OK;
    default:
        return BUL_OK; /* state 5 and states above 0xb do nothing */
    }
}

/* A finish block of phase 2: the seven scene-change cells, the start flag and the engine mode. */
static int apply_block(Ctx *c, size_t blk)
{
    const uint8_t *b = c->body + blk;
    BulTransition t;
    t.scene = rd_s16(b, SB_SCENE);
    t.word[0] = rd_s16(b, SB_W1);
    t.word[1] = rd_s16(b, SB_W2);
    t.word[2] = rd_s16(b, SB_W3);
    t.dword[0] = rd_s32(b, SB_D1);
    t.dword[1] = rd_s32(b, SB_D2);
    t.dword[2] = rd_s32(b, SB_D3);
    HOST(c, c->host->transition(c->host->context, &t));
    fx(c, BUL_FX_XFER_5BB57B, t.scene, 0);
    fx(c, BUL_FX_XFER_5BB599, t.word[0], 0);
    fx(c, BUL_FX_XFER_5BB595, t.word[1], 0);
    fx(c, BUL_FX_XFER_5C39FF, t.word[2], 0);
    fx(c, BUL_FX_XFER_5BB59B, t.dword[0], 0);
    fx(c, BUL_FX_XFER_5BB59F, t.dword[1], 0);
    fx(c, BUL_FX_XFER_5BB5A3, t.dword[2], 0);
    c->w->start_flag_5bb1ca = rd_s16(b, SB_START) != 1 ? 1 : 0;
    fx(c, BUL_FX_START_FLAG, c->w->start_flag_5bb1ca, 0);
    HOST(c, c->host->engine_mode(c->host->context, 4));
    fx(c, BUL_FX_ENGINE_MODE, 4, 0);
    return BUL_OK;
}

static int store_flag(Ctx *c, int16_t index, uint8_t value)
{
    HOST(c, c->host->store_event_flag(c->host->context, index, value));
    fx(c, BUL_FX_EVENT_FLAG, index, value);
    return BUL_OK;
}

/* The event flag index phase 2 would store (BUL_NO_FLAG when none) and its byte value. */
static int16_t finish_flag(const BulObject *o, const uint8_t *body, uint8_t *value)
{
    if (o->finish_kind == 0) {
        *value = body[BUL_B_BLOCK_LEFT + SB_VALUE];
        return rd_s16(body, BUL_B_BLOCK_LEFT + SB_FLAG);
    }
    if (o->won != 0) {
        *value = body[BUL_B_BLOCK_ENDED + SB_VALUE];
        return rd_s16(body, BUL_B_BLOCK_ENDED + SB_FLAG);
    }
    *value = body[BUL_B_BLOCK_ENDED + SB_VALUE2];
    return rd_s16(body, BUL_B_BLOCK_ENDED + SB_FLAG2);
}

/* 0x45c18f phase 2 up to the generic completion. */
static int phase2(Ctx *c)
{
    const BulObject *o = c->o;
    const uint8_t *body = c->body;
    uint8_t value;
    int16_t flag;
    c->w->start_flag_5bb1ca = 1;
    fx(c, BUL_FX_START_FLAG, 1, 0);
    CHECK(stop_record(c, BUL_B_SOUND_BUTTON));
    CHECK(stop_record(c, BUL_B_SOUND_BUTTON + BUL_B_SOUND_RECORD_BYTES));
    CHECK(stop_record(c, BUL_B_SOUND_BUTTON + 2u * BUL_B_SOUND_RECORD_BYTES));
    if (o->finish_kind == 0) {
        if (rd_s16(body, BUL_B_BLOCK_LEFT + SB_SCENE) != BUL_NO_SCENE) CHECK(apply_block(c, BUL_B_BLOCK_LEFT));
    } else {
        if (rd_s16(body, BUL_B_BLOCK_ENDED + SB_SCENE) != BUL_NO_SCENE) CHECK(apply_block(c, BUL_B_BLOCK_ENDED));
    }
    flag = finish_flag(o, body, &value);
    if (flag != BUL_NO_FLAG) CHECK(store_flag(c, flag, value));
    return BUL_OK;
}

static int host_complete(const BulHost *host)
{
    return host != NULL && host->alloc_slot != NULL && host->register_slot != NULL && host->load_surface != NULL &&
           host->set_slot_surface != NULL && host->release_surface != NULL && host->release_slot != NULL &&
           host->mark_dirty != NULL && host->view_origin != NULL && host->clear_pending_item != NULL &&
           host->sound_prepare != NULL && host->sound_stop != NULL && host->sound_busy != NULL &&
           host->sound_play != NULL && host->caption_text != NULL && host->caption_show != NULL && host->tick != NULL &&
           host->random != NULL && host->event_flag_invalid != NULL && host->transition != NULL &&
           host->store_event_flag != NULL && host->engine_mode != NULL;
}

static void ctx_init(Ctx *c, BulObject *o, const uint8_t *body, BulWorld *w, const BulHost *host)
{
    c->o = o;
    c->body = body;
    c->w = w;
    c->host = host;
    c->why = NULL;
}

int bul_step(BulObject *object, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, BulWorld *world,
             const BulHost *host, BulResult *result, const char **failure)
{
    const char *why = NULL;
    uint32_t row_phase = phase;
    Ctx c;
    int rc;
    if (failure != NULL) *failure = NULL;
    if (object == NULL || body == NULL || world == NULL || result == NULL || !host_complete(host)) {
        if (failure != NULL) *failure = "0xda-argument";
        return BUL_ERR_ARGUMENT;
    }
    memset(result, 0, sizeof(*result));
    result->phase_after = phase;
    if (bul_validate_body(body, body_length, &why) != BUL_OK) {
        if (failure != NULL) *failure = why;
        return BUL_ERR_BODY;
    }
    ctx_init(&c, object, body, world, host);
    if (phase == 0u) {
        if (row < 0) {
            if (failure != NULL) *failure = "0xda-row";
            return BUL_ERR_ARGUMENT;
        }
        rc = phase0(&c, row);
        if (rc == BUL_OK) {
            row_phase = 1u;
            result->initialized = 1u;
        }
    } else if (phase == 1u) {
        if (object->active == 0 || object->row != row) {
            if (failure != NULL) *failure = "0xda-phase-1-without-init";
            return BUL_ERR_UNSUPPORTED;
        }
        {
            const int pre = check_object(&c);
            if (pre != BUL_OK) {
                if (failure != NULL) *failure = c.why;
                return pre;
            }
        }
        rc = phase1(&c, &row_phase);
    } else if (phase == 2u) {
        if (object->row != row) {
            if (failure != NULL) *failure = "0xda-phase-2-without-init";
            return BUL_ERR_UNSUPPORTED;
        }
        /* Refuse before any effect when the finish block names a flag the host cannot store. */
        {
            uint8_t value;
            const int16_t flag = finish_flag(object, body, &value);
            if (flag != BUL_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {
                if (failure != NULL) *failure = "0xda-event-flag-index";
                return BUL_ERR_BOUNDS;
            }
        }
        rc = phase2(&c);
        if (rc == BUL_OK) {
            fx(&c, BUL_FX_COMPLETE, object->row, 0);
            result->completed = 1u;
            rc = bul_cleanup(object, host);
            row_phase = 0u;
            if (rc != BUL_OK) c.why = "0xda-host";
        }
    } else {
        return BUL_OK;
    }
    result->phase_after = row_phase;
    if (rc != BUL_OK && failure != NULL) *failure = c.why != NULL ? c.why : "0xda-host-or-bounds";
    return rc;
}

int bul_pointer(BulObject *object, const uint8_t *body, size_t body_length, int32_t x, int32_t y, BulPointerResult *out)
{
    int16_t px, py;
    int32_t kind = -1;
    if (object == NULL || body == NULL || out == NULL || body_length != BUL_BODY_BYTES) return BUL_ERR_ARGUMENT;
    px = (int16_t)(uint16_t)x;
    py = (int16_t)(uint16_t)y;
    memset(out, 0, sizeof *out);
    out->candidate = -1;
    out->button = -1;
    if (object->active == 0 || object->anim_active != 0) return BUL_OK;
    if (body[BUL_B_TWO_PLAYERS] == 0 && object->mode >= 2) return BUL_OK;
    {
        const size_t b0 = BUL_B_BUTTON_RECT, b1 = BUL_B_BUTTON_RECT + 16u, b2 = BUL_B_BUTTON_RECT + 32u;
        if (py >= sub32(rd_s32(body, b0 + 4), 5) && py <= add32(rd_s32(body, b0 + 12), 5) && px >= rd_s32(body, b0) &&
            px <= rd_s32(body, b0 + 8)) {
            kind = 0;
        } else if ((object->mode == 1 || object->mode == 3) && py >= add32(rd_s32(body, b1 + 4), 5) &&
                   py <= add32(rd_s32(body, b1 + 12), 5) && px >= add32(rd_s32(body, b1), 10) &&
                   px <= sub32(rd_s32(body, b1 + 8), 10)) {
            kind = 1;
        } else if (py >= rd_s32(body, b2 + 4) && py <= rd_s32(body, b2 + 12) && px >= rd_s32(body, b2) &&
                   px <= rd_s32(body, b2 + 8)) {
            kind = 2;
        }
    }
    out->cursor_sub = 1;
    out->cursor_link = 1;
    if (kind >= 0) {
        /* 0x45b7a8 (candidate 0x27ba): cursor 0x16, the button kind goes to obj+0x172. */
        out->hit = 1;
        out->candidate = BUL_CANDIDATE_BUTTON;
        out->cursor_kind = 0x16;
        out->cursor_cell = 0x5b160cu + 0x16u * 32u + 16u;
        object->pending_button = (int16_t)kind;
        out->button = kind;
        return BUL_OK;
    }
    if (py >= rd_s32(body, BUL_B_FINISH_RECT + 4) && py <= rd_s32(body, BUL_B_FINISH_RECT + 12) &&
        px >= rd_s32(body, BUL_B_FINISH_RECT) && px <= rd_s32(body, BUL_B_FINISH_RECT + 8)) {
        /* 0x45b7a8 (candidate 0x27bb): cursor 9. */
        out->hit = 1;
        out->candidate = BUL_CANDIDATE_FINISH;
        out->cursor_kind = 9;
        out->cursor_cell = 0x5b160cu + 9u * 32u + 16u;
        return BUL_OK;
    }
    out->cursor_sub = 0;
    out->cursor_link = 0;
    return BUL_OK;
}

int bul_click(BulObject *object, const uint8_t *body, size_t body_length, const BulWorld *world, const BulHost *host,
              uint32_t row_phase, int32_t candidate, BulClickResult *out)
{
    BulWorld local;
    Ctx c;
    if (out != NULL) {
        out->handled = 0;
        out->new_phase = row_phase;
    }
    if (object == NULL || body == NULL || world == NULL || out == NULL || !host_complete(host) ||
        body_length != BUL_BODY_BYTES) {
        return BUL_ERR_ARGUMENT;
    }
    if (object->active == 0 || object->won != 0 || object->state != 0 || row_phase != 1u) return BUL_OK;
    local = *world;
    ctx_init(&c, object, body, &local, host);
    if (candidate == BUL_CANDIDATE_FINISH) {
        int found;
        out->handled = 1;
        CHECK(caption_pick(&c, B_NAMES_CLICK, 4, 0, &found));
        if (!found) {
            out->new_phase = 2u;
            fx(&c, BUL_FX_ROW_PHASE, 2, 0);
        } else {
            uint32_t t;
            object->next_state = BUL_STATE_EXIT_DELAY;
            CHECK(tick(&c, &t));
            object->deadline_16e = t + 800u;
        }
    } else if (candidate == BUL_CANDIDATE_BUTTON) {
        uint32_t t;
        const int16_t kind = object->pending_button;
        if (kind < 0 || kind > 2) return BUL_ERR_UNSUPPORTED;
        out->handled = 1;
        object->anim_active = 1;
        object->button_kind = kind;
        CHECK(tick(&c, &t));
        object->anim_deadline = t + 250u;
        object->button_down = 1;
        if (local.start_flag_5bb1ca != 0) {
            const size_t rec = BUL_B_SOUND_BUTTON + (size_t)kind * BUL_B_SOUND_RECORD_BYTES;
            if (!no_sound(body + rec)) CHECK(play_if_idle(&c, rd_s16(body, rec + B_SOUND_BUTTON_CHANNEL)));
        }
    }
    return BUL_OK;
}

int bul_invalidate(const BulObject *object, const BulHost *host)
{
    if (object == NULL || !host_complete(host)) return BUL_ERR_ARGUMENT;
    if (object->active != 0 && object->slot != BUL_NO_SLOT) {
        if (host->mark_dirty(host->context, object->slot) != 0) return BUL_ERR_HOST;
        if (host->observe != NULL) host->observe(host->context, BUL_FX_MARK_DIRTY, object->slot, 0);
    }
    return BUL_OK;
}

int bul_cleanup(BulObject *object, const BulHost *host)
{
    if (object == NULL || !host_complete(host)) return BUL_ERR_ARGUMENT;
    if (object->surface != 0) {
        const uint32_t held = object->surface;
        if (host->release_surface(host->context, held) != 0) return BUL_ERR_HOST;
        if (host->observe != NULL) host->observe(host->context, BUL_FX_RELEASE_SURFACE, (int32_t)held, 0);
        object->surface = 0; /* 0x4c2dfb zeroes the handle */
    }
    if (object->slot != BUL_NO_SLOT) {
        if (host->release_slot(host->context, object->slot) != 0) return BUL_ERR_HOST;
        if (host->observe != NULL) host->observe(host->context, BUL_FX_RELEASE_SLOT, object->slot, 0);
    }
    /* 0x45b3ea */
    object->row = -1;
    object->slot = -1;
    object->active = 0;
    object->won = 0;
    object->finish_kind = 0;
    return BUL_OK;
}

static int emit_pair(Ctx *c, BulRenderResult *out, int kind, int32_t index, int backdrop, const BulRect *src,
                     const BulRect *rect, int32_t vx, int32_t vy)
{
    BulBlit *e;
    if (out->count >= BUL_MAX_BLITS) {
        c->why = "0xda-blit-overflow";
        return BUL_ERR_BOUNDS;
    }
    e = &out->blit[out->count++];
    e->kind = kind;
    e->index = index;
    e->backdrop = backdrop;
    e->src = *src;
    e->dst = shifted(rect, vx, vy); /* 0x45b568 */
    fx(c, BUL_FX_BLIT, kind, index);
    return BUL_OK;
}

/* src and rect both from body offsets. */
static int emit_body(Ctx *c, BulRenderResult *out, int kind, int32_t index, int backdrop, size_t src_off, size_t rect_off,
                     int32_t vx, int32_t vy)
{
    BulRect src, rect;
    rd_rect(&src, c->body, src_off);
    rd_rect(&rect, c->body, rect_off);
    return emit_pair(c, out, kind, index, backdrop, &src, &rect, vx, vy);
}

/* One array of piece blits: for i in [0, count): src = the piece image, rect = the array slot i. */
static int emit_pieces(Ctx *c, BulRenderResult *out, int kind, int32_t count, size_t array, size_t image, int32_t vx, int32_t vy)
{
    BulRect src, rect;
    for (int32_t i = 0; i < count; ++i) {
        CHECK(body_rect(c, array, i, 0, PIECE_SLOTS, &rect));
        rd_rect(&src, c->body, image);
        CHECK(emit_pair(c, out, kind, i, 0, &src, &rect, vx, vy));
    }
    return BUL_OK;
}

/* A backdrop erase of an object rectangle (src and rect are the same rectangle). */
static int emit_erase(Ctx *c, BulRenderResult *out, int kind, const BulRect *r, int32_t vx, int32_t vy)
{
    return emit_pair(c, out, kind, 0, 1, r, r, vx, vy);
}

int bul_render(BulObject *object, const uint8_t *body, size_t body_length, const BulHost *host, BulRenderResult *out)
{
    BulWorld none;
    Ctx c;
    int32_t vx = 0, vy = 0;
    int32_t n;
    if (out != NULL) {
        out->valid = 0;
        out->count = 0;
    }
    if (object == NULL || body == NULL || out == NULL || !host_complete(host) || body_length != BUL_BODY_BYTES) {
        return BUL_ERR_ARGUMENT;
    }
    if (object->active == 0 || object->slot == BUL_NO_SLOT) return BUL_OK; /* no callback without a z entry */
    memset(&none, 0, sizeof none);
    ctx_init(&c, object, body, &none, host);
    CHECK(check_object(&c));
    out->valid = 1;
    HOST(&c, host->view_origin(host->context, &vx, &vy));
    n = rd_s16(body, BUL_B_PIECES);
    for (int i = 0; i < 4; ++i) {
        BulRect rect;
        rd_rect(&rect, body, BUL_B_ROLL_A_DST + (size_t)i * 16u);
        CHECK(emit_pair(&c, out, BUL_BLIT_ROLL_A, i, 0, &object->roll_a[i], &rect, vx, vy));
    }
    for (int i = 0; i < 4; ++i) {
        BulRect rect;
        rd_rect(&rect, body, BUL_B_ROLL_B_DST + (size_t)i * 16u);
        CHECK(emit_pair(&c, out, BUL_BLIT_ROLL_B, i, 0, &object->roll_b[i], &rect, vx, vy));
    }
    CHECK(emit_pieces(&c, out, BUL_BLIT_PLAYER_BARRACK, n - object->score_computer - 1, BUL_B_PLAYER_BARRACK,
                      BUL_B_PIECE_PLAYER_BARRACK, vx, vy));
    CHECK(emit_pieces(&c, out, BUL_BLIT_PLAYER_JAIL, object->score_player, BUL_B_PLAYER_JAIL, BUL_B_PIECE_PLAYER_JAIL, vx, vy));
    CHECK(emit_pieces(&c, out, BUL_BLIT_COMPUTER_BARRACK, n - object->score_player - 1, BUL_B_COMPUTER_BARRACK,
                      BUL_B_PIECE_COMPUTER_BARRACK, vx, vy));
    CHECK(emit_pieces(&c, out, BUL_BLIT_COMPUTER_JAIL, object->score_computer, BUL_B_COMPUTER_JAIL,
                      BUL_B_PIECE_COMPUTER_JAIL, vx, vy));
    CHECK(emit_pieces(&c, out, BUL_BLIT_PLAYER_JAIL_AGAIN, object->score_player, BUL_B_PLAYER_JAIL, BUL_B_PIECE_PLAYER_JAIL,
                      vx, vy));
    if (object->erase.right != 0) {
        CHECK(emit_erase(&c, out, BUL_BLIT_ERASE_BARRACK, &object->erase, vx, vy));
        memset(&object->erase, 0, sizeof object->erase);
    }
    if (object->mode == 0 || (object->mode == 1 && object->light != 0)) {
        CHECK(emit_body(&c, out, BUL_BLIT_PLAYER_LIGHT, 0, 0, BUL_B_PLAYER_LIGHT_ON, BUL_B_PLAYER_LIGHT, vx, vy));
        CHECK(emit_body(&c, out, BUL_BLIT_COMPUTER_LIGHT_OFF, 0, 1, BUL_B_COMPUTER_LIGHT, BUL_B_COMPUTER_LIGHT, vx, vy));
    } else if (object->light != 0) {
        CHECK(emit_body(&c, out, BUL_BLIT_COMPUTER_LIGHT, 0, 0, BUL_B_COMPUTER_LIGHT_ON, BUL_B_COMPUTER_LIGHT, vx, vy));
        CHECK(emit_body(&c, out, BUL_BLIT_PLAYER_LIGHT_OFF, 0, 1, BUL_B_PLAYER_LIGHT, BUL_B_PLAYER_LIGHT, vx, vy));
    }
    if (object->mode == 0 || object->mode == 2) {
        CHECK(emit_body(&c, out, BUL_BLIT_PASS_DISABLED, 0, 0, BUL_B_PASS_DISABLED, BUL_B_BUTTON_RECT + 16u, vx, vy));
    } else {
        CHECK(emit_body(&c, out, BUL_BLIT_PASS_ENABLED, 0, 1, BUL_B_BUTTON_RECT + 16u, BUL_B_BUTTON_RECT + 16u, vx, vy));
    }
    if (object->anim_active != 0) {
        const int16_t k = object->button_kind;
        if (object->button_down != 0) {
            CHECK(emit_body(&c, out, BUL_BLIT_BUTTON_DOWN, k, 0, BUL_B_BUTTON_DOWN_IMAGE + (size_t)k * 16u,
                            BUL_B_BUTTON_RECT + (size_t)k * 16u, vx, vy));
        } else {
            CHECK(emit_body(&c, out, BUL_BLIT_BUTTON_UP, k, 1, BUL_B_BUTTON_RECT + (size_t)k * 16u,
                            BUL_B_BUTTON_RECT + (size_t)k * 16u, vx, vy));
            object->anim_active = 0;
        }
    }
    if (object->finish_kind == 0) {
        if (object->state != BUL_STATE_SCORE || object->side == 0) {
            CHECK(emit_pair(&c, out, BUL_BLIT_PLAYER_PIECE, 0, 0, &object->image_player, &object->cur_player, vx, vy));
        }
        if (object->state != BUL_STATE_SCORE || object->side == 1) {
            CHECK(emit_pair(&c, out, BUL_BLIT_COMPUTER_PIECE, 0, 0, &object->image_computer, &object->cur_computer, vx, vy));
        }
    }
    if (object->moving.right != 0) {
        CHECK(emit_erase(&c, out, BUL_BLIT_ERASE_MOVING, &object->moving, vx, vy));
        memset(&object->moving, 0, sizeof object->moving);
    }
    if (object->state == BUL_STATE_RESET_WAIT) {
        for (int i = 0; i < 4; ++i) CHECK(emit_erase(&c, out, BUL_BLIT_CLEAR_PLAYER + i, &object->clear[i], vx, vy));
    }
    return BUL_OK;
}
