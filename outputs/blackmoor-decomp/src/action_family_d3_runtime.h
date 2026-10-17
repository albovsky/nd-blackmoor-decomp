#ifndef BLACKMOOR_ACTION_FAMILY_D3_RUNTIME_H
#define BLACKMOOR_ACTION_FAMILY_D3_RUNTIME_H

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

/* Runtime of raw 0xd3, the Collision Puzzle (RT-53; surface "Collision Puzzle Surface", z entry label "COLLISION PUZZLE
 * OVERLAYS": a grid of up to 8 x 8 cells; pieces slide cell by cell in one direction until a barrier or another piece
 * stops them, and the puzzle is solved when every piece rests on the cell type that equals its number).
 *
 * Original code (GAME.EXE, SHA-256 afd337a2...5c45), confirmed in the disassembly:
 *   0x427a50  dispatcher arm 0xd3 (0x42a210): gate 0x423f57(deps, 0), then the thiscall handler 0x463392(ECX = 0x61d779, row).
 *             The object (CCollisionPuzzle) is one static singleton; the grid lives in process globals (0x594db3).
 *   0x461903  loader (0x410484): copies the 855-byte typed body into a fresh row allocation (pData at
 *             0x5bb5e5 + row * 0x8d); src/action_family_d3.[ch] decodes it.
 *   0x463392  the handler: a phase switch on the row phase dword (0x5bb632 + row * 0x8d). Phase 0 init, phase 1 an inner
 *             state machine on obj+0x24 (0..4), phase 2 finish (generic completion 0x42ba3a, then the cleanup 0x461862).
 *   0x462577  one-time grid setup (flag byte 0x594db3), 0x4618df grid reset (0x438471 and phase 0 when body byte 0x21 is 0),
 *             0x462b84 cell rectangle.
 *   0x462c39  pointer hit test (the cascade 0x4f0059 at 0x4f0b96, x = [event+0x5e], y = [event+0x5a], view relative);
 *             0x4630a3 the cursor / candidate writer, 0x4619be the move check (can the piece continue in a direction).
 *   0x4631d1  click handler (the accepted-release chain, 0x43b2a0).
 *   0x461d82  one animation step of a moving piece, 0x461d4b a cell type test, 0x4632bf the solved scan.
 *   0x463b10  the render callback of the dynamic generic z entry (type 10, label above), blits through 0x4c5d4b / 0x4c5377.
 *   0x4618ab  slot invalidate (0x43d910).  0x461862 / 0x461827  cleanup (0x438b8f, 0x43de84) and reset.
 *
 * Typed body, offsets from the start of the 855-byte body (words and dwords signed; a rectangle is four dwords left, top,
 * right, bottom; hit bounds are inclusive):
 *   +0x000 NUL-terminated name of the puzzle surface image (CIFTREE), 0x21 bytes (loaded even when empty)
 *   +0x021 byte: 0 resets the persistent grid at phase 0
 *   +0x022 word R (rows, first grid index a, 0..8)   +0x024 word C (columns, second grid index b, 0..8)
 *   +0x026 word P (pieces, 0..10)
 *   +0x028 + 16*a + 2*b  word cell type of (a, b): 0 empty, 1..10 target of piece n, 0x10 / 0x13 left / right edge arrow,
 *          0x11 / 0x12 top / bottom edge arrow, 0x14 wall
 *   +0x0a8 + 4*k word column b, +0x0aa + 4*k word row a of the start cell of piece k + 1
 *   +0x0d0 + 16*k  source rectangle of piece k + 1 (k < 10); +0x0d8 - +0x0d0 and +0x0dc - +0x0d4 give the cell size
 *   +0x170 + 16*t  source rectangle of the target overlay for type t + 1 (drawn only when right != left)
 *   +0x210 horizontal arrow source (types 0x10 / 0x13)   +0x220 vertical arrow source (0x11 / 0x12)
 *   +0x230 wall source (type 0x14, drawn only when right != left)
 *   +0x240 dword x origin  +0x244 dword y origin  +0x248 word gap between cells  +0x24a word animation steps per cell (>= 1)
 *   +0x24f sound record A (move sound, "NO SOUND\0" none), +0x270 word channel A
 *   +0x280 sound record B (a piece stops on an empty cell type), +0x2a1 word channel B
 *   +0x2b1 sound record C (a piece stops on another cell type), +0x2d2 word channel C
 *   +0x2e2 solved scene block: scene word (9999 none) +0x2e2, words +0x2e4 +0x2e6 +0x2e8, dwords +0x2ea +0x2ee +0x2f2,
 *          start-flag word +0x2f6 (== 1 stores 0, anything else stores 1), event flag index word +0x2f8 (-1 none),
 *          value byte +0x2fa
 *   +0x2fb word delay in seconds before the final sound
 *   +0x2fd sound record D (final sound), +0x31e word channel D
 *   +0x32e cancel scene block (same shape: scene, three words, three dwords, start-flag word +0x342, flag index word
 *          +0x344, value byte +0x346)
 *   +0x347 left, +0x34b top, +0x34f right, +0x353 bottom: cancel rectangle (inclusive)
 *
 * Every engine call whose body lies outside this slice is a callback of CpzHost in the original order. Nothing here claims
 * original source structure. */

#define CPZ_RUNTIME_TYPE UINT8_C(0xd3)
#define CPZ_BODY_BYTES 855u
#define CPZ_NAME_BYTES 0x21u
#define CPZ_SOUND_BYTES 0x21u
#define CPZ_GRID_MAX 8
#define CPZ_PIECES_MAX 10
#define CPZ_NO_SLOT (-1)
#define CPZ_NO_SCENE 9999
#define CPZ_NO_FLAG (-1)
#define CPZ_CANDIDATE_CANCEL 0x277f /* 0x4630a3: the cancel rectangle is under the pointer */
#define CPZ_CANDIDATE_LEFT 0x2780   /* a piece can slide left, up, down, right */
#define CPZ_CANDIDATE_UP 0x2781
#define CPZ_CANDIDATE_DOWN 0x2782
#define CPZ_CANDIDATE_RIGHT 0x2783
#define CPZ_CURSOR_CANCEL 9
#define CPZ_MAX_BLITS 192

/* Body offsets the host receives (the `record` arguments are pointers into the body). */
#define CPZ_OFFSET_SOUND_A 0x24fu
#define CPZ_OFFSET_SOUND_B 0x280u
#define CPZ_OFFSET_SOUND_C 0x2b1u
#define CPZ_OFFSET_SOUND_D 0x2fdu

/* Directions (obj+0x57, the word of the move check) and cell types. */
enum {
    CPZ_DIR_NONE = 0,
    CPZ_DIR_LEFT = 0x10,  /* column b - 1 */
    CPZ_DIR_UP = 0x11,    /* row a - 1 */
    CPZ_DIR_DOWN = 0x12,  /* row a + 1 */
    CPZ_DIR_RIGHT = 0x13, /* column b + 1 */
    CPZ_CELL_WALL = 0x14
};

/* Handler states (obj+0x24). */
enum {
    CPZ_STATE_IDLE = 0,    /* wait for a click; checks whether the puzzle is solved */
    CPZ_STATE_SOLVED = 1,  /* solved: start the delay */
    CPZ_STATE_MOVING = 2,  /* a piece slides, one animation step per tick */
    CPZ_STATE_WAIT_SOUND = 3,
    CPZ_STATE_WAIT_DELAY = 4
};

typedef enum CpzStatus {
    CPZ_OK = 0,
    CPZ_ERR_ARGUMENT = 1,
    CPZ_ERR_BODY = 2,
    CPZ_ERR_UNSUPPORTED = 3,
    CPZ_ERR_HOST = 4,
    CPZ_ERR_BOUNDS = 5
} CpzStatus;

/* One grid cell (40 bytes at 0x594db5 + 0x140 * a + 0x28 * b). */
typedef struct CpzCell {
    int32_t visible;  /* +0x00 the cell is drawn */
    int32_t base[4];  /* +0x04 overlay rectangle (target, arrow, wall), view origin included */
    int32_t rect[4];  /* +0x14 rectangle of the piece standing here, view origin included */
    int16_t type;     /* +0x24 */
    int16_t piece;    /* +0x26 piece number standing here, 0 none */
} CpzCell;

/* The process globals the handler reads and writes: the start flag 0x5bb1ca and the persistent grid (flag byte 0x594db3
 * and 0x594db5..). */
typedef struct CpzWorld {
    int32_t start_flag_5bb1ca;
    uint8_t grid_ready;
    CpzCell cell[CPZ_GRID_MAX][CPZ_GRID_MAX];
} CpzWorld;

/* The singleton at 0x61d779. Offsets are object offsets. `at_row` / `at_col` are the cell of the piece being moved. */
typedef struct CpzObject {
    int16_t slot;        /* +0x1c generic z entry, -1 none */
    int16_t row;         /* +0x1e */
    uint32_t surface;    /* +0x20 puzzle image handle, 0 none */
    int32_t state;       /* +0x24 */
    uint8_t flag28;      /* +0x28 set to 1 by phase 0, never read */
    int32_t saved[4];    /* +0x29 rectangle the moving piece left (restore background), view origin included */
    int16_t piece;       /* +0x39 number of the piece under the pointer / moving, 0 none */
    int32_t moved;       /* +0x3b a move finished in this tick: the render restores the background */
    int32_t active;      /* +0x3f */
    int32_t canceled;    /* +0x43 */
    int32_t solved;      /* +0x47 */
    uint32_t deadline;   /* +0x4b GetTickCount deadline */
    int32_t cell_w;      /* +0x4f cell width: body +0xd8 - +0xd0 */
    int32_t cell_h;      /* +0x53 cell height: body +0xdc - +0xd4 */
    int16_t dir;         /* +0x57 direction of the pending / running move */
    int16_t step;        /* +0x59 animation steps done in the current cell */
    int16_t at_row;      /* +0x5b */
    int16_t at_col;      /* +0x5d */
} CpzObject;

typedef enum CpzEffect {
    CPZ_FX_ACTIVE = 1,        /* +0x3f := 1 */
    CPZ_FX_START_FLAG = 2,    /* 0x5bb1ca := a */
    CPZ_FX_GRID_RESET = 3,    /* 0x4618df */
    CPZ_FX_CLEAR_ITEM = 4,    /* 0x4e8d96 */
    CPZ_FX_GRID_SETUP = 5,    /* 0x462577 entry, a = 1 when the one-time setup ran */
    CPZ_FX_SLOT = 6,          /* 0x4d39f9 returned a */
    CPZ_FX_SLOT_REGISTER = 7, /* type 10, callback 0x463b10, flags 0/0/1/1, label */
    CPZ_FX_SURFACE_LOAD = 8,  /* 0x4c2790 returned a */
    CPZ_FX_SLOT_SURFACE = 9,  /* slot surface := b (slot a) */
    CPZ_FX_PHASE = 10,        /* row phase := a */
    CPZ_FX_STATE = 11,        /* +0x24 := a */
    CPZ_FX_SOUND_PREPARE = 12,/* 0x4fb77a(body + a) */
    CPZ_FX_SOUND_STOP = 13,   /* 0x4fba69(body + a) */
    CPZ_FX_SOUND_PLAY = 14,   /* 0x4fb2e3(channel a) */
    CPZ_FX_SOUND_BUSY = 15,   /* 0x4f6334(channel a) returned b */
    CPZ_FX_TICK = 16,         /* GetTickCount returned a */
    CPZ_FX_XFER_5BB57B = 17,  /* dword := sign-extended scene word */
    CPZ_FX_XFER_5BB599 = 18,  /* word */
    CPZ_FX_XFER_5BB595 = 19,  /* word */
    CPZ_FX_XFER_5C39FF = 20,  /* word */
    CPZ_FX_XFER_5BB59B = 21,  /* dword */
    CPZ_FX_XFER_5BB59F = 22,  /* dword */
    CPZ_FX_XFER_5BB5A3 = 23,  /* dword */
    CPZ_FX_ENGINE_MODE = 24,  /* 0x583999 := 4 */
    CPZ_FX_EVENT_FLAG = 25,   /* dword [0x585801 + 4 * a] := b */
    CPZ_FX_COMPLETE = 26,     /* 0x42ba3a(row) */
    CPZ_FX_RELEASE_SURFACE = 27, /* 0x4c2dfb(&surface), the handle held was a */
    CPZ_FX_RELEASE_SLOT = 28, /* 0x4d3992(a) */
    CPZ_FX_BLIT = 29          /* 0x4c5d4b / 0x4c5377, blit kind a (CpzBlitKind) for the cell with piece number b */
} CpzEffect;

/* The scene-change cells of a finish block (the same shape as the 0x2e arm). */
typedef struct CpzTransition {
    int16_t scene;
    int16_t word[3];
    int32_t dword[3];
} CpzTransition;

typedef struct CpzHost {
    void *context;
    /* 0x4d39f9: first free generic z entry in 0x18..0x3f. Zero on success. */
    int (*alloc_slot)(void *, int16_t *slot);
    /* Entry stores 0x5d1591..0x5d15b3: type 10, callback 0x463b10, surface 0, flags 0, 0, 1, 1, word 0 and the label
     * "COLLISION PUZZLE OVERLAYS". */
    int (*register_slot)(void *, int16_t slot, const char *label);
    /* 0x4c2790("CIFTREE", name, 6, "Collision Puzzle Surface"). */
    int (*load_surface)(void *, const char *name, uint32_t *surface);
    /* Entry surface store (0x5d1599). */
    int (*set_slot_surface)(void *, int16_t slot, uint32_t surface);
    /* 0x4c2dfb(&surface). */
    int (*release_surface)(void *, uint32_t surface);
    /* 0x4d3992: entry flags +0x14 and +0x18 := 0. */
    int (*release_slot)(void *, int16_t slot);
    /* 0x4618ab: entry +0x14 := 1 (redraw request). */
    int (*mark_dirty)(void *, int16_t slot);
    /* The view origin 0x583186 (x) / 0x58318a (y). */
    int (*view_origin)(void *, int32_t *x, int32_t *y);
    /* 0x4e8d96: commits the pending inventory item (phase 0 only). */
    int (*clear_pending_item)(void *);
    /* 0x4fb77a / 0x4fba69 on the sound record embedded in the body (offsets above). */
    int (*sound_prepare)(void *, const uint8_t *record);
    int (*sound_stop)(void *, const uint8_t *record);
    /* 0x4fb2e3(channel). */
    int (*sound_play)(void *, int16_t channel);
    /* 0x4f6334(channel): the raw return value (0 or 1 on the paths the handler reaches). */
    int (*sound_busy)(void *, int16_t channel, int32_t *result);
    /* GetTickCount. */
    uint32_t (*tick)(void *);
    /* Pure query for the finish block: nonzero when `index` is not a valid event flag. */
    int (*event_flag_invalid)(void *, int16_t index);
    /* Finish block: the scene-change cells and the engine mode := 4 as one request, then the event flag store. */
    int (*transition)(void *, const CpzTransition *request);
    int (*store_event_flag)(void *, int16_t index, uint32_t value);
    /* Optional ordered effect observer (production may leave it NULL). */
    void (*observe)(void *, int effect, int32_t a, int32_t b);
} CpzHost;

typedef struct CpzResult {
    uint32_t phase_after;
    uint8_t initialized; /* phase 0 ran */
    uint8_t completed;   /* phase 2 ran 0x42ba3a: the executor applies the generic completion for the subtype */
} CpzResult;

/* A power-on object: 0x461827 (slot -1, row -1, inactive, not canceled, not solved) over zeroed storage. */
void cpz_object_reset(CpzObject *object);

/* 0x4618df: clears the one-time setup flag and the whole cell array (the new-game reset 0x438471 calls it too). */
void cpz_grid_reset(CpzWorld *world);

/* Native safety check of a typed body. Not an original check: the original trusts the loader. Rejects a short body, a name
 * or sound name without NUL in its 0x21 bytes, R or C outside 0..8, P outside 0..10 (the original indexes past the grid
 * and the piece tables) and an animation step count below 1 (the original divides by it). `failure` is optional. */
int cpz_validate_body(const uint8_t *body, size_t length, const char **failure);

/* One true-gate visit of 0x463392. Validation precedes the first effect. A host failure after effects returns CPZ_ERR_HOST
 * (the original has no recovery); the session must stop. Phase 1 or 2 on an object that phase 0 did not initialise for `row`
 * returns CPZ_ERR_UNSUPPORTED before any effect. `failure` is optional. */
int cpz_step(CpzObject *object, const uint8_t *body, size_t body_length, int16_t row, uint32_t phase, CpzWorld *world,
             const CpzHost *host, CpzResult *result, const char **failure);

typedef struct CpzPointerResult {
    uint8_t hit;          /* 0x462c39 return value (1 = the cascade stops here) */
    int32_t candidate;    /* 0x5c39e5 written by 0x4630a3 (0x277f..0x2783), -1 when nothing was written */
    uint8_t cursor_written; /* 0x4630a3 wrote the cursor cells */
    int32_t cursor_kind;  /* 0x5b44f0: 9 for the cancel rectangle, 0x19 left, 0x17 up, 0x18 down, 0x1a right */
    int32_t cursor_sub;   /* 0x5b44f4 (1) */
} CpzPointerResult;

/* 0x462c39 at view-relative (x, y), both taken as signed 16-bit words; `view_x` / `view_y` are 0x583186 / 0x58318a. While
 * `active` is 0 or a move runs nothing happens. Scans the cells in order; a cell with a piece claims the pointer when the
 * point lies in the edge zone (a quarter of the cell width on the left and right, half the height on top and bottom, in
 * the order up, right, down, left) of a direction the piece can move in. Changes the object (piece, position, direction)
 * exactly as the original does, including the move check's side effects. Inclusive bounds. */
int cpz_pointer(CpzObject *object, const CpzWorld *world, const uint8_t *body, size_t body_length, int32_t x, int32_t y,
                int32_t view_x, int32_t view_y, CpzPointerResult *out);

typedef struct CpzClickResult {
    uint8_t cancel_asked; /* candidate 0x277f: canceled := 1 and the row phase becomes 2 */
    uint8_t move_started; /* state became MOVING */
    uint8_t sound_played; /* 0x4fb2e3 was issued */
    uint32_t new_phase;   /* the row phase afterwards (== row_phase unless cancel_asked) */
} CpzClickResult;

/* 0x4631d1, run on an accepted release with the retained candidate 0x5c39e5 and the process flag 0x5bb1ca (`start_flag`).
 * Nothing happens unless active && !solved && state == IDLE && row_phase == 1. */
int cpz_click(CpzObject *object, const uint8_t *body, size_t body_length, uint32_t row_phase, int32_t candidate,
              int32_t start_flag, const CpzHost *host, CpzClickResult *out);

/* 0x4618ab. */
int cpz_invalidate(CpzObject *object, const CpzHost *host);

/* 0x461862: release the surface and the slot, then the 0x461827 reset. */
int cpz_cleanup(CpzObject *object, const CpzHost *host);

/* 0x463b10: one render callback. It reports the blits the host must perform, in order. It changes nothing. */
typedef enum CpzBlitKind {
    CPZ_BLIT_TARGET = 1,    /* "Collision Puzzle Piece Overlays": cell type 1..10 */
    CPZ_BLIT_ARROW_H = 2,   /* "Collision Puzzle Overlays": cell type 0x10 / 0x13 */
    CPZ_BLIT_ARROW_V = 3,   /* "Collision Puzzle Overlays": cell type 0x11 / 0x12 */
    CPZ_BLIT_WALL = 4,      /* "Collision Puzzle Overlays": cell type 0x14 */
    CPZ_BLIT_RESTORE = 5,   /* "restore background" over the rectangle the moving piece left */
    CPZ_BLIT_PIECE = 6      /* "Collision Puzzle Overlays": the piece standing in the cell */
} CpzBlitKind;

typedef struct CpzBlit {
    int32_t kind;         /* CpzBlitKind */
    int32_t piece;        /* piece number standing in the cell (kinds 5 and 6), else 0 */
    uint32_t src_surface; /* the puzzle surface (all kinds but RESTORE) or 0 = the host's generic entry 1 surface (0x5d15e3) */
    int32_t src[4];       /* left top right bottom: the body rectangle, or for RESTORE the saved rectangle minus the view origin */
    int32_t dst[4];       /* the cell rectangle (base or piece), or for RESTORE the saved rectangle */
} CpzBlit;

typedef struct CpzRenderResult {
    uint8_t valid;        /* 0 when the callback is never called (no slot) */
    uint16_t count;
    CpzBlit blit[CPZ_MAX_BLITS];
} CpzRenderResult;

int cpz_render(const CpzObject *object, const CpzWorld *world, const uint8_t *body, size_t body_length,
               const CpzHost *host, CpzRenderResult *out);

#ifdef __cplusplus
}
#endif
#endif
