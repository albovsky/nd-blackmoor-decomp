#include "action_family_ee_runtime.h"

#include <string.h>

/* Object offsets (see the header). */
enum {
    O_VTABLE = 0x00,
    O_SLOT = 0x04,
    O_ROW = 0x06,
    O_SURFACE = 0x08,
    O_BODY = 0x0c,
    O_STATE = 0x10,
    O_CELLS = 0x14,
    O_USED = 0x18,
    O_FIRST = 0x1c,
    O_SECOND = 0x20,
    O_ACTIVE = 0x24,
    O_WON = 0x28,
    O_LOST = 0x2c,
    O_REDRAW = 0x30,
    O_FLIPBACK = 0x34,
    O_DEADLINE = 0x38,
    O_TILE_RECTS = 0x3c,
    O_TAB_TARGET = 0x1bc,
    O_TAB_HOT = 0x1cc,
    O_VIEW_COPY = 0x25c,
    O_VIEW = 0x26c,
    O_HIT = 0x27c,
    O_PER_PAGE = 0x280,
    O_TOTAL = 0x284,
    O_SLOTS = 0x288,
    O_PAGE = 0x28c,
    O_PAIRS = 0x290,
    O_TRIES = 0x294,
    O_HALF_TOTAL = 0x298,
    O_HALF_PAGE = 0x29c,
    O_NEEDED = 0x2a0,
    O_IDS = 0x2a4,
    O_UNUSED = 0x2a8,
    O_LOOP_I = 0x2ac,
    O_LOOP_J = 0x2b0,
    O_CELL = 0x2b4,
    O_SND_MATCH = 0x2b8,
    O_SND_WRONG = 0x2bc,
    O_SND_WIN = 0x2c0
};

/* Body offsets. */
enum {
    B_NAME = 0x00,
    B_PICTURES = 0x21,
    B_TAB_SRC = 0xe1,
    B_TILES = 0x111,
    B_TAB_TARGET = 0x291,
    B_TAB_HOT = 0x2a1,
    B_DELAY = 0x331,
    B_PCT_IDS = 0x335,
    B_PCT_NEEDED = 0x339,
    B_NEEDED_FIXED = 0x33d,
    B_TRIES = 0x341,
    B_RECENTER = 0x345,
    B_SHUFFLE_ALL = 0x346,
    B_PAGES = 0x347,
    B_COLS = 0x34b,
    B_ROWS = 0x34f,
    B_SLOT_COLS = 0x353,
    B_SLOT_ROWS = 0x357,
    B_TABS = 0x35b,
    B_SND_FLIP1 = 0x35c,
    B_SND_FLIP2 = 0x412,
    B_SND_MATCH = 0x4c8,
    B_SND_WRONG = 0x856,
    B_SND_WIN = 0xf72,
    B_BLOCK_WIN = 0x168e,
    B_BLOCK_LOSE = 0x16a8
};

enum { SND_NAME = 0x00, SND_CHANNEL = 0x21, SND_KEY = 0x31, SND_TEXT = 0x52, SND_KEY_BYTES = 0x21, SND_TEXT_BYTES = 0x64 };
enum { BLOCK_BYTES = 0x1a, CAPTION_LOCAL_BYTES = 104, CAPTION_TEXT_MAX = 0x9c40 };

#define LABEL_SLOT "WHALESURVIVOR GAME PUZZLE OVERLAYS"
#define TAG_SURFACE "Memory Puzzle Overlay Surface"

static int16_t rd_s16(const uint8_t *b, size_t off)
{
    return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));
}

static int32_t rd_s32(const uint8_t *b, size_t off)
{
    return (int32_t)((uint32_t)b[off] | ((uint32_t)b[off + 1] << 8) | ((uint32_t)b[off + 2] << 16) |
                     ((uint32_t)b[off + 3] << 24));
}

static uint32_t rd_u32(const uint8_t *b, size_t off)
{
    return (uint32_t)rd_s32(b, off);
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

static int32_t mul32(int32_t a, int32_t b)
{
    return (int32_t)((uint32_t)a * (uint32_t)b);
}

#define HOST(call) do { if ((call) != 0) { return MP_ERR_HOST; } } while (0)
#define CHECK(call) do { int rc_ = (call); if (rc_ != MP_OK) { return rc_; } } while (0)

/* The 9-byte comparison against "NO SOUND\0" (repe cmpsb with ecx = 9). */
static int no_sound_exact(const uint8_t *name)
{
    static const uint8_t k[9] = {'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0};
    return memcmp(name, k, sizeof k) == 0;
}

/* 0x516530 in the C locale (0x63cb1c == 0): ASCII case-insensitive string equality against "NO SOUND". */
static int no_sound_ci(const uint8_t *name)
{
    static const char k[] = "NO SOUND";
    size_t i = 0;
    for (;;) {
        unsigned a = name[i], b = (unsigned char)k[i];
        if (a >= 'A' && a <= 'Z') a += 0x20u;
        if (b >= 'A' && b <= 'Z') b += 0x20u;
        if (a != b) return 0;
        if (a == 0) return 1;
        ++i;
    }
}

static const uint8_t *cell_at(const MpObject *o, int32_t index)
{
    return o->cells + (size_t)index * MP_CELL_BYTES;
}

static uint8_t *cell_at_w(MpObject *o, int32_t index)
{
    return o->cells + (size_t)index * MP_CELL_BYTES;
}

/* The guest pointer of the first / second flipped cell back to its index, -1 when it is not a cell of the table. */
static int32_t cell_index(const MpObject *o, uint32_t ptr)
{
    uint32_t d;
    if (ptr < MP_GUEST_CELLS) return -1;
    d = ptr - MP_GUEST_CELLS;
    if (d % MP_CELL_BYTES != 0u || d / MP_CELL_BYTES >= (uint32_t)MP_MAX_CELLS) return -1;
    (void)o;
    return (int32_t)(d / MP_CELL_BYTES);
}

void mp_object_reset(MpObject *object)
{
    uint8_t *b = object->b;
    memset(object, 0, sizeof *object);
    wr_32(b, O_VTABLE, (int32_t)MP_VTABLE);
    wr_16(b, O_ROW, -1);
    wr_16(b, O_SLOT, -1);
}

/* 0x47b23b: the object reset the clear runs; it keeps the vtable pointer, the state, the deadline, the tile counts, the view and
 * every other field it does not name. */
static void object_clear(uint8_t *b)
{
    wr_16(b, O_ROW, -1);
    wr_16(b, O_SLOT, -1);
    wr_32(b, O_BODY, 0);
    wr_32(b, O_ACTIVE, 0);
    wr_32(b, O_WON, 0);
    wr_32(b, O_LOST, 0);
    wr_32(b, O_REDRAW, 0);
    wr_32(b, O_FLIPBACK, 0);
    wr_32(b, O_UNUSED, 0);
    wr_32(b, O_SURFACE, 0);
    wr_32(b, O_CELLS, 0);
    wr_32(b, O_USED, 0);
    wr_32(b, O_FIRST, 0);
    wr_32(b, O_SECOND, 0);
    wr_32(b, O_PER_PAGE, 0);
    wr_32(b, O_HALF_PAGE, 0);
    wr_32(b, O_SLOTS, 0);
    wr_32(b, O_NEEDED, 0);
    wr_32(b, O_PAGE, 0);
    wr_32(b, O_IDS, 0);
}

int16_t mp_object_slot(const MpObject *object) { return rd_s16(object->b, O_SLOT); }
int16_t mp_object_row(const MpObject *object) { return rd_s16(object->b, O_ROW); }
int mp_object_active(const MpObject *object) { return rd_s32(object->b, O_ACTIVE) != 0; }
uint32_t mp_object_state(const MpObject *object) { return (uint32_t)rd_s32(object->b, O_STATE); }

static int field_terminated(const uint8_t *body, size_t off, size_t span)
{
    return memchr(body + off, 0, span) != NULL;
}

/* The scaling of 0x47bb56: float32(percentage) / 100.0f * float32(count), truncated by __ftol. Evaluated in double precision. */
static int scaled(int32_t pct, int32_t count, int32_t *out)
{
    const double q = (double)(float)pct / 100.0;
    const double p = q * (double)(float)count;
    if (!(p > -2147483648.0 && p < 2147483648.0)) return 0;
    *out = (int32_t)p;
    return 1;
}

int mp_validate_body(const uint8_t *body, size_t length, const char **failure)
{
    const char *why = NULL;
    static const struct {
        size_t base;
        int count;
    } lists[] = {{B_SND_FLIP1, 1}, {B_SND_FLIP2, 1}, {B_SND_MATCH, 5}, {B_SND_WRONG, 10}, {B_SND_WIN, 10}};
    if (body == NULL || length < MP_BODY_BYTES) {
        why = "0xee-short-body";
    } else if (!field_terminated(body, B_NAME, 0x21)) {
        why = "0xee-unterminated-name";
    } else {
        const int32_t pages = rd_s32(body, B_PAGES), cols = rd_s32(body, B_COLS), rows = rd_s32(body, B_ROWS);
        const int32_t sc = rd_s32(body, B_SLOT_COLS), sr = rd_s32(body, B_SLOT_ROWS);
        int32_t t;
        if (pages < 1 || pages > MP_MAX_PAGES) why = "0xee-pages";
        else if (cols < 1 || cols > 6) why = "0xee-columns";
        else if (rows < 1 || rows > 4) why = "0xee-rows";
        else if (sc < 1 || sc > 6) why = "0xee-picture-columns";
        else if (sr < 1 || sr > 2) why = "0xee-picture-rows";
        else {
            const int32_t per_page = cols * rows;
            const int shuffle_all = pages > 1 && body[B_SHUFFLE_ALL] != 0;
            if ((shuffle_all ? per_page * pages : per_page) % 2 != 0) why = "0xee-odd-cell-count";
            else if (!scaled(rd_s32(body, B_PCT_IDS), sc * sr, &t)) why = "0xee-percentage";
            else if (rd_s32(body, B_PCT_NEEDED) != -1 && !scaled(rd_s32(body, B_PCT_NEEDED), per_page * pages / 2, &t))
                why = "0xee-percentage";
        }
        for (size_t l = 0; l < sizeof lists / sizeof lists[0] && why == NULL; ++l)
            for (int i = 0; i < lists[l].count && why == NULL; ++i) {
                const size_t r = lists[l].base + (size_t)i * MP_SOUND_RECORD_BYTES;
                if (!field_terminated(body, r + SND_NAME, 0x21)) why = "0xee-unterminated-sound-name";
                else if (!field_terminated(body, r + SND_KEY, SND_KEY_BYTES)) why = "0xee-unterminated-caption-key";
                else if (!field_terminated(body, r + SND_TEXT, SND_TEXT_BYTES)) why = "0xee-unterminated-caption-text";
            }
    }
    if (why != NULL) {
        if (failure != NULL) *failure = why;
        return MP_ERR_BODY;
    }
    return MP_OK;
}

static int host_complete(const MpHost *h)
{
    return h != NULL && h->view != NULL && h->set_start_flag != NULL && h->clear_pending_item != NULL &&
           h->recenter_cursor != NULL && h->alloc_slot != NULL && h->register_slot != NULL &&
           h->set_slot_surface != NULL && h->release_slot != NULL && h->mark_dirty != NULL && h->load_surface != NULL &&
           h->release_surface != NULL && h->random != NULL && h->tick != NULL && h->sound_prepare != NULL &&
           h->sound_play != NULL && h->sound_busy != NULL && h->captions_enabled != NULL &&
           h->autotext_lookup != NULL && h->caption_show != NULL && h->event_flag_invalid != NULL &&
           h->transition != NULL && h->store_event_flag != NULL && h->complete != NULL;
}

/* strlen(src) + the "<n><e>" suffix into the 104-byte local of 0x47d02d; the original overruns it beyond that. */
static int show_caption(const MpHost *host, const char *text)
{
    char buf[CAPTION_LOCAL_BYTES];
    const size_t n = strlen(text);
    if (n + 7u > sizeof buf) return MP_ERR_BOUNDS;
    memcpy(buf, text, n);
    memcpy(buf + n, "<n><e>", 7);
    return host->caption_show(host->context, buf) != 0 ? MP_ERR_HOST : MP_OK;
}

/* 0x47d02d: play the sound record at body offset `id` and show its caption. */
static int play_record(const uint8_t *body, size_t id, const MpHost *host)
{
    const uint8_t *rec = body + id;
    int32_t enabled = 0;
    int shown = 0;
    if (!no_sound_ci(rec + SND_NAME)) {
        HOST(host->sound_prepare(host->context, (uint32_t)id, rec));
        HOST(host->sound_play(host->context, rd_s16(rec, SND_CHANNEL)));
    }
    HOST(host->captions_enabled(host->context, &enabled));
    if (enabled == 0) return MP_OK;
    if (rec[SND_KEY] != 0) {
        const char *t = NULL;
        HOST(host->autotext_lookup(host->context, (const char *)rec + SND_KEY, &t));
        if (t != NULL && strlen(t) < (size_t)CAPTION_TEXT_MAX + 1u) {
            CHECK(show_caption(host, t));
            shown = 1;
        }
    }
    if (!shown && rec[SND_TEXT] != 0) CHECK(show_caption(host, (const char *)rec + SND_TEXT));
    return MP_OK;
}

/* 0x47cd90 / 0x47ce6f / 0x47cf4e: pick a sound record other than "NO SOUND" at random and play it. The picked index is kept in
 * the object (`field`), -1 when every record is "NO SOUND". */
static int pick_and_play(MpObject *o, const uint8_t *body, size_t base, int count, size_t field, const MpHost *host)
{
    uint8_t *b = o->b;
    int found = 0;
    wr_32(b, field, -1);
    for (int i = 0; i < count && !found; ++i)
        if (!no_sound_ci(body + base + (size_t)i * MP_SOUND_RECORD_BYTES + SND_NAME)) found = 1;
    if (found) {
        int draws = 0;
        do {
            if (++draws > MP_PICK_LIMIT) return MP_ERR_STUCK;
            wr_32(b, field, host->random(host->context) % count);
        } while (no_sound_ci(body + base + (size_t)rd_s32(b, field) * MP_SOUND_RECORD_BYTES + SND_NAME));
        CHECK(play_record(body, base + (size_t)rd_s32(b, field) * MP_SOUND_RECORD_BYTES, host));
    }
    return MP_OK;
}

/* 0x47c049: a picture id that no pair has used yet, else any. */
static int pick_id(MpObject *o, const MpHost *host, int32_t *id)
{
    uint8_t *b = o->b;
    const int32_t ids = rd_s32(b, O_IDS);
    int any_free = 0;
    int draws = 0;
    for (int32_t j = 0; j < ids; ++j)
        if (rd_s32(o->used, (size_t)j * 4u) == 0) {
            any_free = 1;
            break;
        }
    if (!any_free) {
        *id = host->random(host->context) % ids;
        return MP_OK;
    }
    do {
        if (++draws > MP_PICK_LIMIT) return MP_ERR_STUCK;
        *id = host->random(host->context) % ids;
    } while (rd_s32(o->used, (size_t)*id * 4u) != 0);
    wr_32(o->used, (size_t)*id * 4u, 1);
    return MP_OK;
}

/* A random free partner cell in [first, first + span): `r` is drawn with `_rand` % span until the cell is undealt. */
static int draw_partner(MpObject *o, const MpHost *host, int32_t first, int32_t span, int32_t *cell)
{
    int draws = 0;
    for (;;) {
        int32_t r;
        if (++draws > MP_PICK_LIMIT) return MP_ERR_STUCK;
        r = host->random(host->context) % span;
        *cell = first + r;
        if (rd_s32(cell_at(o, *cell), 0) == -1) return MP_OK;
    }
}

/* 0x47bb56: allocate the cells and the id table, count the pairs and deal the pictures. */
static int deal(MpObject *o, const uint8_t *body, const MpHost *host)
{
    uint8_t *b = o->b;
    const int32_t total = rd_s32(b, O_TOTAL), per_page = rd_s32(b, O_PER_PAGE), pages = rd_s32(body, B_PAGES);
    int32_t v;
    wr_32(b, O_FIRST, 0);
    wr_32(b, O_SECOND, 0);
    wr_32(b, O_CELLS, (int32_t)MP_GUEST_CELLS);
    memset(o->cells, 0, sizeof o->cells);
    for (wr_32(b, O_LOOP_I, 0); rd_s32(b, O_LOOP_I) < total; wr_32(b, O_LOOP_I, rd_s32(b, O_LOOP_I) + 1)) {
        uint8_t *c = cell_at_w(o, rd_s32(b, O_LOOP_I));
        wr_32(c, 0, -1);
        wr_32(c, 4, 0);
        wr_32(c, 8, 0);
    }
    wr_32(b, O_SLOTS, mul32(rd_s32(body, B_SLOT_COLS), rd_s32(body, B_SLOT_ROWS)));
    (void)scaled(rd_s32(body, B_PCT_IDS), rd_s32(b, O_SLOTS), &v);
    wr_32(b, O_IDS, v);
    if (rd_s32(b, O_IDS) <= 4) wr_32(b, O_IDS, 4);
    if (!(rd_s32(b, O_IDS) < rd_s32(b, O_SLOTS))) wr_32(b, O_IDS, rd_s32(b, O_SLOTS));
    wr_32(b, O_USED, (int32_t)MP_GUEST_USED);
    memset(o->used, 0, sizeof o->used);
    if (rd_s32(body, B_PCT_NEEDED) == -1) {
        wr_32(b, O_NEEDED, rd_s32(body, B_NEEDED_FIXED));
    } else {
        (void)scaled(rd_s32(body, B_PCT_NEEDED), rd_s32(b, O_HALF_TOTAL), &v);
        wr_32(b, O_NEEDED, v);
    }
    if (rd_s32(b, O_NEEDED) <= 2) wr_32(b, O_NEEDED, 2);
    if (!(rd_s32(b, O_NEEDED) < rd_s32(b, O_HALF_TOTAL))) wr_32(b, O_NEEDED, rd_s32(b, O_HALF_TOTAL));
    wr_32(b, O_TRIES, 0);
    wr_32(b, O_PAIRS, 0);
    /* body +0x346 is forced to 0 for one page (the original stores it). */
    if (pages == 1 || body[B_SHUFFLE_ALL] == 0) {
        for (int32_t page = 0; page < pages; ++page)
            for (int32_t col = 0; col < per_page; ++col) {
                int32_t id, partner;
                wr_32(b, O_CELL, add32(mul32(page, per_page), col));
                if (rd_s32(cell_at(o, rd_s32(b, O_CELL)), 0) == -1) {
                    CHECK(pick_id(o, host, &id));
                    wr_32(cell_at_w(o, rd_s32(b, O_CELL)), 0, id);
                    CHECK(draw_partner(o, host, page * per_page, per_page, &partner));
                    wr_32(cell_at_w(o, partner), 0, rd_s32(cell_at(o, rd_s32(b, O_CELL)), 0));
                }
            }
    } else {
        for (int32_t i = 0; i < total; ++i)
            if (rd_s32(cell_at(o, i), 0) == -1) {
                int32_t id, partner;
                CHECK(pick_id(o, host, &id));
                wr_32(cell_at_w(o, i), 0, id);
                CHECK(draw_partner(o, host, 0, total, &partner));
                wr_32(cell_at_w(o, partner), 0, rd_s32(cell_at(o, i), 0));
            }
    }
    wr_32(b, O_DEADLINE, 0);
    wr_32(b, O_FLIPBACK, 0);
    wr_32(b, O_PAGE, 0);
    wr_32(b, O_REDRAW, 1);
    return MP_OK;
}

/* 0x47b321 then 0x47b23b. */
int mp_cleanup(MpObject *object, const MpHost *host)
{
    uint8_t *b = object->b;
    if (!host_complete(host)) return MP_ERR_ARGUMENT;
    if (rd_s32(b, O_SURFACE) != 0) {
        HOST(host->release_surface(host->context, rd_u32(b, O_SURFACE)));
        wr_32(b, O_SURFACE, 0);
    }
    if (rd_s32(b, O_CELLS) != 0) wr_32(b, O_CELLS, 0);
    if (rd_s32(b, O_USED) != 0) wr_32(b, O_USED, 0);
    if (rd_s16(b, O_SLOT) != -1) HOST(host->release_slot(host->context, rd_s16(b, O_SLOT)));
    object_clear(b);
    return MP_OK;
}

int mp_invalidate(MpObject *object, const MpHost *host)
{
    const uint8_t *b = object->b;
    if (!host_complete(host)) return MP_ERR_ARGUMENT;
    if (rd_s32(b, O_ACTIVE) != 0 && rd_s16(b, O_SLOT) != -1) HOST(host->mark_dirty(host->context, rd_s16(b, O_SLOT)));
    return MP_OK;
}

/* A finish block (0x168e win, 0x16a8 lose): the scene-change cells, then the event flag. */
static int apply_block(const uint8_t *body, size_t block, const MpHost *host)
{
    MpTransition t;
    if (rd_s16(body, block) != MP_NO_SCENE) {
        t.scene = rd_s16(body, block);
        t.word[0] = rd_s16(body, block + 2);
        t.word[1] = rd_s16(body, block + 4);
        t.word[2] = rd_s16(body, block + 6);
        t.dword[0] = rd_s32(body, block + 8);
        t.dword[1] = rd_s32(body, block + 12);
        t.dword[2] = rd_s32(body, block + 16);
        t.start_flag = rd_s16(body, block + 0x14) != 1;
        HOST(host->transition(host->context, &t));
    }
    if (rd_s16(body, block + 0x16) != MP_NO_FLAG)
        HOST(host->store_event_flag(host->context, rd_s16(body, block + 0x16), rd_s16(body, block + 0x18)));
    return MP_OK;
}

static int block_flag_invalid(const uint8_t *body, size_t block, const MpHost *host)
{
    const int16_t index = rd_s16(body, block + 0x16);
    return index != MP_NO_FLAG && host->event_flag_invalid(host->context, index) != 0;
}

/* 0x47ba79: the flip-back timer. */
static int flip_back(MpObject *o, const MpHost *host)
{
    uint8_t *b = o->b;
    if (rd_s32(b, O_FLIPBACK) != 0 && rd_u32(b, O_DEADLINE) < host->tick(host->context)) {
        const int32_t c1 = cell_index(o, rd_u32(b, O_FIRST)), c2 = cell_index(o, rd_u32(b, O_SECOND));
        if (c1 < 0 || c2 < 0) return MP_ERR_BOUNDS;
        wr_32(cell_at_w(o, c1), 4, 0);
        wr_32(cell_at_w(o, c2), 4, 0);
        wr_32(b, O_FIRST, 0);
        wr_32(b, O_SECOND, 0);
        wr_32(b, O_FLIPBACK, 0);
        wr_32(b, O_DEADLINE, 0);
    }
    return MP_OK;
}

/* 0x47badf: win or lose after a try. */
static void check_end(MpObject *o, const uint8_t *body)
{
    uint8_t *b = o->b;
    if (rd_s32(b, O_PAIRS) < rd_s32(b, O_NEEDED) || rd_s32(body, B_TRIES) < rd_s32(b, O_TRIES)) {
        if (rd_s32(b, O_PAIRS) < rd_s32(b, O_NEEDED) && rd_s32(body, B_TRIES) <= rd_s32(b, O_TRIES)) wr_32(b, O_LOST, 1);
    } else {
        wr_32(b, O_WON, 1);
    }
}

int mp_step(MpObject *object, const uint8_t *body, size_t body_length, uint32_t body_handle, int16_t row, uint32_t phase,
            const MpHost *host, MpResult *result, const char **failure)
{
    uint8_t *b;
    if (object == NULL || body == NULL || result == NULL || !host_complete(host)) return MP_ERR_ARGUMENT;
    b = object->b;
    memset(result, 0, sizeof *result);
    result->phase_after = phase;
    if (phase > 2u) return MP_ERR_UNSUPPORTED;
    if (phase == 0u) {
        const int32_t pages = rd_s32(body, B_PAGES), cols = rd_s32(body, B_COLS), rows = rd_s32(body, B_ROWS);
        MpView view;
        int16_t slot = -1;
        uint32_t surface;
        CHECK(mp_validate_body(body, body_length, failure));
        wr_32(b, O_BODY, (int32_t)body_handle);
        wr_16(b, O_ROW, row);
        wr_32(b, O_ACTIVE, 1);
        HOST(host->set_start_flag(host->context, 1));
        HOST(host->clear_pending_item(host->context));
        if (body[B_RECENTER] != 0) HOST(host->recenter_cursor(host->context));
        wr_32(b, O_PER_PAGE, mul32(cols, rows));
        wr_32(b, O_TOTAL, mul32(rd_s32(b, O_PER_PAGE), pages));
        wr_32(b, O_HALF_PAGE, rd_s32(b, O_PER_PAGE) / 2);
        wr_32(b, O_HALF_TOTAL, rd_s32(b, O_TOTAL) / 2);
        HOST(host->view(host->context, &view));
        for (int k = 0; k < 4; ++k) wr_32(b, O_VIEW + (size_t)k * 4u, view.view[k]);
        for (int k = 0; k < 4; ++k) wr_32(b, O_VIEW_COPY + (size_t)k * 4u, rd_s32(b, O_VIEW + (size_t)k * 4u));
        for (wr_32(b, O_LOOP_I, 0); rd_s32(b, O_LOOP_I) < rd_s32(b, O_PER_PAGE); wr_32(b, O_LOOP_I, rd_s32(b, O_LOOP_I) + 1)) {
            const size_t i = (size_t)rd_s32(b, O_LOOP_I), s = B_TILES + i * 16u, d = O_TILE_RECTS + i * 16u;
            wr_32(b, d, add32(rd_s32(body, s), rd_s32(b, O_VIEW)));
            wr_32(b, d + 8, add32(rd_s32(body, s + 8), rd_s32(b, O_VIEW)));
            wr_32(b, d + 4, add32(rd_s32(body, s + 4), rd_s32(b, O_VIEW + 4)));
            wr_32(b, d + 12, add32(rd_s32(body, s + 12), rd_s32(b, O_VIEW + 4)));
        }
        if (body[B_TABS] != 0) {
            for (wr_32(b, O_LOOP_I, 0); rd_s32(b, O_LOOP_I) < pages; wr_32(b, O_LOOP_I, rd_s32(b, O_LOOP_I) + 1))
                for (wr_32(b, O_LOOP_J, 0); rd_s32(b, O_LOOP_J) < 3; wr_32(b, O_LOOP_J, rd_s32(b, O_LOOP_J) + 1)) {
                    const size_t k = (size_t)rd_s32(b, O_LOOP_I) * 0x30u + (size_t)rd_s32(b, O_LOOP_J) * 0x10u;
                    wr_32(b, O_TAB_HOT + k, add32(rd_s32(body, B_TAB_HOT + k), rd_s32(b, O_VIEW)));
                    wr_32(b, O_TAB_HOT + 8 + k, add32(rd_s32(body, B_TAB_HOT + 8 + k), rd_s32(b, O_VIEW)));
                    wr_32(b, O_TAB_HOT + 4 + k, add32(rd_s32(body, B_TAB_HOT + 4 + k), rd_s32(b, O_VIEW + 4)));
                    wr_32(b, O_TAB_HOT + 12 + k, add32(rd_s32(body, B_TAB_HOT + 12 + k), rd_s32(b, O_VIEW + 4)));
                }
            wr_32(b, O_TAB_TARGET, add32(rd_s32(body, B_TAB_TARGET), rd_s32(b, O_VIEW)));
            wr_32(b, O_TAB_TARGET + 8, add32(rd_s32(body, B_TAB_TARGET + 8), rd_s32(b, O_VIEW)));
            wr_32(b, O_TAB_TARGET + 4, add32(rd_s32(body, B_TAB_TARGET + 4), rd_s32(b, O_VIEW + 4)));
            wr_32(b, O_TAB_TARGET + 12, add32(rd_s32(body, B_TAB_TARGET + 12), rd_s32(b, O_VIEW + 4)));
        }
        HOST(host->alloc_slot(host->context, &slot));
        wr_16(b, O_SLOT, slot);
        HOST(host->register_slot(host->context, slot, LABEL_SLOT));
        if (rd_s32(b, O_SURFACE) == 0) {
            surface = 0;
            HOST(host->load_surface(host->context, (const char *)body + B_NAME, TAG_SURFACE, &surface));
            wr_32(b, O_SURFACE, (int32_t)surface);
        }
        HOST(host->set_slot_surface(host->context, slot, rd_u32(b, O_SURFACE)));
        CHECK(deal(object, body, host));
        wr_32(b, O_WON, 0);
        wr_32(b, O_LOST, 0);
        wr_32(b, O_REDRAW, 1);
        wr_32(b, O_STATE, 0);
        result->initialized = 1;
        result->phase_after = 1u;
        return MP_OK;
    }
    if (rd_s16(b, O_ROW) != row || rd_s32(b, O_ACTIVE) == 0) return MP_ERR_UNSUPPORTED;
    CHECK(mp_validate_body(body, body_length, failure));
    wr_32(b, O_BODY, (int32_t)body_handle);
    if (phase == 1u) {
        int32_t busy = 0;
        switch (rd_s32(b, O_STATE)) {
        case MP_STATE_PLAY:
            CHECK(flip_back(object, host));
            if (rd_s32(b, O_WON) != 0) {
                wr_32(b, O_STATE, 1);
                wr_32(b, O_REDRAW, 1);
            }
            if (rd_s32(b, O_LOST) != 0) {
                wr_32(b, O_STATE, 2);
                wr_32(b, O_REDRAW, 1);
            }
            break;
        case MP_STATE_WIN_PICK:
            CHECK(pick_and_play(object, body, B_SND_WIN, 10, O_SND_WIN, host));
            if (rd_s32(b, O_SND_WIN) == -1 ||
                no_sound_exact(body + B_SND_WIN + (size_t)rd_s32(b, O_SND_WIN) * MP_SOUND_RECORD_BYTES + SND_NAME))
                result->phase_after = 2u;
            else
                wr_32(b, O_STATE, MP_STATE_WIN_WAIT);
            break;
        case MP_STATE_LOSE_PICK:
            CHECK(pick_and_play(object, body, B_SND_WRONG, 10, O_SND_WRONG, host));
            if (rd_s32(b, O_SND_WRONG) == -1 ||
                no_sound_exact(body + B_SND_WRONG + (size_t)rd_s32(b, O_SND_WRONG) * MP_SOUND_RECORD_BYTES + SND_NAME))
                result->phase_after = 2u;
            else
                wr_32(b, O_STATE, MP_STATE_LOSE_WAIT);
            break;
        case MP_STATE_WIN_WAIT:
            HOST(host->sound_busy(host->context,
                                  rd_s16(body, B_SND_WIN + (size_t)rd_s32(b, O_SND_WIN) * MP_SOUND_RECORD_BYTES + SND_CHANNEL),
                                  &busy));
            if (busy == 0) result->phase_after = 2u;
            break;
        case MP_STATE_LOSE_WAIT:
            HOST(host->sound_busy(host->context,
                                  rd_s16(body, B_SND_WRONG + (size_t)rd_s32(b, O_SND_WRONG) * MP_SOUND_RECORD_BYTES + SND_CHANNEL),
                                  &busy));
            if (busy == 0) result->phase_after = 2u;
            break;
        default:
            break;
        }
        return MP_OK;
    }
    /* Phase 2: finish. */
    {
        const size_t block = rd_s32(b, O_WON) != 0 ? B_BLOCK_WIN : B_BLOCK_LOSE;
        const int apply = rd_s32(b, O_WON) != 0 || rd_s32(b, O_LOST) != 0;
        if (apply && block_flag_invalid(body, block, host)) return MP_ERR_BOUNDS;
        wr_32(b, O_ACTIVE, 0);
        if (apply) CHECK(apply_block(body, block, host));
        HOST(host->complete(host->context, rd_s16(b, O_ROW)));
        result->completed = 1;
        CHECK(mp_cleanup(object, host));
    }
    return MP_OK;
}

static void write_candidate(int32_t candidate, MpPointerResult *out)
{
    out->candidate = candidate;
    out->wrote_cursor = 1;
    out->cursor = 0;
    out->cursor_flag = 1;
}

int mp_pointer(MpObject *object, const uint8_t *body, size_t body_length, int16_t x16, int16_t y16, MpPointerResult *out)
{
    uint8_t *b;
    const int32_t x = x16, y = y16;
    if (object == NULL || out == NULL) return MP_ERR_ARGUMENT;
    b = object->b;
    memset(out, 0, sizeof *out);
    out->candidate = -1;
    if (rd_s32(b, O_ACTIVE) == 0 || rd_s32(b, O_WON) != 0 || rd_s32(b, O_LOST) != 0) return MP_OK;
    if (body == NULL || body_length < MP_BODY_BYTES) return MP_ERR_ARGUMENT;
    wr_32(b, O_HIT, -1);
    if (body[B_TABS] != 0) {
        for (int32_t j = 0; j < 3; ++j) {
            const size_t k = B_TAB_HOT + (size_t)rd_s32(b, O_PAGE) * 0x30u + (size_t)j * 0x10u;
            if (rd_s32(body, k + 4) <= y && y <= rd_s32(body, k + 12) && rd_s32(body, k) <= x && x <= rd_s32(body, k + 8)) {
                wr_32(b, O_HIT, j);
                write_candidate(MP_CANDIDATE_TAB, out);
                out->hit = 1;
                return MP_OK;
            }
        }
    }
    for (int32_t j = 0; j < rd_s32(b, O_PER_PAGE); ++j) {
        const size_t r = B_TILES + (size_t)j * 16u;
        wr_32(b, O_CELL, add32(mul32(rd_s32(b, O_PAGE), rd_s32(b, O_PER_PAGE)), j));
        if (add32(rd_s32(body, r + 4), 3) <= y && y <= add32(rd_s32(body, r + 12), -3) && add32(rd_s32(body, r), 3) <= x &&
            x <= add32(rd_s32(body, r + 8), -3)) {
            const int32_t c = rd_s32(b, O_CELL);
            if (c < 0 || c >= rd_s32(b, O_TOTAL)) return MP_ERR_BOUNDS;
            if (rd_s32(cell_at(object, c), 4) == 0 && rd_s32(cell_at(object, c), 8) == 0) {
                wr_32(b, O_HIT, j);
                write_candidate(MP_CANDIDATE_TILE, out);
                out->hit = 1;
                return MP_OK;
            }
        }
    }
    return MP_OK;
}

int mp_click(MpObject *object, const uint8_t *body, size_t body_length, uint32_t body_handle, uint32_t row_phase,
             int32_t candidate, const MpHost *host)
{
    uint8_t *b;
    if (object == NULL || !host_complete(host)) return MP_ERR_ARGUMENT;
    b = object->b;
    wr_32(b, O_BODY, (int32_t)body_handle);
    if (!(rd_s32(b, O_ACTIVE) != 0 && row_phase == 1u && rd_s32(b, O_STATE) == MP_STATE_PLAY &&
          (candidate == MP_CANDIDATE_TAB || candidate == MP_CANDIDATE_TILE)))
        return MP_OK;
    if (body == NULL || body_length < MP_BODY_BYTES) return MP_ERR_ARGUMENT;
    if (candidate == MP_CANDIDATE_TAB) {
        if (rd_s32(b, O_HIT) < 0 || rd_s32(b, O_HIT) >= rd_s32(body, B_PAGES)) return MP_ERR_BOUNDS;
        wr_32(b, O_PAGE, rd_s32(b, O_HIT));
        HOST(host->sound_play(host->context, MP_FLIP_CHANNEL));
        return MP_OK;
    }
    {
        const int32_t idx = add32(mul32(rd_s32(b, O_PAGE), rd_s32(b, O_PER_PAGE)), rd_s32(b, O_HIT));
        uint8_t *cell;
        if (idx < 0 || idx >= rd_s32(b, O_TOTAL)) return MP_ERR_BOUNDS;
        wr_32(b, O_CELL, idx);
        cell = cell_at_w(object, idx);
        if (rd_s32(cell, 8) == 0 && rd_s32(cell, 4) == 0 && (rd_s32(b, O_FIRST) == 0 || rd_s32(b, O_SECOND) == 0) &&
            rd_s32(b, O_FLIPBACK) == 0) {
            wr_32(cell, 4, 1);
            if (rd_s32(b, O_FIRST) == 0) {
                wr_32(b, O_FIRST, (int32_t)(MP_GUEST_CELLS + (uint32_t)idx * MP_CELL_BYTES));
                CHECK(play_record(body, B_SND_FLIP1, host));
            } else if (rd_s32(b, O_SECOND) == 0) {
                const int32_t c1 = cell_index(object, rd_u32(b, O_FIRST));
                if (c1 < 0) return MP_ERR_BOUNDS;
                CHECK(play_record(body, B_SND_FLIP2, host));
                wr_32(b, O_SECOND, (int32_t)(MP_GUEST_CELLS + (uint32_t)idx * MP_CELL_BYTES));
                if (rd_s32(cell_at(object, c1), 0) == rd_s32(cell, 0)) {
                    wr_32(b, O_PAIRS, rd_s32(b, O_PAIRS) + 1);
                    wr_32(b, O_TRIES, rd_s32(b, O_TRIES) + 1);
                    wr_32(cell_at_w(object, c1), 8, 1);
                    wr_32(cell, 8, 1);
                    wr_32(b, O_FIRST, 0);
                    wr_32(b, O_SECOND, 0);
                    check_end(object, body);
                    if (rd_s32(b, O_WON) == 0) CHECK(pick_and_play(object, body, B_SND_MATCH, 5, O_SND_MATCH, host));
                } else {
                    wr_32(b, O_TRIES, rd_s32(b, O_TRIES) + 1);
                    check_end(object, body);
                    if (rd_s32(b, O_LOST) == 0) CHECK(pick_and_play(object, body, B_SND_WRONG, 10, O_SND_WRONG, host));
                    wr_32(b, O_DEADLINE, (int32_t)(host->tick(host->context) + (uint32_t)rd_s32(body, B_DELAY)));
                    wr_32(b, O_FLIPBACK, 1);
                }
            }
        }
    }
    return MP_OK;
}

static void blit_plan(MpRenderPlan *plan, uint8_t src_kind, uint8_t label, const uint8_t *src, size_t src_off,
                      const int32_t *src_i, const uint8_t *dst, size_t dst_off)
{
    MpBlit *p = &plan->blit[plan->count++];
    p->src_kind = src_kind;
    p->label = label;
    for (int k = 0; k < 4; ++k) {
        p->src[k] = src_i != NULL ? src_i[k] : rd_s32(src, src_off + (size_t)k * 4u);
        p->dst[k] = rd_s32(dst, dst_off + (size_t)k * 4u);
    }
}

int mp_render_plan(MpObject *object, const uint8_t *body, size_t body_length, const MpHost *host, MpRenderPlan *plan)
{
    uint8_t *b;
    if (object == NULL || plan == NULL || !host_complete(host)) return MP_ERR_ARGUMENT;
    b = object->b;
    memset(plan, 0, sizeof *plan);
    if (rd_s32(b, O_ACTIVE) == 0) return MP_OK;
    if (body == NULL || body_length < MP_BODY_BYTES) return MP_ERR_ARGUMENT;
    plan->valid = 1;
    if (rd_s32(b, O_REDRAW) != 0) {
        MpView view;
        HOST(host->view(host->context, &view));
        blit_plan(plan, 0, MP_LABEL_BACKGROUND, NULL, 0, view.clip, b, O_VIEW_COPY);
        wr_32(b, O_REDRAW, 0);
    }
    if (body[B_TABS] != 0) blit_plan(plan, 1, MP_LABEL_TAB, body, B_TAB_SRC + (size_t)rd_s32(b, O_PAGE) * 0x10u, NULL, b, O_TAB_TARGET);
    {
        int32_t local = mul32(rd_s32(b, O_PAGE), rd_s32(b, O_PER_PAGE));
        for (int32_t j = 0; j < rd_s32(b, O_PER_PAGE); ++j, ++local) {
            const uint8_t *cell;
            if (local < 0 || local >= rd_s32(b, O_TOTAL)) return MP_ERR_BOUNDS;
            cell = cell_at(object, local);
            if (rd_s32(cell, 4) == 1) {
                const int32_t id = rd_s32(cell, 0);
                if (id < 0 || id >= MP_MAX_IDS) return MP_ERR_BOUNDS;
                blit_plan(plan, 1, MP_LABEL_VISIBLE, body, B_PICTURES + (size_t)id * 16u, NULL, b, O_TILE_RECTS + (size_t)j * 16u);
            } else {
                blit_plan(plan, 0, MP_LABEL_HIDDEN, body, B_TILES + (size_t)j * 16u, NULL, b, O_TILE_RECTS + (size_t)j * 16u);
            }
        }
    }
    return MP_OK;
}
