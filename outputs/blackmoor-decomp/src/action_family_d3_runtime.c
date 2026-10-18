#include "action_family_d3_runtime.h"

#include <string.h>

/* Body offsets (see the header). */
enum {
    B_PERSIST = 0x21,
    B_ROWS = 0x22,
    B_COLS = 0x24,
    B_PIECES = 0x26,
    B_TYPES = 0x28,
    B_START = 0xa8,
    B_PIECE_SRC = 0xd0,
    B_TARGET_SRC = 0x170,
    B_ARROW_H = 0x210,
    B_ARROW_V = 0x220,
    B_WALL = 0x230,
    B_ORIGIN_X = 0x240,
    B_ORIGIN_Y = 0x244,
    B_GAP = 0x248,
    B_STEPS = 0x24a,
    B_SOUND_A = CPZ_OFFSET_SOUND_A,
    B_CHANNEL_A = 0x270,
    B_SOUND_B = CPZ_OFFSET_SOUND_B,
    B_CHANNEL_B = 0x2a1,
    B_SOUND_C = CPZ_OFFSET_SOUND_C,
    B_CHANNEL_C = 0x2d2,
    B_SOLVED = 0x2e2,
    B_DELAY = 0x2fb,
    B_SOUND_D = CPZ_OFFSET_SOUND_D,
    B_CHANNEL_D = 0x31e,
    B_CANCEL = 0x32e,
    B_CANCEL_RECT = 0x347
};

/* Offsets inside a scene block (solved block at 0x2e2, cancel block at 0x32e). */
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

static void fx(const CpzHost *host, int effect, int32_t a, int32_t b)
{
    if (host->observe != NULL) host->observe(host->context, effect, a, b);
}

/* The 9-byte comparison against "NO SOUND\0" (repe cmpsb with ecx = 9). */
static int no_sound(const uint8_t *name)
{
    static const uint8_t k[9] = {'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0};
    return memcmp(name, k, sizeof k) == 0;
}

#define HOST(call) do { if ((call) != 0) { return CPZ_ERR_HOST; } } while (0)

void cpz_object_reset(CpzObject *object)
{
    memset(object, 0, sizeof(*object));
    object->slot = CPZ_NO_SLOT;
    object->row = -1;
}

/* FL-12: original FUN_004618df is this function (function ledger acceptance). */
void cpz_grid_reset(CpzWorld *world)
{
    world->grid_ready = 0;
    memset(world->cell, 0, sizeof(world->cell));
}

int cpz_validate_body(const uint8_t *body, size_t length, const char **failure)
{
    const char *why = NULL;
    if (body == NULL || length != CPZ_BODY_BYTES) {
        why = "0xd3-body-length";
    } else if (memchr(body, 0, CPZ_NAME_BYTES) == NULL) {
        why = "0xd3-name-unterminated";
    } else if (rd_s16(body, B_ROWS) < 0 || rd_s16(body, B_ROWS) > CPZ_GRID_MAX || rd_s16(body, B_COLS) < 0 ||
               rd_s16(body, B_COLS) > CPZ_GRID_MAX) {
        why = "0xd3-grid-size";
    } else if (rd_s16(body, B_PIECES) < 0 || rd_s16(body, B_PIECES) > CPZ_PIECES_MAX) {
        why = "0xd3-piece-count";
    } else if (rd_s16(body, B_STEPS) < 1) {
        why = "0xd3-animation-steps";
    } else if (memchr(body + B_SOUND_A, 0, CPZ_SOUND_BYTES) == NULL || memchr(body + B_SOUND_B, 0, CPZ_SOUND_BYTES) == NULL ||
               memchr(body + B_SOUND_C, 0, CPZ_SOUND_BYTES) == NULL || memchr(body + B_SOUND_D, 0, CPZ_SOUND_BYTES) == NULL) {
        why = "0xd3-sound-unterminated";
    }
    if (failure != NULL) *failure = why;
    return why == NULL ? CPZ_OK : CPZ_ERR_BODY;
}

/* 0x462b84: the cell rectangle of (a, b). */
static void cell_rect(const CpzObject *o, const uint8_t *body, int32_t view_x, int32_t view_y, int16_t a, int16_t b,
                      int32_t out[4])
{
    const int32_t gap = rd_s16(body, B_GAP);
    out[0] = add32(add32(add32(mul32(gap, b), view_x), rd_s32(body, B_ORIGIN_X)), mul32(b, o->cell_w));
    out[2] = add32(out[0], o->cell_w);
    out[1] = add32(add32(add32(mul32(gap, a), view_y), rd_s32(body, B_ORIGIN_Y)), mul32(a, o->cell_h));
    out[3] = add32(out[1], o->cell_h);
}

/* 0x462577: the one-time grid setup. */
static void grid_setup(const CpzObject *o, const uint8_t *body, CpzWorld *world, int32_t view_x, int32_t view_y)
{
    const int16_t rows = rd_s16(body, B_ROWS), cols = rd_s16(body, B_COLS), pieces = rd_s16(body, B_PIECES);
    const int32_t gap_half = rd_s16(body, B_GAP) / 2;
    if (world->grid_ready != 0) return;
    world->grid_ready = 1;
    for (int16_t a = 0; a < rows; ++a) {
        for (int16_t b = 0; b < cols; ++b) {
            CpzCell *c = &world->cell[a][b];
            memset(c, 0, sizeof(*c));
            c->type = rd_s16(body, B_TYPES + (size_t)a * 16u + (size_t)b * 2u);
            cell_rect(o, body, view_x, view_y, a, b, c->base);
            cell_rect(o, body, view_x, view_y, a, b, c->rect);
            if (c->type != 0) {
                c->visible = 1;
                switch (c->type) {
                case CPZ_DIR_LEFT:
                case CPZ_DIR_RIGHT: {
                    const int32_t w = sub32(rd_s32(body, B_ARROW_H + 8), rd_s32(body, B_ARROW_H));
                    const int32_t h = sub32(rd_s32(body, B_ARROW_H + 12), rd_s32(body, B_ARROW_H + 4));
                    const int32_t off = sub32(o->cell_h, h) / 2;
                    c->base[1] = add32(c->base[1], off);
                    c->base[3] = sub32(c->base[3], off);
                    if (c->type == CPZ_DIR_LEFT) {
                        c->base[0] = sub32(sub32(c->base[0], gap_half), w / 2);
                    } else {
                        c->base[0] = sub32(add32(c->base[2], gap_half), w / 2);
                    }
                    c->base[2] = add32(c->base[0], w);
                    break;
                }
                case CPZ_DIR_UP:
                case CPZ_DIR_DOWN: {
                    const int32_t w = sub32(rd_s32(body, B_ARROW_V + 8), rd_s32(body, B_ARROW_V));
                    const int32_t h = sub32(rd_s32(body, B_ARROW_V + 12), rd_s32(body, B_ARROW_V + 4));
                    const int32_t off = sub32(o->cell_w, w) / 2;
                    c->base[0] = add32(c->base[0], off);
                    c->base[2] = sub32(c->base[2], off);
                    if (c->type == CPZ_DIR_UP) {
                        c->base[1] = sub32(sub32(c->base[1], gap_half), h / 2);
                    } else {
                        c->base[1] = sub32(add32(c->base[3], gap_half), h / 2);
                    }
                    c->base[3] = add32(c->base[1], h);
                    break;
                }
                default:
                    break;
                }
            }
            c->piece = 0;
            for (int16_t k = 0; k < pieces; ++k) {
                if (rd_s16(body, B_START + (size_t)k * 4u) == b && rd_s16(body, B_START + 2u + (size_t)k * 4u) == a) {
                    c->visible = 1;
                    c->piece = (int16_t)(k + 1);
                }
            }
        }
    }
}

/* 0x461d4b: the cell type equals `piece`. */
static int type_is(const CpzWorld *world, int16_t piece, int16_t a, int16_t b)
{
    return world->cell[a][b].type == piece;
}

/* 0x4619be: can the piece at (at_row, at_col) move one cell in `dir`. Stores the direction; a refusal clears the piece, the
 * direction and the step counter. A direction other than the four moves passes (the original switch has no default). */
static int can_move(CpzObject *o, const CpzWorld *world, const uint8_t *body, int16_t dir)
{
    const int16_t a = o->at_row, b = o->at_col;
    int ok = 1;
    o->dir = dir;
    switch (o->dir) {
    case CPZ_DIR_LEFT:
        if (b == 0) ok = 0;
        else if (world->cell[a][b].type == CPZ_DIR_LEFT || world->cell[a][b - 1].type == CPZ_DIR_RIGHT ||
                 world->cell[a][b - 1].piece != 0 || world->cell[a][b - 1].type == CPZ_CELL_WALL)
            ok = 0;
        break;
    case CPZ_DIR_UP:
        if (a == 0) ok = 0;
        else if (world->cell[a][b].type == CPZ_DIR_UP || world->cell[a - 1][b].type == CPZ_DIR_DOWN ||
                 world->cell[a - 1][b].piece != 0 || world->cell[a - 1][b].type == CPZ_CELL_WALL)
            ok = 0;
        break;
    case CPZ_DIR_DOWN:
        if (a == rd_s16(body, B_ROWS) - 1) ok = 0;
        else if (world->cell[a][b].type == CPZ_DIR_DOWN || world->cell[a + 1][b].type == CPZ_DIR_UP ||
                 world->cell[a + 1][b].piece != 0 || world->cell[a + 1][b].type == CPZ_CELL_WALL)
            ok = 0;
        break;
    case CPZ_DIR_RIGHT:
        if (b == rd_s16(body, B_COLS) - 1) ok = 0;
        else if (world->cell[a][b].type == CPZ_DIR_RIGHT || world->cell[a][b + 1].type == CPZ_DIR_LEFT ||
                 world->cell[a][b + 1].piece != 0 || world->cell[a][b + 1].type == CPZ_CELL_WALL)
            ok = 0;
        break;
    default:
        break;
    }
    if (!ok) {
        o->piece = 0;
        o->dir = 0;
        o->step = 0;
    }
    return ok;
}

/* 0x461d82: one animation step of the moving piece. Returns 1 when the piece arrived in the next cell. */
static int move_step(CpzObject *o, const uint8_t *body, CpzWorld *world, int32_t view_x, int32_t view_y)
{
    const int32_t steps = rd_s16(body, B_STEPS);
    CpzCell *c = &world->cell[o->at_row][o->at_col];
    int arrived = 0;
    memcpy(o->saved, c->rect, sizeof(o->saved));
    switch (o->dir) {
    case CPZ_DIR_LEFT:
    case CPZ_DIR_RIGHT:
        c->rect[0] = o->dir == CPZ_DIR_LEFT ? sub32(c->rect[0], o->cell_w / steps) : add32(c->rect[0], o->cell_w / steps);
        c->rect[2] = add32(c->rect[0], o->cell_w);
        break;
    case CPZ_DIR_UP:
    case CPZ_DIR_DOWN:
        c->rect[1] = o->dir == CPZ_DIR_UP ? sub32(c->rect[1], o->cell_h / steps) : add32(c->rect[1], o->cell_h / steps);
        c->rect[3] = add32(c->rect[1], o->cell_h);
        break;
    default:
        return 0;
    }
    o->step = (int16_t)(o->step + 1);
    if (o->step == rd_s16(body, B_STEPS)) {
        c->piece = 0;
        if (c->type == 0) c->visible = 0;
        cell_rect(o, body, view_x, view_y, o->at_row, o->at_col, c->rect);
        switch (o->dir) {
        case CPZ_DIR_LEFT: o->at_col = (int16_t)(o->at_col - 1); break;
        case CPZ_DIR_UP: o->at_row = (int16_t)(o->at_row - 1); break;
        case CPZ_DIR_DOWN: o->at_row = (int16_t)(o->at_row + 1); break;
        default: o->at_col = (int16_t)(o->at_col + 1); break;
        }
        c = &world->cell[o->at_row][o->at_col];
        c->piece = o->piece;
        c->visible = 1;
        o->step = 0;
        arrived = 1;
        o->moved = 1;
    }
    return arrived;
}

/* 0x4632bf: solved when every piece stands on the cell type that equals its number. */
static void solved_scan(CpzObject *o, const CpzWorld *world, const uint8_t *body, const CpzHost *host)
{
    const int16_t rows = rd_s16(body, B_ROWS), cols = rd_s16(body, B_COLS);
    for (int16_t a = 0; a < rows; ++a)
        for (int16_t b = 0; b < cols; ++b)
            if (world->cell[a][b].piece != 0 && !type_is(world, world->cell[a][b].piece, a, b)) return;
    o->solved = 1;
    o->state = CPZ_STATE_SOLVED;
    fx(host, CPZ_FX_STATE, o->state, 0);
}

/* The scene block shared by the solved and cancel paths of phase 2. */
static int apply_block(const uint8_t *blk, CpzWorld *world, const CpzHost *host)
{
    if (rd_s16(blk, SB_SCENE) != CPZ_NO_SCENE) {
        CpzTransition t;
        t.scene = rd_s16(blk, SB_SCENE);
        t.word[0] = rd_s16(blk, SB_W1);
        t.word[1] = rd_s16(blk, SB_W2);
        t.word[2] = rd_s16(blk, SB_W3);
        t.dword[0] = rd_s32(blk, SB_D1);
        t.dword[1] = rd_s32(blk, SB_D2);
        t.dword[2] = rd_s32(blk, SB_D3);
        HOST(host->transition(host->context, &t));
        fx(host, CPZ_FX_XFER_5BB57B, t.scene, 0);
        fx(host, CPZ_FX_XFER_5BB599, t.word[0], 0);
        fx(host, CPZ_FX_XFER_5BB595, t.word[1], 0);
        fx(host, CPZ_FX_XFER_5C39FF, t.word[2], 0);
        fx(host, CPZ_FX_XFER_5BB59B, t.dword[0], 0);
        fx(host, CPZ_FX_XFER_5BB59F, t.dword[1], 0);
        fx(host, CPZ_FX_XFER_5BB5A3, t.dword[2], 0);
        world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;
        fx(host, CPZ_FX_START_FLAG, world->start_flag_5bb1ca, 0);
        fx(host, CPZ_FX_ENGINE_MODE, 4, 0);
    }
    {
        const int16_t flag = rd_s16(blk, SB_FLAG);
        if (flag != CPZ_NO_FLAG) {
            HOST(host->store_event_flag(host->context, flag, blk[SB_VALUE]));
            fx(host, CPZ_FX_EVENT_FLAG, flag, blk[SB_VALUE]);
        }
    }
    return CPZ_OK;
}

/* 0x4633d8: phase 0. */
static int phase0(CpzObject *o, const uint8_t *body, int16_t row, CpzWorld *world, const CpzHost *host)
{
    int32_t view_x = 0, view_y = 0;
    o->row = row;
    o->active = 1;
    fx(host, CPZ_FX_ACTIVE, 1, 0);
    world->start_flag_5bb1ca = 1;
    fx(host, CPZ_FX_START_FLAG, 1, 0);
    if (body[B_PERSIST] == 0) {
        cpz_grid_reset(world);
        fx(host, CPZ_FX_GRID_RESET, 0, 0);
    }
    HOST(host->clear_pending_item(host->context));
    fx(host, CPZ_FX_CLEAR_ITEM, 0, 0);
    o->cell_w = sub32(rd_s32(body, B_PIECE_SRC + 8), rd_s32(body, B_PIECE_SRC));
    o->cell_h = sub32(rd_s32(body, B_PIECE_SRC + 12), rd_s32(body, B_PIECE_SRC + 4));
    HOST(host->view_origin(host->context, &view_x, &view_y));
    {
        const int ran = world->grid_ready == 0;
        grid_setup(o, body, world, view_x, view_y);
        fx(host, CPZ_FX_GRID_SETUP, ran, 0);
    }
    o->flag28 = 1;
    {
        int16_t slot = CPZ_NO_SLOT;
        HOST(host->alloc_slot(host->context, &slot));
        o->slot = slot;
        fx(host, CPZ_FX_SLOT, slot, 0);
        HOST(host->register_slot(host->context, slot, "COLLISION PUZZLE OVERLAYS"));
        fx(host, CPZ_FX_SLOT_REGISTER, slot, 0);
        if (o->surface == 0u) {
            uint32_t surface = 0;
            HOST(host->load_surface(host->context, (const char *)body, &surface));
            o->surface = surface;
            fx(host, CPZ_FX_SURFACE_LOAD, (int32_t)surface, 0);
        }
        HOST(host->set_slot_surface(host->context, slot, o->surface));
        fx(host, CPZ_FX_SLOT_SURFACE, slot, (int32_t)o->surface);
    }
    if (!no_sound(body + B_SOUND_A)) {
        HOST(host->sound_prepare(host->context, body + B_SOUND_A));
        fx(host, CPZ_FX_SOUND_PREPARE, B_SOUND_A, 0);
    }
    if (!no_sound(body + B_SOUND_B)) {
        HOST(host->sound_prepare(host->context, body + B_SOUND_B));
        fx(host, CPZ_FX_SOUND_PREPARE, B_SOUND_B, 0);
    }
    if (!no_sound(body + B_SOUND_C)) {
        HOST(host->sound_prepare(host->context, body + B_SOUND_C));
        fx(host, CPZ_FX_SOUND_PREPARE, B_SOUND_C, 0);
    }
    o->solved = 0;
    o->canceled = 0;
    o->state = CPZ_STATE_IDLE;
    o->piece = 0;
    o->dir = 0;
    o->step = 0;
    o->moved = 0;
    memset(o->saved, 0, sizeof(o->saved));
    return CPZ_OK;
}

/* Plays the stop sound of the move (B when the piece rests on an empty cell type, C otherwise). */
static int play_if(const uint8_t *body, size_t record, size_t channel, const CpzHost *host)
{
    if (!no_sound(body + record)) {
        const int16_t ch = rd_s16(body, channel);
        HOST(host->sound_play(host->context, ch));
        fx(host, CPZ_FX_SOUND_PLAY, ch, 0);
    }
    return CPZ_OK;
}

/* 0x4634a5: phase 1. */
static int phase1(CpzObject *o, const uint8_t *body, CpzWorld *world, uint32_t *row_phase, const CpzHost *host)
{
    switch (o->state) {
    case CPZ_STATE_IDLE:
        o->moved = 0;
        if (o->solved == 0) {
            solved_scan(o, world, body, host);
        } else {
            o->state = CPZ_STATE_SOLVED;
            fx(host, CPZ_FX_STATE, o->state, 0);
        }
        break;
    case CPZ_STATE_SOLVED: {
        const uint32_t now = host->tick(host->context);
        fx(host, CPZ_FX_TICK, (int32_t)now, 0);
        o->deadline = now + (uint32_t)((int32_t)rd_s16(body, B_DELAY) * 1000);
        o->state = CPZ_STATE_WAIT_DELAY;
        fx(host, CPZ_FX_STATE, o->state, 0);
        break;
    }
    case CPZ_STATE_MOVING: {
        int32_t view_x = 0, view_y = 0;
        /* Native safety: the original indexes the grid with these words unchecked; they are always in range unless the
         * object was corrupted from outside. */
        if (o->at_row < 0 || o->at_row >= CPZ_GRID_MAX || o->at_col < 0 || o->at_col >= CPZ_GRID_MAX) return CPZ_ERR_BOUNDS;
        HOST(host->view_origin(host->context, &view_x, &view_y));
        if (move_step(o, body, world, view_x, view_y) != 0 && can_move(o, world, body, o->dir) == 0) {
            const int rests = type_is(world, o->piece, o->at_row, o->at_col);
            const int rc = rests == 0 ? play_if(body, B_SOUND_C, B_CHANNEL_C, host) : play_if(body, B_SOUND_B, B_CHANNEL_B, host);
            if (rc != CPZ_OK) return rc;
            o->state = CPZ_STATE_IDLE;
            fx(host, CPZ_FX_STATE, o->state, 0);
        }
        break;
    }
    case CPZ_STATE_WAIT_SOUND: {
        const int16_t ch = rd_s16(body, B_CHANNEL_D);
        int32_t busy = 0;
        HOST(host->sound_busy(host->context, ch, &busy));
        fx(host, CPZ_FX_SOUND_BUSY, ch, busy);
        if (busy == 0) {
            HOST(host->sound_stop(host->context, body + B_SOUND_D));
            fx(host, CPZ_FX_SOUND_STOP, B_SOUND_D, 0);
            *row_phase = 2u;
            fx(host, CPZ_FX_PHASE, 2, 0);
        }
        break;
    }
    case CPZ_STATE_WAIT_DELAY: {
        const uint32_t now = host->tick(host->context);
        fx(host, CPZ_FX_TICK, (int32_t)now, 0);
        if (now >= o->deadline) {
            if (no_sound(body + B_SOUND_D)) {
                *row_phase = 2u;
                fx(host, CPZ_FX_PHASE, 2, 0);
            } else {
                const int16_t ch = rd_s16(body, B_CHANNEL_D);
                HOST(host->sound_prepare(host->context, body + B_SOUND_D));
                fx(host, CPZ_FX_SOUND_PREPARE, B_SOUND_D, 0);
                HOST(host->sound_play(host->context, ch));
                fx(host, CPZ_FX_SOUND_PLAY, ch, 0);
                o->state = CPZ_STATE_WAIT_SOUND;
                fx(host, CPZ_FX_STATE, o->state, 0);
            }
        }
        break;
    }
    default:
        break;
    }
    return CPZ_OK;
}

/* 0x463c26: phase 2. */
static int phase2(CpzObject *o, const uint8_t *body, CpzWorld *world, const CpzHost *host)
{
    world->start_flag_5bb1ca = 1;
    fx(host, CPZ_FX_START_FLAG, 1, 0);
    if (!no_sound(body + B_SOUND_A)) {
        HOST(host->sound_stop(host->context, body + B_SOUND_A));
        fx(host, CPZ_FX_SOUND_STOP, B_SOUND_A, 0);
    }
    if (!no_sound(body + B_SOUND_B)) {
        HOST(host->sound_stop(host->context, body + B_SOUND_B));
        fx(host, CPZ_FX_SOUND_STOP, B_SOUND_B, 0);
    }
    if (!no_sound(body + B_SOUND_C)) {
        HOST(host->sound_stop(host->context, body + B_SOUND_C));
        fx(host, CPZ_FX_SOUND_STOP, B_SOUND_C, 0);
    }
    if (o->canceled == 0) {
        if (o->solved != 0) return apply_block(body + B_SOLVED, world, host);
        return CPZ_OK;
    }
    return apply_block(body + B_CANCEL, world, host);
}

static int host_complete(const CpzHost *host)
{
    return host != NULL && host->alloc_slot != NULL && host->register_slot != NULL && host->load_surface != NULL &&
           host->set_slot_surface != NULL && host->release_surface != NULL && host->release_slot != NULL &&
           host->mark_dirty != NULL && host->view_origin != NULL && host->clear_pending_item != NULL &&
           host->sound_prepare != NULL && host->sound_stop != NULL && host->sound_play != NULL &&
           host->sound_busy != NULL && host->tick != NULL && host->event_flag_invalid != NULL &&
           host->transition != NULL && host->store_event_flag != NULL;
}

int cpz_step(CpzObject *object, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, CpzWorld *world,
             const CpzHost *host, CpzResult *result, const char **failure)
{
    const char *why = NULL;
    uint32_t row_phase = phase;
    int rc;
    if (failure != NULL) *failure = NULL;
    if (object == NULL || body == NULL || world == NULL || result == NULL || !host_complete(host)) {
        if (failure != NULL) *failure = "0xd3-argument";
        return CPZ_ERR_ARGUMENT;
    }
    memset(result, 0, sizeof(*result));
    result->phase_after = phase;
    if (cpz_validate_body(body, body_length, &why) != CPZ_OK) {
        if (failure != NULL) *failure = why;
        return CPZ_ERR_BODY;
    }
    if (phase == 0u) {
        if (row < 0) {
            if (failure != NULL) *failure = "0xd3-row";
            return CPZ_ERR_ARGUMENT;
        }
        rc = phase0(object, body, row, world, host);
        if (rc == CPZ_OK) {
            row_phase = 1u;
            fx(host, CPZ_FX_PHASE, 1, 0);
            result->initialized = 1u;
        }
    } else if (phase == 1u) {
        if (object->active == 0 || object->row != row) {
            if (failure != NULL) *failure = "0xd3-phase-1-without-init";
            return CPZ_ERR_UNSUPPORTED;
        }
        rc = phase1(object, body, world, &row_phase, host);
    } else if (phase == 2u) {
        if (object->active == 0 || object->row != row) {
            if (failure != NULL) *failure = "0xd3-phase-2-without-init";
            return CPZ_ERR_UNSUPPORTED;
        }
        /* Refuse before any effect when the finish block names a flag the host cannot store. */
        {
            const uint8_t *blk = object->canceled != 0 ? body + B_CANCEL : (object->solved != 0 ? body + B_SOLVED : NULL);
            if (blk != NULL) {
                const int16_t flag = rd_s16(blk, SB_FLAG);
                if (flag != CPZ_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {
                    if (failure != NULL) *failure = "0xd3-event-flag-index";
                    return CPZ_ERR_BOUNDS;
                }
            }
        }
        rc = phase2(object, body, world, host);
        if (rc == CPZ_OK) {
            fx(host, CPZ_FX_COMPLETE, row, 0);
            result->completed = 1u;
            row_phase = 0u; /* 0x42ba3a stores phase 0 */
            rc = cpz_cleanup(object, host);
        }
    } else {
        rc = CPZ_OK; /* any other phase falls out of the switch */
    }
    if (rc != CPZ_OK && failure != NULL && *failure == NULL) *failure = "0xd3-host";
    result->phase_after = row_phase;
    return rc;
}

static int in_rect(const uint8_t *body, size_t rect, int32_t x, int32_t y)
{
    return rd_s32(body, rect + 4) <= y && y <= rd_s32(body, rect + 12) && rd_s32(body, rect) <= x &&
           x <= rd_s32(body, rect + 8);
}

/* 0x4630a3: the cursor / candidate writer. */
static void cursor_write(CpzObject *o, int candidate, CpzPointerResult *out)
{
    out->cursor_written = 1u;
    out->cursor_sub = 1;
    out->candidate = candidate;
    if (candidate == CPZ_CANDIDATE_CANCEL) {
        out->cursor_kind = CPZ_CURSOR_CANCEL;
        return;
    }
    if (o->dir == 0) o->dir = (int16_t)candidate;
    switch (candidate) {
    case CPZ_CANDIDATE_LEFT: out->cursor_kind = 0x19; break;
    case CPZ_CANDIDATE_UP: out->cursor_kind = 0x17; break;
    case CPZ_CANDIDATE_DOWN: out->cursor_kind = 0x18; break;
    default: out->cursor_kind = 0x1a; break;
    }
}

/* FL-12: original FUN_00462c39 is this function (function ledger acceptance). */
int cpz_pointer(CpzObject *object, const CpzWorld *world, const uint8_t *body, size_t body_length, int32_t x, int32_t y,
                int32_t view_x, int32_t view_y, CpzPointerResult *out)
{
    int16_t rows, cols;
    int32_t px, py, quarter, half_h;
    if (object == NULL || world == NULL || body == NULL || out == NULL ||
        cpz_validate_body(body, body_length, NULL) != CPZ_OK)
        return CPZ_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    if (object->active == 0 || object->state == CPZ_STATE_MOVING) return CPZ_OK;
    x = (int16_t)x; /* movsx word */
    y = (int16_t)y;
    px = add32(x, view_x);
    py = add32(y, view_y);
    rows = rd_s16(body, B_ROWS);
    cols = rd_s16(body, B_COLS);
    /* (w + ((w >> 31) & 3)) >> 2 with an arithmetic shift: w / 4 rounded toward zero. */
    quarter = (int32_t)((uint32_t)object->cell_w + (uint32_t)((object->cell_w < 0) ? 3 : 0));
    quarter = (quarter < 0) ? (int32_t)(~(~(uint32_t)quarter >> 2)) : (quarter >> 2);
    half_h = object->cell_h / 2;
    for (int16_t a = 0; a < rows; ++a) {
        for (int16_t b = 0; b < cols; ++b) {
            const CpzCell *c = &world->cell[a][b];
            if (c->piece == 0) continue;
            object->piece = c->piece;
            object->at_row = a;
            object->at_col = b;
            if (c->rect[1] <= py && py < add32(c->rect[1], half_h) && add32(c->rect[0], quarter) < px &&
                px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_UP) == 1) {
                cursor_write(object, CPZ_CANDIDATE_UP, out);
                out->hit = 1u;
                return CPZ_OK;
            }
            if (c->rect[1] <= py && py <= c->rect[3] && sub32(c->rect[2], quarter) < px && px <= c->rect[2] &&
                can_move(object, world, body, CPZ_DIR_RIGHT) == 1) {
                cursor_write(object, CPZ_CANDIDATE_RIGHT, out);
                out->hit = 1u;
                return CPZ_OK;
            }
            if (sub32(c->rect[3], half_h) <= py && py <= c->rect[3] && add32(c->rect[0], quarter) < px &&
                px < sub32(c->rect[2], quarter) && can_move(object, world, body, CPZ_DIR_DOWN) == 1) {
                cursor_write(object, CPZ_CANDIDATE_DOWN, out);
                out->hit = 1u;
                return CPZ_OK;
            }
            if (c->rect[1] <= py && py <= c->rect[3] && c->rect[0] <= px && px < add32(c->rect[0], quarter) &&
                can_move(object, world, body, CPZ_DIR_LEFT) == 1) {
                cursor_write(object, CPZ_CANDIDATE_LEFT, out);
                out->hit = 1u;
                return CPZ_OK;
            }
        }
    }
    object->dir = 0;
    if (in_rect(body, B_CANCEL_RECT, x, y)) {
        cursor_write(object, CPZ_CANDIDATE_CANCEL, out);
        out->hit = 1u;
    }
    return CPZ_OK;
}

int cpz_click(CpzObject *object, const uint8_t *body, size_t body_length, uint32_t row_phase, int32_t candidate,
              int32_t start_flag, const CpzHost *host, CpzClickResult *out)
{
    if (object == NULL || body == NULL || out == NULL || !host_complete(host) ||
        cpz_validate_body(body, body_length, NULL) != CPZ_OK)
        return CPZ_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->new_phase = row_phase;
    if (!(object->active != 0 && object->solved == 0 && object->state == CPZ_STATE_IDLE && row_phase == 1u)) return CPZ_OK;
    if (candidate == CPZ_CANDIDATE_CANCEL) {
        object->canceled = 1;
        out->cancel_asked = 1u;
        out->new_phase = 2u;
        fx(host, CPZ_FX_PHASE, 2, 0);
    } else if (object->dir != 0) {
        object->state = CPZ_STATE_MOVING;
        fx(host, CPZ_FX_STATE, object->state, 0);
        out->move_started = 1u;
        if (start_flag != 0 && !no_sound(body + B_SOUND_A)) {
            const int16_t ch = rd_s16(body, B_CHANNEL_A);
            HOST(host->sound_play(host->context, ch));
            fx(host, CPZ_FX_SOUND_PLAY, ch, 0);
            out->sound_played = 1u;
        }
    }
    return CPZ_OK;
}

/* FL-12: original FUN_004618ab is this function (function ledger acceptance). */
int cpz_invalidate(CpzObject *object, const CpzHost *host)
{
    if (object == NULL || host == NULL || host->mark_dirty == NULL) return CPZ_ERR_ARGUMENT;
    if (object->active != 0 && object->slot != CPZ_NO_SLOT) HOST(host->mark_dirty(host->context, object->slot));
    return CPZ_OK;
}

/* FL-12: original FUN_00461862 is this function (function ledger acceptance). */
int cpz_cleanup(CpzObject *object, const CpzHost *host)
{
    if (object == NULL || host == NULL || host->release_surface == NULL || host->release_slot == NULL)
        return CPZ_ERR_ARGUMENT;
    if (object->surface != 0u) {
        const uint32_t surface = object->surface;
        HOST(host->release_surface(host->context, surface));
        object->surface = 0u;
        fx(host, CPZ_FX_RELEASE_SURFACE, (int32_t)surface, 0);
    }
    if (object->slot != CPZ_NO_SLOT) {
        const int16_t slot = object->slot;
        HOST(host->release_slot(host->context, slot));
        fx(host, CPZ_FX_RELEASE_SLOT, slot, 0);
    }
    object->slot = CPZ_NO_SLOT; /* 0x461827 */
    object->row = -1;
    object->active = 0;
    object->canceled = 0;
    object->solved = 0;
    return CPZ_OK;
}

static void add_blit(CpzRenderResult *out, int kind, int32_t piece, uint32_t surface, const uint8_t *body, size_t src,
                     const int32_t *dst, const CpzHost *host)
{
    CpzBlit *bl = &out->blit[out->count++];
    bl->kind = kind;
    bl->piece = piece;
    bl->src_surface = surface;
    for (int k = 0; k < 4; ++k) {
        bl->src[k] = rd_s32(body, src + (size_t)k * 4u);
        bl->dst[k] = dst[k];
    }
    fx(host, CPZ_FX_BLIT, kind, piece);
}

/* FL-12: original FUN_00463b10 is this function (function ledger acceptance). */
int cpz_render(const CpzObject *object, const CpzWorld *world, const uint8_t *body, size_t body_length,
               const CpzHost *host, CpzRenderResult *out)
{
    int32_t view_x = 0, view_y = 0;
    int16_t rows, cols;
    if (object == NULL || world == NULL || body == NULL || out == NULL || !host_complete(host) ||
        cpz_validate_body(body, body_length, NULL) != CPZ_OK)
        return CPZ_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    if (object->slot == CPZ_NO_SLOT) return CPZ_OK;
    out->valid = 1u;
    HOST(host->view_origin(host->context, &view_x, &view_y));
    rows = rd_s16(body, B_ROWS);
    cols = rd_s16(body, B_COLS);
    for (int16_t a = 0; a < rows; ++a) {
        for (int16_t b = 0; b < cols; ++b) {
            const CpzCell *c = &world->cell[a][b];
            if (c->visible == 0) continue;
            switch (c->type) {
            case 1: case 2: case 3: case 4: case 5: case 6: case 7: case 8: case 9: case 10: {
                const size_t src = B_TARGET_SRC + (size_t)(c->type - 1) * 16u;
                if (rd_s32(body, src + 8) != rd_s32(body, src))
                    add_blit(out, CPZ_BLIT_TARGET, 0, object->surface, body, src, c->base, host);
                break;
            }
            case CPZ_DIR_LEFT:
            case CPZ_DIR_RIGHT:
                add_blit(out, CPZ_BLIT_ARROW_H, 0, object->surface, body, B_ARROW_H, c->base, host);
                break;
            case CPZ_DIR_UP:
            case CPZ_DIR_DOWN:
                add_blit(out, CPZ_BLIT_ARROW_V, 0, object->surface, body, B_ARROW_V, c->base, host);
                break;
            case CPZ_CELL_WALL:
                if (rd_s32(body, B_WALL + 8) != rd_s32(body, B_WALL))
                    add_blit(out, CPZ_BLIT_WALL, 0, object->surface, body, B_WALL, c->base, host);
                break;
            default:
                break;
            }
            if (c->piece != 0) {
                if ((object->state == CPZ_STATE_MOVING || object->moved == 1) && object->piece == c->piece) {
                    CpzBlit *bl = &out->blit[out->count++];
                    bl->kind = CPZ_BLIT_RESTORE;
                    bl->piece = c->piece;
                    bl->src_surface = 0u;
                    bl->src[0] = sub32(object->saved[0], view_x);
                    bl->src[1] = sub32(object->saved[1], view_y);
                    bl->src[2] = sub32(object->saved[2], view_x);
                    bl->src[3] = sub32(object->saved[3], view_y);
                    for (int k = 0; k < 4; ++k) bl->dst[k] = object->saved[k];
                    fx(host, CPZ_FX_BLIT, CPZ_BLIT_RESTORE, c->piece);
                }
                if (c->piece < 1 || c->piece > CPZ_PIECES_MAX) return CPZ_ERR_BOUNDS;
                add_blit(out, CPZ_BLIT_PIECE, c->piece, object->surface, body,
                         B_PIECE_SRC + (size_t)(c->piece - 1) * 16u, c->rect, host);
            }
        }
    }
    return CPZ_OK;
}
