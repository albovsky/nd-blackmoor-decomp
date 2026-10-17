#include "action_family_f6_runtime.h"

#include <string.h>

/* Body offsets (see the header). */
enum {
    B_A = 0x21,
    B_B = 0x22,
    B_C = 0x23,
    B_MODE = 0x24,
    B_COLS = 0x25,
    B_ROWS = 0x27,
    B_DEAL = 0x29,
    B_TURN_SRC = 0x2b,
    B_TURN_DST = 0x4b,
    B_CARD_FACE = 0x6b,
    B_BUTTON_DOWN = 0x3ab,
    B_SUIT_SRC = 0x47b,
    B_SUIT_DST = 0x48b,
    B_SLIDE_STEPS = 0x62b,
    B_SLIDE_STEP = 0x62d,
    B_SLIDE_INTERVAL = 0x62f,
    B_DISPLAY = 0x633,
    B_BUTTON = 0x653,
    B_CARD = 0x723,
    B_DELIVER_FRAMES = 0x993,
    B_DELIVER_PASSES = 0x995,
    B_DELIVER_INTERVAL = 0x997,
    B_DELIVER_RECT = 0x99b,
    B_DELIVER_AREA = 0xa8b,
    B_NOCARD_FRAMES = 0xa9b,
    B_NOCARD_PASSES = 0xa9d,
    B_NOCARD_INTERVAL = 0xa9f,
    B_NOCARD_RECT = 0xaa3,
    B_NOCARD_AREA = 0xb93,
    B_LINE_PICK = 0xba3,
    B_LINE_DELIVER = 0xbc4,
    B_LINE_SLIDE = 0xbe5,
    B_LINE_DRAW = 0xc06,
    B_LINES_COMPUTER = 0xc2b,
    B_LISTS = 0xdd8,
    B_LIST_FOUND = 0xe7d,
    B_LIST_SET = 0xee0,
    B_LIST_END = 0xf22,
    B_CHANNEL_A = 0xf64,
    B_CHANNEL_B = 0xf66,
    B_LINES_HUMAN = 0xf68,
    B_LIST_END_LOSE = 0x125f,
    B_LIST_END_DRAW = 0x12a1,
    B_WIN = 0x1304,
    B_EXIT = 0x1320,
    B_EXIT_RECT = 0x1336
};
#define LIST_PLAYER_STRIDE 0x33d
#define NAME_STRIDE 0x21

/* Offsets inside the finish block at B_WIN (two scene words) and the exit block at B_EXIT. */
enum { WB_SCENE0 = 0, WB_SCENE1 = 2, WB_W1 = 4, WB_W2 = 6, WB_W3 = 8, WB_D1 = 10, WB_D2 = 14, WB_D3 = 18,
       WB_START = 22, WB_FLAG0 = 24, WB_FLAG1 = 26 };
enum { XB_SCENE = 0, XB_W1 = 2, XB_W2 = 4, XB_W3 = 6, XB_D1 = 8, XB_D2 = 12, XB_D3 = 16, XB_START = 20 };

/* Object states (obj+0x39e). */
enum {
    ST_DELIVER = 1,
    ST_NO_CARD = 2,
    ST_SLIDE = 3,
    ST_TURN = 4,
    ST_CHOOSE = 5,
    ST_ASK_HUMAN = 6,
    ST_ASK_COMPUTER = 7,
    ST_SET = 8,
    ST_DRAW = 9,
    ST_LINE = 10,
    ST_WAIT = 11,
    ST_END = 12
};

static int16_t rd_s16(const uint8_t *b, size_t off)
{
    return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));
}

static int32_t rd_s32(const uint8_t *b, size_t off)
{
    return (int32_t)((uint32_t)b[off] | ((uint32_t)b[off + 1] << 8) | ((uint32_t)b[off + 2] << 16) |
                     ((uint32_t)b[off + 3] << 24));
}

static void fx(const F6Host *host, int effect, int32_t a, int32_t b)
{
    if (host->observe != NULL) host->observe(host->context, effect, a, b);
}

#define HOST(call) do { if ((call) != 0) { return F6_ERR_HOST; } } while (0)
#define CHECK(expr) do { const int rc_ = (expr); if (rc_ != F6_OK) return rc_; } while (0)

typedef struct Ctx {
    F6Object *o;
    const uint8_t *b;
    const F6Host *h;
    const char *failure;
} Ctx;

static int bounds(Ctx *c, const char *why)
{
    c->failure = why;
    return F6_ERR_BOUNDS;
}

static int rows_of(const Ctx *c) { return rd_s16(c->b, B_ROWS); }
static int cols_of(const Ctx *c) { return rd_s16(c->b, B_COLS); }

/* The tick and rand of the original, one effect each. */
static int tick(Ctx *c, uint32_t *now)
{
    *now = c->h->tick(c->h->context);
    fx(c->h, F6_FX_TICK, (int32_t)*now, 0);
    return F6_OK;
}

static int draw(Ctx *c, int32_t *value)
{
    *value = c->h->random(c->h->context);
    fx(c->h, F6_FX_RAND, *value, 0);
    return F6_OK;
}

/* 0x45e67d: the name is neither the 9 bytes "NO SOUND\0" nor empty. */
static int real_sound(const uint8_t *name)
{
    static const uint8_t k[9] = {'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0};
    if (memcmp(name, k, sizeof k) == 0) return 0;
    return name[0] != 0;
}

static void rect_copy(int32_t *dst, const uint8_t *body, size_t off)
{
    for (int k = 0; k < 4; ++k) dst[k] = rd_s32(body, off + (size_t)k * 4u);
}

static void copy_name(uint8_t *record, const uint8_t *name)
{
    size_t n = 0;
    while (n < F6_NAME_BYTES && name[n] != 0) ++n;
    memcpy(record, name, n);
    record[n] = 0;
}

static int16_t record_channel(const F6Object *o) { return rd_s16(o->record, 0x21); }

/* 0x45e6bd(names, record, count): pick a line, play it and show its caption. */
static int pick_line(Ctx *c, size_t names_off, int16_t count)
{
    F6Object *o = c->o;
    const uint8_t *names = c->b + names_off;
    int found = 0;
    if (count < 2) {
        if (real_sound(names)) {
            copy_name(o->record, names);
            found = 1;
        }
    } else {
        int picked[10] = {0};
        int all = 0;
        int guard = 0;
        if (count > 10) return bounds(c, "0xf6-pick-count");
        while (found == 0 && all == 0) {
            int32_t r;
            int16_t idx;
            uint8_t name[F6_NAME_BYTES];
            if (++guard > F6_PICK_LIMIT) {
                c->failure = "0xf6-pick-loop";
                return F6_ERR_STUCK;
            }
            CHECK(draw(c, &r));
            idx = (int16_t)(r % (int32_t)count);
            copy_name(name, names + (size_t)idx * NAME_STRIDE);
            if (!real_sound(name)) {
                picked[idx] = 1;
                all = 1;
                for (int16_t k = 0; k < count; ++k)
                    if (picked[k] == 0) all = 0;
            } else {
                copy_name(o->record, name);
                found = 1;
            }
        }
    }
    if (found != 0) {
        const char *text = NULL;
        HOST(c->h->sound_prepare(c->h->context, o->record));
        fx(c->h, F6_FX_SOUND_PREPARE, 0, 0);
        HOST(c->h->sound_play(c->h->context, record_channel(o)));
        fx(c->h, F6_FX_SOUND_PLAY, record_channel(o), 0);
        o->channel = record_channel(o);
        HOST(c->h->autotext(c->h->context, (const char *)o->record, &text));
        fx(c->h, F6_FX_AUTOTEXT, text != NULL ? 1 : 0, 0);
        if (text != NULL) {
            const size_t len = strlen(text);
            if (len <= F6_TEXT_MAX) {
                char buffer[F6_TEXT_MAX + 4u];
                memcpy(buffer, text, len);
                memcpy(buffer + len, "<e>", 4u);
                HOST(c->h->caption(c->h->context, buffer, len + 3u));
                fx(c->h, F6_FX_CAPTION, (int32_t)len, 0);
                o->caption_shown = 1;
            }
        }
        o->state = ST_LINE;
    }
    return F6_OK;
}

/* 0x45e906: move the card of column `col`, suit row `row` from player `from` to player `to`. */
static int move_card(Ctx *c, int16_t col, int16_t row, int16_t from, int16_t to)
{
    F6Object *o = c->o;
    if (col < 0 || col >= F6_MAX_COLUMNS || row < 0 || row >= F6_CARD_ROWS || from < 0 || from > 1 || to < 0 || to > 1)
        return bounds(c, "0xf6-move-index");
    o->card[from][row][col] = 0;
    o->count[from][col] = (int16_t)(o->count[from][col] - 1);
    o->card[to][row][col] = 1;
    o->count[to][col] = (int16_t)(o->count[to][col] + 1);
    return F6_OK;
}

/* 0x45e9db: the first suit row of column `col` that `player` holds. */
static int find_card(Ctx *c, int16_t col, int16_t player, int16_t *row, int *found)
{
    if (col < 0 || col >= F6_MAX_COLUMNS || player < 0 || player > 1) return bounds(c, "0xf6-find-index");
    *found = 0;
    for (int16_t r = 0; r < rows_of(c); ++r) {
        if (c->o->card[player][r][col] == 1) {
            *row = r;
            *found = 1;
            return F6_OK;
        }
    }
    return F6_OK;
}

/* 0x45de8a: deal one card (or end the game) for `player`. Returns the column, -1 when none. */
static int deal(Ctx *c, int16_t player, int16_t *col_out)
{
    F6Object *o = c->o;
    const uint8_t *b = c->b;
    if (player < 0 || player > 1) return bounds(c, "0xf6-deal-player");
    if (o->deck_left < 1) {
        if (o->score[1] < o->score[0]) {
            CHECK(pick_line(c, B_LIST_END, 2));
            o->outcome_2a8 = 0;
        } else if (o->score[0] == o->score[1]) {
            /* 0x45df28 compares an unsigned byte with -1: the unset branch is dead. */
            if (b[B_MODE] == 2) {
                CHECK(pick_line(c, B_LIST_END + (size_t)player * LIST_PLAYER_STRIDE, 2));
                o->outcome_2a8 = (uint8_t)(player == 1);
            } else if (b[B_MODE] == 0) {
                CHECK(pick_line(c, B_LIST_END, 2));
                o->outcome_2a8 = 0;
            } else {
                CHECK(pick_line(c, B_LIST_END_LOSE, 2));
                o->outcome_2a8 = 1;
            }
        } else {
            CHECK(pick_line(c, B_LIST_END_LOSE, 2));
            o->outcome_2a8 = 1;
        }
        o->next_state = ST_END;
        *col_out = -1;
        return F6_OK;
    }
    {
        const int free_pick = o->deck_left <= cols_of(c);
        int placed = 0;
        int16_t col = -1;
        int guard = 0;
        while (!placed) {
            int32_t r1, r2;
            int16_t row;
            if (++guard > F6_PICK_LIMIT) {
                c->failure = "0xf6-deal-loop";
                return F6_ERR_STUCK;
            }
            CHECK(draw(c, &r1));
            row = (int16_t)(r1 % (int32_t)rows_of(c));
            CHECK(draw(c, &r2));
            col = (int16_t)(r2 % (int32_t)cols_of(c));
            if (o->deck[row][col] != 0 && (free_pick || o->count[player][col] + 1 < 3)) {
                o->card[player][row][col] = 1;
                o->count[player][col] = (int16_t)(o->count[player][col] + 1);
                o->deck[row][col] = 0;
                o->deck_left = (int16_t)(o->deck_left - 1);
                placed = 1;
            }
        }
        *col_out = col;
    }
    return F6_OK;
}

static int16_t held_sum(const F6Object *o, const Ctx *c, int16_t player)
{
    int16_t sum = 0;
    for (int16_t k = 0; k < cols_of(c); ++k) sum = (int16_t)(sum + o->count[player][k]);
    return sum;
}

/* 0x45ea4a */
static int refill_a(Ctx *c, int16_t player)
{
    int16_t col;
    if (player < 0 || player > 1) return bounds(c, "0xf6-refill-player");
    if ((int)held_sum(c->o, c, player) == (int)c->o->score[player] * 3) return deal(c, player, &col);
    return F6_OK;
}

/* 0x45eadc */
static int refill_b(Ctx *c, int16_t player)
{
    int16_t col;
    int16_t sum;
    if (player < 0 || player > 1) return bounds(c, "0xf6-refill-player");
    sum = held_sum(c->o, c, player);
    if (sum == 0 || (int)sum == (int)c->o->score[player] * 3) return deal(c, player, &col);
    return F6_OK;
}

/* 0x45eb76: the computer picks a column. */
static int computer_pick(Ctx *c, int16_t *out)
{
    F6Object *o = c->o;
    int16_t sets = 0;
    int mixed = 0;
    int done = 0;
    int guard = 0;
    if (c->b[0x21] != 0) {
        for (int16_t k = 0; k < cols_of(c); ++k) {
            if (1 < o->count[0][k]) mixed = 1;
            if (0 < o->count[0][k] && o->count[0][k] < 3) sets = (int16_t)(sets + 1);
        }
    }
    while (!done) {
        int32_t r;
        int16_t col;
        int seen = 0;
        if (++guard > F6_PICK_LIMIT) {
            c->failure = "0xf6-computer-loop";
            return F6_ERR_STUCK;
        }
        CHECK(draw(c, &r));
        col = (int16_t)(r % (int32_t)cols_of(c));
        if (-1 < o->order_count && 1 < sets && o->order_count < sets) {
            if (o->order_count >= F6_MAX_COLUMNS) return bounds(c, "0xf6-order-index");
            for (int16_t k = 0; k <= o->order_count; ++k)
                if (col == o->order[k]) seen = 1;
        }
        if (!seen && o->count[0][col] < 3) {
            if (mixed && 1 < o->count[0][col]) {
                *out = col;
                done = 1;
            } else if (0 < o->count[0][col]) {
                *out = col;
                done = 1;
            }
        }
    }
    o->order_count = (int16_t)(o->order_count + 1);
    if (o->order_count < 0 || o->order_count >= F6_MAX_COLUMNS) return bounds(c, "0xf6-order-index");
    o->order[o->order_count] = *out;
    return F6_OK;
}

/* 0x45ed60 / 0x45ef5a: start a card slide. */
static int slide_common(Ctx *c, uint8_t forward, int16_t idx, int32_t next)
{
    F6Object *o = c->o;
    const uint8_t *b = c->b;
    uint32_t now;
    o->slide_index = idx;
    o->slide_forward = forward;
    if (forward == 0) {
        o->slide_step = (int16_t)(rd_s16(b, B_SLIDE_STEPS) - 1);
    } else {
        const int32_t back = (int32_t)rd_s16(b, B_SLIDE_STEP) * (int32_t)(rd_s16(b, B_SLIDE_STEPS) - 1);
        o->slide_step = 0;
        o->slide_sheet[idx][0] = (int32_t)((uint32_t)o->slide_sheet[idx][0] - (uint32_t)back);
        o->slide_sheet[idx][2] = (int32_t)((uint32_t)o->slide_sheet[idx][2] - (uint32_t)back);
    }
    o->state = ST_SLIDE;
    o->after_slide = next;
    CHECK(tick(c, &now));
    o->deadline_anim = now + (uint32_t)rd_s32(b, B_SLIDE_INTERVAL);
    return F6_OK;
}

static int slide_display(Ctx *c, uint8_t forward, int16_t number, int32_t next)
{
    F6Object *o = c->o;
    int16_t idx = (int16_t)(number - 1);
    if (idx < 0 || idx > 1) return bounds(c, "0xf6-slide-index");
    rect_copy(o->slide_screen[idx], c->b, B_DISPLAY + (size_t)idx * 16u);
    memcpy(o->slide_sheet[idx], o->display[idx], sizeof(o->slide_sheet[idx]));
    if (forward == 0) {
        if (o->player == 1) o->slide_2d4 = 1;
        o->flip_2ab = 0;
    }
    return slide_common(c, forward, idx, next);
}

static int slide_card(Ctx *c, uint8_t forward, int16_t col, int16_t row, int32_t next)
{
    F6Object *o = c->o;
    if (col < 0 || col >= cols_of(c) || row < 0 || row >= F6_MAX_ROWS) return bounds(c, "0xf6-slide-card");
    rect_copy(o->slide_screen[0], c->b, B_CARD + (size_t)row * 0xd0u + (size_t)col * 16u);
    rect_copy(o->slide_sheet[0], c->b, B_CARD_FACE + (size_t)row * 0xd0u + (size_t)col * 16u);
    return slide_common(c, forward, 0, next);
}

/* The sound of an animation state: play `name` when it is real and the last sound is not busy (state 1, 2, 3). */
static int line_if_idle(Ctx *c, size_t name_off)
{
    F6Object *o = c->o;
    const uint8_t *name = c->b + name_off;
    if (real_sound(name)) {
        int32_t busy = 0;
        HOST(c->h->sound_busy(c->h->context, o->channel, &busy));
        fx(c->h, F6_FX_SOUND_BUSY, o->channel, busy);
        if (busy == 0) {
            copy_name(o->record, name);
            HOST(c->h->sound_prepare(c->h->context, o->record));
            fx(c->h, F6_FX_SOUND_PREPARE, 0, 0);
            HOST(c->h->sound_play(c->h->context, rd_s16(o->record, 0x21)));
            fx(c->h, F6_FX_SOUND_PLAY, rd_s16(o->record, 0x21), 0);
        }
    }
    return F6_OK;
}

static int16_t mod16(int32_t value, int16_t divisor)
{
    return (int16_t)(value % (int32_t)divisor);
}

static void mark_sets(F6Object *o, const Ctx *c)
{
    for (int16_t k = 0; k < cols_of(c); ++k)
        if (o->count[o->player][k] == 3) o->mark[o->player][k] = 1;
}

/* The human's or computer's column request (states 6 and 7 share the pick / refill tail). */
static int set_or_turn(F6Object *o) { return o->count[o->player][o->selected] == 3 ? ST_SET : ST_TURN; }

static int sel_ok(Ctx *c)
{
    if (c->o->selected < 0 || c->o->selected >= cols_of(c)) return bounds(c, "0xf6-selected");
    return F6_OK;
}

static int phase1(Ctx *c, uint32_t *row_phase)
{
    F6Object *o = c->o;
    const uint8_t *b = c->b;
    uint32_t now;
    switch (o->state) {
    case ST_DELIVER: {
        const int32_t frames = rd_s16(b, B_DELIVER_FRAMES);
        CHECK(line_if_idle(c, B_LINE_DELIVER));
        if ((int32_t)o->delivery_step < frames * (int32_t)rd_s16(b, B_DELIVER_PASSES)) {
            CHECK(tick(c, &now));
            if (o->deadline_anim <= now) {
                if (frames == 0) return bounds(c, "0xf6-deliver-frames-zero");
                o->delivery_step = (int16_t)(o->delivery_step + 1);
                o->anim_frame = mod16(o->delivery_step, (int16_t)frames);
                CHECK(tick(c, &now));
                o->deadline_anim = now + (uint32_t)rd_s32(b, B_DELIVER_INTERVAL);
            }
        } else {
            CHECK(sel_ok(c));
            if (o->card_row < 0 || o->card_row >= F6_MAX_ROWS) return bounds(c, "0xf6-card-row");
            o->clear_29e = 1;
            o->delivery_step = -1;
            rect_copy(o->display[0], b, B_CARD_FACE + (size_t)o->card_row * 0xd0u + (size_t)o->selected * 16u);
            CHECK(slide_display(c, 1, 1, o->player == 0 ? 7 : 6));
        }
        break;
    }
    case ST_NO_CARD: {
        const int32_t frames = rd_s16(b, B_NOCARD_FRAMES);
        CHECK(line_if_idle(c, B_LINE_DELIVER));
        if ((int32_t)o->delivery_step < frames * (int32_t)rd_s16(b, B_NOCARD_PASSES)) {
            CHECK(tick(c, &now));
            if (o->deadline_anim <= now) {
                if (frames == 0) return bounds(c, "0xf6-nocard-frames-zero");
                o->delivery_step = (int16_t)(o->delivery_step + 1);
                o->anim_frame = mod16(o->delivery_step, (int16_t)frames);
                CHECK(tick(c, &now));
                o->deadline_anim = now + (uint32_t)rd_s32(b, B_NOCARD_INTERVAL);
            }
        } else {
            o->no_card_29d = 0;
            o->delivery_step = -1;
            o->clear_29e = 1;
            CHECK(tick(c, &now));
            o->deadline_state = now + 300u;
            o->state = ST_WAIT;
            o->wait_state = 9;
        }
        break;
    }
    case ST_SLIDE: {
        const int16_t idx = o->slide_index;
        CHECK(line_if_idle(c, B_LINE_SLIDE));
        if (idx < 0 || idx > 1) return bounds(c, "0xf6-slide-state-index");
        CHECK(tick(c, &now));
        if (o->deadline_anim <= now) {
            const int32_t step = rd_s16(b, B_SLIDE_STEP);
            o->slide_step = (int16_t)(o->slide_step + (o->slide_forward == 0 ? -1 : 1));
            if (o->slide_forward == 0) {
                o->slide_sheet[idx][0] = (int32_t)((uint32_t)o->slide_sheet[idx][0] - (uint32_t)step);
                o->slide_sheet[idx][2] = (int32_t)((uint32_t)o->slide_sheet[idx][2] - (uint32_t)step);
            } else {
                o->slide_sheet[idx][0] = (int32_t)((uint32_t)o->slide_sheet[idx][0] + (uint32_t)step);
                o->slide_sheet[idx][2] = (int32_t)((uint32_t)o->slide_sheet[idx][2] + (uint32_t)step);
            }
            CHECK(tick(c, &now));
            o->deadline_anim = now + (uint32_t)rd_s32(b, B_SLIDE_INTERVAL);
        }
        if ((o->slide_forward != 0 && rd_s16(b, B_SLIDE_STEPS) <= o->slide_step) ||
            (o->slide_forward == 0 && o->slide_step < 0)) {
            CHECK(tick(c, &now));
            o->deadline_state = now + 500u;
            o->state = ST_WAIT;
            o->wait_state = o->after_slide;
            o->slide_step = -1;
            if (o->slide_screen[0][1] == rd_s32(b, B_DISPLAY + 4u)) {
                o->display_count = o->slide_index;
                if (o->slide_forward == 0)
                    o->clear_29e = 1;
                else
                    o->flip_2ab = 1;
            }
        }
        break;
    }
    case ST_TURN:
        if (o->player == 0) {
            CHECK(tick(c, &now));
            o->deadline_state = now + 1000u;
            o->state = ST_WAIT;
            o->wait_state = 5;
        }
        break;
    case ST_CHOOSE:
        if (o->player == 1) {
            CHECK(refill_a(c, 1));
            o->order_count = 0;
            o->order[0] = o->selected;
            CHECK(sel_ok(c));
            if (o->has_sound_a == 0 || !real_sound(b + B_LINES_HUMAN + (size_t)o->selected * NAME_STRIDE)) {
                o->state = ST_ASK_HUMAN;
            } else {
                CHECK(pick_line(c, B_LINES_HUMAN + (size_t)o->selected * NAME_STRIDE, 1));
                o->next_state = ST_ASK_HUMAN;
            }
        } else {
            CHECK(refill_a(c, 0));
            CHECK(computer_pick(c, &o->selected));
            if (o->has_sound_b == 0 || !real_sound(b + B_LINES_COMPUTER + (size_t)o->selected * NAME_STRIDE)) {
                o->state = ST_ASK_COMPUTER;
            } else {
                CHECK(pick_line(c, B_LINES_COMPUTER + (size_t)o->selected * NAME_STRIDE, 1));
                o->next_state = ST_ASK_COMPUTER;
            }
        }
        break;
    case ST_ASK_HUMAN:
        CHECK(sel_ok(c));
        if (o->flip_2ab == 0) {
            if (o->slide_2d4 == 0) {
                int stop = 0;
                int guard = 0;
                o->card_row = -1;
                while (!stop) {
                    int found = 0;
                    if (++guard > F6_PICK_LIMIT) {
                        c->failure = "0xf6-ask-loop";
                        return F6_ERR_STUCK;
                    }
                    CHECK(find_card(c, o->selected, (int16_t)(o->player == 0), &o->card_row, &found));
                    if (found == 0) {
                        stop = 1;
                    } else if (o->has_delivery == 0) {
                        CHECK(move_card(c, o->selected, o->card_row, (int16_t)(o->player == 0), o->player));
                    } else {
                        o->delivery_step = 0;
                        o->deliver_29c = 1;
                        o->anim_frame = 0;
                        CHECK(tick(c, &now));
                        o->deadline_anim = now + (uint32_t)rd_s32(b, B_DELIVER_INTERVAL);
                        o->state = ST_DELIVER;
                        stop = 1;
                    }
                }
                if (o->card_row == -1 || o->deliver_29c != 0) {
                    if (o->card_row == -1 && o->deliver_29c != 0) {
                        o->state = o->count[o->player][o->selected] == 3 ? ST_SET : ST_TURN;
                        o->deliver_29c = 0;
                        CHECK(refill_b(c, (int16_t)(o->player == 0)));
                    } else if (o->card_row == -1) {
                        if (o->has_no_card == 0) {
                            CHECK(pick_line(c, B_LISTS + (size_t)(o->player == 0) * LIST_PLAYER_STRIDE, 5));
                            o->next_state = ST_DRAW;
                        } else {
                            o->delivery_step = 0;
                            o->anim_frame = 0;
                            o->no_card_29d = 1;
                            CHECK(tick(c, &now));
                            o->deadline_anim = now + (uint32_t)rd_s32(b, B_NOCARD_INTERVAL);
                            o->state = ST_NO_CARD;
                        }
                        o->warned_3ab = 1;
                    }
                } else {
                    CHECK(pick_line(c, B_LIST_FOUND + (size_t)(o->player == 0) * LIST_PLAYER_STRIDE, 3));
                    o->next_state = set_or_turn(o);
                    CHECK(refill_b(c, (int16_t)(o->player == 0)));
                }
            } else {
                o->flip_2ac = 1;
                o->slide_2d4 = 0;
                CHECK(slide_card(c, 1, o->selected, o->card_row, 6));
                CHECK(move_card(c, o->selected, o->card_row, (int16_t)(o->player == 0), o->player));
            }
        } else {
            CHECK(slide_display(c, 0, 1, 6));
        }
        break;
    case ST_ASK_COMPUTER:
        CHECK(sel_ok(c));
        if (o->has_delivery == 0 || o->deliver_29c != 0) {
            if (o->flip_2ab == 0 && (o->display_count != 1 || o->picked_3ad != 0)) {
                if (o->has_delivery == 0 || o->picked_3ad == 0) {
                    int stop = 0;
                    int guard = 0;
                    o->card_row = -1;
                    while (!stop) {
                        int found = 0;
                        if (++guard > F6_PICK_LIMIT) {
                            c->failure = "0xf6-ask-loop";
                            return F6_ERR_STUCK;
                        }
                        CHECK(find_card(c, o->selected, (int16_t)(o->player == 0), &o->card_row, &found));
                        if (found == 0) {
                            stop = 1;
                        } else {
                            if (o->deliver_29c != 0) {
                                o->display_count = o->picked_3ac == 0 ? 0 : 1;
                                CHECK(slide_card(c, 0, o->selected, o->card_row, 7));
                                o->picked_3ac = 1;
                                o->picked_3ad = 1;
                                stop = 1;
                            }
                            CHECK(move_card(c, o->selected, o->card_row, (int16_t)(o->player == 0), o->player));
                        }
                    }
                    if (o->card_row == -1 || o->deliver_29c != 0) {
                        if (o->card_row == -1 && o->deliver_29c != 0 && o->picked_3ac != 0) {
                            o->state = o->count[o->player][o->selected] == 3 ? ST_SET : ST_TURN;
                            o->deliver_29c = 0;
                            o->picked_3ac = 0;
                            o->flip_2ac = 1;
                            CHECK(refill_b(c, (int16_t)(o->player == 0)));
                        } else if (o->card_row == -1) {
                            if (o->deliver_29c == 0) {
                                CHECK(pick_line(c, B_LISTS + (size_t)(o->player == 0) * LIST_PLAYER_STRIDE, 5));
                                o->next_state = ST_DRAW;
                            } else {
                                CHECK(tick(c, &now));
                                o->deadline_state = now + 300u;
                                o->state = ST_WAIT;
                                o->wait_state = 9;
                                o->deliver_29c = 0;
                                o->picked_3ac = 0;
                            }
                            o->warned_3ab = 1;
                        }
                    } else {
                        CHECK(pick_line(c, B_LIST_FOUND + (size_t)(o->player == 0) * LIST_PLAYER_STRIDE, 3));
                        o->next_state = set_or_turn(o);
                        CHECK(refill_b(c, (int16_t)(o->player == 0)));
                    }
                } else {
                    if (o->card_row < 0 || o->card_row >= F6_MAX_ROWS) return bounds(c, "0xf6-card-row");
                    if (o->display_count < 0 || o->display_count > 1) return bounds(c, "0xf6-display-count");
                    rect_copy(o->display[o->display_count], b,
                              B_CARD_FACE + (size_t)o->card_row * 0xd0u + (size_t)o->selected * 16u);
                    CHECK(slide_display(c, 1, (int16_t)(o->display_count + 1), 7));
                    o->picked_3ad = 0;
                }
            } else {
                o->flip_2ab = 0;
                CHECK(slide_display(c, 0, (int16_t)(o->display_count + 1), 7));
                if (o->display_count == 1) o->display_count = 0;
            }
        } else {
            int found = 0;
            o->delivery_step = 0;
            o->deliver_29c = 1;
            o->anim_frame = 0;
            CHECK(tick(c, &now));
            o->deadline_anim = now + (uint32_t)rd_s32(b, B_DELIVER_INTERVAL);
            o->state = ST_DELIVER;
            o->display_count = 0;
            CHECK(find_card(c, o->selected, o->player, &o->card_row, &found));
        }
        break;
    case ST_SET:
        CHECK(pick_line(c, B_LIST_SET + (size_t)o->player * LIST_PLAYER_STRIDE, 2));
        o->score[o->player] = (int16_t)(o->score[o->player] + 1);
        o->next_state = ST_TURN;
        CHECK(refill_a(c, o->player));
        mark_sets(o, c);
        break;
    case ST_DRAW:
        if (o->warned_3ab == 0) {
            int16_t col;
            CHECK(deal(c, o->player, &col));
            if (col != -1) {
                if (o->count[o->player][col] == 3) {
                    CHECK(pick_line(c, B_LIST_SET + (size_t)o->player * LIST_PLAYER_STRIDE, 2));
                    o->score[o->player] = (int16_t)(o->score[o->player] + 1);
                    o->next_state = ST_TURN;
                    CHECK(refill_a(c, o->player));
                    mark_sets(o, c);
                } else {
                    o->state = ST_TURN;
                }
                if (o->order_count < -1 || o->order_count >= F6_MAX_COLUMNS) return bounds(c, "0xf6-order-index");
                if (b[B_B] == 0 || o->order_count < 0 || col != o->order[o->order_count]) {
                    o->player = (int16_t)(o->player == 0);
                    o->order[0] = -1;
                    o->order_count = -1;
                }
            }
        } else {
            CHECK(pick_line(c, B_LINE_DRAW, 1));
            o->next_state = ST_DRAW;
            o->warned_3ab = 0;
        }
        break;
    case ST_LINE: {
        int32_t busy = 0;
        HOST(c->h->sound_busy(c->h->context, o->channel, &busy));
        fx(c->h, F6_FX_SOUND_BUSY, o->channel, busy);
        if (busy == 0) {
            if (o->button_down != 0) o->button_down = 0;
            if (o->next_state == ST_END) {
                o->interval = 100;
                o->blink = 0;
                CHECK(tick(c, &now));
                o->deadline_anim = now + (uint32_t)o->interval;
                CHECK(tick(c, &now));
                o->deadline_state = now + 2000u;
                o->state = ST_WAIT;
                o->wait_state = ST_END;
                o->finished = 1;
            } else {
                o->state = o->next_state;
            }
        }
        break;
    }
    case ST_WAIT:
        if (o->finished != 0) {
            CHECK(tick(c, &now));
            if (o->deadline_anim <= now) {
                o->blink = (int16_t)(((int32_t)o->blink + 1) % 2);
                CHECK(tick(c, &now));
                o->deadline_anim = now + (uint32_t)o->interval;
            }
        }
        CHECK(tick(c, &now));
        if (o->deadline_state <= now) o->state = o->wait_state;
        break;
    case ST_END:
        *row_phase = 2u;
        fx(c->h, F6_FX_PHASE, 2, 0);
        o->finished = 1;
        break;
    default:
        break;
    }
    return F6_OK;
}

static void put_reset(F6Object *o)
{
    /* 0x45dc8a */
    o->row = -1;
    o->slot = -1;
    o->active = 0;
    o->exit_taken = 0;
    o->finished = 0;
    o->caption_shown = 0;
    o->redraw_298 = 0;
    o->button_down = 0;
    o->deliver_29c = 0;
    o->clear_29e = 0;
    o->flip_2ab = 0;
    o->slide_2d4 = 0;
    o->flip_2ac = 0;
    o->picked_3ac = 0;
    o->picked_3ad = 0;
    o->anim_frame = -1;
    o->slide_step = -1;
    o->delivery_step = -1;
}

void f6_object_reset(F6Object *object)
{
    memset(object, 0, sizeof(*object));
    put_reset(object);
}

static int name_ok(const uint8_t *body, size_t off)
{
    return memchr(body + off, 0, F6_NAME_BYTES) != NULL;
}

int f6_validate_body(const uint8_t *body, size_t length, const char **failure)
{
    const char *why = NULL;
    if (body == NULL || length != F6_BODY_BYTES) {
        why = "0xf6-body-length";
    } else if (rd_s16(body, B_COLS) < 1 || rd_s16(body, B_COLS) > F6_MAX_COLUMNS) {
        why = "0xf6-columns";
    } else if (rd_s16(body, B_ROWS) < 1 || rd_s16(body, B_ROWS) > F6_MAX_ROWS) {
        why = "0xf6-rows";
    } else if (rd_s16(body, B_DEAL) < 0) {
        why = "0xf6-deal-count";
    } else if (!name_ok(body, 0) || !name_ok(body, B_LINE_PICK) || !name_ok(body, B_LINE_DELIVER) ||
               !name_ok(body, B_LINE_SLIDE) || !name_ok(body, B_LINE_DRAW)) {
        why = "0xf6-name-unterminated";
    } else {
        for (size_t k = 0; k < 13u && why == NULL; ++k)
            if (!name_ok(body, B_LINES_COMPUTER + k * NAME_STRIDE) || !name_ok(body, B_LINES_HUMAN + k * NAME_STRIDE))
                why = "0xf6-name-unterminated";
        for (size_t p = 0; p < 2u && why == NULL; ++p) {
            const size_t base = B_LISTS + p * LIST_PLAYER_STRIDE;
            for (size_t k = 0; k < 5u; ++k)
                if (!name_ok(body, base + k * NAME_STRIDE)) why = "0xf6-name-unterminated";
            for (size_t k = 0; k < 3u; ++k)
                if (!name_ok(body, base + (B_LIST_FOUND - B_LISTS) + k * NAME_STRIDE)) why = "0xf6-name-unterminated";
            for (size_t k = 0; k < 2u; ++k) {
                if (!name_ok(body, base + (B_LIST_SET - B_LISTS) + k * NAME_STRIDE)) why = "0xf6-name-unterminated";
                if (!name_ok(body, base + (B_LIST_END - B_LISTS) + k * NAME_STRIDE)) why = "0xf6-name-unterminated";
            }
        }
        for (size_t k = 0; k < 3u && why == NULL; ++k)
            if (!name_ok(body, B_LIST_END_DRAW + k * NAME_STRIDE)) why = "0xf6-name-unterminated";
    }
    if (failure != NULL) *failure = why;
    return why == NULL ? F6_OK : F6_ERR_BODY;
}

static void put16(uint8_t *img, uint8_t *mask, size_t off, int16_t v)
{
    img[off] = (uint8_t)((uint16_t)v & 0xffu);
    img[off + 1] = (uint8_t)(((uint16_t)v >> 8) & 0xffu);
    mask[off] = mask[off + 1] = 1;
}

static void put32(uint8_t *img, uint8_t *mask, size_t off, int32_t v)
{
    for (int k = 0; k < 4; ++k) {
        img[off + (size_t)k] = (uint8_t)(((uint32_t)v >> (8 * k)) & 0xffu);
        mask[off + (size_t)k] = 1;
    }
}

static void put8(uint8_t *img, uint8_t *mask, size_t off, uint8_t v)
{
    img[off] = v;
    mask[off] = 1;
}

void f6_object_pack(const F6Object *o, uint8_t image[F6_IMAGE_BYTES], uint8_t mask[F6_IMAGE_BYTES])
{
    memset(image, 0, F6_IMAGE_BYTES);
    memset(mask, 0, F6_IMAGE_BYTES);
    put16(image, mask, 0x1c, o->slot);
    put16(image, mask, 0x1e, o->row);
    put32(image, mask, 0x20, (int32_t)o->surface);
    for (size_t p = 0; p < 2u; ++p) {
        const size_t base = 0x24u + p * 0x120u;
        for (size_t r = 0; r < F6_CARD_ROWS; ++r)
            for (size_t k = 0; k < F6_MAX_COLUMNS; ++k) put32(image, mask, base + r * 0x34u + k * 4u, o->card[p][r][k]);
        for (size_t k = 0; k < F6_MAX_COLUMNS; ++k) {
            put16(image, mask, base + 0xd0u + k * 2u, o->count[p][k]);
            put32(image, mask, base + 0xeau + k * 4u, o->mark[p][k]);
        }
        put16(image, mask, base + 0x11eu, o->score[p]);
    }
    for (size_t r = 0; r < F6_CARD_ROWS; ++r)
        for (size_t k = 0; k < F6_MAX_COLUMNS; ++k) put8(image, mask, 0x264u + r * 13u + k, o->deck[r][k]);
    put8(image, mask, 0x298, o->redraw_298);
    put8(image, mask, 0x299, o->button_down);
    put16(image, mask, 0x29a, o->selected);
    put8(image, mask, 0x29c, o->deliver_29c);
    put8(image, mask, 0x29d, o->no_card_29d);
    put8(image, mask, 0x29e, o->clear_29e);
    put16(image, mask, 0x29f, o->anim_frame);
    put8(image, mask, 0x2a1, o->has_scores);
    put8(image, mask, 0x2a2, o->has_display);
    put8(image, mask, 0x2a3, o->has_turn);
    put16(image, mask, 0x2a4, o->player);
    put16(image, mask, 0x2a6, o->deck_left);
    put8(image, mask, 0x2a8, o->outcome_2a8);
    put8(image, mask, 0x2a9, o->outcome_2a9);
    put8(image, mask, 0x2aa, o->finished);
    put8(image, mask, 0x2ab, o->flip_2ab);
    put8(image, mask, 0x2ac, o->flip_2ac);
    for (size_t i = 0; i < 2u; ++i)
        for (size_t k = 0; k < 4u; ++k) {
            put32(image, mask, 0x2adu + i * 16u + k * 4u, o->display[i][k]);
            put32(image, mask, 0x2ddu + i * 16u + k * 4u, o->slide_screen[i][k]);
            put32(image, mask, 0x2fdu + i * 16u + k * 4u, o->slide_sheet[i][k]);
        }
    put16(image, mask, 0x2cd, o->display_count);
    put16(image, mask, 0x2cf, o->delivery_step);
    put16(image, mask, 0x2d1, o->blink);
    put8(image, mask, 0x2d3, o->slide_forward);
    put8(image, mask, 0x2d4, o->slide_2d4);
    put16(image, mask, 0x2d5, o->slide_step);
    put16(image, mask, 0x2d7, o->slide_index);
    put32(image, mask, 0x2d9, o->after_slide);
    put8(image, mask, 0x321, o->active);
    put8(image, mask, 0x322, o->has_sound_a);
    put8(image, mask, 0x323, o->has_sound_b);
    put8(image, mask, 0x324, o->has_delivery);
    put8(image, mask, 0x325, o->has_no_card);
    for (size_t k = 0; k < F6_RECORD_BYTES; ++k) put8(image, mask, 0x326u + k, o->record[k]);
    put16(image, mask, 0x371, o->card_row);
    put16(image, mask, 0x373, o->channel);
    put32(image, mask, 0x375, (int32_t)o->deadline_state);
    put32(image, mask, 0x379, (int32_t)o->deadline_anim);
    put32(image, mask, 0x37d, o->interval);
    put16(image, mask, 0x381, o->order_count);
    for (size_t k = 0; k < F6_MAX_COLUMNS; ++k) put16(image, mask, 0x383u + k * 2u, o->order[k]);
    put8(image, mask, 0x39d, o->exit_taken);
    put32(image, mask, 0x39e, o->state);
    put32(image, mask, 0x3a2, o->next_state);
    put32(image, mask, 0x3a6, o->wait_state);
    put8(image, mask, 0x3aa, o->caption_shown);
    put8(image, mask, 0x3ab, o->warned_3ab);
    put8(image, mask, 0x3ac, o->picked_3ac);
    put8(image, mask, 0x3ad, o->picked_3ad);
    put8(image, mask, 0x3ae, o->has_exit);
}

static int host_complete(const F6Host *h)
{
    return h != NULL && h->alloc_slot != NULL && h->register_slot != NULL && h->load_surface != NULL &&
           h->set_slot_surface != NULL && h->release_surface != NULL && h->release_slot != NULL &&
           h->mark_dirty != NULL && h->view_origin != NULL && h->clear_pending_item != NULL &&
           h->sound_prepare != NULL && h->sound_play != NULL && h->sound_busy != NULL && h->tick != NULL &&
           h->random != NULL && h->autotext != NULL && h->caption != NULL && h->transition != NULL &&
           h->store_event_flag != NULL && h->event_flag_invalid != NULL;
}

int f6_cleanup(F6Object *object, const F6Host *host)
{
    if (object == NULL || !host_complete(host)) return F6_ERR_ARGUMENT;
    if (object->surface != 0u) {
        const uint32_t surface = object->surface;
        HOST(host->release_surface(host->context, surface));
        object->surface = 0u;
        fx(host, F6_FX_RELEASE_SURFACE, (int32_t)surface, 0);
    }
    if (object->slot != F6_NO_SLOT) {
        const int16_t slot = object->slot;
        HOST(host->release_slot(host->context, slot));
        fx(host, F6_FX_RELEASE_SLOT, slot, 0);
    }
    put_reset(object);
    return F6_OK;
}

static int nonempty(const uint8_t *name) { return name[0] != 0; }

/* 0x45f123: phase 0. */
static int phase0(Ctx *c, int16_t row, F6World *world)
{
    F6Object *o = c->o;
    const uint8_t *b = c->b;
    const F6Host *h = c->h;
    int16_t slot = F6_NO_SLOT;
    o->row = row;
    o->active = 1;
    world->start_flag_5bb1ca = 1;
    fx(h, F6_FX_START_FLAG, 1, 0);
    HOST(h->clear_pending_item(h->context));
    fx(h, F6_FX_CLEAR_ITEM, 0, 0);
    o->deck_left = (int16_t)((int32_t)cols_of(c) * (int32_t)rows_of(c));
    memset(o->card, 0, sizeof(o->card));
    memset(o->count, 0, sizeof(o->count));
    memset(o->mark, 0, sizeof(o->mark));
    memset(o->score, 0, sizeof(o->score));
    memset(o->deck, 0, sizeof(o->deck));
    for (int16_t r = 0; r < rows_of(c); ++r)
        for (int16_t k = 0; k < cols_of(c); ++k) o->deck[r][k] = 1;
    for (int16_t k = 0; k < rd_s16(b, B_DEAL); ++k) {
        int16_t col;
        CHECK(deal(c, 0, &col));
        CHECK(deal(c, 1, &col));
    }
    HOST(h->alloc_slot(h->context, &slot));
    o->slot = slot;
    fx(h, F6_FX_SLOT, slot, 0);
    HOST(h->register_slot(h->context, slot, "MATCH PUZZLE OVERLAYS"));
    fx(h, F6_FX_SLOT_REGISTER, slot, 0);
    if (o->surface == 0u) {
        uint32_t surface = 0;
        HOST(h->load_surface(h->context, (const char *)b, &surface));
        o->surface = surface;
        fx(h, F6_FX_SURFACE_LOAD, (int32_t)surface, 0);
    }
    HOST(h->set_slot_surface(h->context, slot, o->surface));
    fx(h, F6_FX_SLOT_SURFACE, slot, (int32_t)o->surface);
    o->has_sound_a = 0;
    for (size_t k = 0; k < 13u; ++k)
        if (nonempty(b + B_LINES_HUMAN + k * NAME_STRIDE)) o->has_sound_a = 1;
    o->has_sound_b = 0;
    for (size_t k = 0; k < 13u; ++k)
        if (nonempty(b + B_LINES_COMPUTER + k * NAME_STRIDE)) o->has_sound_b = 1;
    o->has_scores = rd_s32(b, B_SUIT_SRC + 12u) != rd_s32(b, B_SUIT_SRC + 4u);
    o->has_display = rd_s32(b, B_DISPLAY + 12u) != rd_s32(b, B_DISPLAY + 4u);
    o->has_delivery = rd_s16(b, B_DELIVER_FRAMES) > 0;
    o->has_no_card = rd_s16(b, B_NOCARD_FRAMES) > 0;
    o->has_turn = rd_s32(b, B_TURN_DST + 12u) != rd_s32(b, B_TURN_DST + 4u);
    o->has_exit = rd_s32(b, B_BUTTON + 12u) != rd_s32(b, B_BUTTON + 4u);
    o->player = b[B_C];
    o->order[0] = -1;
    o->order_count = -1;
    {
        const int16_t eight = 8;
        const int32_t one = 1;
        o->record[0x21] = (uint8_t)(eight & 0xff);
        o->record[0x22] = (uint8_t)((eight >> 8) & 0xff);
        o->record[0x23] = 2;
        o->record[0x24] = 0;
        o->record[0x25] = 1;
        o->record[0x26] = 0;
        o->record[0x27] = 1;
        o->record[0x28] = 0;
        for (int k = 0; k < 4; ++k) o->record[0x29 + k] = (uint8_t)(((uint32_t)one >> (8 * k)) & 0xffu);
        o->record[0x2d] = b[B_CHANNEL_A];
        o->record[0x2e] = b[B_CHANNEL_A + 1];
        o->record[0x2f] = b[B_CHANNEL_B];
        o->record[0x30] = b[B_CHANNEL_B + 1];
    }
    o->channel = 8;
    o->exit_taken = 0;
    o->outcome_2a8 = 0;
    o->outcome_2a9 = 0;
    o->state = 4;
    return F6_OK;
}

static int apply_block(const F6Host *h, F6World *world, const F6Transition *t, int16_t start_word)
{
    HOST(h->transition(h->context, t));
    fx(h, F6_FX_XFER_5BB57B, t->scene, 0);
    fx(h, F6_FX_XFER_5BB599, t->word[0], 0);
    fx(h, F6_FX_XFER_5BB595, t->word[1], 0);
    fx(h, F6_FX_XFER_5C39FF, t->word[2], 0);
    fx(h, F6_FX_XFER_5BB59B, t->dword[0], 0);
    fx(h, F6_FX_XFER_5BB59F, t->dword[1], 0);
    fx(h, F6_FX_XFER_5BB5A3, t->dword[2], 0);
    world->start_flag_5bb1ca = start_word != 1 ? 1 : 0;
    fx(h, F6_FX_START_FLAG, world->start_flag_5bb1ca, 0);
    fx(h, F6_FX_ENGINE_MODE, 4, 0);
    return F6_OK;
}

/* The event flag index the finish stores (or F6_NO_FLAG); also the validity pre-check. */
static int16_t finish_flag(const F6Object *o, const uint8_t *b)
{
    if (o->exit_taken != 0 || o->finished == 0) return F6_NO_FLAG;
    if (o->outcome_2a8 == 0 || rd_s16(b, B_WIN + WB_FLAG0) == -1) {
        if (o->outcome_2a9 != 0 && rd_s16(b, B_WIN + WB_FLAG1) != -1) return rd_s16(b, B_WIN + WB_FLAG1);
        return F6_NO_FLAG;
    }
    return rd_s16(b, B_WIN + WB_FLAG0);
}

/* 0x460be3: phase 2. */
static int phase2(Ctx *c, F6World *world)
{
    F6Object *o = c->o;
    const uint8_t *b = c->b;
    const F6Host *h = c->h;
    world->start_flag_5bb1ca = 1;
    fx(h, F6_FX_START_FLAG, 1, 0);
    if (o->exit_taken == 0) {
        if (o->finished != 0) {
            const int16_t scene = o->outcome_2a9 == 0 ? rd_s16(b, B_WIN + WB_SCENE0) : rd_s16(b, B_WIN + WB_SCENE1);
            const int16_t flag = finish_flag(o, b);
            if (scene != F6_NO_SCENE) {
                F6Transition t;
                t.scene = scene;
                t.word[0] = rd_s16(b, B_WIN + WB_W1);
                t.word[1] = rd_s16(b, B_WIN + WB_W2);
                t.word[2] = rd_s16(b, B_WIN + WB_W3);
                t.dword[0] = rd_s32(b, B_WIN + WB_D1);
                t.dword[1] = rd_s32(b, B_WIN + WB_D2);
                t.dword[2] = rd_s32(b, B_WIN + WB_D3);
                CHECK(apply_block(h, world, &t, rd_s16(b, B_WIN + WB_START)));
            }
            if (flag != F6_NO_FLAG) {
                HOST(h->store_event_flag(h->context, flag, 1u));
                fx(h, F6_FX_EVENT_FLAG, flag, 1);
            }
        }
    } else if (rd_s16(b, B_EXIT + XB_SCENE) != F6_NO_SCENE) {
        F6Transition t;
        t.scene = rd_s16(b, B_EXIT + XB_SCENE);
        t.word[0] = rd_s16(b, B_EXIT + XB_W1);
        t.word[1] = rd_s16(b, B_EXIT + XB_W2);
        t.word[2] = rd_s16(b, B_EXIT + XB_W3);
        t.dword[0] = rd_s32(b, B_EXIT + XB_D1);
        t.dword[1] = rd_s32(b, B_EXIT + XB_D2);
        t.dword[2] = rd_s32(b, B_EXIT + XB_D3);
        CHECK(apply_block(h, world, &t, rd_s16(b, B_EXIT + XB_START)));
    }
    return F6_OK;
}

int f6_step(F6Object *object, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, F6World *world,
            const F6Host *host, F6Result *result, const char **failure)
{
    const char *why = NULL;
    uint32_t row_phase = phase;
    Ctx ctx;
    int rc;
    if (failure != NULL) *failure = NULL;
    if (object == NULL || body == NULL || world == NULL || result == NULL || !host_complete(host)) {
        if (failure != NULL) *failure = "0xf6-argument";
        return F6_ERR_ARGUMENT;
    }
    memset(result, 0, sizeof(*result));
    result->phase_after = phase;
    if (f6_validate_body(body, body_length, &why) != F6_OK) {
        if (failure != NULL) *failure = why;
        return F6_ERR_BODY;
    }
    ctx.o = object;
    ctx.b = body;
    ctx.h = host;
    ctx.failure = NULL;
    if (phase == 0u) {
        if (row < 0) {
            if (failure != NULL) *failure = "0xf6-row";
            return F6_ERR_ARGUMENT;
        }
        rc = phase0(&ctx, row, world);
        if (rc == F6_OK) {
            row_phase = 1u;
            fx(host, F6_FX_PHASE, 1, 0);
            result->initialized = 1u;
        }
    } else if (phase == 1u) {
        if (object->active == 0 || object->row != row) {
            if (failure != NULL) *failure = "0xf6-phase-1-without-init";
            return F6_ERR_UNSUPPORTED;
        }
        rc = phase1(&ctx, &row_phase);
    } else if (phase == 2u) {
        if (object->active == 0 || object->row != row) {
            if (failure != NULL) *failure = "0xf6-phase-2-without-init";
            return F6_ERR_UNSUPPORTED;
        }
        {
            const int16_t flag = finish_flag(object, body);
            if (flag != F6_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {
                if (failure != NULL) *failure = "0xf6-event-flag-index";
                return F6_ERR_BOUNDS;
            }
        }
        rc = phase2(&ctx, world);
        if (rc == F6_OK) {
            fx(host, F6_FX_COMPLETE, row, 0);
            result->completed = 1u;
            row_phase = 0u; /* 0x42ba3a stores phase 0 */
            rc = f6_cleanup(object, host);
        }
    } else {
        rc = F6_OK; /* 0x45f0e6: any other phase falls out of the switch */
    }
    if (rc != F6_OK && failure != NULL && *failure == NULL) *failure = ctx.failure != NULL ? ctx.failure : "0xf6-host";
    result->phase_after = row_phase;
    return rc;
}

/* 0x45e4d4 */
static void write_cursor(F6PointerResult *out, int32_t candidate)
{
    if (candidate == F6_CANDIDATE_EXIT) {
        out->cursor = F6_CURSOR_EXIT;
        out->sprite = 1;
    } else {
        out->cursor = F6_CURSOR_PICK;
        out->sprite = 2;
    }
    out->candidate = candidate;
}

int f6_pointer_move(F6Object *object, const uint8_t *body, size_t body_length, int16_t x, int16_t y,
                    F6PointerResult *out)
{
    if (object == NULL || body == NULL || out == NULL || f6_validate_body(body, body_length, NULL) != F6_OK)
        return F6_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    if (object->active == 0) return F6_OK;
    if (object->state == 4) {
        const int cols = rd_s16(body, B_COLS);
        if (object->has_exit == 0) {
            for (int r = 0; r < 3; ++r)
                for (int k = 0; k < cols; ++k) {
                    const size_t rect = B_CARD + (size_t)r * 0xd0u + (size_t)k * 16u;
                    if (rd_s32(body, rect + 4) <= y && y <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= x &&
                        x <= rd_s32(body, rect + 8) && object->card[1][r][k] == 1 && object->count[1][k] < 3) {
                        object->selected = (int16_t)k;
                        write_cursor(out, F6_CANDIDATE_CARD);
                        out->hit = 1;
                        return F6_OK;
                    }
                }
        } else {
            for (int k = 0; k < cols; ++k) {
                const size_t rect = B_BUTTON + (size_t)k * 16u;
                if (rd_s32(body, rect + 4) <= y && y <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= x &&
                    x <= rd_s32(body, rect + 8) && 0 < object->count[1][k] && object->count[1][k] < 3) {
                    object->selected = (int16_t)k;
                    write_cursor(out, F6_CANDIDATE_BUTTON);
                    out->hit = 1;
                    return F6_OK;
                }
            }
        }
    }
    if (rd_s32(body, B_EXIT_RECT + 4) <= y && y <= rd_s32(body, B_EXIT_RECT + 12) &&
        rd_s32(body, B_EXIT_RECT) <= x && x <= rd_s32(body, B_EXIT_RECT + 8)) {
        write_cursor(out, F6_CANDIDATE_EXIT);
        out->hit = 1;
    }
    return F6_OK;
}

int f6_click(F6Object *object, const uint8_t *body, size_t body_length, uint32_t row_phase, int32_t candidate,
             const F6Host *host, uint32_t *new_phase)
{
    Ctx ctx;
    if (object == NULL || body == NULL || new_phase == NULL || !host_complete(host) ||
        f6_validate_body(body, body_length, NULL) != F6_OK)
        return F6_ERR_ARGUMENT;
    *new_phase = row_phase;
    if (object->active == 0 || object->finished != 0 || object->state == ST_LINE || row_phase != 1u) return F6_OK;
    ctx.o = object;
    ctx.b = body;
    ctx.h = host;
    ctx.failure = NULL;
    if (candidate == F6_CANDIDATE_EXIT) {
        object->exit_taken = 1;
        *new_phase = 2u;
        fx(host, F6_FX_PHASE, 2, 0);
    } else if (candidate == F6_CANDIDATE_CARD) {
        object->state = ST_CHOOSE;
    } else if (candidate == F6_CANDIDATE_BUTTON) {
        CHECK(pick_line(&ctx, B_LINE_PICK, 1));
        object->button_down = 1;
        object->redraw_298 = 1;
        object->next_state = ST_CHOOSE;
    }
    return F6_OK;
}

int f6_invalidate(F6Object *object, const F6Host *host)
{
    if (object == NULL || !host_complete(host)) return F6_ERR_ARGUMENT;
    if (object->active != 0 && object->slot != F6_NO_SLOT) {
        HOST(host->mark_dirty(host->context, object->slot));
        fx(host, F6_FX_MARK_DIRTY, object->slot, 0);
    }
    return F6_OK;
}

typedef struct Plan {
    F6RenderPlan *plan;
    int32_t vx, vy;
    int overflow;
} Plan;

static void add_blit(Plan *p, int kind, const int32_t *src, const int32_t *dst_view)
{
    F6Blit *blit;
    if (p->plan->count >= F6_MAX_BLITS) {
        p->overflow = 1;
        return;
    }
    blit = &p->plan->blit[p->plan->count++];
    blit->kind = (uint8_t)kind;
    memcpy(blit->src, src, sizeof(blit->src));
    /* 0x4d3a52 */
    blit->dst[0] = (int32_t)((uint32_t)dst_view[0] + (uint32_t)p->vx);
    blit->dst[1] = (int32_t)((uint32_t)dst_view[1] + (uint32_t)p->vy);
    blit->dst[2] = (int32_t)((uint32_t)dst_view[2] + (uint32_t)p->vx);
    blit->dst[3] = (int32_t)((uint32_t)dst_view[3] + (uint32_t)p->vy);
}

static void blit_body(Plan *p, const uint8_t *body, int kind, size_t src_off, size_t dst_off)
{
    int32_t src[4], dst[4];
    rect_copy(src, body, src_off);
    rect_copy(dst, body, dst_off);
    add_blit(p, kind, src, dst);
}

int f6_render_plan(F6Object *o, const uint8_t *body, size_t body_length, const F6Host *host, F6RenderPlan *plan)
{
    Plan p;
    int32_t vx = 0, vy = 0;
    if (o == NULL || body == NULL || plan == NULL || !host_complete(host) ||
        f6_validate_body(body, body_length, NULL) != F6_OK)
        return F6_ERR_ARGUMENT;
    memset(plan, 0, sizeof(*plan));
    if (o->slot == F6_NO_SLOT) return F6_OK;
    HOST(host->view_origin(host->context, &vx, &vy));
    p.plan = plan;
    p.vx = vx;
    p.vy = vy;
    p.overflow = 0;
    plan->valid = 1u;
    plan->surface = o->surface;
    {
        const int rows = rd_s16(body, B_ROWS);
        const int cols = rd_s16(body, B_COLS);
        for (int r = 0; r < rows; ++r)
            for (int k = 0; k < cols; ++k) {
                const size_t slot = B_CARD + (size_t)r * 0xd0u + (size_t)k * 16u;
                if (o->card[1][r][k] == 0) blit_body(&p, body, F6_BLIT_RESTORE, slot, slot);
                if (o->card[1][r][k] == 1)
                    blit_body(&p, body, F6_BLIT_SHEET_KEYED, B_CARD_FACE + (size_t)r * 0xd0u + (size_t)k * 16u, slot);
            }
        if (o->has_scores != 0) {
            for (int k = 0; k < cols; ++k)
                for (int pl = 0; pl < 2; ++pl)
                    if (o->mark[pl][k] != 0)
                        blit_body(&p, body, F6_BLIT_SHEET_OPAQUE, B_SUIT_SRC,
                                  B_SUIT_DST + (size_t)pl * 0xd0u + (size_t)k * 16u);
        }
    }
    if (o->has_turn != 0) {
        const int pl = o->player;
        const int other = o->player == 0;
        if (o->finished == 0) {
            blit_body(&p, body, F6_BLIT_SHEET_OPAQUE, B_TURN_SRC + (size_t)pl * 16u, B_TURN_DST + (size_t)pl * 16u);
            blit_body(&p, body, F6_BLIT_RESTORE, B_TURN_DST + (size_t)other * 16u, B_TURN_DST + (size_t)other * 16u);
        } else {
            const int mine = o->outcome_2a8 != 0;
            if (mine != pl)
                blit_body(&p, body, F6_BLIT_RESTORE, B_TURN_DST + (size_t)other * 16u, B_TURN_DST + (size_t)pl * 16u);
            if (o->blink == 0 && o->outcome_2a9 == 0)
                blit_body(&p, body, F6_BLIT_RESTORE, B_TURN_DST + (size_t)mine * 16u, B_TURN_DST + (size_t)mine * 16u);
            else if (o->outcome_2a9 == 0)
                blit_body(&p, body, F6_BLIT_SHEET_OPAQUE, B_TURN_SRC + (size_t)mine * 16u,
                          B_TURN_DST + (size_t)mine * 16u);
        }
    }
    if (o->selected < 0 || o->selected >= F6_MAX_COLUMNS) return F6_ERR_BOUNDS;
    if (o->button_down == 0) {
        if (o->redraw_298 != 0) {
            blit_body(&p, body, F6_BLIT_RESTORE, B_BUTTON + (size_t)o->selected * 16u,
                      B_BUTTON + (size_t)o->selected * 16u);
            o->redraw_298 = 0;
        }
    } else {
        blit_body(&p, body, F6_BLIT_SHEET_OPAQUE, B_BUTTON_DOWN + (size_t)o->selected * 16u,
                  B_BUTTON + (size_t)o->selected * 16u);
    }
    if (o->deliver_29c == 0 || o->delivery_step == -1) {
        if (o->no_card_29d != 0) {
            if (o->anim_frame < 0 || o->anim_frame > 14) return F6_ERR_BOUNDS;
            blit_body(&p, body, F6_BLIT_SHEET_KEYED, B_NOCARD_RECT + (size_t)o->anim_frame * 16u, B_NOCARD_AREA);
        }
    } else {
        if (o->anim_frame < 0 || o->anim_frame > 14) return F6_ERR_BOUNDS;
        blit_body(&p, body, F6_BLIT_SHEET_KEYED, B_DELIVER_RECT + (size_t)o->anim_frame * 16u, B_DELIVER_AREA);
    }
    if (o->clear_29e != 0) {
        blit_body(&p, body, F6_BLIT_RESTORE, B_DELIVER_AREA, B_DELIVER_AREA);
        blit_body(&p, body, F6_BLIT_RESTORE, B_NOCARD_AREA, B_NOCARD_AREA);
        o->clear_29e = 0;
    }
    if (o->slide_step != -1) {
        if (o->slide_index < 0 || o->slide_index > 1) return F6_ERR_BOUNDS;
        add_blit(&p, F6_BLIT_SHEET_KEYED, o->slide_sheet[o->slide_index], o->slide_screen[o->slide_index]);
    }
    if (o->has_display != 0) {
        if (o->flip_2ab != 0) {
            if (o->display_count < 0 || o->display_count > 1) return F6_ERR_BOUNDS;
            for (int i = 0; i <= o->display_count; ++i) {
                int32_t dst[4];
                rect_copy(dst, body, B_DISPLAY + (size_t)i * 16u);
                add_blit(&p, F6_BLIT_SHEET_OPAQUE, o->display[i], dst);
            }
        }
        if (o->flip_2ac != 0) {
            for (int i = 0; i < 2; ++i)
                blit_body(&p, body, F6_BLIT_RESTORE, B_DISPLAY + (size_t)i * 16u, B_DISPLAY + (size_t)i * 16u);
            o->flip_2ac = 0;
        }
    }
    return p.overflow != 0 ? F6_ERR_BOUNDS : F6_OK;
}
