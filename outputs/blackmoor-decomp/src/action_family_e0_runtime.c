#include "action_family_e0_runtime.h"

#include <math.h>
#include <string.h>

/* Body offsets (see the header). */
enum {
    B_NAME_BYTES = 0x21,
    B_COUNT = 0x21,
    B_ORDERED = 0x23,
    B_HAS_EXIT = 0x24,
    B_EXIT_SRC = 0x25,
    B_EXIT_RECT = 0x35,
    B_ROUND0 = 0x45,
    B_SOUND_A = 0x66,
    B_CLICK_CHANNEL = 0x87,
    B_FAIL_BLOCK = 0x97,
    B_FAIL_START = 0xab,
    B_FAIL_FLAG = 0xad,
    B_FAIL_VALUE = 0xaf,
    B_DELAY = 0xb0,
    B_SOUND_B = 0xb2,
    B_WIN_CHANNEL = 0xd3,
    B_EXIT_BLOCK = 0xe3,
    B_EXIT_START = 0xf7,
    B_EXIT_FLAG = 0xf9,
    B_EXIT_VALUE = 0xfb,
    B_EXIT_AREA = 0xfc,
    B_ROUNDS = 0x10c,
    B_COLS = 0x10e,
    B_ROWS = 0x110,
    B_KEY_W = 0x112,
    B_KEY_H = 0x114,
    B_X0 = 0x116,
    B_Y0 = 0x118,
    B_XGAP = 0x11a,
    B_YGAP = 0x11c,
    B_X0B = 0x11e,
    B_Y0B = 0x120,
    B_XGAPB = 0x122,
    B_YGAPB = 0x124,
    B_LIGHT_SRC = 0x10e,
    B_LIGHT_DST = 0x15e,
    B_ACTIVE_SRC = 0x1ae,
    B_ACTIVE_DST = 0x1fe,
    B_BLINK = 0x24e,
    B_ROUND1 = 0x24f,
    B_SETS = 0x2d3,
    B_ALL_BLOCK = 0x2ec,
    B_ALL_START = 0x300,
    B_ALL_FLAG = 0x302,
    B_ALL_VALUE = 0x304,
    B_RECT_A = 0x305,
    B_RECT_B = 0x4e5
};

/* Offsets inside a scene block. */
enum { SB_SCENE = 0, SB_W1 = 2, SB_W2 = 4, SB_W3 = 6, SB_D1 = 8, SB_D2 = 12, SB_D3 = 16 };

static const char kEntryLabel[] = "KEYPAD PUZZLE OVERLAYS";

static int16_t rd_s16(const uint8_t *b, size_t off)
{
    return (int16_t)(uint16_t)(b[off] | (b[off + 1] << 8));
}

static int32_t rd_s32(const uint8_t *b, size_t off)
{
    return (int32_t)((uint32_t)b[off] | ((uint32_t)b[off + 1] << 8) | ((uint32_t)b[off + 2] << 16) |
                     ((uint32_t)b[off + 3] << 24));
}

static void wr_s16(uint8_t *b, size_t off, int16_t v)
{
    b[off] = (uint8_t)((uint16_t)v & 0xffu);
    b[off + 1] = (uint8_t)(((uint16_t)v >> 8) & 0xffu);
}

static void fx(const E0Host *host, int effect, int32_t a, int32_t b)
{
    if (host->observe != NULL) host->observe(host->context, effect, a, b);
}

/* The 9-byte comparison against "NO SOUND\0" (repe cmpsb with ecx = 9). */
static int no_sound(const uint8_t *name)
{
    static const uint8_t k[9] = {'N', 'O', ' ', 'S', 'O', 'U', 'N', 'D', 0};
    return memcmp(name, k, sizeof k) == 0;
}

#define HOST(call) do { if ((call) != 0) { return E0_ERR_HOST; } } while (0)

static int host_complete(const E0Host *h)
{
    return h != NULL && h->alloc_slot != NULL && h->register_slot != NULL && h->load_surface != NULL &&
           h->set_slot_surface != NULL && h->release_surface != NULL && h->release_slot != NULL &&
           h->mark_dirty != NULL && h->view_origin != NULL && h->sound_prepare != NULL && h->sound_stop != NULL &&
           h->sound_play != NULL && h->sound_busy != NULL && h->tick != NULL && h->transition != NULL &&
           h->store_event_flag != NULL && h->event_flag_invalid != NULL;
}

void e0_object_reset(E0Object *object)
{
    if (object == NULL) return;
    memset(object, 0, sizeof(*object));
    object->row = -1;
    object->slot = E0_NO_SLOT;
}

/* ------------------------------------------------------------------------------------------------------------------ */
/* body validation                                                                                                     */
/* ------------------------------------------------------------------------------------------------------------------ */
static int record_ok(const uint8_t *body, size_t off)
{
    const int16_t k = rd_s16(body, off);
    return off + E0_ROUND_BYTES <= E0_BODY_CAPACITY && k >= 0 && k <= E0_MAX_CODE;
}

int e0_validate_body(int flag, const uint8_t *body, size_t length, const char **failure)
{
    const char *why = NULL;
    int16_t n = 0;
    if (body == NULL || (flag != 0 && flag != 1)) {
        why = "keypad-argument";
    } else if (length != (flag == 0 ? E0_BODY_BYTES_D6 : E0_BODY_BYTES_E0)) {
        why = "keypad-body-length";
    } else if (memchr(body, 0, B_NAME_BYTES) == NULL) {
        why = "keypad-name-unterminated";
    } else {
        size_t i;
        for (i = length; i < E0_BODY_CAPACITY && why == NULL; ++i)
            if (body[i] != 0u) why = "keypad-padding-not-zero";
    }
    if (why == NULL) {
        if (flag == 1) {
            const int16_t cols = rd_s16(body, B_COLS);
            n = (int16_t)(int32_t)((int32_t)cols * (int32_t)rd_s16(body, B_ROWS));
            if (n > 0 && cols == 0) why = "keypad-zero-columns";
        } else {
            n = rd_s16(body, B_COUNT);
        }
        if (why == NULL && (n < 0 || n > E0_MAX_KEYS)) why = "keypad-key-count";
    }
    if (why == NULL && body[B_ORDERED] != 0u && n > E0_MAX_CODE) why = "keypad-ordered-key-count";
    if (why == NULL && !record_ok(body, B_ROUND0)) why = "keypad-code-length";
    if (why == NULL && flag == 0) {
        int sets = 0, seen_zero = 0;
        for (size_t j = 0; j < 4u && why == NULL; ++j)
            if (!record_ok(body, B_ROUND1 + j * E0_ROUND_BYTES)) why = "keypad-code-length";
        for (size_t s = 0; s < 5u && why == NULL; ++s) {
            if (body[B_SETS + 5u * s] != 0u) {
                ++sets;
                if (seen_zero) why = "keypad-code-sets-not-prefix";
            } else {
                seen_zero = 1;
            }
        }
        if (why == NULL && sets > 0 && n > E0_MAX_CODE - 1) why = "keypad-code-sets-key-count";
    }
    if (failure != NULL) *failure = why;
    return why == NULL ? E0_OK : E0_ERR_BODY;
}

/* ------------------------------------------------------------------------------------------------------------------ */
/* the shared pieces                                                                                                   */
/* ------------------------------------------------------------------------------------------------------------------ */
typedef struct Ctx {
    E0Object *o;
    uint8_t *b;
    E0World *world;
    const E0Host *h;
    uint32_t phase;
} Ctx;

/* The 33-byte round record copy (rep movsd x8 + movsb) to obj+0xd01. Native bound: the record must lie in the body and carry a
 * code length of 0..30 (the original copies whatever is there). */
static int load_record(E0Object *o, const uint8_t *body, long off)
{
    if (off < 0 || (size_t)off + E0_ROUND_BYTES > E0_BODY_CAPACITY) return E0_ERR_BOUNDS;
    if (rd_s16(body, (size_t)off) < 0 || rd_s16(body, (size_t)off) > E0_MAX_CODE) return E0_ERR_BOUNDS;
    o->code_len = rd_s16(body, (size_t)off);
    o->code_ordered = body[(size_t)off + 2];
    memcpy(o->code, body + (size_t)off + 3, E0_MAX_CODE);
    return E0_OK;
}

static void clear_player(E0Object *o)
{
    for (int i = 0; i < E0_MAX_CODE; ++i) o->player[i] = -1;
}

static void clear_lit(E0Object *o, int count)
{
    for (int i = 0; i < count; ++i) o->lit[i] = 0u;
}

static void set_phase(Ctx *c, uint32_t phase)
{
    c->phase = phase;
    fx(c->h, E0_FX_PHASE, (int32_t)phase, 0);
}

/* A scene block of phase 2 (exit and all-sets): the seven cells, the start flag from the block's start-flag word, mode 4.
 * The caller has already checked the scene word against 9999. */
static int apply_block(const uint8_t *blk, int16_t start_word, E0World *world, const E0Host *host)
{
    E0Transition t;
    t.scene = rd_s16(blk, SB_SCENE);
    t.word[0] = rd_s16(blk, SB_W1);
    t.word[1] = rd_s16(blk, SB_W2);
    t.word[2] = rd_s16(blk, SB_W3);
    t.dword[0] = rd_s32(blk, SB_D1);
    t.dword[1] = rd_s32(blk, SB_D2);
    t.dword[2] = rd_s32(blk, SB_D3);
    HOST(host->transition(host->context, &t));
    world->scene_cell_5bb57b = t.scene;
    fx(host, E0_FX_XFER_5BB57B, t.scene, 0);
    fx(host, E0_FX_XFER_5BB599, t.word[0], 0);
    fx(host, E0_FX_XFER_5BB595, t.word[1], 0);
    fx(host, E0_FX_XFER_5C39FF, t.word[2], 0);
    fx(host, E0_FX_XFER_5BB59B, t.dword[0], 0);
    fx(host, E0_FX_XFER_5BB59F, t.dword[1], 0);
    fx(host, E0_FX_XFER_5BB5A3, t.dword[2], 0);
    world->start_flag_5bb1ca = start_word == 1 ? 0 : 1;
    fx(host, E0_FX_START_FLAG, world->start_flag_5bb1ca, 0);
    fx(host, E0_FX_ENGINE_MODE, 4, 0);
    return E0_OK;
}

static int store_flag(const E0Host *host, int16_t index, uint8_t value)
{
    HOST(host->store_event_flag(host->context, index, value));
    fx(host, E0_FX_EVENT_FLAG, index, value);
    return E0_OK;
}

int e0_cleanup(E0Object *object, const E0Host *host)
{
    if (object == NULL || !host_complete(host)) return E0_ERR_ARGUMENT;
    if (object->surface != 0u) {
        const uint32_t surface = object->surface;
        HOST(host->release_surface(host->context, surface));
        object->surface = 0u;
        fx(host, E0_FX_RELEASE_SURFACE, (int32_t)surface, 0);
    }
    if (object->slot != E0_NO_SLOT) {
        const int16_t slot = object->slot;
        HOST(host->release_slot(host->context, slot));
        fx(host, E0_FX_RELEASE_SLOT, slot, 0);
    }
    /* 0x470d7a */
    object->row = -1;
    object->slot = -1;
    object->surface = 0u;
    object->active = 0u;
    object->exit_asked = 0u;
    object->solved = 0u;
    object->solved_sets = 0u;
    object->blink = 0u;
    object->initialized = 0u;
    return E0_OK;
}

int e0_invalidate(E0Object *object, const E0Host *host)
{
    if (object == NULL || !host_complete(host)) return E0_ERR_ARGUMENT;
    if (object->active != 0u && object->slot != E0_NO_SLOT) {
        HOST(host->mark_dirty(host->context, object->slot));
        fx(host, E0_FX_MARK_DIRTY, object->slot, 0);
    }
    return E0_OK;
}

void e0_scene_reset(E0Object *object)
{
    if (object == NULL) return;
    object->word_5957b5 = 0;
    object->round = 0;
}

/* ------------------------------------------------------------------------------------------------------------------ */
/* phase 0 (0x471786)                                                                                                  */
/* ------------------------------------------------------------------------------------------------------------------ */
static int phase0(Ctx *c, int flag, int16_t row)
{
    E0Object *o = c->o;
    uint8_t *b = c->b;
    const E0Host *h = c->h;
    int16_t slot = E0_NO_SLOT;
    int rc;
    o->active = 1u;
    o->flag = (uint8_t)flag;
    o->solved = 0u;
    o->waiting = 0u;
    c->world->start_flag_5bb1ca = 1;
    fx(h, E0_FX_START_FLAG, 1, 0);
    o->row = row;
    o->exit_asked = 0u;
    memset(o->rect_a, 0, sizeof(o->rect_a));
    memset(o->rect_b, 0, sizeof(o->rect_b));
    if (flag != 0) {
        const int16_t cols = rd_s16(b, B_COLS);
        const int16_t n = (int16_t)(int32_t)((int32_t)cols * (int32_t)rd_s16(b, B_ROWS));
        wr_s16(b, B_COUNT, n);
        for (int16_t i = 0; i < n; ++i) {
            const double q = floor((double)i / (double)cols);
            const int16_t qi = (int16_t)(int32_t)q;
            const int32_t rem = (int32_t)i % (int32_t)cols;
            const uint32_t w = (uint32_t)(int32_t)rd_s16(b, B_KEY_W);
            const uint32_t hgt = (uint32_t)(int32_t)rd_s16(b, B_KEY_H);
            uint32_t left, top;
            left = (uint32_t)(int32_t)rd_s16(b, B_X0) +
                   (uint32_t)rem * ((uint32_t)(int32_t)rd_s16(b, B_KEY_W) + (uint32_t)(int32_t)rd_s16(b, B_XGAP));
            top = (uint32_t)(int32_t)rd_s16(b, B_Y0) +
                  (uint32_t)(int32_t)qi * ((uint32_t)(int32_t)rd_s16(b, B_KEY_H) + (uint32_t)(int32_t)rd_s16(b, B_YGAP));
            o->rect_a[i][0] = (int32_t)left;
            o->rect_a[i][1] = (int32_t)top;
            o->rect_a[i][2] = (int32_t)(left + w);
            o->rect_a[i][3] = (int32_t)(top + hgt);
            left = (uint32_t)(int32_t)rd_s16(b, B_X0B) +
                   (uint32_t)rem * ((uint32_t)(int32_t)rd_s16(b, B_KEY_W) + (uint32_t)(int32_t)rd_s16(b, B_XGAPB));
            top = (uint32_t)(int32_t)rd_s16(b, B_Y0B) +
                  (uint32_t)(int32_t)qi * ((uint32_t)(int32_t)rd_s16(b, B_KEY_H) + (uint32_t)(int32_t)rd_s16(b, B_YGAPB));
            o->rect_b[i][0] = (int32_t)left;
            o->rect_b[i][1] = (int32_t)top;
            o->rect_b[i][2] = (int32_t)(left + w);
            o->rect_b[i][3] = (int32_t)(top + hgt);
        }
        o->rounds = 1;
        o->round = 0;
        o->set_count = 0;
        o->scene = rd_s16(b, B_ROUNDS);
    } else {
        for (int i = 0; i < 30; ++i)
            for (int k = 0; k < 4; ++k) {
                o->rect_a[i][k] = rd_s32(b, B_RECT_A + (size_t)i * 16u + (size_t)k * 4u);
                o->rect_b[i][k] = rd_s32(b, B_RECT_B + (size_t)i * 16u + (size_t)k * 4u);
            }
        o->rounds = rd_s16(b, B_ROUNDS);
        if (o->rounds > 0 && o->round == 0) o->round = 1;
        o->set_count = 0;
        for (int s = 0; s < 5; ++s)
            if (b[B_SETS + 5u * (size_t)s] != 0u) ++o->set_count;
        o->scene = E0_NO_SCENE;
    }
    if (o->round <= 1)
        rc = load_record(o, b, B_ROUND0);
    else
        rc = load_record(o, b, (long)B_ROUND1 + (long)((int32_t)o->round - 2) * (long)E0_ROUND_BYTES);
    if (rc != E0_OK) return rc;
    clear_lit(o, rd_s16(b, B_COUNT));
    clear_player(o);
    for (int i = 0; i < E0_MAX_CODE; ++i) o->record[i] = -1;
    o->typed = 0;
    o->recorded = 0;
    o->tiles_visible = 1u;
    o->exit_pending = 0u;
    HOST(h->alloc_slot(h->context, &slot));
    o->slot = slot;
    fx(h, E0_FX_SLOT, slot, 0);
    HOST(h->register_slot(h->context, slot, kEntryLabel, o->surface));
    fx(h, E0_FX_SLOT_REGISTER, slot, (int32_t)o->surface);
    if (o->surface == 0u) {
        uint32_t surface = 0u;
        HOST(h->load_surface(h->context, (const char *)b, &surface));
        o->surface = surface;
        fx(h, E0_FX_SURFACE_LOAD, (int32_t)surface, 0);
    }
    HOST(h->set_slot_surface(h->context, slot, o->surface));
    fx(h, E0_FX_SLOT_SURFACE, slot, (int32_t)o->surface);
    if (!no_sound(b + B_SOUND_A)) {
        HOST(h->sound_prepare(h->context, b + B_SOUND_A));
        fx(h, E0_FX_SOUND_PREPARE, B_SOUND_A, 0);
    }
    o->state = 0;
    o->initialized = 1u;
    set_phase(c, 1u);
    return E0_OK;
}

/* ------------------------------------------------------------------------------------------------------------------ */
/* phase 1 states                                                                                                      */
/* ------------------------------------------------------------------------------------------------------------------ */
static uint32_t do_tick(const E0Host *h)
{
    const uint32_t now = h->tick(h->context);
    fx(h, E0_FX_TICK, (int32_t)now, 0);
    return now;
}

/* The blink toggle shared by states 3 and 4 (0x47254f / 0x472653): only with the blink byte. */
static void blink_step(Ctx *c)
{
    E0Object *o = c->o;
    if (c->b[B_BLINK] != 0u) {
        const uint32_t now = do_tick(c->h);
        if (now >= o->blink_deadline) {
            o->blink = o->blink == 0u ? 1u : 0u;
            o->blink_deadline = do_tick(c->h) + 0x64u;
        }
    }
}

/* 0x4721b4 and 0x472346: the typed-code check and the ordered-mode wrap, after the waiting block. */
static void typed_checks(Ctx *c)
{
    E0Object *o = c->o;
    const uint8_t *b = c->b;
    if (o->code_len > 0 && o->waiting == 0u && o->typed == o->code_len) {
        o->solved = 1u;
        for (int16_t i = 0; i < o->code_len; ++i) {
            if (o->code_ordered != 0u) {
                if (o->player[i] != (int16_t)o->code[i]) {
                    o->solved = 0u;
                    break;
                }
            } else {
                int matched = 1;
                memcpy(o->scratch, o->player, sizeof(o->scratch));
                for (int16_t m = 0; m < o->code_len; ++m) {
                    matched = 0;
                    if (o->scratch[m] == (int16_t)o->code[i]) {
                        matched = 1;
                        /* the original stores -1 at index code_len, not at the matched index; scratch[30] is record[0] */
                        if (o->code_len == E0_MAX_CODE)
                            o->record[0] = -1;
                        else
                            o->scratch[o->code_len] = -1;
                        break;
                    }
                }
                if (!matched) {
                    o->solved = 0u;
                    break;
                }
            }
        }
    }
    if (b[B_ORDERED] != 0u && o->typed >= rd_s16(b, B_COUNT)) {
        clear_lit(o, E0_MAX_KEYS);
        clear_player(o);
        o->typed = 0;
    }
}

static int state0(Ctx *c)
{
    E0Object *o = c->o;
    const uint8_t *b = c->b;
    const E0Host *h = c->h;
    const int16_t n = rd_s16(b, B_COUNT);
    int clear_typed = 0;
    if (o->solved != 0u && o->waiting == 0u && b[B_HAS_EXIT] == 0u) {
        if (o->round > 0 && o->round < rd_s16(b, B_ROUNDS)) {
            o->solved = 0u;
            o->typed = 0;
            clear_player(o);
        }
        o->state = 1;
        return E0_OK;
    }
    if (o->waiting != 0u) {
        const uint32_t now = do_tick(h);
        if (now <= o->wait_deadline) return E0_OK;
        o->waiting = 0u;
        if (o->exit_pending != 0u) {
            o->exit_pending = 0u;
            o->recorded = 0;
            clear_typed = 1;
            if (o->solved != 0u) {
                if (o->round > 0 && o->round < rd_s16(b, B_ROUNDS)) o->solved = 0u;
                o->state = 1;
            } else if (o->set_count > 0) {
                for (int16_t i = 0; i < o->set_count; ++i) {
                    int flagm = 0;
                    for (int j = 0; j < 5; ++j) {
                        const uint8_t code = b[B_SETS + 5u * (size_t)i + (size_t)j];
                        if (code == 0u) break;
                        flagm = 0;
                        for (int16_t m = 0; m < n; ++m) {
                            if (o->record[m] == (int16_t)code - 1) {
                                flagm = 1;
                                o->record[n] = -1; /* index N, not m (original) */
                                break;
                            }
                        }
                        if (!flagm) break;
                    }
                    if (flagm) {
                        o->solved_sets = 1u;
                        set_phase(c, 2u);
                    }
                }
                for (int i = 0; i < E0_MAX_CODE; ++i) o->record[i] = -1;
                o->recorded = 0;
            } else {
                if ((o->typed == 0 || b[B_ORDERED] == 0u) && o->scene != E0_NO_SCENE) {
                    o->state = 1;
                } else {
                    clear_lit(o, E0_MAX_KEYS);
                }
            }
        } else if (o->hover != E0_EXIT_KEY) {
            for (int16_t i = 0; i < n; ++i)
                if (o->lit[i] != 0u) o->lit[i] = 0u;
        }
    }
    if (clear_typed) {
        clear_player(o);
        o->typed = 0;
    }
    typed_checks(c);
    return E0_OK;
}

static int next_round(Ctx *c)
{
    E0Object *o = c->o;
    int rc = load_record(o, c->b, (long)B_ROUND1 + (long)((int32_t)o->round - 1) * (long)E0_ROUND_BYTES);
    if (rc != E0_OK) return rc;
    o->round = (int16_t)(o->round + 1);
    o->blink = 0u;
    o->state = 0;
    return E0_OK;
}

static int state1(Ctx *c)
{
    E0Object *o = c->o;
    const uint32_t first = do_tick(c->h);
    o->show_deadline = first + (uint32_t)((int32_t)rd_s16(c->b, B_DELAY) * 1000 + 0x190);
    o->blink_deadline = do_tick(c->h) + 0x64u;
    o->state = 3;
    return E0_OK;
}

static int state3(Ctx *c)
{
    E0Object *o = c->o;
    const uint8_t *b = c->b;
    const E0Host *h = c->h;
    const uint32_t now = do_tick(h);
    if (now < o->show_deadline) {
        blink_step(c);
        return E0_OK;
    }
    if (o->scene != E0_NO_SCENE && o->scene != 0 && o->typed == 0) {
        set_phase(c, 2u);
        return E0_OK;
    }
    if (!no_sound(b + B_SOUND_B)) {
        HOST(h->sound_prepare(h->context, b + B_SOUND_B));
        fx(h, E0_FX_SOUND_PREPARE, B_SOUND_B, 0);
        HOST(h->sound_play(h->context, rd_s16(b, B_WIN_CHANNEL)));
        fx(h, E0_FX_SOUND_PLAY, rd_s16(b, B_WIN_CHANNEL), 0);
        o->state = 4;
        return E0_OK;
    }
    if (o->solved != 0u) {
        set_phase(c, 2u);
        return E0_OK;
    }
    return next_round(c);
}

static int state4(Ctx *c)
{
    E0Object *o = c->o;
    const uint8_t *b = c->b;
    const E0Host *h = c->h;
    int32_t busy = 0;
    const int16_t channel = rd_s16(b, B_WIN_CHANNEL);
    HOST(h->sound_busy(h->context, channel, &busy));
    fx(h, E0_FX_SOUND_BUSY, channel, busy);
    if (busy == 0) {
        HOST(h->sound_stop(h->context, b + B_SOUND_B));
        fx(h, E0_FX_SOUND_STOP, B_SOUND_B, 0);
        if (o->solved != 0u) {
            set_phase(c, 2u);
            return E0_OK;
        }
        return next_round(c);
    }
    blink_step(c);
    return E0_OK;
}

/* ------------------------------------------------------------------------------------------------------------------ */
/* phase 2 (0x4726a3)                                                                                                  */
/* ------------------------------------------------------------------------------------------------------------------ */
static int flag_invalid(const E0Host *h, int16_t index)
{
    return index != E0_NO_FLAG && h->event_flag_invalid(h->context, index) != 0;
}

static int phase2(Ctx *c, E0Result *result)
{
    E0Object *o = c->o;
    const uint8_t *b = c->b;
    const E0Host *h = c->h;
    E0World *w = c->world;
    const int exit_branch = o->exit_asked != 0u;
    const int sets_branch = !exit_branch && o->solved_sets != 0u;
    int fail_assigns = 0;
    int32_t fail_scene = 0;
    int16_t flag_index;
    uint8_t flag_value;
    /* native: validate the event flag index of the chosen branch before the first effect */
    if (exit_branch) {
        flag_index = rd_s16(b, B_EXIT_FLAG);
        flag_value = b[B_EXIT_VALUE];
    } else if (sets_branch) {
        flag_index = rd_s16(b, B_ALL_FLAG);
        flag_value = b[B_ALL_VALUE];
    } else {
        flag_index = rd_s16(b, B_FAIL_FLAG);
        flag_value = b[B_FAIL_VALUE];
    }
    if (flag_invalid(h, flag_index)) return E0_ERR_BOUNDS;
    w->start_flag_5bb1ca = 1;
    fx(h, E0_FX_START_FLAG, 1, 0);
    o->blink = 0u;
    o->active = 0u;
    w->entry17_active_5d1a8f = 0;
    fx(h, E0_FX_ENTRY17_ACTIVE, 0, 0);
    if (!no_sound(b + B_SOUND_A)) {
        HOST(h->sound_stop(h->context, b + B_SOUND_A));
        fx(h, E0_FX_SOUND_STOP, B_SOUND_A, 0);
    }
    if (exit_branch) {
        if (rd_s16(b, B_EXIT_BLOCK) != E0_NO_SCENE) {
            const int rc = apply_block(b + B_EXIT_BLOCK, rd_s16(b, B_EXIT_START), w, h);
            if (rc != E0_OK) return rc;
        }
    } else if (sets_branch) {
        if (rd_s16(b, B_ALL_BLOCK) != E0_NO_SCENE) {
            const int rc = apply_block(b + B_ALL_BLOCK, rd_s16(b, B_ALL_START), w, h);
            if (rc != E0_OK) return rc;
        }
    } else {
        if (o->solved == 0u && o->scene != E0_NO_SCENE && o->scene != 0 && o->typed == 0) {
            fail_scene = o->scene;
            fail_assigns = 1;
        } else if (rd_s16(b, B_FAIL_BLOCK) != E0_NO_SCENE) {
            fail_scene = rd_s16(b, B_FAIL_BLOCK);
            fail_assigns = 1;
        }
        if (fail_assigns) {
            w->scene_cell_5bb57b = fail_scene;
            fx(h, E0_FX_XFER_5BB57B, fail_scene, 0);
        }
        if (w->scene_cell_5bb57b != E0_NO_SCENE) {
            E0Transition t;
            t.scene = w->scene_cell_5bb57b;
            t.word[0] = rd_s16(b, B_FAIL_BLOCK + SB_W1);
            t.word[1] = rd_s16(b, B_FAIL_BLOCK + SB_W2);
            t.word[2] = rd_s16(b, B_FAIL_BLOCK + SB_W3);
            t.dword[0] = rd_s32(b, B_FAIL_BLOCK + SB_D1);
            t.dword[1] = rd_s32(b, B_FAIL_BLOCK + SB_D2);
            t.dword[2] = rd_s32(b, B_FAIL_BLOCK + SB_D3);
            HOST(h->transition(h->context, &t));
            fx(h, E0_FX_XFER_5BB599, t.word[0], 0);
            fx(h, E0_FX_XFER_5BB595, t.word[1], 0);
            fx(h, E0_FX_XFER_5C39FF, t.word[2], 0);
            fx(h, E0_FX_XFER_5BB59B, t.dword[0], 0);
            fx(h, E0_FX_XFER_5BB59F, t.dword[1], 0);
            fx(h, E0_FX_XFER_5BB5A3, t.dword[2], 0);
            w->start_flag_5bb1ca = rd_s16(b, B_FAIL_START) == 1 ? 0 : 1;
            fx(h, E0_FX_START_FLAG, w->start_flag_5bb1ca, 0);
            fx(h, E0_FX_ENGINE_MODE, 4, 0);
        }
    }
    if (flag_index != E0_NO_FLAG) {
        const int rc = store_flag(h, flag_index, flag_value);
        if (rc != E0_OK) return rc;
    }
    fx(h, E0_FX_COMPLETE, o->row, 0);
    {
        const int rc = e0_cleanup(o, h);
        if (rc != E0_OK) return rc;
    }
    result->completed = 1u;
    c->phase = 2u;
    return E0_OK;
}

/* ------------------------------------------------------------------------------------------------------------------ */
/* step                                                                                                                */
/* ------------------------------------------------------------------------------------------------------------------ */
int e0_step(E0Object *object, uint8_t *body, size_t body_length, int flag, int16_t row, uint32_t phase, E0World *world,
            const E0Host *host, E0Result *result, const char **failure)
{
    Ctx c;
    int rc;
    if (failure != NULL) *failure = NULL;
    if (object == NULL || body == NULL || world == NULL || result == NULL || !host_complete(host))
        return E0_ERR_ARGUMENT;
    memset(result, 0, sizeof(*result));
    result->phase_after = phase;
    if (phase > 2u) return E0_OK;
    if (e0_validate_body(flag, body, body_length, failure) != E0_OK) return E0_ERR_BODY;
    if (phase != 0u && (object->initialized == 0u || object->row != row)) {
        if (failure != NULL) *failure = "keypad-phase-without-init";
        return E0_ERR_UNSUPPORTED;
    }
    c.o = object;
    c.b = body;
    c.world = world;
    c.h = host;
    c.phase = phase;
    switch (phase) {
    case 0u:
        rc = phase0(&c, flag, row);
        if (rc == E0_OK) result->initialized = 1u;
        break;
    case 1u:
        switch (object->state) {
        case 0: rc = state0(&c); break;
        case 1: rc = state1(&c); break;
        case 3: rc = state3(&c); break;
        case 4: rc = state4(&c); break;
        default: rc = E0_OK; break;
        }
        break;
    default:
        rc = phase2(&c, result);
        break;
    }
    result->phase_after = c.phase;
    return rc;
}

/* ------------------------------------------------------------------------------------------------------------------ */
/* pointer and click                                                                                                   */
/* ------------------------------------------------------------------------------------------------------------------ */
static void pointer_hit(E0PointerResult *out, int cursor, int32_t candidate)
{
    out->hit = 1u;
    out->cursor = (uint8_t)cursor;
    out->candidate = candidate;
}

int e0_pointer_move(E0Object *o, const uint8_t *b, size_t body_length, int32_t xin, int32_t yin, E0PointerResult *out)
{
    const int32_t x = (int16_t)xin;
    const int32_t y = (int16_t)yin;
    (void)body_length;
    if (o == NULL || b == NULL || out == NULL) return E0_ERR_ARGUMENT;
    memset(out, 0, sizeof(*out));
    out->candidate = -1;
    if (o->active != 0u) {
        const int16_t n = rd_s16(b, B_COUNT);
        if (y >= rd_s32(b, B_EXIT_AREA + 4) && y <= rd_s32(b, B_EXIT_AREA + 12) && x >= rd_s32(b, B_EXIT_AREA) &&
            x <= rd_s32(b, B_EXIT_AREA + 8)) {
            pointer_hit(out, E0_CURSOR_EXIT, E0_CANDIDATE_EXIT);
            return E0_OK;
        }
        for (int16_t i = 0; i < n && i < E0_MAX_KEYS; ++i) {
            if (o->waiting == 0u && y >= o->rect_b[i][1] && y <= o->rect_b[i][3] && x >= o->rect_b[i][0] &&
                x <= o->rect_b[i][2]) {
                pointer_hit(out, E0_CURSOR_PICK, E0_CANDIDATE_KEY);
                o->hover = i;
                return E0_OK;
            }
        }
        if (o->waiting == 0u && b[B_HAS_EXIT] != 0u && y >= rd_s32(b, B_EXIT_RECT + 4) &&
            y <= rd_s32(b, B_EXIT_RECT + 12) && x >= rd_s32(b, B_EXIT_RECT) && x <= rd_s32(b, B_EXIT_RECT + 8)) {
            pointer_hit(out, E0_CURSOR_PICK, E0_CANDIDATE_KEY);
            o->hover = E0_EXIT_KEY;
            return E0_OK;
        }
    }
    o->hover = -1;
    return E0_OK;
}

int e0_click(E0Object *o, const uint8_t *b, size_t body_length, uint32_t row_phase, int32_t candidate,
             int32_t start_flag, const E0Host *h, uint32_t *new_phase)
{
    (void)body_length;
    if (o == NULL || b == NULL || new_phase == NULL || !host_complete(h)) return E0_ERR_ARGUMENT;
    *new_phase = row_phase;
    if (o->active == 0u || o->state != 0 || row_phase != 1u) return E0_OK;
    if (o->hover != E0_EXIT_KEY && candidate == E0_CANDIDATE_KEY && (o->hover < 0 || o->hover >= E0_MAX_KEYS))
        return E0_ERR_BOUNDS;
    if (o->hover != E0_EXIT_KEY && candidate == E0_CANDIDATE_KEY) {
        const int16_t hv = o->hover;
        const int16_t n = rd_s16(b, B_COUNT);
        if (o->lit[hv] != 0u && b[B_ORDERED] != 0u) {
            int16_t t;
            o->lit[hv] = 0u;
            t = (int16_t)(o->typed - 1);
            if (t < 0) t = 0;
            if (o->player[t] == o->hover) {
                o->typed = (int16_t)(o->typed - 1);
                if (o->typed < 0) o->typed = 0;
                o->player[o->typed] = -1;
            }
        } else if (b[B_ORDERED] != 0u) {
            if (o->typed <= n - 1) o->player[o->typed] = o->hover;
            if (o->lit[hv] == 0u) {
                o->typed = (int16_t)(o->typed + 1);
                o->lit[hv] = 1u;
            }
            if (o->typed > n) o->typed = n;
        } else if (o->lit[hv] == 0u) {
            o->typed = (int16_t)(o->typed + 1);
            if (o->code_len > 0 && o->typed > o->code_len) o->typed = o->code_len;
            o->lit[hv] = 1u;
            o->wait_deadline = do_tick(h) + 0x12cu;
            o->waiting = 1u;
            for (int16_t i = 0; i < o->code_len - 1; ++i) o->player[i] = o->player[i + 1];
            if (o->code_len == 0)
                o->pad_d48 = o->hover;
            else
                o->player[o->code_len - 1] = o->hover;
        }
        if (o->set_count > 0 && o->recorded <= n - 1) {
            o->record[o->recorded] = o->hover;
            o->recorded = (int16_t)(o->recorded + 1);
        }
        if (start_flag != 0 && !no_sound(b + B_SOUND_A)) {
            HOST(h->sound_play(h->context, rd_s16(b, B_CLICK_CHANNEL)));
            fx(h, E0_FX_SOUND_PLAY, rd_s16(b, B_CLICK_CHANNEL), 0);
        }
    }
    if (b[B_HAS_EXIT] != 0u && o->hover == E0_EXIT_KEY) {
        o->exit_pending = 1u;
        o->wait_deadline = do_tick(h) + 0x12cu;
        if (start_flag != 0 && !no_sound(b + B_SOUND_A)) {
            HOST(h->sound_play(h->context, rd_s16(b, B_CLICK_CHANNEL)));
            fx(h, E0_FX_SOUND_PLAY, rd_s16(b, B_CLICK_CHANNEL), 0);
        }
    }
    if (candidate == E0_CANDIDATE_EXIT) {
        o->exit_asked = 1u;
        *new_phase = 2u;
        fx(h, E0_FX_PHASE, 2, 0);
    }
    return E0_OK;
}

/* ------------------------------------------------------------------------------------------------------------------ */
/* render                                                                                                              */
/* ------------------------------------------------------------------------------------------------------------------ */
static int add_blit(E0RenderPlan *plan, int kind, int role, const int32_t src[4], int32_t vx, int32_t vy,
                    const int32_t dst_raw[4])
{
    E0Blit *bl;
    if (plan->count >= E0_MAX_BLITS) return E0_ERR_BOUNDS;
    bl = &plan->blit[plan->count++];
    bl->kind = (uint8_t)kind;
    bl->role = (uint8_t)role;
    for (int k = 0; k < 4; ++k) bl->src[k] = src[k];
    bl->dst[0] = dst_raw[0] + vx;
    bl->dst[1] = dst_raw[1] + vy;
    bl->dst[2] = dst_raw[2] + vx;
    bl->dst[3] = dst_raw[3] + vy;
    return E0_OK;
}

static void rd_rect(const uint8_t *b, size_t off, int32_t r[4])
{
    for (int k = 0; k < 4; ++k) r[k] = rd_s32(b, off + (size_t)k * 4u);
}

int e0_render_plan(E0Object *o, const uint8_t *b, size_t body_length, const E0Host *host, E0RenderPlan *plan)
{
    int32_t vx = 0, vy = 0;
    int32_t src[4], dst[4];
    (void)body_length;
    if (o == NULL || b == NULL || plan == NULL || !host_complete(host)) return E0_ERR_ARGUMENT;
    memset(plan, 0, sizeof(*plan));
    if (o->tiles_visible == 0u) return E0_OK;
    HOST(host->view_origin(host->context, &vx, &vy));
    plan->valid = 1u;
    plan->surface = o->surface;
    for (int16_t i = 0; i < rd_s16(b, B_COUNT); ++i) {
        int rc;
        if (i >= E0_MAX_KEYS) return E0_ERR_BOUNDS;
        if (o->lit[i] != 0u)
            rc = add_blit(plan, E0_BLIT_SHEET_KEYED, E0_ROLE_KEY_DOWN, o->rect_a[i], vx, vy, o->rect_b[i]);
        else
            rc = add_blit(plan, E0_BLIT_BG_OPAQUE, E0_ROLE_KEY_UP, o->rect_b[i], vx, vy, o->rect_b[i]);
        if (rc != E0_OK) return rc;
    }
    if (o->flag == 0u) {
        for (int16_t i = 0; i < o->round; ++i) {
            const size_t d = B_LIGHT_DST + (size_t)i * 16u;
            int rc;
            if (d + 16u > E0_BODY_CAPACITY || B_LIGHT_SRC + (size_t)i * 16u + 16u > E0_BODY_CAPACITY)
                return E0_ERR_BOUNDS;
            rd_rect(b, d, dst);
            if (dst[3] - dst[1] != 0) {
                rd_rect(b, B_LIGHT_SRC + (size_t)i * 16u, src);
                rc = add_blit(plan, E0_BLIT_SHEET_KEYED, E0_ROLE_ROUND_LIGHT, src, vx, vy, dst);
                if (rc != E0_OK) return rc;
            }
        }
        if (o->round > 0) {
            const size_t last = (size_t)(o->round - 1);
            const size_t d = B_ACTIVE_DST + last * 16u;
            if (d + 16u > E0_BODY_CAPACITY || B_ACTIVE_SRC + last * 16u + 16u > E0_BODY_CAPACITY)
                return E0_ERR_BOUNDS;
            rd_rect(b, d, dst);
            if (dst[3] - dst[1] != 0) {
                int rc;
                if (o->blink != 0u) {
                    rc = add_blit(plan, E0_BLIT_BG_KEYED, E0_ROLE_ACTIVE_ERASE, dst, vx, vy, dst);
                } else {
                    rd_rect(b, B_ACTIVE_SRC + last * 16u, src);
                    rc = add_blit(plan, E0_BLIT_SHEET_KEYED, E0_ROLE_ACTIVE_LIGHT, src, vx, vy, dst);
                }
                if (rc != E0_OK) return rc;
            }
        }
    }
    {
        int rc;
        rd_rect(b, B_EXIT_RECT, dst);
        if (o->exit_pending != 0u) {
            rd_rect(b, B_EXIT_SRC, src);
            rc = add_blit(plan, E0_BLIT_SHEET_KEYED, E0_ROLE_EXIT_DOWN, src, vx, vy, dst);
            o->waiting = 1u;
        } else {
            rc = add_blit(plan, E0_BLIT_BG_KEYED, E0_ROLE_EXIT_UP, dst, vx, vy, dst);
        }
        if (rc != E0_OK) return rc;
    }
    return E0_OK;
}

/* ------------------------------------------------------------------------------------------------------------------ */
/* image                                                                                                               */
/* ------------------------------------------------------------------------------------------------------------------ */
static void put8(uint8_t *image, uint8_t *mask, size_t off, uint8_t v)
{
    image[off] = v;
    mask[off] = 1u;
}

static void put16(uint8_t *image, uint8_t *mask, size_t off, uint16_t v)
{
    put8(image, mask, off, (uint8_t)(v & 0xffu));
    put8(image, mask, off + 1u, (uint8_t)(v >> 8));
}

static void put32(uint8_t *image, uint8_t *mask, size_t off, uint32_t v)
{
    for (int k = 0; k < 4; ++k) put8(image, mask, off + (size_t)k, (uint8_t)((v >> (8 * k)) & 0xffu));
}

void e0_object_pack(const E0Object *o, uint8_t image[E0_IMAGE_BYTES], uint8_t mask[E0_IMAGE_BYTES])
{
    memset(image, 0, E0_IMAGE_BYTES);
    memset(mask, 0, E0_IMAGE_BYTES);
    for (int i = 0; i < E0_MAX_KEYS; ++i)
        for (int k = 0; k < 4; ++k) {
            put32(image, mask, 0x1cu + (size_t)i * 16u + (size_t)k * 4u, (uint32_t)o->rect_a[i][k]);
            put32(image, mask, 0x65cu + (size_t)i * 16u + (size_t)k * 4u, (uint32_t)o->rect_b[i][k]);
        }
    for (int i = 0; i < E0_MAX_KEYS; ++i) put8(image, mask, 0xc9cu + (size_t)i, o->lit[i]);
    put8(image, mask, 0xd00, o->tiles_visible);
    put16(image, mask, 0xd01, (uint16_t)o->code_len);
    put8(image, mask, 0xd03, o->code_ordered);
    for (int i = 0; i < E0_MAX_CODE; ++i) put8(image, mask, 0xd04u + (size_t)i, o->code[i]);
    put16(image, mask, 0xd22, (uint16_t)o->rounds);
    put32(image, mask, 0xd24, o->surface);
    put16(image, mask, 0xd28, (uint16_t)o->row);
    put16(image, mask, 0xd2a, (uint16_t)o->hover);
    put32(image, mask, 0xd2c, (uint32_t)o->state);
    put16(image, mask, 0xd30, (uint16_t)o->recorded);
    put16(image, mask, 0xd32, (uint16_t)o->typed);
    put16(image, mask, 0xd38, (uint16_t)o->slot);
    put8(image, mask, 0xd3a, o->exit_pending);
    put8(image, mask, 0xd3b, o->waiting);
    put8(image, mask, 0xd3c, o->blink);
    put8(image, mask, 0xd3d, o->flag);
    put8(image, mask, 0xd3e, o->active);
    put8(image, mask, 0xd3f, o->exit_asked);
    put32(image, mask, 0xd40, o->blink_deadline);
    put32(image, mask, 0xd44, o->show_deadline);
    put16(image, mask, 0xd48, (uint16_t)o->pad_d48);
    for (int i = 0; i < E0_MAX_CODE; ++i) {
        put16(image, mask, 0xd4au + (size_t)i * 2u, (uint16_t)o->player[i]);
        put16(image, mask, 0xd86u + (size_t)i * 2u, (uint16_t)o->scratch[i]);
        put16(image, mask, 0xdc2u + (size_t)i * 2u, (uint16_t)o->record[i]);
    }
    put8(image, mask, 0xdfe, o->solved);
    put8(image, mask, 0xdff, o->solved_sets);
    put32(image, mask, 0xe00, o->wait_deadline);
    put16(image, mask, 0xe06, (uint16_t)o->set_count);
    put16(image, mask, 0xe08, (uint16_t)o->scene);
}
