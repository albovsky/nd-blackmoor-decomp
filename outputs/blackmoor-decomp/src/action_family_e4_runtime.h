#ifndef BLACKMOOR_ACTION_FAMILY_E4_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_E4_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0xe4, the Match Puzzle (RT-54; surface "Match Puzzle Surface", z entry label "MATCH PUZZLE OVERLAYS": a
 * board of coloured glyph pieces, a score, an optional countdown and a target score; the player swaps two pieces and every
 * run of three or more equal pieces in a row or column scores and refills).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x427a50  dispatcher arm 0xe4 (0x42a3e9): gate 0x423f57(deps, 0), then the thiscall handler 0x476a25(ECX = 0x622fa2, row).
 *             The object (CMatchPuzzle, 0x8da bytes) is one static singleton.
 *   0x475964  loader (0x40b34a, 0x4105f0): copies the 2034-byte typed body into a fresh row allocation (pData at
 *             0x5bb5e5 + row * 0x8d); src/action_family_e4.[ch] decodes it.
 *   0x476a25  the handler: a phase switch on the row phase dword (0x5bb632 + row * 0x8d). Phase 0 init, phase 1 an inner
 *             state machine on obj+0x2c (0..6, jump table 0x4778b3), phase 2 finish (scene block, generic completion
 *             0x42ba3a, then the cleanup 0x475885).
 *   0x475a1e  board fill (all cells, or one cell) with 0x475bef (cell rectangle).   0x4763b3  CheckForMatch.
 *   0x475da4  pointer hit test (the cascade 0x4f0059 at 0x4f0c36, x = [event+0x5e], y = [event+0x5a], view relative); the
 *             candidate/cursor writer 0x475fb1.
 *   0x47608e  click method (called unconditionally on the accepted-release chain at 0x43b2cd; it guards itself).
 *   0x4778df  the render callback of the dynamic generic z entry (type 10, label above), text helper 0x475cc4.
 *   0x4758e8  slot invalidate (0x43d98d).  0x475885 / 0x4757da  cleanup (0x43deb1, 0x438be4) and reset.
 *   0x47591f  scene reset of the high score table (0x4384a8): 0x5a0545 and the five dwords at 0x5a0549 := 0.
 *
 * Typed body, offsets from the start of the 2034-byte body (words and dwords signed; a rectangle is four dwords left, top,
 * right, bottom; hit tests are inclusive):
 *   +0x000 name of the puzzle surface (CIFTREE, 0x21 bytes, NUL-terminated)   +0x021 name of the score surface ("" none)
 *   +0x042 word rows (board height)  +0x044 word columns  +0x046 word piece kinds (the fill draws kinds 0..kinds-2)
 *   +0x048 source rectangle of the shuffle button pressed
 *   +0x058 + 16*k piece source rectangles (30 kinds)
 *   +0x238 byte piece-name panel enabled   +0x23a word font index   +0x23c word font parameter   +0x23e title text (0x21)
 *   +0x25f + 0x21*k piece names (35 slots)
 *   +0x63d byte score panel enabled   +0x63e word time limit in seconds (0 none)   +0x640 dword target score
 *   +0x644 word score per matched piece   +0x646 source rectangle of a matched piece
 *   +0x656 word time bonus (seconds) of a three-run, +0x658 word score and +0x65a time bonus of a four-run, +0x65c and +0x65e
 *          of a five-run
 *   +0x660 word board x offset, +0x662 y offset, +0x664 y gap, +0x666 x gap
 *   +0x668 title rect, +0x678 shuffle button rect, +0x688 target score rect, +0x698 score rect, +0x6a8 time rect,
 *   +0x6b8 piece-name rect, +0x6c8 piece icon rect
 *   +0x6d8 / +0x6dc / +0x6e0 / +0x6e4 dwords: high score screen anchors   +0x6e8 word seconds shown before the high scores
 *   +0x6ea sound record A (match sound, 0x21 name + channel word at +0x70b)   +0x71b B (shuffle, channel +0x73c)
 *   +0x74c C (piece click, channel +0x76d)   +0x77d win scene block   +0x796 word seconds before the end sound
 *   +0x798 D (end sound, channel +0x7b9)   +0x7c9 exit scene block   +0x7e2 exit button rect
 * A scene block is: scene word (9999 none), words +2 +4 +6, dwords +8 +12 +16, start-flag word +20 (== 1 stores 0, anything
 * else stores 1), event flag index word +22 (-1 none), value byte +24.
 *
 * Every engine call whose body lies outside this slice is a callback of E4rHost in the original order. Nothing here claims
 * original source structure. The debug flag 0x63a4cd is taken as 0 (the log calls are skipped). */

#define E4R_RUNTIME_TYPE UINT8_C(0xe4)
#define E4R_BODY_BYTES 2034u
#define E4R_OBJECT_BYTES 0x8dau
#define E4R_NAME_BYTES 0x21u
#define E4R_MAX_ROWS 10
#define E4R_MAX_COLS 10
#define E4R_MAX_KINDS 30
#define E4R_MIN_KINDS 4 /* the fill draws kinds 0..kinds-2 and avoids two neighbours: fewer than three values can never finish */
#define E4R_MAX_FONT 17
#define E4R_NO_SLOT (-1)
#define E4R_NO_SCENE 9999
#define E4R_NO_FLAG (-1)
#define E4R_HIGH_SCORES 5
#define E4R_CANDIDATE_PIECE 0x27d5   /* 0x475fb1: a board piece is under the pointer */
#define E4R_CANDIDATE_EXIT 0x27d6    /* the exit button */
#define E4R_CANDIDATE_SHUFFLE 0x27d7 /* the shuffle button */
#define E4R_MAX_OPS 160

/* Body offsets the host receives (sound `record` arguments are pointers into the body). */
#define E4R_OFFSET_SOUND_A 0x6eau
#define E4R_OFFSET_SOUND_B 0x71bu
#define E4R_OFFSET_SOUND_C 0x74cu
#define E4R_OFFSET_SOUND_D 0x798u

/* Object offsets from 0x622fa2 (bytes +0x00..+0x1b hold the vtable and constructor leftovers and are never touched). */
enum {
    E4R_O_WON = 0x1c,         /* dword: the target score was reached */
    E4R_O_SLOT = 0x20,        /* word: generic z entry, -1 none */
    E4R_O_ROW = 0x22,         /* word: scene row, -1 none */
    E4R_O_SURFACE = 0x24,     /* dword: puzzle image handle */
    E4R_O_SCORE_SURFACE = 0x28, /* dword: score image handle */
    E4R_O_STATE = 0x2c,       /* dword: handler state 0..6 */
    E4R_O_CELLS = 0x30,       /* 10 rows of 200 bytes, 10 cells of 20 bytes: +0 present, +1 matched, +2 word kind, +4 rect */
    E4R_O_SHOW_NAME = 0x800,  /* byte */
    E4R_O_SCORE_DIRTY = 0x801,/* byte */
    E4R_O_ERASE_ALL = 0x802,  /* byte: the next render erases the whole view first */
    E4R_O_NAME_DIRTY = 0x803, /* byte */
    E4R_O_NAME_TEXT = 0x804,  /* 0x21 bytes: piece name shown */
    E4R_O_ICON_RECT = 0x825,  /* 16 bytes: source rectangle of the piece icon shown */
    E4R_O_SCORE_TEXT = 0x835, /* 0x21 bytes */
    E4R_O_TIME_TEXT = 0x856,  /* 0x21 bytes */
    E4R_O_TARGET_TEXT = 0x877,/* 0x21 bytes */
    E4R_O_SHUFFLE_DOWN = 0x898, /* byte */
    E4R_O_SHUFFLE_DIRTY = 0x899, /* byte */
    E4R_O_ACTIVE = 0x89a,     /* dword */
    E4R_O_EXIT = 0x89e,       /* dword: the exit button was taken */
    E4R_O_DEADLINE = 0x8a2,   /* dword: tick deadline of the current state */
    E4R_O_SEL_COL = 0x8a6,    /* dword: selected piece column */
    E4R_O_SEL_ROW = 0x8aa,    /* dword */
    E4R_O_SWAP_COL = 0x8ae,   /* dword: second piece of the last swap */
    E4R_O_SWAP_ROW = 0x8b2,   /* dword */
    E4R_O_NO_SELECTION = 0x8b6, /* dword: 1 when no piece is selected */
    E4R_O_HOVER_COL = 0x8ba,  /* dword: piece under the pointer */
    E4R_O_HOVER_ROW = 0x8be,  /* dword */
    E4R_O_SCORE = 0x8c2,      /* dword */
    E4R_O_TIME_END = 0x8c6,   /* dword: tick at which the countdown ends */
    E4R_O_SHUFFLE_END = 0x8ca,/* dword: tick at which a shuffle completes */
    E4R_O_RUN_ROW_MIN = 0x8ce,/* words: the runs found by the last CheckForMatch */
    E4R_O_RUN_ROW_MAX = 0x8d0,
    E4R_O_RUN_COL_MIN = 0x8d2,
    E4R_O_RUN_COL_MAX = 0x8d4,
    E4R_O_MATCH_COL = 0x8d6,  /* byte: a run along the column was found */
    E4R_O_MATCH_ROW = 0x8d7,  /* byte: a run along the row was found */
    E4R_O_CHECK_FIRST = 0x8d8,/* byte: the selected piece is to be checked */
    E4R_O_CHECK_SECOND = 0x8d9/* byte: the swapped piece is to be checked */
};

enum {
    E4R_STATE_PLAY = 0,       /* pieces can be swapped; the countdown runs */
    E4R_STATE_END = 1,        /* the end sound starts */
    E4R_STATE_REFILL = 2,     /* matched pieces are shown until the deadline and the match sound has finished, then refilled */
    E4R_STATE_SHUFFLE = 3,    /* the shuffle button is shown pressed until the deadline, then the whole board is refilled */
    E4R_STATE_END_SOUND = 4,  /* waits for the end sound to finish */
    E4R_STATE_END_WAIT = 5,   /* waits the delay in seconds before the end sound is checked */
    E4R_STATE_SCORES = 6      /* the high score screen */
};

typedef struct E4rObject {
    uint8_t b[E4R_OBJECT_BYTES];
} E4rObject;

typedef enum E4rStatus {
    E4R_OK = 0,
    E4R_ERR_ARGUMENT = 1,
    E4R_ERR_BODY = 2,
    E4R_ERR_UNSUPPORTED = 3,
    E4R_ERR_HOST = 4,
    E4R_ERR_BOUNDS = 5
} E4rStatus;

/* The process globals the handler reads and writes: the start flag 0x5bb1ca and the high score table 0x5a0549 (five signed
 * dwords, best first) with its companion dword 0x5a0545. */
typedef struct E4rWorld {
    int32_t start_flag_5bb1ca;
    int32_t high_score_marker_5a0545;
    int32_t high_score[E4R_HIGH_SCORES];
} E4rWorld;

typedef enum E4rEffect {
    E4R_FX_START_FLAG = 1,      /* 0x5bb1ca := a */
    E4R_FX_AMBIENT_STOP = 2,    /* 0x4e8d96: commits the pending inventory item (named AMBIENT for historical reasons) */
    E4R_FX_RAND = 3,            /* 0x50cd50 returned a */
    E4R_FX_SLOT = 4,            /* 0x4d39f9 returned a */
    E4R_FX_SLOT_REGISTER = 5,   /* type 10, callback 0x4778df, flags 0/0/1/1, label (slot a) */
    E4R_FX_SURFACE_LOAD = 6,    /* 0x4c2790 of kind a (0 puzzle, 1 score) returned b */
    E4R_FX_SLOT_SURFACE = 7,    /* slot surface := b (slot a) */
    E4R_FX_PHASE = 8,           /* row phase := a */
    E4R_FX_SOUND_PREPARE = 9,   /* 0x4fb77a(body + a) */
    E4R_FX_SOUND_STOP = 10,     /* 0x4fba69(body + a) */
    E4R_FX_SOUND_PLAY = 11,     /* 0x4fb2e3(channel a) */
    E4R_FX_SOUND_BUSY = 12,     /* 0x4f6334(channel a) returned b */
    E4R_FX_TICK = 13,           /* GetTickCount returned a */
    E4R_FX_XFER_5BB57B = 14,    /* dword := sign-extended scene word */
    E4R_FX_XFER_5BB599 = 15,    /* word */
    E4R_FX_XFER_5BB595 = 16,    /* word */
    E4R_FX_XFER_5C39FF = 17,    /* word */
    E4R_FX_XFER_5BB59B = 18,    /* dword */
    E4R_FX_XFER_5BB59F = 19,    /* dword */
    E4R_FX_XFER_5BB5A3 = 20,    /* dword */
    E4R_FX_ENGINE_MODE = 21,    /* 0x583999 := 4 */
    E4R_FX_EVENT_FLAG = 22,     /* dword [0x585801 + 4 * a] := b */
    E4R_FX_FONT_RELEASE = 23,   /* 0x4c92c5(font a) */
    E4R_FX_COMPLETE = 24,       /* 0x42ba3a(row a) */
    E4R_FX_RELEASE_SURFACE = 25,/* 0x4c2dfb(&surface), the handle held was a */
    E4R_FX_RELEASE_SLOT = 26,   /* 0x4d3992(a) */
    E4R_FX_MARK_DIRTY = 27,     /* entry +0x14 := 1 (slot a) */
    E4R_FX_TEXT_EXTENT = 28     /* 0x4d3836("T", font a) returned b */
} E4rEffect;

/* The scene-change cells of a finish block (the same shape as the 0x2e arm). */
typedef struct E4rTransition {
    int16_t scene;
    int16_t word[3];
    int32_t dword[3];
} E4rTransition;

typedef struct E4rHost {
    void *context;
    /* 0x4d39f9: first free generic z entry in 0x18..0x3f. Zero on success. */
    int (*alloc_slot)(void *, int16_t *slot);
    /* Entry stores 0x5d1591..0x5d15b3: type 10, callback 0x4778df, surface 0, flags 0, 0, 1, 1, word 0 and the label
     * "MATCH PUZZLE OVERLAYS". */
    int (*register_slot)(void *, int16_t slot, const char *label);
    /* 0x4c2790("CIFTREE", name, 6, label): kind 0 = puzzle surface (label "Match Puzzle Surface"), kind 1 = score surface
     * (label "Score Surface"). */
    int (*load_surface)(void *, int kind, const char *name, uint32_t *surface);
    /* Entry surface store (0x5d1599). */
    int (*set_slot_surface)(void *, int16_t slot, uint32_t surface);
    /* 0x4c2dfb(&surface). */
    int (*release_surface)(void *, uint32_t surface);
    /* 0x4d3992: entry flags +0x14 and +0x18 := 0. */
    int (*release_slot)(void *, int16_t slot);
    /* Entry +0x14 := 1 (redraw request). */
    int (*mark_dirty)(void *, int16_t slot);
    /* The view rectangle 0x583186 (left, top, right, bottom) and the full-screen rectangle 0x583196 that follows it. */
    int (*view_rects)(void *, int32_t view[4], int32_t full[4]);
    /* 0x4fb77a / 0x4fba69 on the sound record embedded in the body. */
    int (*sound_prepare)(void *, const uint8_t *record);
    int (*sound_stop)(void *, const uint8_t *record);
    /* 0x4fb2e3(channel). */
    int (*sound_play)(void *, int16_t channel);
    /* 0x4f6334(channel): the raw return value (0 or nonzero). */
    int (*sound_busy)(void *, int16_t channel, int32_t *result);
    /* GetTickCount. */
    uint32_t (*tick)(void *);
    /* 0x50cd50 (CRT rand): a value in 0..32767. */
    int (*random)(void *, int32_t *value);
    /* 0x4e8d96: commits the pending inventory item (phase 0 only; the identifier stop_ambient is a misnomer). */
    int (*stop_ambient)(void *);
    /* 0x4c92c5(font): drops one reference of the font image. */
    int (*font_release)(void *, int16_t font);
    /* 0x4d3836("T", font tables): the text height measure of the high score screen. */
    int (*text_extent)(void *, int16_t font, int16_t *height);
    /* Pure query for the finish block: nonzero when `index` is not a valid event flag. */
    int (*event_flag_invalid)(void *, int16_t index);
    /* Finish block: the scene-change cells and the engine mode := 4 as one request, then the event flag store. */
    int (*transition)(void *, const E4rTransition *request);
    int (*store_event_flag)(void *, int16_t index, uint32_t value);
    /* Optional ordered effect observer (production may leave it NULL). */
    void (*observe)(void *, int effect, int32_t a, int32_t b);
} E4rHost;

typedef struct E4rResult {
    uint32_t phase_after;
    uint8_t initialized; /* phase 0 ran */
    uint8_t completed;   /* phase 2 ran 0x42ba3a: the executor applies the generic completion for the subtype */
} E4rResult;

/* A power-on object: zeroed storage with the 0x4757da stores (slot -1, row -1, inactive, empty board). */
void e4r_object_reset(E4rObject *object);

/* 0x47591f: the high score table back to zero (the scene entry path). */
void e4r_scene_reset(E4rWorld *world);

/* Native safety check of a typed body. Not an original check: the original trusts the loader. Rejects a short or long body,
 * rows or columns outside 1..10, kinds outside 4..30, a font index outside 0..17, and any name, title, piece name (for the
 * used kinds) or sound record name without NUL in its 0x21 bytes. `failure` is optional. */
int e4r_validate_body(const uint8_t *body, size_t length, const char **failure);

/* One true-gate visit of 0x476a25. Validation precedes the first effect. A host failure after effects returns E4R_ERR_HOST
 * (the original has no recovery); the session must stop. Phase 1 or 2 on an object that phase 0 did not initialise for `row`
 * returns E4R_ERR_UNSUPPORTED before any effect; so does a board index or piece kind outside the board in the object.
 * `failure` is optional. */
int e4r_step(E4rObject *object, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, E4rWorld *world,
             const E4rHost *host, E4rResult *result, const char **failure);

typedef struct E4rPointerResult {
    uint8_t hit;            /* 0x475da4 return value (1 = the cascade stops here) */
    int32_t candidate;      /* 0x5c39e5 written by 0x475fb1, -1 when nothing was written */
    uint8_t cursor_written; /* 0x475fb1 wrote the cursor cells */
    int32_t cursor_kind;    /* 0x5b44f0 (9 for the exit button, 0x16 for a piece and the shuffle button) */
    int32_t cursor_sub;     /* 0x5b44f4 (1) */
} E4rPointerResult;

/* 0x475da4 at view-relative (x, y), both taken as signed 16-bit words. Nothing happens unless active and the state is not
 * REFILL. A hit on a piece also stores its row and column in obj+0x8be / obj+0x8ba. */
int e4r_pointer(E4rObject *object, const uint8_t *body, size_t body_length, int32_t x, int32_t y, E4rPointerResult *out);

typedef struct E4rClickResult {
    uint8_t fired;        /* the guard held */
    uint8_t sound_played; /* 0x4fb2e3 was issued */
    uint8_t phase_changed;/* the exit button stored the row phase */
    uint32_t phase;       /* the phase stored when phase_changed (2) */
} E4rClickResult;

/* 0x47608e, run on an accepted release with the row phase and the candidate 0x5c39e5 (`candidate`). Nothing happens unless
 * active && !won && state == PLAY && no check pending && row_phase == 1. */
int e4r_click(E4rObject *object, const uint8_t *body, size_t body_length, uint32_t row_phase, int32_t candidate,
              const E4rHost *host, E4rClickResult *out);

/* 0x4758e8. */
int e4r_invalidate(E4rObject *object, const E4rHost *host);

/* 0x475885: release the surfaces and the slot, then the 0x4757da reset. */
int e4r_cleanup(E4rObject *object, const E4rHost *host);

typedef enum E4rOpKind {
    E4R_OP_BLIT = 1, /* 0x4c5377 */
    E4R_OP_TEXT = 2  /* 0x4c924d(font) then 0x4d2c20 */
} E4rOpKind;

typedef enum E4rLabel {
    E4R_LABEL_ERASE_ALL = 1,       /* "MATCH PUZZLE Entire Background Erase" 0x54c9b0 */
    E4R_LABEL_PIECE = 2,           /* "Match Puzzle Overlays" 0x54c9d8 */
    E4R_LABEL_MATCHED = 3,         /* "Match Puzzle Overlays" 0x54c9f0 */
    E4R_LABEL_NAME_ICON = 4,       /* "Matching Piece" 0x54ca08 (icon drawn from the puzzle surface) */
    E4R_LABEL_NAME_ERASE = 5,      /* "MATCH PUZZLE Sring Background Erase" 0x54ca18 */
    E4R_LABEL_ICON_ERASE = 6,      /* "Matching Piece" 0x54ca3c (icon area erased from the background) */
    E4R_LABEL_SCORE_ERASE = 7,     /* "MATCH PUZZLE Score Background Erase" 0x54ca4c */
    E4R_LABEL_TIME_ERASE = 8,      /* "MATCH PUZZLE Time Left" 0x54ca70 */
    E4R_LABEL_SHUFFLE_DOWN = 9,    /* "MatchPuz Shuffle Button Down" 0x54ca88 (pressed graphic) */
    E4R_LABEL_SHUFFLE_ERASE = 10,  /* "MatchPuz Shuffle Button Down" 0x54caa8 (area erased from the background) */
    E4R_LABEL_SCORES_BACKDROP = 11 /* "MATCH PUZZLE blt with score background" 0x54cac8 */
} E4rLabel;

typedef enum E4rSurfaceRole {
    E4R_SURFACE_PUZZLE = 1,     /* the generic entry's surface (obj+0x24) */
    E4R_SURFACE_BACKGROUND = 2, /* the host's generic entry 1 surface (0x5d15e3) */
    E4R_SURFACE_SCORE = 3       /* obj+0x28 */
} E4rSurfaceRole;

typedef struct E4rOp {
    int32_t kind;         /* E4rOpKind */
    int32_t label;        /* E4rLabel (blits) */
    int32_t surface_role; /* E4rSurfaceRole (blits) */
    int32_t src[4];       /* blit source rectangle contents */
    int32_t dst[4];       /* blit destination rectangle contents (the view origin already added) */
    char text[E4R_NAME_BYTES + 1]; /* text drawn */
    int16_t font;         /* 0x23a */
    int16_t param;        /* 0x23c */
    int16_t x;            /* rect.left + view x, truncated to a word */
    int16_t y;            /* rect.bottom + view y, truncated to a word */
} E4rOp;

typedef struct E4rRenderResult {
    uint8_t valid; /* 0 when the callback does nothing (no row) */
    uint16_t count;
    E4rOp op[E4R_MAX_OPS];
} E4rRenderResult;

/* 0x4778df: one render callback. It changes the object (dirty flags) as the original does and reports the blits and texts
 * the host must perform, in order. A piece kind outside 0..kinds-1 returns E4R_ERR_BOUNDS before any change. */
int e4r_render(E4rObject *object, const uint8_t *body, size_t body_length, const E4rWorld *world, const E4rHost *host,
               E4rRenderResult *out);

static inline int16_t e4r_rd16(const E4rObject *o, size_t off)
{
    return (int16_t)(uint16_t)(o->b[off] | (o->b[off + 1] << 8));
}

static inline int32_t e4r_rd32(const E4rObject *o, size_t off)
{
    return (int32_t)((uint32_t)o->b[off] | ((uint32_t)o->b[off + 1] << 8) | ((uint32_t)o->b[off + 2] << 16) |
                     ((uint32_t)o->b[off + 3] << 24));
}

#ifdef __cplusplus
}
#endif
#endif
