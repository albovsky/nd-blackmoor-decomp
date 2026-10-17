#ifndef BLACKMOOR_ACTION_FAMILY_F5_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_F5_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#include "score_time_display.h"

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0xf5, the Typing Quiz Puzzle (RT-55; surface "Typing Quiz Puzzle Data Surface", z entry label "TYPING QUIZ
 * PUZZLE OVERLAYS"): balloons carrying a character float on screen; the player types the character to pop the balloon;
 * a score (hits per minute) and a clock are drawn by the shared score / time display (src/score_time_display.[ch]); when
 * the time is up the score decides between the passed and the normal exit.
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x427a50  dispatcher arm 0xf5: gate 0x423f57(deps, 0), then the thiscall handler 0x4b8e92(ECX = 0x61ee6e, row).
 *             The object (CTypingQuiz) is one static singleton.
 *   0x4b80d9  loader (0x4109ce): copies the 1390-byte typed body into a fresh row allocation (src/action_family_f5.[ch]).
 *   0x4b8e92  the handler: a phase switch on the row phase dword (0x5bb632 + row * 0x8d). Phase 0 init, phase 1 an inner
 *             state machine on obj+0x10 (0 play, 1 time up, 2 wait for the end delay), phase 2 finish.
 *   0x4b832c  clock update, 0x4b8d5e balloon expiry, 0x4b844d score recompute, 0x4b8783 first balloon wave,
 *   0x4b8a27  further balloons after a balloon went away, 0x4b866e free position pick, 0x4b85f6 / 0x4b8520 character pick.
 *   0x4b8193  key method (called from the character message handler 0x437e92; the character filter is 0x437ea1).
 *   0x4b81ff  pointer test (the cascade 0x4f0059), 0x4b82cd click (accepted release chain), 0x4b80a5 invalidate,
 *   0x4b7ff4  cleanup (+ reset 0x4b7f3b), 0x4b8087 new-game reset of 0x5a4c0a / 0x5a4c0e,
 *   0x4b9a88  the render callback of the dynamic generic z entry (type 10).
 *
 * Typed body, offsets from the start of the 1390-byte body (words signed; a rectangle is four dwords left, top, right,
 * bottom):
 *   +0x000 NUL-terminated name of the puzzle surface image (CIFTREE), 0x21 bytes
 *   +0x021 word V (balloon graphic variants, 1..20)   +0x023 + 16*k source rectangle of variant k
 *   +0x163 source rectangle of a popped balloon       +0x173 word N (balloon positions, 1..20)
 *   +0x175 + 16*c destination rectangle of position c (view origin is added when a balloon is placed)
 *   +0x2b5 ten digit rectangles of the score display  +0x355 ten digit rectangles of the clock display
 *   +0x3f5 colon rectangle of the clock               +0x405 / +0x409 / +0x415 score display x, y, digit gap
 *   +0x40d / +0x411 / +0x419 clock display x, y, digit gap   +0x41d rectangle of the "passed" message
 *   +0x42d dword end delay (ms)   +0x431 byte case sensitive   +0x432 byte digits allowed
 *   +0x433 byte (nonzero: characters up to 0xff) +0x434 30 extra accepted characters (first byte nonzero: up to 0x7f)
 *   +0x452 / +0x454 words min / max balloon lifetime (s)   +0x456 / +0x458 words min / max balloons on screen
 *   +0x45a word time limit (s)   +0x45c word score factor   +0x45e word minimum score   +0x460 word default target
 *   +0x462 word target percent of the best earlier score   +0x464 word lowest target
 *   +0x466 sound record A (start; stopped at the end)   +0x487 word channel hit   +0x497 sound record B
 *   +0x4b8 word channel miss   +0x4c8 sound record C   +0x4e9 word channel balloon timed out
 *   +0x4f9 passed scene block: scene word (9999 none) +0x4f9, words +0x4fb +0x4fd +0x4ff, dwords +0x501 +0x505 +0x509,
 *          start-flag word +0x50d (== 1 stores 0, else 1), event flag word +0x50f (-1 none)
 *   +0x511 sound record D (passed; stopped at the end)   +0x532 word channel D
 *   +0x542 normal scene block: scene word +0x542, words +0x544 +0x546 +0x548, dwords +0x54a +0x54e +0x552, start-flag word
 *          +0x556, event flag word +0x558 (taken when the minimum score was reached), event flag word +0x55a (otherwise)
 *   +0x55c word cursor kind   +0x55e left, +0x562 top, +0x566 right, +0x56a bottom: pointer rectangle (inclusive)
 *
 * Every engine call whose body lies outside this slice is a callback of TqzHost in the original order. Nothing here claims
 * original source structure. */

#define TQZ_RUNTIME_TYPE UINT8_C(0xf5)
#define TQZ_BODY_BYTES 1390u
#define TQZ_NAME_BYTES 0x21u
#define TQZ_SOUND_BYTES 0x21u
#define TQZ_BALLOONS 20
#define TQZ_NO_SLOT (-1)
#define TQZ_NO_SCENE 9999
#define TQZ_NO_FLAG (-1)
#define TQZ_CANDIDATE 0x27eb /* 0x4b81ff writes this to 0x5c39e5 */
#define TQZ_FONT_SURFACE 10  /* 0x4c924d / 0x4c92c5 argument */
#define TQZ_MAX_BLITS 192
#define TQZ_PICK_LIMIT 100000u /* draws of one random pick loop before the kernel reports TQZ_ERR_STUCK */

/* Body offsets the host receives. */
#define TQZ_OFFSET_SOUND_A 0x466u
#define TQZ_OFFSET_SOUND_B 0x497u
#define TQZ_OFFSET_SOUND_C 0x4c8u
#define TQZ_OFFSET_SOUND_D 0x511u

/* Balloon states (entry + 0x33). */
enum { TQZ_BALLOON_FREE = 0, TQZ_BALLOON_FLYING = 1, TQZ_BALLOON_POPPING = 2, TQZ_BALLOON_GONE = 3 };

/* Handler states (obj+0x10). */
enum { TQZ_STATE_PLAY = 0, TQZ_STATE_TIME_UP = 1, TQZ_STATE_WAIT_END = 2 };

/* z entry render callbacks handed to register_slot (the score / clock ones are STD_CALLBACK_*). */
enum { TQZ_CALLBACK_QUIZ = 1 };

typedef enum TqzStatus {
    TQZ_OK = 0,
    TQZ_ERR_ARGUMENT = 1,
    TQZ_ERR_BODY = 2,
    TQZ_ERR_UNSUPPORTED = 3,
    TQZ_ERR_HOST = 4,
    TQZ_ERR_BOUNDS = 5,
    TQZ_ERR_STUCK = 6
} TqzStatus;

/* One balloon (55 bytes at obj+0x4a + 0x37 * k, unaligned fields). */
typedef struct TqzBalloon {
    int32_t src[4];     /* +0x00 variant rectangle copied from the body */
    int32_t dst[4];     /* +0x10 placed rectangle, view origin included */
    uint8_t ch;         /* +0x20 the character to type */
    int32_t text_x;     /* +0x21 */
    int32_t text_y;     /* +0x25 */
    uint32_t deadline;  /* +0x29 GetTickCount value at which a popping balloon is gone */
    uint32_t spawn;     /* +0x2d GetTickCount value when the balloon appeared */
    int16_t lifetime;   /* +0x31 seconds */
    int32_t state;      /* +0x33 TQZ_BALLOON_* */
} TqzBalloon;

/* The process globals the handler reads and writes besides the display widget. */
typedef struct TqzWorld {
    int32_t start_flag_5bb1ca;
    int32_t played_5a4c0a;  /* dword, set by phase 0, cleared by the new-game reset 0x4b8087 */
    int16_t best_5a4c0e;    /* word: the score of the last finished run */
    StdDisplay display;     /* 0x638603 */
} TqzWorld;

/* The singleton at 0x61ee6e. Offsets are object offsets. */
typedef struct TqzObject {
    int16_t slot;           /* +0x04 generic z entry, -1 none */
    int16_t row;            /* +0x06 */
    uint32_t surface;       /* +0x0c puzzle image handle, 0 none */
    int32_t state;          /* +0x10 */
    int32_t active;         /* +0x14 */
    int32_t passed;         /* +0x18 the target score was reached */
    int32_t reached;        /* +0x1c the minimum score was reached */
    int32_t finishing;      /* +0x20 */
    int32_t flag34;         /* +0x34 the render erases the background once */
    int16_t count;          /* +0x48 balloons that should be on screen */
    TqzBalloon balloon[TQZ_BALLOONS]; /* +0x4a */
    uint8_t key_char;       /* +0x636 */
    int32_t key_pending;    /* +0x637 */
    int16_t max_char;       /* +0x63b */
    uint32_t end_deadline;  /* +0x63d */
    int16_t target;         /* +0x641 */
    int32_t minutes;        /* +0x626 */
    int32_t seconds;        /* +0x62a */
    uint32_t start_tick;    /* +0x62e */
    uint32_t elapsed;       /* +0x632 milliseconds */
    int32_t hits;           /* +0x54e */
    int32_t score;          /* +0x552 */
    int32_t prev_score;     /* +0x556 */
    int32_t dword55a;       /* +0x55a zeroed by the reset, never read */
    int32_t score_block[0x2e]; /* +0x496 (see StdDisplay.score_block) */
    int32_t clock_block[0x32]; /* +0x55e (see StdDisplay.clock_block) */
} TqzObject;

typedef enum TqzEffect {
    TQZ_FX_ACTIVE = 1,        /* +0x14 := 1 */
    TQZ_FX_START_FLAG = 2,    /* 0x5bb1ca := a */
    TQZ_FX_CLEAR_ITEM = 3,    /* 0x4e8d96 */
    TQZ_FX_SLOT = 4,          /* 0x4d39f9 returned a (call 1: the quiz entry, 2: the score entry, 3: the clock entry) */
    TQZ_FX_SLOT_REGISTER = 5, /* quiz entry stores: type 10, callback 0x4b9a88, surface 0, flags 0/0/1/1, label */
    TQZ_FX_SURFACE_LOAD = 6,  /* 0x4c2790 returned a */
    TQZ_FX_SLOT_SURFACE = 7,  /* slot surface := b (slot a) */
    TQZ_FX_SOUND_PREPARE = 8, /* 0x4fb77a(body + a) */
    TQZ_FX_SOUND_STOP = 9,    /* 0x4fba69(body + a) */
    TQZ_FX_SOUND_PLAY = 10,   /* 0x4fb2e3(channel a) */
    TQZ_FX_TICK = 11,         /* GetTickCount returned a */
    TQZ_FX_RANDOM = 12,       /* _rand returned a */
    TQZ_FX_PHASE = 13,        /* row phase := a */
    TQZ_FX_STATE = 14,        /* +0x10 := a */
    TQZ_FX_XFER_5BB57B = 15,  /* dword := sign-extended scene word */
    TQZ_FX_XFER_5BB599 = 16,  /* word */
    TQZ_FX_XFER_5BB595 = 17,  /* word */
    TQZ_FX_XFER_5C39FF = 18,  /* word */
    TQZ_FX_XFER_5BB59B = 19,  /* dword */
    TQZ_FX_XFER_5BB59F = 20,  /* dword */
    TQZ_FX_XFER_5BB5A3 = 21,  /* dword */
    TQZ_FX_ENGINE_MODE = 22,  /* 0x583999 := 4 */
    TQZ_FX_EVENT_FLAG = 23,   /* dword [0x585801 + 4 * a] := b */
    TQZ_FX_COMPLETE = 24,     /* 0x42ba3a(row) */
    TQZ_FX_RELEASE_SURFACE = 25, /* 0x4c2dfb(&surface), the handle held was a */
    TQZ_FX_RELEASE_SLOT = 26, /* 0x4d3992(a) */
    TQZ_FX_FONT_ACQUIRE = 27, /* 0x4c924d(10) */
    TQZ_FX_FONT_RELEASE = 28, /* 0x4c92c5(10) */
    TQZ_FX_SET_SCORE = 29,    /* 0x44655e(a) */
    TQZ_FX_SET_CLOCK = 30,    /* 0x446598(a, b) */
    TQZ_FX_ENABLE_SCORE = 31, /* 0x446532(a) */
    TQZ_FX_ENABLE_CLOCK = 32, /* 0x446548(a) */
    TQZ_FX_RESET_DISPLAY = 33, /* 0x445f53 + 0x445fc5 */
    TQZ_FX_PLAYED_FLAG = 34,  /* 0x5a4c0a := a */
    TQZ_FX_BEST_SCORE = 35,   /* 0x5a4c0e := a */
    TQZ_FX_BLIT = 36          /* render: blit kind a, index b */
} TqzEffect;

/* The scene-change cells of a finish block. */
typedef struct TqzTransition {
    int16_t scene;
    int16_t word[3];
    int32_t dword[3];
} TqzTransition;

typedef struct TqzHost {
    void *context;
    /* 0x4d39f9: first free generic z entry in 0x18..0x3f. Zero on success. */
    int (*alloc_slot)(void *, int16_t *slot);
    /* Entry stores 0x5d1591..0x5d15b3: type, render callback (TQZ_CALLBACK_* / STD_CALLBACK_*), surface, flags 0 / 0 / 1 / 1,
     * word 0 and the label. Used for the quiz entry and (through the display) for the score and clock entries. */
    int (*register_slot)(void *, int16_t slot, int32_t type, int callback, uint32_t surface, const char *label);
    /* 0x4c2790("CIFTREE", name, 6, "Typing Quiz Puzzle Data Surface"). */
    int (*load_surface)(void *, const char *name, uint32_t *surface);
    /* Entry surface store (0x5d1599). */
    int (*set_slot_surface)(void *, int16_t slot, uint32_t surface);
    /* 0x4c2dfb(&surface). */
    int (*release_surface)(void *, uint32_t surface);
    /* 0x4d3992: entry flags +0x14 and +0x18 := 0. */
    int (*release_slot)(void *, int16_t slot);
    /* 0x4b80a5: entry +0x14 := 1 (redraw request). */
    int (*mark_dirty)(void *, int16_t slot);
    /* The view rectangle 0x583186 (left top right bottom) and the view-relative rectangle 0x583196. */
    int (*view_rects)(void *, int32_t absolute[4], int32_t local[4]);
    /* 0x4e8d96: commits the pending inventory item (phase 0 only). */
    int (*clear_pending_item)(void *);
    /* 0x4c924d(10) / 0x4c92c5(10): reference counted font surface. */
    int (*font_acquire)(void *);
    int (*font_release)(void *);
    /* 0x4fb77a / 0x4fba69 on the sound record embedded in the body. */
    int (*sound_prepare)(void *, const uint8_t *record);
    int (*sound_stop)(void *, const uint8_t *record);
    /* 0x4fb2e3(channel). */
    int (*sound_play)(void *, int16_t channel);
    /* GetTickCount. */
    uint32_t (*tick)(void *);
    /* _rand (0x50cd50): 0..32767. */
    int32_t (*random)(void *);
    /* Pure query for the finish block: nonzero when `index` is not a valid event flag. */
    int (*event_flag_invalid)(void *, int16_t index);
    /* Finish block: the seven scene-change cells as one request, then (after the start flag and the event flag store) the
     * engine mode := 4 (0x583999). */
    int (*transition)(void *, const TqzTransition *request);
    int (*store_event_flag)(void *, int16_t index, uint32_t value);
    int (*engine_mode)(void *, int32_t mode);
    /* Optional ordered effect observer (production may leave it NULL). */
    void (*observe)(void *, int effect, int32_t a, int32_t b);
} TqzHost;

typedef struct TqzResult {
    uint32_t phase_after;
    uint8_t initialized; /* phase 0 ran */
    uint8_t completed;   /* phase 2 ran 0x42ba3a: the executor applies the generic completion for the subtype */
} TqzResult;

/* A power-on object: 0x4b7f3b over zeroed storage (slot -1, row -1, clock slot -1, score slot -1). */
void tqz_object_reset(TqzObject *object);

/* 0x4b8087: the new-game reset of 0x5a4c0a / 0x5a4c0e. */
void tqz_world_new_game(TqzWorld *world);

/* 0x437ea1: the characters the character message handler hands to the key method. */
int tqz_key_filter(int8_t ch);

/* Native safety check of a typed body. Not an original check: the original trusts the loader. Rejects a short body, a name
 * or sound name without NUL in its 0x21 bytes, V or N outside 1..20 (the original takes random numbers modulo them and
 * indexes 20 balloons), a balloon count range with minimum above maximum, below 0 or above 20, and a lifetime range with
 * minimum above maximum (modulo zero or a negative count). `failure` is optional. */
int tqz_validate_body(const uint8_t *body, size_t length, const char **failure);

/* One true-gate visit of 0x4b8e92. Validation precedes the first effect. A host failure after effects returns TQZ_ERR_HOST
 * (the original has no recovery); the session must stop. Phase 1 or 2 on an object that phase 0 did not initialise for `row`
 * returns TQZ_ERR_UNSUPPORTED before any effect. `failure` is optional. */
int tqz_step(TqzObject *object, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, TqzWorld *world,
             const TqzHost *host, TqzResult *result, const char **failure);

/* 0x4b8193: a typed character (already filtered by 0x437ea1 in the original; this applies the filter too and returns 0
 * for a refused character). `row_phase` is the dword at 0x5bb632 + row * 0x8d. Returns 1 when the character was stored. */
int tqz_key(TqzObject *object, uint32_t row_phase, int8_t ch);

typedef struct TqzPointerResult {
    uint8_t hit;          /* 0x4b81ff return value (1 = the cascade stops here) */
    int32_t candidate;    /* 0x5c39e5 written (TQZ_CANDIDATE), -1 when nothing was written */
    int32_t cursor_kind;  /* 0x5b44f0: the body word +0x55c */
    int32_t cursor_sub;   /* 0x5b44f4 (1) */
} TqzPointerResult;

/* 0x4b81ff at (x, y), both taken as signed 16-bit words. Inclusive bounds. */
int tqz_pointer(const TqzObject *object, const uint8_t *body, size_t body_length, int32_t x, int32_t y,
                TqzPointerResult *out);

/* 0x4b82cd, run on an accepted release with the retained candidate 0x5c39e5. Returns 1 when the row phase became 2. */
int tqz_click(const TqzObject *object, uint32_t row_phase, int32_t candidate, uint32_t *new_phase);

/* 0x4b80a5. */
int tqz_invalidate(const TqzObject *object, const TqzHost *host);

/* 0x4b7ff4: release the surface and the slots, the font, then the 0x4b7f3b reset. */
int tqz_cleanup(TqzObject *object, TqzWorld *world, const TqzHost *host);

/* Render callbacks (0x4b9a88, 0x446688, 0x4468fe). Each reports the blits the host must perform in order; the quiz render
 * also changes the object (popping balloons go away, new balloons appear, the background is erased once). */
typedef enum TqzBlitKind {
    TQZ_BLIT_BALLOON = 101,        /* 0x4c5d4b "Typing Quiz Character" (0x551e54): a flying balloon, a = index */
    TQZ_BLIT_TEXT = 102,           /* 0x4d2c20: the character a at (b, c), text surface and colours are the host's */
    TQZ_BLIT_POP = 103,            /* 0x4c5d4b "Typing Quiz Character" (0x551e6c): a popping balloon (body +0x163), a = index */
    TQZ_BLIT_BALLOON_ERASE = 104,  /* 0x4c5377 "Typing Quiz balloon Erase" (0x551e84), a = index */
    TQZ_BLIT_BACKGROUND_ERASE = 105, /* 0x4c5377 "TYPING PUZZLE Background Erase" (0x551ea0): src 0x583196, dst 0x583186 */
    TQZ_BLIT_PASSED = 106          /* 0x4c5d4b "Typing Puzzle Passed Msg" (0x551ec0) */
} TqzBlitKind;

typedef struct TqzRenderResult {
    uint8_t valid;        /* 0 when the callback does nothing (inactive) */
    uint16_t count;
    StdBlit blit[TQZ_MAX_BLITS];
} TqzRenderResult;

int tqz_render(TqzObject *object, TqzWorld *world, const uint8_t *body, size_t body_length, const TqzHost *host,
               TqzRenderResult *out);
int tqz_render_score(TqzWorld *world, const TqzHost *host, TqzRenderResult *out);
int tqz_render_clock(TqzWorld *world, const TqzHost *host, TqzRenderResult *out);

#ifdef __cplusplus
}
#endif
#endif
