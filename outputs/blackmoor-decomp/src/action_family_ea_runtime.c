#include "action_family_ea_runtime.h"

#include <string.h>

/* Object offsets (see the header). */
enum {
    O_SLOT = 0x1c,
    O_MULTI = 0x1e,
    O_SRC = 0x22,
    O_ROW = 0x26,
    O_PIECES = 0x28,
    O_DRAG = 0xa92,
    O_DROP = 0xa96,
    O_LIFT = 0xa9a,
    O_HAND = 0xa9e,
    O_PREV = 0xaa0,
    O_MOVE = 0xab0,
    O_PREV_T = 0xac0,
    O_MOVE_T = 0xad0,
    O_SAVED = 0xae0,
    O_SND_A = 0xb21,
    O_SND_B = 0xb52,
    O_CHAN_A = 0xb42,
    O_CHAN_B = 0xb73,
    O_PLACED_OK = 0xb83,
    O_DROP_SND = 0xb87,
    O_HAS_ANIM = 0xb8b,
    O_ANIM_REST = 0xb8f,
    O_ANIM_ON = 0xb93,
    O_ANIM_SRC = 0xb97,
    O_ACTIVE = 0xba7,
    O_EXIT = 0xbab,
    O_STATE = 0xbac,
    O_DONE = 0xbb0,
    O_PTR_RECT = 0xbb1,
    O_CAPTION = 0xbc1,
    O_PW = 0xbc5,
    O_PH = 0xbc7,
    O_DEADLINE = 0xbc9,
    O_DEADLINE2 = 0xbcd,
    O_LIST_UNPLACED = 0xbd1,
    O_COUNT_UNPLACED = 0xbf9,
    O_LIST_PLACED = 0xbfb,
    O_COUNT_PLACED = 0xc23,
    O_PLACED_N = 0xc25,
    O_EXIT_AREA = 0xc27,
    O_CLICK_ANIM = 0xc2b,
    O_FLAG_2F = 0xc2f,
    O_ANIM_COL = 0xc33,
    O_ANIM_FRAME = 0xc35,
    O_CELL_W = 0xc37,
    O_CELL_H = 0xc39
};

/* Piece offsets (inside the 0x85-byte piece record) and entry offsets. */
enum {
    P_Z = 0,
    P_RECT = 2,
    P_RECT2 = 0x12,
    P_ORIENT = 0x22,
    P_PLACED = 0x23,
    P_ENT = 0x24,
    P_FLAG84 = 0x84,
    ENT_STRIDE = 0x18,
    ENT_SURF = 0,
    ENT_RECT = 4,
    ENT_W = 0x14,
    ENT_H = 0x16
};

/* Body offsets. */
enum {
    B_NAME = 0x00,
    B_COUNT = 0x21,
    B_FLAG23 = 0x23,
    B_ROT_ALLOWED = 0x24,
    B_ROT_LOCKED = 0x25,
    B_ZONE_H = 0x26,
    B_ZONE_W = 0x28,
    B_TOL_ON = 0x2a,
    B_TOL = 0x2b,
    B_ORDERED = 0x2d,
    B_ORDER = 0x2e,
    B_LAYER_ON = 0x56,
    B_LAYER = 0x57,
    B_PIECES = 0x7f,
    BP_STRIDE = 0x42,
    BP_RECT_A = 0x00,
    BP_RECT_B = 0x10,
    BP_RECT_C = 0x20,
    BP_RECT_D = 0x30,
    BP_ORIENT = 0x40,
    BP_LOOSE = 0x41,
    B_AREA = 0x5a7,
    B_DROP_AREA = 0x5b7,
    B_ANIM_NAME = 0x5c7,
    B_ANIM_AREA = 0x5e8,
    B_EXIT_AREA = 0x5f8,
    B_GRID_ROWS = 0x608,
    B_GRID_COLS = 0x60a,
    B_GRID_X = 0x60c,
    B_GRID_Y = 0x60e,
    B_GRID_GAP = 0x610,
    B_GRID_REPEAT = 0x612,
    B_SND_ANIM = 0x614,
    B_CHAN_ANIM = 0x635,
    B_SND_DONE_REC = 0x645,
    B_CHAN_DONE = 0x666,
    B_SND_ROT = 0x676,
    B_SND_PICK = 0x6a7,
    B_SND_DROP = 0x6d8,
    B_SND_DROP_1 = 0x709,
    B_SND_DROP_2 = 0x72a,
    B_SND_GOOD = 0x74b,
    B_CHAN_GOOD = 0x76c,
    B_SND_GOOD_1 = 0x77c,
    B_SND_GOOD_2 = 0x79d,
    B_KEY_GOOD = 0x7be,
    B_TEXT_GOOD = 0x821,
    B_SND_BAD = 0xa79,
    B_CHAN_BAD = 0xa9a,
    B_SND_BAD_1 = 0xaaa,
    B_SND_BAD_2 = 0xacb,
    B_KEY_BAD = 0xaec,
    B_TEXT_BAD = 0xb4f,
    B_SND_WIN = 0xdc4,
    B_CHAN_WIN = 0xde5,
    B_KEY_WIN = 0xdf5,
    B_TEXT_WIN = 0xe16,
    B_CURSOR_PICK = 0xda7,
    B_CURSOR_EXIT = 0xda9,
    B_BLOCK_WIN = 0xdab,
    B_BLOCK_EXIT = 0xede,
    B_EXIT_RECT = 0xef7
};

/* Scene block offsets. */
enum { SB_SCENE = 0, SB_W1 = 2, SB_W2 = 4, SB_W3 = 6, SB_D1 = 8, SB_D2 = 12, SB_D3 = 16, SB_START = 20, SB_FLAG = 22, SB_VALUE = 24 };

#define TAG_PIECE_SRC "DF_Piece_Source_Surface"
#define TAG_MULTI "Multi_Anim_Surface"
#define LABEL_SLOT "ONEBUILD_PUZZLE_OVERLAYS"
#define CANDIDATE_NONE (-1)

static int16_t rd_s16(const uint8_t *b, size_t off)
{
    return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));
}

static int32_t rd_s32(const uint8_t *b, size_t off)
{
    return (int32_t)((uint32_t)b[off] | ((uint32_t)b[off + 1] << 8) | ((uint32_t)b[off + 2] << 16) |
                     ((uint32_t)b[off + 3] << 24));
}

static void wr_16(uint8_t *b, size_t off, int16_t v)
{
    b[off] = (uint8_t)(v & 0xff);
    b[off + 1] = (uint8_t)(((uint16_t)v >> 8) & 0xff);
}

static void wr_32(uint8_t *b, size_t off, int32_t v)
{
    const uint32_t u = (uint32_t)v;
    b[off] = (uint8_t)(u & 0xff);
    b[off + 1] = (uint8_t)((u >> 8) & 0xff);
    b[off + 2] = (uint8_t)((u >> 16) & 0xff);
    b[off + 3] = (uint8_t)((u >> 24) & 0xff);
}

/* Two's complement wrap of an int32 sum, as the original's `add`. */
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

static size_t piece_off(int16_t i)
{
    return O_PIECES + (size_t)(int32_t)i * EA_PIECE_STRIDE;
}

static size_t bpiece_off(int16_t i)
{
    return B_PIECES + (size_t)(int32_t)i * BP_STRIDE;
}

/* The 8-byte comparison against "NO_FILE\0" (repe cmpsb with ecx = 8). */
static int no_file(const uint8_t *name)
{
    static const uint8_t k[8] = {'N', 'O', '_', 'F', 'I', 'L', 'E', 0};
    return memcmp(name, k, sizeof k) == 0;
}

/* The 9-byte comparison against "NO SOUND\0" (repe cmpsb with ecx = 9). */
static int no_sound(const uint8_t *name)
{
    static const uint8_t k[9] = {'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0};
    return memcmp(name, k, sizeof k) == 0;
}

#define HOST(call) do { if ((call) != 0) { return EA_ERR_HOST; } } while (0)

void ea_object_reset(EaObject *object)
{
    memset(object->b, 0, sizeof(object->b));
    wr_16(object->b, O_ROW, -1);
    wr_16(object->b, O_SLOT, -1);
}

int16_t ea_object_slot(const EaObject *object) { return rd_s16(object->b, O_SLOT); }
int16_t ea_object_row(const EaObject *object) { return rd_s16(object->b, O_ROW); }
int ea_object_active(const EaObject *object) { return rd_s32(object->b, O_ACTIVE) != 0; }
uint32_t ea_object_state(const EaObject *object) { return (uint32_t)rd_s32(object->b, O_STATE); }

/* 0x484f0d: nonzero when the rectangle has a nonzero width and height edge pair. */
static int rect_valid(const uint8_t *body, size_t off)
{
    return !(rd_s32(body, off + 12) == rd_s32(body, off + 4) || rd_s32(body, off + 8) == rd_s32(body, off));
}

static int field_terminated(const uint8_t *body, size_t off, size_t span)
{
    return memchr(body + off, 0, span) != NULL;
}

int ea_validate_body(const uint8_t *body, size_t length, const char **failure)
{
    const char *why = NULL;
    int16_t n;
    static const struct { size_t off; size_t span; } fields[] = {
        {B_NAME, 0x21}, {B_ANIM_NAME, 0x21}, {B_SND_ANIM, 0x21}, {B_SND_DONE_REC, 0x21}, {B_SND_ROT, 0x21},
        {B_SND_PICK, 0x21}, {B_SND_DROP, 0x21}, {B_SND_DROP_1, 0x21}, {B_SND_DROP_2, 0x21}, {B_SND_GOOD, 0x21},
        {B_SND_GOOD_1, 0x21}, {B_SND_GOOD_2, 0x21}, {B_KEY_GOOD, 0x21}, {B_KEY_GOOD + 0x21, 0x21},
        {B_KEY_GOOD + 0x42, 0x21}, {B_TEXT_GOOD, 200}, {B_TEXT_GOOD + 200, 200}, {B_TEXT_GOOD + 400, 200},
        {B_SND_BAD, 0x21}, {B_SND_BAD_1, 0x21}, {B_SND_BAD_2, 0x21}, {B_KEY_BAD, 0x21}, {B_KEY_BAD + 0x21, 0x21},
        {B_KEY_BAD + 0x42, 0x21}, {B_TEXT_BAD, 200}, {B_TEXT_BAD + 200, 200}, {B_TEXT_BAD + 400, 200},
        {B_SND_WIN, 0x21}, {B_KEY_WIN, 0x21}, {B_TEXT_WIN, 200}};
    if (body == NULL || length != EA_BODY_BYTES) {
        why = "0xea-body-length";
    } else if ((n = rd_s16(body, B_COUNT)) < 0 || n > EA_MAX_PIECES) {
        why = "0xea-piece-count";
    } else if (rd_s32(body, B_ANIM_AREA + 12) != rd_s32(body, B_ANIM_AREA + 4) && rd_s16(body, B_GRID_COLS) == 0) {
        why = "0xea-grid-columns-zero";
    } else {
        for (size_t k = 0; k < sizeof fields / sizeof fields[0] && why == NULL; ++k)
            if (!field_terminated(body, fields[k].off, fields[k].span)) why = "0xea-unterminated-field";
        for (int16_t i = 0; i < n && why == NULL; ++i) {
            const size_t p = bpiece_off(i);
            const size_t r = rect_valid(body, p + BP_RECT_B) ? p + BP_RECT_B : p + BP_RECT_A;
            const int32_t w = (int16_t)(rd_s32(body, r + 8) - rd_s32(body, r)) + 1;
            const int32_t h = (int16_t)(rd_s32(body, r + 12) - rd_s32(body, r + 4)) + 1;
            if (w < 1 || w > 4096 || h < 1 || h > 4096) why = "0xea-piece-size";
        }
    }
    if (why != NULL) {
        if (failure != NULL) *failure = why;
        return EA_ERR_BODY;
    }
    return EA_OK;
}

static int host_complete(const EaHost *h)
{
    return h != NULL && h->view != NULL && h->alloc_slot != NULL && h->register_slot != NULL &&
           h->release_slot != NULL && h->mark_dirty != NULL && h->load_surface != NULL && h->create_surface != NULL &&
           h->blit != NULL && h->copy_surface != NULL && h->rotate_surface != NULL && h->release_surface != NULL &&
           h->clear_pending_item != NULL && h->sound_prepare != NULL && h->sound_stop != NULL &&
           h->sound_play != NULL && h->sound_busy != NULL && h->tick != NULL && h->rand_value != NULL &&
           h->captions_enabled != NULL && h->autotext_lookup != NULL && h->caption_show != NULL &&
           h->event_flag_invalid != NULL && h->transition != NULL && h->store_event_flag != NULL &&
           h->complete != NULL;
}

/* 0x4841cb: rectangle plus the view origin. */
static int translate(uint8_t *obj, size_t from, size_t to, const EaHost *host)
{
    EaView v;
    int32_t src[4];
    HOST(host->view(host->context, &v));
    for (int k = 0; k < 4; ++k) src[k] = rd_s32(obj, from + (size_t)k * 4u);
    wr_32(obj, to + 4, add32(src[1], v.origin_y));
    wr_32(obj, to + 12, add32(src[3], v.origin_y));
    wr_32(obj, to, add32(src[0], v.origin_x));
    wr_32(obj, to + 8, add32(src[2], v.origin_x));
    return EA_OK;
}

static void copy_rect(uint8_t *to, size_t to_off, const uint8_t *from, size_t from_off)
{
    for (int k = 0; k < 4; ++k) wr_32(to, to_off + (size_t)k * 4u, rd_s32(from, from_off + (size_t)k * 4u));
}

/* 0x484caf: clamp a rectangle into the clip rectangle, keeping its size. */
static int clamp_rect(uint8_t *obj, size_t off, const EaHost *host)
{
    EaView v;
    int16_t w, h;
    HOST(host->view(host->context, &v));
    w = (int16_t)sub32(rd_s32(obj, off + 8), rd_s32(obj, off));
    h = (int16_t)sub32(rd_s32(obj, off + 12), rd_s32(obj, off + 4));
    if (rd_s32(obj, off + 4) < v.clip[1]) {
        wr_32(obj, off + 4, v.clip[1]);
        wr_32(obj, off + 12, add32(rd_s32(obj, off + 4), h));
    }
    if (v.clip[3] < rd_s32(obj, off + 12)) {
        wr_32(obj, off + 12, v.clip[3]);
        wr_32(obj, off + 4, sub32(rd_s32(obj, off + 12), h));
    }
    if (rd_s32(obj, off) < v.clip[0]) {
        wr_32(obj, off, v.clip[0]);
        wr_32(obj, off + 8, add32(rd_s32(obj, off), w));
    }
    if (v.clip[2] < rd_s32(obj, off + 8)) {
        wr_32(obj, off + 8, v.clip[2]);
        wr_32(obj, off, sub32(rd_s32(obj, off + 8), w));
    }
    return EA_OK;
}

/* 0x48421e: build the surfaces of piece i. */
static int piece_init(uint8_t *obj, const uint8_t *body, int16_t i, const EaHost *host)
{
    const size_t P = piece_off(i);
    const size_t BP = bpiece_off(i);
    size_t ent = P + P_ENT;
    int32_t src_rect[4];
    int16_t w, h;
    uint32_t surf = 0;
    int32_t dst_rect[4];
    wr_16(obj, P + P_Z, 0);
    obj[P + P_ORIENT] = body[BP + BP_ORIENT];
    obj[P + P_PLACED] = body[BP + BP_LOOSE];
    if (obj[P + P_PLACED] == 0) {
        for (int k = 0; k < 4; ++k) wr_32(obj, P + P_RECT + (size_t)k * 4u, rd_s32(body, BP + BP_RECT_D + (size_t)k * 4u));
        HOST(translate(obj, P + P_RECT, P + P_RECT2, host));
    } else {
        for (int k = 0; k < 4; ++k) wr_32(obj, P + P_RECT + (size_t)k * 4u, rd_s32(body, BP + BP_RECT_C + (size_t)k * 4u));
        HOST(translate(obj, P + P_RECT, P + P_RECT2, host));
        obj[P + P_ORIENT] = 0;
        if (body[B_LAYER_ON] != 0) {
            const int16_t n = rd_s16(body, B_COUNT);
            for (int16_t k = 0; k < n; ++k)
                if ((int32_t)rd_s16(body, B_LAYER + (size_t)k * 2u) == (int32_t)i + 1) wr_16(obj, P + P_Z, k);
        }
    }
    if (!rect_valid(body, BP + BP_RECT_B)) {
        w = (int16_t)(sub32(rd_s32(body, BP + BP_RECT_A + 8), rd_s32(body, BP + BP_RECT_A)) + 1);
        h = (int16_t)(sub32(rd_s32(body, BP + BP_RECT_A + 12), rd_s32(body, BP + BP_RECT_A + 4)) + 1);
        for (int k = 0; k < 4; ++k) src_rect[k] = rd_s32(body, BP + BP_RECT_A + (size_t)k * 4u);
        obj[P + P_FLAG84] = 1;
    } else {
        w = (int16_t)(sub32(rd_s32(body, BP + BP_RECT_B + 8), rd_s32(body, BP + BP_RECT_B)) + 1);
        h = (int16_t)(sub32(rd_s32(body, BP + BP_RECT_B + 12), rd_s32(body, BP + BP_RECT_B + 4)) + 1);
        for (int k = 0; k < 4; ++k) src_rect[k] = rd_s32(body, BP + BP_RECT_B + (size_t)k * 4u);
        obj[P + P_FLAG84] = 0;
    }
    wr_16(obj, ent + ENT_W, w);
    wr_16(obj, ent + ENT_H, h);
    HOST(host->create_surface(host->context, w, h, "pDFSurface for Onebuild Puzzle Piece", &surf));
    wr_32(obj, ent + ENT_SURF, (int32_t)surf);
    wr_32(obj, ent + ENT_RECT + 4, 0);
    wr_32(obj, ent + ENT_RECT, 0);
    wr_32(obj, ent + ENT_RECT + 12, add32(sub32(rd_s32(obj, ent + ENT_RECT + 4), 1), h));
    wr_32(obj, ent + ENT_RECT + 8, add32(sub32(rd_s32(obj, ent + ENT_RECT), 1), w));
    for (int k = 0; k < 4; ++k) dst_rect[k] = rd_s32(obj, ent + ENT_RECT + (size_t)k * 4u);
    HOST(host->blit(host->context, (uint32_t)rd_s32(obj, O_SRC), surf, src_rect, dst_rect));
    if (body[B_ROT_ALLOWED] != 0 || obj[P + P_ORIENT] != 0) {
        for (unsigned k = 1; k < 4; ++k) {
            const size_t prev = ent;
            ent = P + P_ENT + (size_t)k * ENT_STRIDE;
            if (obj[P + P_PLACED] == 0) {
                uint32_t s2 = 0;
                int16_t rw = 0, rh = 0;
                HOST(host->create_surface(host->context, w, h, "pDFSurface for Onebuild Puzzle Piece", &s2));
                wr_32(obj, ent + ENT_SURF, (int32_t)s2);
                HOST(host->copy_surface(host->context, s2, (uint32_t)rd_s32(obj, prev + ENT_SURF)));
                HOST(host->rotate_surface(host->context, s2, &rw, &rh));
                wr_32(obj, ent + ENT_RECT, 0);
                wr_32(obj, ent + ENT_RECT + 4, 0);
                wr_32(obj, ent + ENT_RECT + 12, add32(sub32(rd_s32(obj, ent + ENT_RECT + 4), 1), rh));
                wr_32(obj, ent + ENT_RECT + 8, add32(sub32(rd_s32(obj, ent + ENT_RECT), 1), rw));
                wr_16(obj, ent + ENT_W, rw);
                wr_16(obj, ent + ENT_H, rh);
                w = rw;
                h = rh;
            } else {
                wr_32(obj, ent + ENT_SURF, 0);
            }
        }
    }
    return EA_OK;
}

/* 0x4853b0: turn piece i to its next orientation around its centre. */
static int rotate_piece(uint8_t *obj, int16_t i, const EaHost *host)
{
    const size_t P = piece_off(i);
    size_t ent;
    int16_t sw, sh, cx, cy;
    wr_32(obj, O_LIFT, 1);
    copy_rect(obj, O_SAVED, obj, P + P_RECT);
    ent = P + P_ENT + (size_t)obj[P + P_ORIENT] * ENT_STRIDE;
    sw = rd_s16(obj, ent + ENT_W);
    sh = rd_s16(obj, ent + ENT_H);
    cx = (int16_t)add32(rd_s32(obj, P + P_RECT), (int32_t)sw / 2);
    cy = (int16_t)add32(rd_s32(obj, P + P_RECT + 4), (int32_t)sh / 2);
    obj[P + P_ORIENT] = (uint8_t)(obj[P + P_ORIENT] + 1u);
    if (obj[P + P_ORIENT] == 4) obj[P + P_ORIENT] = 0;
    ent = P + P_ENT + (size_t)obj[P + P_ORIENT] * ENT_STRIDE;
    wr_32(obj, P + P_RECT, sub32((int32_t)cx, (int32_t)rd_s16(obj, ent + ENT_W) / 2));
    wr_32(obj, P + P_RECT + 4, sub32((int32_t)cy, (int32_t)rd_s16(obj, ent + ENT_H) / 2));
    wr_32(obj, P + P_RECT + 8, add32(rd_s32(obj, P + P_RECT), rd_s32(obj, ent + ENT_RECT + 8)));
    wr_32(obj, P + P_RECT + 12, add32(rd_s32(obj, P + P_RECT + 4), rd_s32(obj, ent + ENT_RECT + 12)));
    HOST(clamp_rect(obj, P + P_RECT, host));
    return translate(obj, P + P_RECT, P + P_RECT2, host);
}

/* 0x484622 / 0x4846c2: the piece of a list with the greatest layer (the first on ties), or -1. */
static int16_t top_piece(const uint8_t *obj, size_t list, size_t count)
{
    int16_t best;
    int16_t n = rd_s16(obj, count);
    int32_t k;
    if (n == 0) return -1;
    best = rd_s16(obj, list);
    for (k = 1; k < n; ++k) {
        const int16_t cand = rd_s16(obj, list + (size_t)k * 2u);
        if (rd_s16(obj, piece_off(best) + P_Z) < rd_s16(obj, piece_off(cand) + P_Z)) best = cand;
    }
    return best;
}

/* 0x484762: do the rectangles of pieces a and b overlap. */
static int pieces_overlap(const uint8_t *obj, int16_t a, int16_t b)
{
    const size_t A = piece_off(a), B = piece_off(b);
    int32_t x0, x1, y0, y1;
    const int32_t al = rd_s32(obj, A + 2), at = rd_s32(obj, A + 6), ar = rd_s32(obj, A + 10), ab = rd_s32(obj, A + 14);
    const int32_t bl = rd_s32(obj, B + 2), bt = rd_s32(obj, B + 6), br = rd_s32(obj, B + 10), bb = rd_s32(obj, B + 14);
    if (al < bl) {
        if (ar < bl) return 0;
        x0 = bl;
        x1 = br < ar ? br : ar;
    } else {
        if (br < al) return 0;
        x0 = al;
        x1 = br < ar ? br : ar;
    }
    if (at < bt) {
        if (ab < bt) return 0;
        y0 = bt;
        y1 = bb < ab ? bb : ab;
    } else {
        if (bb < at) return 0;
        y0 = at;
        y1 = bb < ab ? bb : ab;
    }
    return !(y0 == -1 || y1 == -1 || x0 == -1 || x1 == -1);
}

/* 0x484935: the layer of piece i. */
static void set_layer(uint8_t *obj, const uint8_t *body, int16_t i)
{
    const size_t P = piece_off(i);
    const int16_t n = rd_s16(body, B_COUNT);
    if (body[B_LAYER_ON] == 0) {
        int16_t hits[20];
        int16_t count = 0;
        for (int k = 0; k < 20; ++k) hits[k] = -1;
        for (int16_t c = 0; c < n; ++c)
            if (c != i && pieces_overlap(obj, i, c)) hits[count++] = c;
        for (int16_t c = 0; c < count; ++c) {
            const int16_t other = rd_s16(obj, piece_off(hits[c]) + P_Z);
            const int16_t mine = rd_s16(obj, P + P_Z);
            wr_16(obj, P + P_Z, other < mine ? mine : other);
        }
        wr_16(obj, P + P_Z, (int16_t)(rd_s16(obj, P + P_Z) + 1));
    } else {
        for (int16_t c = 0; c < n; ++c)
            if ((int32_t)rd_s16(body, B_LAYER + (size_t)c * 2u) == (int32_t)i + 1) wr_16(obj, P + P_Z, c);
    }
}

/* 0x486725: the puzzle is done when every piece the body expects on the board is placed. */
static void check_solved(uint8_t *obj, const uint8_t *body)
{
    const int16_t n = rd_s16(body, B_COUNT);
    for (int16_t k = 0; k < n; ++k) {
        if (obj[piece_off(k) + P_PLACED] == 0) {
            if (rd_s32(body, bpiece_off(k) + BP_RECT_C + 4) != 0) return;
            if (rd_s32(body, bpiece_off(k) + BP_RECT_C + 12) != 0) return;
        }
    }
    wr_32(obj, O_STATE, EA_STATE_DONE);
    obj[O_DONE] = 1;
}

/* 0x4866b4: is the rectangle at `off` inside the area rectangle. */
static int inside_area(const uint8_t *obj, const uint8_t *body, size_t off)
{
    if (rd_s32(obj, off + 4) < rd_s32(body, B_AREA + 4) || rd_s32(body, B_AREA + 12) < rd_s32(obj, off + 12) ||
        rd_s32(obj, off) < rd_s32(body, B_AREA) || rd_s32(body, B_AREA + 8) < rd_s32(obj, off + 8))
        return 0;
    return 1;
}

static uint32_t now(const EaHost *host) { return host->tick(host->context); }

/* The 0x31-byte record copy of the sound helpers. */
static void copy_record(uint8_t *obj, size_t to, const uint8_t *body, size_t from)
{
    memcpy(obj + to, body + from, EA_SOUND_RECORD_BYTES);
}

/* strcpy of a NUL-terminated name over the start of a buffer (the field was validated to be terminated). */
static void copy_name(uint8_t *obj, size_t to, const uint8_t *body, size_t from)
{
    size_t n = strlen((const char *)body + from) + 1u;
    memcpy(obj + to, body + from, n);
}

/* rand() % 3 narrowed to a short, as the helpers do. */
static int rand3(const EaHost *host, int16_t *out)
{
    int32_t v = 0;
    HOST(host->rand_value(host->context, &v));
    if (v < 0) return EA_ERR_BOUNDS; /* _rand() is never negative */
    *out = (int16_t)(v % 3);
    return EA_OK;
}

/* The random alternate pick shared by 0x48633c, 0x485fb6 and 0x485d52. `alt1` and `alt2` are body offsets of records
 * that replace the name in the object buffer `to`. Returns the final pick in *r. */
static int pick_alternate(uint8_t *obj, size_t to, const uint8_t *body, size_t alt1, size_t alt2, const EaHost *host,
                          int16_t *r)
{
    HOST(rand3(host, r));
    if (0 < *r) {
        int done = 0;
        for (;;) {
            if (done || *r < 1) break;
            if (*r == 1) {
                if (!no_sound(body + alt1)) {
                    copy_name(obj, to, body, alt1);
                    done = 1;
                    continue;
                }
            }
            if (*r == 2) {
                if (no_sound(body + alt2)) {
                    HOST(rand3(host, r));
                } else {
                    copy_name(obj, to, body, alt2);
                    done = 1;
                }
            } else {
                HOST(rand3(host, r));
            }
        }
    }
    return EA_OK;
}

/* strlen(src) + the "<e>" suffix into a 204-byte local; the original overruns the buffer beyond 199 characters. */
static int show_caption(const EaHost *host, const char *text)
{
    char buf[204];
    const size_t n = strlen(text);
    if (n + 4u > sizeof buf) return EA_ERR_BOUNDS;
    memcpy(buf, text, n);
    memcpy(buf + n, "<e>", 4);
    return host->caption_show(host->context, buf) != 0 ? EA_ERR_HOST : EA_OK;
}

/* The caption block shared by 0x48633c, 0x485fb6 and phase 1 state 6: AUTOTEXT lookup of `key`, else the body text.
 * Sets obj+0xbc1 when `flag_on_show` and a caption was shown. */
static int caption_block(uint8_t *obj, const uint8_t *body, size_t key, size_t text, int flag_on_show,
                         const EaHost *host)
{
    int32_t enabled = 0;
    const char *found = NULL;
    HOST(host->captions_enabled(host->context, &enabled));
    if (enabled == 0) return EA_OK;
    if (body[key] != 0) {
        const char *t = NULL;
        HOST(host->autotext_lookup(host->context, (const char *)body + key, &t));
        if (t != NULL && strlen(t) < 0x9c41u) {
            int rc = show_caption(host, t);
            if (rc != EA_OK) return rc;
            if (flag_on_show) wr_32(obj, O_CAPTION, 1);
            found = t;
        }
    }
    if (found == NULL && body[text] != 0) {
        int rc = show_caption(host, (const char *)body + text);
        if (rc != EA_OK) return rc;
        if (flag_on_show) wr_32(obj, O_CAPTION, 1);
    }
    return EA_OK;
}

/* 0x48633c (good drop) and 0x485fb6 (bad drop). */
static int feedback_sound(uint8_t *obj, const uint8_t *body, int good, const EaHost *host)
{
    const size_t rec = good ? B_SND_GOOD : B_SND_BAD;
    const size_t alt1 = good ? B_SND_GOOD_1 : B_SND_BAD_1;
    const size_t alt2 = good ? B_SND_GOOD_2 : B_SND_BAD_2;
    const size_t chan = good ? B_CHAN_GOOD : B_CHAN_BAD;
    const size_t key = good ? B_KEY_GOOD : B_KEY_BAD;
    const size_t text = good ? B_TEXT_GOOD : B_TEXT_BAD;
    int16_t r = 0;
    int rc;
    if (no_sound(body + rec)) {
        wr_32(obj, O_STATE, 0);
        return EA_OK;
    }
    copy_record(obj, O_SND_A, body, rec);
    HOST(pick_alternate(obj, O_SND_A, body, alt1, alt2, host, &r));
    HOST(host->sound_prepare(host->context, EA_SOUND_OBJECT_ID + O_SND_A, obj + O_SND_A));
    HOST(host->sound_play(host->context, rd_s16(body, chan)));
    rc = caption_block(obj, body, key + (size_t)r * 0x21u, text + (size_t)r * 200u, 1, host);
    if (rc != EA_OK) return rc;
    wr_32(obj, O_STATE, EA_STATE_FEEDBACK);
    if (good) wr_32(obj, O_CAPTION, 1);
    wr_32(obj, O_DEADLINE, (int32_t)(now(host) + 2000u));
    return EA_OK;
}

/* 0x485ca1 (pick), 0x485f12 (rotate) and 0x485d52 (drop) sound helpers. */
static int piece_sound(uint8_t *obj, const uint8_t *body, size_t rec, int is_pick, int is_drop, const EaHost *host)
{
    if (no_sound(body + rec)) return EA_OK;
    copy_record(obj, O_SND_B, body, rec);
    if (is_drop) {
        int16_t r = 0;
        HOST(pick_alternate(obj, O_SND_B, body, B_SND_DROP_1, B_SND_DROP_2, host, &r));
    }
    HOST(host->sound_prepare(host->context, EA_SOUND_OBJECT_ID + O_SND_B, obj + O_SND_B));
    HOST(host->sound_play(host->context, rd_s16(obj, O_CHAN_B)));
    if (is_pick || is_drop) wr_32(obj, O_STATE, EA_STATE_DROP_WAIT);
    wr_32(obj, O_DEADLINE, (int32_t)(now(host) + 300u));
    wr_32(obj, O_DROP_SND, is_drop ? 1 : 0);
    return EA_OK;
}

static void piece_size(uint8_t *obj, int16_t i)
{
    const size_t P = piece_off(i);
    wr_16(obj, O_PW, (int16_t)sub32(rd_s32(obj, P + 10), rd_s32(obj, P + 2)));
    wr_16(obj, O_PH, (int16_t)sub32(rd_s32(obj, P + 14), rd_s32(obj, P + 6)));
}

static int apply_block(const uint8_t *blk, EaWorld *world, const EaHost *host)
{
    if (rd_s16(blk, SB_SCENE) != EA_NO_SCENE) {
        EaTransition t;
        t.scene = rd_s16(blk, SB_SCENE);
        t.word[0] = rd_s16(blk, SB_W1);
        t.word[1] = rd_s16(blk, SB_W2);
        t.word[2] = rd_s16(blk, SB_W3);
        t.dword[0] = rd_s32(blk, SB_D1);
        t.dword[1] = rd_s32(blk, SB_D2);
        t.dword[2] = rd_s32(blk, SB_D3);
        HOST(host->transition(host->context, &t));
        world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;
    }
    {
        const int16_t flag = rd_s16(blk, SB_FLAG);
        if (flag != EA_NO_FLAG) HOST(host->store_event_flag(host->context, flag, blk[SB_VALUE]));
    }
    return EA_OK;
}

int ea_cleanup(EaObject *object, const EaHost *host)
{
    uint8_t *obj;
    if (object == NULL || host == NULL || host->release_surface == NULL || host->release_slot == NULL)
        return EA_ERR_ARGUMENT;
    obj = object->b;
    if (rd_s32(obj, O_MULTI) != 0) {
        HOST(host->release_surface(host->context, (uint32_t)rd_s32(obj, O_MULTI)));
        wr_32(obj, O_MULTI, 0);
    }
    if (rd_s32(obj, O_SRC) != 0) {
        HOST(host->release_surface(host->context, (uint32_t)rd_s32(obj, O_SRC)));
        wr_32(obj, O_SRC, 0);
    }
    for (int16_t i = 0; i < 20; ++i)
        for (int16_t k = 0; k < 4; ++k) {
            const size_t e = piece_off(i) + P_ENT + (size_t)k * ENT_STRIDE;
            if (rd_s32(obj, e + ENT_SURF) != 0) {
                HOST(host->release_surface(host->context, (uint32_t)rd_s32(obj, e + ENT_SURF)));
                wr_32(obj, e + ENT_SURF, 0);
            }
        }
    if (rd_s16(obj, O_SLOT) != -1) HOST(host->release_slot(host->context, rd_s16(obj, O_SLOT)));
    /* 0x483f6a */
    wr_16(obj, O_ROW, -1);
    wr_16(obj, O_SLOT, -1);
    wr_32(obj, O_ACTIVE, 0);
    obj[O_EXIT] = 0;
    obj[O_DONE] = 0;
    wr_32(obj, O_DRAG, 0);
    return EA_OK;
}

/* 0x4867bd phase 0. */
static int phase0(uint8_t *obj, uint8_t *body, int16_t row, EaWorld *world, const EaHost *host)
{
    const int16_t n = rd_s16(body, B_COUNT);
    int16_t slot = EA_NO_SLOT;
    wr_16(obj, O_ROW, row);
    wr_32(obj, O_ACTIVE, 1);
    world->start_flag_5bb1ca = 1;
    HOST(host->clear_pending_item(host->context));
    wr_32(obj, O_DRAG, 0);
    wr_16(obj, O_HAND, -1);
    wr_32(obj, O_DRAG, 0);
    wr_32(obj, O_DROP, 0);
    wr_32(obj, O_LIFT, 0);
    obj[O_DONE] = 0;
    obj[O_EXIT] = 0;
    wr_32(obj, O_STATE, 0);
    for (size_t off = O_PREV; off < O_PREV + 0x40u; off += 4u) wr_32(obj, off, 0);
    for (size_t off = O_PTR_RECT; off < O_PTR_RECT + 16u; off += 4u) wr_32(obj, off, 0);
    wr_32(obj, O_DEADLINE, 0);
    wr_32(obj, O_CAPTION, 0);
    wr_16(obj, O_PLACED_N, 0);
    wr_32(obj, O_CLICK_ANIM, 0);
    wr_32(obj, O_FLAG_2F, 0);
    wr_16(obj, O_ANIM_COL, 0);
    wr_16(obj, O_ANIM_FRAME, 0);
    wr_16(obj, O_CELL_W, (int16_t)sub32(rd_s32(body, B_ANIM_AREA + 8), rd_s32(body, B_ANIM_AREA)));
    wr_16(obj, O_CELL_H, (int16_t)sub32(rd_s32(body, B_ANIM_AREA + 12), rd_s32(body, B_ANIM_AREA + 4)));
    if (rd_s32(obj, O_SRC) == 0) {
        uint32_t s = 0;
        HOST(host->load_surface(host->context, (const char *)body + B_NAME, TAG_PIECE_SRC, &s));
        wr_32(obj, O_SRC, (int32_t)s);
    }
    wr_32(obj, O_MULTI, 0);
    wr_32(obj, O_ANIM_REST, 0);
    wr_32(obj, O_ANIM_ON, 0);
    wr_32(obj, O_HAS_ANIM, rd_s32(body, B_ANIM_AREA + 12) != rd_s32(body, B_ANIM_AREA + 4));
    wr_32(obj, O_EXIT_AREA, rd_s32(body, B_EXIT_AREA + 12) != rd_s32(body, B_EXIT_AREA + 4));
    {
        int has = 0;
        if (rd_s32(body, B_ANIM_AREA + 12) != rd_s32(body, B_ANIM_AREA + 4) && !no_file(body + B_ANIM_NAME) &&
            body[B_ANIM_NAME] != 0) {
            uint32_t s = 0;
            HOST(host->load_surface(host->context, (const char *)body + B_ANIM_NAME, TAG_MULTI, &s));
            wr_32(obj, O_MULTI, (int32_t)s);
            wr_32(obj, O_HAS_ANIM, 1);
            has = 1;
        }
        if (!has) wr_32(obj, O_HAS_ANIM, 0);
    }
    for (int16_t i = 0; i < 20; ++i)
        for (int16_t k = 0; k < 4; ++k) wr_32(obj, piece_off(i) + P_ENT + (size_t)k * ENT_STRIDE, 0);
    for (int16_t i = 0; i < n; ++i) HOST(piece_init(obj, body, i, host));
    HOST(host->alloc_slot(host->context, &slot));
    wr_16(obj, O_SLOT, slot);
    HOST(host->register_slot(host->context, slot, LABEL_SLOT));
    return EA_OK;
}

/* 0x4867bd phase 2. */
static int phase2(uint8_t *obj, const uint8_t *body, int16_t row, EaWorld *world, const EaHost *host)
{
    world->start_flag_5bb1ca = 1;
    if (obj[O_EXIT] == 0) {
        if (obj[O_DONE] != 0) {
            int rc = apply_block(body + B_BLOCK_WIN, world, host);
            if (rc != EA_OK) return rc;
        }
    } else {
        int rc = apply_block(body + B_BLOCK_EXIT, world, host);
        if (rc != EA_OK) return rc;
    }
    HOST(host->complete(host->context, row));
    return EA_OK;
}

/* 0x4867bd phase 1: the state machine on obj+0xbac. */
static int phase1(uint8_t *obj, const uint8_t *body, uint32_t *row_phase, const EaHost *host)
{
    switch (rd_s32(obj, O_STATE)) {
    case EA_STATE_IDLE:
        if (rd_s32(obj, O_CLICK_ANIM) == 0) return EA_OK;
        if (rd_s32(obj, O_HAS_ANIM) == 0) {
            check_solved(obj, body);
            if (obj[O_DONE] == 0) {
                HOST(host->sound_prepare(host->context, B_SND_DONE_REC, body + B_SND_DONE_REC));
                HOST(host->sound_play(host->context, rd_s16(body, B_CHAN_DONE)));
                wr_32(obj, O_DEADLINE2, (int32_t)(now(host) + 800u));
                wr_32(obj, O_STATE, EA_STATE_WAIT);
                wr_32(obj, O_FLAG_2F, 1);
            }
        } else {
            wr_32(obj, O_STATE, EA_STATE_ANIM_STEP);
            HOST(host->sound_prepare(host->context, B_SND_ANIM, body + B_SND_ANIM));
            wr_32(obj, O_DEADLINE2, (int32_t)(now(host) + 100u));
        }
        wr_32(obj, O_CLICK_ANIM, 0);
        return EA_OK;
    case EA_STATE_DROP_WAIT:
        if (now(host) < (uint32_t)rd_s32(obj, O_DEADLINE)) return EA_OK;
        HOST(host->sound_stop(host->context, EA_SOUND_OBJECT_ID + O_SND_B, obj + O_SND_B));
        if (rd_s32(obj, O_DROP_SND) != 0 && rd_s32(obj, O_PLACED_OK) != 0) {
            int rc = feedback_sound(obj, body, 1, host);
            if (rc != EA_OK) return rc;
            if (rd_s32(obj, O_EXIT_AREA) != 0) return EA_OK;
            check_solved(obj, body);
            return EA_OK;
        }
        if (rd_s32(obj, O_DROP_SND) != 0 && !inside_area(obj, body, O_MOVE)) return feedback_sound(obj, body, 0, host);
        wr_32(obj, O_STATE, EA_STATE_IDLE);
        return EA_OK;
    case EA_STATE_FEEDBACK: {
        int32_t busy = 0;
        HOST(host->sound_busy(host->context, rd_s16(obj, O_CHAN_A), &busy));
        if (busy != 0 && now(host) < (uint32_t)rd_s32(obj, O_DEADLINE)) return EA_OK;
        HOST(host->sound_stop(host->context, EA_SOUND_OBJECT_ID + O_SND_A, obj + O_SND_A));
        {
            int32_t enabled = 0;
            HOST(host->captions_enabled(host->context, &enabled));
            if (enabled != 0 && rd_s32(obj, O_CAPTION) != 0) {
                HOST(host->caption_show(host->context, "<n><e>"));
                wr_32(obj, O_CAPTION, 0);
            }
        }
        wr_32(obj, O_STATE, EA_STATE_IDLE);
        return EA_OK;
    }
    case EA_STATE_ANIM_STEP: {
        const int16_t cols = rd_s16(body, B_GRID_COLS);
        int16_t cell;
        if (!no_sound(body + B_SND_ANIM)) {
            int32_t busy = 0;
            HOST(host->sound_busy(host->context, rd_s16(body, B_CHAN_ANIM), &busy));
            if (busy == 0) HOST(host->sound_play(host->context, rd_s16(body, B_CHAN_ANIM)));
        }
        if (cols == 0) return EA_ERR_BODY; /* the original divides by it */
        cell = (int16_t)((int32_t)rd_s16(obj, O_ANIM_FRAME) / (int32_t)cols);
        if (rd_s16(body, B_GRID_ROWS) <= cell) {
            wr_16(obj, O_ANIM_FRAME, 0);
            wr_16(obj, O_ANIM_COL, (int16_t)(rd_s16(obj, O_ANIM_COL) + 1));
        }
        if (rd_s16(obj, O_ANIM_COL) < rd_s16(body, B_GRID_REPEAT)) {
            const int32_t frame = rd_s16(obj, O_ANIM_FRAME);
            const int32_t gap = rd_s16(body, B_GRID_GAP);
            wr_32(obj, O_ANIM_SRC, add32(rd_s16(body, B_GRID_X),
                                         mul32(add32(rd_s16(obj, O_CELL_W), gap), frame % (int32_t)cols)));
            wr_32(obj, O_ANIM_SRC + 4, add32(rd_s16(body, B_GRID_Y),
                                             mul32(add32(rd_s16(obj, O_CELL_H), gap), frame / (int32_t)cols)));
            wr_32(obj, O_ANIM_SRC + 8, add32(rd_s32(obj, O_ANIM_SRC), rd_s16(obj, O_CELL_W)));
            wr_32(obj, O_ANIM_SRC + 12, add32(rd_s32(obj, O_ANIM_SRC + 4), rd_s16(obj, O_CELL_H)));
            wr_16(obj, O_ANIM_FRAME, (int16_t)(rd_s16(obj, O_ANIM_FRAME) + 1));
            wr_32(obj, O_STATE, EA_STATE_WAIT);
            wr_32(obj, O_ANIM_ON, 1);
            return EA_OK;
        }
        wr_16(obj, O_ANIM_COL, 0);
        wr_32(obj, O_ANIM_REST, 1);
        wr_32(obj, O_ANIM_ON, 0);
        wr_32(obj, O_STATE, EA_STATE_IDLE);
        HOST(host->sound_stop(host->context, B_SND_ANIM, body + B_SND_ANIM));
        check_solved(obj, body);
        if (obj[O_DONE] != 0) return EA_OK;
        HOST(host->sound_prepare(host->context, B_SND_DONE_REC, body + B_SND_DONE_REC));
        HOST(host->sound_play(host->context, rd_s16(body, B_CHAN_DONE)));
        wr_32(obj, O_DEADLINE2, (int32_t)(now(host) + 800u));
        wr_32(obj, O_STATE, EA_STATE_WAIT);
        wr_32(obj, O_FLAG_2F, 1);
        return EA_OK;
    }
    case EA_STATE_WAIT:
        if (now(host) < (uint32_t)rd_s32(obj, O_DEADLINE2)) return EA_OK;
        if (rd_s32(obj, O_FLAG_2F) != 0) {
            wr_32(obj, O_STATE, EA_STATE_IDLE);
            wr_32(obj, O_FLAG_2F, 0);
            return EA_OK;
        }
        wr_32(obj, O_DEADLINE2, (int32_t)(now(host) + 100u));
        wr_32(obj, O_STATE, EA_STATE_ANIM_STEP);
        return EA_OK;
    case EA_STATE_WIN_SOUND: {
        int32_t busy = 0;
        HOST(host->sound_busy(host->context, rd_s16(body, B_CHAN_WIN), &busy));
        if (busy != 0) return EA_OK;
        HOST(host->sound_stop(host->context, B_SND_WIN, body + B_SND_WIN));
        *row_phase = 2u;
        return EA_OK;
    }
    case EA_STATE_DONE: {
        int32_t enabled = 0;
        if (no_sound(body + B_SND_WIN)) {
            *row_phase = 2u;
            return EA_OK;
        }
        HOST(host->sound_prepare(host->context, B_SND_WIN, body + B_SND_WIN));
        HOST(host->sound_play(host->context, rd_s16(body, B_CHAN_WIN)));
        HOST(host->captions_enabled(host->context, &enabled));
        if (enabled != 0) {
            const char *found = NULL;
            if (body[B_KEY_WIN] != 0) {
                const char *t = NULL;
                HOST(host->autotext_lookup(host->context, (const char *)body + B_KEY_WIN, &t));
                if (t != NULL && strlen(t) < 0x9c41u) {
                    int rc = show_caption(host, t);
                    if (rc != EA_OK) return rc;
                    found = t;
                }
            }
            if (found == NULL && body[B_TEXT_WIN] != 0) {
                int rc = show_caption(host, (const char *)body + B_TEXT_WIN);
                if (rc != EA_OK) return rc;
            }
        }
        wr_32(obj, O_STATE, EA_STATE_WIN_SOUND);
        return EA_OK;
    }
    default:
        return EA_OK;
    }
}

int ea_step(EaObject *object, uint8_t *body, size_t body_length, int16_t row, uint32_t phase, EaWorld *world,
            const EaHost *host, EaResult *result, const char **failure)
{
    const char *why = NULL;
    uint32_t row_phase = phase;
    int rc;
    if (failure != NULL) *failure = NULL;
    if (object == NULL || body == NULL || world == NULL || result == NULL || !host_complete(host)) {
        if (failure != NULL) *failure = "0xea-argument";
        return EA_ERR_ARGUMENT;
    }
    memset(result, 0, sizeof(*result));
    result->phase_after = phase;
    if (ea_validate_body(body, body_length, &why) != EA_OK) {
        if (failure != NULL) *failure = why;
        return EA_ERR_BODY;
    }
    if (phase == 0u) {
        if (row < 0) {
            if (failure != NULL) *failure = "0xea-row";
            return EA_ERR_ARGUMENT;
        }
        rc = phase0(object->b, body, row, world, host);
        if (rc == EA_OK) {
            row_phase = 1u;
            result->initialized = 1u;
        }
    } else if (phase == 1u) {
        if (!ea_object_active(object) || ea_object_row(object) != row) {
            if (failure != NULL) *failure = "0xea-phase-1-without-init";
            return EA_ERR_UNSUPPORTED;
        }
        rc = phase1(object->b, body, &row_phase, host);
    } else if (phase == 2u) {
        if (!ea_object_active(object) || ea_object_row(object) != row) {
            if (failure != NULL) *failure = "0xea-phase-2-without-init";
            return EA_ERR_UNSUPPORTED;
        }
        {
            const uint8_t *blk = object->b[O_EXIT] == 0 ? (object->b[O_DONE] != 0 ? body + B_BLOCK_WIN : NULL)
                                                         : body + B_BLOCK_EXIT;
            if (blk != NULL) {
                const int16_t flag = rd_s16(blk, SB_FLAG);
                if (flag != EA_NO_FLAG && host->event_flag_invalid(host->context, flag) != 0) {
                    if (failure != NULL) *failure = "0xea-event-flag-index";
                    return EA_ERR_BOUNDS;
                }
            }
        }
        rc = phase2(object->b, body, row, world, host);
        if (rc == EA_OK) {
            result->completed = 1u;
            row_phase = 0u; /* 0x42ba3a stores phase 0 */
            rc = ea_cleanup(object, host);
        }
    } else {
        rc = EA_OK; /* 0x4867bd: any other phase falls out of the switch */
    }
    if (rc != EA_OK && failure != NULL && *failure == NULL) *failure = rc == EA_ERR_BOUNDS ? "0xea-bounds" : "0xea-host";
    if (rc == EA_OK && phase == 1u) {
        /* row_phase is written by the states that ask for phase 2 */
    }
    result->phase_after = row_phase;
    return rc;
}

/* 0x4854fb: the cursor and candidate writes of the pointer receiver. */
static void write_candidate(const uint8_t *body, int32_t code, EaPointerResult *out)
{
    out->wrote_cursor = 1;
    out->candidate = code;
    if (code == EA_CANDIDATE_ROTATE) {
        out->cursor = 0x14;
        out->cursor_flag = 0;
        out->cursor_record = 0x5b188cu;
    } else if (code == EA_CANDIDATE_ANIM) {
        out->cursor = 0x16;
        out->cursor_flag = 1;
        out->cursor_record = 0x5b18dcu;
    } else {
        out->cursor = rd_s16(body, code == EA_CANDIDATE_EXIT ? B_CURSOR_EXIT : B_CURSOR_PICK);
        out->cursor_flag = 1;
        out->cursor_record = (uint32_t)(0x5b161c + (int64_t)out->cursor * 0x20);
    }
}

/* 0x484d87: advance the moving rectangle to the pointer rectangle's centre. */
static int follow_pointer(uint8_t *obj, const EaHost *host)
{
    wr_32(obj, O_PREV + 4, rd_s32(obj, O_MOVE + 4));
    wr_32(obj, O_PREV + 12, rd_s32(obj, O_MOVE + 12));
    wr_32(obj, O_PREV, rd_s32(obj, O_MOVE));
    wr_32(obj, O_PREV + 8, rd_s32(obj, O_MOVE + 8));
    wr_32(obj, O_PREV_T + 4, rd_s32(obj, O_MOVE_T + 4));
    wr_32(obj, O_PREV_T + 12, rd_s32(obj, O_MOVE_T + 12));
    wr_32(obj, O_PREV_T, rd_s32(obj, O_MOVE_T));
    wr_32(obj, O_PREV_T + 8, rd_s32(obj, O_MOVE_T + 8));
    wr_32(obj, O_MOVE + 4,
          sub32(add32(sub32(rd_s32(obj, O_PTR_RECT + 12), rd_s32(obj, O_PTR_RECT + 4)) / 2, rd_s32(obj, O_PTR_RECT + 4)),
                (int32_t)rd_s16(obj, O_PH) / 2));
    wr_32(obj, O_MOVE,
          sub32(add32(sub32(rd_s32(obj, O_PTR_RECT + 8), rd_s32(obj, O_PTR_RECT)) / 2, rd_s32(obj, O_PTR_RECT)),
                (int32_t)rd_s16(obj, O_PW) / 2));
    wr_32(obj, O_MOVE + 12, add32(rd_s32(obj, O_MOVE + 4), rd_s16(obj, O_PH)));
    wr_32(obj, O_MOVE + 8, add32(rd_s32(obj, O_MOVE), rd_s16(obj, O_PW)));
    HOST(clamp_rect(obj, O_MOVE, host));
    return translate(obj, O_MOVE, O_MOVE_T, host);
}

int ea_pointer_move(EaObject *object, uint8_t *body, size_t body_length, int16_t x, int16_t y, const int32_t rect[4],
                    const EaHost *host, EaPointerResult *out)
{
    uint8_t *obj;
    int16_t n;
    if (object == NULL || body == NULL || out == NULL || rect == NULL || !host_complete(host) ||
        ea_validate_body(body, body_length, NULL) != EA_OK)
        return EA_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = CANDIDATE_NONE;
    obj = object->b;
    if (rd_s32(obj, O_ACTIVE) == 0) return EA_OK;
    n = rd_s16(body, B_COUNT);
    {
        const int16_t cur = rd_s16(obj, O_HAND);
        wr_32(obj, O_PTR_RECT + 4, rect[1]);
        wr_32(obj, O_PTR_RECT + 12, rect[3]);
        wr_32(obj, O_PTR_RECT, rect[0]);
        wr_32(obj, O_PTR_RECT + 8, rect[2]);
        if (rd_s32(obj, O_DRAG) != 0) {
            int ok = 1;
            int rc;
            if (cur < 0 || cur >= n) return EA_ERR_BOUNDS; /* no piece in hand: the original reads outside the tables */
            rc = follow_pointer(obj, host);
            if (rc != EA_OK) return rc;
            if (rd_s32(body, B_DROP_AREA + 8) != rd_s32(body, B_DROP_AREA) &&
                ((int32_t)y < rd_s32(body, B_DROP_AREA + 4) || rd_s32(body, B_DROP_AREA + 12) < (int32_t)y ||
                 (int32_t)x < rd_s32(body, B_DROP_AREA) || rd_s32(body, B_DROP_AREA + 8) < (int32_t)x))
                ok = 0;
            if (ok) {
                const size_t bp = bpiece_off(cur);
                if (body[B_TOL_ON] == 0) wr_16(body, B_TOL, 0);
                if (obj[piece_off(cur) + P_ORIENT] == 0 &&
                    sub32(rd_s32(body, bp + BP_RECT_C + 4), (int32_t)rd_s16(body, B_TOL)) <= rd_s32(obj, O_PREV + 4) &&
                    rd_s32(obj, O_PREV + 12) <= add32(rd_s32(body, bp + BP_RECT_C + 12), (int32_t)rd_s16(body, B_TOL)) &&
                    sub32(rd_s32(body, bp + BP_RECT_C), (int32_t)rd_s16(body, B_TOL)) <= rd_s32(obj, O_PREV) &&
                    rd_s32(obj, O_PREV + 8) <= add32(rd_s32(body, bp + BP_RECT_C + 8), (int32_t)rd_s16(body, B_TOL)))
                    write_candidate(body, EA_CANDIDATE_DROP_GOOD, out);
                else
                    write_candidate(body, EA_CANDIDATE_DROP_BAD, out);
                out->hit = 1;
                return EA_OK;
            }
            return EA_OK;
        }
        for (size_t off = O_LIST_UNPLACED; off < O_LIST_UNPLACED + 40u; off += 4u) wr_32(obj, off, 0);
        wr_16(obj, O_COUNT_UNPLACED, 0);
        wr_16(obj, O_COUNT_PLACED, 0);
        for (int16_t c = 0; c < n; ++c) {
            const size_t Q = piece_off(c);
            const int32_t ql = rd_s32(obj, Q + 2), qt = rd_s32(obj, Q + 6), qr = rd_s32(obj, Q + 10), qb = rd_s32(obj, Q + 14);
            if (body[B_ROT_ALLOWED] == 0 || body[B_ROT_LOCKED] == 0 || (int32_t)y < qt ||
                add32(qt, rd_s16(body, B_ZONE_H)) < (int32_t)y || (int32_t)x < ql ||
                add32(ql, rd_s16(body, B_ZONE_W)) < (int32_t)x) {
                if (obj[Q + P_PLACED] == 0 && qt <= (int32_t)y && (int32_t)y <= qb && ql <= (int32_t)x &&
                    (int32_t)x <= qr) {
                    const int16_t cnt = rd_s16(obj, O_COUNT_UNPLACED);
                    if (cnt < 0 || cnt >= EA_MAX_PIECES) return EA_ERR_BOUNDS;
                    wr_16(obj, O_LIST_UNPLACED + (size_t)cnt * 2u, c);
                    wr_16(obj, O_COUNT_UNPLACED, (int16_t)(cnt + 1));
                }
            } else {
                const int16_t cnt = rd_s16(obj, O_COUNT_PLACED);
                if (cnt < 0 || cnt >= EA_MAX_PIECES) return EA_ERR_BOUNDS;
                wr_16(obj, O_LIST_PLACED + (size_t)cnt * 2u, c);
                wr_16(obj, O_COUNT_PLACED, (int16_t)(cnt + 1));
            }
        }
        if (rd_s16(obj, O_COUNT_PLACED) != 0) {
            write_candidate(body, EA_CANDIDATE_ROTATE, out);
            out->hit = 1;
            return EA_OK;
        }
        if (rd_s16(obj, O_COUNT_UNPLACED) != 0) {
            write_candidate(body, EA_CANDIDATE_PICK, out);
            out->hit = 1;
            return EA_OK;
        }
        if (rd_s32(obj, O_EXIT_AREA) != 0 && rd_s32(body, B_EXIT_AREA + 4) <= (int32_t)y &&
            (int32_t)y <= rd_s32(body, B_EXIT_AREA + 12) && rd_s32(body, B_EXIT_AREA) <= (int32_t)x &&
            (int32_t)x < rd_s32(body, B_EXIT_AREA + 8)) {
            write_candidate(body, EA_CANDIDATE_ANIM, out);
            out->hit = 1;
            return EA_OK;
        }
        if (rd_s32(body, B_EXIT_RECT + 4) <= (int32_t)y && (int32_t)y <= rd_s32(body, B_EXIT_RECT + 12) &&
            rd_s32(body, B_EXIT_RECT) <= (int32_t)x && (int32_t)x <= rd_s32(body, B_EXIT_RECT + 8)) {
            write_candidate(body, EA_CANDIDATE_EXIT, out);
            out->hit = 1;
        }
    }
    return EA_OK;
}

/* The piece in hand is set by a click; the click paths refuse an index outside the table before any effect. */
static int hand_valid(const uint8_t *obj, const uint8_t *body)
{
    const int16_t cur = rd_s16(obj, O_HAND);
    return cur >= 0 && cur < rd_s16(body, B_COUNT);
}

int ea_click(EaObject *object, uint8_t *body, size_t body_length, uint32_t row_phase, int32_t candidate,
             const EaHost *host, uint32_t *new_phase)
{
    uint8_t *obj;
    if (object == NULL || body == NULL || new_phase == NULL || !host_complete(host) ||
        ea_validate_body(body, body_length, NULL) != EA_OK)
        return EA_ERR_ARGUMENT;
    obj = object->b;
    *new_phase = row_phase;
    if (!(rd_s32(obj, O_ACTIVE) != 0 && obj[O_DONE] == 0 && rd_s32(obj, O_STATE) == 0 && row_phase == 1u)) return EA_OK;
    if (candidate == EA_CANDIDATE_EXIT) {
        obj[O_EXIT] = 1;
        *new_phase = 2u;
    } else if (candidate == EA_CANDIDATE_ANIM) {
        wr_32(obj, O_CLICK_ANIM, 1);
    } else if (candidate == EA_CANDIDATE_ROTATE) {
        const int16_t s = top_piece(obj, O_LIST_PLACED, O_COUNT_PLACED);
        if (s != -1) {
            if (s < 0 || s >= rd_s16(body, B_COUNT)) return EA_ERR_BOUNDS;
            HOST(rotate_piece(obj, s, host));
            HOST(piece_sound(obj, body, B_SND_ROT, 0, 0, host));
            wr_32(obj, O_DRAG, 1);
            wr_16(obj, O_HAND, s);
            piece_size(obj, s);
        }
    } else if (rd_s32(obj, O_DRAG) == 0 && candidate == EA_CANDIDATE_PICK) {
        int16_t s;
        HOST(piece_sound(obj, body, B_SND_PICK, 1, 0, host));
        s = top_piece(obj, O_LIST_UNPLACED, O_COUNT_UNPLACED);
        if (s != -1) {
            const size_t P = piece_off(s);
            if (s < 0 || s >= rd_s16(body, B_COUNT)) return EA_ERR_BOUNDS;
            wr_16(obj, O_HAND, s);
            wr_32(obj, O_LIFT, 1);
            copy_rect(obj, O_SAVED, obj, P + P_RECT);
            if (rect_valid(body, bpiece_off(s) + BP_RECT_B)) copy_rect(obj, P + P_RECT, body, bpiece_off(s) + BP_RECT_B);
            piece_size(obj, s);
            wr_32(obj, O_DRAG, 1);
        }
    } else if (candidate == EA_CANDIDATE_DROP_GOOD || candidate == EA_CANDIDATE_DROP_BAD) {
        int16_t cur;
        size_t P, BP;
        if (!hand_valid(obj, body)) return EA_ERR_BOUNDS;
        cur = rd_s16(obj, O_HAND);
        P = piece_off(cur);
        BP = bpiece_off(cur);
        {
            const int16_t placed = rd_s16(obj, O_PLACED_N);
            if (candidate == EA_CANDIDATE_DROP_GOOD && body[B_ORDERED] != 0 &&
                (placed < 0 || (size_t)B_ORDER + (size_t)placed * 2u + 2u > EA_BODY_BYTES))
                return EA_ERR_BOUNDS;
        }
        HOST(piece_sound(obj, body, B_SND_DROP, 0, 1, host));
        wr_32(obj, O_DRAG, 0);
        wr_32(obj, O_DROP, 1);
        if (candidate == EA_CANDIDATE_DROP_GOOD &&
            (body[B_ORDERED] == 0 ||
             (body[B_ORDERED] != 0 &&
              (int32_t)rd_s16(body, B_ORDER + (size_t)rd_s16(obj, O_PLACED_N) * 2u) == (int32_t)cur + 1))) {
            copy_rect(obj, P + P_RECT, body, BP + BP_RECT_C);
            HOST(translate(obj, P + P_RECT, P + P_RECT2, host));
            obj[P + P_PLACED] = 1;
            obj[P + P_FLAG84] = 1;
            wr_32(obj, O_PLACED_OK, 1);
            wr_16(obj, O_PLACED_N, (int16_t)(rd_s16(obj, O_PLACED_N) + 1));
        } else {
            if (body[B_FLAG23] == 0) {
                copy_rect(obj, P + P_RECT, obj, O_PREV);
                copy_rect(obj, P + P_RECT2, obj, O_PREV_T);
                obj[P + P_FLAG84] = 1;
            } else {
                copy_rect(obj, P + P_RECT, body, BP + BP_RECT_D);
                HOST(translate(obj, P + P_RECT, P + P_RECT2, host));
                obj[P + P_ORIENT] = body[BP + BP_ORIENT];
                obj[P + P_FLAG84] = 0;
            }
            wr_32(obj, O_PLACED_OK, 0);
        }
        set_layer(obj, body, cur);
        wr_16(obj, O_HAND, -1);
    }
    return EA_OK;
}

int ea_rotate_key(EaObject *object, uint8_t *body, size_t body_length, uint32_t row_phase, const EaHost *host)
{
    uint8_t *obj;
    int16_t s;
    if (object == NULL || body == NULL || !host_complete(host) || ea_validate_body(body, body_length, NULL) != EA_OK)
        return EA_ERR_ARGUMENT;
    obj = object->b;
    if (!(rd_s32(obj, O_ACTIVE) != 0 && body[B_ROT_ALLOWED] != 0 && body[B_ROT_LOCKED] == 0 && obj[O_DONE] == 0 &&
          rd_s32(obj, O_STATE) == 0 && row_phase == 1u && rd_s16(obj, O_COUNT_UNPLACED) != 0))
        return EA_OK;
    if (rd_s32(obj, O_DRAG) == 0) {
        s = top_piece(obj, O_LIST_UNPLACED, O_COUNT_UNPLACED);
        if (s == -1) return EA_OK;
        if (s < 0 || s >= rd_s16(body, B_COUNT)) return EA_ERR_BOUNDS;
        HOST(rotate_piece(obj, s, host));
        wr_32(obj, O_DRAG, 1);
        wr_16(obj, O_HAND, s);
        piece_size(obj, s);
    } else {
        s = rd_s16(obj, O_HAND);
        if (!hand_valid(obj, body)) return EA_ERR_BOUNDS;
        HOST(rotate_piece(obj, s, host));
        piece_size(obj, s);
    }
    HOST(piece_sound(obj, body, B_SND_ROT, 0, 0, host));
    set_layer(obj, body, s);
    return EA_OK;
}

int ea_invalidate(EaObject *object, const EaHost *host)
{
    if (object == NULL || host == NULL || host->mark_dirty == NULL) return EA_ERR_ARGUMENT;
    if (rd_s32(object->b, O_ACTIVE) != 0 && rd_s16(object->b, O_SLOT) != -1)
        HOST(host->mark_dirty(host->context, rd_s16(object->b, O_SLOT)));
    return EA_OK;
}

static void plan_blit(EaRenderPlan *plan, uint8_t kind, uint8_t src_kind, uint32_t surface, const int32_t src[4],
                      const int32_t dst[4])
{
    EaBlit *b = &plan->blit[plan->count++];
    b->kind = kind;
    b->src_kind = src_kind;
    b->src_surface = surface;
    memcpy(b->src, src, sizeof b->src);
    memcpy(b->dst, dst, sizeof b->dst);
}

static void rect_at(const uint8_t *b, size_t off, int32_t out[4])
{
    for (int k = 0; k < 4; ++k) out[k] = rd_s32(b, off + (size_t)k * 4u);
}

static void xlate(const EaView *v, const int32_t in[4], int32_t out[4])
{
    out[1] = add32(in[1], v->origin_y);
    out[3] = add32(in[3], v->origin_y);
    out[0] = add32(in[0], v->origin_x);
    out[2] = add32(in[2], v->origin_x);
}

int ea_render_plan(EaObject *object, uint8_t *body, size_t body_length, const EaHost *host, EaRenderPlan *plan)
{
    uint8_t *obj;
    EaView v;
    int32_t src[4], dst[4], moved[4];
    int16_t n, want, layer, drawn;
    if (object == NULL || body == NULL || plan == NULL || !host_complete(host) ||
        ea_validate_body(body, body_length, NULL) != EA_OK)
        return EA_ERR_ARGUMENT;
    memset(plan, 0, sizeof(*plan));
    obj = object->b;
    if (rd_s16(obj, O_SLOT) == EA_NO_SLOT) return EA_OK;
    if (host->view(host->context, &v) != 0) return EA_ERR_HOST;
    plan->valid = 1;
    n = rd_s16(body, B_COUNT);
    if (rd_s32(obj, O_DROP) != 0 || rd_s32(obj, O_DRAG) != 0) {
        rect_at(obj, O_PREV, src);
        rect_at(obj, O_PREV_T, dst);
        plan_blit(plan, 0, 0, 0, src, dst);
        wr_32(obj, O_DROP, 0);
    }
    if (rd_s32(obj, O_LIFT) != 0) {
        rect_at(obj, O_SAVED, src);
        xlate(&v, src, moved);
        plan_blit(plan, 0, 0, 0, src, moved);
        wr_32(obj, O_LIFT, 0);
    }
    want = n;
    if (rd_s32(obj, O_DRAG) != 0) {
        want = (int16_t)(n - 1);
        if (!hand_valid(obj, body)) return EA_ERR_BOUNDS;
    }
    layer = 0;
    drawn = 0;
    for (;;) {
        if (drawn == want) {
            if (rd_s32(obj, O_DRAG) != 0) {
                const size_t P = piece_off(rd_s16(obj, O_HAND));
                const size_t ent = P + P_ENT + (size_t)obj[P + P_ORIENT] * ENT_STRIDE;
                rect_at(obj, ent + ENT_RECT, src);
                rect_at(obj, O_MOVE_T, dst);
                plan_blit(plan, 1, 3, (uint32_t)rd_s32(obj, ent + ENT_SURF), src, dst);
            }
            if (rd_s32(obj, O_ANIM_ON) == 0) {
                if (rd_s32(obj, O_ANIM_REST) != 0) {
                    rect_at(body, B_ANIM_AREA, src);
                    xlate(&v, src, moved);
                    plan_blit(plan, 0, 0, 0, src, moved);
                    wr_32(obj, O_ANIM_REST, 0);
                }
            } else {
                rect_at(body, B_ANIM_AREA, src);
                xlate(&v, src, moved);
                rect_at(obj, O_ANIM_SRC, src);
                plan_blit(plan, 0, 1, (uint32_t)rd_s32(obj, O_MULTI), src, moved);
            }
            return EA_OK;
        }
        if (layer >= 0x4000) return EA_ERR_BOUNDS;
        for (int16_t c = 0; c < n; ++c) {
            const size_t P = piece_off(c);
            if (rd_s32(obj, O_DRAG) == 0 || rd_s16(obj, O_HAND) != c) {
                if (rd_s16(obj, P + P_Z) == layer) {
                    if (plan->count >= EA_MAX_BLITS - 4) return EA_ERR_BOUNDS;
                    rect_at(obj, P + P_RECT2, dst);
                    if (obj[P + P_FLAG84] == 0) {
                        rect_at(body, bpiece_off(c) + BP_RECT_A, src);
                        plan_blit(plan, 1, 2, (uint32_t)rd_s32(obj, O_SRC), src, dst);
                    } else {
                        const size_t ent = P + P_ENT + (size_t)obj[P + P_ORIENT] * ENT_STRIDE;
                        rect_at(obj, ent + ENT_RECT, src);
                        plan_blit(plan, 1, 3, (uint32_t)rd_s32(obj, ent + ENT_SURF), src, dst);
                    }
                    ++drawn;
                    if (drawn == want) break;
                }
            }
        }
        ++layer;
    }
}
