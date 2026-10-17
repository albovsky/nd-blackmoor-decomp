#ifndef BLACKMOOR_ACTION_FAMILY_F6_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_F6_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0xf6, the card puzzle ("CCardPuzzle", RT-47). The corpus is the two-player 10 x 3 card game of the
 * Betty puzzle (resources 1736, 1738: "GRE_BettyPUZ_OVL") and the Skull Bones puzzle (resource 2300).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x427a50  dispatcher arm 0xf6 (0x42a92b): gate 0x423f57(deps, 0), then 0x45f0e6(ECX = 0x61f4b1, row). The object
 *             (CCardPuzzle, 0x3af bytes used) is one static singleton.
 *   0x4109f8  loader (0x40b34a): copies the 4,934-byte typed body into a fresh row allocation (0x45ddd0); the
 *             decoder is src/action_family_f6.[ch].
 *   0x45f0e6  the handler: a phase switch on the row phase dword (0x5bb632 + row * 0x8d). Phase 0 init (sets the row
 *             phase to 1), phase 1 a state machine on obj+0x39e (states 1..12, any other value does nothing), phase 2
 *             the finish: scene change block or exit block, 0x42ba3a(row), cleanup 0x45dd4d.
 *   0x45de8a  deal / "no card" step (random pick, `_rand` 0x50cd50), 0x45e6bd pick a line from a name list at random,
 *             play it (0x4fb77a, 0x4fb2e3) and show the caption (0x423259 on AUTOTEXT 0x619a6b, 0x448d11 on the
 *             caption object 0x619a05), 0x45e67d "name is a real sound", 0x45e906 move one card between players,
 *             0x45e9db find a card of a column, 0x45ea4a / 0x45eadc refill checks, 0x45eb76 pick the computer's column
 *             (random), 0x45ed60 / 0x45ef5a start a card animation, 0x45dd4d cleanup, 0x45dc8a reset.
 *   0x45e1ca  pointer hit test (cascade 0x4f0059 at 0x4f0f0f, x = [ptr+0x5e], y = [ptr+0x5a], view relative);
 *             0x45e4d4 writes the cursor index, the candidate [0x5c39e5] and the cursor sprite cells.
 *   0x45e587  click (accepted-release chain 0x43b287 at 0x43b372), 0x45dd96 slot invalidate (0x43d91f at 0x43da23),
 *             0x45dd4d cleanup (0x438c7f, 0x43df56), 0x460f26 the render callback of generic Z entry type 10.
 * Every engine call whose body lies outside this slice is a callback of F6Host in the original order; the random source
 * is the host too. Nothing here claims original source structure.
 *
 * Typed body, offsets from the start of the 4,934-byte body (words signed, dwords signed; a "rect" is four dwords
 * left, top, right, bottom, view relative; a "name" is 0x21 bytes, NUL terminated):
 *   +0x00 name of the overlay image (CIFTREE, "CARD GAME Puzzle Surface")   +0x21 byte A   +0x22 byte B   +0x23 byte C
 *   +0x24 byte mode (0, 2, other)   +0x25 columns (word, 1..13)   +0x27 rows (word, 1..3)   +0x29 cards dealt each
 *   +0x2b + 16 p "turn marker" source rect per player   +0x4b + 16 p turn marker destination rect
 *   +0x6b + 0xd0 r + 16 c face-up card source rect   +0x3ab + 16 i button-down source   +0x47b suit score source rect
 *   +0x48b + 0xd0 p + 16 i suit score destination   +0x62b / +0x62d / +0x62f card slide: steps, step, interval
 *   +0x633 + 16 i display rects   +0x653 + 16 c button rects   +0x723 + 0xd0 r + 16 c card rects
 *   +0x993 / +0x995 / +0x997 card delivery animation: frames, passes, interval   +0x99b + 16 i frame rects
 *   +0xa8b rect   +0xa9b / +0xa9d / +0xa9f no-card animation: frames, passes, interval   +0xaa3 + 16 i   +0xb93 rect
 *   sound / caption name lists (0x21 bytes each): +0xba3, +0xbc4, +0xbe5, +0xc06, +0xc2b + 0x21 i (13), +0xdd8 (5, and
 *   + 0x33d for the other player), +0xe7d (3), +0xee0 (2), +0xf22 (2), +0xf64 / +0xf66 words, +0xf68 + 0x21 i (13),
 *   +0x125f, +0x12a1
 *   +0x1304 win scene / +0x1306 draw scene (word, 9999 none) with cells +0x1308.. ; +0x131c / +0x131e event flag
 *   words; +0x1320 exit scene block; +0x1336 exit rectangle.
 * A scene block is: scene word (9999 = none), three words, three dwords, start-flag word.
 *
 * F6_OBJECT_FIELDS lists every modelled field of the singleton with its object offset, so a test can compare the
 * packed image (f6_object_pack) against the original bytes. Bytes outside the listed ranges are not modelled. */

#define F6_RUNTIME_TYPE UINT8_C(0xf6)
#define F6_BODY_BYTES 4934u
#define F6_NAME_BYTES 0x21u
#define F6_MAX_COLUMNS 13
#define F6_MAX_ROWS 3
#define F6_CARD_ROWS 4
#define F6_NO_SLOT (-1)
#define F6_NO_SCENE 9999
#define F6_NO_FLAG (-1)
#define F6_CANDIDATE_CARD 0x27ec   /* 0x45e1ca: a card of the human's hand is under the pointer (state 4 only) */
#define F6_CANDIDATE_BUTTON 0x27ed /* a column button is under the pointer (state 4, button mode) */
#define F6_CANDIDATE_EXIT 0x27ef   /* the exit rectangle is under the pointer */
#define F6_CURSOR_EXIT 9
#define F6_CURSOR_PICK 0x16
#define F6_RECORD_BYTES 0x31u      /* the sound record at obj+0x326 handed to 0x4fb77a */
#define F6_IMAGE_BYTES 0x3afu      /* packed object image (offsets as in the original) */
#define F6_MAX_BLITS 160
#define F6_TEXT_MAX 0x9c40u        /* longest caption text the original accepts (0x45e885) */

typedef enum F6Status {
    F6_OK = 0,
    F6_ERR_ARGUMENT = 1,
    F6_ERR_BODY = 2,
    F6_ERR_UNSUPPORTED = 3,
    F6_ERR_HOST = 4,
    F6_ERR_MEMORY = 5,
    F6_ERR_BOUNDS = 6,
    F6_ERR_STUCK = 7 /* a random-pick loop of the original did not end within F6_PICK_LIMIT draws (it would hang) */
} F6Status;

#define F6_PICK_LIMIT 100000

/* The process global phase 0 and 2 write (0x5bb1ca). */
typedef struct F6World {
    int32_t start_flag_5bb1ca;
} F6World;

/* The singleton at 0x61f4b1. Members carry their object offsets. Player 0 is the computer's first deal, player 1 the
 * human; card[p][r][c] = 1 when the player holds the card of suit row r and column c. */
typedef struct F6Object {
    int16_t slot;                       /* +0x1c generic Z entry, -1 none */
    int16_t row;                        /* +0x1e */
    uint32_t surface;                   /* +0x20 puzzle sheet handle, 0 none */
    int32_t card[2][F6_CARD_ROWS][F6_MAX_COLUMNS]; /* +0x24 + 0x120 p + 0x34 r + 4 c */
    int16_t count[2][F6_MAX_COLUMNS];   /* +0xf4 + 0x120 p + 2 c  cards held in column c */
    int32_t mark[2][F6_MAX_COLUMNS];    /* +0x10e + 0x120 p + 4 c  suit complete */
    int16_t score[2];                   /* +0x142 + 0x120 p */
    uint8_t deck[F6_CARD_ROWS][F6_MAX_COLUMNS]; /* +0x264 + 13 r + c  still in the deck */
    uint8_t redraw_298;                 /* +0x298 */
    uint8_t button_down;                /* +0x299 */
    int16_t selected;                   /* +0x29a column chosen */
    uint8_t deliver_29c;                /* +0x29c */
    uint8_t no_card_29d;                /* +0x29d */
    uint8_t clear_29e;                  /* +0x29e */
    int16_t anim_frame;                 /* +0x29f */
    uint8_t has_scores;                 /* +0x2a1 */
    uint8_t has_display;                /* +0x2a2 */
    uint8_t has_turn;                   /* +0x2a3 */
    int16_t player;                     /* +0x2a4 current player 0 / 1 */
    int16_t deck_left;                  /* +0x2a6 */
    uint8_t outcome_2a8;                /* +0x2a8 */
    uint8_t outcome_2a9;                /* +0x2a9 */
    uint8_t finished;                   /* +0x2aa */
    uint8_t flip_2ab;                   /* +0x2ab */
    uint8_t flip_2ac;                   /* +0x2ac */
    int32_t display[2][4];              /* +0x2ad + 16 i */
    int16_t display_count;              /* +0x2cd */
    int16_t delivery_step;              /* +0x2cf */
    int16_t blink;                      /* +0x2d1 */
    uint8_t slide_forward;              /* +0x2d3 */
    uint8_t slide_2d4;                  /* +0x2d4 */
    int16_t slide_step;                 /* +0x2d5 */
    int16_t slide_index;                /* +0x2d7 */
    int32_t after_slide;                /* +0x2d9 */
    int32_t slide_screen[2][4];         /* +0x2dd + 16 i  screen rectangle of the sliding card (render destination) */
    int32_t slide_sheet[2][4];          /* +0x2fd + 16 i  sheet rectangle (render source), moved by the slide */
    uint8_t active;                     /* +0x321 */
    uint8_t has_sound_a;                /* +0x322 */
    uint8_t has_sound_b;                /* +0x323 */
    uint8_t has_delivery;               /* +0x324 */
    uint8_t has_no_card;                /* +0x325 */
    uint8_t record[F6_RECORD_BYTES];    /* +0x326 sound record (name, channel word +0x347, ...) */
    int16_t card_row;                   /* +0x371 suit row found by 0x45e9db */
    int16_t channel;                    /* +0x373 */
    uint32_t deadline_state;            /* +0x375 */
    uint32_t deadline_anim;             /* +0x379 */
    int32_t interval;                   /* +0x37d */
    int16_t order_count;                /* +0x381 */
    int16_t order[F6_MAX_COLUMNS];      /* +0x383 */
    uint8_t exit_taken;                 /* +0x39d */
    int32_t state;                      /* +0x39e */
    int32_t next_state;                 /* +0x3a2 */
    int32_t wait_state;                 /* +0x3a6 */
    uint8_t caption_shown;              /* +0x3aa */
    uint8_t warned_3ab;                 /* +0x3ab */
    uint8_t picked_3ac;                 /* +0x3ac */
    uint8_t picked_3ad;                 /* +0x3ad */
    uint8_t has_exit;                   /* +0x3ae */
} F6Object;

typedef enum F6Effect {
    F6_FX_START_FLAG = 1,     /* 0x5bb1ca := a */
    F6_FX_CLEAR_ITEM = 2,     /* 0x4e8d96 */
    F6_FX_SLOT = 3,           /* 0x4d39f9 returned a */
    F6_FX_SLOT_REGISTER = 4,  /* type 10, callback 0x460f26, flags 0/0/1/1, label "MATCH PUZZLE OVERLAYS" */
    F6_FX_SURFACE_LOAD = 5,   /* 0x4c2790 returned a */
    F6_FX_SLOT_SURFACE = 6,   /* slot surface := a */
    F6_FX_SOUND_PREPARE = 7,  /* 0x4fb77a(record at obj+0x326) */
    F6_FX_SOUND_BUSY = 8,     /* 0x4f6334(channel a) returned b */
    F6_FX_SOUND_PLAY = 9,     /* 0x4fb2e3(channel a) */
    F6_FX_TICK = 10,          /* GetTickCount returned a */
    F6_FX_RAND = 11,          /* _rand returned a */
    F6_FX_AUTOTEXT = 12,      /* 0x423259 returned a != 0 */
    F6_FX_CAPTION = 13,       /* 0x448d11(text + "<e>"), a = text length */
    F6_FX_PHASE = 14,         /* row phase := a */
    F6_FX_XFER_5BB57B = 15,   /* dword := sign-extended scene word */
    F6_FX_XFER_5BB599 = 16,   /* word */
    F6_FX_XFER_5BB595 = 17,   /* word */
    F6_FX_XFER_5C39FF = 18,   /* word */
    F6_FX_XFER_5BB59B = 19,   /* dword */
    F6_FX_XFER_5BB59F = 20,   /* dword */
    F6_FX_XFER_5BB5A3 = 21,   /* dword */
    F6_FX_ENGINE_MODE = 22,   /* 0x583999 := 4 */
    F6_FX_EVENT_FLAG = 23,    /* dword [0x585801 + 4 * a] := b */
    F6_FX_COMPLETE = 24,      /* 0x42ba3a(row) */
    F6_FX_RELEASE_SURFACE = 25, /* 0x4c2dfb(&surface) */
    F6_FX_RELEASE_SLOT = 26,  /* 0x4d3992(a) */
    F6_FX_MARK_DIRTY = 27     /* 0x5d15a5 := 1 on slot a */
} F6Effect;

/* The scene-change cells of a finish block (the same shape as the 0x2e / 0xd1 arms). */
typedef struct F6Transition {
    int16_t scene;
    int16_t word[3];
    int32_t dword[3];
} F6Transition;

typedef struct F6Host {
    void *context;
    /* 0x4d39f9: first free generic Z entry in 0x18..0x3f. Zero on success. */
    int (*alloc_slot)(void *, int16_t *slot);
    /* Entry stores 0x5d1591..0x5d15b3: type 10, callback 0x460f26, surface (0 on a first visit), flags 0, 0, 1, 1,
     * word 0 and the label "MATCH PUZZLE OVERLAYS". */
    int (*register_slot)(void *, int16_t slot, const char *label);
    /* 0x4c2790("CIFTREE", name, 6, "CARD GAME Puzzle Surface"). */
    int (*load_surface)(void *, const char *name, uint32_t *surface);
    /* Entry surface store (0x5d1599). */
    int (*set_slot_surface)(void *, int16_t slot, uint32_t surface);
    /* 0x4c2dfb(&surface). */
    int (*release_surface)(void *, uint32_t surface);
    /* 0x4d3992: entry flags +0x14 and +0x18 := 0. */
    int (*release_slot)(void *, int16_t slot);
    /* 0x45dd96 / 0x5d15a5: entry +0x14 := 1 (redraw request). */
    int (*mark_dirty)(void *, int16_t slot);
    /* The view origin 0x583186 (x) / 0x58318a (y). */
    int (*view_origin)(void *, int32_t *x, int32_t *y);
    /* 0x4e8d96: commits the pending inventory item (phase 0 only). */
    int (*clear_pending_item)(void *);
    /* 0x4fb77a(ECX 0x5c3a67, obj+0x326): prepares the sound record built in the object (0x31 bytes). */
    int (*sound_prepare)(void *, const uint8_t *record);
    /* 0x4fb2e3(ECX 0x5c3a67, channel). */
    int (*sound_play)(void *, int16_t channel);
    /* 0x4f6334(ECX 0x5cf1eb, channel): the raw return value (only zero / nonzero matter). */
    int (*sound_busy)(void *, int16_t channel, int32_t *result);
    /* GetTickCount. */
    uint32_t (*tick)(void *);
    /* _rand (0x50cd50): 0..32767. */
    int32_t (*random)(void *);
    /* 0x423259(ECX 0x619a6b, key): the text of an AUTOTEXT key, or NULL when the key is not present. `*text` is
     * valid until the next call. Returns zero on success. */
    int (*autotext)(void *, const char *key, const char **text);
    /* 0x448d11(*0x5d03b3, text, -1, 0) on the caption object 0x619a05; `text` already ends with the "<e>" suffix. */
    int (*caption)(void *, const char *text, size_t length);
    /* Finish block: the scene-change cells and the engine mode := 4 as one request, then the event flag store. */
    int (*transition)(void *, const F6Transition *request);
    int (*store_event_flag)(void *, int16_t index, uint32_t value);
    /* Pure query for the finish block: nonzero when `index` is not a valid event flag. */
    int (*event_flag_invalid)(void *, int16_t index);
    /* Optional ordered effect observer (production may leave it NULL). */
    void (*observe)(void *, int effect, int32_t a, int32_t b);
} F6Host;

typedef struct F6Result {
    uint32_t phase_after;
    uint8_t initialized; /* phase 0 ran */
    uint8_t completed;   /* phase 2 ran 0x42ba3a: the executor applies the generic completion for the subtype */
} F6Result;

/* A power-on object: 0x45dc1a (reset 0x45dc8a) over zeroed storage. */
void f6_object_reset(F6Object *object);

/* Native safety check of a typed body. Not an original check: the original trusts the loader. Rejects a short body,
 * columns outside 1..13, rows outside 1..3, a negative deal count, and any name that is not NUL terminated within
 * its 0x21 bytes. */
int f6_validate_body(const uint8_t *body, size_t length, const char **failure);

/* Writes the object into `image` (F6_IMAGE_BYTES, the original offsets) and the modelled-byte mask (1 per byte
 * written). The sound record is written whole, the body pointer +0x31d and the header bytes are not modelled. */
void f6_object_pack(const F6Object *object, uint8_t image[F6_IMAGE_BYTES], uint8_t mask[F6_IMAGE_BYTES]);

/* One true-gate visit of 0x45f0e6. Validation precedes the first effect. A host failure after effects returns
 * F6_ERR_HOST (the original has no recovery); the session must stop. `failure` is optional. */
int f6_step(F6Object *object, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, F6World *world,
            const F6Host *host, F6Result *result, const char **failure);

typedef struct F6PointerResult {
    uint8_t hit;        /* 0x45e1ca return value */
    int32_t candidate;  /* 0x5c39e5 written by 0x45e4d4, -1 when nothing was written */
    uint8_t cursor;     /* 0x5b44f0 written by 0x45e4d4 (9 exit, 0x16 pick), 0 when nothing was written */
    uint8_t sprite;     /* 0x5d1631: 1 = 0x5b173c (exit), 2 = 0x5b18dc (pick), 0 nothing written */
} F6PointerResult;

/* 0x45e1ca with the 0x45e4d4 writes reported in `out` (the cells 0x5d1639 and 0x5b44f4 := 1 and 0x5d162d := 0x5d0377
 * accompany every hit). The original returns 0 without touching anything unless the object is active. */
int f6_pointer_move(F6Object *object, const uint8_t *body, size_t body_length, int16_t x, int16_t y,
                    F6PointerResult *out);

/* 0x45e587, run on an accepted release. `row_phase` is the row phase dword, `candidate` the retained 0x5c39e5.
 * `new_phase` receives the row phase afterwards (2 when the exit was taken). Returns F6_ERR_BOUNDS (before any effect)
 * when a button click names no column. */
int f6_click(F6Object *object, const uint8_t *body, size_t body_length, uint32_t row_phase, int32_t candidate,
             const F6Host *host, uint32_t *new_phase);

/* 0x45dd96. */
int f6_invalidate(F6Object *object, const F6Host *host);

/* 0x45dd4d: release the surface and the slot, then the 0x45dc8a reset. */
int f6_cleanup(F6Object *object, const F6Host *host);

/* 0x460f26: the blits of one render callback. `valid` is 0 when there is no render entry. The callback clears
 * redraw_298, clear_29e and flip_2ac exactly where the original does, so the object is not const. */
typedef enum F6BlitKind {
    F6_BLIT_RESTORE = 0,     /* 0x4c5377 from the background surface (Z entry 1, 0x5d15e3) */
    F6_BLIT_SHEET_OPAQUE = 1, /* 0x4c5377 from the puzzle sheet */
    F6_BLIT_SHEET_KEYED = 2   /* 0x4c5d4b (transparent colour) from the puzzle sheet */
} F6BlitKind;

typedef struct F6Blit {
    uint8_t kind;
    int32_t src[4]; /* view relative */
    int32_t dst[4]; /* view origin applied */
} F6Blit;

typedef struct F6RenderPlan {
    uint8_t valid;
    uint32_t surface;
    int32_t count;
    F6Blit blit[F6_MAX_BLITS];
} F6RenderPlan;

int f6_render_plan(F6Object *object, const uint8_t *body, size_t body_length, const F6Host *host, F6RenderPlan *plan);

#ifdef __cplusplus
}
#endif
#endif
