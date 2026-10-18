#include "action_family_eb_runtime.h"

#include <string.h>

/* Object offsets (see the header). */
enum {
    O_SLOT = 0x1c,
    O_ROW = 0x1e,
    O_ENTRIES = 0x20,
    O_COUNTS = 0x7a0,
    O_PIECES = 0x7b4,
    O_DRAG = 0x1344,
    O_DROP = 0x1348,
    O_LIFT = 0x134c,
    O_HAND = 0x1350,
    O_PREV = 0x1352,
    O_MOVE = 0x1362,
    O_PREV_T = 0x1372,
    O_MOVE_T = 0x1382,
    O_SAVED = 0x1392,
    O_COUNT = 0x13a2,
    O_SRC = 0x13a4,
    O_MULTI = 0x13a8,
    O_ANIM = 0x13ac,
    O_HAS_MULTI = 0x13b0,
    O_MULTI_HAND = 0x13b1,
    O_ANIM_ON = 0x13b2,
    O_ANIM_REST = 0x13b3,
    O_HAS_ANIM = 0x13b4,
    O_ANIM_SRC = 0x13b5,
    O_ACTIVE = 0x13c5,
    O_EXIT = 0x13c9,
    O_STATE = 0x13ca,
    O_DONE = 0x13ce,
    O_PTR_RECT = 0x13cf,
    O_HIT = 0x13df,
    O_HW = 0x13e3,
    O_HH = 0x13e5,
    O_DEADLINE = 0x13e7,
    O_DEADLINE2 = 0x13eb,
    O_LIST1 = 0x13ef,
    O_COUNT1 = 0x1417,
    O_LIST2 = 0x1419,
    O_COUNT2 = 0x1441,
    O_TOTAL = 0x1443,
    O_ANIM_ROW = 0x1445,
    O_ANIM_FRAME = 0x1447,
    O_CELL_W = 0x1449,
    O_CELL_H = 0x144b
};

/* Piece instance offsets and entry offsets. */
enum {
    P_Z = 0,
    P_RECT = 2,
    P_RECT2 = 0x12,
    P_ORIENT = 0x22,
    P_TYPE = 0x23,
    P_STAMP = 0x24,
    ENT_STRIDE = 0x18,
    ENT_TYPE_STRIDE = 0x60,
    ENT_SURF = 0,
    ENT_RECT = 4,
    ENT_W = 0x14,
    ENT_H = 0x16
};

/* Body offsets. */
enum {
    B_NAME = 0x00,
    B_MULTI_NAME = 0x21,
    B_PERSIST = 0x42,
    B_NTYPES = 0x43,
    B_TARGET = 0x45,
    B_WIN_SOUND = 0x47,
    B_ROT_ALLOWED = 0x48,
    B_ROT_LOCKED = 0x49,
    B_ZONE_H = 0x4a,
    B_ZONE_W = 0x4c,
    B_AREA = 0x4e,
    B_MODE = 0x5e,
    B_OVERLAP = 0x5f,
    B_ANIM_NAME = 0x60,
    B_ANIM_AREA = 0x81,
    B_GRID_ROWS = 0x91,
    B_GRID_COLS = 0x93,
    B_GRID_GAP = 0x95,
    B_GRID_REPEAT = 0x97,
    B_TYPES = 0x99,
    BT_STRIDE = 0x53,
    BT_A = 0x00,
    BT_B = 0x10,
    BT_C = 0x20,
    BT_D = 0x30,
    BT_E = 0x40,
    BT_SPAWN = 0x50,
    BT_REQUIRED = 0x51,
    BT_FORBIDDEN = 0x52,
    B_SND_ROT = 0x715,
    B_CHAN_ROT = 0x736,
    B_SND_PICK = 0x746,
    B_CHAN_PICK = 0x767,
    B_SND_GOOD = 0x777,
    B_CHAN_GOOD = 0x798,
    B_SND_BAD = 0x7a8,
    B_CHAN_BAD = 0x7c9,
    B_KEY_BAD = 0x7d9,
    B_TEXT_BAD = 0x7fa,
    B_CURSOR_PICK = 0x8c2,
    B_CURSOR_EXIT_A = 0x8c4,
    B_CURSOR_EXIT_B = 0x8c6,
    B_BLOCK_WIN = 0x8c8,
    B_FLAG_WIN = 0x8de,
    B_VALUE_WIN = 0x8e0,
    B_SND_WIN = 0x8e1,
    B_CHAN_WIN = 0x902,
    B_KEY_WIN = 0x912,
    B_TEXT_WIN = 0x933,
    B_BLOCK_EXIT = 0x9fb,
    B_FLAG_EXIT = 0xa11,
    B_VALUE_EXIT = 0xa13,
    B_BTN_A = 0xa14,
    B_BTN_B = 0xa24
};

/* Scene block offsets. */
enum { SB_SCENE = 0, SB_W1 = 2, SB_W2 = 4, SB_W3 = 6, SB_D1 = 8, SB_D2 = 12, SB_D3 = 16, SB_START = 20 };

#define TAG_PIECE_SRC "DF Piece Source Surface"
#define TAG_MULTI "Multi Piece Source Surface"
#define TAG_ANIM "Multi Anim Surface"
#define TAG_PIECE "pDFSurface for Multibuild Puzzle Piece"
#define LABEL_SLOT "MULTIBUILD PUZZLE OVERLAYS"
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
    return O_PIECES + (size_t)(int32_t)i * EB_PIECE_STRIDE;
}

static size_t type_off(int16_t t)
{
    return B_TYPES + (size_t)(int32_t)t * BT_STRIDE;
}

static size_t entry_off(int16_t t, unsigned k)
{
    return O_ENTRIES + (size_t)(int32_t)t * ENT_TYPE_STRIDE + (size_t)k * ENT_STRIDE;
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

#define HOST(call) do { if ((call) != 0) { return EB_ERR_HOST; } } while (0)
#define CHECK(call) do { int rc_ = (call); if (rc_ != EB_OK) { return rc_; } } while (0)

void eb_object_reset(EbObject *object)
{
    memset(object->b, 0, sizeof(object->b));
    wr_16(object->b, O_ROW, -1);
    wr_16(object->b, O_SLOT, -1);
}

void eb_world_reset(EbWorld *world)
{
    world->saved_flag = 0;
    world->saved_scene = EB_NO_SCENE;
    memset(world->saved_counts, 0, sizeof world->saved_counts);
    memset(world->saved_pieces, 0, sizeof world->saved_pieces);
    /* 0x47e3f7 writes the flag, the scene word, the 20 counters (0x5a0563..0x5a0576) and the 80 instances only: the count
     * (0x5a1107) and the total (0x5a1109) words keep their values (verified against the original by the RT-56 oracle). */
}

int16_t eb_object_slot(const EbObject *object) { return rd_s16(object->b, O_SLOT); }
int16_t eb_object_row(const EbObject *object) { return rd_s16(object->b, O_ROW); }
int eb_object_active(const EbObject *object) { return rd_s32(object->b, O_ACTIVE) != 0; }
uint32_t eb_object_state(const EbObject *object) { return (uint32_t)rd_s32(object->b, O_STATE); }

/* 0x47e99e: nonzero when the rectangle has a nonzero width and height edge pair. */
static int rect_valid(const uint8_t *b, size_t off)
{
    return !(rd_s32(b, off + 12) == rd_s32(b, off + 4) || rd_s32(b, off + 8) == rd_s32(b, off));
}

static int field_terminated(const uint8_t *body, size_t off, size_t span)
{
    return memchr(body + off, 0, span) != NULL;
}

int eb_validate_body(const uint8_t *body, size_t length, const char **failure)
{
    const char *why = NULL;
    int16_t n;
    static const struct { size_t off; size_t span; } fields[] = {
        {B_NAME, 0x21}, {B_MULTI_NAME, 0x21}, {B_ANIM_NAME, 0x21}, {B_SND_ROT, 0x21}, {B_SND_PICK, 0x21},
        {B_SND_GOOD, 0x21}, {B_SND_BAD, 0x21}, {B_KEY_BAD, 0x21}, {B_TEXT_BAD, 200}, {B_SND_WIN, 0x21},
        {B_KEY_WIN, 0x21}, {B_TEXT_WIN, 200}};
    if (body == NULL || length != EB_BODY_BYTES) {
        why = "0xeb-body-length";
    } else if ((n = rd_s16(body, B_NTYPES)) < 0 || n > EB_MAX_TYPES) {
        why = "0xeb-type-count";
    } else if (rd_s32(body, B_ANIM_AREA + 12) != rd_s32(body, B_ANIM_AREA + 4) && rd_s16(body, B_GRID_COLS) == 0) {
        why = "0xeb-grid-columns-zero";
    } else {
        for (size_t k = 0; k < sizeof fields / sizeof fields[0] && why == NULL; ++k)
            if (!field_terminated(body, fields[k].off, fields[k].span)) why = "0xeb-unterminated-field";
        for (int16_t t = 0; t < n && why == NULL; ++t) {
            const size_t p = type_off(t);
            const size_t r = rect_valid(body, p + BT_C) ? p + BT_C : p + BT_B;
            const int32_t w = (int16_t)((int16_t)sub32(rd_s32(body, r + 8), rd_s32(body, r)) + 1);
            const int32_t h = (int16_t)((int16_t)sub32(rd_s32(body, r + 12), rd_s32(body, r + 4)) + 1);
            if (w < 1 || w > 4096 || h < 1 || h > 4096) why = "0xeb-piece-size";
        }
    }
    if (why != NULL) {
        if (failure != NULL) *failure = why;
        return EB_ERR_BODY;
    }
    return EB_OK;
}

static int host_complete(const EbHost *h)
{
    return h != NULL && h->view != NULL && h->alloc_slot != NULL && h->register_slot != NULL &&
           h->release_slot != NULL && h->mark_dirty != NULL && h->load_surface != NULL && h->create_surface != NULL &&
           h->blit != NULL && h->copy_surface != NULL && h->rotate_surface != NULL && h->release_surface != NULL &&
           h->clear_pending_item != NULL && h->sound_prepare != NULL && h->sound_stop != NULL &&
           h->sound_play != NULL && h->sound_busy != NULL && h->tick != NULL && h->captions_enabled != NULL &&
           h->autotext_lookup != NULL && h->caption_show != NULL && h->event_flag_invalid != NULL &&
           h->transition != NULL && h->store_event_flag != NULL && h->complete != NULL;
}

/* 0x47e52f: rectangle plus the view origin. */
static int translate(uint8_t *obj, size_t from, size_t to, const EbHost *host)
{
    EbView v;
    int32_t src[4];
    HOST(host->view(host->context, &v));
    for (int k = 0; k < 4; ++k) src[k] = rd_s32(obj, from + (size_t)k * 4u);
    wr_32(obj, to + 4, add32(src[1], v.origin_y));
    wr_32(obj, to + 12, add32(src[3], v.origin_y));
    wr_32(obj, to, add32(src[0], v.origin_x));
    wr_32(obj, to + 8, add32(src[2], v.origin_x));
    return EB_OK;
}

static void copy_rect(uint8_t *to, size_t to_off, const uint8_t *from, size_t from_off)
{
    for (int k = 0; k < 4; ++k) wr_32(to, to_off + (size_t)k * 4u, rd_s32(from, from_off + (size_t)k * 4u));
}

/* 0x47f19d: clamp a rectangle into the clip rectangle, keeping its size. */
static int clamp_rect(uint8_t *obj, size_t off, const EbHost *host)
{
    EbView v;
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
    return EB_OK;
}

/* A piece instance index the native code is willing to touch. */
static int instance_valid(const uint8_t *obj, int32_t i)
{
    return i >= 0 && i < EB_MAX_INSTANCES && i < rd_s16(obj, O_COUNT) && obj[piece_off((int16_t)i) + P_TYPE] < EB_MAX_TYPES;
}

/* Every instance below the count has a type byte inside the body's type table (native safety). */
static int instances_sane(const uint8_t *obj)
{
    const int16_t n = rd_s16(obj, O_COUNT);
    if (n < 0 || n > EB_MAX_INSTANCES) return 0;
    for (int16_t j = 0; j < n; ++j)
        if (obj[piece_off(j) + P_TYPE] >= EB_MAX_TYPES) return 0;
    return 1;
}

/* 0x47e582: set up piece instance `index` of type `type`; the type's four surface entries are built when
 * index == type. `forced` is the third argument (1 when a copy is spawned). */
static int piece_init(uint8_t *obj, const uint8_t *body, const EbWorld *world, int16_t index, int16_t type,
                      int forced, const EbHost *host)
{
    const size_t P = piece_off(index);
    const size_t T = type_off(type);
    if (forced != 0 || body[B_PERSIST] == 0 || world->saved_flag == 0 || (int32_t)world->saved_scene != world->scene_5bb57b) {
        wr_16(obj, P + P_Z, 0);
        obj[P + P_TYPE] = (uint8_t)type;
        obj[P + P_STAMP] = 0;
        copy_rect(obj, P + P_RECT, body, T + BT_B);
        HOST(translate(obj, P + P_RECT, P + P_RECT2, host));
    }
    if (index == type) {
        const size_t E0 = entry_off(type, 0);
        int16_t w, h;
        uint32_t surf = 0;
        int32_t src_rect[4], dst_rect[4];
        if (!rect_valid(body, T + BT_C)) {
            w = (int16_t)((int16_t)sub32(rd_s32(body, T + BT_B + 8), rd_s32(body, T + BT_B)) + 1);
            h = (int16_t)((int16_t)sub32(rd_s32(body, T + BT_B + 12), rd_s32(body, T + BT_B + 4)) + 1);
            for (int k = 0; k < 4; ++k) src_rect[k] = rd_s32(body, T + BT_A + (size_t)k * 4u);
        } else {
            w = (int16_t)((int16_t)sub32(rd_s32(body, T + BT_C + 8), rd_s32(body, T + BT_C)) + 1);
            h = (int16_t)((int16_t)sub32(rd_s32(body, T + BT_C + 12), rd_s32(body, T + BT_C + 4)) + 1);
            for (int k = 0; k < 4; ++k) src_rect[k] = rd_s32(body, T + BT_C + (size_t)k * 4u);
        }
        wr_16(obj, E0 + ENT_W, w);
        wr_16(obj, E0 + ENT_H, h);
        HOST(host->create_surface(host->context, w, h, TAG_PIECE, &surf));
        wr_32(obj, E0 + ENT_SURF, (int32_t)surf);
        wr_32(obj, E0 + ENT_RECT + 4, 0);
        wr_32(obj, E0 + ENT_RECT, 0);
        wr_32(obj, E0 + ENT_RECT + 12, add32(sub32(rd_s32(obj, E0 + ENT_RECT + 4), 1), h));
        wr_32(obj, E0 + ENT_RECT + 8, add32(sub32(rd_s32(obj, E0 + ENT_RECT), 1), w));
        for (int k = 0; k < 4; ++k) dst_rect[k] = rd_s32(obj, E0 + ENT_RECT + (size_t)k * 4u);
        HOST(host->blit(host->context, (uint32_t)rd_s32(obj, O_SRC), surf, src_rect, dst_rect));
        if (body[B_ROT_ALLOWED] != 0 || obj[P + P_ORIENT] != 0) {
            for (unsigned k = 1; k < 4; ++k) {
                const size_t prev = entry_off(type, k - 1);
                const size_t ent = entry_off(type, k);
                uint32_t s2 = 0;
                int16_t rw = 0, rh = 0;
                HOST(host->create_surface(host->context, w, h, TAG_PIECE, &s2));
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
            }
        }
    }
    return EB_OK;
}

/* 0x47e8fe / 0x47e9d3: the piece of the list with the greatest z (the first one on a tie), -1 for an empty list. */
static int16_t top_piece(const uint8_t *obj, size_t list, size_t count)
{
    int16_t best;
    int16_t n = rd_s16(obj, count);
    if (n == 0) return -1;
    best = rd_s16(obj, list);
    for (int32_t k = 1; k < n; ++k) {
        const int16_t cand = rd_s16(obj, list + (size_t)k * 2u);
        if (rd_s16(obj, piece_off(best) + P_Z) < rd_s16(obj, piece_off(cand) + P_Z)) best = cand;
    }
    return best;
}

/* 0x47ea73: the two piece rectangles overlap (and the overlap contains no -1 edge). */
static int pieces_overlap(const uint8_t *obj, int16_t a, int16_t b)
{
    const size_t pa = piece_off(a);
    const size_t pb = piece_off(b);
    const int32_t al = rd_s32(obj, pa + 2), at = rd_s32(obj, pa + 6), ar = rd_s32(obj, pa + 10), ab = rd_s32(obj, pa + 14);
    const int32_t bl = rd_s32(obj, pb + 2), bt = rd_s32(obj, pb + 6), br = rd_s32(obj, pb + 10), bb = rd_s32(obj, pb + 14);
    int32_t l, r, t, bo;
    if (al < bl) {
        if (ar < bl) return 0;
        l = bl;
        r = br < ar ? br : ar;
    } else {
        if (br < al) return 0;
        l = al;
        r = br < ar ? br : ar;
    }
    if (at < bt) {
        if (ab < bt) return 0;
        t = bt;
        bo = bb < ab ? bb : ab;
    } else {
        if (bb < at) return 0;
        t = at;
        bo = bb < ab ? bb : ab;
    }
    return !(t == -1 || bo == -1 || l == -1 || r == -1);
}

/* 0x47ed96: z of piece i := 1 + the greatest z among the pieces it overlaps (and itself). */
static void set_layer(uint8_t *obj, int16_t i)
{
    int16_t found[EB_MAX_INSTANCES];
    int16_t nfound = 0;
    int16_t z = rd_s16(obj, piece_off(i) + P_Z);
    const int16_t count = rd_s16(obj, O_COUNT);
    for (int16_t j = 0; j < count && j < EB_MAX_INSTANCES; ++j)
        if (j != i && pieces_overlap(obj, i, j)) found[nfound++] = j;
    for (int16_t k = 0; k < nfound; ++k) {
        const int16_t zj = rd_s16(obj, piece_off(found[k]) + P_Z);
        z = zj < z ? z : zj;
        wr_16(obj, piece_off(i) + P_Z, z);
    }
    wr_16(obj, piece_off(i) + P_Z, (int16_t)(rd_s16(obj, piece_off(i) + P_Z) + 1));
}

/* 0x47fa11: turn piece i to its next orientation around its centre. */
static int rotate_piece(uint8_t *obj, int16_t i, const EbHost *host)
{
    const size_t P = piece_off(i);
    const int16_t type = obj[P + P_TYPE];
    size_t ent = entry_off(type, obj[P + P_ORIENT]);
    const int16_t w = rd_s16(obj, ent + ENT_W);
    const int16_t h = rd_s16(obj, ent + ENT_H);
    wr_32(obj, O_LIFT, 1);
    copy_rect(obj, O_SAVED, obj, P + P_RECT);
    obj[P + P_ORIENT] = (uint8_t)(obj[P + P_ORIENT] + 1);
    if (obj[P + P_ORIENT] == 4) obj[P + P_ORIENT] = 0;
    ent = entry_off(type, obj[P + P_ORIENT]);
    wr_32(obj, P + P_RECT, sub32((int16_t)add32(rd_s32(obj, P + P_RECT), w / 2), (int32_t)rd_s16(obj, ent + ENT_W) / 2));
    wr_32(obj, P + P_RECT + 4, sub32((int16_t)add32(rd_s32(obj, P + P_RECT + 4), h / 2), (int32_t)rd_s16(obj, ent + ENT_H) / 2));
    wr_32(obj, P + P_RECT + 8, add32(rd_s32(obj, P + P_RECT), rd_s32(obj, ent + ENT_RECT + 8)));
    wr_32(obj, P + P_RECT + 12, add32(rd_s32(obj, P + P_RECT + 4), rd_s32(obj, ent + ENT_RECT + 12)));
    CHECK(clamp_rect(obj, P + P_RECT, host));
    return translate(obj, P + P_RECT, P + P_RECT2, host);
}

/* 0x47fb76: take a copy from the Multi_Piece source: re-centre the piece on its type's D rectangle (or place it on E). */
static int multi_pick(uint8_t *obj, const uint8_t *body, int16_t i, const EbHost *host)
{
    const size_t P = piece_off(i);
    const int16_t type = obj[P + P_TYPE];
    const size_t T = type_off(type);
    wr_32(obj, O_LIFT, 1);
    copy_rect(obj, O_SAVED, obj, P + P_RECT);
    if (!rect_valid(body, T + BT_E)) {
        const size_t ent = entry_off(type, obj[P + P_ORIENT]);
        const int32_t dl = rd_s32(body, T + BT_D), dt = rd_s32(body, T + BT_D + 4);
        const int32_t dr = rd_s32(body, T + BT_D + 8), db = rd_s32(body, T + BT_D + 12);
        const int16_t eh = rd_s16(obj, ent + ENT_H);
        wr_32(obj, P + P_RECT, sub32((int16_t)add32(rd_s32(obj, P + P_RECT), rd_s16(obj, ent + ENT_W) / 2), sub32(dr, dl) / 2));
        wr_32(obj, P + P_RECT + 4, sub32((int16_t)add32(rd_s32(obj, P + P_RECT + 4), eh / 2), sub32(db, dt) / 2));
        wr_32(obj, P + P_RECT + 8, sub32(add32(rd_s32(obj, P + P_RECT), dr), dl));
        wr_32(obj, P + P_RECT + 12, sub32(add32(rd_s32(obj, P + P_RECT + 4), db), dt));
        CHECK(clamp_rect(obj, P + P_RECT, host));
        return translate(obj, P + P_RECT, P + P_RECT2, host);
    }
    copy_rect(obj, P + P_RECT, body, T + BT_E);
    return translate(obj, P + P_RECT, P + P_RECT2, host);
}

/* 0x47f275: advance the moving rectangle to the pointer rectangle's centre. */
static int follow_pointer(uint8_t *obj, const EbHost *host)
{
    wr_32(obj, O_PREV, rd_s32(obj, O_MOVE));
    wr_32(obj, O_PREV + 4, rd_s32(obj, O_MOVE + 4));
    wr_32(obj, O_PREV + 8, rd_s32(obj, O_MOVE + 8));
    wr_32(obj, O_PREV + 12, rd_s32(obj, O_MOVE + 12));
    wr_32(obj, O_PREV_T, rd_s32(obj, O_MOVE_T));
    wr_32(obj, O_PREV_T + 4, rd_s32(obj, O_MOVE_T + 4));
    wr_32(obj, O_PREV_T + 8, rd_s32(obj, O_MOVE_T + 8));
    wr_32(obj, O_PREV_T + 12, rd_s32(obj, O_MOVE_T + 12));
    wr_32(obj, O_MOVE + 4,
          sub32(add32(sub32(rd_s32(obj, O_PTR_RECT + 12), rd_s32(obj, O_PTR_RECT + 4)) / 2, rd_s32(obj, O_PTR_RECT + 4)),
                (int32_t)rd_s16(obj, O_HH) / 2));
    wr_32(obj, O_MOVE,
          sub32(add32(sub32(rd_s32(obj, O_PTR_RECT + 8), rd_s32(obj, O_PTR_RECT)) / 2, rd_s32(obj, O_PTR_RECT)),
                (int32_t)rd_s16(obj, O_HW) / 2));
    wr_32(obj, O_MOVE + 12, add32(rd_s32(obj, O_MOVE + 4), rd_s16(obj, O_HH)));
    wr_32(obj, O_MOVE + 8, add32(rd_s32(obj, O_MOVE), rd_s16(obj, O_HW)));
    CHECK(clamp_rect(obj, O_MOVE, host));
    CHECK(translate(obj, O_MOVE, O_MOVE_T, host));
    if (rd_s32(obj, O_PREV + 4) == 0 && rd_s32(obj, O_PREV + 12) == 0) {
        copy_rect(obj, O_PREV, obj, O_MOVE);
        copy_rect(obj, O_PREV_T, obj, O_MOVE_T);
    }
    return EB_OK;
}

/* 0x47ec06: with the multi-piece in hand, a piece away from home lies under the dragged piece's lower middle. */
static int near_unplaced(const uint8_t *obj, const uint8_t *body, int16_t x, int16_t y)
{
    const int16_t hand = rd_s16(obj, O_HAND);
    const size_t H = piece_off(hand);
    const int16_t half_w = (int16_t)(sub32(rd_s32(obj, H + 10), rd_s32(obj, H + 2)) / 2);
    const int16_t half_h = (int16_t)(sub32(rd_s32(obj, H + 14), rd_s32(obj, H + 6)) / 2);
    for (int16_t j = 0; j < rd_s16(obj, O_COUNT); ++j) {
        const size_t P = piece_off(j);
        const size_t home = type_off(obj[P + P_TYPE]) + BT_B;
        int at_home = 1;
        for (int k = 0; k < 4; ++k)
            if (rd_s32(obj, P + 2 + (size_t)k * 4u) != rd_s32(body, home + (size_t)k * 4u)) at_home = 0;
        if (!at_home && sub32(rd_s32(obj, P + 6), 4) < add32(y, half_h) && y < rd_s32(obj, P + 6) &&
            sub32(rd_s32(obj, P + 2), 0x14) < sub32(x, half_w) &&
            add32(x, half_w) < add32(rd_s32(obj, P + 10), 0x14))
            return 1;
    }
    return 0;
}

/* The 0x47fd65 writes. */
static void write_candidate(const uint8_t *obj, const uint8_t *body, int32_t code, EbPointerResult *out)
{
    out->wrote_cursor = 1;
    out->candidate = code;
    if (code == EB_CANDIDATE_ROTATE) {
        out->cursor = 0x14;
        out->cursor_flag = 0;
        out->cursor_record = 0x5b188cu;
    } else if (code == EB_CANDIDATE_EXIT_A || code == EB_CANDIDATE_EXIT_B) {
        out->cursor_flag = 1;
        out->cursor = rd_s16(body, code == EB_CANDIDATE_EXIT_A ? B_CURSOR_EXIT_A : B_CURSOR_EXIT_B);
        out->cursor_record = (uint32_t)(0x5b161c + (int64_t)out->cursor * 0x20);
    } else {
        if (rd_s32(obj, O_HIT) == 0 && code != EB_CANDIDATE_PICK)
            out->cursor = 0x16;
        else
            out->cursor = rd_s16(body, B_CURSOR_PICK);
        out->cursor_flag = 1;
        out->cursor_record = (uint32_t)(0x5b161c + (int64_t)out->cursor * 0x20);
    }
}

/* FL-12: original FUN_0047f421 is this function (function ledger acceptance). */
int eb_pointer_move(EbObject *object, const uint8_t *body, size_t body_length, int16_t x, int16_t y,
                    const int32_t rect[4], const EbHost *host, EbPointerResult *out)
{
    uint8_t *obj;
    if (object == NULL || body == NULL || out == NULL || rect == NULL || !host_complete(host) ||
        eb_validate_body(body, body_length, NULL) != EB_OK)
        return EB_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = CANDIDATE_NONE;
    obj = object->b;
    if (rd_s32(obj, O_ACTIVE) == 0) return EB_OK;
    if (!instances_sane(obj)) return EB_ERR_BOUNDS;
    wr_32(obj, O_PTR_RECT + 4, rect[1]);
    wr_32(obj, O_PTR_RECT + 12, rect[3]);
    wr_32(obj, O_PTR_RECT, rect[0]);
    wr_32(obj, O_PTR_RECT + 8, rect[2]);
    if (rd_s32(obj, O_DRAG) != 0 && obj[O_MULTI_HAND] == 0) {
        int16_t half_h, half_w;
        const int16_t hand = rd_s16(obj, O_HAND);
        if (!instance_valid(obj, hand)) return EB_ERR_BOUNDS;
        CHECK(follow_pointer(obj, host));
        half_h = (int16_t)(sub32(rd_s32(obj, piece_off(hand) + 14), rd_s32(obj, piece_off(hand) + 6)) / 2);
        half_w = (int16_t)(sub32(rd_s32(obj, piece_off(hand) + 10), rd_s32(obj, piece_off(hand) + 2)) / 2);
        if ((rd_s32(body, B_AREA + 4) < sub32(y, half_h) && add32(y, half_h) < rd_s32(body, B_AREA + 12) &&
             rd_s32(body, B_AREA) < sub32(x, half_w) && add32(x, half_w) < rd_s32(body, B_AREA + 8)) ||
            (body[B_MODE] == 1 && near_unplaced(obj, body, x, y))) {
            wr_32(obj, O_HIT, 1);
            if (body[B_MODE] == 0 && body[B_OVERLAP] != 0) {
                const int32_t pl = rd_s32(obj, O_PREV), pt = rd_s32(obj, O_PREV + 4);
                const int32_t pr = rd_s32(obj, O_PREV + 8), pb = rd_s32(obj, O_PREV + 12);
                for (int16_t j = 0; j < rd_s16(obj, O_COUNT); ++j) {
                    const size_t P = piece_off(j);
                    int x_hit = 0, y_hit = 0;
                    if (j != hand && obj[O_COUNTS + (size_t)j] != 0) {
                        if (pl < rd_s32(obj, P + 2))
                            x_hit = add32(rd_s32(obj, P + 2), 3) <= pr;
                        else if (pl <= sub32(rd_s32(obj, P + 10), 3))
                            x_hit = 1;
                        if (x_hit && pt < rd_s32(obj, P + 6))
                            y_hit = add32(rd_s32(obj, P + 6), 3) <= pb;
                        else if (x_hit && pt <= sub32(rd_s32(obj, P + 14), 3))
                            y_hit = 1;
                        if (x_hit && y_hit) {
                            wr_32(obj, O_HIT, 0);
                            j = rd_s16(obj, O_COUNT);
                        }
                    }
                }
            }
        } else {
            wr_32(obj, O_HIT, 0);
        }
        out->hit = 1;
        write_candidate(obj, body, EB_CANDIDATE_DROP, out);
        return EB_OK;
    }
    for (size_t k = 0; k < 40u; k += 4u) wr_32(obj, O_LIST1 + k, 0);
    wr_16(obj, O_COUNT1, 0);
    wr_16(obj, O_COUNT2, 0);
    for (int16_t j = 0; j < rd_s16(obj, O_COUNT); ++j) {
        const size_t P = piece_off(j);
        const size_t T = type_off(obj[P + P_TYPE]);
        if ((obj[O_MULTI_HAND] == 0 || j == rd_s16(obj, O_HAND)) &&
            (obj[P + P_STAMP] == 0 || body[T + BT_SPAWN] == 0)) {
            if (body[B_ROT_ALLOWED] == 0 || body[B_ROT_LOCKED] == 0 || y < rd_s32(obj, P + 6) ||
                add32(rd_s32(obj, P + 6), rd_s16(body, B_ZONE_H)) < y || x < rd_s32(obj, P + 2) ||
                add32(rd_s32(obj, P + 2), rd_s16(body, B_ZONE_W)) < x) {
                if (rd_s32(obj, P + 6) <= y && y <= rd_s32(obj, P + 14) && rd_s32(obj, P + 2) <= x &&
                    x <= rd_s32(obj, P + 10)) {
                    if (rd_s16(obj, O_COUNT1) >= 20) return EB_ERR_BOUNDS;
                    wr_16(obj, O_LIST1 + (size_t)rd_s16(obj, O_COUNT1) * 2u, j);
                    wr_16(obj, O_COUNT1, (int16_t)(rd_s16(obj, O_COUNT1) + 1));
                }
            } else {
                if (rd_s16(obj, O_COUNT2) >= 20) return EB_ERR_BOUNDS;
                wr_16(obj, O_LIST2 + (size_t)rd_s16(obj, O_COUNT2) * 2u, j);
                wr_16(obj, O_COUNT2, (int16_t)(rd_s16(obj, O_COUNT2) + 1));
            }
        }
    }
    if (rd_s16(obj, O_COUNT2) != 0) {
        out->hit = 1;
        write_candidate(obj, body, EB_CANDIDATE_ROTATE, out);
        return EB_OK;
    }
    if (rd_s16(obj, O_COUNT1) != 0) {
        out->hit = 1;
        write_candidate(obj, body, EB_CANDIDATE_PICK, out);
        return EB_OK;
    }
    if (rd_s32(body, B_BTN_A + 4) <= y && y <= rd_s32(body, B_BTN_A + 12) && rd_s32(body, B_BTN_A) <= x &&
        x <= rd_s32(body, B_BTN_A + 8)) {
        out->hit = 1;
        write_candidate(obj, body, EB_CANDIDATE_EXIT_A, out);
        return EB_OK;
    }
    if (rd_s32(body, B_BTN_B + 4) <= y && y <= rd_s32(body, B_BTN_B + 12) && rd_s32(body, B_BTN_B) <= x &&
        x <= rd_s32(body, B_BTN_B + 8)) {
        out->hit = 1;
        write_candidate(obj, body, EB_CANDIDATE_EXIT_B, out);
        return EB_OK;
    }
    return EB_OK;
}

/* strlen(src) + the "<e>" suffix into a local of `local_bytes`; the original overruns it beyond that. */
static int show_caption(const EbHost *host, const char *text, size_t local_bytes)
{
    char buf[208];
    const size_t n = strlen(text);
    if (n + 4u > local_bytes) return EB_ERR_BOUNDS;
    memcpy(buf, text, n);
    memcpy(buf + n, "<e>", 4);
    return host->caption_show(host->context, buf) != 0 ? EB_ERR_HOST : EB_OK;
}

/* The caption block of the bad drop (0x47ff0e) and of the win (0x480e02 state 6): AUTOTEXT lookup of `key`, else the
 * body text. */
static int caption_block(const uint8_t *body, size_t key, size_t text, size_t local_bytes, const EbHost *host)
{
    int32_t enabled = 0;
    const char *found = NULL;
    HOST(host->captions_enabled(host->context, &enabled));
    if (enabled == 0) return EB_OK;
    if (body[key] != 0) {
        const char *t = NULL;
        HOST(host->autotext_lookup(host->context, (const char *)body + key, &t));
        if (t != NULL && strlen(t) < 0x9c41u) {
            CHECK(show_caption(host, t, local_bytes));
            found = t;
        }
    }
    if (found == NULL && body[text] != 0) CHECK(show_caption(host, (const char *)body + text, local_bytes));
    return EB_OK;
}

/* 0x4809a7 (pick), 0x480a1d (good drop), 0x480abe (rotate): the sound blocks. */
static int sound_blip(uint8_t *obj, const uint8_t *body, size_t rec, size_t chan, uint32_t delay, const EbHost *host)
{
    if (!no_sound(body + rec)) {
        HOST(host->sound_play(host->context, rd_s16(body, chan)));
        wr_32(obj, O_DEADLINE, (int32_t)(host->tick(host->context) + delay));
        wr_32(obj, O_STATE, 1);
    }
    return EB_OK;
}

static int write_flag(const uint8_t *body, size_t index_off, uint32_t value, const EbHost *host)
{
    const int16_t index = rd_s16(body, index_off);
    if (index == EB_NO_FLAG) return EB_OK;
    if (host->event_flag_invalid(host->context, index) != 0) return EB_ERR_BOUNDS;
    HOST(host->store_event_flag(host->context, index, value));
    return EB_OK;
}

/* 0x480b34: save the puzzle state, count what is placed and set the completion flags. `row_phase` is the executor's
 * phase of the row. */
static int save_and_check(uint8_t *obj, const uint8_t *body, EbWorld *world, uint32_t row_phase, const EbHost *host)
{
    const int16_t ntypes = rd_s16(body, B_NTYPES);
    int16_t total = 0;
    wr_16(obj, O_TOTAL, 0);
    world->saved_flag = 1;
    memcpy(world->saved_pieces, obj + O_PIECES, sizeof world->saved_pieces);
    memcpy(world->saved_counts, obj + O_COUNTS, sizeof world->saved_counts);
    world->saved_count = rd_s16(obj, O_COUNT);
    for (int16_t j = 0; j < ntypes; ++j)
        if (obj[O_COUNTS + (size_t)j] != 0 && (body[type_off(j) + BT_SPAWN] == 0 || body[B_MODE] == 2))
            total = (int16_t)(total + obj[O_COUNTS + (size_t)j]);
    total = (int16_t)((int16_t)(total + rd_s16(obj, O_COUNT)) - ntypes);
    wr_16(obj, O_TOTAL, total);
    world->saved_total = total;
    if (total < rd_s16(body, B_TARGET)) {
        CHECK(write_flag(body, B_FLAG_EXIT, body[B_VALUE_EXIT] == 0, host));
        return EB_OK;
    }
    CHECK(write_flag(body, B_FLAG_EXIT, body[B_VALUE_EXIT], host));
    CHECK(write_flag(body, B_FLAG_WIN, body[B_VALUE_WIN] == 0, host));
    for (int16_t j = 0; j < ntypes; ++j) {
        const size_t T = type_off(j);
        if (obj[O_COUNTS + (size_t)j] != 0 && body[T + BT_FORBIDDEN] != 0) return EB_OK;
        if (body[T + BT_REQUIRED] != 0 && obj[O_COUNTS + (size_t)j] != body[T + BT_REQUIRED]) return EB_OK;
    }
    CHECK(write_flag(body, B_FLAG_WIN, body[B_VALUE_WIN], host));
    if (body[B_WIN_SOUND] == 0) {
        if (row_phase == 2) obj[O_DONE] = 1;
    } else {
        wr_32(obj, O_STATE, 6);
        obj[O_DONE] = 1;
    }
    return EB_OK;
}

static int sound_good(uint8_t *obj, const uint8_t *body, EbWorld *world, uint32_t row_phase, const EbHost *host)
{
    if (no_sound(body + B_SND_GOOD)) {
        wr_32(obj, O_DEADLINE, (int32_t)host->tick(host->context));
    } else {
        HOST(host->sound_play(host->context, rd_s16(body, B_CHAN_GOOD)));
        wr_32(obj, O_DEADLINE, (int32_t)(host->tick(host->context) + 300u));
    }
    CHECK(save_and_check(obj, body, world, row_phase, host));
    wr_32(obj, O_STATE, 4);
    wr_32(obj, O_DEADLINE2, (int32_t)(host->tick(host->context) + 100u));
    return EB_OK;
}

static void hand_size(uint8_t *obj, int16_t i)
{
    const size_t P = piece_off(i);
    wr_16(obj, O_HW, (int16_t)sub32(rd_s32(obj, P + 10), rd_s32(obj, P + 2)));
    wr_16(obj, O_HH, (int16_t)sub32(rd_s32(obj, P + 14), rd_s32(obj, P + 6)));
}

static int block_valid_hand(const uint8_t *obj)
{
    return instance_valid(obj, rd_s16(obj, O_HAND));
}

/* FL-12: original FUN_0047ff0e is this function (function ledger acceptance). */
int eb_click(EbObject *object, const uint8_t *body, size_t body_length, EbWorld *world, uint32_t row_phase,
             int32_t candidate, const EbHost *host, uint32_t *new_phase)
{
    uint8_t *obj;
    uint32_t phase = row_phase;
    if (object == NULL || body == NULL || world == NULL || new_phase == NULL || !host_complete(host) ||
        eb_validate_body(body, body_length, NULL) != EB_OK)
        return EB_ERR_ARGUMENT;
    obj = object->b;
    *new_phase = row_phase;
    if (rd_s32(obj, O_ACTIVE) == 0 || obj[O_DONE] != 0 || rd_s32(obj, O_STATE) != 0 || row_phase != 1) return EB_OK;
    if (candidate == EB_CANDIDATE_EXIT_A || candidate == EB_CANDIDATE_EXIT_B) {
        phase = 2;
        *new_phase = 2;
        CHECK(save_and_check(obj, body, world, phase, host));
        if (obj[O_DONE] != 0) return EB_OK;
        obj[O_EXIT] = 1;
        return EB_OK;
    }
    if (candidate == EB_CANDIDATE_ROTATE) {
        const int16_t top = top_piece(obj, O_LIST2, O_COUNT2);
        if (top == -1) return EB_OK;
        if (!instance_valid(obj, top)) return EB_ERR_BOUNDS;
        CHECK(rotate_piece(obj, top, host));
        CHECK(sound_blip(obj, body, B_SND_ROT, B_CHAN_ROT, 0x15e, host));
        wr_32(obj, O_DRAG, 1);
        wr_16(obj, O_HAND, top);
        hand_size(obj, top);
        return EB_OK;
    }
    if ((rd_s32(obj, O_DRAG) == 0 && candidate == EB_CANDIDATE_PICK) ||
        (rd_s32(obj, O_DRAG) != 0 && obj[O_MULTI_HAND] != 0)) {
        int16_t hand;
        size_t P, T;
        wr_32(obj, O_DRAG, 1);
        if (obj[O_HAS_MULTI] != 0 && obj[O_MULTI_HAND] == 0) {
            hand = top_piece(obj, O_LIST1, O_COUNT1);
            if (!instance_valid(obj, hand)) return EB_ERR_BOUNDS;
            wr_16(obj, O_HAND, hand);
            CHECK(multi_pick(obj, body, hand, host));
            obj[O_MULTI_HAND] = 1;
            return EB_OK;
        }
        if (obj[O_HAS_MULTI] == 0) {
            hand = top_piece(obj, O_LIST1, O_COUNT1);
            if (!instance_valid(obj, hand)) return EB_ERR_BOUNDS;
            wr_16(obj, O_HAND, hand);
        }
        hand = rd_s16(obj, O_HAND);
        if (!instance_valid(obj, hand)) return EB_ERR_BOUNDS;
        P = piece_off(hand);
        T = type_off(obj[P + P_TYPE]);
        if (body[T + BT_SPAWN] != 0) {
            const int16_t count = rd_s16(obj, O_COUNT);
            if (count < 0 || count >= EB_MAX_INSTANCES) return EB_ERR_BOUNDS;
            CHECK(piece_init(obj, body, world, count, obj[P + P_TYPE], 1, host));
            set_layer(obj, count);
            wr_16(obj, O_COUNT, (int16_t)(count + 1));
        }
        obj[O_MULTI_HAND] = 0;
        wr_32(obj, O_LIFT, 1);
        copy_rect(obj, O_SAVED, obj, P + P_RECT);
        if (rect_valid(body, T + BT_C)) copy_rect(obj, P + P_RECT, body, T + BT_C);
        CHECK(translate(obj, P + P_RECT, P + P_RECT2, host));
        hand_size(obj, hand);
        if (obj[O_COUNTS + obj[P + P_TYPE]] != 0 && body[T + BT_SPAWN] == 0)
            obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] - 1);
        CHECK(sound_blip(obj, body, B_SND_PICK, B_CHAN_PICK, 300, host));
        return EB_OK;
    }
    if (candidate != EB_CANDIDATE_DROP) return EB_OK;
    {
        const int16_t hand = rd_s16(obj, O_HAND);
        size_t P, T;
        if (!block_valid_hand(obj)) return EB_ERR_BOUNDS;
        P = piece_off(hand);
        T = type_off(obj[P + P_TYPE]);
        wr_32(obj, O_DRAG, 0);
        wr_32(obj, O_DROP, 1);
        copy_rect(obj, P + P_RECT, obj, O_PREV);
        copy_rect(obj, P + P_RECT2, obj, O_PREV_T);
        set_layer(obj, hand);
        if (rd_s32(obj, O_HIT) != 0 && body[B_MODE] != 2) {
            obj[P + P_STAMP] = 1;
            obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] + 1);
            CHECK(sound_good(obj, body, world, row_phase, host));
            wr_16(obj, O_HAND, -1);
            return EB_OK;
        }
        if (rd_s32(obj, O_HIT) == 0 || body[B_MODE] != 2) {
            if (!no_sound(body + B_SND_BAD)) {
                HOST(host->sound_play(host->context, rd_s16(body, B_CHAN_BAD)));
                wr_32(obj, O_DEADLINE, (int32_t)(host->tick(host->context) + 200u));
                wr_32(obj, O_STATE, 1);
                CHECK(caption_block(body, B_KEY_BAD, B_TEXT_BAD, 204, host));
            }
        } else {
            obj[O_COUNTS + obj[P + P_TYPE]] = (uint8_t)(obj[O_COUNTS + obj[P + P_TYPE]] + 1);
            CHECK(sound_good(obj, body, world, row_phase, host));
        }
        obj[P + P_STAMP] = 0;
        copy_rect(obj, P + P_RECT, body, T + BT_B);
        CHECK(translate(obj, P + P_RECT, P + P_RECT2, host));
        obj[P + P_ORIENT] = 0;
        wr_16(obj, O_HAND, -1);
    }
    return EB_OK;
}

int eb_rotate_key(EbObject *object, const uint8_t *body, size_t body_length, uint32_t row_phase, const EbHost *host)
{
    uint8_t *obj;
    int16_t piece;
    if (object == NULL || body == NULL || !host_complete(host) || eb_validate_body(body, body_length, NULL) != EB_OK)
        return EB_ERR_ARGUMENT;
    obj = object->b;
    if (rd_s32(obj, O_ACTIVE) == 0 || body[B_ROT_ALLOWED] == 0 || body[B_ROT_LOCKED] != 0 || obj[O_DONE] != 0 ||
        rd_s32(obj, O_STATE) != 0 || row_phase != 1 || rd_s16(obj, O_COUNT1) == 0)
        return EB_OK;
    if (rd_s32(obj, O_DRAG) == 0) {
        size_t T;
        piece = top_piece(obj, O_LIST1, O_COUNT1);
        if (piece == -1) return EB_OK;
        if (!instance_valid(obj, piece)) return EB_ERR_BOUNDS;
        CHECK(rotate_piece(obj, piece, host));
        wr_32(obj, O_DRAG, 1);
        wr_16(obj, O_HAND, piece);
        hand_size(obj, piece);
        T = type_off(obj[piece_off(piece) + P_TYPE]);
        if (obj[O_COUNTS + obj[piece_off(piece) + P_TYPE]] != 0 && body[T + BT_SPAWN] == 0)
            obj[O_COUNTS + obj[piece_off(piece) + P_TYPE]] =
                (uint8_t)(obj[O_COUNTS + obj[piece_off(piece) + P_TYPE]] - 1);
    } else {
        piece = rd_s16(obj, O_HAND);
        if (!instance_valid(obj, piece)) return EB_ERR_BOUNDS;
        CHECK(rotate_piece(obj, piece, host));
        hand_size(obj, piece);
    }
    CHECK(sound_blip(obj, body, B_SND_ROT, B_CHAN_ROT, 0x15e, host));
    set_layer(obj, piece);
    return EB_OK;
}

int eb_invalidate(EbObject *object, const EbHost *host)
{
    if (object == NULL || host == NULL || host->mark_dirty == NULL) return EB_ERR_ARGUMENT;
    if (rd_s32(object->b, O_ACTIVE) != 0 && rd_s16(object->b, O_SLOT) != -1)
        HOST(host->mark_dirty(host->context, rd_s16(object->b, O_SLOT)));
    return EB_OK;
}

/* FL-12: original FUN_0047e2a5 is this function (function ledger acceptance). */
int eb_cleanup(EbObject *object, const EbHost *host)
{
    uint8_t *obj;
    static const size_t surfaces[3] = {O_SRC, O_MULTI, O_ANIM};
    if (object == NULL || host == NULL || host->release_surface == NULL || host->release_slot == NULL)
        return EB_ERR_ARGUMENT;
    obj = object->b;
    for (int k = 0; k < 3; ++k)
        if (rd_s32(obj, surfaces[k]) != 0) {
            HOST(host->release_surface(host->context, (uint32_t)rd_s32(obj, surfaces[k])));
            wr_32(obj, surfaces[k], 0);
        }
    for (int16_t t = 0; t < EB_MAX_TYPES; ++t)
        for (unsigned k = 0; k < 4; ++k) {
            const size_t e = entry_off(t, k);
            if (rd_s32(obj, e + ENT_SURF) != 0) {
                HOST(host->release_surface(host->context, (uint32_t)rd_s32(obj, e + ENT_SURF)));
                wr_32(obj, e + ENT_SURF, 0);
            }
        }
    if (rd_s16(obj, O_SLOT) != -1) HOST(host->release_slot(host->context, rd_s16(obj, O_SLOT)));
    /* 0x47e25a */
    wr_16(obj, O_ROW, -1);
    wr_16(obj, O_SLOT, -1);
    wr_32(obj, O_ACTIVE, 0);
    obj[O_EXIT] = 0;
    obj[O_DONE] = 0;
    wr_32(obj, O_DRAG, 0);
    return EB_OK;
}

static int apply_block(const uint8_t *blk, EbWorld *world, const EbHost *host)
{
    if (rd_s16(blk, SB_SCENE) != EB_NO_SCENE) {
        EbTransition t;
        t.scene = rd_s16(blk, SB_SCENE);
        t.word[0] = rd_s16(blk, SB_W1);
        t.word[1] = rd_s16(blk, SB_W2);
        t.word[2] = rd_s16(blk, SB_W3);
        t.dword[0] = rd_s32(blk, SB_D1);
        t.dword[1] = rd_s32(blk, SB_D2);
        t.dword[2] = rd_s32(blk, SB_D3);
        HOST(host->transition(host->context, &t));
        world->scene_5bb57b = t.scene;
        world->start_flag_5bb1ca = rd_s16(blk, SB_START) != 1 ? 1 : 0;
    }
    return EB_OK;
}

/* 0x480e02 phase 0. */
static int phase0(uint8_t *obj, const uint8_t *body, int16_t row, EbWorld *world, const EbHost *host)
{
    const int16_t ntypes = rd_s16(body, B_NTYPES);
    int16_t slot = EB_NO_SLOT;
    wr_16(obj, O_ROW, row);
    wr_32(obj, O_ACTIVE, 1);
    world->start_flag_5bb1ca = 1;
    HOST(host->clear_pending_item(host->context));
    wr_32(obj, O_HIT, 0);
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
    wr_16(obj, O_ANIM_ROW, 0);
    wr_16(obj, O_ANIM_FRAME, 0);
    wr_16(obj, O_CELL_W, (int16_t)sub32(rd_s32(body, B_ANIM_AREA + 8), rd_s32(body, B_ANIM_AREA)));
    wr_16(obj, O_CELL_H, (int16_t)sub32(rd_s32(body, B_ANIM_AREA + 12), rd_s32(body, B_ANIM_AREA + 4)));
    if (rd_s32(obj, O_SRC) == 0) {
        uint32_t s = 0;
        HOST(host->load_surface(host->context, (const char *)body + B_NAME, TAG_PIECE_SRC, &s));
        wr_32(obj, O_SRC, (int32_t)s);
    }
    for (int16_t t = 0; t < EB_MAX_TYPES; ++t)
        for (unsigned k = 0; k < 4; ++k) wr_32(obj, entry_off(t, k) + ENT_SURF, 0);
    if (body[B_PERSIST] == 0 || world->saved_flag == 0 || (int32_t)world->saved_scene != world->scene_5bb57b) {
        world->saved_scene = (int16_t)world->scene_5bb57b;
        memset(obj + O_PIECES, 0, sizeof world->saved_pieces);
        memset(obj + O_COUNTS, 0, 20);
        wr_16(obj, O_COUNT, ntypes);
        wr_16(obj, O_TOTAL, 0);
    } else {
        memcpy(obj + O_PIECES, world->saved_pieces, sizeof world->saved_pieces);
        memcpy(obj + O_COUNTS, world->saved_counts, sizeof world->saved_counts);
        wr_16(obj, O_COUNT, world->saved_count);
        wr_16(obj, O_TOTAL, world->saved_total);
    }
    for (int16_t t = 0; t < ntypes; ++t) CHECK(piece_init(obj, body, world, t, t, 0, host));
    if (no_file(body + B_MULTI_NAME) || body[B_MULTI_NAME] == 0) {
        obj[O_HAS_MULTI] = 0;
        wr_32(obj, O_MULTI, 0);
    } else {
        uint32_t s = 0;
        HOST(host->load_surface(host->context, (const char *)body + B_MULTI_NAME, TAG_MULTI, &s));
        wr_32(obj, O_MULTI, (int32_t)s);
        obj[O_HAS_MULTI] = 1;
    }
    if (!no_file(body + B_ANIM_NAME) && body[B_ANIM_NAME] != 0) {
        uint32_t s = 0;
        HOST(host->load_surface(host->context, (const char *)body + B_ANIM_NAME, TAG_ANIM, &s));
        wr_32(obj, O_ANIM, (int32_t)s);
        obj[O_HAS_ANIM] = 1;
    } else {
        obj[O_HAS_ANIM] = 0;
        wr_32(obj, O_ANIM, 0);
    }
    obj[O_ANIM_REST] = 0;
    obj[O_ANIM_ON] = 0;
    obj[O_MULTI_HAND] = 0;
    HOST(host->alloc_slot(host->context, &slot));
    wr_16(obj, O_SLOT, slot);
    HOST(host->register_slot(host->context, slot, LABEL_SLOT));
    {
        static const size_t order[4] = {B_SND_PICK, B_SND_GOOD, B_SND_ROT, B_SND_BAD};
        for (int k = 0; k < 4; ++k)
            if (!no_sound(body + order[k]))
                HOST(host->sound_prepare(host->context, (uint32_t)order[k], body + order[k]));
    }
    return EB_OK;
}

/* 0x480e02 phase 2. */
static int phase2(EbObject *object, const uint8_t *body, EbWorld *world, const EbHost *host)
{
    uint8_t *obj = object->b;
    static const size_t order[4] = {B_SND_PICK, B_SND_GOOD, B_SND_BAD, B_SND_ROT};
    world->start_flag_5bb1ca = 1;
    for (int k = 0; k < 4; ++k)
        if (!no_sound(body + order[k])) HOST(host->sound_stop(host->context, (uint32_t)order[k], body + order[k]));
    if (obj[O_EXIT] == 0) {
        if (obj[O_DONE] != 0) CHECK(apply_block(body + B_BLOCK_WIN, world, host));
    } else {
        CHECK(apply_block(body + B_BLOCK_EXIT, world, host));
    }
    HOST(host->complete(host->context, rd_s16(obj, O_ROW)));
    return eb_cleanup(object, host);
}

/* 0x480e02 phase 1: the state machine on obj+0x13ca. */
static int phase1(uint8_t *obj, const uint8_t *body, uint32_t *row_phase, const EbHost *host)
{
    switch (rd_s32(obj, O_STATE)) {
    case 0:
        if (rd_s16(obj, O_COUNT) > 0x4f) *row_phase = 2;
        break;
    case 1:
        if ((uint32_t)rd_s32(obj, O_DEADLINE) <= host->tick(host->context)) wr_32(obj, O_STATE, 0);
        break;
    case 3: {
        int32_t busy = 0;
        HOST(host->sound_busy(host->context, rd_s16(body, B_CHAN_WIN), &busy));
        if (busy == 0) {
            HOST(host->sound_stop(host->context, B_SND_WIN, body + B_SND_WIN));
            *row_phase = 2;
        }
        break;
    }
    case 4:
        if (obj[O_HAS_ANIM] == 0) {
            if ((uint32_t)rd_s32(obj, O_DEADLINE) <= host->tick(host->context))
                wr_32(obj, O_STATE, obj[O_DONE] == 0 ? 0 : 6);
        } else {
            int16_t cols = rd_s16(body, B_GRID_COLS);
            int16_t frame, row;
            obj[O_ANIM_ON] = 1;
            if (!no_sound(body + B_SND_GOOD)) {
                int32_t busy = 0;
                HOST(host->sound_busy(host->context, rd_s16(body, B_CHAN_GOOD), &busy));
                if (busy == 0) HOST(host->sound_play(host->context, rd_s16(body, B_CHAN_GOOD)));
            }
            if (cols == 0) return EB_ERR_BOUNDS;
            if (rd_s16(body, B_GRID_ROWS) <= rd_s16(obj, O_ANIM_FRAME) / cols) {
                wr_16(obj, O_ANIM_FRAME, 0);
                wr_16(obj, O_ANIM_ROW, (int16_t)(rd_s16(obj, O_ANIM_ROW) + 1));
            }
            if (rd_s16(obj, O_ANIM_ROW) < rd_s16(body, B_GRID_REPEAT)) {
                frame = rd_s16(obj, O_ANIM_FRAME);
                row = (int16_t)(frame / cols);
                wr_32(obj, O_ANIM_SRC, add32(mul32(add32(rd_s16(obj, O_CELL_W), rd_s16(body, B_GRID_GAP)), frame % cols), 1));
                wr_32(obj, O_ANIM_SRC + 4, add32(mul32(add32(rd_s16(obj, O_CELL_H), rd_s16(body, B_GRID_GAP)), row), 1));
                wr_32(obj, O_ANIM_SRC + 8, add32(rd_s32(obj, O_ANIM_SRC), rd_s16(obj, O_CELL_W)));
                wr_32(obj, O_ANIM_SRC + 12, add32(rd_s32(obj, O_ANIM_SRC + 4), rd_s16(obj, O_CELL_H)));
                wr_16(obj, O_ANIM_FRAME, (int16_t)(rd_s16(obj, O_ANIM_FRAME) + 1));
                wr_32(obj, O_STATE, 5);
            } else {
                wr_16(obj, O_ANIM_ROW, 0);
                obj[O_ANIM_REST] = 1;
                obj[O_ANIM_ON] = 0;
                wr_32(obj, O_STATE, obj[O_DONE] == 0 ? 0 : 6);
            }
        }
        break;
    case 5:
        if ((uint32_t)rd_s32(obj, O_DEADLINE2) <= host->tick(host->context)) {
            wr_32(obj, O_STATE, 4);
            wr_32(obj, O_DEADLINE2, (int32_t)(host->tick(host->context) + 100u));
        }
        break;
    case 6:
        if (no_sound(body + B_SND_WIN)) {
            *row_phase = 2;
            return EB_OK;
        }
        HOST(host->sound_prepare(host->context, B_SND_WIN, body + B_SND_WIN));
        HOST(host->sound_play(host->context, rd_s16(body, B_CHAN_WIN)));
        CHECK(caption_block(body, B_KEY_WIN, B_TEXT_WIN, 208, host));
        wr_32(obj, O_STATE, 3);
        break;
    default:
        break;
    }
    return EB_OK;
}

int eb_step(EbObject *object, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, EbWorld *world,
            const EbHost *host, EbResult *result, const char **failure)
{
    uint8_t *obj;
    int rc;
    if (object == NULL || body == NULL || world == NULL || result == NULL || !host_complete(host)) return EB_ERR_ARGUMENT;
    memset(result, 0, sizeof(*result));
    result->phase_after = phase;
    if (eb_validate_body(body, body_length, failure) != EB_OK) return EB_ERR_BODY;
    obj = object->b;
    if (phase == 0) {
        rc = phase0(obj, body, row, world, host);
        if (rc == EB_OK) {
            result->phase_after = 1;
            result->initialized = 1;
        }
        return rc;
    }
    if (rd_s16(obj, O_ROW) != row || rd_s32(obj, O_ACTIVE) == 0) {
        if (failure != NULL) *failure = "0xeb-phase-without-init";
        return EB_ERR_UNSUPPORTED;
    }
    if (phase == 1) {
        uint32_t next = 1;
        rc = phase1(obj, body, &next, host);
        result->phase_after = next;
        return rc;
    }
    if (phase == 2) {
        rc = phase2(object, body, world, host);
        if (rc == EB_OK) result->completed = 1;
        return rc;
    }
    return EB_OK;
}

static void plan_blit(EbRenderPlan *plan, uint8_t kind, uint8_t src_kind, uint32_t surface, const int32_t src[4],
                      const int32_t dst[4])
{
    EbBlit *b = &plan->blit[plan->count++];
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

static void xlate(const EbView *v, const int32_t in[4], int32_t out[4])
{
    out[1] = add32(in[1], v->origin_y);
    out[3] = add32(in[3], v->origin_y);
    out[0] = add32(in[0], v->origin_x);
    out[2] = add32(in[2], v->origin_x);
}

/* FL-12: original FUN_00481cb9 is this function (function ledger acceptance). */
int eb_render_plan(EbObject *object, const uint8_t *body, size_t body_length, const EbHost *host,
                   EbRenderPlan *plan)
{
    uint8_t *obj;
    EbView v;
    int32_t src[4], dst[4], moved[4];
    int16_t n, want, layer, drawn;
    if (object == NULL || body == NULL || plan == NULL || !host_complete(host) ||
        eb_validate_body(body, body_length, NULL) != EB_OK)
        return EB_ERR_ARGUMENT;
    memset(plan, 0, sizeof(*plan));
    obj = object->b;
    if (rd_s16(obj, O_SLOT) == EB_NO_SLOT) return EB_OK;
    if (host->view(host->context, &v) != 0) return EB_ERR_HOST;
    plan->valid = 1;
    n = rd_s16(obj, O_COUNT);
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
        if (!instance_valid(obj, rd_s16(obj, O_HAND))) return EB_ERR_BOUNDS;
    }
    if (!instances_sane(obj)) return EB_ERR_BOUNDS;
    layer = 0;
    drawn = 0;
    for (;;) {
        if (drawn == want) {
            if (rd_s32(obj, O_DRAG) != 0) {
                const size_t P = piece_off(rd_s16(obj, O_HAND));
                const size_t T = type_off(obj[P + P_TYPE]);
                if (obj[O_MULTI_HAND] == 0) {
                    const size_t ent = entry_off(obj[P + P_TYPE], obj[P + P_ORIENT] & 3u);
                    rect_at(obj, ent + ENT_RECT, src);
                    rect_at(obj, O_MOVE_T, dst);
                    plan_blit(plan, 1, 4, (uint32_t)rd_s32(obj, ent + ENT_SURF), src, dst);
                } else {
                    rect_at(body, T + BT_D, src);
                    rect_at(obj, P + P_RECT2, dst);
                    plan_blit(plan, 1, 3, (uint32_t)rd_s32(obj, O_MULTI), src, dst);
                }
            }
            if (obj[O_ANIM_ON] == 0) {
                if (obj[O_ANIM_REST] != 0) {
                    rect_at(body, B_ANIM_AREA, src);
                    xlate(&v, src, moved);
                    plan_blit(plan, 0, 0, 0, src, moved);
                    obj[O_ANIM_REST] = 0;
                }
            } else {
                rect_at(body, B_ANIM_AREA, src);
                xlate(&v, src, moved);
                rect_at(obj, O_ANIM_SRC, src);
                plan_blit(plan, 0, 1, (uint32_t)rd_s32(obj, O_ANIM), src, moved);
            }
            return EB_OK;
        }
        if (layer >= 0x4000) return EB_ERR_BOUNDS;
        for (int16_t c = 0; c < n; ++c) {
            const size_t P = piece_off(c);
            if (rd_s32(obj, O_DRAG) == 0 || rd_s16(obj, O_HAND) != c) {
                if (rd_s16(obj, P + P_Z) == layer) {
                    const size_t T = type_off(obj[P + P_TYPE]);
                    if (plan->count >= EB_MAX_BLITS - 4) return EB_ERR_BOUNDS;
                    rect_at(obj, P + P_RECT2, dst);
                    if (obj[P + P_STAMP] == 0) {
                        if (rect_valid(body, T + BT_A)) {
                            rect_at(body, T + BT_A, src);
                            plan_blit(plan, 1, 2, (uint32_t)rd_s32(obj, O_SRC), src, dst);
                        }
                    } else {
                        const size_t ent = entry_off(obj[P + P_TYPE], obj[P + P_ORIENT] & 3u);
                        rect_at(obj, ent + ENT_RECT, src);
                        plan_blit(plan, 1, 4, (uint32_t)rd_s32(obj, ent + ENT_SURF), src, dst);
                    }
                    ++drawn;
                    if (drawn == want) break;
                }
            }
        }
        ++layer;
    }
}
