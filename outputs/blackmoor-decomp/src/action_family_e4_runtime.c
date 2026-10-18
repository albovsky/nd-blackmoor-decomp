#include "action_family_e4_runtime.h"

#include <stdio.h>
#include <string.h>

/* Body offsets (see the header). */
enum {
    B_SCORE_NAME = 0x21,
    B_ROWS = 0x42,
    B_COLS = 0x44,
    B_KINDS = 0x46,
    B_SHUFFLE_SRC = 0x48,
    B_PIECE_RECT = 0x58,
    B_NAME_PANEL = 0x238,
    B_FONT = 0x23a,
    B_FONT_PARAM = 0x23c,
    B_TITLE = 0x23e,
    B_KIND_NAME = 0x25f,
    B_SCORE_PANEL = 0x63d,
    B_TIME_LIMIT = 0x63e,
    B_TARGET = 0x640,
    B_PER_PIECE = 0x644,
    B_MATCHED_SRC = 0x646,
    B_BONUS3_TIME = 0x656,
    B_BONUS4_SCORE = 0x658,
    B_BONUS4_TIME = 0x65a,
    B_BONUS5_SCORE = 0x65c,
    B_BONUS5_TIME = 0x65e,
    B_X_OFFSET = 0x660,
    B_Y_OFFSET = 0x662,
    B_Y_GAP = 0x664,
    B_X_GAP = 0x666,
    B_TITLE_RECT = 0x668,
    B_SHUFFLE_RECT = 0x678,
    B_TARGET_RECT = 0x688,
    B_SCORE_RECT = 0x698,
    B_TIME_RECT = 0x6a8,
    B_NAME_RECT = 0x6b8,
    B_ICON_RECT = 0x6c8,
    B_HS_X0 = 0x6d8,
    B_HS_Y0 = 0x6dc,
    B_HS_X1 = 0x6e0,
    B_HS_Y1 = 0x6e4,
    B_END_DELAY = 0x6e8,
    B_SOUND_A = E4R_OFFSET_SOUND_A,
    B_CHANNEL_A = 0x70b,
    B_SOUND_B = E4R_OFFSET_SOUND_B,
    B_CHANNEL_B = 0x73c,
    B_SOUND_C = E4R_OFFSET_SOUND_C,
    B_CHANNEL_C = 0x76d,
    B_WIN_BLOCK = 0x77d,
    B_FINAL_DELAY = 0x796,
    B_SOUND_D = E4R_OFFSET_SOUND_D,
    B_CHANNEL_D = 0x7b9,
    B_EXIT_BLOCK = 0x7c9,
    B_EXIT_RECT = 0x7e2
};

/* Offsets inside a scene block (win block at 0x77d, exit block at 0x7c9). */
enum { SB_SCENE = 0, SB_W1 = 2, SB_W2 = 4, SB_W3 = 6, SB_D1 = 8, SB_D2 = 12, SB_D3 = 16, SB_START = 20, SB_FLAG = 22, SB_VALUE = 24 };

/* Cell layout inside the object. */
enum { CELL_ROW_STRIDE = 200, CELL_STRIDE = 20, CELL_PRESENT = 0, CELL_MATCHED = 1, CELL_KIND = 2, CELL_RECT = 4 };

#define FILL_RETRY_LIMIT 1000000

static int16_t bs16(const uint8_t *b, size_t off)
{
    return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));
}

static int32_t bs32(const uint8_t *b, size_t off)
{
    return (int32_t)((uint32_t)b[off] | ((uint32_t)b[off + 1] << 8) | ((uint32_t)b[off + 2] << 16) |
                     ((uint32_t)b[off + 3] << 24));
}

static void ob16(E4rObject *o, size_t off, int16_t v)
{
    o->b[off] = (uint8_t)((uint16_t)v & 0xff);
    o->b[off + 1] = (uint8_t)(((uint16_t)v >> 8) & 0xff);
}

static void ob32(E4rObject *o, size_t off, int32_t v)
{
    const uint32_t u = (uint32_t)v;
    o->b[off] = (uint8_t)(u & 0xff);
    o->b[off + 1] = (uint8_t)((u >> 8) & 0xff);
    o->b[off + 2] = (uint8_t)((u >> 16) & 0xff);
    o->b[off + 3] = (uint8_t)((u >> 24) & 0xff);
}

static int32_t wrap_add(int32_t a, int32_t b)
{
    return (int32_t)((uint32_t)a + (uint32_t)b);
}

static int32_t wrap_mul(int32_t a, int32_t b)
{
    return (int32_t)((uint32_t)a * (uint32_t)b);
}

static size_t cell_at(int32_t row, int32_t col)
{
    return (size_t)E4R_O_CELLS + (size_t)row * CELL_ROW_STRIDE + (size_t)col * CELL_STRIDE;
}

static void fx(const E4rHost *host, int effect, int32_t a, int32_t b)
{
    if (host->observe != NULL) host->observe(host->context, effect, a, b);
}

/* The 9-byte comparison against "NO SOUND\0" (repe cmpsb with ecx = 9). */
static int no_sound(const uint8_t *name)
{
    static const uint8_t k[9] = {'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0};
    return memcmp(name, k, sizeof k) == 0;
}

/* strcpy into a 0x21-byte text field of the object: the string and its NUL, the remaining bytes keep their value. */
static void set_text(E4rObject *o, size_t off, const char *s)
{
    memcpy(o->b + off, s, strlen(s) + 1u);
}

static void set_text_bytes(E4rObject *o, size_t off, const uint8_t *s)
{
    memcpy(o->b + off, s, strlen((const char *)s) + 1u);
}

static void set_number_text(E4rObject *o, size_t off, uint32_t v)
{
    char buf[16];
    (void)snprintf(buf, sizeof buf, "%u", (unsigned)v);
    set_text(o, off, buf);
}

#define HOST(call) do { if ((call) != 0) { return E4R_ERR_HOST; } } while (0)

void e4r_object_reset(E4rObject *object)
{
    memset(object, 0, sizeof(*object));
    ob16(object, E4R_O_SLOT, -1);
    ob16(object, E4R_O_ROW, -1);
}

/* FL-12: original FUN_0047591f is this function (function ledger acceptance). */
void e4r_scene_reset(E4rWorld *world)
{
    int i;
    world->high_score_marker_5a0545 = 0;
    for (i = 0; i < E4R_HIGH_SCORES; ++i) world->high_score[i] = 0;
}

static int terminated(const uint8_t *s, size_t n)
{
    return memchr(s, 0, n) != NULL;
}

int e4r_validate_body(const uint8_t *body, size_t length, const char **failure)
{
    const char *why = NULL;
    if (body == NULL || length != E4R_BODY_BYTES) {
        why = "0xe4-body-length";
    } else {
        const int16_t rows = bs16(body, B_ROWS), cols = bs16(body, B_COLS), kinds = bs16(body, B_KINDS);
        const int16_t font = bs16(body, B_FONT);
        int k;
        if (rows < 1 || rows > E4R_MAX_ROWS)
            why = "0xe4-rows";
        else if (cols < 1 || cols > E4R_MAX_COLS)
            why = "0xe4-columns";
        else if (kinds < E4R_MIN_KINDS || kinds > E4R_MAX_KINDS)
            why = "0xe4-kinds";
        else if (font < 0 || font > E4R_MAX_FONT)
            why = "0xe4-font";
        else if (!terminated(body, E4R_NAME_BYTES))
            why = "0xe4-name-unterminated";
        else if (!terminated(body + B_SCORE_NAME, E4R_NAME_BYTES))
            why = "0xe4-score-name-unterminated";
        else if (!terminated(body + B_TITLE, E4R_NAME_BYTES))
            why = "0xe4-title-unterminated";
        else if (!terminated(body + B_SOUND_A, E4R_NAME_BYTES))
            why = "0xe4-sound-a-unterminated";
        else if (!terminated(body + B_SOUND_B, E4R_NAME_BYTES))
            why = "0xe4-sound-b-unterminated";
        else if (!terminated(body + B_SOUND_C, E4R_NAME_BYTES))
            why = "0xe4-sound-c-unterminated";
        else if (!terminated(body + B_SOUND_D, E4R_NAME_BYTES))
            why = "0xe4-sound-d-unterminated";
        for (k = 0; why == NULL && k < kinds; ++k)
            if (!terminated(body + B_KIND_NAME + (size_t)k * E4R_NAME_BYTES, E4R_NAME_BYTES)) why = "0xe4-piece-name-unterminated";
    }
    if (failure != NULL) *failure = why;
    return why == NULL ? E4R_OK : E4R_ERR_BODY;
}

static int in_board(const uint8_t *body, int32_t row, int32_t col)
{
    return row >= 0 && row < bs16(body, B_ROWS) && col >= 0 && col < bs16(body, B_COLS);
}

/* Every cell of the board holds a piece kind the body describes (the original reads the tables without a check). */
static int kinds_in_range(const E4rObject *o, const uint8_t *body)
{
    const int rows = bs16(body, B_ROWS), cols = bs16(body, B_COLS), kinds = bs16(body, B_KINDS);
    int r, c;
    for (r = 0; r < rows; ++r)
        for (c = 0; c < cols; ++c) {
            const int16_t kind = e4r_rd16(o, cell_at(r, c) + CELL_KIND);
            if (kind < 0 || kind >= kinds) return 0;
        }
    return 1;
}

/* 0x475bef: the rectangle of the cell (row, col), the view origin added. */
static void cell_rect(E4rObject *o, const uint8_t *body, int16_t row, int16_t col, const int32_t view[4])
{
    const size_t at = cell_at(row, col) + CELL_RECT;
    const int16_t w = (int16_t)(bs32(body, B_PIECE_RECT + 8) - bs32(body, B_PIECE_RECT));
    const int16_t h = (int16_t)(bs32(body, B_PIECE_RECT + 12) - bs32(body, B_PIECE_RECT + 4));
    int32_t x = wrap_add(wrap_mul(col, w), view[0]);
    int32_t y = wrap_add(wrap_mul(row, h), view[1]);
    x = wrap_add(wrap_add(x, bs16(body, B_X_OFFSET)), wrap_mul(bs16(body, B_X_GAP), col));
    y = wrap_add(wrap_add(y, bs16(body, B_Y_OFFSET)), wrap_mul(bs16(body, B_Y_GAP), row));
    ob32(o, at, x);
    ob32(o, at + 8, wrap_add(x, w));
    ob32(o, at + 4, y);
    ob32(o, at + 12, wrap_add(y, h));
}

/* 0x475a1e: refill every cell (all != 0) or the cell (row, col). */
static int fill(E4rObject *o, const uint8_t *body, int all, int16_t row, int16_t col, const E4rHost *host)
{
    const int16_t rows = bs16(body, B_ROWS), cols = bs16(body, B_COLS), kinds = bs16(body, B_KINDS);
    int32_t view[4], full[4];
    int have_view = 0;
    int16_t r, c;
    for (r = 0; r < rows; ++r) {
        for (c = 0; c < cols; ++c) {
            int16_t kind = 0;
            int retry = 1, guard = 0;
            if (!(all != 0 || (col == c && row == r))) continue;
            while (retry) {
                int32_t value = 0;
                retry = 0;
                if (++guard > FILL_RETRY_LIMIT) return E4R_ERR_HOST;
                HOST(host->random(host->context, &value));
                fx(host, E4R_FX_RAND, value, 0);
                kind = (int16_t)(value % (kinds - 1));
                if (r > 0 && kind == e4r_rd16(o, cell_at(r - 1, c) + CELL_KIND))
                    retry = 1;
                else if (c > 0 && kind == e4r_rd16(o, cell_at(r, c - 1) + CELL_KIND))
                    retry = 1;
            }
            ob16(o, cell_at(r, c) + CELL_KIND, kind);
            if (!have_view) {
                HOST(host->view_rects(host->context, view, full));
                have_view = 1;
            }
            cell_rect(o, body, r, c, view);
            o->b[cell_at(r, c) + CELL_PRESENT] = 1;
            o->b[cell_at(r, c) + CELL_MATCHED] = 0;
        }
    }
    return E4R_OK;
}

/* 0x4763b3: the runs through the piece at (col, row). */
static void check_match(E4rObject *o, const uint8_t *body, int32_t col, int32_t row)
{
    const int16_t rows = bs16(body, B_ROWS), cols = bs16(body, B_COLS);
    const int16_t kind = e4r_rd16(o, cell_at(row, col) + CELL_KIND);
    int16_t rmin = (int16_t)row, rmax = (int16_t)row, cmin = (int16_t)col, cmax = (int16_t)col, r;
    uint32_t score;
    int32_t time_end;

    o->b[E4R_O_MATCH_COL] = 0;
    o->b[E4R_O_MATCH_ROW] = 0;
    for (;;) {
        if (rmin == 0) break;
        --rmin;
        if (kind != e4r_rd16(o, cell_at(rmin, col) + CELL_KIND)) { ++rmin; break; }
    }
    for (;;) {
        if (rmax == rows - 1) break;
        ++rmax;
        if (kind != e4r_rd16(o, cell_at(rmax, col) + CELL_KIND)) { --rmax; break; }
    }
    for (;;) {
        if (cmin == 0) break;
        --cmin;
        if (kind != e4r_rd16(o, cell_at(row, cmin) + CELL_KIND)) { ++cmin; break; }
    }
    for (;;) {
        if (cmax == cols - 1) break;
        ++cmax;
        if (kind != e4r_rd16(o, cell_at(row, cmax) + CELL_KIND)) { --cmax; break; }
    }
    ob16(o, E4R_O_RUN_ROW_MIN, rmin);
    ob16(o, E4R_O_RUN_ROW_MAX, rmax);
    ob16(o, E4R_O_RUN_COL_MIN, cmin);
    ob16(o, E4R_O_RUN_COL_MAX, cmax);

    if ((int32_t)rmax - (int32_t)rmin > 1) {
        o->b[E4R_O_MATCH_COL] = 1;
        for (r = rmin; r <= rmax; ++r) {
            o->b[cell_at(r, col) + CELL_MATCHED] = 1;
            ob32(o, E4R_O_SCORE, wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_PER_PIECE)));
        }
        time_end = e4r_rd32(o, E4R_O_TIME_END);
        if ((int32_t)cmax - (int32_t)cmin == 2) {
            ob32(o, E4R_O_TIME_END, wrap_add(time_end, wrap_mul(bs16(body, B_BONUS3_TIME), 1000)));
        } else if ((int32_t)rmax - (int32_t)rmin == 3) {
            ob32(o, E4R_O_SCORE, wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_BONUS4_SCORE)));
            ob32(o, E4R_O_TIME_END, wrap_add(time_end, wrap_mul(bs16(body, B_BONUS4_TIME), 1000)));
        } else if ((int32_t)rmax - (int32_t)rmin == 4) {
            ob32(o, E4R_O_SCORE, wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_BONUS5_SCORE)));
            ob32(o, E4R_O_TIME_END, wrap_add(time_end, wrap_mul(bs16(body, B_BONUS5_TIME), 1000)));
        }
        score = (uint32_t)e4r_rd32(o, E4R_O_SCORE);
        set_number_text(o, E4R_O_SCORE_TEXT, score);
        o->b[E4R_O_SCORE_DIRTY] = 1;
    }
    if ((int32_t)cmax - (int32_t)cmin > 1) {
        int16_t c;
        o->b[E4R_O_MATCH_ROW] = 1;
        for (c = cmin; c <= cmax; ++c) {
            o->b[cell_at(row, c) + CELL_MATCHED] = 1;
            ob32(o, E4R_O_SCORE, wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_PER_PIECE)));
        }
        time_end = e4r_rd32(o, E4R_O_TIME_END);
        if ((int32_t)cmax - (int32_t)cmin == 2) {
            ob32(o, E4R_O_TIME_END, wrap_add(time_end, wrap_mul(bs16(body, B_BONUS3_TIME), 1000)));
        } else if ((int32_t)cmax - (int32_t)cmin == 3) {
            ob32(o, E4R_O_SCORE, wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_BONUS4_SCORE)));
            ob32(o, E4R_O_TIME_END, wrap_add(time_end, wrap_mul(bs16(body, B_BONUS4_TIME), 1000)));
        } else if ((int32_t)cmax - (int32_t)cmin == 4) {
            ob32(o, E4R_O_SCORE, wrap_add(e4r_rd32(o, E4R_O_SCORE), bs16(body, B_BONUS5_SCORE)));
            ob32(o, E4R_O_TIME_END, wrap_add(time_end, wrap_mul(bs16(body, B_BONUS5_TIME), 1000)));
        }
        score = (uint32_t)e4r_rd32(o, E4R_O_SCORE);
        set_number_text(o, E4R_O_SCORE_TEXT, score);
        o->b[E4R_O_SCORE_DIRTY] = 1;
    }
}

/* The scene block shared by the win and exit paths of phase 2. */
static int apply_block(const uint8_t *blk, E4rWorld *world, const E4rHost *host)
{
    if (bs16(blk, SB_SCENE) != E4R_NO_SCENE) {
        E4rTransition t;
        t.scene = bs16(blk, SB_SCENE);
        t.word[0] = bs16(blk, SB_W1);
        t.word[1] = bs16(blk, SB_W2);
        t.word[2] = bs16(blk, SB_W3);
        t.dword[0] = bs32(blk, SB_D1);
        t.dword[1] = bs32(blk, SB_D2);
        t.dword[2] = bs32(blk, SB_D3);
        HOST(host->transition(host->context, &t));
        fx(host, E4R_FX_XFER_5BB57B, t.scene, 0);
        fx(host, E4R_FX_XFER_5BB599, t.word[0], 0);
        fx(host, E4R_FX_XFER_5BB595, t.word[1], 0);
        fx(host, E4R_FX_XFER_5C39FF, t.word[2], 0);
        fx(host, E4R_FX_XFER_5BB59B, t.dword[0], 0);
        fx(host, E4R_FX_XFER_5BB59F, t.dword[1], 0);
        fx(host, E4R_FX_XFER_5BB5A3, t.dword[2], 0);
        world->start_flag_5bb1ca = bs16(blk, SB_START) != 1 ? 1 : 0;
        fx(host, E4R_FX_START_FLAG, world->start_flag_5bb1ca, 0);
        fx(host, E4R_FX_ENGINE_MODE, 4, 0);
    }
    {
        const int16_t flag = bs16(blk, SB_FLAG);
        if (flag != E4R_NO_FLAG) {
            HOST(host->store_event_flag(host->context, flag, blk[SB_VALUE]));
            fx(host, E4R_FX_EVENT_FLAG, flag, blk[SB_VALUE]);
        }
    }
    return E4R_OK;
}

static uint32_t get_tick(const E4rHost *host)
{
    const uint32_t t = host->tick(host->context);
    fx(host, E4R_FX_TICK, (int32_t)t, 0);
    return t;
}

/* 0x4f6334 with the effect record. */
static int busy(const E4rHost *host, int16_t channel, int32_t *result)
{
    HOST(host->sound_busy(host->context, channel, result));
    fx(host, E4R_FX_SOUND_BUSY, channel, *result);
    return E4R_OK;
}

static int play(const E4rHost *host, int16_t channel)
{
    HOST(host->sound_play(host->context, channel));
    fx(host, E4R_FX_SOUND_PLAY, channel, 0);
    return E4R_OK;
}

static int prepare_sound(const E4rHost *host, const uint8_t *body, size_t off)
{
    HOST(host->sound_prepare(host->context, body + off));
    fx(host, E4R_FX_SOUND_PREPARE, (int32_t)off, 0);
    return E4R_OK;
}

static int stop_sound(const E4rHost *host, const uint8_t *body, size_t off)
{
    HOST(host->sound_stop(host->context, body + off));
    fx(host, E4R_FX_SOUND_STOP, (int32_t)off, 0);
    return E4R_OK;
}

/* 0x476a25 phase 0. */
static int phase0(E4rObject *o, const uint8_t *body, int16_t row, E4rWorld *world, const E4rHost *host)
{
    int16_t slot = E4R_NO_SLOT;
    uint32_t surface = 0;
    int rc;

    ob16(o, E4R_O_ROW, row);
    ob32(o, E4R_O_ACTIVE, 1);
    world->start_flag_5bb1ca = 1;
    fx(host, E4R_FX_START_FLAG, 1, 0);
    HOST(host->stop_ambient(host->context));
    fx(host, E4R_FX_AMBIENT_STOP, 0, 0);
    rc = fill(o, body, 1, 0, 0, host);
    if (rc != E4R_OK) return rc;

    HOST(host->alloc_slot(host->context, &slot));
    fx(host, E4R_FX_SLOT, slot, 0);
    ob16(o, E4R_O_SLOT, slot);
    HOST(host->register_slot(host->context, slot, "MATCH PUZZLE OVERLAYS"));
    fx(host, E4R_FX_SLOT_REGISTER, slot, 0);

    if (e4r_rd32(o, E4R_O_SURFACE) == 0) {
        HOST(host->load_surface(host->context, 0, (const char *)body, &surface));
        fx(host, E4R_FX_SURFACE_LOAD, 0, (int32_t)surface);
        ob32(o, E4R_O_SURFACE, (int32_t)surface);
    }
    HOST(host->set_slot_surface(host->context, slot, (uint32_t)e4r_rd32(o, E4R_O_SURFACE)));
    fx(host, E4R_FX_SLOT_SURFACE, slot, e4r_rd32(o, E4R_O_SURFACE));
    if (e4r_rd32(o, E4R_O_SCORE_SURFACE) == 0 && body[B_SCORE_NAME] != 0) {
        surface = 0;
        HOST(host->load_surface(host->context, 1, (const char *)body + B_SCORE_NAME, &surface));
        fx(host, E4R_FX_SURFACE_LOAD, 1, (int32_t)surface);
        ob32(o, E4R_O_SCORE_SURFACE, (int32_t)surface);
    }
    if (!no_sound(body + B_SOUND_A)) {
        rc = prepare_sound(host, body, B_SOUND_A);
        if (rc != E4R_OK) return rc;
    }
    if (!no_sound(body + B_SOUND_B)) {
        rc = prepare_sound(host, body, B_SOUND_B);
        if (rc != E4R_OK) return rc;
    }
    if (!no_sound(body + B_SOUND_C)) {
        rc = prepare_sound(host, body, B_SOUND_C);
        if (rc != E4R_OK) return rc;
    }

    ob32(o, E4R_O_NO_SELECTION, 1);
    o->b[E4R_O_CHECK_FIRST] = 0;
    o->b[E4R_O_CHECK_SECOND] = 0;
    o->b[E4R_O_SHOW_NAME] = 0;
    o->b[E4R_O_NAME_DIRTY] = 1;
    o->b[E4R_O_SCORE_DIRTY] = 0;
    o->b[E4R_O_ERASE_ALL] = 0;
    o->b[E4R_O_MATCH_COL] = 0;
    o->b[E4R_O_MATCH_ROW] = 0;
    o->b[E4R_O_SHUFFLE_DOWN] = 0;
    o->b[E4R_O_SHUFFLE_DIRTY] = 0;
    ob32(o, E4R_O_SCORE, 0);
    {
        const int32_t base = wrap_mul(bs16(body, B_TIME_LIMIT), 1000);
        ob32(o, E4R_O_TIME_END, wrap_add(base, (int32_t)get_tick(host)));
    }
    set_text(o, E4R_O_SCORE_TEXT, "0");
    set_text(o, E4R_O_TIME_TEXT, "");
    set_text(o, E4R_O_NAME_TEXT, "");
    set_number_text(o, E4R_O_TARGET_TEXT, (uint32_t)bs32(body, B_TARGET));
    ob32(o, E4R_O_WON, 0);
    ob32(o, E4R_O_EXIT, 0);
    ob32(o, E4R_O_STATE, E4R_STATE_PLAY);
    fx(host, E4R_FX_PHASE, 1, 0);
    return E4R_OK;
}

/* Starts the refill after a successful check of the piece at (row, col): state, deadline, name text, icon, flag. */
static int start_refill(E4rObject *o, const uint8_t *body, int32_t row, int32_t col, const E4rHost *host)
{
    const int16_t kind = e4r_rd16(o, cell_at(row, col) + CELL_KIND);
    ob32(o, E4R_O_STATE, E4R_STATE_REFILL);
    ob32(o, E4R_O_DEADLINE, wrap_add((int32_t)get_tick(host), 800));
    set_text_bytes(o, E4R_O_NAME_TEXT, body + B_KIND_NAME + (size_t)kind * E4R_NAME_BYTES);
    memcpy(o->b + E4R_O_ICON_RECT, body + B_PIECE_RECT + (size_t)kind * 16u, 16u);
    o->b[E4R_O_SHOW_NAME] = 1;
    return E4R_OK;
}

static int unsigned_before(uint32_t a, uint32_t b) { return a < b; }

/* 0x476a25 phase 1: one visit of the state machine. */
static int phase1(E4rObject *o, const uint8_t *body, E4rWorld *world, const E4rHost *host, uint32_t *phase)
{
    const int32_t state = e4r_rd32(o, E4R_O_STATE);
    int rc;
    if ((uint32_t)state > 6u) return E4R_OK;
    switch (state) {
    case 0:
        if (o->b[E4R_O_CHECK_FIRST] != 0) {
            check_match(o, body, e4r_rd32(o, E4R_O_SEL_COL), e4r_rd32(o, E4R_O_SEL_ROW));
            if (o->b[E4R_O_MATCH_COL] != 0 || o->b[E4R_O_MATCH_ROW] != 0) {
                rc = start_refill(o, body, e4r_rd32(o, E4R_O_SEL_ROW), e4r_rd32(o, E4R_O_SEL_COL), host);
                if (rc != E4R_OK) return rc;
            }
            o->b[E4R_O_CHECK_FIRST] = 0;
        } else if (o->b[E4R_O_CHECK_SECOND] != 0) {
            check_match(o, body, e4r_rd32(o, E4R_O_SWAP_COL), e4r_rd32(o, E4R_O_SWAP_ROW));
            if (o->b[E4R_O_MATCH_COL] != 0 || o->b[E4R_O_MATCH_ROW] != 0) {
                rc = start_refill(o, body, e4r_rd32(o, E4R_O_SWAP_ROW), e4r_rd32(o, E4R_O_SWAP_COL), host);
                if (rc != E4R_OK) return rc;
            }
            o->b[E4R_O_CHECK_SECOND] = 0;
        } else {
            const uint32_t now = get_tick(host);
            const uint32_t left = (uint32_t)e4r_rd32(o, E4R_O_TIME_END) - now;
            const int16_t limit = bs16(body, B_TIME_LIMIT);
            const int32_t score = e4r_rd32(o, E4R_O_SCORE);
            const int32_t target = bs32(body, B_TARGET);
            if (limit != 0) {
                char buf[24];
                (void)snprintf(buf, sizeof buf, "%2dm %2ds", (int)((left / 60000u) % 60u), (int)((left / 1000u) % 60u));
                set_text(o, E4R_O_TIME_TEXT, buf);
            }
            if ((limit > 0 && left < 500u) || score >= target) {
                ob32(o, E4R_O_STATE, E4R_STATE_END);
                if (score >= target) {
                    set_text(o, E4R_O_TIME_TEXT, "WIN!!!");
                    ob32(o, E4R_O_WON, 1);
                } else {
                    set_text(o, E4R_O_TIME_TEXT, "TIME!");
                }
            }
        }
        break;
    case E4R_STATE_END:
        if (!no_sound(body + B_SOUND_D)) {
            rc = prepare_sound(host, body, B_SOUND_D);
            if (rc != E4R_OK) return rc;
            rc = play(host, bs16(body, B_CHANNEL_D));
            if (rc != E4R_OK) return rc;
        }
        ob32(o, E4R_O_DEADLINE, wrap_add((int32_t)get_tick(host), wrap_mul(bs16(body, B_FINAL_DELAY), 1000)));
        ob32(o, E4R_O_STATE, E4R_STATE_END_WAIT);
        break;
    case E4R_STATE_REFILL: {
        const uint32_t now = get_tick(host);
        int32_t b1 = 0, b2 = 0, b3 = 0;
        int wait = unsigned_before(now, (uint32_t)e4r_rd32(o, E4R_O_DEADLINE));
        if (!wait) {
            rc = busy(host, bs16(body, B_CHANNEL_A), &b1);
            if (rc != E4R_OK) return rc;
            wait = b1 != 0;
        }
        if (wait) {
            rc = busy(host, bs16(body, B_CHANNEL_A), &b2);
            if (rc != E4R_OK) return rc;
            if (b2 == 0) {
                rc = busy(host, bs16(body, B_CHANNEL_A), &b3);
                if (rc != E4R_OK) return rc;
                if (b3 == 0 && !no_sound(body + B_SOUND_A)) {
                    rc = play(host, bs16(body, B_CHANNEL_A));
                    if (rc != E4R_OK) return rc;
                }
            }
        } else {
            const int rows = bs16(body, B_ROWS), cols = bs16(body, B_COLS);
            int r, c;
            ob32(o, E4R_O_STATE, E4R_STATE_PLAY);
            set_text(o, E4R_O_NAME_TEXT, "");
            o->b[E4R_O_SHOW_NAME] = 0;
            o->b[E4R_O_NAME_DIRTY] = 1;
            for (r = 0; r < rows; ++r)
                for (c = 0; c < cols; ++c)
                    if (o->b[cell_at(r, c) + CELL_MATCHED] == 1) {
                        rc = fill(o, body, 0, (int16_t)r, (int16_t)c, host);
                        if (rc != E4R_OK) return rc;
                    }
        }
        break;
    }
    case E4R_STATE_SHUFFLE:
        if ((uint32_t)e4r_rd32(o, E4R_O_SHUFFLE_END) <= get_tick(host)) {
            rc = fill(o, body, 1, 0, 0, host);
            if (rc != E4R_OK) return rc;
            o->b[E4R_O_SHUFFLE_DOWN] = 0;
            o->b[E4R_O_SHUFFLE_DIRTY] = 1;
            ob32(o, E4R_O_STATE, E4R_STATE_PLAY);
        }
        break;
    case E4R_STATE_END_SOUND: {
        int32_t b = 0;
        rc = busy(host, bs16(body, B_CHANNEL_D), &b);
        if (rc != E4R_OK) return rc;
        if (b == 0) {
            rc = stop_sound(host, body, B_SOUND_D);
            if (rc != E4R_OK) return rc;
        }
        ob32(o, E4R_O_DEADLINE, wrap_add((int32_t)get_tick(host), wrap_mul(bs16(body, B_END_DELAY), 1000)));
        ob32(o, E4R_O_STATE, E4R_STATE_SCORES);
        o->b[E4R_O_ERASE_ALL] = 1;
        break;
    }
    case E4R_STATE_END_WAIT:
        if ((uint32_t)e4r_rd32(o, E4R_O_DEADLINE) <= get_tick(host)) ob32(o, E4R_O_STATE, E4R_STATE_END_SOUND);
        break;
    case E4R_STATE_SCORES:
        if ((uint32_t)e4r_rd32(o, E4R_O_DEADLINE) <= get_tick(host)) {
            int32_t carry = e4r_rd32(o, E4R_O_SCORE);
            int i;
            for (i = 0; i < E4R_HIGH_SCORES; ++i) {
                if (carry > world->high_score[i]) {
                    const int32_t displaced = world->high_score[i];
                    world->high_score[i] = carry;
                    o->b[E4R_O_ERASE_ALL] = 1;
                    carry = displaced;
                }
            }
            if (e4r_rd32(o, E4R_O_WON) == 0) {
                ob32(o, E4R_O_STATE, E4R_STATE_PLAY);
                ob32(o, E4R_O_SCORE, 0);
                ob32(o, E4R_O_TIME_END, wrap_add(wrap_mul(bs16(body, B_TIME_LIMIT), 1000), (int32_t)get_tick(host)));
                set_text(o, E4R_O_SCORE_TEXT, "0");
                set_text(o, E4R_O_TIME_TEXT, "");
                o->b[E4R_O_ERASE_ALL] = 1;
            } else {
                *phase = 2;
                fx(host, E4R_FX_PHASE, 2, 0);
            }
        }
        if (e4r_rd32(o, E4R_O_WON) != 0 && bs16(body, B_TIME_LIMIT) == 0) {
            *phase = 2;
            fx(host, E4R_FX_PHASE, 2, 0);
        }
        break;
    }
    return E4R_OK;
}

/* FL-12: original FUN_00475885 is this function (function ledger acceptance). */
int e4r_cleanup(E4rObject *object, const E4rHost *host)
{
    uint32_t surface, score_surface;
    int16_t slot;
    if (object == NULL || host == NULL) return E4R_ERR_ARGUMENT;
    surface = (uint32_t)e4r_rd32(object, E4R_O_SURFACE);
    score_surface = (uint32_t)e4r_rd32(object, E4R_O_SCORE_SURFACE);
    slot = e4r_rd16(object, E4R_O_SLOT);
    if (surface != 0) {
        HOST(host->release_surface(host->context, surface));
        fx(host, E4R_FX_RELEASE_SURFACE, (int32_t)surface, 0);
        ob32(object, E4R_O_SURFACE, 0);
    }
    if (score_surface != 0) {
        HOST(host->release_surface(host->context, score_surface));
        fx(host, E4R_FX_RELEASE_SURFACE, (int32_t)score_surface, 1);
        ob32(object, E4R_O_SCORE_SURFACE, 0);
    }
    if (slot != E4R_NO_SLOT) {
        HOST(host->release_slot(host->context, slot));
        fx(host, E4R_FX_RELEASE_SLOT, slot, 0);
    }
    /* 0x4757da */
    ob16(object, E4R_O_ROW, -1);
    ob16(object, E4R_O_SLOT, -1);
    ob32(object, E4R_O_ACTIVE, 0);
    ob32(object, E4R_O_EXIT, 0);
    ob32(object, E4R_O_WON, 0);
    memset(object->b + E4R_O_CELLS, 0, (size_t)E4R_MAX_ROWS * CELL_ROW_STRIDE);
    return E4R_OK;
}

int e4r_step(E4rObject *o, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, E4rWorld *world,
             const E4rHost *host, E4rResult *result, const char **failure)
{
    const char *why = NULL;
    int rc;
    uint32_t after = phase;
    if (failure != NULL) *failure = NULL;
    if (o == NULL || body == NULL || world == NULL || host == NULL || result == NULL) return E4R_ERR_ARGUMENT;
    memset(result, 0, sizeof *result);
    result->phase_after = phase;
    rc = e4r_validate_body(body, body_length, &why);
    if (rc != E4R_OK) goto refuse;
    if (phase == 1 || phase == 2) {
        if (e4r_rd16(o, E4R_O_ROW) != row || e4r_rd32(o, E4R_O_ACTIVE) == 0) {
            why = "e4-phase-without-init";
            rc = E4R_ERR_UNSUPPORTED;
            goto refuse;
        }
        if (phase == 1 && !kinds_in_range(o, body)) {
            why = "e4-piece-kind-outside-body";
            rc = E4R_ERR_UNSUPPORTED;
            goto refuse;
        }
    }
    if (phase == 1 && e4r_rd32(o, E4R_O_STATE) == 0) {
        if ((o->b[E4R_O_CHECK_FIRST] != 0 &&
             !in_board(body, e4r_rd32(o, E4R_O_SEL_ROW), e4r_rd32(o, E4R_O_SEL_COL))) ||
            (o->b[E4R_O_CHECK_FIRST] == 0 && o->b[E4R_O_CHECK_SECOND] != 0 &&
             !in_board(body, e4r_rd32(o, E4R_O_SWAP_ROW), e4r_rd32(o, E4R_O_SWAP_COL)))) {
            why = "e4-selection-outside-board";
            rc = E4R_ERR_UNSUPPORTED;
            goto refuse;
        }
    }
    if (phase == 2) {
        const uint8_t *blk = NULL;
        if (e4r_rd32(o, E4R_O_EXIT) != 0)
            blk = body + B_EXIT_BLOCK;
        else if (e4r_rd32(o, E4R_O_WON) != 0)
            blk = body + B_WIN_BLOCK;
        if (blk != NULL && bs16(blk, SB_FLAG) != E4R_NO_FLAG && host->event_flag_invalid(host->context, bs16(blk, SB_FLAG)) != 0) {
            why = "e4-event-flag-outside-window";
            rc = E4R_ERR_BOUNDS;
            goto refuse;
        }
    }

    if (phase == 0) {
        rc = phase0(o, body, row, world, host);
        if (rc != E4R_OK) goto host_fail;
        after = 1;
        result->initialized = 1;
    } else if (phase == 1) {
        rc = phase1(o, body, world, host, &after);
        if (rc != E4R_OK) goto host_fail;
    } else if (phase == 2) {
        world->start_flag_5bb1ca = 1;
        fx(host, E4R_FX_START_FLAG, 1, 0);
        if (!no_sound(body + B_SOUND_A)) {
            rc = stop_sound(host, body, B_SOUND_A);
            if (rc != E4R_OK) goto host_fail;
        }
        if (!no_sound(body + B_SOUND_B)) {
            rc = stop_sound(host, body, B_SOUND_B);
            if (rc != E4R_OK) goto host_fail;
        }
        if (!no_sound(body + B_SOUND_C)) {
            rc = stop_sound(host, body, B_SOUND_C);
            if (rc != E4R_OK) goto host_fail;
        }
        if (e4r_rd32(o, E4R_O_EXIT) == 0) {
            if (e4r_rd32(o, E4R_O_WON) != 0) {
                rc = apply_block(body + B_WIN_BLOCK, world, host);
                if (rc != E4R_OK) goto host_fail;
            }
        } else {
            rc = apply_block(body + B_EXIT_BLOCK, world, host);
            if (rc != E4R_OK) goto host_fail;
        }
        if (body[B_NAME_PANEL] != 0) {
            const int16_t font = bs16(body, B_FONT);
            if (host->font_release(host->context, font) != 0) {
                rc = E4R_ERR_HOST;
                goto host_fail;
            }
            fx(host, E4R_FX_FONT_RELEASE, font, 0);
        }
        fx(host, E4R_FX_COMPLETE, row, 0);
        result->completed = 1;
        rc = e4r_cleanup(o, host);
        if (rc != E4R_OK) goto host_fail;
    }
    result->phase_after = after;
    return E4R_OK;

refuse:
    if (failure != NULL) *failure = why;
    return rc;
host_fail:
    if (failure != NULL) *failure = "e4-host-failure";
    result->phase_after = after;
    return rc;
}

/* 0x475fb1: the candidate and the cursor cells. */
static void write_cursor(const E4rObject *o, int32_t candidate, E4rPointerResult *out)
{
    if (candidate == E4R_CANDIDATE_EXIT && e4r_rd32(o, E4R_O_STATE) != E4R_STATE_SCORES) {
        out->cursor_written = 1;
        out->cursor_kind = 9;
        out->cursor_sub = 1;
        out->candidate = candidate;
    } else if (candidate == E4R_CANDIDATE_PIECE || candidate == E4R_CANDIDATE_SHUFFLE) {
        out->cursor_written = 1;
        out->cursor_kind = 0x16;
        out->cursor_sub = 1;
        out->candidate = candidate;
    }
}

int e4r_pointer(E4rObject *o, const uint8_t *body, size_t body_length, int32_t x, int32_t y, E4rPointerResult *out)
{
    int32_t px, py;
    int r, c, rows, cols;
    if (o == NULL || body == NULL || out == NULL) return E4R_ERR_ARGUMENT;
    memset(out, 0, sizeof *out);
    out->candidate = -1;
    if (e4r_validate_body(body, body_length, NULL) != E4R_OK) return E4R_ERR_BODY;
    if (e4r_rd32(o, E4R_O_ACTIVE) == 0 || e4r_rd32(o, E4R_O_STATE) == E4R_STATE_REFILL) return E4R_OK;
    px = (int16_t)x;
    py = (int16_t)y;
    rows = bs16(body, B_ROWS);
    cols = bs16(body, B_COLS);
    for (r = 0; r < rows; ++r) {
        for (c = 0; c < cols; ++c) {
            const size_t at = cell_at(r, c) + CELL_RECT;
            /* 0x475e4e: 32-bit adds, so rectangles near INT32_MAX wrap like the original. */
            const int32_t left = wrap_add(e4r_rd32(o, at), 3), top = wrap_add(e4r_rd32(o, at + 4), 3),
                          right = wrap_add(e4r_rd32(o, at + 8), -3), bottom = wrap_add(e4r_rd32(o, at + 12), -3);
            if (top <= py && py <= bottom && left <= px && px <= right) {
                write_cursor(o, E4R_CANDIDATE_PIECE, out);
                ob32(o, E4R_O_HOVER_ROW, r);
                ob32(o, E4R_O_HOVER_COL, c);
                out->hit = 1;
                return E4R_OK;
            }
        }
    }
    if (bs32(body, B_SHUFFLE_RECT + 4) <= py && py <= bs32(body, B_SHUFFLE_RECT + 12) &&
        bs32(body, B_SHUFFLE_RECT) <= px && px <= bs32(body, B_SHUFFLE_RECT + 8)) {
        write_cursor(o, E4R_CANDIDATE_SHUFFLE, out);
        out->hit = 1;
        return E4R_OK;
    }
    if (bs32(body, B_EXIT_RECT + 4) <= py && py <= bs32(body, B_EXIT_RECT + 12) && bs32(body, B_EXIT_RECT) <= px &&
        px <= bs32(body, B_EXIT_RECT + 8)) {
        write_cursor(o, E4R_CANDIDATE_EXIT, out);
        out->hit = 1;
        return E4R_OK;
    }
    return E4R_OK;
}

/* The click sound: played when the record is not "NO SOUND" and the channel is not busy. */
static int click_sound(const E4rHost *host, const uint8_t *body, size_t record, size_t channel, E4rClickResult *out)
{
    if (!no_sound(body + record)) {
        int32_t b = 0;
        const int rc = busy(host, bs16(body, channel), &b);
        if (rc != E4R_OK) return rc;
        if (b == 0) {
            const int rc2 = play(host, bs16(body, channel));
            if (rc2 != E4R_OK) return rc2;
            out->sound_played = 1;
        }
    }
    return E4R_OK;
}

int e4r_click(E4rObject *o, const uint8_t *body, size_t body_length, uint32_t row_phase, int32_t candidate,
              const E4rHost *host, E4rClickResult *out)
{
    int rc;
    if (o == NULL || body == NULL || host == NULL || out == NULL) return E4R_ERR_ARGUMENT;
    memset(out, 0, sizeof *out);
    if (e4r_validate_body(body, body_length, NULL) != E4R_OK) return E4R_ERR_BODY;
    if (!(e4r_rd32(o, E4R_O_ACTIVE) != 0 && e4r_rd32(o, E4R_O_WON) == 0 && e4r_rd32(o, E4R_O_STATE) == 0 &&
          o->b[E4R_O_CHECK_FIRST] == 0 && o->b[E4R_O_CHECK_SECOND] == 0 && row_phase == 1))
        return E4R_OK;
    if (candidate == E4R_CANDIDATE_EXIT) {
        out->fired = 1;
        ob32(o, E4R_O_EXIT, 1);
        out->phase_changed = 1;
        out->phase = 2;
        fx(host, E4R_FX_PHASE, 2, 0);
    } else if (candidate == E4R_CANDIDATE_PIECE) {
        const int32_t hrow = e4r_rd32(o, E4R_O_HOVER_ROW), hcol = e4r_rd32(o, E4R_O_HOVER_COL);
        if (e4r_rd32(o, E4R_O_NO_SELECTION) == 0) {
            const int32_t srow = e4r_rd32(o, E4R_O_SEL_ROW), scol = e4r_rd32(o, E4R_O_SEL_COL);
            int16_t a, b;
            if (!in_board(body, hrow, hcol) || !in_board(body, srow, scol)) return E4R_ERR_UNSUPPORTED;
            out->fired = 1;
            ob32(o, E4R_O_NO_SELECTION, 1);
            rc = click_sound(host, body, B_SOUND_C, B_CHANNEL_C, out);
            if (rc != E4R_OK) return rc;
            a = e4r_rd16(o, cell_at(srow, scol) + CELL_KIND);
            b = e4r_rd16(o, cell_at(hrow, hcol) + CELL_KIND);
            ob16(o, cell_at(srow, scol) + CELL_KIND, b);
            ob16(o, cell_at(hrow, hcol) + CELL_KIND, a);
            ob32(o, E4R_O_SWAP_ROW, hrow);
            ob32(o, E4R_O_SWAP_COL, hcol);
            o->b[E4R_O_CHECK_FIRST] = 1;
            o->b[E4R_O_CHECK_SECOND] = 1;
        } else {
            if (!in_board(body, hrow, hcol)) return E4R_ERR_UNSUPPORTED;
            out->fired = 1;
            rc = click_sound(host, body, B_SOUND_C, B_CHANNEL_C, out);
            if (rc != E4R_OK) return rc;
            ob32(o, E4R_O_SEL_ROW, hrow);
            ob32(o, E4R_O_SEL_COL, hcol);
            ob32(o, E4R_O_NO_SELECTION, 0);
        }
    } else if (candidate == E4R_CANDIDATE_SHUFFLE) {
        out->fired = 1;
        rc = click_sound(host, body, B_SOUND_B, B_CHANNEL_B, out);
        if (rc != E4R_OK) return rc;
        ob32(o, E4R_O_SHUFFLE_END, wrap_add((int32_t)get_tick(host), 0xfa));
        o->b[E4R_O_SHUFFLE_DOWN] = 1;
        ob32(o, E4R_O_STATE, E4R_STATE_SHUFFLE);
    }
    return E4R_OK;
}

/* FL-12: original FUN_004758e8 is this function (function ledger acceptance). */
int e4r_invalidate(E4rObject *object, const E4rHost *host)
{
    int16_t slot;
    if (object == NULL || host == NULL) return E4R_ERR_ARGUMENT;
    slot = e4r_rd16(object, E4R_O_SLOT);
    if (e4r_rd32(object, E4R_O_ACTIVE) != 0 && slot != E4R_NO_SLOT) {
        HOST(host->mark_dirty(host->context, slot));
        fx(host, E4R_FX_MARK_DIRTY, slot, 0);
    }
    return E4R_OK;
}

static E4rOp *new_op(E4rRenderResult *out, int kind)
{
    E4rOp *op;
    if (out->count >= E4R_MAX_OPS) return NULL;
    op = &out->op[out->count++];
    memset(op, 0, sizeof *op);
    op->kind = kind;
    return op;
}

static int add_blit(E4rRenderResult *out, int label, int role, const int32_t src[4], const int32_t dst[4])
{
    E4rOp *op = new_op(out, E4R_OP_BLIT);
    if (op == NULL) return E4R_ERR_BOUNDS;
    op->label = label;
    op->surface_role = role;
    memcpy(op->src, src, sizeof op->src);
    memcpy(op->dst, dst, sizeof op->dst);
    return E4R_OK;
}

/* 0x475cc4: draws a non-empty text at (rect.left + view x, rect.bottom + view y), both as words. */
static int add_text(E4rRenderResult *out, const uint8_t *text, const int32_t rect[4], const uint8_t *body,
                    const int32_t view[4])
{
    E4rOp *op;
    if (text[0] == 0) return E4R_OK;
    op = new_op(out, E4R_OP_TEXT);
    if (op == NULL) return E4R_ERR_BOUNDS;
    memcpy(op->text, text, strlen((const char *)text) + 1u);
    op->font = bs16(body, B_FONT);
    op->param = bs16(body, B_FONT_PARAM);
    op->x = (int16_t)wrap_add(rect[0], view[0]);
    op->y = (int16_t)wrap_add(rect[3], view[1]);
    return E4R_OK;
}

static void body_rect(const uint8_t *body, size_t off, int32_t r[4])
{
    r[0] = bs32(body, off);
    r[1] = bs32(body, off + 4);
    r[2] = bs32(body, off + 8);
    r[3] = bs32(body, off + 12);
}

static void rect_plus_view(const int32_t r[4], const int32_t view[4], int32_t d[4])
{
    d[0] = wrap_add(r[0], view[0]);
    d[1] = wrap_add(r[1], view[1]);
    d[2] = wrap_add(r[2], view[0]);
    d[3] = wrap_add(r[3], view[1]);
}

#define OP(call) do { const int rc_ = (call); if (rc_ != E4R_OK) return rc_; } while (0)

int e4r_render(E4rObject *o, const uint8_t *body, size_t body_length, const E4rWorld *world, const E4rHost *host,
               E4rRenderResult *out)
{
    int32_t view[4], full[4], src[4], dst[4];
    int16_t row;
    int rows, cols, kinds, r, c;
    if (o == NULL || body == NULL || host == NULL || out == NULL || world == NULL) return E4R_ERR_ARGUMENT;
    row = e4r_rd16(o, E4R_O_ROW);
    out->valid = 0;
    out->count = 0;
    if (e4r_validate_body(body, body_length, NULL) != E4R_OK) return E4R_ERR_BODY;
    if (row < 0 || e4r_rd16(o, E4R_O_SLOT) == E4R_NO_SLOT) return E4R_OK;
    rows = bs16(body, B_ROWS);
    cols = bs16(body, B_COLS);
    kinds = bs16(body, B_KINDS);
    if (e4r_rd32(o, E4R_O_STATE) != E4R_STATE_SCORES) {
        for (r = 0; r < rows; ++r)
            for (c = 0; c < cols; ++c) {
                const size_t cell = cell_at(r, c);
                const int16_t kind = e4r_rd16(o, cell + CELL_KIND);
                if (o->b[cell + CELL_PRESENT] != 0 && o->b[cell + CELL_MATCHED] == 0 && (kind < 0 || kind >= kinds))
                    return E4R_ERR_BOUNDS;
            }
    }
    if (host->view_rects(host->context, view, full) != 0) return E4R_ERR_HOST;
    out->valid = 1;

    if (o->b[E4R_O_ERASE_ALL] != 0) {
        OP(add_blit(out, E4R_LABEL_ERASE_ALL, E4R_SURFACE_BACKGROUND, full, view));
        o->b[E4R_O_ERASE_ALL] = 0;
    }
    if (e4r_rd32(o, E4R_O_STATE) == E4R_STATE_SCORES) {
        if (bs16(body, B_TIME_LIMIT) > 0) {
            int16_t height = 0, step;
            int32_t rect[4], high_rect[4], bufrect[4];
            int i;
            OP(add_blit(out, E4R_LABEL_SCORES_BACKDROP, E4R_SURFACE_SCORE, full, view));
            if (host->text_extent(host->context, bs16(body, B_FONT), &height) != 0) return E4R_ERR_HOST;
            fx(host, E4R_FX_TEXT_EXTENT, bs16(body, B_FONT), height);
            step = (int16_t)(height + 0xd);
            rect[1] = wrap_add(wrap_add(bs32(body, B_HS_Y0), -6), view[1]);
            rect[3] = wrap_add(rect[1], step);
            rect[0] = wrap_add(bs32(body, B_HS_X0), view[0]);
            rect[2] = wrap_add(rect[0], 100);
            memcpy(bufrect, rect, sizeof bufrect);
            OP(add_text(out, o->b + E4R_O_SCORE_TEXT, bufrect, body, view));
            high_rect[3] = wrap_add(wrap_add(wrap_add(bs32(body, B_HS_Y1), -0x10), view[1]), step);
            high_rect[0] = wrap_add(bs32(body, B_HS_X1), view[0]);
            high_rect[2] = wrap_add(high_rect[0], 0x50);
            for (i = 0; i < E4R_HIGH_SCORES; ++i) {
                uint8_t text[16];
                high_rect[1] = high_rect[3];
                high_rect[3] = wrap_add(high_rect[3], step);
                (void)snprintf((char *)text, sizeof text, "%u", (unsigned)(uint32_t)world->high_score[i]);
                OP(add_text(out, text, high_rect, body, view));
            }
        }
        return E4R_OK;
    }

    for (r = 0; r < rows; ++r)
        for (c = 0; c < cols; ++c) {
            const size_t cell = cell_at(r, c);
            if (o->b[cell + CELL_PRESENT] == 0) continue;
            dst[0] = e4r_rd32(o, cell + CELL_RECT);
            dst[1] = e4r_rd32(o, cell + CELL_RECT + 4);
            dst[2] = e4r_rd32(o, cell + CELL_RECT + 8);
            dst[3] = e4r_rd32(o, cell + CELL_RECT + 12);
            if (o->b[cell + CELL_MATCHED] == 0) {
                const int16_t kind = e4r_rd16(o, cell + CELL_KIND);
                body_rect(body, B_PIECE_RECT + (size_t)kind * 16u, src);
                OP(add_blit(out, E4R_LABEL_PIECE, E4R_SURFACE_PUZZLE, src, dst));
            } else {
                body_rect(body, B_MATCHED_SRC, src);
                OP(add_blit(out, E4R_LABEL_MATCHED, E4R_SURFACE_PUZZLE, src, dst));
            }
        }

    if (body[B_NAME_PANEL] != 0) {
        int32_t rect[4], icon[4];
        body_rect(body, B_NAME_RECT, rect);
        body_rect(body, B_ICON_RECT, icon);
        if (o->b[E4R_O_SHOW_NAME] == 0) {
            if (o->b[E4R_O_NAME_DIRTY] != 0) {
                rect_plus_view(rect, view, dst);
                OP(add_blit(out, E4R_LABEL_NAME_ERASE, E4R_SURFACE_BACKGROUND, rect, dst));
                rect_plus_view(icon, view, dst);
                OP(add_blit(out, E4R_LABEL_ICON_ERASE, E4R_SURFACE_BACKGROUND, icon, dst));
                o->b[E4R_O_NAME_DIRTY] = 0;
            }
        } else {
            OP(add_text(out, o->b + E4R_O_NAME_TEXT, rect, body, view));
            rect_plus_view(icon, view, dst);
            src[0] = e4r_rd32(o, E4R_O_ICON_RECT);
            src[1] = e4r_rd32(o, E4R_O_ICON_RECT + 4);
            src[2] = e4r_rd32(o, E4R_O_ICON_RECT + 8);
            src[3] = e4r_rd32(o, E4R_O_ICON_RECT + 12);
            OP(add_blit(out, E4R_LABEL_NAME_ICON, E4R_SURFACE_PUZZLE, src, dst));
        }
    }

    if (body[B_SCORE_PANEL] != 0) {
        int32_t rect[4];
        body_rect(body, B_SCORE_RECT, rect);
        if (o->b[E4R_O_SCORE_DIRTY] != 0) {
            rect_plus_view(rect, view, dst);
            OP(add_blit(out, E4R_LABEL_SCORE_ERASE, E4R_SURFACE_BACKGROUND, rect, dst));
            o->b[E4R_O_SCORE_DIRTY] = 0;
        }
        OP(add_text(out, o->b + E4R_O_SCORE_TEXT, rect, body, view));
    }

    if (o->b[E4R_O_TIME_TEXT] != 0) {
        int32_t rect[4];
        body_rect(body, B_TIME_RECT, rect);
        rect_plus_view(rect, view, dst);
        OP(add_blit(out, E4R_LABEL_TIME_ERASE, E4R_SURFACE_BACKGROUND, rect, dst));
        OP(add_text(out, o->b + E4R_O_TIME_TEXT, rect, body, view));
    }

    {
        int32_t rect[4];
        body_rect(body, B_SHUFFLE_RECT, rect);
        if (o->b[E4R_O_SHUFFLE_DOWN] == 0) {
            if (o->b[E4R_O_SHUFFLE_DIRTY] != 0) {
                rect_plus_view(rect, view, dst);
                OP(add_blit(out, E4R_LABEL_SHUFFLE_ERASE, E4R_SURFACE_BACKGROUND, rect, dst));
                o->b[E4R_O_SHUFFLE_DIRTY] = 0;
            }
        } else {
            rect_plus_view(rect, view, dst);
            body_rect(body, B_SHUFFLE_SRC, src);
            OP(add_blit(out, E4R_LABEL_SHUFFLE_DOWN, E4R_SURFACE_PUZZLE, src, dst));
        }
    }

    if (body[B_TITLE] != 0) {
        int32_t rect[4];
        body_rect(body, B_TITLE_RECT, rect);
        OP(add_text(out, body + B_TITLE, rect, body, view));
    }
    if (o->b[E4R_O_TARGET_TEXT] != 0) {
        int32_t rect[4];
        body_rect(body, B_TARGET_RECT, rect);
        OP(add_text(out, o->b + E4R_O_TARGET_TEXT, rect, body, view));
    }
    return E4R_OK;
}
